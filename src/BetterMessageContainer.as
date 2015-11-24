package  
{
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class BetterMessageContainer extends Sprite
	{
		public var messageDisplay:MessageContainer;
		
		
		public var imFont:String = (new Imagine()).fontName;
		
		//animation details
		public var textField:TextField;
		public var isWriting:Boolean = false;
		public var fullString:Array = [];
		public var displayedString:String = "";
		public var index:int = 0;
		public var timer:Timer;
		public var textSpeed:int = 30;
		
		
		public function BetterMessageContainer() 
		{
			//messageDisplay = new MessageContainer();
			//messageDisplay.scaleX = 2;
			//addChild(messageDisplay);
			
			
			textField = new TextField();
			textField.x = 0;
			textField.y = 3;
			//textField.wordWrap = true;
			textField.antiAliasType = "advanced";
			textField.autoSize = 'left';
			textField.defaultTextFormat = new TextFormat(imFont, 15, 0xe4e4e4);
			addChild(textField);
			
			textField.filters = [new GlowFilter(0x000000, 1, 16, 16)];//new DropShadowFilter(4, 90, 0x000000, 1, 8, 8)];
		}
		
		
		
		
		public function changeMessage(m:String):void
		{
			if (!isWriting)
			{
				isWriting = true;
				index = 0;
				fullString = m.split("");
				displayedString = "";
				textField.text = "";

				timer = new Timer(textSpeed, fullString.length);
				timer.addEventListener(TimerEvent.TIMER, appendText);
				timer.addEventListener(TimerEvent.TIMER_COMPLETE, timerStop);
				timer.start();
			}
		}
		public function appendText(e:TimerEvent):void
		{
			textField.appendText(fullString[index]);
			index++;
		}
		public function timerStop(e:TimerEvent):void
		{
			timer.removeEventListener(TimerEvent.TIMER, appendText);
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE, timerStop);
			
			isWriting = false;
		}
	}

}