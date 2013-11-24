package ci.dv.view.piechart.piece.tween
{
	import ci.dv.view.piechart.PieChart;
	import ci.dv.view.piechart.piece.PieceDrawer;
	import ci.dv.view.piechart.piece.canvas.PieceCanvasManager;

	public class PieceTweenManager
	{
		public static const RUNNING_TWEENS_COUNT:int = 10;
		
		private var _runningTweens:Array = new Array;
		private var _tweenPool:Vector.<PieceTween> = new Vector.<PieceTween>(RUNNING_TWEENS_COUNT, true); // to avoid new too many instances
		
		private var _nowTheta:Number;
		private var _nowRadiusLevel:Number;
		private var _nowPosition:Number;
		private var _nowAlpha:Number;
		
		private var _fillColor:uint;
		private var _lineColor:uint;
		
		private var _pieceVisible:Boolean;
		private var _canvasManager:PieceCanvasManager;
		private var _spriteCanvasIndex:int = -1;
		
		public function PieceTweenManager(canvasManager:PieceCanvasManager, theta:Number, radiusLevel:Number,
										  position:Number, alpha:Number, fillColor:uint, lineColor:uint)
		{
			_canvasManager = canvasManager;
			
			_nowTheta = theta;
			_nowRadiusLevel = radiusLevel;
			_nowPosition = position;
			_nowAlpha = alpha;
			
			_fillColor = fillColor;
			_lineColor = lineColor;
			
			draw();
		}
		
		public function addTweeningTo(duration:Number, params:Object):void
		{
			var t:PieceTween = _tweenPool[_runningTweens.length]; // get a tween instance from the pool
			if (t == null) {
				t = new PieceTween();
			}
			
			var tweenFromParams:Object = new Object();
			var tweenToParams:Object = new Object();
			
			if (params.theta != null) {
				tweenFromParams.theta = _nowTheta;
				tweenToParams.theta = params.theta;
				
				// cancel other running tweens' theta tween
				for each (var tweenIterator:PieceTween in _runningTweens) {
					tweenIterator._tweenTheta = false;
				}
			}
			
			if (params.radiusLevel != null) {
				tweenFromParams.radiusLevel = _nowRadiusLevel;
				tweenToParams.radiusLevel = params.radiusLevel;
				
				for each (tweenIterator in _runningTweens) {
					tweenIterator._tweenRadiusLevel = false;
				}
			}
			
			if (params.position != null) {
				tweenFromParams.position = _nowPosition;
				tweenToParams.position = params.position;
				
				for each (tweenIterator in _runningTweens) {
					tweenIterator._tweenPosition = false;
				}
			}
			
			if (params.alpha != null) {
				tweenFromParams.alpha = _nowAlpha;
				tweenToParams.alpha = params.alpha;
				
				for each (tweenIterator in _runningTweens) {
					tweenIterator._tweenAlpha = false;
				}
			}

			_runningTweens.push(t);
			t.start(tweenFromParams, tweenToParams, duration, 
				(params.delay) ? params.delay : 0, params.onComplete);
		}
		
		public function get isShapeOnBitmapCanvas():Boolean
		{
			if (_spriteCanvasIndex != -1) {
				return false;
			} else {
				return true;
			}
		}
		
		public function get isTweening():Boolean
		{
			return _runningTweens.length;
		}
		
		// call by piece before entering frames
		public function drawShape():void
		{	
			for each (var tweenIterator:PieceTween in _runningTweens) {
				tweenIterator.updateShapeState();
				
				if (tweenIterator._tweenTheta) {
					_nowTheta = tweenIterator._nowTheta;
				}
				
				if (tweenIterator._tweenRadiusLevel) {
					_nowRadiusLevel = tweenIterator._nowRadiusLevel;
				}
				
				if (tweenIterator._tweenPosition) {
					_nowPosition = tweenIterator._nowPosition;
				}
				
				if (tweenIterator._tweenAlpha) {
					_nowAlpha = tweenIterator._nowAlpha;
				}
				
				// check whether the tween completed or was canceled
				if (false == tweenIterator.isTweening) {
					_runningTweens.splice(_runningTweens.indexOf(tweenIterator), 1);
				}		
			}
			
			draw();
		}
		
		private function checkPieceVisible():Boolean
		{
			if (_nowAlpha <= 0) {
				return false;
			}
			
			if (_nowTheta <= PieChart.MIN_VISIBLE_PIECE_DEGREE) {
				return false;
			}
			
			if (_nowRadiusLevel <= 0) {
				return false;
			}
			
			return true;
		}
		
		private function draw():void
		{
			_pieceVisible = checkPieceVisible();
			
			if (_pieceVisible) {
				_spriteCanvasIndex = PieceDrawer.draw(_canvasManager, _spriteCanvasIndex, _nowRadiusLevel * 50, 50, 
						_nowTheta, _nowPosition, _fillColor, _nowAlpha, true, 1, _lineColor, _nowAlpha);
			} else {
				// no need to draw
				if (_spriteCanvasIndex != -1) {
					// own a sprite canvas, return it;
					_canvasManager.returnSpriteCanvas(_spriteCanvasIndex);
					_spriteCanvasIndex = -1;
				}
			}
		}
	}
}