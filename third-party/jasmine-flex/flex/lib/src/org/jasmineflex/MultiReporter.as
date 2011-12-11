/**
 * @constructor
 */
//jasmine.MultiReporter = function() {
package org.jasmineflex
{
	public dynamic class MultiReporter extends Reporter
	{
		public function MultiReporter()
		{
			this.subReporters_ = [];	
		}
		
		//jasmine.util.inherit(jasmine.MultiReporter, jasmine.Reporter);

		jasmine.MultiReporter = MultiReporter;
		jasmine.MultiReporter.prototype.addReporter = function(reporter) {
		  this.subReporters_.push(reporter);
		};
		
		(function() {
		  var functionNames = [
		    "reportRunnerStarting",
		    "reportRunnerResults",
		    "reportSuiteResults",
		    "reportSpecStarting",
		    "reportSpecResults",
		    "log"
		  ];
		  for (var i = 0; i < functionNames.length; i++) {
		    var functionName = functionNames[i];
		    jasmine.MultiReporter.prototype[functionName] = (function(functionName) {
		      return function() {
		        for (var j = 0; j < this.subReporters_.length; j++) {
		          var subReporter = this.subReporters_[j];
		          if (subReporter[functionName]) {
		            subReporter[functionName].apply(subReporter, arguments);
		          }
		        }
		      };
		    })(functionName);
		  }
		})();
	}
}
