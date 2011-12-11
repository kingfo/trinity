package as3utils.object {
	import flash.events.Event;
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	/**
	 * ...
	 * @author Kingfo[Telds longzang]
	 */
	/**
	 * Creates a deep copy of a plain object or array. Others are returned untouched.
	 * @param	o
	 * @return
	 */
	public function clone(o:*):* {
		var ret:* = o, 
			k:*, 
			c: Class,
			cn: String,
			bytes:ByteArray,
			pn: String,
			xml:XML;
		
			xml = describeType(o);
			cn = getQualifiedClassName(o);
			c = getDefinitionByName(cn) as Class;
			pn = cn.split('::')[0];
		
		if (o && (isPlainObject(o) || o is Array)) {
			// array or plain object
			registerClassAlias(pn, c);
			bytes = new ByteArray();
			bytes.writeObject(o);
			bytes.position = 0;
			ret = bytes.readObject();
		}else if(o is Event) {
			ret = o.clone();
		}

		return ret;	
	}
	
	
	

}