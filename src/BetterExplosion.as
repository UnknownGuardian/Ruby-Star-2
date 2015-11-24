package  
{
	import flash.events.Event;
	import net.profusiondev.graphics.SpriteSheetAnimation;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class BetterExplosion extends Entity
	{
		public var vector:SpriteSheetAnimation;
		
		public function BetterExplosion() 
		{
			vector = new SpriteSheetAnimation(DataR.explosionRegular, 90, 90, 32, true, true);
			vector.x = -vector.width/2;
			vector.y = -vector.height/2;
			addChild(vector);
			
			vector.addEventListener(Event.REMOVED_FROM_STAGE, removeFromStage);
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