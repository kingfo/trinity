package org.jasmineflex.global
{
	import org.jasmineflex.jasmine;

	public function spyOn(obj:*, methodName:String):* {
		return jasmine.getEnv().currentSpec.spyOn(obj, methodName);
	};
}