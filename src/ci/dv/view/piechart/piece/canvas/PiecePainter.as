package ci.dv.view.piechart.piece.canvas
{	
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	
	public class PiecePainter
	{
		private static const SIDES:int = 3;
		private static const CANVAS_EDGE:int = 1;
		private static const DRAW_ON_BITMAP_CANVAS_AREA_THRESHOLD:uint = 10000000;
		
		private static var drawOnBitmapCanvas:Boolean;
		private static var canvas:PieceSpriteCanvas;
		private static var canvasForBitmapDrawing:PieceSpriteCanvas = new PieceSpriteCanvas();
		private static var canvasHolderForBitmapDrawing:Sprite;
		private static var tempBitmapData:BitmapData;
		private static var destPointOfCopyingPixelsToBitmapCanvas:Point = new Point();
		private static var g:Graphics;
		private static var percentage:Number;
		private static var sidesToDraw:int;
		private static var maskRadius:Number;
		private static var rads:Number;
		private static var thetaInRas:Number;
		private static var ratationInRas:Number;
		private static var startPosition:Number;
		private static var endPosition:Number;
		private static var insideRadius:int;
		private static var p1:Point = new Point();
		private static var p2:Point = new Point();
		private static var p3:Point = new Point();
		private static var p4:Point = new Point();
		private static var anchorPoints:Vector.<Point> = new Vector.<Point>(4, true);
		private static var minX:Number;
		private static var minY:Number;
		private static var maxX:Number;
		private static var maxY:Number;
		
		public function PiecePainter()
		{}
		
		public static function draw(canvasManager:PieceCanvasManager, spriteCanvasIndex:int, outsideRadius:int,
									thickness:int, theta:Number, rotation:Number, fillColor:uint = 0x00FF00, 
									fillAlpha:Number = 1, drawLine:Boolean = true, lineThickness:int = 1, 
									lineColor:uint = 0xFF0000, lineAlpha:Number = 1):int
		{	
			if (theta != 360) {
				theta %= 360;
			}
			rotation = (rotation + 360) % 360;
			
			startPosition = ratationInRas;
			endPosition = startPosition + thetaInRas;
			insideRadius = outsideRadius - thickness;
			p1.x = insideRadius * Math.cos(startPosition);
			p1.y = insideRadius * Math.sin(startPosition);
			p2.x = insideRadius * Math.cos(endPosition);
			p2.y = insideRadius * Math.sin(endPosition);
			p3.x = outsideRadius * Math.cos(endPosition);
			p3.y = outsideRadius * Math.sin(endPosition);
			p4.x = outsideRadius * Math.cos(startPosition);
			p4.y = outsideRadius * Math.sin(startPosition);
			
			// detect rect
			minX = Number.POSITIVE_INFINITY;
			minY = Number.POSITIVE_INFINITY;
			maxX = Number.NEGATIVE_INFINITY;
			maxY = Number.NEGATIVE_INFINITY;
			
			anchorPoints[0] = p1;
			anchorPoints[1] = p2;
			anchorPoints[2] = p3;
			anchorPoints[3] = p4;
			
			if ((startPosition <= 0 && endPosition >= 0) || (startPosition <= Math.PI * 2 && endPosition >= Math.PI * 2)) {
				maxX = outsideRadius;
			}
			if ((startPosition <= Math.PI * 0.5 && endPosition >= Math.PI * 0.5) || (startPosition <= Math.PI * 2.5 && endPosition >= Math.PI * 2.5)) {
				maxY = outsideRadius;
			}
			if ((startPosition <= Math.PI && endPosition >= Math.PI) || (startPosition <= Math.PI * 3 && endPosition >= Math.PI * 3)) {
				minX = -outsideRadius;
			}
			if ((startPosition <= Math.PI * 1.5 && endPosition >= Math.PI * 1.5) || (startPosition <= Math.PI * 3.5 && endPosition >= Math.PI * 3.5)) {
				minY = -outsideRadius;
			}
			
			if (minX == Number.POSITIVE_INFINITY) {
				for each (var p:Point in anchorPoints) {
					if (Math.round(p.x) < minX) {
						minX = Math.round(p.x);
					}
				}
			}
			if (minY == Number.POSITIVE_INFINITY) {
				for each (p in anchorPoints) {
					if (Math.round(p.y) < minY) {
						minY = Math.round(p.y);
					}
				}
			}
			if (maxX == Number.NEGATIVE_INFINITY) {
				for each (p in anchorPoints) {
					if (Math.round(p.x) > maxX) {
						maxX = Math.round(p.x);
					}
				}
			}
			if (maxY == Number.NEGATIVE_INFINITY) {
				for each (p in anchorPoints) {
					if (Math.round(p.y) > maxY) {
						maxY = Math.round(p.y);
					}
				}
			}
			
			// determine draw on sprite canvas or bitmap canvas
			if ((maxX - minX) * (maxY - minY) > DRAW_ON_BITMAP_CANVAS_AREA_THRESHOLD) {
				// draw on sprite canvas
				drawOnBitmapCanvas = false;
				
				if (spriteCanvasIndex == -1) {
					spriteCanvasIndex = canvasManager.lendSpriteCanvas();
					if (spriteCanvasIndex == -1) {
						// no more sprite canvas available
						return spriteCanvasIndex; //-1
					}
				}
				
				canvas = canvasManager.getSpriteCanvas(spriteCanvasIndex);

				
			} else {
				// draw on bitmap canvas
				drawOnBitmapCanvas = true;
				
				if (spriteCanvasIndex != -1) {
					// the sprite canvas owned is no use
					canvasManager.returnSpriteCanvas(spriteCanvasIndex);
					spriteCanvasIndex = -1;
				}
				
				canvas = canvasForBitmapDrawing;
			}
			
			canvas.clear();
			
			// draw a ring
			g = canvas.ringGraphics;
			
			if (drawLine) {
				g.lineStyle(lineThickness, lineColor, lineAlpha);
			} else {
				g.lineStyle(0);
			}
			g.beginFill(fillColor, fillAlpha);
			g.drawCircle(0, 0, outsideRadius);
			g.drawCircle(0, 0, outsideRadius - thickness);
			g.endFill();
			
			// draw shape edge
			if (drawLine) {
				g.lineStyle(lineThickness, lineColor, lineAlpha);
				g.moveTo(p1.x, p1.y);
				g.lineTo(p4.x, p4.y);
				g.moveTo(p2.x, p2.y);
				g.lineTo(p3.x, p3.y);
			}
			
			// draw a polygon as mask
			g = canvas.polygonMaskGraphics;
			
			percentage = theta / 360 * SIDES;
			sidesToDraw = Math.floor(percentage);
			maskRadius = outsideRadius / Math.cos(Math.PI / SIDES);
			
			g.lineStyle(0);
			g.beginFill(0);
			g.moveTo(0, 0);
			
			thetaInRas = theta / 180 * Math.PI;
			ratationInRas = rotation/180*Math.PI;
			for (var i:int = 0; i <= sidesToDraw; ++i) {
				rads = i / SIDES * Math.PI * 2 + ratationInRas;
				g.lineTo(Math.cos(rads) * maskRadius, Math.sin(rads) * maskRadius);
			}
			if (percentage * SIDES != sidesToDraw) {
				rads = thetaInRas + ratationInRas;
				g.lineTo(Math.cos(rads) * maskRadius, Math.sin(rads) * maskRadius);
			}
			g.lineTo(0, 0);
			g.endFill();
			
			if (drawOnBitmapCanvas) {
				//draw the graphics on the canvasForBitmapDrawing to canvasManager's bitmap canvas
				canvasHolderForBitmapDrawing = new Sprite();
				canvas.x =  -minX + CANVAS_EDGE;
				canvas.y = -minY + CANVAS_EDGE;
				canvasHolderForBitmapDrawing.addChild(canvas);
				
				tempBitmapData = new BitmapData(maxX - minX + CANVAS_EDGE << 1, maxY - minY + CANVAS_EDGE << 1, true, 0);
				tempBitmapData.draw(canvasHolderForBitmapDrawing, null, null, null, null, true);
				
				destPointOfCopyingPixelsToBitmapCanvas.x = minX - CANVAS_EDGE + canvasManager._canvasCentralX;
				destPointOfCopyingPixelsToBitmapCanvas.y = minY - CANVAS_EDGE + canvasManager._canvasCentralY;
				canvasManager.getBitmapCanvas().copyPixels(tempBitmapData, tempBitmapData.rect, destPointOfCopyingPixelsToBitmapCanvas, null, null, true);
				
				tempBitmapData.dispose();
			}
			
			return spriteCanvasIndex;
		}
	}
}