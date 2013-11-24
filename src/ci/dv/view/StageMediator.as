package ci.dv.view
{	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.system.Capabilities;
	
	import net.hires.debug.Stats;
	
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class StageMediator extends Mediator
	{
		public static const NAME:String = "StageMediator";
		
		private var _addressBarComponent:Sprite;
		private var _pieChartComponent:Sprite;
		
		public function StageMediator(stage:Stage)
		{
			super();
			
			_addressBarComponent = new Sprite();
			stage.addChild(_addressBarComponent);
			facade.registerMediator(new AddressBarMediator(_addressBarComponent));
			
			_pieChartComponent = new Sprite();
			stage.addChild(_pieChartComponent);
			facade.registerMediator(new PieChartMediator(_pieChartComponent));
			
			if (Capabilities.isDebugger) {
				stage.addChild(new Stats());
			}
		}
	}
}