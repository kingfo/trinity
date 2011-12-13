package {
	import flash.display.Sprite;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import trinity.Trinity;
	
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
			Trinity.embed(this);
		}
		
		private var timeid:int;
	}
	
}