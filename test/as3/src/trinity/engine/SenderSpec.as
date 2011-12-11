import org.jasmineflex.global.*;
import trinity.engine.ReceiverProxy;
import trinity.engine.Sender;
import utils.ReciverUtil;
	/**
	 * ...
	 * @author KingFo (telds kingfo)
	 */
describe('Sender', function ():void {
	var reciver:ReciverUtil = new ReciverUtil();
	
	var proxy:ReceiverProxy = new ReceiverProxy(reciver);
	var CHANNEL:String = 'a81080ac-f8d3-4842-8ac2-230897f23b2a';
	
	var HANDLER:String = 'receive';
	var sender:Sender = new Sender(HANDLER);
	
	proxy.connect(CHANNEL);
	
	it('send message', function():void {
		var r:*;
		reciver.onReceive = function(request:*):void {
			r = request;
		}
		var s:String;
		
		sender.send( CHANNEL,{ to:CHANNEL }, function(type:String):void {
			s = type;
			});
		
		waitsFor(function():Boolean {
			return r;
			},'cannot send the message', 2000);
			
		runs(function():void {
			expect(s).toBe('status');
			expect(r.to).toBe(CHANNEL);
			});
	});
	
	it('send messages', function():void {
		var r:Array = [];
		reciver.onReceive = function(request:*):void {
			r.push(request.body);
		}
		
		var s:Array = [];
		
		for (var i:int = 0; i < 10; i++ ) {
			sender.send( CHANNEL,{ to:CHANNEL, body:i },onCallback);
		}
		
		function onCallback(type:String):void {
			if(type == 'status')s.push(0);
		}
		
		
		waitsFor(function():Boolean {
			return r.length == 10;;
			},'cannot send all of the messages', 2000);
			
		runs(function():void {
			expect(s.join('')).toBe('0000000000');
			expect(r.join('')).toBe('0123456789');
			});
	});
	
});