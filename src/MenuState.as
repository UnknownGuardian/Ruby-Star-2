package  
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Sine;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageQuality;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class MenuState extends GameState
	{
		public var main:Sprite = new Sprite();
		public var options:Sprite = new Sprite();
		public var credits:Sprite = new Sprite();
		public var game:PlayState;
		
		public var particles:StarParticles;
		
		public function MenuState() 
		{
			game = new PlayState();
			
			
			main.addChild(DataR.MenuMain);
			options.addChild(DataR.MenuOptions);
			credits.addChild(DataR.MenuCredits);
			
			main.addChild(createLayOver(189, 279, 266, 35, gotoGameFromMain));
			main.addChild(createLayOver(189, 338, 266, 35, gotoOptionsFromMain));
			main.addChild(createLayOver(189, 397, 266, 35, gotoCreditsFromMain));
			
			options.addChild(createLayOver(169, 174, 93, 40, turnMusicOn));
			options.addChild(createLayOver(376, 174, 93, 40, turnMusicOff));
			options.addChild(createLayOver(121, 243, 93, 40, turnSoundOn));
			options.addChild(createLayOver(430, 243, 93, 40, turnSoundOff));
			options.addChild(createLayOver(169, 309, 93, 40, setHighQuality));
			options.addChild(createLayOver(380, 309, 93, 40, setMediumQuality));
			options.addChild(createLayOver(245, 414, 155, 40, gotoMainFromOptions));
			
			credits.addChild(createLayOver(212, 166, 211, 42, openProfusionSite));
			credits.addChild(createLayOver(212, 251, 211, 25, openProfusionBlogSite));
			credits.addChild(createLayOver(232, 315, 170, 22, openDavidSite));
			credits.addChild(createLayOver(226, 373, 183, 22, openKevinSite));
			credits.addChild(createLayOver(245, 421, 155, 40, gotoMainFromCredits));
			show("main");
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			DataR.mPlayMenuLoop = DataR.soundManager.playMusic(DataR.mMenuLoop, Infinity);
			DataR.soundManager.changeVolume(DataR.mPlayMenuLoop, 0.5);
			if (!DataR.musicOn)
			{
				DataR.soundManager.changeVolume(DataR.mPlayMenuLoop, 0);
			}
			
			
			DataR.cursor = new BetterCursor();
			stage.addChild(DataR.cursor);
			particles = new StarParticles();
			stage.addChild(particles);
		}
		
		
		
		
		public function gotoGameFromMain(e:MouseEvent):void {
			TweenMax.to(main, 1.5, { alpha:0, onComplete:kill, onUpdate:fadeMusic } );
			
			if (DataR.soundOn)
			{
				DataR.soundManager.playSound(DataR.mTransition);
			}
		}
		public function gotoOptionsFromMain(e:MouseEvent):void {
			addChild(options);
			options.x = -640;
			TweenMax.to(options, 1, { x:0, ease:Sine.easeInOut } );
			TweenMax.to(main, 1, { x:640, onComplete:show, onCompleteParams:["options"], ease:Sine.easeInOut } );
			if (DataR.soundOn)
			{
				DataR.soundManager.playSound(DataR.mTransition);
			}
		}
		public function gotoCreditsFromMain(e:MouseEvent):void {
			addChild(credits);
			credits.x = 640;
			TweenMax.to(credits, 1, { x:0, ease:Sine.easeInOut } );
			TweenMax.to(main, 1, { x: -640, onComplete:show, onCompleteParams:["credits"], ease:Sine.easeInOut } );
			if (DataR.soundOn)
			{
				DataR.soundManager.playSound(DataR.mTransition);
			}
		}
		public function gotoMainFromOptions(e:MouseEvent):void {
			addChild(main);
			main.x = 640;
			TweenMax.to(options, 1, { x:-640, ease:Sine.easeInOut } );
			TweenMax.to(main, 1, { x:0, onComplete:show, onCompleteParams:["main"], ease:Sine.easeInOut } );
			if (DataR.soundOn)
			{
				DataR.soundManager.playSound(DataR.mTransition);
			}
		}
		public function gotoMainFromCredits(e:MouseEvent):void {
			addChild(main);
			main.x = -640;
			TweenMax.to(credits, 1, { x:640, ease:Sine.easeInOut } );
			TweenMax.to(main, 1, { x:0, onComplete:show, onCompleteParams:["main"], ease:Sine.easeInOut } );
			if (DataR.soundOn)
			{
				DataR.soundManager.playSound(DataR.mTransition);
			}
		}
		
		
		
		
		
		
		
		
		public function turnMusicOn(e:MouseEvent):void {
			DataR.musicOn = true;
			trace("[MenuState] Music is on");
			DataR.soundManager.changeVolume(DataR.mPlayMenuLoop, 1);
			if (DataR.soundOn)
			{
				DataR.soundManager.playSound(DataR.mSelect);
			}
		}
		public function turnMusicOff(e:MouseEvent):void {
			DataR.musicOn = false;
			trace("[MenuState] Music is off");
			DataR.soundManager.changeVolume(DataR.mPlayMenuLoop, 0);
			if (DataR.soundOn)
			{
				DataR.soundManager.playSound(DataR.mSelect);
			}
		}
		public function turnSoundOn(e:MouseEvent):void {
			DataR.soundOn = true;
			trace("[MenuState] Sound is on");
			if (DataR.soundOn)
			{
				DataR.soundManager.playSound(DataR.mSelect);
			}
		}
		public function turnSoundOff(e:MouseEvent):void {
			if (DataR.soundOn)
			{
				DataR.soundManager.playSound(DataR.mSelect);
			}
			DataR.soundOn = false;
			trace("[MenuState] Sound is off");
		}
		public function setHighQuality(e:MouseEvent):void {
			stage.quality = StageQuality.HIGH;
			trace("[MenuState] Stage Quality is : " + stage.quality);
			if (DataR.soundOn)
			{
				DataR.soundManager.playSound(DataR.mSelect);
			}
		}
		public function setMediumQuality(e:MouseEvent):void {
			stage.quality = StageQuality.MEDIUM;
			trace("[MenuState] Stage Quality is : " + stage.quality);
			if (DataR.soundOn)
			{
				DataR.soundManager.playSound(DataR.mSelect);
			}
		}
		
		
		
		
		
		public function openProfusionSite(e:MouseEvent):void {
			//Log.CustomMetric("Went to ProfusionGames.com", "Menu");
			//navigateToURL(new URLRequest("http://profusiongames.com/"), "_blank");
			if (DataR.soundOn)
			{
				DataR.soundManager.playSound(DataR.mSelect);
			}
		}
		public function openProfusionBlogSite(e:MouseEvent):void {
			//Log.CustomMetric("Went to ProfusionGames.com/blog", "Menu");
			//navigateToURL(new URLRequest("http://profusiongames.com/blog"), "_blank");
			if (DataR.soundOn)
			{
				DataR.soundManager.playSound(DataR.mSelect);
			}
		}
		public function openDavidSite(e:MouseEvent):void {
			//Log.CustomMetric("Went to davidarcila.com", "Menu");
			//navigateToURL(new URLRequest("http://davidarcila.com/"), "_blank");
			if (DataR.soundOn)
			{
				DataR.soundManager.playSound(DataR.mSelect);
			}
		}
		
		public function openKevinSite(e:MouseEvent):void {
			//Log.CustomMetric("Went to davidarcila.com", "Menu");
			//navigateToURL(new URLRequest("http://davidarcila.com/"), "_blank");
			if (DataR.soundOn)
			{
				DataR.soundManager.playSound(DataR.mSelect);
			}
		}
		
		
		
		private function fadeMusic():void
		{
			//prevent case if sound volume is already 0, then it would play on fade out for no reason
			if (!DataR.musicOn)
			{
				return;
			}
			DataR.soundManager.changeVolume(DataR.mPlayMenuLoop, main.alpha);
		}
		
		
		
		
		
		
		
		
		
		public function show(t:String):void
		{			
			if (main.parent)
			{
				removeChild(main);
			}
			if (options.parent)
			{
				removeChild(options);
			}
			if (credits.parent)
			{
				removeChild(credits);
			}
			addChild(this[t]);
		}
		
		public function kill():void
		{
			DataR.soundManager.stopMusic(DataR.mPlayMenuLoop);
			
			if (main.parent) {
				removeChild(main);
			}
			if (options.parent)	{
				removeChild(options);
			}
			if (credits.parent)	{
				removeChild(credits);
			}
			
			while (main.numChildren > 0) {
				main.removeChildAt(0);
			}
			while (options.numChildren > 0)	{
				options.removeChildAt(0);
			}
			while (credits.numChildren > 0)	{
				credits.removeChildAt(0);
			}
			particles.kill();
			
			stage.addChild(game);
			DataR.cursor.forceOnTop();
			parent.removeChild(this);
		}
		
		
		public function createLayOver(X:int, Y:int, Width:int, Height:int, onClick:Function):Sprite
		{
			var s:Sprite = new Sprite();
			s.x = X;
			s.y = Y;
			
			var m:Matrix = new Matrix();
			m.createGradientBox(Width, Height,1.5*3.141592);
			s.graphics.beginGradientFill("linear", [0xFFFFFF, 0xFFFFFF], [0.2, 0.01], [0, 255], m);
			s.graphics.drawRect(0, 0, Width, Height);
			s.graphics.endFill();
			s.alpha = 0;
			s.addEventListener(MouseEvent.ROLL_OVER, showHighlight, false, 0, true);
			s.addEventListener(MouseEvent.ROLL_OUT, hideHighlight, false, 0, true);
			s.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
			return s;
		}
		
		public function showHighlight(e:MouseEvent):void
		{
			e.currentTarget.alpha = 1;
			e.currentTarget.filters = [new GlowFilter(0xFFE303, 0.2, 16, 16), new GlowFilter(0x236B8E,0.3,30,0,4)];
		}
		public function hideHighlight(e:MouseEvent):void
		{
			e.currentTarget.alpha = 0;
			e.currentTarget.filters = [];
		}
		
		
	}

}