package trinity.engine {
	/**
	 * ...
	 * @author KingFo (telds kingfo)
	 */
	public class Command {
		
		public var signature:String;
		public var host:String;
		public var args:Array;
		
		public function Command(host:String,args:Array,signature:String) {
			this.host = host;
			this.args = args;
			this.signature = signature;
		}
		
	}

}