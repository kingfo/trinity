package org.jasmineflex
{
	public dynamic class StringPrettyPrinter extends PrettyPrinter
	{
		public function StringPrettyPrinter()
		{
			this.string = '';
		};
		
		jasmine.StringPrettyPrinter = StringPrettyPrinter;
		
		jasmine.StringPrettyPrinter.prototype.emitScalar = function(value) {
			this.append(value);
		};
		
		jasmine.StringPrettyPrinter.prototype.emitString = function(value) {
			this.append("'" + value + "'");
		};
		
		jasmine.StringPrettyPrinter.prototype.emitArray = function(array) {
			this.append('[ ');
			for (var i = 0; i < array.length; i++) {
				if (i > 0) {
					this.append(', ');
				}
				this.format(array[i]);
			}
			this.append(' ]');
		};
		
		jasmine.StringPrettyPrinter.prototype.emitObject = function(obj) {
			var self = this;
			this.append('{ ');
			var first = true;
			
			this.iterateObject(obj, function(property, isGetter) {
				if (first) {
					first = false;
				} else {
					self.append(', ');
				}
				
				self.append(property);
				self.append(' : ');
				if (isGetter) {
					self.append('<getter>');
				} else {
					self.format(obj[property]);
				}
			});
			
			this.append(' }');
		};
		
		jasmine.StringPrettyPrinter.prototype.append = function(value) {
			this.string += value;
		};
	}
}