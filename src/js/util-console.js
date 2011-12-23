/**
 * @author kingfo  oicuicu@gmail.com
 */
(function(util,data){
	function hasConsole(){
		return data.config.debug && typeof console !== 'undefined';
	}
	
	function join(){
		return Array.prototype.join.call(args, ' ');
	}
	
	util.log = function(){
		if(hasConsole)console.log(arguments);
	}
	
	
})(trinity._util,trinity._data);
