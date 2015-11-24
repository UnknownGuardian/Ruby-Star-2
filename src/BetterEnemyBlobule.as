package  
{
	import net.profusiondev.graphics.SpriteSheetAnimation;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class BetterEnemyBlobule extends Entity
	{
		public var spriteSheet:SpriteSheetAnimation;
		
		public var speed:Number = 1;
		public var acceleration:Number = 0.02;
		public var yToggle:Boolean = false;
		
		public function BetterEnemyBlobule() 
		{
			spriteSheet = new SpriteSheetAnimation(DataR.blobule, 45, 50, 21, true, false);
			spriteSheet.x = -spriteSheet.width/2;
			spriteSheet.y = -spriteSheet.height/2;
			addChild(spriteSheet);
			
				
		}
		
		override public function frame():void
		{
			x -= speed;
			speed += acceleration;
			var tempY:Number = Layers.Game._ship.y - y;
			if (tempY > 10)
			{
				y += speed/4;
			}
			else if (tempY < 10)
			{
				y -= speed/4;
			}
			else
			{
				acceleration += 0.01;
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