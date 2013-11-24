package ci.dv.view
{
	import flash.display.Sprite;
	
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class AddressBarMediator extends Mediator
	{
		public static const NAME:String = "AddressBarMediator";
		
		public function AddressBarMediator(viewComponent:Sprite)
		{
			super();
		}
	}
}