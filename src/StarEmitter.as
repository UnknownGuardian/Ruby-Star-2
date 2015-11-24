package {
	import idv.cjcat.stardust.common.actions.Age;
	import idv.cjcat.stardust.common.actions.DeathLife;
	import idv.cjcat.stardust.common.actions.ScaleCurve;
	import idv.cjcat.stardust.common.clocks.Clock;
	import idv.cjcat.stardust.common.initializers.Life;
	import idv.cjcat.stardust.common.initializers.Scale;
	import idv.cjcat.stardust.common.math.UniformRandom;
	import idv.cjcat.stardust.twoD.actions.Damping;
	import idv.cjcat.stardust.twoD.actions.Move;
	import idv.cjcat.stardust.twoD.actions.Spin;
	import idv.cjcat.stardust.twoD.emitters.Emitter2D;
	import idv.cjcat.stardust.twoD.initializers.DisplayObjectClass;
	import idv.cjcat.stardust.twoD.initializers.Omega;
	import idv.cjcat.stardust.twoD.initializers.Position;
	import idv.cjcat.stardust.twoD.initializers.Rotation;
	import idv.cjcat.stardust.twoD.initializers.Velocity;
	import idv.cjcat.stardust.twoD.zones.LazySectorZone;
	import idv.cjcat.stardust.twoD.zones.SinglePoint;

	public class StarEmitter extends Emitter2D {

		/**
		 * Constants
		 */
		private static const LIFE_AVG:Number = 250;
		private static const LIFE_VAR:Number = 100;
		private static const SCALE_AVG:Number = 1;
		private static const SCALE_VAR:Number = 0.4;
		private static const GROWING_TIME:Number = 5;
		private static const SHRINKING_TIME:Number = 10;
		private static const SPEED_AVG:Number = 4;
		private static const SPEED_VAR:Number = 2;
		private static const OMEGA_AVG:Number = 0;
		private static const OMEGA_VAR:Number = 5;
		private static const DAMPING:Number = 0.01;

		public var point:SinglePoint;

		public function StarEmitter(clock:Clock) {
			super(clock);

			point = new SinglePoint();

			//initializers
			addInitializer(new DisplayObjectClass(ParticleBlack));
			addInitializer(new Life(new UniformRandom(LIFE_AVG, LIFE_VAR)));
			addInitializer(new Scale(new UniformRandom(SCALE_AVG, SCALE_VAR)));
			addInitializer(new Position(point));
			addInitializer(new Velocity(new LazySectorZone(SPEED_AVG, SPEED_VAR)));
			addInitializer(new Rotation(new UniformRandom(0, 180)));
			addInitializer(new Omega(new UniformRandom(OMEGA_AVG, OMEGA_VAR)));

			//actions
			addAction(new Age());
			addAction(new DeathLife());
			addAction(new Move());
			addAction(new Spin());
			addAction(new Damping(DAMPING));
			addAction(new ScaleCurve(GROWING_TIME, SHRINKING_TIME));
		}
	}
}
