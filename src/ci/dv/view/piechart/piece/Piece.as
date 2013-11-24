package ci.dv.view.piechart.piece
{	
	import ci.dv.view.piechart.piece.canvas.PieceCanvasManager;
	import ci.dv.view.piechart.piece.canvas.PieceSpriteCanvas;
	import ci.dv.view.piechart.piece.tween.PieceTweenManager;
	
	public class Piece
	{
		private var _level:int;
		private var _indexAtRing:int;
		private var _title:String;
		private var _value:Number;
		private var _father:Piece;
		private var _children:Vector.<Piece>;
		
		private var _fillColor:uint;
		private var _lineColor:uint;
		
		private var _tweenManager:PieceTweenManager;
		
		public function Piece(canvasManager:PieceCanvasManager, data:Object, father:Piece = null) {
			
			_fillColor = 0xFFFFFF * Math.random();
			_lineColor = 0xFFFFFF * Math.random();
			
			
			_tweenManager = new PieceTweenManager(canvasManager, 30, 2, 0, 1, _fillColor, _lineColor);
			_tweenManager.drawShape();
		}
		
		public function tweenTo(duration:Number, params:Object):void
		{
			_tweenManager.addTweeningTo(duration, params);
		}
		
		// call by pieces mamager before entering frames
		public function redrawShape():void {
			if (_tweenManager.isTweening) {
				 _tweenManager.drawShape();
			} else if (_tweenManager.isShapeOnBitmapCanvas) {
				// the bitmap canvas will be clear before entering frames, so no matter tweening or not, the shape must be redrawed
				_tweenManager.drawShape();
			}
		}
	}
}