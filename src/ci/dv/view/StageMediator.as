package ci.dv.view
{	
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.system.Capabilities;
	
	import ci.dv.view.pathselector.PathSelector;
	import ci.dv.view.piechart.PieChart;
	
	import net.hires.debug.Stats;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class StageMediator extends Mediator
	{
		private var _pathSelectorComponent:PathSelector;
		private var _addressBarComponent:Sprite;
		private var _pieChartComponent:PieChart;
		
		public function StageMediator(mediatorName:String = null, viewComponent:Object = null)
		{
			super(mediatorName, viewComponent);
			
			_pathSelectorComponent = new PathSelector();
			viewComponent.addChild(_pathSelectorComponent);
			facade.registerMediator(new PathSelectorMediator("PathSelector", _pathSelectorComponent));
			
			_addressBarComponent = new Sprite();
			viewComponent.addChild(_addressBarComponent);
			facade.registerMediator(new AddressBarMediator("AddressBarMediator", _addressBarComponent));
			
			_pieChartComponent = new PieChart(800, 600);
			viewComponent.addChild(_pieChartComponent);
			facade.registerMediator(new PieChartMediator("PieChartMediator", _pieChartComponent));
			
			if (Capabilities.isDebugger) {
				viewComponent.addChild(new Stats());
			}
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