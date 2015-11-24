package  
{
	import com.greensock.TweenLite;
	import net.profusiondev.graphics.SpriteSheetAnimation;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class Portal extends Entity
	{
		public var spriteSheet:SpriteSheetAnimation;
		
		//reverse order push, parses from end to start
		public var spawnArr:Vector.<int> = new Vector.<int>();
		public var spawnReloadTime:int = 0;
		public var spawnLimit:int;		
		public var isInfiniteSpawner:Boolean;
		
		
		public function Portal(SpawnEntities:Array,reloadTime:int = 25,spawnsInfinitely:Boolean = false) 
		{
			spawnArr = Vector.<int>(SpawnEntities.concat());
			spawnLimit = reloadTime;
			isInfiniteSpawner = spawnsInfinitely;
			
			spriteSheet = new SpriteSheetAnimation(DataR.portal, 110, 110, 24, true, false);
			spriteSheet.x = -spriteSheet.width/2;
			spriteSheet.y = -spriteSheet.height/2;
			addChild(spriteSheet);
			
			x = 300;
			y = 300;
		}
		
		override public function frame():void
		{
			spawnReloadTime++;
			if (spawnReloadTime > spawnLimit)
			{
				spawnReloadTime = 0;
				
				spawnEnemy();
			}
		}
		
		public function spawnEnemy():void
		{
			//spawn from end to start of array
			var en:Entity;
			if (spawnArr[spawnArr.length - 1] == DataR.idEnBlobule)
			{
				en = new BetterEnemyBlobule();
			}
			else if (spawnArr[spawnArr.length - 1] == DataR.idEnKaze)
			{
				en = new BetterEnemyKaze();
			}
			else if (spawnArr[spawnArr.length - 1] == DataR.idEnOrb)
			{
				en = new BetterEnemyOrb();
			}
			else if (spawnArr[spawnArr.length - 1] == DataR.idEnPivotor)
			{
				en = new BetterEnemyPivotr();
			}
			else if (spawnArr[spawnArr.length - 1] == DataR.idEnDode)
			{
				en = new BetterEnemyDode();
			}
			else if (spawnArr[spawnArr.length - 1] == DataR.idEnMagneticBros)
			{
				en = new BetterEnemyMagneticBros();
			}
			
			en.x = y + Math.random() * 20;
			en.y = x + Math.random() * 20;
			
			Layers.Ships.addChild(en);
			DataR.enemies.push(en);
			
			//if it is not infinitely spawning, then remove the last guy
			if (!isInfiniteSpawner)
			{
				spawnArr.length -= 1;
				if (spawnArr.length == 0)
				{
					shrink();
				}
			}			
		}
		
		public function shrink():void
		{
			DataR.effects.splice(DataR.effects.indexOf(this), 1);
			spawnArr = null;
			
			TweenLite.to(this, 4.5, { scaleX:0, scaleY:0, onComplete:kill } );
		}
		
		
		
		
		override public function kill():void
		{
			super.kill();
			spriteSheet.destroy();
		}
		
	}

}