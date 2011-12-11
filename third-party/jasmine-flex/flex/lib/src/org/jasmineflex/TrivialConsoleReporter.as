package org.jasmineflex
{

	public dynamic class TrivialConsoleReporter extends Reporter
	{
		
		public function TrivialConsoleReporter(print=null, doneCallback = null, colorized=true, dumpStack=false) 
		{
			this.dumpStack = dumpStack;
			doneCallback = doneCallback || function(){};
			
			var esc = String.fromCharCode(27);
			
			var defaultColumnsPerLine = 50,
				ansi = { green:  esc + '[32m', red: esc+'[31m', yellow: esc+'[33m', none: esc+'[0m' },
				language = { spec:"spec", expectation:"expectation", failure:"failure" };
			
			function coloredStr(color, str) { 
				return colorized ? ansi[color] + str + ansi.none : str; 
			}
			
			function greenStr(str)  { return coloredStr("green", str); }
			function redStr(str)    { return coloredStr("red", str); }
			function yellowStr(str) { return coloredStr("yellow", str); }
			
			function newline() { print("\n"); }
			
			function started()         { print("Started"); 
				newline(); }
			
			function greenDot()        { print(greenStr(".")); }
			function redF()            { print(redStr("F")); }
			function yellowStar()      { print(yellowStr("*")); }
			
			function plural(str, count) { return count == 1 ? str : str + "s"; }
			
			function repeat(thing, times) { var arr = [];
				for(var i=0; i<times; i++) arr.push(thing);
				return arr;
			}
			
			function indent(str, spaces) { var lines = str.split("\n");
				var newArr = [];
				for(var i=0; i<lines.length; i++) {
					newArr.push(repeat(" ", spaces).join("") + lines[i]);
				}
				return newArr.join("\n");
			}
			
			function specFailureDetails(suiteDescription, specDescription, stackTraces)  { 
				newline(); 
				print(suiteDescription + " " + specDescription); 
				newline();
				for(var i=0; i<stackTraces.length; i++) {
					print(indent(stackTraces[i], 2));
					newline();
				}
			}
			function finished(elapsed)  { newline(); 
				print("Finished in " + elapsed/1000 + " seconds"); }
			function summary(colorF, specs, expectations, failed)  { newline();
				print(colorF(specs + " " + plural(language.spec, specs) + ", " +
					expectations + " " + plural(language.expectation, expectations) + ", " +
					failed + " " + plural(language.failure, failed))); 
				newline();
				newline(); }
			function greenSummary(specs, expectations, failed){ summary(greenStr, specs, expectations, failed); }
			function redSummary(specs, expectations, failed){ summary(redStr, specs, expectations, failed); }
			
			
			
			
			function lineEnder(columnsPerLine) {
				var columnsSoFar = 0;
				return function() {
					columnsSoFar += 1;
					if (columnsSoFar == columnsPerLine) {
						newline();
						columnsSoFar = 0;
					}
				};
			}
			
			function fullSuiteDescription(suite) {
				var fullDescription = suite.description;
				if (suite.parentSuite) fullDescription = fullSuiteDescription(suite.parentSuite) + " " + fullDescription ;
				return fullDescription;
			}
			
			var startNewLineIfNecessary = lineEnder(defaultColumnsPerLine);
			
			this.now = function() { return new Date().getTime(); };
			
			this.reportRunnerStarting = function() {
				this.runnerStartTime = this.now();
				started();
			};
			
			this.reportSpecStarting = function() { /* do nothing */ };
			
			this.reportSpecResults = function(spec) {
				var results = spec.results();
				if (results.skipped) {
					yellowStar();
				} else if (results.passed()) {
					greenDot();
				} else {
					redF();
				} 
				startNewLineIfNecessary();   
			};
			
			this.suiteResults = [];
			
			this.reportSuiteResults = function(suite) {
				var suiteResult = {
					description: fullSuiteDescription(suite),
					failedSpecResults: []
				};
				
				suite.results().items_.forEach(function(spec){
					if (spec.failedCount > 0 && spec.description) suiteResult.failedSpecResults.push(spec);
				});
				
				this.suiteResults.push(suiteResult);
			};
			
			function getStackTrace(failedSpecResult, k) {
				
				var trace = failedSpecResult.items_[k].trace;
				
				if(dumpStack)
					return trace.getStackTrace();
				
				if("stack" in trace)
					return trace.stack;
				
				if("message" in trace)
					return trace.message;
				
				return "no trace found"
			}
			
			function eachSpecFailure(suiteResults, callback) {
				for(var i=0; i<suiteResults.length; i++) {
					var suiteResult = suiteResults[i];
					for(var j=0; j<suiteResult.failedSpecResults.length; j++) {
						var failedSpecResult = suiteResult.failedSpecResults[j];
						var stackTraces = [];
						
						for(var k=0; k<failedSpecResult.items_.length; k++) {
							stackTraces.push(getStackTrace(failedSpecResult, k));
						}

						callback(suiteResult.description, failedSpecResult.description, stackTraces);
					}
				}
			}
			
			this.reportRunnerResults = function(runner) {
				newline();
				
				eachSpecFailure(this.suiteResults, function(suiteDescription, specDescription, stackTraces) {
					specFailureDetails(suiteDescription, specDescription, stackTraces);
				});
				
				finished(this.now() - this.runnerStartTime);
				
				var results = runner.results();
				var summaryFunction = results.failedCount === 0 ? greenSummary : redSummary;
				summaryFunction(results.items_.length, results.totalCount, results.failedCount);
				doneCallback(runner);
			};
		};
		
	}
}
