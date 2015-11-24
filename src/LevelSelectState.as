package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class LevelSelectState extends GameState
	{
		public var nearestLevel:int = 1;
		
		public var portals:Array = [];
		
		public function LevelSelectState() 
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		public function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			createGame();
			createBackgroundLayer();
			createItemsLayer();
			createBulletsLayer();
			createShipLayer();
			createEffectsLayer();
			createHUDLayer();
			
			createShip();
			createFrameListener();
			
			displayLevelMessage(1);
		}
		
		
		public function createGame():void
		{
			Layers.Game = this;
		}
		public function createBackgroundLayer():void
		{
			_bg = new ScrollingBackground("backgroundLevelSelectStars");
			stage.addChild(_bg);
			Layers.Background = _bg;
		}
		public function createItemsLayer():void
		{
			var i:Sprite = new Sprite();
			Layers.Background.addChild(i);
			Layers.Items = i;
		}
		public function createBulletsLayer():void
		{
			var b:Sprite = new Sprite();
			Layers.Background.addChild(b);
			Layers.Bullets = b;
		}
		public function createShipLayer():void
		{
			var s:Sprite = new Sprite();
			Layers.Background.addChild(s);
			Layers.Ships = s;
		}
		public function createEffectsLayer():void
		{
			var e:Sprite = new Sprite();
			Layers.Background.addChild(e);
			Layers.Effects = e;
		}
		public function createHUDLayer():void
		{
			_hud = new HUD();
			stage.addChild(_hud);
			_hud.hideStatus();
			Layers.Display = _hud;
		}
		public function createShip():void
		{
			_ship = new BetterShip();
			Layers.Ships.addChild(_ship);
			
			for (var i:int = 1; i <= 10; i++)
			{
				var p:PortalBlue =  new PortalBlue();
				p.x = i * 120;
				p.y = Math.random() * 400 - 200 + 240;
				Layers.Effects.addChild(p);
				DataR.effects.push(p);
				portals.push(p);
			}
		}
		public function createFrameListener():void
		{
			stage.addEventListener(Event.ENTER_FRAME, frame);
		}
		
		public function frame(e:Event):void
		{
			//frame
			_ship.frame();
			
			/*
			var indexProximity:int = (_ship.x+60) / 120;
			if (indexProximity != nearestLevel && indexProximity > 0 && indexProximity < 11)
			{
				nearestLevel = indexProximity;
				displayLevelMessage(indexProximity);
			}
			*/
			
			for (var a:int = 0; a < portals.length; a++)
			{
				//check distance
				if (PortalBlue(portals[a]).distanceToShip(_ship) < 60 && a != nearestLevel )
				{
					PortalBlue(portals[nearestLevel]).transform.colorTransform = new ColorTransform(0.5, 1, 2)
					nearestLevel = a;
					PortalBlue(portals[nearestLevel]).transform.colorTransform = new ColorTransform(0.65, 1, 2);
					displayLevelMessage(nearestLevel+1);
				}
			}
			
			
			
			for (var i:int = DataR.allyBullets.length-1; i >=0; i--)
			{
				DataR.allyBullets[i].frame();
			}
			for (i = DataR.enemyBullets.length-1; i >=0; i--)
			{
				DataR.enemyBullets[i].frame();
			}
			for (i = DataR.enemies.length-1; i >=0; i--)
			{
				DataR.enemies[i].frame();
			}
			for (i = DataR.effects.length-1; i >=0; i--)
			{
				DataR.effects[i].frame();
			}
		}
		
		
		
		public function displayLevelMessage(num:int):void
		{
			_hud.dialog.displayMessage("Operator", "Level " + num + ": " + Message["levelSelect" + num + "Name"]);
		}
	}

}