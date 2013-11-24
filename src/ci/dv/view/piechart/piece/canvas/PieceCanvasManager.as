package ci.dv.view.piechart.piece.canvas
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	public class PieceCanvasManager extends Sprite
	{
		private static const SPRITE_CANVAS_POOL_SIZE:int = 10000;
		private var _spriteCanvasPool:Vector.<PieceSpriteCanvas> = new Vector.<PieceSpriteCanvas>(SPRITE_CANVAS_POOL_SIZE, true);
		private var _spriteCanvasesAvailable:Vector.<int> = new Vector.<int>();
		
		private var _bitmapCanvas:BitmapData;
		
		public var _canvasCentralX:int;
		public var _canvasCentralY:int;
		
		public function PieceCanvasManager(canvasWidth:int, canvasHeight:int)
		{
			_canvasCentralX = canvasWidth >> 1;
			_canvasCentralY = canvasHeight >> 1;
			
			for (var i:int = 0; i < _spriteCanvasPool.length; ++i) {
				_spriteCanvasesAvailable.push(i);
			}
			
			_bitmapCanvas = new BitmapData(canvasWidth, canvasHeight, true, 0);
			addChild(new Bitmap(_bitmapCanvas));
		}
		
		public function lendSpriteCanvas():int
		{
			var index:int;
			if (_spriteCanvasesAvailable.length > 0) {
				index = _spriteCanvasesAvailable.pop();
				
				if (_spriteCanvasPool[index] == null) {
					_spriteCanvasPool[index] = new PieceSpriteCanvas();
					_spriteCanvasPool[index].x = _canvasCentralX;
					_spriteCanvasPool[index].y = _canvasCentralY;
				}
				
				addChild(_spriteCanvasPool[index]);
				
			} else {
				// no more sprite canvas available
				index = -1;
			}
			
			return index;
		}
		
		public function returnSpriteCanvas(index:int):void
		{
			_spriteCanvasesAvailable.push(index);
			removeChild(_spriteCanvasPool[index]);
		}
		
		public function getSpriteCanvas(index:int):PieceSpriteCanvas
		{
			return _spriteCanvasPool[index];
		}
		
		public function getBitmapCanvas():BitmapData
		{
			return _bitmapCanvas;
		}
		
		public function clearBitmapCanvas():void
		{
			_bitmapCanvas.fillRect(_bitmapCanvas.rect, 0);
		}
	}
}