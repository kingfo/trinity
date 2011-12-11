package org.jasmineflex
{
	public dynamic class Clock
	{
		public function Clock()
		{
			this.defaultFakeTimer = new jasmine.FakeTimer();
			
			this.reset = function() {
				jasmine.Clock.assertInstalled();
				jasmine.Clock.defaultFakeTimer.reset();
			};
			
			this.tick =  function(millis) {
				jasmine.Clock.assertInstalled();
				jasmine.Clock.defaultFakeTimer.tick(millis);
			};
			
			this.runFunctionsWithinRange = function(oldMillis, nowMillis) {
				jasmine.Clock.defaultFakeTimer.runFunctionsWithinRange(oldMillis, nowMillis);
			};
			
			this.scheduleFunction = function(timeoutKey, funcToCall, millis, recurring) {
				jasmine.Clock.defaultFakeTimer.scheduleFunction(timeoutKey, funcToCall, millis, recurring);
			};
			
			this.useMock = function() {
				if (!jasmine.Clock.isInstalled()) {
					var spec = jasmine.getEnv().currentSpec;
					spec.after(jasmine.Clock.uninstallMock);
					
					jasmine.Clock.installMock();
				}
			};
			
			this.installMock = function() {
				jasmine.Clock.installed = jasmine.Clock.defaultFakeTimer;
			};
			
			this.uninstallMock = function() {
				jasmine.Clock.assertInstalled();
				jasmine.Clock.installed = jasmine.Clock.real;
			};
			
			this.real = {
				setTimeout: jasmine.setTimeout,
					clearTimeout: jasmine.clearTimeout,
					setInterval: jasmine.setInterval,
					clearInterval: jasmine.clearInterval
			};
			
			this.assertInstalled = function() {
				if (!jasmine.Clock.isInstalled()) {
					throw new Error("Mock clock is not installed, use jasmine.Clock.useMock()");
				}
			};
			
			this.isInstalled = function() {
				return jasmine.Clock.installed == jasmine.Clock.defaultFakeTimer;
			};
			
			this.installed = null
		};
		
		jasmine.Clock = new Clock();
		jasmine.Clock.installed = jasmine.Clock.real;
		
		//else for IE support
		jasmine.setTimeout = function(funcToCall, millis) {
			if (jasmine.Clock.installed.setTimeout.apply) {
				return jasmine.Clock.installed.setTimeout.apply(this, arguments);
			} else {
				return jasmine.Clock.installed.setTimeout(funcToCall, millis);
			}
		};
		
		jasmine.setInterval = function(funcToCall, millis) {
			if (jasmine.Clock.installed.setInterval.apply) {
				return jasmine.Clock.installed.setInterval.apply(this, arguments);
			} else {
				return jasmine.Clock.installed.setInterval(funcToCall, millis);
			}
		};
		
		jasmine.clearTimeout = function(timeoutKey) {
			if (jasmine.Clock.installed.clearTimeout.apply) {
				return jasmine.Clock.installed.clearTimeout.apply(this, arguments);
			} else {
				return jasmine.Clock.installed.clearTimeout(timeoutKey);
			}
		};
		
		jasmine.clearInterval = function(timeoutKey) {
			if (jasmine.Clock.installed.clearTimeout.apply) {
				return jasmine.Clock.installed.clearInterval.apply(this, arguments);
			} else {
				return jasmine.Clock.installed.clearInterval(timeoutKey);
			}
		};
	}
}