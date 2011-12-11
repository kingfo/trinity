// ActionScript file
package org.jasmineflex.global
{
	import org.jasmineflex.jasmine;

	public function describe(description:String, specDefinitions:Function):* {
		return jasmine.getEnv().describe(description, specDefinitions);
	};
}