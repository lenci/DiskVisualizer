package ci.dv.controller
{	
	import flash.display.Sprite;
	
	import ci.dv.model.DiskDataProxy;
	import ci.dv.view.StageMediator;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class StartupCommand extends SimpleCommand
	{
		public function StartupCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			facade.registerMediator(new StageMediator("StageMediator", Sprite(notification.getBody()).stage));
			facade.registerProxy(new DiskDataProxy("DiskDataProxy"));
		}
	}
}