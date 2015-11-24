package  
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class BetterCursor extends Cursor
	{
		
		public function BetterCursor() 
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		public function init(e:Event):void
		{
			Mouse.hide();
			removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, frame, false, 0, true);
			addEventListener(Event.REMOVED_FROM_STAGE, kill);
			mouseEnabled = false;
			x = stage.mouseX;
			y = stage.mouseY;
		}
		
		public function frame(e:MouseEvent):void
		{
			x = e.stageX;
			y = e.stageY;
			if (stage.getChildIndex(this) != stage.numChildren - 1)
			{
				stage.setChildIndex(this, stage.numChildren-1);
			}
		}
		
		public function forceOnTop():void
		{
			if (stage && stage.getChildIndex(this) != stage.numChildren - 1)
			{
				stage.setChildIndex(this, stage.numChildren-1);
			}
		}
		
		public function show():void
		{
			Mouse.hide();
			visible = true;
		}
		public function hide():void
		{
			Mouse.show();
			visible = false;
		}
		
		public function kill(e:Event):void
		{
			Mouse.show();
			removeEventListener(Event.REMOVED_FROM_STAGE, kill);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, frame);
			if (parent)
			{
				parent.removeChild(this);
			}
			trace("killed");
		}
	}

}