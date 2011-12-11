package asunit.runners {
	
	import asunit.framework.CallbackBridge;
	import asunit.framework.IRunner;
	import asunit.framework.IRunnerFactory;
	import asunit.framework.RunnerFactory;
	import asunit.framework.SuiteIterator;
	import asunit.util.Iterator;

	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
    
    public class SuiteRunner implements IEventDispatcher, IRunner {

        protected var dispatcher:IEventDispatcher;
        protected var testClasses:Iterator;
        protected var timer:Timer;
        protected var visualContext:DisplayObjectContainer;
        protected var testMethod:String;

        private var factory:IRunnerFactory;
        
        public function SuiteRunner(factory:IRunnerFactory = null) {
            timer      = new Timer(0, 1);
            dispatcher = new EventDispatcher();
			this.factory = factory || new RunnerFactory();
        }
        
        public function run(suite:Class, testMethod:String=null, visualContext:DisplayObjectContainer=null):void {
            this.visualContext = visualContext;
            this.testMethod = testMethod;
            runSuite(suite);
        }

        protected function runSuite(suite:*):void {
            testClasses = new SuiteIterator(suite);
            timer.addEventListener(TimerEvent.TIMER, runNextTest);
            
            runNextTest();
        }
        
        protected function runNextTest(e:TimerEvent = null):void{
            if (!testClasses.hasNext()) {
                onSuiteCompleted();
                return;
            }
            
            var testClass:Class = testClasses.next();
            // [luke] TODO: This runnerFor call can throw exceptions,
            // we need to handle them in some way.
            var runner:IRunner = factory.runnerFor(testClass);
            runner.addEventListener(Event.COMPLETE, onTestCompleted);
            // [luke] TODO: There should be a clear search,
            // and clear failure when testMethod is provided,
            // but not found...
            runner.run(testClass, testMethod, visualContext);
        }
        
        protected function onTestCompleted(e:Event):void {
            e.target.removeEventListener(Event.COMPLETE, onTestCompleted);
            // Start a new green thread.
            timer.reset();
            timer.start();
        }
        
        protected function onSuiteCompleted():void {
            timer.removeEventListener(TimerEvent.TIMER, runNextTest);
            dispatchEvent(new Event(Event.COMPLETE));
        }

        /**
         * Template method that subclasses can override to perform some
         * operation when the run is complete.
         */
        protected function onRunCompleted():void {
        }

        // BEGIN: Implement the IEvent Dispatcher Interface:

        public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void {
            dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
        }
        
        public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void {
            dispatcher.removeEventListener(type, listener, useCapture);
        }
        
        public function dispatchEvent(event:Event):Boolean {
            return dispatcher.dispatchEvent(event);
        }
        
        public function hasEventListener(type:String):Boolean {
            return dispatcher.hasEventListener(type);
        }
        
        public function willTrigger(type:String):Boolean {
            return dispatcher.willTrigger(type);
        }

        // END: Implement the IEvent Dispatcher Interface:
    }
}
