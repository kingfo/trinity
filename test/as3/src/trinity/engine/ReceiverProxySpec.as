import org.jasmineflex.global.*;
import trinity.engine.ReceiverProxy;
import utils.ReciverUtil;
	/**
	 * ...
	 * @author KingFo (telds kingfo)
	 */
describe('ReceiverProxy', function test():void {
	var reciver:ReciverUtil = new ReciverUtil();
	var proxy:ReceiverProxy = new ReceiverProxy(reciver);
	var CHANNEL:String = '931af78a-1175-450e-8f90-07899f6c5222';
	
	it('should be connected', function ():void {
		expect(proxy.isConnecting).toBe(false);
		expect(proxy.connect(CHANNEL)).toBe(true);
		expect(proxy.isConnecting).toBe(true);
	});
	
	it('should be closed', function ():void {
		expect(proxy.isConnecting).toBe(true);
		proxy.close();
		expect(proxy.isConnecting).toBe(false);
	});
	
});