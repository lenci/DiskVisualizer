package ci.dv.view.piechart
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import ci.dv.view.piechart.piece.Piece;
	import ci.dv.view.piechart.piece.canvas.PieceCanvasManager;
	
	import com.greensock.easing.*;
	
	public class PieChart extends Sprite
	{
		public static const MIN_VISIBLE_PIECE_DEGREE:Number = 0.1;

		private var pieces:Vector.<Piece>;
		private var _tweeningPieceCount:int = 0;
		
		private var _canvasManager:PieceCanvasManager;
		
		private var _width:int;
		private var _height:int;
		
		private static var instance:PieChart;
		
		public function PieChart(width:int, height:int)
		{
			super();
			
			_width = width;
			_height = height;
			
			_canvasManager = new PieceCanvasManager(_width, _height);
			addChild(_canvasManager);
			
			pieces = new Vector.<Piece>(2, true);
			
			for (var i:int = 0; i < pieces.length; ++i) {
				pieces[i] = new Piece(_canvasManager, new Object);
				pieces[i].tweenTo(10, {theta:57, radiusLevel: 3, delay:1, ease:Back.easeInOut});
				pieces[i].tweenTo(10, {alpha:0.9});
				pieces[i].tweenTo(10, {alpha:0.1, position:40, delay:3});
				++_tweeningPieceCount;
			}
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void
		{
			_canvasManager.clearBitmapCanvas();
			
			for each (var piece:Piece in pieces) {
				piece.redrawShape();
			}
		}
	}
}