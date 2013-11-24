package ci.dv.view
{	
	import ci.dv.model.DiskDataProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class PathSelectorMediator extends Mediator
	{	
		public function PathSelectorMediator(mediatorName:String = null, viewComponent:Object = null)
		{
			super(mediatorName, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return [DiskDataProxy.ANALYSING_COMPLETED, DiskDataProxy.INVALID_PARH, DiskDataProxy.NO_PATH_ACCESS_PERMISSION,
					DiskDataProxy.PATH_IS_NOT_A_DIR];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName()) {
				case DiskDataProxy.ANALYSING_COMPLETED:
					break;
				
				case DiskDataProxy.INVALID_PARH:
					break;
				
				case DiskDataProxy.NO_PATH_ACCESS_PERMISSION:
					break;
				
				case DiskDataProxy.PATH_IS_NOT_A_DIR:
					
					
			}
		}
	}
}