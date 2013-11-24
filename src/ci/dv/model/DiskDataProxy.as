package ci.dv.model
{
	import flash.events.Event;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.system.WorkerDomain;
	import flash.utils.ByteArray;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class DiskDataProxy extends Proxy
	{
		public static const ANALYSING_COMPLETED:String = "AnalysingCompleted";
		public static const INVALID_PARH:String = "InvalidPath";
		public static const NO_PATH_ACCESS_PERMISSION:String = "NoPathAccessPermission";
		public static const PATH_IS_NOT_A_DIR:String = "PathIsNotADir";
		
		private var _diskAnalyser:Worker;
		private var _mainToDiskAnalyser:MessageChannel;
		private var _diskAnalyserToMain:MessageChannel;
		
		private var _fileTreeDataBytes:ByteArray = new ByteArray();
		private var _fileTreeData:Object;
		private var _path:String;
		
		public function DiskDataProxy(proxyName:String = null, data:Object = null)
		{
			super(proxyName, data);
			
			if (WorkerDomain.isSupported) {
				// give the worker app privileges, or the worker will running with a LOCAL_WITH_NETWORK sandbox
				_diskAnalyser = WorkerDomain.current.createWorker(Workers.ci_dv_model_DiskAnalyser, true);
				
				_mainToDiskAnalyser = Worker.current.createMessageChannel(_diskAnalyser);
				_diskAnalyserToMain = _diskAnalyser.createMessageChannel(Worker.current);
				_diskAnalyser.setSharedProperty("MainToDiskAnalyserChannel", _mainToDiskAnalyser);
				_diskAnalyser.setSharedProperty("DiskAnalyserToMainChannel", _diskAnalyserToMain);
				
				_diskAnalyserToMain.addEventListener(Event.CHANNEL_MESSAGE, onMessageFromDiskAnalyser);
				
				_fileTreeDataBytes.shareable = true;
				_diskAnalyser.setSharedProperty("FileTreeDataBytes", _fileTreeDataBytes);
				
				_diskAnalyser.start();
				
				analysePath("/users/lenci"); // test
			}
		}
		
		public function analysePath(path:String):void
		{
			_path = path;
			_mainToDiskAnalyser.send(_path);
		}
		
		private function onMessageFromDiskAnalyser(e:Event):void {
			switch (_diskAnalyserToMain.receive() as String) {
				case DiskAnalyser.ANALYSING_COMPLETED:
					_fileTreeData = _fileTreeDataBytes.readObject();
					sendNotification(ANALYSING_COMPLETED, _fileTreeData);
					break;
				
				case DiskAnalyser.INVALID_PATH:
					sendNotification(INVALID_PARH, _path);
					break;
				
				case DiskAnalyser.NO_PERMISSION:
					sendNotification(NO_PATH_ACCESS_PERMISSION, _path);
					break;
				
				case DiskAnalyser.PATH_IS_NOT_A_DIR:
					sendNotification(PATH_IS_NOT_A_DIR, _path);
			}
		}
	}
}