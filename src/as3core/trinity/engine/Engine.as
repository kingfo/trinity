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
		
		public function get isConnecting():Boolean {
			return _isConnecting;
		}
		/**
		 * 当节点链接成功并加入网络的时候回调
		 * 与 master 不同，node 加入网络并被 master 注册后才被触发
		 * 接受以下形式函数:
		 * onConnected();
		 * onConnected(name:String);
		 */
		public var onConnected:Function;
		/**
		 * 当成为 master 节点的时候回调
		 * 接受以下形式函数:
		 * onMaster();
		 * onMaster(name:String);
		 */
		public var onMaster:Function;
		/**
		 * 当发送消息成功的时候回调
		 * 接受以下形式函数:
		 * onSended();
		 * onSended(type:String);
		 * onSended(type:String, msg:String);
		 * onSended(type:String, msg:String, request:*);
		 */
		public var onSended:Function;
		/**
		 * 当发送消息失败的时候回调
		 * 接受以下形式函数:
		 * onError();
		 * onError(type:String);
		 * onError(type:String, msg:String);
		 * onError(type:String, msg:String, request:*);
		 */
		public var onError:Function;
		/**
		 * 当接收到指令执行时的回调
		 * 接受以下形式函数:
		 * onExecution();
		 * onExecution(command:*);
		 */
		public var onExecution:Function;
		/**
		 * 当接收到消息的时候回调
		 * 接受以下形式函数:
		 * onReceived();
		 * onReceived(request:*);
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
		 * @param	to				不指定则全员广播
		 */
		public function fire(data:*, to:String = null ):void { // master 和 node 都适用
			//trace('FIRE');
			var request:Object = createEmptyRequest(ExchangeDataType.MESSAGE);
			request.body = data;
			if (!to) { // 广播 
				broadcast(request);
				return;
			}
			// 单播
			request.to = to;
			send(request, onCallback);
		}
		/**
		 * 公开的接收其他节点的方法
		 * @param	request
		 */
		public function receive(request:*):void {
			if (!request) return;
			////trace(request.type,request.from);
			switch(request.type) {
				case ExchangeDataType.SNIFFING: // 仅用于 Master
					return;
					break;
				case ExchangeDataType.MESSAGE: 
					if (request.to == kernel.name) { // 到达终点。任何节点到达本节点时，且不止于组内。
						callFunc(onReceived, request);
						return;
					}  
					
					if (request.to == null) { // 未指定接收者则广播，一般来自组外转发。
						broadcast(request);
						callFunc(onReceived, request); // 既然广播则自己也需要接收一份
						return;
					}
					
					// ??? request.to != kernel.name
					
					break;
				case ExchangeDataType.REGISTRATION: // 仅用于 Master
					request.gateway = kernel.name;
					cache.addChannel(request.from, request.gateway);
					join(request);
					break;
				case ExchangeDataType.EXECUTION:
					if(kernel.isMaster && request.body)callFunc(onExecution, request.body);
					break;
				case ExchangeDataType.FORWARD: // 仅用于 Master
					arguments.callee(request.body);
					break;
				case ExchangeDataType.EXIT: // 仅用于 Master
					cache.removeChannel(request.body);
					break;
				case ExchangeDataType.JOIN:// 仅用于 node
					_isConnecting = true;
					callFunc(onConnected, kernel.name);
					break;
			}
		}
		/**
		 * 广播消息
		 * 同通常认识的一样，广播来源方不会被通知
		 * 以下 2 种情况会被触发
		 * 	   当 fire 时 to 为 null 会触发
		 *     当 receive 到 to 为 null 会触发 
		 * @param	request
		 */
		public function broadcast(request:*):void {
			if (request.gateway == group) {// 如果是网关
				var list:Array = cache.getSubnets(group) || [];
				list = list.concat();
				list.push(group); // 包含网关都应该收到通知
				var i:int, len:int = list.length;
				for (i = 0; i < len; i++ ) {
					var name:String = list[i];
					//if (name == request.from) continue; //交由业务层处理
					var req:Object = cloneRequest(request);
					req.to = name;
					send(req, onCallback);
				}
			}else {// 非当前网关 则无法广播 需要转发至原网关进行
				forward(request);
			}
		}
		/**
		 * 转发消息
		 *     会对当前的 数据 进行再次封装
		 * 		
		 * @param	request
		 */
		public function forward(request:*):void {
			var req:Object = createEmptyRequest(ExchangeDataType.FORWARD);
			if (request.to == kernel.name) return; // 这里同样要排除自己
			
			req.to = request.to || request.gateway; //包含组内或组外转发
			req.body = request; 
			send(req, onCallback);
			
		}
		
		/**
		 * 创建不带 to 和 body 的交换请求
		 * @param	type
		 * @return
		 */
		public function createEmptyRequest(type:int):Object {
			return ExchangeDataGenerator.generator(null,type,null,kernel.name,group);
		}
		
		public function cloneRequest(request:*):Object {
			return ExchangeDataGenerator.generator(request['to'],
													request['type'],
													request['body'],
													request['from'],
													request['gateway']);
		}
		
		public function exit(force:Boolean = false ):void {
			if (force || kernel.isMaster) {
				kernel.close();
				_isConnecting = false;
			}else {
				notifyExit(group,kernel.name);
			}
		}
		
		public function notifyExit(masterName:String,from:String = null):void {
			var request:Object = createEmptyRequest(ExchangeDataType.EXIT);
			request.to = masterName;
			request.body = from;
			send(request, onCallback);
		}
		
		protected function onTimer(timer:Timer):void {
			var a:Array = cache.getSubnets(group) || [];
			breath.check(a.length);
			var request:Object = createEmptyRequest(ExchangeDataType.SNIFFING);
			request.to = group;
			send(request, onCallback);
			//trace('SNIFFING');
		}
		
		
		protected function register():void {
			var request:Object = createEmptyRequest(ExchangeDataType.REGISTRATION);
			request.to = group;
			send(request, onCallback);
			//trace('REGISTRATION');
		}
		
		protected function checkSubnet():void {
			broadcast(createEmptyRequest(ExchangeDataType.SNIFFING));
		}
		
		protected function join(request:*):void {
			var req:Object = createEmptyRequest(ExchangeDataType.JOIN);
			req.to = request.from;
			send(req, onCallback);
			//trace('JOIN');
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
						
						if ((request.gateway && request.gateway != group) || 
							(!kernel.isMaster && request.to != group)) {
							notifyExit(request.gateway, request.to);
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
		
		
		
		private function masterHandler(name:String):void {
			checkSubnet();
			breath.stop();
			cache.addChannel(name);
			callFunc(onMaster, name);
			//trace('I M MASTER!');
		}
		
		private function connectedHandler(...args):void {
			var a:Array = args.concat();
			a.unshift(onConnected);
			if (!kernel.isMaster) {
				register();
				breath.start();
			}else {
				_isConnecting = true;
				callFunc.apply(this, a); // node 需要等到 注册成功返回才算
			}
		}
		
		private function send(request:Object, callback:Function):void {
			if (!request || !request.to) return;
			breath.later();
			kernel.send(request.to, request, callback);
		}
		
		
		private var _cache:ChannelCache = new ChannelCache();
		private var _isRunning:Boolean = false;
		private var _isConnecting:Boolean = false;
		
		private var group:String;
		private var kernel:Kernel;
		private var breath:Breath;
		
		
	}

}