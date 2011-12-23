package as3utils.xml {
	/**
	 * ...
	 * @author Kingfo[Telds longzang]
	 */
	public function isEmptyXML(data: * ): Boolean {
		var xml: XML ;
		if (data is String ) xml = new XML(data);
		else if (data is XML) xml = data;
		else return false;
		return !xml.hasComplexContent() && xml.text().length() < 1;
	}

}