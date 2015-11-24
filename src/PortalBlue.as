package  
{
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import net.profusiondev.graphics.SpriteSheetAnimation;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class PortalBlue extends Entity
	{
		public var spriteSheet:SpriteSheetAnimation;
		
		public function PortalBlue() 
		{
			spriteSheet = new SpriteSheetAnimation(DataR.portal, 110, 110, 24, true, false);
			spriteSheet.x = -spriteSheet.width/2;
			spriteSheet.y = -spriteSheet.height/2;
			addChild(spriteSheet);
			
			transform.colorTransform = new ColorTransform(0.5, 1, 2);
			
		}
		
		
		
		
		
		
		
		public function distanceToShip(ship:Sprite):Number
		{
			return Math.sqrt(Math.pow(ship.x - x, 2) + Math.pow(ship.y - y, 2));
		}
		public function shrink():void
		{
			DataR.effects.splice(DataR.effects.indexOf(this), 1);
			
			TweenLite.to(this, 4.5, { scaleX:0, scaleY:0, onComplete:kill } );
		}
		
		override public function kill():void
		{
			super.kill();
			spriteSheet.destroy();
		}
		
	}

}