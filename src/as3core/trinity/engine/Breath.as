package trinity.engine {
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import trinity.utils.callFunc;
	/**
	 * ...
	 * @author KingFo (telds kingfo)
	 */
	public class Breath implements IBreath {
		/**
		 * 呼吸频率
		 * 节点数越多 呼吸越慢
		 * 建立在假设 节点数多的时候 每个节点发送消息数也多 
		 * 且如果节点数很多 发送消息少 也意味着对应的应用并不在用户焦点中 
		 * 或者用户以达到其容忍的最大应用量
		 */
		public var rate:Number;
		
		public function get interval():Number {
			return _interval;
		}
		
		public function get timer():Timer {
			return _timer;
		}
		
		public function get running():Boolean {
			return ! !timer && timer.running;
		}
		
		public var onTimer:Function;
		
		public function Breath(rate:Number) {
			this.rate = rate;
			this._interval = rate;
		}
		/**
		 * 开始
		 */
		public function start():void {
			if (!timer) {
				_timer = new Timer(interval);
				timer.addEventListener(TimerEvent.TIMER, timeHandler);
			}
			!timer.running &&timer.start();
		}
		/**
		 * 停止
		 */
		public function stop():void {
			if (!timer || !timer.running) return;
			timer.stop();
		}
		/**
		 * 延迟
		 */
		public function later():void {
			if (!timer) return;
			timer.reset();
			timer.start();
		}
		
		/**
		 * 
		 * @param	multiple			扩增倍数
		 */
		public function check(multiple:Number):void {
			if (!timer) return;
			var num:Number = multiple + 1;
			var tmp:Number = rate * num;
			_interval = tmp < interval ? interval : tmp;
			timer.delay = interval;
		}
		
		private function timeHandler(e:TimerEvent):void {
			callFunc(onTimer, timer);
		}
		
		private var _interval:Number;
		private var _timer:Timer;
		
	}

}