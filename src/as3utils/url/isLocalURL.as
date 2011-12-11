package as3utils.url {
	import flash.external.ExternalInterface;
	/**
	 * ...
	 * @author Kingfo[Telds longzang]
	 */
	public function isLocalURL(url:String): Boolean {
		return url.indexOf("file://") > -1;
	}

}