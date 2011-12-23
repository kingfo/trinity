package trinity.engine {
	/**
	 * ...
	 * @author KingFo (telds kingfo)
	 */
	public class Session {
		
		public var name:String;
		public var origin:String;
		public var data:*;
		
		public function Session(name:String, origin:String, data:* = null) {
			this.name = name;
			this.data = data;
			this.origin = origin;
		}
		
	}

}