package org.jasmineflex
{
	public dynamic class Block
	{
		
		/**
		 * Blocks are functions with executable code that make up a spec.
		 *
		 * @constructor
		 * @param {jasmine.Env} env
		 * @param {Function} func
		 * @param {jasmine.Spec} spec
		 */
		//jasmine.Block = function(env, func, spec) {
		public function Block(env, func, spec=null)
		{
		  this.env = env;
		  this.func = func;
		  this.spec = spec;
		};
		
		jasmine.Block = Block;

		jasmine.Block.prototype.execute = function(onComplete) {  
		  try {
		    this.func.apply(this.spec);
		  } catch (e) {
		    this.spec.fail(e);
		  }
		  onComplete();
		};
		
	}
}