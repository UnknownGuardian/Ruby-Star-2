package  
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendModeShader;
	import flash.display.DisplayObject;
	import flash.display.shaders.*;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class ScrollingBackground extends Sprite
	{
		//public var hexagonBG:HexagonBackground = new HexagonBackground();
		
		public static var WIDTH:Number;
		public static var HEIGHT:Number;
		
		public var fullBitmap:Bitmap;
		public var containerSprite:Sprite = new Sprite();
		
		public var displacementRect:Rectangle = new Rectangle(80, 60, 640, 480);
		
		public var exit:BorderExit;
				
		public function ScrollingBackground(gradientType:String = "") 
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
			
			redraw(gradientType)
						
			WIDTH = fullBitmap.width;// 800;
			HEIGHT = fullBitmap.height;// 600;
			
			render();
			exit = new BorderExit();
			exit.x = 399;
			exit.y = 70;
			addChild(exit);
			
			exit.activate();
		}
		public function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		
		public function redraw(gradientType:String):void
		{
			if (BackgroundGradients.customImages.indexOf(gradientType) == -1)
			{
				draw(gradientType);
			}
			else
			{
				drawOther(gradientType);
				//load the custom image
			}
		}
		
		
		
		
		
		
		public function draw(type:String = ""):void //clean this method up. perhaps remove gradient, hexCells, stars bitmaps. Pointless
		{
			var linear:BlendModeLinearDodge = new BlendModeLinearDodge();
			linear.alpha = .6;
			var color:BlendModeColorDodge = new BlendModeColorDodge();
			color.alpha = 0.65;
			var mySprite:Sprite = new Sprite();
			
			//mySprite.addChild(new Bitmap(DataR.backgroundBasicStars.bitmapDataR.clone()));
			mySprite.addChild(new Bitmap(new BitmapData(800, 600, false, 0x000000)));
			mySprite.addChild(new Bitmap(BackgroundGradients.getGradientBitmap(BackgroundGradients[type]).bitmapData.clone()));
			mySprite.addChild(new Bitmap(DataR.backgroundBasicHexagon.bitmapData.clone()));

			mySprite.addChild(new GameBorder());
			
			//mySprite.getChildAt(0).blendShader = linear;
			//mySprite.getChildAt(1).blendShader = color;
			mySprite.getChildAt(1).blendShader = linear;
			mySprite.getChildAt(2).blendShader = color;
			
			var bd:BitmapData = new BitmapData(mySprite.width, mySprite.height);
			bd.draw(mySprite);
			fullBitmap = new Bitmap(bd);
			fullBitmap.scrollRect = displacementRect;
			addChild(fullBitmap);
			
			
			while (mySprite.numChildren > 0)
			{
				mySprite.removeChild(mySprite.getChildAt(0));
			}
			mySprite = null;
			
			addChild(containerSprite);
		}
		
		/* The old draw method [backup]
		public function draw(type:String = ""):void 
		{
			var mySprite:Sprite = new Sprite();
			
			stars = new Bitmap(Data.backgroundBasicStars.bitmapDataR.clone());
			mySprite.addChild(stars);
			
			DataR.backgroundBasicCustomGradient = BackgroundGradients.getGradientBitmap(BackgroundGradients[type]);
			gradient = new Bitmap(DataR.backgroundBasicCustomGradient.bitmapDataR.clone());
			mySprite.addChild(gradient);
			
			hexCells = new Bitmap(DataR.backgroundBasicHexagon.bitmapDataR.clone());
			mySprite.addChild(hexCells);
			
			var linear:BlendModeLinearDodge = new BlendModeLinearDodge();
			linear.alpha = .6;
			gradient.blendShader = linear;
			
			var color:BlendModeColorDodge = new BlendModeColorDodge();
			color.alpha = 0.65;
			hexCells.blendShader = color;
			
			var bd:BitmapData = new BitmapData(mySprite.width, mySprite.height);
			bd.draw(mySprite);
			fullBitmap = new Bitmap(bd);
			
			
			mySprite.removeChild(mySprite.getChildAt(0));
			mySprite = null;
			
			addChild(drawBitmap);
			addChild(containerSprite);
		}
		*/
		
		
		
		
		public function drawOther(type:String = "" ):void
		{
			var mySprite:Sprite = new Sprite();
			
			mySprite.addChild(DataR[type]);
			
			var bd:BitmapData = new BitmapData(mySprite.width, mySprite.height);
			bd.draw(mySprite);
			fullBitmap = new Bitmap(bd);
			
			mySprite.removeChild(mySprite.getChildAt(0));
			mySprite = null;
			
			addChild(containerSprite);
		}
		
		
		public function render(e:Event = null):void
		{
			fullBitmap.scrollRect = displacementRect;
		}
		
		override public function addChild(child:DisplayObject):DisplayObject
		{
			if (child != containerSprite && child != fullBitmap)// && child != exit)
			{
				return containerSprite.addChild(child);
			}
			return super.addChild(child);
		}
		
		public function get X():Number
		{
			return -displacementRect.x;
		}
		
		public function set X(_value:Number):void
		{
			displacementRect.x = -_value;
			containerSprite.x = _value
		}
		
		public function get Y():Number
		{
			return -displacementRect.y;
		}
		
		public function set Y(_value:Number):void
		{
			displacementRect.y = -_value;
			containerSprite.y = _value;
		}
		
		
		
		
		
		
		
		public function kill():void
		{
			fullBitmap.bitmapData.dispose();

			
			while (containerSprite.numChildren > 0)
			{
				containerSprite.removeChildAt(0);
			}
			while (numChildren > 0)
			{
				removeChildAt(0);
			}
			
			fullBitmap = null;
			
			if (parent)
			{
				parent.removeChild(this);
			}
		}
		
	}

}