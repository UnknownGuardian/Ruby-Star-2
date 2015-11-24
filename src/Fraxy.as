package  
{
	import flash.filters.GlowFilter;
	/**
	 * ...
	 * @author UnknownGuardian
	 */
	public class Fraxy extends FraxyCenter
	{
		public var healthPiece:FraxyHealth;
		public var regenPiece:FraxyRegen;
		public var powerPiece:FraxyPower;
		
		public var rotationSpeed:Number = 1.5;
		
		public function Fraxy() 
		{
			healthPiece = new FraxyHealth();
			healthPiece.x = 56;
			healthPiece.y = 35;
			addChild(healthPiece);
			
			regenPiece = new FraxyRegen();
			regenPiece.x = 3;
			regenPiece.y = -50;
			addChild(regenPiece);
			
			powerPiece = new FraxyPower();
			powerPiece.x = -55;
			powerPiece.y = 35;
			addChild(powerPiece);
			
			x = 200;
			y = 300;
		}
		
		
		override public function frame():void
		{
			rotation+= rotationSpeed
			
			healthPiece.rotation -= rotationSpeed
			regenPiece.rotation -= rotationSpeed
			powerPiece.rotation -= rotationSpeed
		}
		
		override public function kill():void
		{
			healthPiece.kill();
			regenPiece.kill();
			powerPiece.kill();
			super.kill();
		}
		
		
	}

}