package org.jasmineflex.flexreporter
{
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	
	import org.jasmineflex.Reporter;
	import org.jasmineflex.Runner;
	import org.jasmineflex.Spec;
	import org.jasmineflex.Suite;
	import org.jasmineflex.jasmine;
	
	[Bindable]
	public dynamic class TrivialFlexReporter extends Reporter
	{
		public var suites:ArrayList = new ArrayList();
		public var version:String = jasmine.getEnv().versionString();
		public var resultsMessage:String = "Initializing...";
		public var endTime:String;
		public var overallSuccess:String;
		
		public function TrivialFlexReporter()
		{
			this.reportRunnerStarting = function(runner) {
				//this.runnerStartTime = this.now();
				started(runner);
			};
			
			this.reportRunnerResults = function(runner:Runner) {
				
				var results = runner.results();
				var specs = runner.specs();
				
				var specCount = 0;
				for (var i = 0; i < specs.length; i++) {
					if (this.specFilter(specs[i])) {
						specCount++;
					}
				}
				
				var message = "" + specCount + " spec" + (specCount == 1 ? "" : "s" ) + ", " + results.failedCount + " failure" + ((results.failedCount == 1) ? "" : "s");
				message += " in " + ((new Date().getTime() - this.startedAt.getTime()) / 1000) + "s";
				
				resultsMessage = message;
				endTime = "Finished at " + new Date().toString();
				overallSuccess = results.failedCount == 0 ? "passed" : "failed";
			}
			
			this.reportSpecResults = function(spec:Spec) {
				var results:ReporterResult = findResult(suites.source, spec.id, false);
				results.result = spec.results().passed() ? "passed" : "failed";
				results.show = !spec.results().passed();
				
				if(!spec.results().passed())
					overallSuccess = "failed";
				
				for each(var message in spec.results().getItems()) {
					if(message.type == "log") {
						results.messages.addItem(message.toString());
					} else if (message.type == "expect" && !message.passed()) {
						results.messages.addItem(message);
					}
				}
			}
			
			this.reportSuiteResults = function(suite:Suite) {
				var results:ReporterResult = findResult(suites.source, suite.id);
				results.result = suite.results().passed() ? "passed" : "failed";
				results.show = !suite.results().passed();
			}
				
			this.specFilter = function(spec) {
				//var paramMap = {};
				//var params = this.getLocation().search.substring(1).split('&');
				//for (var i = 0; i < params.length; i++) {
				//	var p = params[i].split('=');
				//	paramMap[decodeURIComponent(p[0])] = decodeURIComponent(p[1]);
				//}
				
				//if (!paramMap.spec) {
				//	return true;
				//}
				//return spec.getFullName().indexOf(paramMap.spec) === 0;
				return true;
			};
				
		}
		
		
		private function started(runner:Runner) {
			overallSuccess = "running";
			resultsMessage = "Running...";
			endTime = "";
			
			for each(var suite in runner.suites()) {
				
				var reporterResult:ReporterResult = new ReporterResult(suite);
				
				if(suite.parentSuite == null) {
					suites.addItem(reporterResult);
				}
				else {
					var parent:ReporterResult = findResult(suites.source, suite.parentSuite.id);
					parent.children.addItem(reporterResult);
				}
				
				for each(var spec:Spec in suite.specs()) {
					reporterResult.children.addItem(new ReporterResult(spec));
				}
			}
			
			this.startedAt = new Date();
		}
		
		
		private function findResult(items:Array, id:int, isSuite:Boolean=true) : ReporterResult {
			for each(var item:ReporterResult in items) {
				if(item.isSuite == isSuite && item.id == id) {
					return item;
				}
				
				var found:ReporterResult = findResult(item.children.source, id, isSuite);
				if(found)
					return found;
			}
			
			return null;
		}
		
		public function showPassed(show:Boolean):void {
			for each(var suite:ReporterResult in suites.source) {
				suite.showPassed(show);
			}
		}
		
	}
}