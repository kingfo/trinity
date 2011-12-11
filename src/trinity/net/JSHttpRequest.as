package trinity.net {
	import com.adobe.crypto.MD5;
	import trinity.external.AJBridgeLite;
	import trinity.INetConnection;
	/**
	 * ...
	 * @author KingFo (telds kingfo)
	 */
	public class JSHttpRequest implements INetConnection {
		
		
		public function JSHttpRequest() {
			
		}
		
		public function connect(config:Object,session:String):void {
			AJBridgeLite.callJS({type:'connect',data:config,session:String});
		}
		
		public function send(data:*):void {
			AJBridgeLite.callJS({type:'send',data:data});
		}
		
		
	}

}