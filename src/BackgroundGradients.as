package  
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class BackgroundGradients
	{
		public static var customImages:Array = ["backgroundLevelSelectStars"];
		public static var limeGreen:Object = { from:0x3BBB2A, to:0x265C4C };
		public static var level1:Object = { from:0x77c62d, to:0x50a767 };
		public static var level2:Object = { from:0xffde00, to:0xee850a };
		public static var level3:Object = { from:0x00f6ff, to:0x0bebb7 };
		
		public static var level4:Object = { from:0x0359fa, to:0x0e9be9 };
		public static var level5:Object = { from:0xed06cc, to:0xd410e6 };
		public static var level6:Object = { from:0x9e9e9e, to:0xdfdfdf };
		public static var level7:Object = { from:0x1f1e1f, to:0x404040 };
		public static var level8:Object = { from:0x29ccaf, to:0x28ccb0 };
		public static var level9:Object = { from:0x8f2d32, to:0x9028c6 };
		public static var level10:Object = { from:0x2a3257, to:0x0a0c14, point:"center" };



		
		
		public function BackgroundGradients() 
		{
			
		}
		
		
		
		
		public static function getGradientBitmap(type:Object, Width:int = 800, Height:int = 600):Bitmap
		{
			var d:BitmapData = new BitmapData(Width, Height, true);
			
			var s:Sprite = new Sprite();
			var g:Graphics = s.graphics;
			
			var m:Matrix = new Matrix(); 
			m.createGradientBox( Width*2, Height*2, 2.53, -Width*0.75, -Height*0.75);
			
			g.beginGradientFill("radial", [type.from, type.to], [1, 1], [0, 255], m, "pad", "rgb", 0);
			g.drawRect(0, 0, Width, Height);
			g.endFill();
			
			d.draw(s);
			
			return new Bitmap(d);
		}
		
	}

}