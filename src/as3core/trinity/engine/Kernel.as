package trinity.engine {
	import trinity.utils.callFunc;
	import trinity.utils.guid;
	/**
	 * 核心类
	 * 		对 发送信道 和 接收信道代理 进行了封装。
	 * 		这意味着对外部应用而言，具备了同一且统一的输入输出接口。
	 * @author KingFo (telds kingfo)
	 */
	public class Kernel {
		/**
		 * 核心名称
		 *     当是 Master 模式的时候其 name 必然是第三方指定的名称。
		 *     当不是 Master 模式时，其 name 必然是系统生成的，带下划线 ("_") 前缀的运行时间增量名称
		 */
		public function get name():String {
			return _name;
		}
		/**
		 * 对状态进行封装的判断
		 *     相当于  status > 0 的判断
		 */
		public function get isMaster():Boolean {
			return status > 0;
		}
		/**
		 * 核心状态，具备以下值
		 *     1	Master 模式
		 *     0	Node   模式
		 *     -1	非连接状态
		 */
		public function get status():int {
			return _status;
		}
		/**
		 * 当处于 Master 模式的时候回调
		 * 自定义回调接收以下内容
		 * <pre>
		 * var kernel = new Kernel(HANDLER,client);
		 * // 无形式参数
		 * kernel.onMaster = function():void{//...}
		 * </pre>
		 * <pre>
		 * // 带名称传参
		 * kernel.onMaster =  function(name):void{ trace(name == kerenl.name); //true}
		 * </pre>
		 */
		public var onMaster:Function;
		/**
		 * 当连接建立完成时的回调
		 * 自定义回调接收以下内容
		 * <pre>
		 * var kernel = new Kernel(HANDLER,client);
		 * // 无形式参数
		 * kernel.onConnected = function():void{//...}
		 * </pre>
		 * <pre>
		 * // 带名称传参
		 * kernel.onConnected =  function(name):void{ trace(name == kerenl.name); //true}
		 * </pre>
		 */
		public var onConnected:Function;
		
		public var onError:Function;
		
		public function Kernel(handler:String, client:IReceiver) {
			 privateName = guid('_');
			_sender = new Sender(handler);
			_receiverProxy = new ReceiverProxy(client);
		}
		/**
		 * 建立链接
		 * @param	channel				指定的信道名称
		 * @param	tag					请不要改变默认传参，保持一直为 1
		 */
		public function connect(channel:String, tag:uint = 1):void {
			_status = tag;
			if (_receiverProxy.connect(channel)) {
				_name = channel;
				if (isMaster) {
					callFunc(onMaster, name);
				}
				callFunc(onConnected, name);
				return ;
			}
			if (tag == 0) privateName = guid('_');
			arguments.callee.apply(this, [privateName,0]);
			return ;
		}
		
		public function close():void {
			_receiverProxy.close();
			_status = -1;
		}
		
		public function send(to:String, request:*, callback:Function):Boolean {
			//if (to == name) return false; // 交给业务层处理
			return _sender.send(to, request, callback);
		}
		
		private var _status:int = -1;
		private var _name:String;
		private var privateName:String;
		private var _sender:Sender;
		private var _receiverProxy:ReceiverProxy;
		
	}

}