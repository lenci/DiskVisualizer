package ci.dv.view
{
	import flash.display.Sprite;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class AddressBarMediator extends Mediator
	{
		public static const NAME:String = "AddressBarMediator";
		
		public function AddressBarMediator(mediatorName:String = null, viewComponent:Object = null)
		{
			super(mediatorName, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return [];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName()) {
				
			}
		}
	}
}