package  
{
	import flash.events.Event;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class GameCompleteEvent extends Event
	{
		public static const ENDURANCE_MODE:String = "endurance";
		public static const STORY_MODE:String = "story";
		public static const MISSION_MODE:String = "mission";
		
		public var data:Object = { };
		public var score:Number = 0;
		public var time:Number = 0;
		public var level:int = 0;
		
		public function GameCompleteEvent(Type:String, Data:Object = null, Score:Number = 0, Time:Number = 0, Level:int = 0) 
		{
			super(Type);
			Data? data = Data: null;
			score = Score;
			time = Time;
			level = Level;
		}
		
	}

}