package as3utils.timer {
	import flash.utils.clearInterval;
	import flash.utils.clearTimeout;
	import flash.utils.setInterval;
	import flash.utils.setTimeout;
	/**
	 * ...
	 * @author Kingfo[Telds longzang]
	 */
	
	 /**
	  * Executes the supplied function in the context of the supplied
	  * object 'when' milliseconds later. Executes the function a
	  * single time unless periodic is set to true.
	  * @param	fn				the function to execute or the name of the method in the 'o' object to execute.
	  * @param	when			the number of milliseconds to wait until the fn is executed.
	  * @param	periodic		if true, executes continuously at supplied interval until canceled. default false.
	  * @param	o				the context object.
	  * @param	data			that is provided to the function. This accepts either a single
	  * 						 item or an array. If an array is provided, the function is executed wit
	  * 						 one parameter for each array item. If you need to pass a single array
	  * 						 parameter, it needs to be wrapped in an array [myarray].
	  * @return					a timer object. Call the cancel() method on this object to stop the timer.
	  */
	public function later(fn: *, when: Number = 0, periodic: Boolean = false, o:*=null, data: Array = null):Object {
		o = o || { };
		var m:Function = fn as Function, d:Array = data, f:Function, r:*;

		if (fn is String) {
			m = o[fn];
		}

		if (!(m is Function)) {
			throw new Error('method undefined');
		}

		f = function():void {
			m.apply(o, d);
		};

		r = (periodic) ? setInterval(f, when) : setTimeout(f, when);

		return {
			id: r,
			interval: periodic,
			cancel: function():void {
				if (this.interval) {
					clearInterval(r);
				} else {
					clearTimeout(r);
				}
			}
		};	
	}

}