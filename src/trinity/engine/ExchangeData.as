package trinity.engine {
	/**
	 * ...
	 * @author KingFo (telds kingfo)
	 */
	public class ExchangeData {
		
		/**
		 * 冗余值 供未来追溯
		 */
		public var getway:String;
		/**
		 * 消息发送方
		 */
		public var from:String;
		/**
		 * 消息接收方
		 */
		public var to:String;
		/**
		 * 消息类型
		 */
		public var type:Number;
		/**
		 * 消息内容
		 */
		public var body:*;
		
		public function ExchangeData(to:String = null) {
			this.to = to;
		}
		
	}

}