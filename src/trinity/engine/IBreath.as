package trinity.engine {
	
	/**
	 * ...
	 * @author KingFo (telds kingfo)
	 */
	public interface IBreath {
		function start():void;
		function stop():void;
		function later():void;
		function check(multiple:Number):void;
	}
	
}