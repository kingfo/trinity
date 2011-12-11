package org.jasmineflex.global
{
	import org.jasmineflex.jasmine;

	public function xdescribe(description:String, specDefinitions:Function):* {
		return jasmine.getEnv().xdescribe(description, specDefinitions);
	};
}