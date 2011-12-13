import org.jasmineflex.global.*;
import trinity.engine.Command;
import trinity.engine.Engine;
import trinity.engine.ExchangeDataType;
	/**
	 * ...
	 * @author KingFo (telds kingfo)
	 */
describe('Engine', function():void {
	var GROUP:String = 'f440b960-7ad9-4b73-87dc-d481bf18a3d6';
	var master:Engine = new Engine(GROUP);
	describe('master engine', function():void {
		it('create master', function():void { 
			master.onMaster = function(name:String):void {
				expect(name).not.toBe(GROUP);
				expect(name).toBe('_'+GROUP);
			};
			master.onConnected = function(name:String):void {
				expect(name).not.toBe(GROUP);
				expect(name).toBe('_'+GROUP);
			};
			
			expect(master.getStatus()).toBe(-1);
			master.connect();
			expect(master.getStatus()).toBe(1);
			expect(master.getGroup()).toBe('_'+GROUP);
			expect(master.getName()).toBe('_'+GROUP);
			
		});	
		it('onExecution', function():void {
			master.onExecution = function(command:*):void {
				expect(command).toBeDefined();
				expect(command.host).toBe('foo');
			};
			var testRequest:Object = master.createEmptyRequest(ExchangeDataType.EXECUTION);
			testRequest.body = new Command('foo', ['arg1', 'arg2'], 'signature');
			master.receive(testRequest);
		});	
		it('onReceived', function():void {
			master.onReceived = function(request:*):void {
				expect(request).toBeDefined();
				expect(request.to).toBe('_'+GROUP);
				expect(request.getway).toBe('_'+GROUP);
				expect(request.body.length).toBe(6);
				//trace(request.body)
			};
			var testRequest:Object = master.createEmptyRequest(ExchangeDataType.MESSAGE);
			testRequest.to = master.getGroup();
			testRequest.body = [1, 2, 3, 4, 5, 6];
			master.receive(testRequest);
		});
	});
	describe('node mode', function():void {
		var node:Engine = new Engine(GROUP);
		it('create node', function():void { 
			
			node.onConnected = function(name:String):void {
				expect(name).not.toBe(GROUP);
				expect(name).not.toBe('_' + GROUP);
				expect(name).toMatch(/^_[0-9A-Fa-f]+/);
			};
			
			expect(node.getStatus()).toBe(-1);
			node.connect();
			expect(node.getStatus()).toBe(0);
			expect(node.getGroup()).toBe('_'+GROUP);
			expect(node.getName()).not.toBe('_'+GROUP);
			
		});
		
		it('onSended', function():void {
			node.onSended = function(type:String, msg:String, request:*):void {
				expect(type).toBe('status');
				expect(request.getway).toBe('_'+GROUP);
				expect(request.to).toBeDefined();
				expect(request.from).toBeDefined();
			};
			
			node.fire([1, 2, 3, 4, 5, 6]);
		});
	});
	
	describe('same network fire', function():void {
		var GROUP:String = '_d7d88ad1-db58-4dd9-b2f6-166570dfbb5b';
		var master:Engine = new Engine(GROUP);
		var nodeA:Engine = new Engine(GROUP);
		var nodeB:Engine = new Engine(GROUP);
		it('create network', function():void {
			runs(function():void {
				master.onMaster = function(name:String):void {
					expect(name).toBe(GROUP);
					trace(name);
				};
				master.onConnected = function(name:String):void {
					expect(name).toBe(GROUP);
					
				};
				master.connect();
				
				nodeA.onConnected = function(name:String):void {
					expect(name).toMatch(/^_[0-9A-Fa-f]+/);
					trace(name);
					
				};
				nodeA.connect(); 
				
				nodeB.onConnected = function(name:String):void {
					expect(name).toMatch(/^_[0-9A-Fa-f]+/);
					trace(name);
				};
				nodeB.connect();
			});
		});
		
		it('master broadcast', function():void {
			nodeA.onReceived = function(request:*) {
				expect(request.body).toBe('hello,guys!');
			};
			nodeB.onReceived = function(request:*) {
				expect(request.body).toBe('hello,guys!');
			};
			waitsFor(function():Boolean {
				return nodeA.isConnecting && nodeB.isConnecting;
			}, 'node connect error', 3000 );
			runs(function():void { 
				master.fire('hello,guys!');
			} );
		} );
		
		it('nodeA broadcast', function():void {
			runs(function():void {
				master.onReceived = function(request:*) {
					expect(request.body).toBe('hello,guys!');
				};
				nodeB.onReceived = function(request:*) {
					expect(request.body).toBe('hello,guys!');
				};
			});
			waitsFor(function():Boolean {
				return master.isConnecting && nodeB.isConnecting;
			}, 'node connect error', 3000 );
			runs(function():void { 
				nodeA.fire('hello,guys!');
			} );
		} );
		
		it('nodeB broadcast', function():void {
			runs(function():void {
				master.onReceived = function(request:*) {
					expect(request.body).toBe('hello,guys!');
				};
				nodeA.onReceived = function(request:*) {
					expect(request.body).toBe('hello,guys!');
				};
			});
			waitsFor(function():Boolean {
				return master.isConnecting && nodeA.isConnecting;
			}, 'node connect error', 3000 );
			runs(function():void { 
				nodeB.fire('hello,guys!');
			} );
		} );
		
		it('close', function():void { 
			runs(function():void {
				expect(nodeA.isConnecting).toBe(true);
				nodeA.close();
				expect(nodeA.isConnecting).toBe(false);
				
				expect(nodeA.isConnecting).toBe(true);
				nodeB.close();
				expect(nodeA.isConnecting).toBe(false);
				
				expect(nodeA.isConnecting).toBe(true);
				master.close();
				expect(nodeA.isConnecting).toBe(false);
			});
			
		} );
	});
	
	/*describe('not same network fire', function():void {
		var GROUP_A:String = '_01d06e03-dd21-4ee6-ad95-095ee0983d14';
		var masterA:Engine = new Engine(GROUP_A);
		var nodeA1:Engine = new Engine(GROUP_A);
		var nodeA2:Engine = new Engine(GROUP_A);
		
		var GROUP_B:String = '_5bd37936-44de-4f0a-bb89-67b376008b72';
		var masterB:Engine = new Engine(GROUP_B);
		var nodeB1:Engine = new Engine(GROUP_B);
		var nodeB2:Engine = new Engine(GROUP_B);
		
		//TODO: next time...
	} );*/
});