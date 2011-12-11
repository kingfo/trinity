package {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	import trinity.net.JSHttpRequest;
	import trinity.Trinity;
	import trinity.Storage;
	
	/**
	 * ...
	 * @author KingFo (telds kingfo)
	 */
	public class Main extends Sprite {
		
		public function Main():void {
			timeid = setTimeout(init, 100);
		}
		
		private function init():void {
			clearTimeout(timeid);
			// entry point
			storage = Storage.getInstance();
			trin = new Trinity(new JSHttpRequest(), storage);
			trin.embed(this);
			trin.addCallback(
								'clear',				storage.clear,
								'destroy',				storage.destroy,
								'getSize',				storage.getSize,
								'setSize',				storage.setSize,
								'hasCompression',		storage.hasCompression,
								'useCompression',		storage.useCompression,
								'getModificationDate',	storage.getModificationDate
								);
			trin.ready();
		}
		
		private var trin:Trinity
		private var storage:Storage
		private var timeid:int;
	}
	
}