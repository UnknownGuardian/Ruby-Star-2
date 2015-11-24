package 
{
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class MoveMine extends Mine
	{
		public var speed:Number = 0;
		public var acceleration:Number = 0;
		public function MoveMine(_spee:Number, _accel:Number) 
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