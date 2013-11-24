package
{
	import ci.dv.ApplicationFacade;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	[SWF(width="800", height="600", frameRate="60")]
	public class DiskVisualizer extends Sprite
	{
		public static const SECTOR_DEGREE_PRECISION:Number = 1;	// 1/dletaDegree
		
		public function DiskVisualizer()
		{
			if (stage) {
				init();
			} else {
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			var facade:ApplicationFacade = ApplicationFacade.getInstance();
			facade.startup(this);
		}
	}
}