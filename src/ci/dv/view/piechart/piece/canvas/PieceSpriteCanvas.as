package ci.dv.view.piechart.piece.canvas
{
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	public class PieceSpriteCanvas extends Sprite
	{
		private var _ring:Shape = new Shape();
		private var _polygonMask:Shape = new Shape();
		
		public function PieceSpriteCanvas()
		{
			super();
			
			addChild(_ring);
			addChild(_polygonMask);
			
			_ring.mask = _polygonMask;
		}
		
		public function get ringGraphics():Graphics
		{
			return _ring.graphics;
		}
		
		public function get polygonMaskGraphics():Graphics
		{
			return _polygonMask.graphics;
		}
		
		public function clear():void
		{
			_ring.graphics.clear();
			_polygonMask.graphics.clear();
		}
	}
}