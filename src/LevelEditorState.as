package  
{
	import com.greensock.TweenMax;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.system.System;
	import flash.text.TextField;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class LevelEditorState extends GameState
	{
		public var symmetric:Boolean = false;
		
		public var current:Sprite = new Sprite();
		public var m:Mine = new Mine();
		public var m2:Mine = new Mine();
		public var c:Coin = new Coin();
		public var c2:Coin = new Coin();
		
		public var placedItems:Array = [];
		
		public function LevelEditorState() 
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
			
			createShip();
			createFrameListener();	
			
			Layers.Items.addChild(m);
			Layers.Items.addChild(m2);
			Layers.Items.addChild(c);
			Layers.Items.addChild(c2);
		}
		public function createGame():void
		{
			Layers.Game = this;
		}
		public function createBackgroundLayer():void
		{
			_bg = new ScrollingBackground("limeGreen");
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
			_ship = new BetterShip(null);
			_ship.x = 320;
			_ship.y = 240;
			Layers.Ships.addChild(_ship);
		}
		public function createFrameListener(e:Event = null):void
		{
			stage.addEventListener(Event.ENTER_FRAME, frame);
			stage.addEventListener(KeyboardEvent.KEY_UP, kUp);
			stage.addEventListener(MouseEvent.CLICK, place);
		}
		
		public function frame(e:Event):void
		{
			if (current)
			{
				m.x = -100;
				m.y = -100;
				c.x = -100;
				c.y = -100;
				
				current.x = int((stage.mouseX - ScrollingBackground(_bg).X)/10) * 10;
				current.y = int((stage.mouseY - ScrollingBackground(_bg).Y)/10) * 10;
				if (symmetric)
				{
					m2.x = 800 - current.x;
					m2.y = m.y;
					c2.x = 800 - current.x;
					c2.y = c.y
				}
				else
				{
					m2.x = -100;
					m2.y = -100;
					c2.x = -100;
					c2.y = -100;
				}
			}
			//frame
			_ship.frame();
		}
		
		public function place(e:MouseEvent):void
		{
			if (current is Mine)
			{
				var mine:Mine = new Mine();
				mine.x = current.x;
				mine.y = current.y;
				Layers.Items.addChild(mine);
				placedItems.push(mine);
				if (symmetric)
				{
					mine= new Mine();
					mine.x = 800 - current.x;
					mine.y = current.y;
					Layers.Items.addChild(mine);
					placedItems.push(mine);
				}
			}
			if (current is Coin)
			{
				var coin:Coin = new Coin();
				coin.x = current.x
				coin.y = current.y
				Layers.Items.addChild(coin);
				placedItems.push(coin);
				if (symmetric)
				{
					coin = new Coin();
					coin.x = 800 - current.x;
					coin.y = current.y;
					Layers.Items.addChild(coin);
					placedItems.push(coin);
				}
			}
		}
		
		public function kUp(e:KeyboardEvent):void
		{
			if (e.keyCode == 65) //mine  a 
			{
				current = m;
			}
			if (e.keyCode == 83) //coin   s 
			{
				current = c;
			}
			if (e.keyCode == 81) //print  d 
			{
				clear();
			}
			if (e.keyCode == 68) //print  d 
			{
				print();
			}
			if (e.keyCode == 69) //print  e 
			{
				if (placedItems.length == 0)
				{
					return;
				}
				var en:Entity = placedItems.pop();
				en.parent.removeChild(en);
			}
			if (e.keyCode == 87) //symmetry  w 
			{
				symmetric = !symmetric;
			}
		}
		
		public function print():void
		{
			var s:String = "";
			s += "public static var field:Array = [";
			for (var i:int = 0; i < placedItems.length; i++)
			{
				s += "{t:'";
				s += (placedItems[i] is Mine) ? "M" : "C";
				s += "', x:" + placedItems[i].x + ", y:" + placedItems[i].y + "}";
				if (i != placedItems.length - 1)
				{
					s += ",";
				}
			}
			s += "];";
			trace(s);
			
			var t:TextField = new TextField();
			t.width = stage.stageWidth;
			t.height = stage.stageHeight;
			t.textColor = 0xFFFFFF;
			t.wordWrap = true;
			t.text = s;
			t.name = "textprint";
			t.mouseEnabled = false;
			t.selectable = true;
			stage.addChild(t);
			TweenMax.to(t, 1, { delay:5, alpha:0, onComplete:killT } );
			System.setClipboard(s);
		}
		
		public function killT():void
		{
			stage.removeChild(stage.getChildByName("textprint"));
		}
		
		public function clear():void
		{
			for (var i:int = 0; i < placedItems.length; i++)
			{
				Layers.Items.removeChild(placedItems[i]);
			}
			placedItems.length = 0;
		}
	}

}