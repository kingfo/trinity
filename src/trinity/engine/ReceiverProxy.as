package trinity.engine {
	import flash.net.LocalConnection;
	/**
	 * ...
	 * @author KingFo (telds kingfo)
	 */
	public class ReceiverProxy {
		
		public function get client():* { return localConn.client; }
		public function set client(value:*):void {
			localConn.client = value;
		}
		
		public function get isConnecting():Boolean {
			return _isConnecting;
		}
		
		public function ReceiverProxy(client:IReceiver) {
			localConn.client = client;
			localConn.allowDomain('*');
		}
		
		public function connect(channel:String):Boolean {
			var chnl:String = channel;
			close();
			try {
				localConn.connect(chnl);
				_isConnecting = true;
				return isConnecting;
			}catch (e:Error) {
				
			}
			return _isConnecting = false;
			
		}
		
		public function close():void {
			if (isConnecting) {
				localConn.close();
				_isConnecting = false;
			}
			
		}
		
		private var _isConnecting:Boolean = false;
		private var localConn:LocalConnection = new LocalConnection();
	}

}