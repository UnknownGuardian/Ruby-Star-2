package  
{
	import com.greensock.easing.Sine;
	import com.greensock.TweenMax;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class HUD extends Sprite
	{
		public var statusBackground:StatusBar;
		
		public var visitorFont:String = (new Visitor()).fontName;
		public var timeText:TextField;
		public var coinsText:TextField;
		public var pointsText:TextField;
		public var livesDisplay:Array = [];
		public var bombIcon:BombIcon;
		
		public var mute:Sprite;
		
		public var tempPoints:int = 0;
		
		public function HUD() 
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);

			statusBackground = new StatusBar();
			statusBackground.x = 0;
			statusBackground.y = 0;
			addChild(statusBackground);
			
			timeText = new TextField();
			timeText.mouseEnabled = false;
			timeText.x = 375;
			timeText.y = 3;
			timeText.width = 130;
			timeText.height = 35;
			timeText.embedFonts = true;
			timeText.defaultTextFormat = new TextFormat(visitorFont, 30, 0xFFFFFF, null, null, null, null, null, 'right');
			timeText.filters = [new GlowFilter(0xC5C1AA, 1, 3, 3)];
			timeText.text = "Time Left";
			addChild(timeText);
			
			coinsText = new TextField();
			coinsText.mouseEnabled = false;
			coinsText.x = 495;
			coinsText.y = 3;
			coinsText.width = 130;
			coinsText.height = 35;
			coinsText.embedFonts = true;
			coinsText.defaultTextFormat = new TextFormat(visitorFont, 30, 0xFFFFFF, null, null, null, null, null, 'right');
			coinsText.filters = [new GlowFilter(0xC5C1AA, 1, 3, 3)];
			coinsText.text = "0";
			addChild(coinsText);
			
			
			pointsText = new TextField();
			pointsText.mouseEnabled = false;
			pointsText.x = 145;
			pointsText.y = 3;
			pointsText.width = 130;
			pointsText.height = 35;
			pointsText.embedFonts = true;
			pointsText.defaultTextFormat = new TextFormat(visitorFont, 30, 0xFFFFFF, null, null, null, null, null, 'right');
			pointsText.filters = [new GlowFilter(0xFFE303, 1, 3, 3)];
			pointsText.text = "0";
			addChild(pointsText);
			
			bombIcon = new BombIcon();
			bombIcon.x = 300;
			bombIcon.y = 6;
			addChild(bombIcon);
			
			
			mute = new Mute();
			mute.x = stage.stageWidth - mute.width - 5;
			mute.y = stage.stageHeight - mute.height - 5;
			//mute.addEventListener(MouseEvent.CLICK, changeSoundVolume);
			addChild(mute);
			stage.addEventListener(KeyboardEvent.KEY_UP, changeSoundVolume);
			
			
			for (var i:int = 0; i < 4; i++)
			{
				var s:Ship = new Ship();
				s.x = 27 + i * 25;
				s.y = 19;
				s.rotation = -90;
				s.scaleX = s.scaleY = 0.70;
				addChild(s);
				livesDisplay.push(s);
			}
		}
		
		public function updateTime(t:int):void
		{
			timeText.text = t.toString();
		}
		
		public function updateCoinsLeft(m:int):void
		{
			coinsText.text = m.toString();
		}
		
		public function updatePointsLeft(p:int):void
		{
			TweenMax.to(this, 1, { tempPoints:p, onUpdate:changePointsText, ease:Sine.easeInOut } );
			//pointsText.text = p.toString();
		}
		public function changePointsText():void
		{
			pointsText.text = tempPoints.toString();
		}
		
		public function updateLivesLeft(lives:int):void
		{
			for (var i:int = 0; i < 4; i++)
			{
				if (i < lives)
				{
					livesDisplay[i].visible = true;
				}
				else
				{
					livesDisplay[i].visible = false;
				}
			}
		}
		
		public function updateBomb(hasBomb:Boolean):void
		{
			bombIcon.alpha = hasBomb?1:0.5;
		}
		
		
		public function kill():void
		{
			removeChild(timeText);
			removeChild(coinsText);
			removeChild(pointsText);
			
			for (var i:int = 0; i < 4; i++)
			{
				removeChild(livesDisplay[i]);
			}
			livesDisplay.length = 0;
			
			removeChild(statusBackground);
			
			tempPoints = 0;
		}
		
		public function changeSoundVolume(e:KeyboardEvent):void
		{
			if (e.keyCode == 77) //m
			{
				DataR.soundOn = !DataR.soundOn;
				//mute.removeEventListener(MouseEvent.CLICK, changeSoundVolume);
				removeChild(mute);
				
				if (!DataR.soundOn) //if sound off, show x sound
				{
					DataR.soundManager.changeGlobalVolume(0);
					mute = new MuteActive();
					mute.x = stage.stageWidth - mute.width - 5;
					mute.y = stage.stageHeight - mute.height - 5;
					//mute.addEventListener(MouseEvent.CLICK, changeSoundVolume);
					addChild(mute);
				}
				if (DataR.soundOn) //if sound on, show no x sound
				{
					DataR.soundManager.changeGlobalVolume(1);
					mute = new Mute();
					mute.x = stage.stageWidth - mute.width - 5;
					mute.y = stage.stageHeight - mute.height - 5;
					//mute.addEventListener(MouseEvent.CLICK, changeSoundVolume);
					addChild(mute);
				}
			}
		}
	}
}