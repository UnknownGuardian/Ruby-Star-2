package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import skyboy.media.SoundManager;
	
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class Main extends Sprite 
	{
		public var count:int = 0;
		public var Game:MenuState;
		//public var Game:ScoreState = new ScoreState(10, 10, 100, 20, 20, 4);
		//public var Game:LevelSelectState = new LevelSelectState();
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			
			stage.scaleMode = "noScale";
			stage.align = "c";
			//stage.showDefaultContextMenu = false;
			
			DataR.soundManager = new SoundManager();
			DataR.sBomb = DataR.soundManager.addSound(new Bomb());
			DataR.sCoundDownNear = DataR.soundManager.addSound(new CountDownNear());
			DataR.sEnemySpawn = DataR.soundManager.addSound(new EnemySpawn());
			DataR.sExplode = DataR.soundManager.addSound(new Explode());
			DataR.sNewLevel = DataR.soundManager.addSound(new NewLevel());
			DataR.sShoot = DataR.soundManager.addSound(new Shoot());
			DataR.mMenuLoop = DataR.soundManager.addSound(new MenuLoop());
			DataR.mGameLoop1 = DataR.soundManager.addSound(new GameLoop1());
			DataR.mGameLoop2 = DataR.soundManager.addSound(new GameLoop2());
			DataR.mTransition = DataR.soundManager.addSound(new Transition());
			DataR.mSelect = DataR.soundManager.addSound(new Selection());
			DataR.sCoinCollect1 = DataR.soundManager.addSound(new CoinPickup1());
			DataR.sCoinCollect2 = DataR.soundManager.addSound(new CoinPickup2());
			DataR.sCoinCollect3 = DataR.soundManager.addSound(new CoinPickup3());
			DataR.sCoinCollect4 = DataR.soundManager.addSound(new CoinPickup4());
			DataR.sShipExplode = DataR.soundManager.addSound(new ShipExplosion());
			DataR.mPlayGameCurrentMusic = DataR.mGameLoop1;
			
			Game = new MenuState();
			var screen:SplashScreen = new SplashScreen(this);
			stage.addChild(screen);
			
			//proceed();
			//var ed:LevelEditorState = new LevelEditorState();
			//stage.addChild(ed);
		}
		
		public function proceed():void
		{
			
			stage.addChild(Game);
			
	
			
			
			//TODO add sound effects for menus
		}
		
		
		
		
		
		//fun project
		public function frame(e:Event):void
		{
			count++ && (count <= 1000000) && ( (count % 3 == 0 && count % 5 == 0) ? trace("FizzBuzz") : (count % 3 == 0) ? trace("Fizz") : (count % 5 == 0) ? trace("Buzz") : trace(count));
		}
	}
	
}