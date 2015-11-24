package  
{
	import com.greensock.easing.*;
	import com.greensock.TweenMax;
	import flash.display.Sprite;
	import flash.events.Event;
	import net.profusiondev.graphics.SpriteSheetAnimation;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class BossVrain extends Entity
	{
		public var spriteSheet:SpriteSheetAnimation;
		
		public var leftMask:BetterVrainMask;
		public var rightMask:BetterVrainMask;
		
		public var isLeftMaskDead:Boolean = false;
		public var isRightMaskDead:Boolean = false;
		
		public var orbitals:Vector.<BetterEnemyDode> = new Vector.<BetterEnemyDode>(); 
		
		public var noShootReloadTime:int = 0;
		public var noShootLimit:int = 100;
		
		public var shootingReloadTime:int = 0;
		public var shootingLimit:int = 10;
		
		public var shootOrangeBulletNext:Boolean = true;
		public var shootingAngle:int = 0;
		
		
		public function BossVrain() 
		{
			spriteSheet = new SpriteSheetAnimation(DataR.vrain, 147, 182, 20, true , false);
			spriteSheet.x = -spriteSheet.width/2;
			spriteSheet.y = -spriteSheet.height/2;
			addChild(spriteSheet);
			
			
			x = 200;
			y = 200;
			
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		public function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			leftMask = new BetterVrainMask();
			leftMask.x = -15;
			rightMask = new BetterVrainMask();
			rightMask.scaleX = -1;
			rightMask.x = 15;
			
			addChild(rightMask);
			addChild(leftMask);
			
			
			var d:BetterEnemyDode = new BetterEnemyDode(this);
			d.x = 0 + x;
			d.y = -150 + y;
			d.rotAroundGuard = 0;
			d.rotation = 0;
			Layers.Ships.addChild(d);
			DataR.enemies.push(d);
			orbitals.push(d);
			
			d = new BetterEnemyDode(this);
			d.x = 150 + x;
			d.y = 0 + y;
			d.rotAroundGuard = 90;
			d.rotation = 90;
			Layers.Ships.addChild(d);
			DataR.enemies.push(d);
			orbitals.push(d);
			
			d = new BetterEnemyDode(this);
			d.x = 0 + x;
			d.y = 150 + y;
			d.rotAroundGuard = 180;
			d.rotation = 180;
			Layers.Ships.addChild(d);
			DataR.enemies.push(d);
			orbitals.push(d);
			
			d = new BetterEnemyDode(this);
			d.x = -150 + x;
			d.y = 0 + y;
			d.rotAroundGuard = 270;
			d.rotation = 270;
			Layers.Ships.addChild(d);
			DataR.enemies.push(d);
			orbitals.push(d);
			
			TweenMax.to(leftMask, 0.75, { x: -20, ease:Sine.easeIn, yoyo:true, repeat:-1 } );
			TweenMax.to(rightMask, 0.75, { x:20, ease:Sine.easeIn, yoyo:true, repeat:-1 } );
		}
		
		override public function frame():void
		{
			//check orbitals health
			for (var i:int = orbitals.length - 1; i >= 0; i--)
			{
				if (orbitals[i].getHealth() <= 0)
				{
					orbitals.splice(i, 1);
				}
			}
			
			noShootReloadTime++;
			if (noShootReloadTime > noShootLimit)
			{
				fireWeapon();
			}
			if (noShootReloadTime > noShootLimit * 5)
			{
				noShootReloadTime = 0;
			}
			
			
		}
		
		public function fireWeapon():void
		{
			shootingReloadTime++;
			if (shootingReloadTime > shootingLimit)
			{
				shootingReloadTime = 0;
				shootingAngle += 10;
				
				var b:Bullet;
				if (shootOrangeBulletNext)	{
					b = new BetterEnemyBulletOrange(shootingAngle*Math.PI/180, 3);
				}
				else {
					b = new BetterEnemyBulletBlue(shootingAngle*Math.PI/180, 3);
				}
				b.x = x;
				b.y = y;
				Layers.Bullets.addChild(b);
				DataR.enemyBullets.push(b);
				
				shootOrangeBulletNext = !shootOrangeBulletNext;
			}
		}
		
		
		override public function collisionCheck(obj:Sprite):Boolean
		{
			if (obj is Bullet)
			{
				return super.collisionCheck(obj);
			}
			//no damage if its the ship attacking
			return false;
		}
		
		override public function applyDamage(num:Number):void
		{
			trace(orbitals.length);
			if (orbitals.length > 0)
			{
				//don't apply damage until all orbitals are dead
			}
			else if (!isLeftMaskDead)
			{
				leftMask.applyDamage(num);
				if (leftMask.getHealth() <= 0)
				{
					isLeftMaskDead = true;
				}
			}
			else if (!isRightMaskDead)
			{
				rightMask.applyDamage(num);
				if (rightMask.getHealth() <= 0)
				{
					isRightMaskDead = true;
				}
			}
			else
			{
				super.applyDamage(num);
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
		}
		
	}

}