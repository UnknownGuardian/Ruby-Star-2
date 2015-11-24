package  
{
	import com.greensock.easing.Linear;
	import com.greensock.TweenLite;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class Award extends Sprite
	{
		public var field:TextField;
		public var imFont:String = (new Imagine()).fontName;
		
		public var des:String;
		public var poi:int;
		
		public function Award(n:int, s:String) 
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
			des = s;
			poi = n;
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			y = 35;
			
			field = new TextField();
			field.y = 3;
			field.selectable = false
			field.autoSize = 'left';
			field.defaultTextFormat = new TextFormat(imFont, 30, 0xe4e4e4);
			field.filters = [new GlowFilter(0x000000, 1, 16, 16)];
			field.text = "+" + poi.toString() + "    " + des;
			field.x = field.width;
			addChild(field);
			
			graphics.beginFill(0xFFFFFF, 0.5);
			graphics.drawRect(0, 0, 640, 30);
			graphics.endFill();
			alpha = 0;
			TweenLite.to(this, 2, { alpha:1 } );
			TweenLite.to(field, 4.5, { x: -field.width, ease:Linear.easeNone } );
			TweenLite.to(this, 2, { alpha:0, delay:3, onComplete:kill, overwrite:false } );
		}
		
		public function kill():void
		{
			removeChild(field);
			parent.removeChild(this);
		}
	}

}