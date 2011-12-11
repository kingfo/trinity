package org.jasmineflex
{
	public const jasmine = new Base().jasmine;
	jasmine.Queue = Queue;
	jasmine.Runner = Runner;
	jasmine.Reporter = Reporter;
	jasmine.MultiReporter = MultiReporter;
	jasmine.Matchers = Matchers;
	jasmine.Env = Env;
	jasmine.Suite = Suite;
	jasmine.Spec = Spec;
	jasmine.NestedResults = NestedResults;
	jasmine.Block = Block;
	jasmine.StringPrettyPrinter = StringPrettyPrinter;
	jasmine.FakeTimer = FakeTimer;
	jasmine.WaitsBlock = WaitsBlock;
	jasmine.WaitsForBlock = WaitsForBlock;
	jasmine.ApiReporter = ApiReporter;
	jasmine.TrivialConsoleReporter = TrivialConsoleReporter;
	new util();
	new Clock();
	jasmine.version_= {
		"major": 1,
		"minor": 0,
		"build": 2,
		"revision": 1299565706
	};
	
}