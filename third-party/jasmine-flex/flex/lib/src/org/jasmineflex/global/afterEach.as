package org.jasmineflex.global
{
	import org.jasmineflex.jasmine;

	public function afterEach(afterEachFunction:Function):void {
		jasmine.getEnv().afterEach(afterEachFunction);
	};
}