package ci.dv.view
{
	import flash.display.Sprite;
	
	import ci.dv.model.DiskDataProxy;
	import ci.dv.view.piechart.PieChart;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class PieChartMediator extends Mediator
	{
		private var _pieChart:PieChart;
		
		public function PieChartMediator(mediatorName:String = null, viewComponent:Object = null)
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
		
		private function initPieChart(data:XML = null):void
		{	
			
		}
	}
}