package trinity {
	
	/**
	 * ...
	 * @author KingFo (telds kingfo)
	 */
	public interface INetConnection {
		
		function connect(config:Object,session:String):void;
		
		function send(data:*):void;
		
	}
	
}