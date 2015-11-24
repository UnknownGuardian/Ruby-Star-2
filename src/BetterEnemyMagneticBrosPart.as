package  
{
	import com.greensock.TweenMax;
	import net.profusiondev.graphics.SpriteSheetAnimation;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class BetterEnemyMagneticBrosPart extends Entity
	{
		public var spriteSheet:SpriteSheetAnimation;
		public var itemDropY:int = 0;
		public var itemDropNeeded:Boolean = true;
		public var dropRate:Number = 3.2;
		public var itemDropList:Array = [];
		
		public function BetterEnemyMagneticBrosPart() 
		{
			spriteSheet = new SpriteSheetAnimation(DataR.magneticBros, 80, 60, 30, true , false);
			spriteSheet.x = -spriteSheet.width/2;
			spriteSheet.y = -spriteSheet.height/2;
			addChild(spriteSheet);
			
			setHealth(100);
			setDropList(["mine", "coin", "speedmine", "kaze", "blobules", "health", "bomb"]);
		}
		
		public function setDropList(arr:Array):void
		{
			itemDropList.length = 0;
			for (var i:int = arr.length-1; i >=0 ; i--)
			{
				var j:int = i;
				while (j < arr.length)
				{
					itemDropList.push(arr[i]);
					j++;
				}
			}
			trace(itemDropList);
		}
		
		override public function frame():void
		{
			if (itemDropNeeded)
			{
				itemDropY = Math.random() * (ScrollingBackground.HEIGHT - 55) + 60;
				TweenMax.to(this, 1, { y:itemDropY } );
				itemDropNeeded = false;
			}
			else
			{
				if (y - itemDropY < 1 && y - itemDropY > -1)
				{
					dropItem();
					itemDropNeeded = true;
				}
			}
		}
		
		public function dropItem():void
		{
			var itemPicked:String = itemDropList[int(Math.random() * itemDropList.length)];
			if (itemPicked == "mine")
			{
				var m:MoveMine = new MoveMine(2.5, 0);
				m.x = x - 10;
				m.y = y;
				Layers.Items.addChild(m);
				DataR.effects.push(m);
			}
			else if (itemPicked == "speedmine")
			{
				var m2:MoveMine = new MoveMine(2.5, .08);
				m2.x = x - 10;
				m2.y = y;
				Layers.Items.addChild(m2);
				DataR.effects.push(m2);
			}
			else if (itemPicked == "coin")
			{
				var c:MoveCoin = new MoveCoin(4,0);
				c.x = x - 10;
				c.y = y;
				c.spriteSheet.frameNumber = int( Math.random() * (c.spriteSheet.numFrames ) );
				Layers.Items.addChild(c);
				DataR.effects.push(c);
			}
			else if (itemPicked == "kaze")
			{
				var k:BetterEnemyKaze = new BetterEnemyKaze(2.5,0);
				k.x = x - 10;
				k.y = y;
				Layers.Ships.addChild(k);
				DataR.enemies.push(k);
			}
			else if (itemPicked == "blobules")
			{
				var b:BetterEnemyBlobule = new BetterEnemyBlobule();
				b.x = x - 10;
				b.y = y;
				Layers.Ships.addChild(b);
				DataR.enemies.push(b);
			}
			else if (itemPicked == "health")
			{
				
			}
			else if (itemPicked == "bomb")
			{
				var b2:BombPickup = new BombPickup(3, 0);
				b2.x = x - 10;
				b2.y = y;
				Layers.Ships.addChild(b2);
				DataR.effects.push(b2);
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