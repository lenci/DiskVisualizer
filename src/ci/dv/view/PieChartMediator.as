package ci.dv.view
{
	import flash.display.Sprite;
	
	import ci.dv.model.DiskDataProxy;
	import ci.dv.view.piechart.PieChart;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class PieChartMediator extends Mediator
	{
		public static const NAME:String = "VisualizerMediator";
		
		private var _pieChart:PieChart;
		
		public function PieChartMediator(viewComponent:Sprite)
		{
			super();
			
			_pieChart = new PieChart(800, 600);
			viewComponent.addChild(_pieChart);
		}
		
		override public function listNotificationInterests():Array
		{
			return [DiskDataProxy.DATA_LOADED];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			switch (notification.getName()) {
				case DiskDataProxy.DATA_LOADED:
					initPieChart(notification.getBody() as XML);
			}
		}
		
		private function initPieChart(data:XML = null):void
		{	
			
		}
	}
}