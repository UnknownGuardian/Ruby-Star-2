package  
{
	import flash.events.Event;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class BetterEnemyBulletOrange extends EnemyBulletOrange
	{
		public var dir:Number = 0;
		
		public function BetterEnemyBulletOrange(direction:Number = 0,  speed:Number = 8) 
		{
			normalSpeed = speed;
			dir = direction;
		}
		
		override public function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			//calculate rotation
			xSpeed = Math.cos(dir) * normalSpeed;
			ySpeed = Math.sin(dir) * normalSpeed;
		}
		
		override public function kill():void
		{
			super.kill()
			DataR.enemyBullets.splice(DataR.enemyBullets.indexOf(this), 1);
			//DataR.enemyBullets[DataR.enemyBullets.indexOf(this)] = DataR.enemyBullets[DataR.enemyBullets.length - 1];
			//DataR.enemyBullets.length -= 1;
			
			var explosion:BetterExplosionBullet = new BetterExplosionBullet();
			explosion.x = x;
			explosion.y = y;
			Layers.Effects.addChild(explosion);
			DataR.effects.push(explosion);
		}
	}

}