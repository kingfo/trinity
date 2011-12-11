package trinity.engine {
	import flash.events.SecurityErrorEvent;
	import flash.events.StatusEvent;
	import flash.net.LocalConnection;
	import trinity.utils.callFunc;
	
	/**
	 * ...
	 * @author KingFo (telds kingfo)
	 */
	public class Sender {
		
		public function Sender(hander:String) {
			this.hander = hander;
			localConn.addEventListener(StatusEvent.STATUS, onStatus);
			localConn.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
		}
		
		public function send(to:String, request:*, callback:Function):Boolean {
			if (!to) return false ;
			queue.push( {
							args:[to, hander, request],
							callback:callback
						});
			run();
			return true;
		}
		
		public function run():void {
			if (isRunning) return;
			_send();
			isRunning = true;
		}
		
		private function _send():void {
			if (queue.length < 1) {
				isRunning = false;
				return;
			}
			current = queue.shift();
			localConn.send.apply(this, current.args);
		}
		
		
		private function onSecurityError(e:SecurityErrorEvent):void {
			callFunc(current.callback, e.type, e.text,current.args[2]);
			_send();
		}
		
		private function onStatus(e:StatusEvent):void {
			callFunc(current.callback, e.level, e.code,current.args[2]);
			_send();
		}
		
		
		private var localConn:LocalConnection = new LocalConnection();
		private var hander:String;
		private var queue:Array = [];
		private var current:Object;
		private var isRunning:Boolean = false;
	}
}
