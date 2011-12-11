import flash.utils.getTimer;
import org.jasmineflex.global.*;
import trinity.engine.Breath;
	/**
	 * ...
	 * @author KingFo (telds kingfo)
	 */
describe('Breath', function():void {
	var rate:Number = 1000;
	var breath:Breath = new Breath(rate);
	var count:Number = 1;
	
	breath.onTimer = function():void {
		breath.check(count);
		count++;
	};
	
	it('test all', function():void {
		expect(breath.running).toBe(false);
		breath.start();
		expect(breath.running).toBe(true);
		
		
		var t:Number = getTimer();
		waitsFor(function():Boolean {
			return count == 3;
			},'check error', 3000);
		runs(function():void {
			t = getTimer() - t;
			expect(breath.interval).toBe(rate * count);
			expect(breath.rate).toBe(rate);
			expect(t).toBeGreaterThan(3000);
			expect(t).toBeLessThan(4000);
		});
		
		runs(function() {
			breath.later();
			});
		
		
		waitsFor(function():Boolean {
			return count == 4;
			},'check error', 2000);
		runs(function():void {
			t = getTimer() - t;
			expect(breath.interval).toBe(rate * count);
			expect(breath.rate).toBe(rate);
			
			expect(t).toBeGreaterThan(4000);
			//expect(t).toBeLessThan(6000);
			
			});
		
		runs(function() {
			breath.stop();
			expect(breath.running).toBe(false);
			});
		
		});
	
	
	
});