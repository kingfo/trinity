package org.jasmineflex.global
{
	import org.jasmineflex.jasmine;

	public function it(desc:String, func:Function):* {
		return jasmine.getEnv().it(desc, func);
	};
}