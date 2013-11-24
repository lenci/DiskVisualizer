package ci.dv
{
	import ci.dv.controller.StartupCommand;
	
	import org.puremvc.as3.patterns.facade.Facade;

	public class ApplicationFacade extends Facade
	{
		public static const START_UP:String = "StartUp";
		
		public function ApplicationFacade()
		{
			super();
		}
		
		public static function getInstance():ApplicationFacade
		{
			if (null == instance) {
				instance = new ApplicationFacade();
			}
			
			return instance as ApplicationFacade;
		}
		
		public function startup(app:Object):void
		{
			sendNotification(START_UP, app);
		}
		
		override protected function initializeController():void
		{
			super.initializeController();
			
			registerCommand(START_UP, StartupCommand);
		}
	}
}