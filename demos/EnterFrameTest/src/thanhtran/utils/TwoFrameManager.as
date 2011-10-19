package thanhtran.utils {
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author Thanh Tran
	 */
	public class TwoFrameManager extends TwoFrameMovie{
		
		static private var _instance: TwoFrameManager = new TwoFrameManager();
	
		public var enterFrame: Signal;
		
		public function TwoFrameManager() {
			//if (_instance) throw new Error("EnterFrameManager Singleton exception");
			enterFrame = new Signal();
			addFrameScript(0, enterFrameHandler, 1, enterFrameHandler);
		}
		
		private function enterFrameHandler(): void {
			enterFrame.dispatch();
		}
		
		static public function get instance(): TwoFrameManager { return _instance; }
			
		
	}

}