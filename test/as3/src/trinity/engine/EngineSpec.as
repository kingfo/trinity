import org.jasmineflex.global.*;
import trinity.engine.Engine;
	/**
	 * ...
	 * @author KingFo (telds kingfo)
	 */
describe('Engine', function():void {
	var GROUP:String = 'f440b960-7ad9-4b73-87dc-d481bf18a3d6';
	describe('master engine', function():void {
		var master:Engine = new Engine(GROUP);
		it('create master', function():void { 
			master.onMaster = function(name:String):void {
				expect(name).toBe(GROUP);
			}
			master.onConnected = function(name:String):void {
				expect(name).toBe(GROUP);
			}
			} );
		});
	
	});