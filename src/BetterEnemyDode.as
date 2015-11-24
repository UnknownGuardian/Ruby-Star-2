package  
{
	import net.profusiondev.graphics.SpriteSheetAnimation;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class BetterEnemyDode extends Entity
	{
		public var spriteSheet:SpriteSheetAnimation;
		
		public var guard:Entity;
		
		public var rotAroundGuard:Number = 0;
		public var radiusAroundGuard:Number = 150;
		
		public function BetterEnemyDode(guardObj:Entity = null) 
		{
			guard = guardObj;
			
			spriteSheet = new SpriteSheetAnimation(DataR.dode, 50, 50, 31, true, false);
			spriteSheet.x = -spriteSheet.width/2;
			spriteSheet.y = -spriteSheet.height/2;
			addChild(spriteSheet);
			
			setHealth(1);
		}
		
		override public function frame():void
		{
			if (guard != null)
			{
				x = Math.cos(rotAroundGuard * (Math.PI / 180)) * radiusAroundGuard + guard.x;
				y = Math.sin(rotAroundGuard * (Math.PI / 180)) * radiusAroundGuard + guard.y;	
				
				rotAroundGuard ++;
				rotation++;
			}
			else
			{
				//regular enemy code here
			}
		}
		
		override public function kill():void
		{
			super.kill()
			DataR.enemies.splice(DataR.enemies.indexOf(this), 1);
			//DataR.enemies[DataR.enemies.indexOf(this)] = DataR.enemies[DataR.enemies.length - 1];
			//DataR.enemies.length -= 1;
			
			var explosion:BetterExplosion = new BetterExplosion();
			explosion.x = x;
			explosion.y = y;
			Layers.Effects.addChild(explosion);
			DataR.effects.push(explosion);
			
			spriteSheet.destroy();
		}
		
	}

}