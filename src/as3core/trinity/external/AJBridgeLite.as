package trinity.external {
	import as3utils.object.isPlainObject;
	import as3utils.string.isEmptyString;
	import flash.external.ExternalInterface;
	import trinity.utils.getObjectValue;
	/**
	 * ...
	 * @author KingFo (telds kingfo)
	 */
	public class AJBridgeLite {
		
		static public var isReady:Boolean = false;
		
		public function AJBridgeLite() {
			
		}
		
		static public function deploy(flashvars:Object):void {
			entry = getObjectValue(flashvars, 'jsentry');
			id = getObjectValue(flashvars, 'swfid');
		}
		
		static public function addCallback(...args):Boolean {
			var len: int = args.length;
			if (len < 1) return false;
			
			var name: String;
			var func: Function;
			var callbacks: * ;
			var a: Array;
			
			//like: addCallback(FunctionName,closure,...)
			a = args.concat();
			while (a.length) {
				callbacks = a.splice(0, 2);
				name = callbacks[0];
				if (isEmptyString(name)) continue;
				func = callbacks[1] as Function;
				_addCallback(name, func);
			}
			
			
			//if (len == 1) { // name-function hash对象
				//callbacks = args[0];
				//if (!isPlainObject(callbacks)) return false;
				//for (name in callbacks) {
					//_addCallback(name, callbacks[name] as Function);
				//}
			//}else if (len > 1) {
				//like: addCallback(FunctionName,closure,...)
				//a = args.concat();
				//while (a.length) {
					//callbacks = a.splice(0, 2);
					//name = callbacks[0];
					//if (isEmptyString(name)) continue;
					//func = callbacks[1] as Function;
					//_addCallback(name, func);
				//}
			//}
			
			function _addCallback(name:String, closure:Function):void {
				if (closure == null) return;
				try {
					ExternalInterface.addCallback(name, closure);
				}catch (e:Error) {
					
				}
			}
			
			return true;
		}
		
		static public function callJS(msg:*):void {
			if (!entry || !id || !ExternalInterface.available) return;
			try {
				ExternalInterface.call(entry, id, msg);
			}catch (e:Error) {
				
			}
		}
		
		static public function ready():void {
			if (isReady) return;
			isReady = true;
			callJS( {type:'swfReady'} );
		}
		
		static private var entry:String;
		static private var id:String;
	}

}