package trinity.engine {
	import flash.utils.Timer;
	import trinity.utils.callFunc;
	/**
	 * ...
	 * @author KingFo (telds kingfo)
	 */
	public class Engine implements IReceiver {
		
		public static const HANDER:String = 'receive';
		
		public function get cache():ChannelCache {
			return _cache;
		}
		/**
		 * 当节点链接的时候回调
		 */
		public var onConnected:Function;
		/**
		 * 当成为 master 节点的时候回调
		 */
		public var onMaster:Function;
		/**
		 * 当发送消息成功的时候回调
		 */
		public var onSended:Function;
		/**
		 * 当发送消息失败的时候回调
		 */
		public var onError:Function;
		/**
		 * 当接收到指令执行时的回调
		 */
		public var onExecution:Function;
		/**
		 * 当接收到消息的时候回调
		 */
		public var onReceived:Function;
		
		/**
		 * 返回当前组名
		 * @return
		 */
		public function getGroup():String {
			return this.group;
		}
		
		public function Engine(group:String, rate:Number = 1000) {
			this.group = group.indexOf('_') == 0 ? group : '_' + group;
			
			breath = new Breath(rate);
			breath.onTimer = onTimer;
			
			kernel = new Kernel(HANDER, this);
			kernel.onMaster = masterHandler;
			kernel.onConnected = connectedHandler;
		}
		
		/**
		 * 链接
		 * @return
		 */
		public function connect():void {
			kernel.connect(group);
		}
		/**
		 * 关闭链接
		 */
		public function close():void {
			kernel.close();
		}
		/**
		 * 获取状态
		 *     当 1 时为 master 状态
		 *     当 0 时为 非 master 状态
		 *     当 -1 时则未启动链接
		 * @return
		 */
		public function getStatus():int {
			return kernel.name ? kernel.isMaster ? 1: 0 : -1;
		}
		/**
		 * 获取当前节点名字
		 *     当节点获取到 master 资源 或者 被关闭的时候 name 会发生改变
		 *     这与当前节点的状态有关
		 * @return
		 */
		public function getName():String {
			return kernel.name;
		}
		/**
		 * 对所有节点进行广播
		 * @param	data
		 * @param	to
		 */
		public function fire(data:*,to:String = null ):void {
			var request:ExchangeData = createRequest(ExchangeDataType.MESSAGE);
			if (kernel.isMaster) {
				if (!to) { // 广播
					broadcast(request);
					return;
				}
				// 单播
				request.to = to;
				send(request, onCallback);
				return;
			}
			
			forward(request); // 转发
			
		}
		/**
		 * 公开的接收其他节点的方法
		 * @param	request
		 */
		public function receive(request:*):void {
			if (!request) return;
			switch(request.type) {
				case ExchangeDataType.SNIFFING: // 仅用于 Master
					return;
					break;
				case ExchangeDataType.MESSAGE: 
					if (request.to == kernel.name) {
						callFunc(onReceived, request);
					}else if(request.to == null) {
						broadcast(request);
					}else {
						forward(request);
					}
					break;
				case ExchangeDataType.REGISTRATION: // 仅用于 Master
					request.getway = kernel.name;
					cache.addChannel(request.from,request.getway); 
					break;
				case ExchangeDataType.EXECUTION:
					if(kernel.isMaster)callFunc(onExecution, request.body);
					break;
				case ExchangeDataType.FORWARD: // 仅用于 Master
					arguments.callee(request.body);
					break;
				case ExchangeDataType.EXIT: // 仅用于 Master
					cache.removeChannel(request.body);
					break;
			}
		}
		/**
		 * 广播消息 以下 2 种情况会被触发
		 * 	   当 fire 时 to 为 null 会触发
		 *     当 receive 到 to 为 null 会触发 
		 * @param	request
		 */
		public function broadcast(request:*):void {
			var list:Array = cache.getSubnets(request.getway), i:int, len:int = list.length;
			for (i = 0; i < len; i++ ) {
				request.to = list[i];
				send(request, onCallback);
			}
		}
		/**
		 * 转发消息
		 *     对当前的 ExchangeData 进行再次封装成为 ExchangeData
		 * @param	request
		 */
		public function forward(request:*):void {
			var req:ExchangeData = createRequest(ExchangeDataType.FORWARD);
			req.to = request.to || group;
			req.body = request; //外面包一层
			send(req, onCallback);
		}
		
		public function createRequest(type:Number):ExchangeData {
			var request:ExchangeData = new ExchangeData();
			request.from = kernel.name;
			request.getway = group;
			request.type = type;
			return request;
		}
		
		public function exit():void {
			if (kernel.isMaster) {
				kernel.close();
			}else {
				notifyExit(group,kernel.name);
			}
		}
		
		public function notifyExit(masterName:String,from:String = null):void {
			var request:ExchangeData = createRequest(ExchangeDataType.EXIT);
			request.to = masterName;
			request.from = kernel.name; 
			request.body = from;
			send(request, onCallback);
		}
		
		
		private function masterHandler(name:String):void {
			breath.stop();
			cache.addChannel(name);
			callFunc(onMaster, name);
			trace('I M MASTER!');
		}
		
		private function connectedHandler(...args):void {
			var a:Array = args.concat();
			a.unshift(onConnected);
			callFunc.apply(this, a);
			if (!kernel.isMaster) {
				register();
				breath.start();
			}
			
		}
		
		protected function onCallback(type:String,msg:String,request:*):void {
			switch(type) {
				case 'status':
					// 消息 发送成功
						if(request.type == ExchangeDataType.MESSAGE)callFunc(onSended, type, msg, request);
					break;
				case 'error':
					// 消息 发送失败
						if (request.type == ExchangeDataType.MESSAGE) callFunc(onError, type, msg, request);
						
						if ((request.getway && request.getway != group) || 
							(!kernel.isMaster && request.to != group)) {
							notifyExit(request.getway, request.to);
							return;
						}
						
						if (kernel.isMaster) {
							cache.removeChannel(request.to);
							return;
						}
						
						connect();
						break;
			}
		}
		
		private function onTimer(timer:Timer):void {
			var a:Array = cache.getSubnets(group) || [];
			breath.check(a.length);
			var request:ExchangeData = new ExchangeData(group);
			request.type = ExchangeDataType.SNIFFING;
			trace('SNIFFING');
			send(request, onCallback);
			
		}
		
		private function register():void {
			var request:ExchangeData = new ExchangeData(group);
			request.type = ExchangeDataType.REGISTRATION;
			request.from = kernel.name;
			request.getway = group;
			trace('REGISTRATION');
			send(request, onCallback);
		}
		
		
		private function send(request:ExchangeData, callback:Function):void {
			breath.later();
			kernel.send(request.to, request, callback);
		}
		
		
		private var _cache:ChannelCache = new ChannelCache();
		private var _isRunning:Boolean = false;
		
		private var group:String;
		private var kernel:Kernel;
		private var breath:Breath;
		
		
	}

}