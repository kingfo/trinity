import org.jasmineflex.global.*;
import trinity.engine.Breath;
import trinity.engine.Kernel;
import utils.ReciverUtil;
	/**
	 * ...
	 * @author KingFo (telds kingfo)
	 */
describe('Kernel', function():void {
	var master:Kernel;
	var HANDLER:String = 'receive';
	it('master mode', function() {
		var GROUP:String = '_d4c98309-b76f-486b-b11f-514411db1b2a';
		var receiver:ReciverUtil = new ReciverUtil();
		master = new Kernel(HANDLER, receiver);
		master.onMaster = function(name:String):void {
			expect(name).toBe(GROUP);
		}
		master.onConnected = function(name:String):void {
			expect(name).toBe(GROUP);
		}
		
		expect(master.isMaster).toBe(false);
		expect(master.status).toBe(-1);
		master.connect(GROUP);
		expect(master.name).toBe(GROUP);
		expect(master.isMaster).toBe(true);
		expect(master.status).toBe(1);
		
		master.send( GROUP,{ to:GROUP }, function(type:String,info:String,request:*) { 
			expect(type).toBe('error'); 
			expect(info).toBe('repetition'); 
			expect(request.to).toBe(GROUP);
			} );
		
		master.close();
		expect(master.isMaster).toBe(false);
		expect(master.status).toBe(-1);
		
	});
	
	describe('node mode', function() {
		var node:Kernel;
		var GROUP:String = '47d1f604-b11e-4419-863f-94f89c2442e9';
		var masterReceiver:ReciverUtil = new ReciverUtil();
		
		it('create master first', function():void {
			master = new Kernel(HANDLER, masterReceiver);
			expect(master.isMaster).toBe(false);
			expect(master.status).toBe(-1);
			master.connect(GROUP);
			expect(master.isMaster).toBe(true);
			expect(master.status).toBe(1);
		});
		
		var nodeReceiver:ReciverUtil;
		it('create node', function():void {
			nodeReceiver = new ReciverUtil();
			node = new Kernel(HANDLER, nodeReceiver);
			expect(node.isMaster).toBe(false);
			expect(node.status).toBe(-1);
			node.connect(GROUP);
			expect(node.isMaster).toBe(false);
			expect(node.status).toBe(0);
			} );
		
		var done:int = -1;
		it('send message', function() { 
			// master
			masterReceiver.onReceive = function(request:*):void {
				expect(request).toBe('Hello master!');
				done++;
				}
			master.send(node.name, 'Hello node!', function(type:String):void {
				expect(type).toBe('status');
				});
			
			// node
			nodeReceiver.onReceive = function(request:*):void {
				expect(request).toBe('Hello node!');
				done++;
				}
			node.send(master.name,'Hello master!',function(type:String):void {
				expect(type).toBe('status');
				});
			
			} );
			
		it('send messages', function() { 
			
			waitsFor(function():Boolean {
				return done > 0;
				},'send message error', 3000 );
				
			var i:int
			var r:Array = [];
			var s:Array = [];
			
			runs(function():void {
				masterReceiver.onReceive = function(request:*):void {
					r.push(request);
					}
				nodeReceiver.onReceive = function(request:*):void {
					s.push(request);
					}
				
				for (i = 0; i < 15; i++ ) {
					master.send( node.name,i,function(type:String):void {
					expect(type).toBe('status');
					});
					node.send( master.name,i,function(type:String):void {
					expect(type).toBe('status');
					});
				}
				
				});
			
			waitsFor(function():Boolean {
				//trace('r:' + r.toString(),'\ns:' + s.toString(),'\n--------')
				return (r.length + s.length) == 30;
				},'send messages error', 3000);
				
			runs(function():void { 
				expect(s.join('')).toBe('01234567891011121314');
				expect(r.join('')).toBe('01234567891011121314');
				} );
			} );
		});
	
	
});