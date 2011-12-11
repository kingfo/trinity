﻿package asunit.framework {

	public interface IResult extends IRunListener, ITestListener {
		
		function addListener(listener:IRunListener):void;
		function removeListener(listener:IRunListener):void;

        function addObserver(observer:TestObserver):void;
		
		function get errors():Array;
		function get errorCount():uint;
		
		function get failures():Array;
		function get failureCount():uint;
		
		function get successes():Array;
		function get successCount():uint;

        function get warnings():Array;
		
		function get ignoredTests():Array;
		function get ignoredTestCount():uint;
		
		function get runCount():uint;
		
        function get failureEncountered():Boolean;
		function get wasSuccessful():Boolean;
		
		function get runTime():Number;
		function set runTime(value:Number):void;
	}
}

