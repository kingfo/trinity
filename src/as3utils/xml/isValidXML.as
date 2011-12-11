package as3utils.xml {
	/**
	 * 验证 XML 或 XML 字符串有效性
	 * @author Kingfo[Telds longzang]
	 */
	public function isValidXML(data:*): Boolean {
		var xml: XML;
		try {
			if (data is String) xml = new XML(data);
			else if (xml is XML) xml = data as XML;
			else return false;
		}catch (e: Error) {
			return false;
		}
		if (xml.nodeKind() != 'element') return false;
		return true;
	}

}