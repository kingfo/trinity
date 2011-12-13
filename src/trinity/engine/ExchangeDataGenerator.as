package trinity.engine {
	/**
	 * ...
	 * @author KingFo (telds kingfo)
	 */
	public class ExchangeDataGenerator {
		
		
		public function ExchangeDataGenerator() {
		}
		
		static public function generator(	to:String,
											type:int,
											body:* = null,
											from:String = null,
											getway:String = null):Object {
			return { 	to:to || null, 				//消息发送方
						type:type || 0, 			//消息类型
						body:body || null, 			//消息类型
						from:from || null, 			//消息接收方
						getway:getway || null 		//冗余值 供未来追溯
					};
		}
		
	}

}