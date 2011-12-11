package org.jasmineflex
{
	public dynamic class WaitsBlock extends Block
	{
		public function WaitsBlock(env, timeout, spec) {
		  this.timeout = timeout;
		  super(env, null, spec);
		};
		
		jasmine.WaitsBlock = WaitsBlock;
		
		jasmine.WaitsBlock.prototype.execute = function (onComplete) {
		  this.env.reporter.log('>> Jasmine waiting for ' + this.timeout + ' ms...');
		  this.env.setTimeout(function () {
		    onComplete();
		  }, this.timeout);
		};
	}
}
