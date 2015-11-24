package  
{
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.geom.Point;
	import net.profusiondev.graphics.SpriteSheetAnimation;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class BetterEnemyMagneticBros extends Entity
	{
		public var first:BetterEnemyMagneticBrosPart;
		public var second:BetterEnemyMagneticBrosPart;
		
		public var dir:Number;
		
		public var e1:Point;
		public var e2:Point;
		
		
		public var isMoving:Boolean = false;
		
		
		
		public function BetterEnemyMagneticBros() 
		{
			first = new BetterEnemyMagneticBrosPart();
			second = new BetterEnemyMagneticBrosPart();
			
			Layers.Ships.addChild(first);
			Layers.Ships.addChild(second);
			
			DataR.enemies.push(first);
			DataR.enemies.push(second);
			
			pickRandomDir();
		}
		public function pickRandomDir():void
		{
			dir = int(Math.random() * 4);
			first.rotation = (dir%2) * 90 + 180;
			second.rotation = first.rotation + 180;
			startTween(dir);
		}
		
		public function startTween(num:int):void
		{
			isMoving = true;
			
			var p:ScrollingBackground = ScrollingBackground(Layers.Background);
			e1 = new Point();
			e2 = new Point();
			
			if (num == 0) { //up
				e1 = new Point(200, 200);
				e2 = new Point(p.WIDTH - 200, 200);
			}
			else if (num == 1) {  //right
				e1 = new Point(p.WIDTH-200, 200);
				e2 = new Point(p.WIDTH - 200, p.HEIGHT - 200 );
			}
			else if (num == 2) { //down
				e1 = new Point(200, p.HEIGHT - 200);
				e2 = new Point(p.WIDTH - 200, p.HEIGHT - 200);
			}
			else if(num == 3) { //left
				e1 = new Point(200, 200);
				e2 = new Point(200, p.HEIGHT - 200);
			}
			var e1X:int = e1.x;
			var e1Y:int = e1.y;
			var e2X:int = e2.x;
			var e2Y:int = e2.y;
			
			
			if (first.getHealth() > 0)
			{
				TweenLite.to(first, 15, { x:e1X , y:e1Y } );
			}
			if (second.getHealth() > 0 )
			{
				TweenLite.to(second, 15, { x:e2X , y:e2Y } );
			}
			TweenLite.to(this,15, { x:0, onComplete:delayTween } );
			
		}
		
		public function delayTween():void
		{
			isMoving = false;
			TweenLite.to(this,2, { x:0, onComplete:startTween, onCompleteParams:[(dir += 2) % 4] } );
		}
		
		
		override public function frame():void
		{
			if (first.getHealth() <= 0 && second.getHealth() <= 0 )
			{
				kill();
			}
			else
			{
				if (isMoving && first.getHealth() > 0 && second.getHealth() > 0)
				{
					graphics.clear();
					var w:int = Math.random() * 10 + 5;
					graphics.lineStyle(w, 0xFFFF00, 0.5,false,'normal', 'none');
					//graphics.lineGradientStyle("linear", [0x000000, 0x00FF00, 0x000000], [1, 1, 1], [0, 127, 255]);
					graphics.moveTo(first.x, first.y);
					graphics.lineTo(second.x, second.y);
				}
				else
				{
					graphics.clear();
				}
			}
		}
		
		
		override public function collisionCheck(obj:Sprite):Boolean
		{
			return false;
		}
		
		
		
		
		override public function kill():void
		{
			super.kill()
			DataR.enemies.splice(DataR.enemies.indexOf(this), 1);
			//DataR.enemies[DataR.enemies.indexOf(this)] = DataR.enemies[DataR.enemies.length - 1];
			//DataR.enemies.length -= 1;
			
			first = null;
			second = null;
		}
	}

}




























/*
package  
{
	import flash.display.Sprite;
	import ugLabs.graphics.SpriteSheetAnimation;

	public class BetterEnemyMagneticBros extends Entity
	{
		public var first:SpriteSheetAnimation;
		public var second:SpriteSheetAnimation;
		
		public var xSpeed1:Number;
		public var ySpeed1:Number;
		
		public var xSpeed2:Number;
		public var ySpeed2:Number;
		
		public var speed:Number = 0.4;
		public var dir:Number;
		
		
		public function BetterEnemyMagneticBros() 
		{
			first = new SpriteSheetAnimation(DataR.magneticBros, 80, 60, 30, true , false);
			first.x = -first.width/2;
			first.y = -first.height/2;
			addChild(first);
			
			second = new SpriteSheetAnimation(DataR.magneticBros, 80, 60, 30, true , false);
			second.x = -second.width/2;
			second.y = -second.height/2;
			addChild(second);
			
			
			
			changeSpeed();
			
		}
		override public function frame():void
		{
			first.x += xSpeed1;
			first.y += ySpeed1;
			second.x += xSpeed2;
			second.y += ySpeed2;
			boundsCheck(first);
			boundsCheck(second);
			rotate();
		}
		
		public function changeSpeed():void
		{
			dir = Math.random() * 360;
			xSpeed1 = Math.cos(dir * (Math.PI / 180)) * speed;
			ySpeed1 = Math.sin(dir * (Math.PI / 180)) * speed;
			dir = Math.random() * 360;
			xSpeed2 = Math.cos(dir * (Math.PI / 180)) * speed;
			ySpeed2 = Math.sin(dir * (Math.PI / 180)) * speed;	
		}
		
		public function boundsCheck(obj:Sprite):void
		{		
			//check bounds
			var p:ScrollingBackground = ScrollingBackground(Layers.Background);
			if (obj.x < width/2)
			{
				obj.x = width/2;
				//how the wall collision effects ship
				obj == first ? xSpeed1 *= -1 : xSpeed2 *= -1;
			}
			else if (obj.x > p.WIDTH - width/2)
			{
				obj.x = p.WIDTH - width / 2;
				//how the wall collision effects ship
				obj == first ? xSpeed1 *= -1 : xSpeed2 *= -1;
			}
			if (obj.y < height/2)
			{
				obj.y = height/2;
				//how the wall collision effects ship
				obj == first ? ySpeed1 *= -1 :  ySpeed2 *= -1;
			}
			else if (obj.y > p.HEIGHT - height/2)
			{
				obj.y = p.HEIGHT - height/2;
				//how the wall collision effects ship
				obj == first ? ySpeed1 *= -1 :  ySpeed2 *= -1;
			}
		}
		public function rotate():void
		{
			first.rotation = Math.atan2(second.y - first.y, second.x - first.x) * 180 / Math.PI - 90;
			//second.rotation = -first.rotation;
			//myObject.rotation = Math.atan2(stage.mouseY - myObject.y, stage.mouseX - myObject.x) * 180 / Math.PI;

		}
		
	}

}
*/