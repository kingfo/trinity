package trinity {
	import flash.events.NetStatusEvent;
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;
	import flash.utils.ByteArray;
	import trinity.utils.callFunc;
	/**
	 * 
	 * @author KingFo (telds kingfo)
	 */
	//TODO:  后期优化，进行核心版本缩小，其他的次要功能，通过完成其扩展即可
	public class Storage implements IStorage {
		
		static public function getInstance():Storage { return instance ||= new Storage(); }
		
		static public const DEFAULT_SHARED_NAME:String = '__trinity__';
		
		static public const INTERNAL_FLAG:String = '1cb78b86-4045-4599-921f-069589d61c21';
		
		
		public var onCreation:Function;
		public var onOpen:Function;
		public var onChanged:Function;
		public var onStatus:Function;
		public var onClose:Function;
		public var onError:Function;
		public var onPending:Function;
		
		public function Storage() {
			if (instance) throw new Error('Singleton!');
			instance = this;
		}
		
		
		/**
		 * 存储数据对象
		 * @param	key								键
		 * @param	data							任意数据
		 */
		public function setItem(key:String,data:*): void {
			if (key == "" || key == null) return;
			var oldValue:* ;
	    	var info: String;
			var archive: Object = readArchive();
			var result: Boolean;
			var index: int;
			
			index =  archive.hash.indexOf(key);
			
			if (data == null || data == undefined ) {
				if (index < 0) return;
				oldValue = archive.map[key];
				delete archive.map[key];
				archive.hash.splice(index, 1);
				
				info = "delete";
			}else {
				if (archive.map.hasOwnProperty(key)) {
					if (archive.map[key] == data) {
						return ;
					}else {
						oldValue = getItem(key);
						info = "update";
					}
				}else {
					info = "add";
					archive.hash.push(key);
				}
				archive.map[key] = data;
			}
			
			result = save(archive);
			trace('onChanged:' + 'info:' + info + ' key:' + key + ' oldValue:' + oldValue + ' data:' + data);
			if (isInternal(data)) return;
			callFunc(onChanged, { 
									type:'storage', 
									info:info,
									key:key,
									oldValue:oldValue,
									newValue:data
								} );
		}
		
		/**
		 * 获得存储的数据对象
		 * @param	key								键
		 * @return
		 */
		public function getItem(key:String):*{
			var  archive: Object = readArchive();
			if (archive.map.hasOwnProperty(key)) {
				return archive.map[key];
			}
			return null;
		}
		/**
		 * 获得存储的数据源
		 * @param	key								键
		 * @return
		 */
		public function getSource():*{
			return readArchive();
		}
		
		/**
		 * 清空数据缓存
		 * 原始操作相当于销毁实际文件
		 * 而此操作后又创建了新的档案并再次存入修改信息
		 */
		public function clear(): void {
			var so: SharedObject = getSharedObject();
			so.clear();
			save(createEmptyArchive());
			trace('clear');
		}
		/**
		 * 销毁本地存储
		 */
		public function destroy(): void {
			var so: SharedObject = getSharedObject();
			so.clear();
			save();
			trace('destroy');
		}
		
		/**
		 * 获得已存字节大小  单位 B
		 * @return
		 */
		public function getSize(): uint {
			var so: SharedObject = getSharedObject();
			var size: uint = so.size;
			return size;
		}
		/**
		 * 分配磁盘空间
		 * @param	value
		 * @return
		 */
		public function setSize(value: int): String {
			var status: String;
			var so: SharedObject = getSharedObject();
			status = so.flush(value);
			return status;
		}
		/**
		 * 获得是否是压缩方式处理数据
		 * @return
		 */
		public function hasCompression(): Boolean {
			return _useCompression;
		}
		/**
		 * 设置压缩方式
		 * 配置是否为压缩方式请在传参的时候配置
		 * 一般不公开
		 * @param	value
		 */
		public function useCompression(value:Boolean = true): void {
			_useCompression = value;
		}
		/**
		 * 获取最后修改时间
		 * @return
		 */
		public function getModificationDate(): Date {
			var so:SharedObject = getSharedObject();
			if (!so.data.hasOwnProperty('modificationDate')) return null;
			var lastDate: Date =  new Date(so.data.modificationDate);
			return lastDate;
		}
		/**
		 * 重新获取本地共享对象
		 * @return
		 */
		protected function getSharedObject(): SharedObject {
			var so:SharedObject = SharedObject.getLocal(DEFAULT_SHARED_NAME);
			so.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
			trace('onOpen');
			callFunc(onOpen, {type:'open',info:DEFAULT_SHARED_NAME});
			return so;
		}
		/**
		 * SharedObject 存储状态
		 * @param	event
		 */
		protected function onNetStatus(event: NetStatusEvent): void {
			trace('onStatus:' + event.type);
			callFunc(onStatus, {type:event.type, info:event.info.level } );
		}
		/**
		 * 设置修改时间
		 * @param	so
		 */
		protected function setModificationDate(so:SharedObject): void {
			so.data.modificationDate = new Date().getTime();
		}
		/**
		 * 保存即时数据
		 * @param	archive
		 * @return
		 */
		protected function save(archive:Object = null): Boolean {
			var so: SharedObject = getSharedObject();
			var bytes: ByteArray = new ByteArray();
			var result: String;
			var key: String;
			
			////	每次操作保存都当作一次修改作为记录
			////	而非有新值才变动
			
			if (archive) {
				if (_useCompression) {
					bytes.writeObject(archive);   
					bytes.compress();    
					so.data.archive = bytes;
				}else {
					so.data.archive = archive;
				}
				setModificationDate(so);
			}
			
			try{
				result = so.flush();
	    	}catch (e:Error) {
				trace('onError:' + e.message);
				callFunc(onError, {type:'flushError', info:e.message, id:e.errorID } );
			}
			
			switch(result) {
				case SharedObjectFlushStatus.FLUSHED:
					trace('onClose:' + result);
					callFunc(onClose, {type:result, info:DEFAULT_SHARED_NAME } );
					return true;
				break;
				case SharedObjectFlushStatus.PENDING:
					if (archive) {
						key = archive.hash[archive.hash.length - 1];
					}
					trace('onPending:' + result);
					callFunc(onPending, {type:result, info:DEFAULT_SHARED_NAME, key:key } );
					return false;
				break;
				default:
					trace('onError:' + result);
					callFunc(onError,{type:result,info:'Flash Player Could not write SharedObject to disk.',id:-1})
					return false;
			}
			
		}
		
		/**
		 * 即时读取存档
		 * @return
		 */
		protected function readArchive(): Object {
			var so: SharedObject = getSharedObject();
			var tempBytes: ByteArray;
			var bytes: ByteArray;
			var archive: Object;
			if (!so.data.hasOwnProperty("archive")) {
   				archive = createEmptyArchive();
				trace('onCreation');
				callFunc(onCreation,{type:'creation',info:DEFAULT_SHARED_NAME});
 			}else {
				////	判断是否字节流
				////	是则是经过压缩的数据
				if (so.data.archive is ByteArray) {
					tempBytes = so.data.archive as ByteArray;
					bytes = new ByteArray();
					////	可能位置不正确，所以尝试复位
					tempBytes.position = 0;
 					tempBytes.readBytes(bytes, 0, tempBytes.length);
					try	{
 						bytes.uncompress();
 					}catch(error:Error)	{
						callFunc(onError,{type:'uncompressError',info:'ByteArray uncompress error'});
 					}
					archive = bytes.readObject();
				}else {
					archive = so.data.archive;
				}
			}
			return archive;
		}
		
		/**
		 * 创建空文档
		 * @return
		 */
		protected function createEmptyArchive(): Object {
			return { map: { }, hash: [] };
		}
		
		private function isInternal(data:*):Boolean {
			return data && data.hasOwnProperty(INTERNAL_FLAG);
		}
		
		private var _useCompression: Boolean;
		
		static private var instance:Storage;
	}

}