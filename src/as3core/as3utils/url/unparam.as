package as3utils.url {
	/**
	 * ...
	 * @author Kingfo[Telds longzang]
	 */
	import flash.net.URLVariables
	
	
	/**
	 * Parses a URI-like query string and returns an object composed of parameter/value pairs.
	 * <code>
	 * 'section=blog&id=45'        // -> {section: 'blog', id: '45'}
	 * 'section=blog&tag[]=js&tag[]=doc' // -> {section: 'blog', tag: ['js', 'doc']}
	 * 'tag=ruby%20on%20rails'        // -> {tag: 'ruby on rails'}
	 * 'id=45&raw'        // -> {id: '45', raw: ''}
	 * </code>
	 * @param	str
	 * @param	sep
	 * @return
	 */
	public function unparam(str: String, sep: String = '&'): URLVariables  {
		
		
		if (!str || (str = trim(str)).length === 0) return new URLVariables();

		var ret:URLVariables = new URLVariables(),
			pairs:Array = str.split(sep),
			pair:*, key:String, val:*, m:Array,
			i:int = 0, len:int = pairs.length;

		for (; i < len; ++i) {
			pair = pairs[i].split('=');
			key = decodeURIComponent(pair[0]);

			// pair[1] 可能包含 gbk 编码的中文，而 decodeURIComponent 仅能处理 utf-8 编码的中文，否则报错
			try {
				val = decodeURIComponent(pair[1] || '');
			} catch (e:Error) {
				val = pair[1] || '';
			}

			if ((m = key.match(/^(\w+)\[\]$/)) && m[1]) {
				ret[m[1]] = ret[m[1]] || [];
				ret[m[1]].push(val);
			} else {
				ret[key] = val;
			}
		}
		return ret;
	}

}