package  
{
	import com.greensock.easing.Back;
	import com.greensock.TweenMax;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class MineDodger extends GameState
	{
		public var level:int = 1; //handles difficulty
		
		
		public var enemyCounter:int = 0;
		public var enemyLimit:int = 100;
		
		public var levelTime:int;
		public var levelTimeMax:int;
		
		public var spawner:BetterEnemyMagneticBrosPart;
		
		public var messenger:DialogManager;
		
		
		public function MineDodger() 
		{
			createGame();
			createBackgroundLayer();
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		public function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.addChild(_bg);
			
			createItemsLayer();
			createBulletsLayer();
			createShipLayer();
			createEffectsLayer();
			createHUDLayer();
			
			//createFrameListener();
			var t:Timer = new Timer(250, 1);
			t.addEventListener(TimerEvent.TIMER, delayCall);
			t.start();
			
			//******************DataR.mPlayGameCurrentMusic = DataR.soundManager.playMusic(DataR.mGameLoop1, Infinity);
			//******************DataR.mPlayGameCurrentMusic2 = DataR.soundManager.playMusic(DataR.mGameLoop2, Infinity);
			//******************DataR.soundManager.changeSoundVolume(DataR.mPlayGameCurrentMusic2, 0);
		}
		public function delayCall(e:TimerEvent):void
		{
			e.currentTarget.removeEventListener(TimerEvent.TIMER, delayCall);
			createShip();
			primeLevel();
		}
		public function createGame():void
		{
			Layers.Game = this;
		}
		public function createBackgroundLayer():void
		{
			_bg = new ScrollingBackground("limeGreen");
			Layers.Background = _bg;
			_bg.X = -80;
			_bg.Y = -60;
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
			
			messenger = new DialogManager();
			Layers.Display.addChild(messenger);
		}
		
		
		public function createShip():void
		{
			_ship = new BetterShip(this);
			_ship.x = 400;
			_ship.y = 300;
			Layers.Ships.addChild(_ship);
		}
		public function createFrameListener(e:Event = null):void
		{
			stage.addEventListener(Event.ENTER_FRAME, frame);
			stage.addEventListener(KeyboardEvent.KEY_UP, kUp);
		}

		public function primeLevel():void
		{
			if (!spawner)
			{
				spawner = new BetterEnemyMagneticBrosPart();
				spawner.x = 790 - spawner.width / 2;
				Layers.Ships.addChild(spawner);
				spawner.y = 325 - spawner.height / 2;
				DataR.enemies.push(spawner);
			}
			
			
			resetTimer();
			_bg.exit.activate();
			animateIn()
			_ship.freezeUntilMouseover();
			
			_hud.updateCoinsLeft(_ship.coinsLeft);
			if (level > 8)
			{
				_ship.hasBomb = true;
			}
			_hud.updateBomb(_ship.hasBomb);
			
			if (level > 10)
			{
				enemyLimit = 180;
				var temp:int = level;
				while (temp > 10)
				{
					temp--;
					enemyLimit -= 7;
				}
			}
			
			handleMessenger();
			
		}
		
		public function primeSameLevel():void
		{
			//just kill all the bullets. it makes it a lot easier for the player, prevents glitches that pop up
			var i:int = 0;
			for (i = DataR.allyBullets.length - 1; i >= 0; i--)
			{
				DataR.allyBullets[i].kill();
			}
			DataR.allyBullets.length = 0;
			for (i = DataR.enemyBullets.length - 1; i >= 0; i--)
			{
				DataR.enemyBullets[i].kill();
			}
			DataR.enemyBullets.length = 0;
			
			if (_ship.livesLeft < 0)
			{
				trace("[PlayState] Game Over");
				var menu:MenuState = new MenuState();
				menu.alpha = 0;
				stage.addChild(menu);
				menu.show("credits");
				
				var scoreDisplay:ScoreState = new ScoreState(_ship.points, _ship.minesHit, _ship.coinsCollected, _ship.enemyBulletsHit, _ship.enemiesHit, _ship.livesLeft);
				scoreDisplay.alpha = 0;
				stage.addChild(scoreDisplay);
				
				//TODO display final score
				TweenMax.to(this, 2, { alpha:0, onUpdate:fadeMusic } );
				TweenMax.to(menu, 2, { alpha:1, onComplete:kill } );
				TweenMax.to(scoreDisplay, 2, { alpha:1 } );
				return;
			}
			
			handleMessenger();
			
			//animateIn(false);
			createFrameListener();
			_ship.freezeUntilMouseover();
		}
		public function resetTimer():void
		{
			levelTime = int((DataR.effects.length * 2.8 + 10) * 30);
			_hud.updateTime(levelTime);
		}
		
		public function handleMessenger():void
		{
			if (level == 1)	{
				messenger.visible = true;
				messenger.displayMessage("Operator","We can't have all this money scattered about. \n\nTake control of your ship by putting your mouse on it.");
			}
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
			var en:Entity;
			var p:ScrollingBackground = ScrollingBackground(Layers.Background);
			for (i = DataR.effects.length-1; i >=0; i--)
			{
				en = DataR.effects[i];
				DataR.effects[i].frame();
			}
			
			
			for (i = DataR.effects.length-1; i >=0; i--)
			{
				if (DataR.effects[i].collisionCheck(_ship) )
				{
					if (DataR.effects[i] is Coin)
					{
						coinHit();
						DataR.effects[i].kill();
					}
					else if (DataR.effects[i] is Mine)
					{
						mineHit();
						DataR.effects[i].kill();
					}
				}
				
			}
			
			if (!_ship.isFrozen)
			{
				checkCollisions();
				
				levelTime--;
				//play near level count down time.
				if (levelTime <= 300 && levelTime % 30 == 0)
				{
					if (DataR.soundOn)
					{
						//******************DataR.soundManager.playSound(DataR.sCoundDownNear);
					}
				}
				if (levelTime < 0)
				{
					levelTime = 0;
				}
				_hud.updateTime(levelTime);
			}
		}
		
		public function checkCollisions():void
		{
			//Old collision against enemies, enemy bullets
			//collision
			var i:int = 0;
			for (i = 0; i < DataR.enemies.length; i++)
			{
				//enemy to ship collision
				if (DataR.enemies[i].collisionCheck(_ship) )
				{
					DataR.enemies[i].nonExplosionKill();
					enemyHit();
					return;
				}
				else //no ship collision
				{
					//enemy to ally bullet collision
					for (var b:int = 0; b < DataR.allyBullets.length; b++)
					{
						if ( DataR.enemies[i].collisionCheck(DataR.allyBullets[b]) )
						{
							DataR.enemies[i].kill();						
							DataR.allyBullets[b].kill();
							_ship.points += 50;
							_hud.updatePointsLeft(_ship.points);
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
					DataR.enemyBullets[i].kill();
					enemyBulletHit();
					return;
				}
			}
			
			if ( _ship.hitTestObject(_bg.exit))
			{
				if (_ship.coinsLeft == 0)
				{
					animateOut();
					level++;
					
					if (DataR.soundOn)
					{
						//******************DataR.soundManager.playSound(DataR.sNewLevel);
					}
				}
				else
				{
					var explosion:BetterExplosion = new BetterExplosion();
					explosion.x = _ship.x;
					explosion.y = _ship.y;
					Layers.Effects.addChild(explosion);
					DataR.effects.push(explosion);
					
					if (DataR.soundOn)
					{
						//******************DataR.soundManager.playSound(DataR.sShipExplode);
					}
							
					trace("[PlayState] Hit top border while incomplete");
					animateOut(false);
					
				}
			}
			
		}
		
		
		
	
		
		
		
		
		
		
		
		public function coinHit():void
		{
			_ship.coinsCollected++;
			_ship.coinsLeft--;
			trace("[PlayState] Coin collected. " + _ship.coinsLeft + " left.");
			_hud.updateCoinsLeft(_ship.coinsLeft);
			
			if (DataR.soundOn) //play a random coin noise
			{
				var r:Number = Math.random();
				if (r < 0.25)
				{
					//******************DataR.soundManager.playSound(DataR.sCoinCollect1);
				}
				else if (r < 0.50)
				{
					//******************DataR.soundManager.playSound(DataR.sCoinCollect2);
				}
				else if (r < 0.75)
				{
					//******************DataR.soundManager.playSound(DataR.sCoinCollect3);
				}
				else
				{
					//******************DataR.soundManager.playSound(DataR.sCoinCollect4);
				}
				
			}
			if (_ship.coinsCollected % 25 == 0)
			{
				var a:Award = new Award(_ship.coinsCollected, "Collected " + _ship.coinsCollected + " coins!");
				Layers.Display.addChild(a);
				_ship.points += _ship.coinsCollected;
			}
			
			
			_ship.points += 100;
			_hud.updatePointsLeft(_ship.points);
			if (_ship.coinsLeft == 0)
			{
				_bg.exit.deactivate();
				_ship.points += 1000;
				_hud.updatePointsLeft(_ship.points);
				//animateOut();
				//level++;
			}
		}
		override public function enemyHit():void
		{
			var explosion:BetterExplosion = new BetterExplosion();
			explosion.x = _ship.x;
			explosion.y = _ship.y;
			Layers.Effects.addChild(explosion);
			DataR.effects.push(explosion);
			
			trace("[PlayState] Enemy Hit");
			_ship.enemiesHit++;
			var a:Award;
			if (_ship.enemiesHit == 1)
			{
				a = new Award(50, "Suicider!");
				Layers.Display.addChild(a);
				_ship.points += 50;
			}
			else if (_ship.enemiesHit == 3)
			{
				a = new Award(150, "Professional Suicider!");
				Layers.Display.addChild(a);
				_ship.points += 150;
			}
			else if (_ship.enemiesHit == 5)
			{
				a = new Award(250, "Super Professional Suicider!");
				Layers.Display.addChild(a);
				_ship.points += 250;
			}
			else if (_ship.enemiesHit == 7)
			{
				a = new Award(350, "Super Ultra Professional Suicider!");
				Layers.Display.addChild(a);
				_ship.points += 350;
			}
			animateOut(false);
			
		}
		public function enemyBulletHit():void
		{
			var explosion:BetterExplosion = new BetterExplosion();
			explosion.x = _ship.x;
			explosion.y = _ship.y;
			Layers.Effects.addChild(explosion);
			DataR.effects.push(explosion);
			
			trace("[PlayState] Enemy Bullet Hit");
			_ship.enemyBulletsHit++;
			animateOut(false);
			
			
		}
		public function mineHit():void
		{
			var explosion:BetterExplosion = new BetterExplosion();
			explosion.x = _ship.x;
			explosion.y = _ship.y;
			Layers.Effects.addChild(explosion);
			DataR.effects.push(explosion);
			
			if (DataR.soundOn)
			{
				//******************DataR.soundManager.playSound(DataR.sShipExplode);
			}
			
			trace("[PlayState] Mine Hit");
			_ship.minesHit++;
			animateOut(false);
			var a:Award;
			if (_ship.minesHit == 1)
			{
				a = new Award(100, "Mine Awareness Program!");
				Layers.Display.addChild(a);
				_ship.points += 100;
			}
			else if (_ship.minesHit == 3)
			{
				a = new Award(1000, "Blind to Mines!");
				Layers.Display.addChild(a);
				_ship.points += 1000;
			}
			else if (_ship.minesHit == 5)
			{
				a = new Award(3000, "Mines Must Love You!");
				Layers.Display.addChild(a);
				_ship.points += 3000;
			}
			else if (_ship.minesHit == 7)
			{
				a = new Award(5000, "Minetastic!");
				Layers.Display.addChild(a);
				_ship.points += 5000;
			}
			
		}
		
		//method not in use anymore I think
		public function boundsHit():void
		{
			var explosion:BetterExplosion = new BetterExplosion();
			explosion.x = _ship.x;
			explosion.y = _ship.y;
			Layers.Effects.addChild(explosion);
			DataR.effects.push(explosion);
			
			trace("[PlayState] Out of Bounds!");
			_ship.outOfBounds++;
			animateOut(false);
			
		}
		//^^^^^method not in use anymore I think^^^^^^^^
		
		
		public function animateIn(newLevel:Boolean = true):void
		{
			var arr:Array = [];
			var i:int = 0;
			for (i = 0; i < DataR.effects.length; i++)
			{
				arr.push(DataR.effects[i]);
			}
			for (i = 0; i < DataR.enemies.length; i++)
			{
				arr.push(DataR.enemies[i]);
			}
			for (i = 0; i < DataR.allyBullets.length; i++)
			{
				arr.push(DataR.allyBullets[i]);
			}
			for (i = 0; i < DataR.enemyBullets.length; i++)
			{
				arr.push(DataR.enemyBullets[i]);
			}
			_ship.x = 400;
			_ship.y = 300;
			arr.push(_ship);
			
			if (newLevel)
			{
				
				TweenMax.allFrom(arr, 1, {y: "-600", ease:Back.easeOut, overwrite:true }, 0.02, createFrameListener);
			}
			else
			{
				//_ship.y -= 600;
				//TweenMax.allTo(arr, 1, { y: "600", ease:Back.easeOut, overwrite:true }, 0.02, createFrameListener);
			}
		}
		
		public function animateOut(newLevel:Boolean = true):void
		{
			stage.removeEventListener(Event.ENTER_FRAME, frame);
			stage.removeEventListener(KeyboardEvent.KEY_UP, kUp);
			
			var arr:Array = [];
			var i:int = 0;
			for (i = 0; i < DataR.effects.length; i++)
			{
				arr.push(DataR.effects[i]);
			}
			for (i = 0; i < DataR.enemies.length; i++)
			{
				arr.push(DataR.enemies[i]);
			}
			for (i = 0; i < DataR.allyBullets.length; i++)
			{
				arr.push(DataR.allyBullets[i]);
			}
			for (i = 0; i < DataR.enemyBullets.length; i++)
			{
				arr.push(DataR.enemyBullets[i]);
			}
			arr.push(_ship);
			
			var timeDelay:Number;
			if (newLevel)
			{
				TweenMax.allTo(arr, 1, { y: "-600", ease:Back.easeIn }, 0.02, resetLevel);
				timeDelay = 0.02 * arr.length;
				TweenMax.to(Layers.Background, 1, { X:-80, Y:-60, delay:timeDelay,onUpdate:ScrollingBackground(Layers.Background).render } );
			}
			else
			{
				_ship.livesLeft--;
				_hud.updateLivesLeft(_ship.livesLeft);
				
				TweenMax.to(_ship, 1, { x:400, y:300, onComplete:primeSameLevel, delay:0.5 } );
				//TweenMax.allTo(arr, 1, { y: "-600", ease:Back.easeIn }, 0.02, primeSameLevel);
				//timeDelay = 0.02 * arr.length;
				TweenMax.to(Layers.Background, 1, { X:-80, Y:-60, delay:0.52, onUpdate:ScrollingBackground(Layers.Background).render} );
			}
		}
		
		public function resetLevel():void
		{
			var i:int;
			for (i = DataR.effects.length - 1; i >= 0; i--)
			{
				DataR.effects[i].kill();
			}
			DataR.effects.length = 0;
			for (i = DataR.enemies.length - 1; i >= 0 ; i--)
			{
				DataR.enemies[i].nonExplosionKill();
			}
			DataR.enemies.length = 0;
			for (i = DataR.allyBullets.length - 1; i >= 0; i--)
			{
				DataR.allyBullets[i].kill();
			}
			DataR.allyBullets.length = 0;
			for (i = DataR.enemyBullets.length - 1; i >= 0; i--)
			{
				DataR.enemyBullets[i].kill();
			}
			DataR.enemyBullets.length = 0;
			
			
			_bg.redraw("level" + ((level%10)+1));
			ScrollingBackground(_bg).render();
			
			primeLevel();
		}
		
		
		
		
		
		public function kUp(e:KeyboardEvent):void
		{
			if (e.keyCode == 32)
			{
				if (_ship.hasBomb  && !_ship.isFrozen)
				{
					_ship.hasBomb = false;
					_hud.updateBomb(_ship.hasBomb);
					
					_ship.bombsUsed++;
					if (_ship.bombsUsed  == 0)
					{
						var a:Award = new Award(3000, "Bombtastic!");
						Layers.Display.addChild(a);
						_ship.points += 3000;
					}
					else if (_ship.bombsUsed  == 5)
					{
						var b:Award = new Award(3000, "You're the bomb!");
						Layers.Display.addChild(b);
						_ship.points += 3000;
					}
					
					var explosion:BetterBombExplosion = new BetterBombExplosion();
					explosion.x = _ship.x;
					explosion.y = _ship.y;
					Layers.Effects.addChild(explosion);
					DataR.effects.push(explosion);
					//use bomb
					
					for (var i:int = DataR.enemies.length - 1; i >= 0 ; i--)
					{
						DataR.enemies[i].kill();
					}
					DataR.enemies.length = 0;
					
					//loop through mines to see if any are nearby
					var en:Entity;
					for (i = DataR.effects.length-1; i >=0; i--)
					{
						en = DataR.effects[i];
						if (en is Mine)
						{
							if (12000 > Math.pow(_ship.x - en.x, 2) + Math.pow(_ship.y - en.y, 2))
							{
								var explo:BetterExplosion = new BetterExplosion();
								explo.x = en.x;
								explo.y = en.y;
								Layers.Effects.addChild(explo);
								DataR.effects.push(explo);
								en.kill();
							}
						}
						
					}
				}
			}
		}
		
		
		public function kill():void
		{
			
			//**DataR.soundManager.stopMusic(DataR.mPlayGameCurrentMusic);
			//******************DataR.soundManager.stopMusic(DataR.mPlayGameCurrentMusic);
			//******************DataR.soundManager.stopMusic(DataR.mPlayGameCurrentMusic2);
			
			
			messenger.kill();
			
			
			trace("1");
			stage.removeEventListener(Event.ENTER_FRAME, frame);
			stage.removeEventListener(KeyboardEvent.KEY_UP, kUp);
			trace("2");
			var i:int;
			for (i = DataR.effects.length - 1; i >= 0; i--)
			{
				DataR.effects[i].kill();
			}
			trace("3");
			DataR.effects.length = 0;
			for (i = DataR.enemies.length - 1; i >= 0 ; i--)
			{
				DataR.enemies[i].nonExplosionKill();
			}
			trace("4");
			DataR.enemies.length = 0;
			for (i = DataR.allyBullets.length - 1; i >= 0; i--)
			{
				DataR.allyBullets[i].kill();
			}
			trace("5");
			DataR.allyBullets.length = 0;
			for (i = DataR.enemyBullets.length - 1; i >= 0; i--)
			{
				DataR.enemyBullets[i].kill();
			}
			DataR.enemyBullets.length = 0;
			trace("6");
			_ship.kill();
			//Layers.Background.parent.removeChild(Layers.Background);
			trace("7");
			Layers.Bullets.parent.removeChild(Layers.Bullets);
			trace("8");
			Layers.Display.parent.removeChild(Layers.Display);
			trace("9");
			Layers.Effects.parent.removeChild(Layers.Effects);
			trace("10");
			//Layers.Game.parent.removeChild(Layers.Game);
			trace("11");
			Layers.Items.parent.removeChild(Layers.Items);
			trace("12");
			Layers.Ships.parent.removeChild(Layers.Ships);
			trace("13");
			ScrollingBackground(_bg).kill();
			trace("14");
			_hud.kill();
			trace("15");
			//_ship.kill(); //moved up, so ref to stage exists
			trace("16");
			parent.removeChild(this);
			trace("17");
		}
		
		private function fadeMusic():void
		{
			//prevent case if sound volume is already 0, then it would play on fade out for no reason
			if (!DataR.musicOn)
			{
				return;
			}
			//******************DataR.soundManager.changeVolume(DataR.mPlayGameLoop1, alpha);
			//******************DataR.soundManager.changeVolume(DataR.mPlayGameLoop2, alpha);
		}
	}

}