package ci.dv.model
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class XMLDataProxy extends Proxy
	{
		public static const NAME:String = "XMLDataProxy";
		public static const DATA_LOADED:String = "DataLoaded";
		
		private var _xmlData:XML;
		
		public function XMLDataProxy()
		{
			super();
			
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			loader.addEventListener(Event.COMPLETE, onComplete);
			loader.load(new URLRequest("SourceCounter_Result_L.xml"));
		}
		
		private function onIOError(e:IOErrorEvent):void
		{
			trace(e.text);
		}
		
		private function onSecurityError(e:SecurityErrorEvent):void
		{
			trace(e.text);
		}
		
		private function onComplete(e:Event):void
		{
			_xmlData = XML(URLLoader(e.target).data);
			sendNotification(DATA_LOADED, _xmlData);
		}
	}
}