package trinity.utils {
	import flash.utils.getTimer;
	/**
	 * ...
	 * @author KingFo (telds kingfo)
	 */
		
	public function guid(prefix:String = '',  suffix:String = ''):String {
		return prefix + getTimer().toString(16).toUpperCase() + suffix;
	}
		

}