package trinity {
	import com.adobe.crypto.MD5;
	import flash.display.DisplayObject;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	import trinity.engine.Command;
	import trinity.engine.Engine;
	import trinity.engine.ExchangeData;
	import trinity.engine.ExchangeDataType;
	import trinity.engine.Session;
	import trinity.external.AJBridgeLite;
	import trinity.INetConnection;
	import trinity.IStorage;
	import trinity.utils.getObjectValue;
	
	/**
	 * 包含 INetConnection IStorage
	 * @author KingFo (telds kingfo)
	 */
	public class Trinity implements ITrinity {
		
		static public const NAME:String = '__22803fd4-979f-4f2c-a4a7-fbed83000ee0__';
		
		public function get netConnection():INetConnection {
			return _netConnection;
		}
		
		public function get storage():IStorage {
			return _storage;
		}
		
		public function get engine():Engine {
			return _engine;
		}
		
		public var delay:Number ;
		/**
		 * 
		 * @param	netConnection			 INetConnection
		 * @param	storage					 IStorage
		 */
		public function Trinity(netConnection:INetConnection,storage:IStorage) {
			this._netConnection = netConnection;
			this._storage = storage;
		}
		
		public function embed(container:DisplayObject):void {
			var flashvars:Object = container.loaderInfo.parameters
			var publicChannel:String;
			
			AJBridgeLite.deploy(flashvars);
			delay = getObjectValue(flashvars, 'delay');
			delay = isNaN(delay) ? 10000 : delay;
			publicChannel = getObjectValue(flashvars, 'group') || '_group';
			
			_engine = new Engine(publicChannel);
			engine.onConnected = onConnected;
			engine.onMaster = onMaster;
			engine.onSended = onStatus;
			engine.onError = onStatus;
			engine.onExecution = onExecution;
			engine.onReceived = onReceived;
			engine.connect();
			
			
			AJBridgeLite.addCallback(
										'load',			load,
										'notify', 		notify,
										'fire',			engine.fire,
										'getName',		engine.getName,
										'getStatus',	engine.getStatus,
										'getGroup',		engine.getGroup,
										'setItem',		storage.setItem,
										'getItem',		storage.getItem
									);
		}
		
		
		public function addCallback(...args):void {
			AJBridgeLite.addCallback.apply(this, args);
		}
		
		public function ready():void {
			AJBridgeLite.ready();
		}
		
		public function load(url:String, params:Object, method:String = 'GET'):String {
			var args:Array = [url, params, method];
			var sessionName:String = getSignature(args);
			var offset:Number = getTimer() - getTimestamp();
			if (offset < delay && hasSession(sessionName)) { // 在安全周期内 有会话的将不再产生连接
				var session:Session = getSession(sessionName);
				notify(session.data, sessionName,session.origin);
				return sessionName;
			}; 
			if (engine.getStatus() < 0) { // 普通节点
				var cmd:Command = new Command('load',args,sessionName);
				var req:ExchangeData = engine.createRequest(ExchangeDataType.EXECUTION);
				req.body = cmd;
				req.to = engine.getGroup();
				engine.forward(req);
			}else {
				var config:Object = { url:url, method:method };
				netConnection.connect(config, sessionName);
				netConnection.send(params);
				setTimestamp(getTimer());
			}
			
			return  sessionName;
			
		}
		
		public function notify(data:*, sessionName:String, from:String = null):void {
			if (engine.getStatus() < -1) {
				forward(new Command('notify',[data,sessionName,from],sessionName));
				return;
			}
			engine.fire(data,from);
			setSession(sessionName, data);
		}
		
		
		private function forward(cmd:Command):void {
			var req:ExchangeData = engine.createRequest(ExchangeDataType.EXECUTION);
			req.body = cmd;
			req.to = engine.getGroup();
			engine.forward(req);
		}
		
		/**
		 * 获得签名
		 *     用于来自不同节点的相同内容的请求
		 * @param	data
		 * @return
		 */
		protected function getSignature(data:*):String {
			var bytes:ByteArray = new ByteArray();
			var res:String;
			bytes.writeObject(data);
			bytes.position = 0;
			return MD5.hashBinary(bytes);
		}
		/**
		 * 执行被传递至的命令
		 * @param	cmd
		 */
		private function onExecution(cmd:Command):void {
			var host:* = this;
			var props:Array = cmd.host.split('.');
			var i:int , len:int = props.length;
			var prop:String;
			for (i = 0; i < len; i++) {
				prop = props[i];
				host = host[prop];
			}
			if (host is Function) {
				host.apply(this,cmd.args);
			}
		}
		
		private function setTimestamp(time:Number):void {
			var data:Object = storage.getItem(NAME) || { };
			data['timestamp'] = time;
			data[Storage.INTERNAL_FLAG] = 1;
			storage.setItem(NAME, data);
		}
		
		private function getTimestamp():Number {
			var data:Object = storage.getItem(NAME);
			return !data ? 0 : data['timestamp'];
		}
		
		private function hasSession(sessionName:String):Boolean {
			return !!getSession(sessionName);
		}
		
		private function getSession(sessionName:String):Session{
			var data:Object = storage.getItem(NAME) || { };
			var dic:Object = data['dic'];
			return !dic ? null : dic[sessionName];
		}
		
		private function setSession(sessionName:String,content:*):void{
			var data:Object = storage.getItem(NAME) || { };
			var session:Session = new Session(sessionName,engine.getName(),content);
			(data['dic'] ||= { } )[sessionName] = session;
			data[Storage.INTERNAL_FLAG] = 1;
			storage.setItem(NAME,data);
		}
		
		private function onConnected(name:String):void {
			AJBridgeLite.callJS({type:'join',name:name});
		}
		
		private function onReceived(request:*):void {
			AJBridgeLite.callJS({type:'message',data:request});
		}
		
		private function onStatus(type:String, msg:String, request:*):void {
			AJBridgeLite.callJS({type:type,msg:msg,data:request.body});
		}
		
		private function onMaster(name:String):void {
			AJBridgeLite.callJS({type:'master',name:name});
		}
		
		private var _netConnection:INetConnection;
		private var _storage:IStorage;
		private var _engine:Engine;
		
	}

}