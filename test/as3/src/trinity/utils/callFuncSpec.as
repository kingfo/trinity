import org.jasmineflex.global.*;
import trinity.utils.callFunc;
	/**
	 * ...
	 * @author KingFo (telds kingfo)
	 */
describe('callFunc', function test():void {
	it('like foo()', function test():void {
		callFunc(function foo():void {
			expect(arguments.length).toBe(0);
		});
	});
	it('like foo(o:*)', function test():void {
		callFunc(foo);
			
		callFunc(foo, {});
		callFunc(foo, []);
		callFunc(foo, new XML());
		callFunc(foo, 'string');
		callFunc(foo, 1);
		callFunc(foo, function():void { } );
		callFunc(foo, {},1 );
			
		function foo(o:*):void {
			expect(arguments.length).toBe(1);
		}
	});
	it('like foo(...args)', function test():void {
		callFunc(foo, 1,2,3,4,5,6);
			
		function foo(...args):void {
			expect(args.length).toBe(6);
		}
	});
	
	it('not exist', function test():void {
		callFunc(undefined,1,34);
		callFunc(null, 123, 34);
		expect(true).toBe(true);
	});
});