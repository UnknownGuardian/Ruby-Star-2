package  
{
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class EnduranceState extends GameState
	{
			
		public function EnduranceState() 
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
			
		}
		public function createGame():void
		{
			Layers.Game = this;
		}
		public function createBackgroundLayer():void
		{
			_bg = new ScrollingBackground("limeGreen");
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
			Layers.Display = _hud;
		}
		
		
		public function createShip():void
		{
			_ship = new BetterShip();
			_ship.x = 400;
			_ship.y = 200;
			Layers.Ships.addChild(_ship);
			
			/*
			
			var a:BetterEnemyBlobule = new BetterEnemyBlobule();
			Layers.Ships.addChild(a);
			DataR.enemies.push(a);
			
			var b:BetterEnemyOrb = new BetterEnemyOrb();
			Layers.Ships.addChild(b);
			DataR.enemies.push(b);
			
			var c:BetterEnemyPivotr = new BetterEnemyPivotr();
			Layers.Ships.addChild(c);
			DataR.enemies.push(c);
			
			var d:Fraxy = new Fraxy();
			Layers.Effects.addChild(d);
			DataR.effects.push(d);
			
			var e:BetterExplosion = new BetterExplosion();
			Layers.Effects.addChild(e);
			DataR.effects.push(e);
			
			var f:BetterEnemyKaze = new BetterEnemyKaze();
			Layers.Ships.addChild(f);
			DataR.enemies.push(f);
			
			
			var g:Portal = new Portal([1,2,3,4,5]);
			Layers.Effects.addChild(g);
			DataR.effects.push(g);
			
			*/
			
			//var h:BossVrain = new BossVrain();
			//Layers.Ships.addChild(h);
			//DataR.enemies.push(h);
			
			var i:BetterEnemyMagneticBros = new BetterEnemyMagneticBros();
			Layers.Ships.addChild(i);
			DataR.enemies.push(i);
		}
		public function createFrameListener():void
		{
			stage.addEventListener(Event.ENTER_FRAME, frame);
		}
		
		
		
		
		
		public function frame(e:Event):void
		{
			
			//frame
			_ship.frame();
			
			
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
			
			
			/*
			for (var i:int = 0; i < DataR.allyBullets.length; i++)
			{
				DataR.allyBullets[i].frame();
			}
			for (i = 0; i < DataR.enemyBullets.length; i++)
			{
				DataR.enemyBullets[i].frame();
			}
			for (i = 0; i < DataR.enemies.length; i++)
			{
				DataR.enemies[i].frame();
			}
			for (i = 0; i < DataR.effects.length; i++)
			{
				DataR.effects[i].frame();
			}
			*/
			
			
			//collision
			for (i = 0; i < DataR.enemies.length; i++)
			{
				//enemy to ship collision
				if (DataR.enemies[i].collisionCheck(_ship) )
				{
					_ship.applyDamage(10);
					DataR.enemies[i].kill();
					
					trace("[EnduranceState] Enemy-to-ship collision with ship detected");
				}
				else //no ship collision
				{
					//enemy to ally bullet collision
					for (var b:int = 0; b < DataR.allyBullets.length; b++)
					{
						if ( DataR.enemies[i].collisionCheck(DataR.allyBullets[b]) )
						{
							DataR.enemies[i].applyDamage(10);							
							DataR.allyBullets[b].kill();
							
							trace("[EnduranceState] AllyBullet-to-enemy collision with enemy detected");
							break;
						}
					}
				}
			}
			//ship to enemy-bullet collision
			for (i = 0; i < DataR.enemyBullets.length; i++)
			{
				if (_ship.collisionCheck(DataR.enemyBullets[i]) )
				{
					_ship.applyDamage(10);
					DataR.enemyBullets[i].kill();
					
					trace("[EnduranceState] EnemyBullet-to-ship collision with ship detected");
				}
			}
		}
		
	}

}