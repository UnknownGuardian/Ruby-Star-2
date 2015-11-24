package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class Bullet extends Sprite
	{
		public var normalSpeed:Number = 8.5;
		public var xSpeed:Number = 0;
		public var ySpeed:Number = 0;
		
		public function Bullet() 
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			//calculate rotation
			xSpeed = Math.cos(rotation * (Math.PI / 180)) * normalSpeed;
			ySpeed = Math.sin(rotation * (Math.PI / 180)) * normalSpeed;
		}
		
		public function frame():void
		{
			x += xSpeed;
			y += ySpeed;
			
			if (x > 800/*parent.parent.width*/ + width || x < -width || y > 600/*parent.parent.height*/ + height || y < -height)
			{
				kill();
			}
		}
		
		public function kill():void
		{
			parent.removeChild(this);
		}
		
	}

}