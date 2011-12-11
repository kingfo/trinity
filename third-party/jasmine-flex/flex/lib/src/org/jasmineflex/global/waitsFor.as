package org.jasmineflex.global
{
	import org.jasmineflex.jasmine;

	public function waitsFor(latchFunction:Function, optional_timeoutMessage:String = null, optional_timeout:* = null) {
		jasmine.getEnv().currentSpec.waitsFor.apply(jasmine.getEnv().currentSpec, arguments);
	};
}