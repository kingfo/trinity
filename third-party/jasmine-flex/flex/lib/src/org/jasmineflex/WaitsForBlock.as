package org.jasmineflex
{
	public dynamic class WaitsForBlock extends Block
	{
		/**
		 * A block which waits for some condition to become true, with timeout.
		 *
		 * @constructor
		 * @extends jasmine.Block
		 * @param {jasmine.Env} env The Jasmine environment.
		 * @param {Number} timeout The maximum time in milliseconds to wait for the condition to become true.
		 * @param {Function} latchFunction A function which returns true when the desired condition has been met.
		 * @param {String} message The message to display if the desired condition hasn't been met within the given time period.
		 * @param {jasmine.Spec} spec The Jasmine spec.
		 */
		//jasmine.WaitsForBlock = function(env, timeout, latchFunction, message, spec) {
		public function WaitsForBlock(env, timeout, latchFunction, message, spec)
		{
		  this.timeout = timeout || env.defaultTimeoutInterval;
		  this.latchFunction = latchFunction;
		  this.message = message;
		  this.totalTimeSpentWaitingForLatch = 0;
		  
		  super(env, null, spec);
		};
		
		
		jasmine.WaitsForBlock = WaitsForBlock;

		jasmine.WaitsForBlock.TIMEOUT_INCREMENT = 10;
		
		jasmine.WaitsForBlock.prototype.execute = function(onComplete) {
		  this.env.reporter.log('>> Jasmine waiting for ' + (this.message || 'something to happen'));
		  var latchFunctionResult;
		  try {
		    latchFunctionResult = this.latchFunction.apply(this.spec);
		  } catch (e) {
		    this.spec.fail(e);
		    onComplete();
		    return;
		  }
		
		  if (latchFunctionResult) {
		    onComplete();
		  } else if (this.totalTimeSpentWaitingForLatch >= this.timeout) {
		    var message = 'timed out after ' + this.timeout + ' msec waiting for ' + (this.message || 'something to happen');
		    this.spec.fail({
		      name: 'timeout',
		      message: message
		    });
		
		    this.abort = true;
		    onComplete();
		  } else {
		    this.totalTimeSpentWaitingForLatch += jasmine.WaitsForBlock.TIMEOUT_INCREMENT;
		    var self = this;
		    this.env.setTimeout(function() {
		      self.execute(onComplete);
		    }, jasmine.WaitsForBlock.TIMEOUT_INCREMENT);
		  }
		};
		
	}
}