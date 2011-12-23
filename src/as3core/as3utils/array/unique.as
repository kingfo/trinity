package as3utils.array {
	/**
	 * ...
	 * @author Kingfo[Telds longzang]
	 */
	
	/**
	 * Returns a copy of the array with the duplicate entries removed
	 * @param	a				the array to find the subset of uniques for
	 * @param	rv			
	 * @return					a copy of the array with duplicate entries removed
	 */
	public function unique(a:Array, rv:Boolean = false):Array {
		if(rv) a.reverse(); // 默认是后置删除，如果 override 为 true, 则前置删除
		var b:Array = a.slice(), i:int = 0, n:int, item:*;
		while (i < b.length) {
			item = b[i];
			while ((n = b.lastIndexOf(item)) !== i) {
				b.splice(n, 1);
			}
			i += 1;
		}
		if(rv) b.reverse(); // 将顺序转回来
		return b;	
	}

}