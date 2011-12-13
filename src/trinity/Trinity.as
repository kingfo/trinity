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
			
			engine.connect();
		}
		
		static public function embed(container:DisplayObject):Trinity {
			if (instance) return  instance;
			
			var flashvars:Object = container.loaderInfo.parameters
			
			AJBridgeLite.deploy(flashvars);
			
			var group:String;
			group = getObjectValue(flashvars, 'group') || '_group';
			
			var engine:Engine;
			engine = new Engine(group);
			instance = new Trinity(engine);
			
			var storage:Storage = Storage.getInstance();
			
			AJBridgeLite.addCallback(
										'fire',						engine.fire,
										'getName',					engine.getName,
										'getStatus',				engine.getStatus,
										'getGroup',					engine.getGroup,
										'exit',						engine.exit,
										'connect',					engine.connect,
										
										'setItem',					storage.setItem,
										'getItem',					storage.getItem,
										'clear',					storage.clear,
										'destroy',					storage.destroy,
										'getSize',					storage.getSize,
										'setSize',					storage.setSize,
										'hasCompression',			storage.hasCompression,
										'useCompression',			storage.useCompression,
										'getModificationDate',		storage.getModificationDate
									);
			AJBridgeLite.ready();
			return instance;
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
		
		private var _engine:Engine;
		
		static private var instance:Trinity
	}

}