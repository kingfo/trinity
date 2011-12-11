import org.jasmineflex.global.*;
import trinity.engine.ChannelCache;
	/**
	 * ...
	 * @author KingFo (telds kingfo)
	 */
describe('ChannelCache', function():void {
	var cache:ChannelCache = new ChannelCache();
	it('add channel only', function():void {
		var a:Array;
		var s:Object;
		
		a = cache.getSubnets('chn-1');
		expect(a).toBe(null);
		
		cache.addChannel('chn-1');
		a = cache.getSubnets('chn-1');
		s = cache.getSource();
		expect(a).toBe(null);
		expect(s.hash.indexOf('chn-1')).toBeGreaterThan(-1);
		expect(s.map.hasOwnProperty('chn-1')).toBe(true);
		
	});
		
	it('add channel base on getway', function():void {
		var a:Array;
		var s:Object;
		
		cache.addChannel('chn-1-1','chn-1');
		a = cache.getSubnets('chn-1');
		s = cache.getSource();
		expect(a.length).toBe(1);
		expect(s.hash.indexOf('chn-1')).toBeGreaterThan(-1);
		expect(s.hash.indexOf('chn-1-1')).toBeGreaterThan(-1);
		expect(s.map.hasOwnProperty('chn-1')).toBe(true);
		expect(s.map.hasOwnProperty('chn-1-1')).toBe(true);
		
		cache.addChannel('chn-2-1','chn-2');
		a = cache.getSubnets('chn-2');
		s = cache.getSource();
		expect(a.length).toBe(1);
		expect(s.hash.indexOf('chn-2')).toBeGreaterThan(-1);
		expect(s.hash.indexOf('chn-2-1')).toBeGreaterThan(-1);
		expect(s.map.hasOwnProperty('chn-2')).toBe(true);
		expect(s.map.hasOwnProperty('chn-2-1')).toBe(true);
		
	});
	
	it('add channel base on subnets', function():void {
		var a:Array;
		var s:Object;
		
		var subnets:Array = ['chn-1-2', 'chn-1-3', 'chn-1-4', 'chn-1-5'];
		cache.addChannel('chn-1', subnets);
		a = cache.getSubnets('chn-1');
		s = cache.getSource();
		expect(a.length).toBe(5);
		expect(s.hash.indexOf('chn-1')).toBeGreaterThan(-1);
		expect(s.hash.indexOf('chn-1-1')).toBeGreaterThan(-1);
		expect(s.hash.indexOf('chn-1-2')).toBeGreaterThan(-1);
		expect(s.hash.indexOf('chn-1-3')).toBeGreaterThan(-1);
		expect(s.hash.indexOf('chn-1-4')).toBeGreaterThan(-1);
		expect(s.hash.indexOf('chn-1-5')).toBeGreaterThan(-1);
		expect(s.map.hasOwnProperty('chn-1')).toBe(true);
		expect(s.map.hasOwnProperty('chn-1-1')).toBe(true);
		expect(s.map.hasOwnProperty('chn-1-2')).toBe(true);
		expect(s.map.hasOwnProperty('chn-1-3')).toBe(true);
		expect(s.map.hasOwnProperty('chn-1-4')).toBe(true);
		expect(s.map.hasOwnProperty('chn-1-5')).toBe(true);
		
		var subnets:Array = ['chn-3-1', 'chn-3-2', 'chn-3-3', 'chn-3-4'];
		cache.addChannel('chn-3', subnets);
		a = cache.getSubnets('chn-3');
		s = cache.getSource();
		expect(a.length).toBe(4);
		expect(s.hash.indexOf('chn-3')).toBeGreaterThan(-1);
		expect(s.hash.indexOf('chn-3-1')).toBeGreaterThan(-1);
		expect(s.hash.indexOf('chn-3-2')).toBeGreaterThan(-1);
		expect(s.hash.indexOf('chn-3-3')).toBeGreaterThan(-1);
		expect(s.hash.indexOf('chn-3-4')).toBeGreaterThan(-1);
		expect(s.map.hasOwnProperty('chn-3')).toBe(true);
		expect(s.map.hasOwnProperty('chn-3-1')).toBe(true);
		expect(s.map.hasOwnProperty('chn-3-2')).toBe(true);
		expect(s.map.hasOwnProperty('chn-3-3')).toBe(true);
		expect(s.map.hasOwnProperty('chn-3-4')).toBe(true);
	});
	
	it('getSubnets', function():void {
		expect(cache.getSubnets('chn-1')).toContain('chn-1-1');
		expect(cache.getSubnets('chn-1')).toContain('chn-1-2');
		expect(cache.getSubnets('chn-1')).toContain('chn-1-3');
		expect(cache.getSubnets('chn-1')).toContain('chn-1-4');
		expect(cache.getSubnets('chn-1')).toContain('chn-1-5');
		
		expect(cache.getSubnets('chn-2')).toContain('chn-2-1');
		expect(cache.getSubnets('chn-2')).not.toContain('chn-2-2');
		
		expect(cache.getSubnets('chn-3')).toContain('chn-3-1');
		expect(cache.getSubnets('chn-3')).toContain('chn-3-2');
		expect(cache.getSubnets('chn-3')).toContain('chn-3-3');
		expect(cache.getSubnets('chn-3')).toContain('chn-3-4');
	});
	
	it('getGetway', function():void { 
		expect(cache.getGetway('chn-1')).toContain('chn-1');
		expect(cache.getGetway('chn-1-1')).toContain('chn-1');
		expect(cache.getGetway('chn-1-2')).toContain('chn-1');
		expect(cache.getGetway('chn-1-3')).toContain('chn-1');
		expect(cache.getGetway('chn-1-4')).toContain('chn-1');
		expect(cache.getGetway('chn-1-5')).toContain('chn-1');
		
		expect(cache.getGetway('chn-2')).toContain('chn-2');
		expect(cache.getGetway('chn-2-1')).toContain('chn-2');
		
		expect(cache.getGetway('chn-3')).toContain('chn-3');
		expect(cache.getGetway('chn-3-1')).toContain('chn-3');
		expect(cache.getGetway('chn-3-2')).toContain('chn-3');
		expect(cache.getGetway('chn-3-3')).toContain('chn-3');
		expect(cache.getGetway('chn-3-4')).toContain('chn-3');
		
	} );
	
	it('removeChannel', function():void { 
		expect(cache.removeChannel('chn-1')).toBe(false);
		expect(cache.removeChannel('chn-1-1')).toBe(true);
		expect(cache.removeChannel('chn-1-2')).toBe(true);
		expect(cache.removeChannel('chn-1-3')).toBe(true);
		expect(cache.removeChannel('chn-1-4')).toBe(true);
		expect(cache.removeChannel('chn-1-5')).toBe(true);
		expect(cache.removeChannel('chn-1')).toBe(true);
		
		expect(cache.removeChannel('chn-2')).toBe(false);
		expect(cache.removeChannel('chn-2-1')).toBe(true);
		expect(cache.removeChannel('chn-2')).toBe(true);
		
		expect(cache.removeChannel('chn-3')).toBe(false);
		expect(cache.removeChannel('chn-3-1')).toBe(true);
		expect(cache.removeChannel('chn-3-2')).toBe(true);
		expect(cache.removeChannel('chn-3-3')).toBe(true);
		expect(cache.removeChannel('chn-3-4')).toBe(true);
		expect(cache.removeChannel('chn-3')).toBe(true);
	});
	
		
});