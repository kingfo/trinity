﻿package asunit.support {

	import asunit.asserts.*;

	import flash.display.Sprite;

	public class OrderedTestMethod {
		
		public var methodsCalled:Array = [];
	
		public function OrderedTestMethod() {
		}
		
		// Method names are chosen to avoid coinciding with alphabetical order.
		
		[Test(order=2)]
		public function two():void {
			methodsCalled.push(arguments.callee);
		}
		
		[Test(order=3)]
		public function three():void {
			methodsCalled.push(arguments.callee);
		}
		
		[Test]
		public function zeroIsDefaultOrder():void {
			methodsCalled.push(arguments.callee);
		}
		
		[Test(order=-1)]
		public function negativeOrderIsAllowed():void {
			methodsCalled.push(arguments.callee);
		}
	}
}
