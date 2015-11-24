package  
{
	import net.profusiondev.graphics.SpriteSheetAnimation;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class BetterEnemyPivotr extends Entity
	{
		public var spriteSheet:SpriteSheetAnimation;
		
		public var speed:Number = 3;
		public var xSpeed:Number;
		public var ySpeed:Number;
		
		public var shootingReloadTime:int = 0;
		public var shootingLimit:int = 90;
		
		public var dir:Number = 0;
		
		public function BetterEnemyPivotr() 
		{
			spriteSheet = new SpriteSheetAnimation(DataR.pivotr, 50, 38, 26, true, false);
			spriteSheet.x = -spriteSheet.width/2;
			spriteSheet.y = -spriteSheet.height/2;
			addChild(spriteSheet);
			
			dir = Math.random() * 360;
			
			xSpeed = Math.cos(dir * (Math.PI / 180)) * speed;
			ySpeed = Math.sin(dir * (Math.PI / 180)) * speed;	
		}
		
		
		override public function frame():void
		{
			x += xSpeed;
			y += ySpeed;
			
			//check bounds
			var p:ScrollingBackground = ScrollingBackground(Layers.Background);
			if (x < width/2)
			{
				x = width/2;
				
				//how the wall collision effects ship
				xSpeed *= -1;
			}
			else if (x > ScrollingBackground.WIDTH - width/2)
			{
				x = ScrollingBackground.WIDTH - width / 2;
				
				//how the wall collision effects ship
				xSpeed *= -1;
			}
			if (y < height/2 + 35)
			{
				y = height/2 + 35;
				
				//how the wall collision effects ship
				ySpeed *= -1;
			}
			else if (y > ScrollingBackground.HEIGHT - height/2)
			{
				y = ScrollingBackground.HEIGHT - height/2;
				
				//how the wall collision effects ship
				ySpeed *= -1;
			}
			
			fireWeapon();
		}
		
		public function fireWeapon():void
		{
			shootingReloadTime++;
			if (shootingReloadTime > shootingLimit)
			{
				shootingReloadTime = 0;
				
				var b:BetterEnemyBulletOrange = new BetterEnemyBulletOrange(Math.atan2(Layers.Game._ship.y - y, Layers.Game._ship.x - x),4);
				b.x = x;
				b.y = y;
				Layers.Bullets.addChild(b);
				DataR.enemyBullets.push(b);
			}
		}
		
		override public function applyDamage(num:Number):void
		{
			super.applyDamage(num);
		}
		
		
		override public function nonExplosionKill():void
		{
			super.kill()
			DataR.enemies.splice(DataR.enemies.indexOf(this), 1);
			//DataR.enemies[DataR.enemies.indexOf(this)] = DataR.enemies[DataR.enemies.length - 1];
			//DataR.enemies.length -= 1;
			spriteSheet.destroy();
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








/* Original source below
 * 
 * Kill - Reference only
 * 
 */
//package  
//{
	//import ugLabs.graphics.SpriteSheetAnimation;
	///**
	 //* ...
	 //* @author UnknownGuardian
	 //*/
	//public class BetterEnemyPivotr extends Entity
	//{
		//public var spriteSheet:SpriteSheetAnimation;
		//
		//public var inRange:Boolean = false;
		//public var rangeDistance:int = 40000; //the square of the distance in pixels
		//
		//public var speed:Number = 5;
		//
		//public var shootingReloadTime:int = 0;
		//public var shootingLimit:int = 25;
		//
		//
		//public function BetterEnemyPivotr() 
		//{
			//spriteSheet = new SpriteSheetAnimation(DataR.pivotr, 50, 38, 26, true, false);
			//spriteSheet.x = -spriteSheet.width/2;
			//spriteSheet.y = -spriteSheet.height/2;
			//addChild(spriteSheet);
		//}
		//
		//
		//override public function frame():void
		//{
			//if (!inRange)
			//{
				//var dir:Number = Math.atan2(Layers.Game._ship.y - y, Layers.Game._ship.x - x);
				//x += Math.cos(dir) * speed;
				//y += Math.sin(dir) * speed;
			//}
			//else
			//{
				//fireWeapon();
			//}
			//
			//inRange = (  (Layers.Game._ship.y - y) * (Layers.Game._ship.y - y) + ( Layers.Game._ship.x - x) * ( Layers.Game._ship.x - x) < rangeDistance)
		//}
		//
		//public function fireWeapon():void
		//{
			//shootingReloadTime++;
			//if (shootingReloadTime > shootingLimit)
			//{
				//shootingReloadTime = 0;
				//
				//var b:BetterEnemyBulletOrange = new BetterEnemyBulletOrange(Math.atan2(Layers.Game._ship.y - y, Layers.Game._ship.x - x));
				//b.x = x;
				//b.y = y;
				//Layers.Bullets.addChild(b);
				//DataR.enemyBullets.push(b);
			//}
		//}
		//
		//override public function applyDamage(num:Number):void
		//{
			//super.applyDamage(num);
		//}
		//
		//
		//public function nonExplosionKill():void
		//{
			//super.kill()
			//DataR.enemies.splice(DataR.enemies.indexOf(this), 1);
			//DataR.enemies[DataR.enemies.indexOf(this)] = DataR.enemies[DataR.enemies.length - 1];
			//DataR.enemies.length -= 1;
			//spriteSheet.destroy();
		//}
		//override public function kill():void
		//{
			//super.kill()
			//DataR.enemies.splice(DataR.enemies.indexOf(this), 1);
			//DataR.enemies[DataR.enemies.indexOf(this)] = DataR.enemies[DataR.enemies.length - 1];
			//DataR.enemies.length -= 1;
			//
			//var explosion:BetterExplosion = new BetterExplosion();
			//explosion.x = x;
			//explosion.y = y;
			//Layers.Effects.addChild(explosion);
			//DataR.effects.push(explosion);
						//
			//spriteSheet.destroy();
		//}
		//
	//}
//
//}