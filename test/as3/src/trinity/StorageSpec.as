import org.jasmineflex.global.*;
import trinity.Storage;
	/**
	 * ...
	 * @author KingFo (telds kingfo)
	 */
describe('Storage', function() {
	var storage:Storage = Storage.getInstance();
	it('all tests', function():void {
		storage.onCreation = function(data:*):void {
			expect(data).not.toBe(null);
			expect(data.type).toBe('creation');
			expect(data.info).toBe(Storage.DEFAULT_SHARED_NAME);
		}
		storage.onOpen = function(data:*):void {
			expect(data).not.toBe(null);
			expect(data.type).toBe('open');
			expect(data.info).toBe(Storage.DEFAULT_SHARED_NAME);
		}
		storage.onChanged = function(data:*):void {
			expect(data).not.toBe(null);
			expect(data.type).toBe('storage');
			expect(data.info).toMatch(/add|update|delete/);
			expect(data.key).not.toBe(null);
			expect(data.hasOwnProperty('oldValue')).toBe(true);
			expect(data.newValue).toBeDefined();
		}
		storage.onStatus = function(data:*):void {
			expect(data).not.toBe(null);
			expect(data.type).toBeDefined();
			expect(data.info).toBeDefined();
		}
		storage.onClose = function(data:*):void {
			expect(data).not.toBe(null);
			expect(data.type).toBe('flushed');
			expect(data.info).toBe(Storage.DEFAULT_SHARED_NAME);
		}
		storage.onError = function(data:*):void {
			expect(data).not.toBe(null);
			expect(data.type).toBeDefined();
			expect(data.info).toBeDefined();
		}
		storage.onPending = function(data:*):void {
			expect(data).not.toBe(null);
			expect(data.type).toBe('pending');
			expect(data.info).toBe(Storage.DEFAULT_SHARED_NAME);
			expect(data.key).toBeDefined();
		}
		
		
		storage.clear();
		expect(storage.getItem('chopper')).toBe(null);
		
		storage.setItem('chopper', 50);
		expect(storage.getItem('chopper')).toBe(50);
		
		var archive:Object;
		
		storage.setItem('tonny', 'tonny');
		archive = storage.getSource();
		expect(storage.getItem('tonny')).toBe('tonny');
		expect(archive.hash).toBeDefined();
		expect(archive.map).toBeDefined();
		expect(archive.hash.indexOf('tonny')).toBeGreaterThan(-1);
		expect(archive.map.hasOwnProperty('tonny')).toBe(true);
		
		storage.setItem('tonny', null);
		archive = storage.getSource();
		expect(archive.hash).toBeDefined();
		expect(archive.map).toBeDefined();
		expect(archive.hash.indexOf('tonny')).toEqual(-1);
		expect(archive.map.hasOwnProperty('tonny')).toBe(false);
		
		expect(storage.getSize()).toBeGreaterThan(0);
		expect(storage.setSize(1024)).toBe('flushed');
		expect(storage.setSize(1024 * 1024)).toBe('pending');
		
		storage.clear();
		expect(storage.getModificationDate()).not.toBe(null);
		
		storage.destroy();
		expect(storage.getModificationDate()).toBe(null);
	});
});