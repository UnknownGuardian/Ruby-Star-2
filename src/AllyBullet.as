package  
{
	import flash.events.Event;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class AllyBullet extends PlayerBullet
	{
		
		
		public function AllyBullet(speed:Number) 
		{
			normalSpeed = speed;
		}
		
		override public function kill():void
		{
			super.kill()
			DataR.allyBullets.splice(DataR.allyBullets.indexOf(this), 1);
			//DataR.allyBullets[DataR.allyBullets.indexOf(this)] = DataR.allyBullets[DataR.allyBullets.length - 1];
			//DataR.allyBullets.length -= 1;
			
			var explosion:BetterExplosionBullet = new BetterExplosionBullet();
			explosion.x = x;
			explosion.y = y;
			Layers.Effects.addChild(explosion);
			DataR.effects.push(explosion);
		}
	}

}