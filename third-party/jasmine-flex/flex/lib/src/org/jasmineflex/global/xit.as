package org.jasmineflex.global
{
	import org.jasmineflex.jasmine;

	public function xit(desc:String, func:Function):* {
		return jasmine.getEnv().xit(desc, func);
	};
}