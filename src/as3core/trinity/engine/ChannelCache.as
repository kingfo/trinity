package trinity.engine {
	import as3utils.array.unique;
	import flash.events.NetStatusEvent;
	import trinity.Storage;
	import trinity.utils.callFunc;
	/**
	 * ...
	 * @author KingFo (telds kingfo)
	 */
	public class ChannelCache {
		
		public static const NAME:String = '__02d872c7-1965-406e-821f-45d40fd5058f__';
		
		public function ChannelCache() {
			
		}
		
		/**
		 * 获得指定信道下的子网
		 * @param	channel
		 * @return
		 */
		public function getSubnets(channel:String):Array {
			var res:Object = getCacheItem(channel);
			if (!res) return null;
			return res.subnets;
		}
		/**
		 * 获取信道的网关
		 * @param	channel
		 * @return
		 */
		public function getGetway(channel:String):String {
			var res:Object = getCacheItem(channel);
			if (!res) return null;
			return res.getway;
		}
		/**
		 * 添加信道
		 * @param	channel
		 * @param	base
		 */
		public function addChannel(channel:String,base:* = null):void {
			var map:Object = getMap() || {};
			var hash:Array = getHash() || [];
			var item:Object;
			var gtw:Object;
			var subnets:Array;
			
			if (hash.indexOf(channel) < 0) { // channel hash not exist 
				hash.push(channel); 
			}
			
			item = map[channel] ||= createCacheItem(channel);
			
			if (!base) {
				item.getway = channel;
				setSource(hash, map);
				return;
			}
			
			if (base is String) { // base on getway
				//update channel
				item.getway = base;
				// update getway & map
				gtw = map[item.getway] ||= createCacheItem(item.getway);
				gtw.getway = item.getway;
				subnets =  gtw.subnets ||= [];
				subnets.unshift(channel); // as stack when broadcast
				//update hash
				hash.push(item.getway)
				hash = unique(hash);
				
				setSource(hash, map);
				return;
			}
			
			if (base is Array) { // getway 
				//update getway
				base = unique(base);
				item.subnets = unique(base.concat(item.subnets || []));
				subnets = item.subnets;
				item.getway = channel;
				//update subnet & getway
				var i:int, len:int = base.length;
				var name:String;
				for (i = 0; i < len; i++ ) {
					name = base[i];
					item = map[name] ||= createCacheItem(name);
					item.getway = channel;
				}
				//update hash
				hash = unique(hash.concat(base as Array));
				setSource(hash, map);
				return;
			}
			
		}
		/**
		 * 移除信道
		 * @param	channel
		 */
		public function removeChannel(channel:String):Boolean {
			var map:Object = getMap();
			var item:Object;
			
			item = map[channel];
			if (!item) return true; 
			if (item.subnets && item.subnets.length > 0) return false; // getway is not empty
			
			//update hash
			var hash:Array = getHash();
			var len:int;
			var i:int = hash.indexOf(channel);
			if (i > -1) hash.splice(i, 1); 
			
			//update getway
			item = map[item.getway]
			if (item) {
				var a:Array = item.subnets || [];
				i = a.indexOf(channel);
				if (i > -1)item.subnets.splice(i, 1);
			}
			//update map
			delete map[channel];
			setSource(hash, map);
			return true;
		}
		/**
		 * 获得源数据
		 * @return
		 */
		public function getSource():*{
			return Storage.getInstance().getItem(NAME) || { hash:[], map: { }};
		}
		/**
		 * 设置源数据
		 * @param	hash
		 * @param	map
		 */
		public function setSource(hash:Array = null , map:Object = null):void {
			var cache:Object = getSource();
			if (hash) cache.hash = hash;
			if (map) cache.map = map;
			cache[Storage.INTERNAL_FLAG] = 1;
			Storage.getInstance().setItem(NAME, cache);
		}
		/**
		 * 获得 缓存 对象
		 * @param	channel
		 * @return
		 */
		protected function getCacheItem(channel:String ):Object {
			var map:Object = getMap(channel);
			if (!map) return null;
			return map[channel];
		}
		
		protected function createCacheItem(name:String):Object {
			var res:Object = { name:name/*, subnets:null, getway:null*/ };
			return  res;
		}
		/**
		 * 获得 信道 列表
		 * @param	chn 若指定某信道 则相当于  contains(chn) 
		 * @return
		 */
		protected function getHash(chn:String = null):Array {
			var hash:Array = getSource()['hash'];
			return !chn ? hash : hash.indexOf(chn) > -1 ? hash : null;
		}
		
		/**
		 * 获得 信道 字典
		 * @param	chn 若指定某信道 则相当于  contains(chn) 
		 * @return
		 */
		protected function getMap(chn:String = null):Object {
			var map:Object = getSource()['map'];
			return !chn ? map : map.hasOwnProperty(chn) ? map : null;
		}
		
	}
}