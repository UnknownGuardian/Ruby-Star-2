package  
{
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class BetterEnemyOrb extends EnemyOrb
	{
		public var hasSplit:Boolean = false;
		
		public var speed:Number = 5;
		
		public function BetterEnemyOrb() 
		{
		}
		
		override public function frame():void
		{
			var dir:Number = Math.atan2(Layers.Game._ship.y - y, Layers.Game._ship.x - x)
			x += Math.cos(dir)*speed
			y += Math.sin(dir)*speed 
		}
		
		override public function kill():void
		{
			if (!hasSplit)
			{
				split();
			}
			DataR.enemies.splice(DataR.enemies.indexOf(this), 1);
			//DataR.enemies[DataR.enemies.indexOf(this)] = DataR.enemies[DataR.enemies.length - 1];
			//DataR.enemies.length -= 1;
			
			var explosion:BetterExplosion = new BetterExplosion();
			explosion.x = x;
			explosion.y = y;
			Layers.Effects.addChild(explosion);
			DataR.effects.push(explosion);
			
			super.kill();
		}
		
		public function split():void
		{
			for (var i:int = 0; i < 3; i++)
			{
				var a:BetterEnemyOrb = new BetterEnemyOrb();
				a.hasSplit = true;
				a.x = x + Math.random() * 100 - 50;
				a.y = y + Math.random() * 100 - 50;
				Layers.Ships.addChild(a);
				DataR.enemies.push(a);
			}
		}
		
		override public function applyDamage(num:Number):void
		{
			super.applyDamage(num);
		}
	}
}