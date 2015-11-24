package  
{
	import com.bit101.components.FPSMeter;
	import flash.display.Sprite;
	import flash.events.Event;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class StatusManager extends Sprite
	{
		//background
		public var statusBackgrond:StatusBar;
		
		public var FPS:FPSMeter;
		
		
		public function StatusManager() 
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function init(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			statusBackgrond = new StatusBar();
			statusBackgrond.x = stage.stageWidth / 2;
			statusBackgrond.y = statusBackgrond.height / 2;
			addChild(statusBackgrond);
			
			FPS = new FPSMeter(this, 0, 0);
			FPS.opaqueBackground = false;
		}
	}

}