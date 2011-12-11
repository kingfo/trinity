package org.jasmineflex
{
	public dynamic class util
	{
		
		/**
		 * @namespace
		 */
		jasmine.util = {};
		
		/**
		 * Declare that a child class inherit it's prototype from the parent class.
		 *
		 * @private
		 * @param {Function} childClass
		 * @param {Function} parentClass
		 */
		jasmine.util.inherit = function(childClass, parentClass) {
		  /**
		   * @private
		   */
		  var subclass = function() {
		  };
		  subclass.prototype = parentClass.prototype;
		  childClass.prototype = new subclass();
		};
		
		jasmine.util.formatException = function(e) {
		  var lineNumber;
		  if ("line" in e) {
		    lineNumber = e.line;
		  }
		  else if ("lineNumber" in e) {
		    lineNumber = e.lineNumber;
		  }
		
		  var file;
		
		  if ("sourceURL" in e) {
		    file = e.sourceURL;
		  }
		  else if ("fileName" in e) {
		    file = e.fileName;
		  }
		
		  var message = ("name" in e && "message" in e) ? (e.name + ': ' + e.message) : e.toString();
		
		  if (file && lineNumber) {
		    message += ' in ' + file + ' (line ' + lineNumber + ')';
		  }
		
		  return message;
		};
		
		jasmine.util.htmlEscape = function(str) {
		  if (!str) return str;
		  return str.replace(/&/g, '&amp;')
		    .replace(/</g, '&lt;')
		    .replace(/>/g, '&gt;');
		};
		
		jasmine.util.argsToArray = function(args) {
		  var arrayOfArgs = [];
		  for (var i = 0; i < args.length; i++) arrayOfArgs.push(args[i]);
		  return arrayOfArgs;
		};
		
		jasmine.util.extend = function(destination, source) {
		  for (var property in source) destination[property] = source[property];
		  return destination;
		};
		
	}
}

