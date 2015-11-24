package  
{
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class MoveCoin extends Coin
	{
		
		public var speed:Number = 0;
		public var acceleration:Number = 0;
		public function MoveCoin(_spee:Number, _accel:Number) 
		{
			speed = _spee;
			acceleration = _accel;
		}
		override public function frame():void
		{
			x -= speed;
			speed += acceleration;
		}
		
	}

}