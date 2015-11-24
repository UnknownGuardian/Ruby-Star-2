package  
{
	import com.greensock.TweenMax;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class ScoreState extends GameState
	{
		public var visitorFont:String = (new Visitor()).fontName;
			
		public var Tscore:int = 0;
		public var mines:int = 0;
		public var coins:int = 0;
		public var bullets:int = 0;
		public var enemies:int = 0;
		public var lives:int = 0;
		
		public var vScore:TextField;
		public var vMines:TextField;
		public var vCoins:TextField;
		public var vBullets:TextField;
		public var vEnemies:TextField;
		public var vLives:TextField;
		
		public var sScore:TextField;
		public var sMines:TextField;
		public var sCoins:TextField;
		public var sBullets:TextField;
		public var sEnemies:TextField;
		public var sLives:TextField;
		
		public var glowAmount:int = 0;
		public var glowUp:Boolean = true;
				
		public function ScoreState(_Tscore:int, _minesDestroyed:int, _coinsCollected:int, _hitByBullet:int, _hitByEnemy:int, _livesLeft:int ) 
		{
			
			
			DataR.cursor.hide();
			
			_livesLeft++;
			
			TweenMax.to(this, 1, { delay:1.5, mines:_minesDestroyed });
			TweenMax.to(this, 1, { delay:2, coins:_coinsCollected });
			TweenMax.to(this, 1, { delay:2.5, bullets:_hitByBullet });
			TweenMax.to(this, 1, { delay:3, enemies:_hitByEnemy });
			TweenMax.to(this, 1, { delay:3.5, lives:_livesLeft } );
			TweenMax.to(this, 2, { delay:4, Tscore:_Tscore } );
			TweenMax.to(this, 1, { delay:6, onComplete:showMochi } );
			//score = _score;
			//mines = _minesDestroyed;
			//coins = _coinsCollected;
			//bullets = _hitByBullet;
			//enemies = _hitByEnemy;
			//lives = _livesLeft;
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		public function init(e:Event):void
		{
			graphics.beginFill(0x000000, 0.8);
			graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			graphics.endFill();
			
			var sc:Bitmap = DataR.MenuScore;
			sc.x = (stage.stageWidth - sc.width) / 2;
			sc.y = (stage.stageHeight - sc.height) / 2;
			addChild(sc);
			
			
			sScore = createSField(-20);
			sMines = createSField();
			sCoins = createSField();
			sBullets = createSField();
			sEnemies = createSField();
			sLives = createSField();
			
			vScore = createVField(-20);
			vMines = createVField();
			vCoins = createVField();
			vBullets = createVField();
			vEnemies = createVField();
			vLives = createVField();
			
			sScore.y = vScore.y = 138;
			sMines.y = vMines.y = 178;
			sCoins.y = vCoins.y = 216;
			sBullets.y = vBullets.y = 255;
			sEnemies.y = vEnemies.y = 292;
			sLives.y = vLives.y = 328;
			
			sScore.text = "Score: ";
			sMines.text = "Mines Hit: ";
			sCoins.text = "Coins: ";
			sBullets.text = "Bullets Hit: ";
			sEnemies.text = "Enemies Hit: ";
			sLives.text = "Lives Left: ";
			
			addEventListener(Event.ENTER_FRAME, frame);
		}
		
		public function createSField(posOffset:int = 0, size:int = 30):TextField
		{			
			var field:TextField = new TextField();
			field.mouseEnabled = false;
			field.x = 255 + posOffset;
			field.height = 35;
			field.embedFonts = true;
			field.autoSize = 'right';
			field.defaultTextFormat = new TextFormat(visitorFont,  size, 0xFFFFFF);// , null, null, null, null, null, 'right');
			field.filters = [new GlowFilter(0xC5C1AA, 1, 3, 3)];
			field.text = "";
			addChild(field);
			return field;
		}
		public function createVField(posOffset:int = 0, size:int = 30):TextField
		{			
			var field:TextField = new TextField();
			field.mouseEnabled = false;
			field.x = 345 + posOffset;
			field.height = 35;
			field.embedFonts = true;
			field.autoSize = 'left';
			field.defaultTextFormat = new TextFormat(visitorFont, size, 0xFFFFFF);// , null, null, null, null, null, 'left');
			field.filters = [new GlowFilter(0xFFE303, 1, 3, 3)];
			field.text = "";
			addChild(field);
			return field;
		}
		
		public function frame(e:Event):void
		{
			vScore.text = Tscore.toString();
			vMines.text  = mines.toString();
			vCoins.text  = coins.toString();
			vBullets.text  = bullets.toString();
			vEnemies.text  = enemies.toString();
			vLives.text  = lives.toString();
			
			if (glowUp)
			{
				glowAmount++;
				if (glowAmount == 10)
				{
					glowUp = false;
				}
			}
			else
			{
				glowAmount--;
				if (glowAmount == 0)
				{
					glowUp = true;
				}
			}
			vScore.filters = [new GlowFilter(0xFFE303, 1, glowAmount/2, glowAmount/2)];
			sScore.filters = [new GlowFilter(0xC5C1AA, 1, glowAmount/2, glowAmount/2)];
		}
		
		
		public function showMochi():void
		{
			var o:Object = { n: [6, 5, 11, 8, 8, 9, 9, 13, 5, 2, 11, 14, 1, 15, 12, 6], f: function (i:Number,s:String):String { if (s.length == 16) return s; return this.f(i+1,s + this.n[i].toString(16));}};
			var boardID:String = o.f(0,"");
		}
		
		
		public function closeScores():void
		{
			TweenMax.to(this, 1.5, { alpha:0 , onComplete:kill } );
			DataR.cursor.show();
		}
		
		public function kill():void
		{
			removeEventListener(Event.ENTER_FRAME, frame);
			
			while (numChildren > 0)
			{
				removeChildAt(0);
			}
			graphics.clear();
			parent.removeChild(this);
		}
		
	}

}