package org.jasmineflex 
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	

	public dynamic class TrivialCommandLineReporter extends TrivialConsoleReporter
	{
		private var stdout:FileStream = new FileStream();
		
		public function TrivialCommandLineReporter(doneCallback:*=null, dumpStack:*=false)
		{
			stdout.open(new File("/dev/fd/1"), FileMode.APPEND);
			
			var print = function(str) { stdout.writeMultiByte(str, "us-ascii")}; 
			
			var completed = function() 
			{ 
				try {
					stdout.close(); 
				} catch(e) {}
				
				if(doneCallback)
					doneCallback();
			};
			
			
			super(print, completed, true, dumpStack);
		}
	}
}