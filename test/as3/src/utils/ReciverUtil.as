package utils {
	import trinity.engine.IReceiver;
	import trinity.utils.callFunc;
	
	/**
	 * ...
	 * @author KingFo (telds kingfo)
	 */
	public class ReciverUtil implements IReceiver {
		
		public var onReceive:Function;
		
		public function ReciverUtil() {
			
		}
		
		public function receive(request:*):void {
			callFunc(onReceive,request);
		}
	}

}