package  
{
	import com.greensock.data.GlowFilterVars;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import flash.ui.Mouse;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class BetterShip extends Ship
	{
		public var livesLeft:int = 4;
		public var coinsLeft:int = 0;
		public var coinsCollected:int = 0;
		public var enemiesHit:int = 0;
		public var enemyBulletsHit:int = 0;
		public var minesHit:int = 0;
		public var outOfBounds:int = 0;
		public var points:int = 0;
		public var hasBomb:Boolean = false;
		public var bombsUsed:int = 0;
		
		
		
		public var isFrozen:Boolean = false;
		//keys
		//public var upPressed:Boolean = false;
		//public var leftPressed:Boolean = false;
		//public var rightPressed:Boolean = false;
		//public var downPressed:Boolean = false;
		public var mousePressed:Boolean = false;
		
		//movement vars
		public var speed:int = 0;
		public var xSpeed:int = 0;
		public var ySpeed:int = 0;
		//public var MAX_X_SPEED:Number = 7;
		//public var MAX_Y_SPEED:Number = 7;
		//public var MAX_DIAGONAL_SPEED:Number  = 4.9;
		//public var ACCELERATION:Number = 15;
		//public var FRICTION:Number = 0.92//0.985;
		
		
		//shooting locations of Shooting points
		public var shootingLocs:Vector.<ShotLocation> = new Vector.<ShotLocation>();
		public var shootingReloadTime:int = 0;
		public var shootingLimit:int = 15;
		
		public var playState:GameState;
		
		public var circle:ShipMouseOver;
		
		public function BetterShip(p:GameState = null ) 
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
			playState = p;
		}
		public function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
					
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, mUp);
			
			filters = [new DropShadowFilter(0, 0, 0, 1, 16, 16, 1, 1)];
			
			//shootingLocs.push(new ShotLocation(13, -4, 0));
			//shootingLocs.push(new ShotLocation(13, 5, 0));
			
			for (var i:int = 0; i < shootingLocs.length; i++)
			{
				addChild(shootingLocs[i]);
			}
			
			setHealth(10000000);

		}
		
		
		
		
		
		public function freezeUntilMouseover():void
		{
			isFrozen = true;
			alpha = 0.6;
			addEventListener(MouseEvent.ROLL_OVER, unFreeze);
			
			circle = new ShipMouseOver(this);
			parent.addChild(circle);
		}
		public function unFreeze(e:MouseEvent):void
		{
			removeEventListener(MouseEvent.ROLL_OVER, unFreeze);
			Mouse.hide();
			isFrozen = false;
			alpha = 1;
			
			circle.kill();
			circle = null;
			trace("unfreeze");
		}
		
		
		
		
		
		//general methods
		override public function kill():void
		{
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, mDown);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mUp);
			parent.removeChild(this);
		}
		
		
		
		
		
		
		
		
		
		public function mDown(e:MouseEvent):void
		{
			mousePressed = true;
		}
		public function mUp(e:MouseEvent):void
		{
			mousePressed = false;
		}
		
		
		
		
		
		
		
		
		
		////////////////////////////////////////////////////////Frame
		override public function frame():void
		{	
			if (isFrozen)
			{
				return;
			}
			
			var distY:Number = parent.mouseY - y;
			var distX:Number = parent.mouseX - x;
			//rotate the ship
			var radians:Number = Math.atan2(distY, distX);
			rotation = radians * 180 / Math.PI
			
			//move if not wanting to shoot
			if (!mousePressed)
			{
				speed = Math.sqrt(Math.pow(distX, 2) + Math.pow(distY, 2)) / 15;
				
				
				xSpeed = Math.cos(radians) * speed;
				ySpeed = Math.sin(radians) * speed;
				
				
				//move the ship
				x += xSpeed;
				y += ySpeed;
			}
			
			
			/*
			var p:ScrollingBackground = ScrollingBackground(Layers.Background);
			if (x < width/2 + 10 || x > p.WIDTH - width/2  - 10|| y < height/2 + 45 || y > p.HEIGHT - height/2 - 10)
			{
				playState.boundsHit();
			}
			*/
			var p:ScrollingBackground = ScrollingBackground(Layers.Background);
			 //Old way of checking bounds.
			//check bounds
			if (x < width/2 + 5)
			{
				x = width/2 + 5;
				
				//how the wall collision effects ship
				//xSpeed *= -1;
			}
			else if (x > ScrollingBackground.WIDTH - width/2 - 5)
			{
				x = ScrollingBackground.WIDTH - width/2 - 5;

				//how the wall collision effects ship
				//xSpeed *= -1;
			}
			if (y < height/2 + 38)
			{
				y = height/2 + 38;
				
				//how the wall collision effects ship
				//ySpeed *= -1;
			}
			else if (y > ScrollingBackground.HEIGHT - height/2 - 5)
			{
				y = ScrollingBackground.HEIGHT - height/2 - 5;
				
				//how the wall collision effects ship
				//ySpeed *= -1;
			}
			
			
			
			
			//do bound scrolling
			if (ScrollingBackground.WIDTH != 640 || ScrollingBackground.HEIGHT != 480)
			{
				//p.x = -x/2;
				//p.y = -y/2
				
				if (x > 320)
				{
					
					p.X = 320 - x;
					
					if (x > ScrollingBackground.WIDTH - 320)
					{
						p.X = 640 - ScrollingBackground.WIDTH;
					}
				}
				else
				{
					p.X = 0;
				}
				if (y > 240)
				{
					p.Y = 240 - y;
					if (y > ScrollingBackground.HEIGHT - 240)
					{
						p.Y = 480-ScrollingBackground.HEIGHT;
					}
				}
				else
				{
					p.Y = 0;
				}
			}
			p.render();
			
			
			//rotate the ship
			//rotation = Math.atan2(parent.mouseY - y, parent.mouseX - x) * 180 / Math.PI
			
			//account for bullet reloads
			shootingReloadTime++;
			if (shootingReloadTime > shootingLimit && mousePressed && playState)
			{
				shootingReloadTime = 0;
				
				for (var i:int = 0; i < shootingLocs.length; i++)
				{
					var b:AllyBullet = new AllyBullet(6);
					var temp:Point = localToGlobal(new Point(shootingLocs[i].x, shootingLocs[i].y));
					var temp2:Point = Layers.Bullets.globalToLocal(temp);
					b.x = temp2.x;
					b.y = temp2.y;
					b.rotation = rotation + shootingLocs[i].rotation;
					Layers.Bullets.addChild(b);
					DataR.allyBullets.push(b);
				}
				
				//trace(DataR.soundOn, DataR.sShoot);
				if (DataR.soundOn)
				{
					//******************DataR.soundManager.playSound(DataR.sShoot);
				}
			}
		}
	}

}