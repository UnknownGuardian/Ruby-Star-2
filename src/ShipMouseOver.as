package  
{
	import com.greensock.TweenMax;
	import flash.events.Event;
	import net.profusiondev.graphics.SpriteSheetAnimation;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class ShipMouseOver extends Entity
	{
		public var vector:SpriteSheetAnimation;
		public var count:int = 0;
		public var ship:BetterShip;
		
		public function ShipMouseOver(_ship:BetterShip) 
		{
			vector = new SpriteSheetAnimation(DataR.bombExplosion, 200, 200, 20, false,true);
			vector.x = -vector.width/2;
			vector.y = -vector.height/2;
			addChild(vector);
			
			scaleX = scaleY = 0.5;
			ship = _ship;
			vector.frameNumber = 7;
			TweenMax.to(vector, 10, { frameNumber:15, yoyo:true, repeat: -1, onUpdate:draw, useFrames:true } );
			
			mouseEnabled = false;
			vector.mouseEnabled = false;
			vector.mouseChildren = false;
			mouseChildren = false;
			
		}
		
		public function draw():void
		{
			vector.drawTile(vector.frameNumber);
			x = ship.x;
			y = ship.y;
		}
		
		override public function kill():void
		{
			vector.destroy();
			
			TweenMax.killTweensOf(vector);
			
			ship = null;
			
			super.kill();
		}
		
	}

}