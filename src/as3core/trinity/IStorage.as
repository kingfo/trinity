package trinity {
	
	/**
	 * ...
	 * @author KingFo (telds kingfo)
	 */
	public interface IStorage {
		
		function setItem(key:String, data:*):void;
		function getItem(key:String):*;
		function getSource():*;
		
	}
	
	
}