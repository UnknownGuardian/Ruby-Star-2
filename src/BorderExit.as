package  
{
	import flash.display.Sprite;
	import net.profusiondev.graphics.SpriteSheetAnimation;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class BorderExit extends Sprite
	{
		public var spriteSheet:SpriteSheetAnimation;
		
		public function BorderExit() 
		{
			spriteSheet = new SpriteSheetAnimation(DataR.backgroundBasicBorderClosed, 125, 20, 20, true , false);
			spriteSheet.x = -spriteSheet.width/2;
			spriteSheet.y = -spriteSheet.height/2;
			addChild(spriteSheet);
			visible = false;
		}
		public function activate():void
		{
			y = 70;
			visible = true;
		}
		public function deactivate():void
		{
			y = 50;
			visible = false;
		}
		
		public function kill():void
		{
			spriteSheet.destroy();
		}
		
	}

}