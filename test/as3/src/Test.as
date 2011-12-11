package  {
	import flash.display.Sprite;
	import trinity.engine.ChannelCache;
	
	/**
	 * ...
	 * @author KingFo (telds kingfo)
	 */
	public class Test extends Sprite {
		
		public function Test() {
			var cache:ChannelCache = new ChannelCache();
			var a:Array;
			
			a = cache.getSubnets('chn-1');
			
			
			cache.addChannel('chn-1');
			a = cache.getSubnets('chn-1');
			
			var subnets:Array = ['chn-1-2', 'chn-1-3', 'chn-1-4', 'chn-1-5'];
			cache.addChannel('chn-1', subnets);
			a = cache.getSubnets('chn-1');
		}
		
	}

}