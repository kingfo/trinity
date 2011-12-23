package trinity.utils {
	/**
	 * ...
	 * @author KingFo (telds kingfo)
	 */
		
	public function getObjectValue(object:Object,key:*,insensitive:Boolean = true):* {
		var res:*;
		var sk:* = key.toString().toLowerCase();
		var tk:String;
		var lk:String;
		for (var k:* in object) {
			tk = k.toString();
			lk = tk.toLowerCase();
			if (insensitive) {
				res = ( lk == sk ) ? object[k] : null;
			}else {
				res = ( lk == sk && tk == sk ) ? object[k] : null;
			}
			if (res) break;
		}
		return res;
	}
		

}