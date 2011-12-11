package org.jasmineflex
{
	public dynamic class TrivialTraceReporter extends TrivialConsoleReporter
	{
		public function TrivialTraceReporter(doneCallback = null, dumpStack=false)
		{
			super(bufferedPrint, doneCallback, false, dumpStack);
		}
		
		private var stringBuffer = "";
		
		private function bufferedPrint(str:String) {
			if(str == "\n") {
				trace(stringBuffer);
				stringBuffer = "";
			} else {
				stringBuffer += str;
			}
		}
		
	}
}