package
{
	import flash.events.Event;
	import net.profusiondev.graphics.SpriteSheetAnimation;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class BetterExplosionBullet extends Entity
	{
		
		public var vector:SpriteSheetAnimation;
		
		public function BetterExplosionBullet() 
		{
			vector = new SpriteSheetAnimation(DataR.explosionBullet, 30, 30, 16, true, true);
			vector.x = -vector.width/2;
			vector.y = -vector.height/2;
			addChild(vector);
			
			vector.addEventListener(Event.REMOVED_FROM_STAGE, removeFromStage);
			
			if (DataR.soundOn)
			{
				DataR.soundManager.playSound(DataR.sExplode);
			}
		}
		
		public function removeFromStage(e:Event):void
		{
			vector.removeEventListener(Event.REMOVED_FROM_STAGE, removeFromStage);
			
			//overwrite this object's position in the array with the last index
			DataR.effects.splice(DataR.effects.indexOf(this), 1);
			//DataR.effects[DataR.effects.indexOf(this)] = DataR.effects[DataR.effects.length - 1];
			//DataR.effects.length -= 1;
						
			kill();
		}
		
	}

}