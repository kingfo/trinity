package org.jasmineflex.global
{
	import org.jasmineflex.jasmine;

	public function expect(actual:*):* {
		return jasmine.getEnv().currentSpec.expect(actual);
	};
}