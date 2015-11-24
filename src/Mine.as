package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	import net.profusiondev.graphics.SpriteSheetAnimation;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class Mine extends Entity
	{
		public var spriteSheet:SpriteSheetAnimation;
		
		public function Mine() 
		{
			spriteSheet = new SpriteSheetAnimation(DataR.mine, 50, 50, 12, true, false);
			spriteSheet.x = -spriteSheet.width/2;
			spriteSheet.y = -spriteSheet.height/2;
			addChild(spriteSheet);
		}
		
		override public function collisionCheck(obj:Sprite):Boolean
		{
			return 1000 > Math.pow(obj.x - x, 2) + Math.pow(obj.y - y, 2);
			//return hitTestObject(obj);
		}
		
		override public function kill():void
		{
			super.kill()
			DataR.effects.splice(DataR.effects.indexOf(this), 1);
			spriteSheet.destroy();
		}
	}

}