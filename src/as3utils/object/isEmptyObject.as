package as3utils.object {
	import flash.utils.describeType;
	/**
	 * Checks to see if an object is empty.
	 * @param	o
	 * @return
	 * @author Kingfo[Telds longzang]
	 */	
	public function isEmptyObject(o: Object): Boolean {
		var xml: XML = describeType(o);
		
		if (xml.toString() !== "") {
			return false;
		}
		
		for (var p:* in o) {
			return false;
		}
		return true;
	}
		

}