package org.jasmineflex.global
{
	import org.jasmineflex.jasmine;

	public function runs(func:Function) {
		jasmine.getEnv().currentSpec.runs(func);
	};
}