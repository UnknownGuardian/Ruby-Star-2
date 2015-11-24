package  
{
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DisplacementMapFilter;
	import flash.filters.DisplacementMapFilterMode;
	import flash.geom.Point;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class DialogManager extends Sprite
	{
		//BORDER STUFF
		public var border:ThumbBorder;
		
		
		
		//MESSAGE STUFF
		public var messageDisplay:BetterMessageContainer;
		
		
		
		//FACE STUFF
		public var icon:Sprite;
		//create a variable to hold the displacement map filter  
		private var dmFilter:DisplacementMapFilter = createDMFilter();  
		private var fuzzMin:int = 1;
		private var fuzzMax:int = 5;
		
		
		
		
		
		
		public function DialogManager() 
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			
			border = new ThumbBorder();
			border.x = 0;
			border.y = -border.height;
			addChild(border);
			
			
			
			changeIcon("Ain");
			addEventListener(Event.ENTER_FRAME, frame);
			
			
			
			messageDisplay = new BetterMessageContainer();
			messageDisplay.x = border.width + messageDisplay.width / 2 + 3;
			messageDisplay.y = border.y;
			addChild(messageDisplay);
			

			x = 5;
			y = stage.stageHeight - 5;
			
			//displayMessage("Ain", "Lux Animals is about 7mo old, perched on the 11th floor of an office building 4 blocks from Times Square.");
		}
		

		
		
		
		
		
		
		
		//for the messages
		
		//display the message from      person     message
		public function displayMessage(p:String, m:String):void
		{
			changeIcon(p);
			messageDisplay.changeMessage(m);
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		//for the icon
		public function changeIcon(newPerson:String):void
		{
			if (icon != null)
			{
				icon.parent.removeChild(icon);
				icon.removeEventListener(MouseEvent.ROLL_OVER, mOver);
				icon.removeEventListener(MouseEvent.ROLL_OUT, mOut);
			}
			
			//change to new icon here
			if (newPerson == "Ain")
			{
				icon = new ThumbAin();
			}
			else if (newPerson == "Blaise")
			{
				icon = new ThumbBlaise();
			}
			else if (newPerson == "Nyx")
			{
				icon = new ThumbNyx();
			}
			else if (newPerson == "Operator")
			{
				icon = new ThumbOperator();
			}
						
			icon.x = border.x + 3;
			icon.y = border.y + 3;
			addChild(icon);
			icon.filters = [dmFilter];
			icon.addEventListener(MouseEvent.ROLL_OVER, mOver);
			icon.addEventListener(MouseEvent.ROLL_OUT, mOut);
		}
		
		public function frame(e:Event):void
		{
			dmFilter.scaleX = Math.random() * (fuzzMax-fuzzMin) + fuzzMin;
			dmFilter.mapPoint = new Point(0, 0 - Math.random() * 160);
			icon.filters = [dmFilter]; 
		}
		public function mOver(e:MouseEvent):void
		{
			fuzzMin = 3;
			fuzzMax = 10;
		}
		public function mOut(e:MouseEvent):void
		{
			fuzzMin = 1;
			fuzzMax = 5;
		}
		
		// create the displacement map filter
		private function createDMFilter():DisplacementMapFilter {

			var mapBitmap:BitmapData = new PersonDisplacementMap(0,0); // use the bitmap data from our StaticMap image
			var mapPoint:Point       = new Point(0, 0);  // position of the StaticMap image in relation to our button
			var channels:uint        = BitmapDataChannel.RED; // which color to use for displacement
			var componentX:uint      = channels;
			var componentY:uint      = channels;
			var scaleX:Number        = 5; // the amount of horizontal shift
			var scaleY:Number        = 1; // the amount of vertical shift
			var mode:String          = DisplacementMapFilterMode.COLOR;
			var color:uint           = 0;
			var alpha:Number         = 0;

			return new DisplacementMapFilter(
							mapBitmap,
							mapPoint,
							componentX,
							componentY,
							scaleX,
							scaleY,
							mode,
							color,
							alpha	);

		}
		
		
		
		
		
		
		
		public function kill():void
		{
			removeEventListener(Event.ENTER_FRAME, frame);
			removeChild(messageDisplay);
			removeChild(icon);
			icon.removeEventListener(MouseEvent.ROLL_OVER, mOver);
			icon.removeEventListener(MouseEvent.ROLL_OUT, mOut);
			removeChild(border);
			dmFilter = null;
			
			parent.removeChild(this);
		}

		
	}

}