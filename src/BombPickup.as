package  
{
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class BombPickup extends Entity
	{		
		public var speed:Number = 0;
		public var acceleration:Number = 0;
		public function BombPickup(_spee:Number, _accel:Number) 
		{
			speed = _spee;
			acceleration = _accel;
			addChild(new BombIcon());
		}
		override public function frame():void
		{
			x -= speed;
			speed += acceleration;
		}
		
		override public function kill():void
		{
			super.kill()
			DataR.effects.splice(DataR.effects.indexOf(this), 1);
		}
		
	}

}