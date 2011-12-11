// Mock setTimeout, clearTimeout
// Contributed by Pivotal Computer Systems, www.pivotalsf.com

package org.jasmineflex
{
	public dynamic class FakeTimer
	{
		public function FakeTimer()
		{
			this.reset();

			var self = this;
			self.setTimeout = function(funcToCall, millis) {
			  self.timeoutsMade++;
			  self.scheduleFunction(self.timeoutsMade, funcToCall, millis, false);
			  return self.timeoutsMade;
			};
			
			self.setInterval = function(funcToCall, millis) {
			  self.timeoutsMade++;
			  self.scheduleFunction(self.timeoutsMade, funcToCall, millis, true);
			  return self.timeoutsMade;
			};
			
			self.clearTimeout = function(timeoutKey) {
			  self.scheduledFunctions[timeoutKey] = jasmine.undefined;
			};
			
			self.clearInterval = function(timeoutKey) {
			  self.scheduledFunctions[timeoutKey] = jasmine.undefined;
			};
			
		};

		jasmine.FakeTimer = FakeTimer;
		
		jasmine.FakeTimer.prototype.reset = function() {
		  this.timeoutsMade = 0;
		  this.scheduledFunctions = {};
		  this.nowMillis = 0;
		};
		
		jasmine.FakeTimer.prototype.tick = function(millis) {
		  var oldMillis = this.nowMillis;
		  var newMillis = oldMillis + millis;
		  this.runFunctionsWithinRange(oldMillis, newMillis);
		  this.nowMillis = newMillis;
		};
		
		jasmine.FakeTimer.prototype.runFunctionsWithinRange = function(oldMillis, nowMillis) {
		  var scheduledFunc;
		  var funcsToRun = [];
		  for (var timeoutKey in this.scheduledFunctions) {
		    scheduledFunc = this.scheduledFunctions[timeoutKey];
		    if (scheduledFunc != jasmine.undefined &&
		        scheduledFunc.runAtMillis >= oldMillis &&
		        scheduledFunc.runAtMillis <= nowMillis) {
		      funcsToRun.push(scheduledFunc);
		      this.scheduledFunctions[timeoutKey] = jasmine.undefined;
		    }
		  }
		
		  if (funcsToRun.length > 0) {
		    funcsToRun.sort(function(a, b) {
		      return a.runAtMillis - b.runAtMillis;
		    });
		    for (var i = 0; i < funcsToRun.length; ++i) {
		      try {
		        var funcToRun = funcsToRun[i];
		        this.nowMillis = funcToRun.runAtMillis;
		        funcToRun.funcToCall();
		        if (funcToRun.recurring) {
		          this.scheduleFunction(funcToRun.timeoutKey,
		              funcToRun.funcToCall,
		              funcToRun.millis,
		              true);
		        }
		      } catch(e) {
		      }
		    }
		    this.runFunctionsWithinRange(oldMillis, nowMillis);
		  }
		};
		
		jasmine.FakeTimer.prototype.scheduleFunction = function(timeoutKey, funcToCall, millis, recurring) {
		  this.scheduledFunctions[timeoutKey] = {
		    runAtMillis: this.nowMillis + millis,
		    funcToCall: funcToCall,
		    recurring: recurring,
		    timeoutKey: timeoutKey,
		    millis: millis
		  };
		};
	}
}


