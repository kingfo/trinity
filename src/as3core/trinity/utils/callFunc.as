package trinity.utils {
	/**
	 * 静默执行函数
	 * @author KingFo (telds kingfo)
	 */
		
	public function callFunc(fn:Function, ...args):void {
		if (fn == null) return;
		
		var fnLen:int = fn.length;
		var argsLen:int = args.length;
		var offset:int = fnLen - argsLen;
		var i:int;
		var a:Array = [];
		
		if ((fnLen == 0 && argsLen > 0) || offset == 0) {
			fn.apply(this, args);
			return;
		}

		if ( offset > 0) {
			for (i = 0; i < offset; i++ ) {
				a.push(null);
			}
		}else {
			a = a.concat(args.splice(0, fnLen));
		}
		
		fn.apply(this, a);	
	}
		

}