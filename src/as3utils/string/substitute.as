package as3utils.string {
	import as3utils.object.isPlainObject;
	/**
	 * ...
	 * @author Kingfo[Telds longzang]
	 */
	
	/**
	 * Substitutes keywords in a string using an object/array.
	 * Removes undefined keywords and ignores escaped keywords.
	 */
	public function substitute(str:String,o:*,regexp:RegExp=null):String {
		 if(!(str is String) || !isPlainObject(o)) return str;

		return str.replace(regexp || /\\?\{([^{}]+)\}/g, function(match:*, name:*):* {
			if (match.charAt(0) === '\\') return match.slice(1);
			return (o[name] !== undefined) ? o[name] : '';
		});
	}
		

}