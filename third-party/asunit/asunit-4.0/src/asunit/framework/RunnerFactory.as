package asunit.framework {

    import asunit.errors.UsageError;
    import asunit.runners.LegacyRunner;
    import asunit.runners.TestRunner;
    import asunit.runners.SuiteRunner;

    import flash.utils.getDefinitionByName;

    import p2.reflect.Reflection;
    import p2.reflect.ReflectionMetaData;
    import org.swiftsuspenders.Injector;

	public class RunnerFactory implements IRunnerFactory {

        public static var DEFAULT_SUITE_RUNNER:Class = SuiteRunner;
		public static var DEFAULT_TEST_RUNNER:Class = TestRunner;

        /**
         * The DefaultTestRunner will be updated whenever
         * a TestSuite is encountered that has a [RunWith]
         * declaration.
         *
         * All subsequent create calls for a Test that
         * don't have a RunWith will use the IRunner that
         * was defined on the Suite.
         *
         */
        public var DefaultTestRunner:Class;

        /**
         * The DefaultSuiteRunner is what
         * we use for all TestSuites
         */
        public var DefaultSuiteRunner:Class;
		
        public function RunnerFactory(injector:Injector = null) {
            DefaultSuiteRunner = DEFAULT_SUITE_RUNNER;
            DefaultTestRunner  = DEFAULT_TEST_RUNNER;
            this.injector = injector || new Injector();
        }
		
		private var _injector:Injector;
		
		public function get injector():Injector
		{
			return _injector;
		}
		
		public function set injector(value:Injector):void
		{
			_injector = value;
		}
		
        /**
         * runnerFor is the primary inerface to the RunnerFactory
         */
        public function runnerFor(testOrSuite:Class):IRunner {
            //trace(">> runnerFor: " + testOrSuite + " with current default of: " + DefaultTestRunner);
            validate(testOrSuite);
            return getRunnerForTestOrSuite(testOrSuite);
        }

        protected function validate(testOrSuite:Class):void {
            if(testOrSuite == null) {
                throw new UsageError("RunnerFactory.runnerFor must be provided with a known test or suite class");
            }
        }

        protected function getRunnerForTestOrSuite(testOrSuite:Class):IRunner {
            var reflection:Reflection = Reflection.create(testOrSuite);
            if(RunnerFactory.isSuite(reflection)) {
                return getRunnerForSuite(reflection);
            }
            else if(RunnerFactory.isLegacyTest(reflection)) {
                return getLegacyRunnerForTest(reflection);
            }
            else if(RunnerFactory.isTest(reflection)) {
                return getRunnerForTest(reflection);
            }

            throw new UsageError("RunnerFactory was asked for a Runner, but was not able to identify: " + reflection.name + " as a LegacyTest, Test or Suite.");
            return null;
        }

        protected function getRunnerForSuite(reflection:Reflection):IRunner {
            // Use the provided RunWith class, or the DefaultSuiteRunner
            var Constructor:Class = getRunWithConstructor(reflection) || DefaultSuiteRunner;
            var runner:IRunner = injector.instantiate(Constructor);
            return runner;
        }

        protected function getLegacyRunnerForTest(reflection:Reflection):IRunner {
            var runner:IRunner = injector.instantiate(LegacyRunner);
            return runner;
        }

        protected function getRunnerForTest(reflection:Reflection):IRunner {
            // Use the provided RunWith class, or the DefaultTestRunner
            var Constructor:Class = getRunWithConstructor(reflection) || DefaultTestRunner;
            var runner:IRunner = injector.instantiate(Constructor);
            return runner;
        }

        protected function getRunWithConstructor(reflection:Reflection):Class {
            var runWith:ReflectionMetaData = getRunWithDeclaration(reflection);

            if(runWith) {
                if(runWith.args.length == 0) {
                    throw new UsageError("Encountered [RunWith] declaration that's missing the class argument. Try [RunWith(my.class.Name)] instead.");
                }
                try {
                    var className:String = runWith.args[0];
                    return getDefinitionByName(className) as Class;
                }
                catch(e:ReferenceError) {
                    var message:String = "Encountered [RunWith] declaration but cannot instantiate the provided runner. " + className + ". ";
                    message += "Is there an actual reference to this class somewhere in your project?";
                    throw new UsageError(message);
                }
            }

            return null;
        }
		
		protected function getRunWithDeclaration(reflection:Reflection):ReflectionMetaData {
		    var result:ReflectionMetaData = reflection.getMetaDataByName('RunWith');
		    if(result) {
		        return result;
	        }
		    
		    var baseClass:*;
		    var baseClassReflection:Reflection;
		    var len:int = reflection.extendedClasses.length;
		    for(var i:int; i < len; i++) {
		        baseClass = getDefinitionByName(reflection.extendedClasses[i]);
		        baseClassReflection = Reflection.create(baseClass);
		        result = baseClassReflection.getMetaDataByName('RunWith');
		        if(result) {
		            return result;
	            }
	        }
	        return null;
	    }

		public static function isSuite(reflection:Reflection):Boolean {
            return (reflection.getMetaDataByName('Suite') != null);
		}

        public static function isLegacyTest(reflection:Reflection):Boolean {
            return reflection.isA('asunit.framework.TestCase');
        }

        public static function isTest(reflection:Reflection):Boolean {
            var testMethods:Array = reflection.getMethodsByMetaData('Test');
            var runWith:ReflectionMetaData = reflection.getMetaDataByName('RunWith');
            return (runWith != null || testMethods.length > 0);
        }
	}
}