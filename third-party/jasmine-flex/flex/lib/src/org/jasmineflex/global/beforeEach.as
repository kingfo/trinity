package org.jasmineflex.global
{
	import org.jasmineflex.jasmine;

	public function beforeEach(beforeEachFunction:Function):void {
		jasmine.getEnv().beforeEach(beforeEachFunction);
	};
}