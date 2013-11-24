package ci.dv.model
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	public class DiskAnalyser extends Sprite
	{
		public static const ANALYSING_COMPLETED:String = "AnalysingCompleted";
		public static const INVALID_PATH:String = "InvalidPath";
		public static const NO_PERMISSION:String = "NoPermission";
		public static const PATH_IS_NOT_A_DIR:String = "PathIsNotADir";
		
		private var _mainToDiskAnalyser:MessageChannel;
		private var _diskAnalyserToMain:MessageChannel;
		
		private var _fileTreeDataBytes:ByteArray;
		private var _fileTreeDataXML:XML;
		
		public function DiskAnalyser()
		{
			super();
			
			_mainToDiskAnalyser = Worker.current.getSharedProperty("MainToDiskAnalyserChannel");
			_diskAnalyserToMain = Worker.current.getSharedProperty("DiskAnalyserToMainChannel");
			
			_fileTreeDataBytes = Worker.current.getSharedProperty("FileTreeDataBytes");
			
			_mainToDiskAnalyser.addEventListener(Event.CHANNEL_MESSAGE, onMessageFromMain);
		}
		
		private function onMessageFromMain(e:Event):void
		{
			analysePath(_mainToDiskAnalyser.receive() as String);
		}
		
		private function analysePath(path:String):void
		{
			var fileTreeData:Object = new Object();
			var file:File;
			
			try {
				file = new File(path);
				
			} catch (e:ArgumentError) {
				_diskAnalyserToMain.send(INVALID_PATH);
				return;
				
			} catch (e:SecurityError) {
				_diskAnalyserToMain.send(NO_PERMISSION);
				return;
			}
			if (!file.isDirectory) {
				_diskAnalyserToMain.send(PATH_IS_NOT_A_DIR);
				return;
			}
			
			_fileTreeDataXML = new XML();
			_fileTreeDataXML =
				<DiskAnalyser path={path}></DiskAnalyser>;
			
			var n:int = getTimer();
			_fileTreeDataXML.appendChild(analyseDir(0, file)); // create the XML
			trace((getTimer() - n)/1000);
			
			_fileTreeDataBytes.writeObject(fileTreeData);
			_fileTreeDataBytes.position = 0;
			
			_diskAnalyserToMain.send(ANALYSING_COMPLETED);
		}
		
		private function analyseDir(level:int, file:File):XML
		{
			var node:XML = createEmptyDirXMLNode();
			
			node.name = file.name;
			
			trace(node.name);
			
			var size:Number = 0;
			var fileNum:Number = 0;
			
			var subNode:XML;
			for each (var subFile:File in file.getDirectoryListing()) {
				if (!subFile.exists) {
					continue;
				}
				
				if (subFile.isDirectory && !subFile.isPackage) {
					subNode = analyseDir(level + 1, subFile);
					
					node.directory_list[0].appendChild(subNode);
					size += subNode.size;
					fileNum += subNode.file_num;
					
				} else {
					subNode = createEmptyFileXMLNode();
					subNode.name = subFile.name;
					try {
						subNode.size = subFile.size;
					
						node.file_list[0].appendChild(subNode);
						size += subNode.size;
						fileNum += 1;
					} catch (e:Error) { // access denied
						trace (e.message);
					}
				}
			}
			
			node.size = size;
			node.file_num = fileNum;
			
			return node;
		}
		
		private function createEmptyDirXMLNode():XML
		{
			var node:XML =
				<directory>
					<name/>
					<size/>
					<file_num/>
					<directory_list/>
					<file_list/>
				</directory>;
			
			return node;
		}
		
		private function createEmptyFileXMLNode():XML
		{
			var node:XML = 
				<file>
					<name/>
					<size/>
				</file>;
			
			return node;
		}
	}
}