package org.jasmineflex
{
	public dynamic class PrettyPrinter
	{
		/**
		 * Base class for pretty printing for expectation results.
		 */
		//jasmine.PrettyPrinter = function() {
		public function PrettyPrinter()
		{
		  this.ppNestLevel_ = 0;
		  
		  this.visitedObjects = [];
		};
		
		jasmine.PrettyPrinter = PrettyPrinter;
		
		jasmine.PrettyPrinter.prototype.objectHasBeenFormatted = function(obj) {
			
			for each(var item in this.visitedObjects)
			    if(item.obj === obj)
					return item.visited;
				
			return false;
		}
			
		jasmine.PrettyPrinter.prototype.markObjectAsFormatted = function(obj, mark) {
			if(mark) {
				this.visitedObjects.push({obj: obj, visited: true});
			} else {
				for each(var item in this.visitedObjects) {
				    if(item.obj === obj) {
						item.value = false;
					}
				}
			}
		}
		
		/**
		 * Formats a value in a nice, human-readable string.
		 *
		 * @param value
		 */
		jasmine.PrettyPrinter.prototype.format = function(value) {
		  if (this.ppNestLevel_ > 40) {
		    throw new Error('jasmine.PrettyPrinter: format() nested too deeply!');
		  }
		
		  this.ppNestLevel_++;
		  try {
		    if (value === jasmine.undefined) {
		      this.emitScalar('undefined');
		    } else if (value === null) {
		      this.emitScalar('null');
		    } else if (value === jasmine.getGlobal()) {
		      this.emitScalar('<global>');
		    } else if (value instanceof jasmine.Matchers.Any) {
		      this.emitScalar(value.toString());
		    } else if (typeof value === 'string') {
		      this.emitString(value);
		    } else if (jasmine.isSpy(value)) {
		      this.emitScalar("spy on " + value.identity);
		    } else if (value instanceof RegExp) {
		      this.emitScalar(value.toString());
		    } else if (typeof value === 'function') {
		      this.emitScalar('Function');
		    } else if ("nodeType" in value && typeof value.nodeType === 'number') {
		      this.emitScalar('HTMLNode');
		    } else if (value instanceof Date) {
		      this.emitScalar('Date(' + value + ')');
		    } else if (this.objectHasBeenFormatted(value)) {
		      this.emitScalar('<circular reference: ' + (jasmine.isArray_(value) ? 'Array' : 'Object') + '>');
		    } else if (jasmine.isArray_(value) || typeof value == 'object') {
		      this.markObjectAsFormatted(value, true);
		      if (jasmine.isArray_(value)) {
		        this.emitArray(value);
		      } else {
		        this.emitObject(value);
		      }
			  this.markObjectAsFormatted(value, false);
		    } else {
		      this.emitScalar(value.toString());
		    }
		  } finally {
		    this.ppNestLevel_--;
		  }
		};
		
		jasmine.PrettyPrinter.prototype.iterateObject = function(obj, fn) {
		  for (var property in obj) {
		    fn(property, obj.__lookupGetter__ ? (obj.__lookupGetter__(property) !== jasmine.undefined && 
		                                         obj.__lookupGetter__(property) !== null) : false);
		  }
		};
		
		jasmine.PrettyPrinter.prototype.emitArray = jasmine.unimplementedMethod_;
		jasmine.PrettyPrinter.prototype.emitObject = jasmine.unimplementedMethod_;
		jasmine.PrettyPrinter.prototype.emitScalar = jasmine.unimplementedMethod_;
		jasmine.PrettyPrinter.prototype.emitString = jasmine.unimplementedMethod_;
	}
}
