package  
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class Entity extends Sprite
	{
		private var health:Number = 0;
		
		public function Entity() 
		{
			
		}
		
		public function frame():void
		{
			
		}
		
		public function setHealth(num:Number):void
		{
			health = num;
		}
		
		public function getHealth():Number
		{
			return health;
		}
		
		public function applyDamage(num:Number):void
		{
			health -= num;
			updateDamageMeter();
			if (health <= 0)
			{
				kill();
			}
		}
		
		private function updateDamageMeter():void
		{
			//to be implemented later
		}
		
		public function collisionCheck(obj:Sprite):Boolean
		{
			return hitTestObject(obj);
		}
		
		public function kill():void
		{
			parent.removeChild(this);
		}
		
		public function nonExplosionKill():void
		{
			
		}
		
		
		
	}

}