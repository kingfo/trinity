package org.jasmineflex.flexreporter
{
	import mx.binding.utils.BindingUtils;
	import mx.collections.ArrayList;
	
	import org.jasmineflex.Spec;
	import org.jasmineflex.Suite;

	[Bindable]
	public class ReporterResult
	{
		public var id;
		public var description:String;
		public var children:ArrayList = new ArrayList();
		public var result:String;
		public var messages:ArrayList = new ArrayList();
		public var show:Boolean = false;
		
		private var suiteOrSpec:*;
		
		public function ReporterResult(suiteOrSpec:*) {
			this.suiteOrSpec = suiteOrSpec;
			this.id = suiteOrSpec.id;
			this.description = suiteOrSpec.description;
		}
		
		public function get isSuite():Boolean { return suiteOrSpec is Suite; }
		public function get isSpec():Boolean { return suiteOrSpec is Spec; }
		
		public function showPassed(showPassed:Boolean):void {
			this.show = result == "failed" || showPassed;
			for each(var child:ReporterResult in children.source) {
				child.showPassed(showPassed);
			}
		}
	}
}