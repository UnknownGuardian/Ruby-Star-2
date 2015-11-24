package  
{
	import flash.display.Sprite;
	import net.profusiondev.graphics.SpriteSheetAnimation;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class BetterEnemyKaze extends Entity
	{
		public var spriteSheet:SpriteSheetAnimation;
		
		public var inRange:Boolean = false;
		public var rangeDistance:int = 20000; //the square of the distance in pixels
		public var explosionRangeDistance:int = 1000;
		public var detonationTimer:int = 0;
		public var speed:Number = 5;
		
		public var sideSpeed:Number = 0;
		public var acceleration:Number = 0;
		public function BetterEnemyKaze(_spee:Number = 0, _accel:Number = 0) 
		{
			spriteSheet = new SpriteSheetAnimation(DataR.kaze, 30, 30, 21, false , false);
			spriteSheet.x = -spriteSheet.width/2;
			spriteSheet.y = -spriteSheet.height/2;
			addChild(spriteSheet);
			
			sideSpeed = _spee;
			acceleration = _accel;
		}
		
		override public function frame():void
		{
			/*
			inRange = (  (Layers.Game._ship.y - y) * (Layers.Game._ship.y - y) + ( Layers.Game._ship.x - x) * ( Layers.Game._ship.x - x) < rangeDistance)
			if (inRange)
			{
				spriteSheet.startAnimation();
				var dir:Number = Math.atan2(Layers.Game._ship.y - y, Layers.Game._ship.x - x);
				x += Math.cos(dir) * speed;
				y += Math.sin(dir) * speed;
				
				if (spriteSheet.frameNumber == spriteSheet.numFrames-1)
				{
					spriteSheet.stopAnimation();
				}
				//if in range
				if (  (Layers.Game._ship.y - y) * (Layers.Game._ship.y - y) + ( Layers.Game._ship.x - x) * ( Layers.Game._ship.x - x) < explosionRangeDistance)
				{
					Layers.Game._ship.applyDamage(20);
				}
				kill();
			}
			*/
			
			
			//old animation....freeze first frame until next to ship, then play and suicide
			
			
			if (!inRange)
			{
				x -= speed;
				speed += acceleration;
				inRange = (  (Layers.Game._ship.y - y) * (Layers.Game._ship.y - y) + ( Layers.Game._ship.x - x) * ( Layers.Game._ship.x - x) < rangeDistance)
			}
			else
			{
				var dir:Number = Math.atan2(Layers.Game._ship.y - y, Layers.Game._ship.x - x);
				x += Math.cos(dir) * speed;
				y += Math.sin(dir) * speed;
				
				detonationTimer++;
				if (detonationTimer == 1)
				{
					spriteSheet.startAnimation();
					
				}
				if (spriteSheet.frameNumber == spriteSheet.numFrames-1)
				{
					spriteSheet.stopAnimation();
				}
				//if animation is finished playing
				if (detonationTimer == 21)
				{
					//if in range
					if (  (Layers.Game._ship.y - y) * (Layers.Game._ship.y - y) + ( Layers.Game._ship.x - x) * ( Layers.Game._ship.x - x) < explosionRangeDistance)
					{
						GameState(Layers.Game).enemyHit();
						nonExplosionKill();
					}
					else
					{
						kill();
					}
				}
			}
			
			
		}
		override public function nonExplosionKill():void
		{
			super.kill()
			DataR.enemies.splice(DataR.enemies.indexOf(this), 1);
			//DataR.enemies[DataR.enemies.indexOf(this)] = DataR.enemies[DataR.enemies.length - 1];
			//DataR.enemies.length -= 1;
			spriteSheet.destroy();
		}
		
		override public function collisionCheck(obj:Sprite):Boolean
		{
			if (obj is Bullet)
			{
				return super.collisionCheck(obj);
			}
			return false;
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
		}
		
	}

}