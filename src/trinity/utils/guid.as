package trinity.utils {
	import flash.system.Capabilities;
	import flash.system.System;
	/**
	 * ...
	 * @author KingFo (telds kingfo)
	 */
		
	public function guid(prefix:String = '',  suffix:String = ''):String {
		return prefix + new Date().time.toString(16) + 
				'-' + 
				System.totalMemory.toString(16) + 
				suffix;
	}
	

}
