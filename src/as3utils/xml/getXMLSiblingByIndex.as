package as3utils.xml {
	/**
	 * ...
	 * @author Kingfo[Telds longzang]
	 */
	public function getXMLSiblingByIndex(x:XML, count:int):XML {
		var out: XML;
		try {
			out = x.parent().children()[x.childIndex() + count];
		}catch (e: Error) {
			out = null;
		}
		return out;	
	}

}