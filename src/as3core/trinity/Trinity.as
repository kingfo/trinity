package trinity {
	import flash.display.DisplayObject;
	import trinity.engine.Engine;
	import trinity.external.AJBridgeLite;
	import trinity.utils.getObjectValue;
	
	/**
	 * 包含 INetConnection IStorage
	 * @author KingFo (telds kingfo)
	 */
	public class Trinity {
		
		public function get engine():Engine {
			return _engine;
		}
		
		public function Trinity(engine:Engine) {
			_engine = engine;
			instance = this;
			
			engine.onConnected = onConnected;
			engine.onMaster = onMaster;
			engine.onSended = onStatus;
			engine.onError = onStatus;
			engine.onReceived = onReceived;
			
		}
		
		static public function embed(container:DisplayObject):Trinity {
			if (instance) return  instance;
			
			var flashvars:Object = container.loaderInfo.parameters
			
			AJBridgeLite.deploy(flashvars);
			
			var group:String = getObjectValue(flashvars, 'group') || '_group';
			var debug:Boolean = getObjectValue(flashvars, 'debug');
			
			var engine:Engine;
			engine = new Engine(group);
			
			var storage:Storage = Storage.getInstance();
			storage.useCompression(!debug);
			
			storage.onChanged = AJBridgeLite.callJS;
			storage.onClose = AJBridgeLite.callJS;
			storage.onCreation = AJBridgeLite.callJS;
			storage.onError = AJBridgeLite.callJS;
			storage.onOpen = AJBridgeLite.callJS;
			storage.onPending = AJBridgeLite.callJS;
			storage.onStatus = AJBridgeLite.callJS;
			
			instance = new Trinity(engine);
			
			AJBridgeLite.addCallback({
										'fire':						engine.fire,
										'getName':					engine.getName,
										'getStatus':				engine.getStatus,
										'getGroup':					engine.getGroup,
										'exit':						engine.exit,
										'connect':					engine.connect,
										
										'setItem':					storage.setItem,
										'getItem':					storage.getItem,
										'clear':					storage.clear,
										'destroy':					storage.destroy,
										'getSize':					storage.getSize,
										'setSize':					storage.setSize,
										'hasCompression':			storage.hasCompression,
										'useCompression':			storage.useCompression,
										'getModificationDate':		storage.getModificationDate
										
										//,'transfer':					transfer
			});
			
			//function transfer(data:*):void {
				//AJBridgeLite.callJS({type:'transfer',data:data});
			//}
			
			AJBridgeLite.ready();
			
			engine.connect();
			return instance;
		}
		
		private function onConnected(name:String):void {
			AJBridgeLite.callJS({type:'join',name:name});
		}
		
		private function onReceived(request:*):void {
			AJBridgeLite.callJS({type:'message',data:request});
		}
		
		private function onStatus(type:String, msg:String, request:*):void {
			AJBridgeLite.callJS({type:type,msg:msg,data:request});
		}
		
		private function onMaster(name:String):void {
			AJBridgeLite.callJS({type:'master',name:name});
		}
		
		
		private var _engine:Engine;
		
		static private var instance:Trinity
	}

}