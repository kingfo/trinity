package as3utils.string {
	/**
	 * ...
	 * @author Kingfo[Telds longzang]
	 */
	/**
	 * Removes the whitespace from the beginning and end of a string.
	 */
	public function trim(s:String):String {
		return s.replace(/^\s+|\s+$/g, '');
	}
	
	

}