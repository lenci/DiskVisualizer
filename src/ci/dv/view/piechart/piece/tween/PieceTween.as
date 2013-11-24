package ci.dv.view.piechart.piece.tween
{
	import flash.utils.getTimer;
	
	public class PieceTween
	{	
		public var _tweenTheta:Boolean = false;
		public var _tweenRadiusLevel:Boolean = false;
		public var _tweenPosition:Boolean = false;
		public var _tweenAlpha:Boolean = false;
		
		public var _onCompleteHandle:Function = null;
		
		public var _nowTheta:Number;
		private var _fromTheta:Number;
		private var _toTheta:Number;
		private var _deltaTheta:Number;
		
		public var _nowRadiusLevel:Number;
		private var _fromRadiusLevel:int;
		private var _toRadiusLevel:int;
		private var _deltaRadiusLevel:Number;
		
		public var _nowPosition:Number;
		private var _fromPosition:Number;
		private var _toPosition:Number;
		private var _deltaPosition:Number;
		
		public var _nowAlpha:Number;
		private var _fromAlpha:Number;
		private var _toAlpha:Number;
		private var _deltaAlpha:Number;
		
		private var _tweenDuration:int;
		private var _tweenDelay:int;
		private var _tweenProgress:Number;
		private var _tweenStartTime:int;
		private var _currentTime:int;
		
		public function PieceTween()
		{
			
		}
		
		public function start(from:Object, to:Object, duration:Number, delay:Number = 0, onComplete:Function = null):void
		{	
			if (to.theta != null) {
				_tweenTheta = true;
				
				_fromTheta = from.theta;
				_nowTheta = _fromTheta;
				_toTheta = to.theta;
				_deltaTheta = _toTheta - _fromTheta;
			} else {
				_tweenTheta = false;
			}
			
			if (to.radiusLevel != null) {
				_tweenRadiusLevel = true;
				
				_fromRadiusLevel = from.radiusLevel;
				_nowRadiusLevel = _fromRadiusLevel;
				_toRadiusLevel = to.radiusLevel;
				_deltaRadiusLevel = _toRadiusLevel - _fromRadiusLevel;
			} else {
				_tweenRadiusLevel = false;
			}
			
			if (to.position != null) {
				_tweenPosition = true;
				
				_fromPosition = from.position;
				_nowPosition = _fromPosition;
				_toPosition = to.position;
				_deltaPosition = _toPosition - _fromPosition;
			} else {
				_tweenPosition = false;
			}
			
			if (to.alpha != null) {
				_tweenAlpha = true;
				
				_fromAlpha = from.alpha;
				_nowAlpha = _fromAlpha;
				_toAlpha = to.alpha;
				_deltaAlpha = _toAlpha - _fromAlpha;
			} else {
				_tweenAlpha = false;
			}
			
			if (onComplete) {
				_onCompleteHandle = onComplete;
			}
			
			_tweenDuration = duration * 1000;
			_tweenDelay = delay * 1000;
			
			_tweenStartTime = getTimer();
		}
		
		public function get isTweening():Boolean
		{
			return (_tweenTheta || _tweenRadiusLevel || _tweenPosition || _tweenAlpha);
		}
		
		public function updateShapeState():void
		{
			_currentTime = getTimer();
			
			if (isTweening && (_currentTime - _tweenStartTime > _tweenDelay)) {
				_tweenProgress = (_currentTime - (_tweenStartTime + _tweenDelay)) / _tweenDuration;
				
				// tweening
				if (_tweenProgress < 1) {
					if (_tweenTheta) {
						_nowTheta = _fromTheta + _deltaTheta * _tweenProgress;
					}
					if (_tweenRadiusLevel) {
						_nowRadiusLevel = _fromRadiusLevel + _deltaRadiusLevel * _tweenProgress;
					}
					if (_tweenPosition) {
						_nowPosition = _fromPosition + _deltaPosition * _tweenProgress;
					}
					if (_tweenAlpha) {
						_nowAlpha = _fromAlpha + _deltaAlpha * _tweenProgress;
					}
					
				// complete
				} else {
					if (_tweenTheta) {
						_nowTheta = _toTheta;
						_tweenTheta = false;
					}
					if (_tweenRadiusLevel) {
						_nowRadiusLevel = _toRadiusLevel;
						_tweenRadiusLevel = false;
					}
					if (_tweenPosition) {
						_nowPosition = _toPosition;
						_tweenPosition = false;
					}
					if (_tweenAlpha) {
						_nowAlpha = _toAlpha;
						_tweenAlpha = false;
					}
					
					if (_onCompleteHandle) {
						_onCompleteHandle();
					}
				}
			}
		}
	}
}