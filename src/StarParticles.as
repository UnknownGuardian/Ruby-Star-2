package {
	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import idv.cjcat.stardust.common.clocks.SteadyClock;
	import idv.cjcat.stardust.common.renderers.Renderer;
	import idv.cjcat.stardust.twoD.renderers.DisplayObjectRenderer;

	public class StarParticles extends Sprite {

		private var emitter:StarEmitter;

		public function StarParticles() {
			//instantiate the StarEmitter
			emitter = new StarEmitter(new SteadyClock(0.5));

			//the container sprite
			var container:Sprite = new Sprite();

			//the renderer that renders the particle effect
			var renderer:Renderer =  new DisplayObjectRenderer(container);
			renderer.addEmitter(emitter);

			//add the container to the display list, above the background
			addChild(container);

			//make use of the enter-frame event
			addEventListener(Event.ENTER_FRAME, mainLoop);
			
			x = 320;
			
			mouseChildren = false;
			mouseEnabled = false;
		}

		private function mainLoop(e:Event):void {
			//call the main loop
			emitter.step();
		}
		
		public function kill():void
		{
			emitter.clearActions();
			emitter.clearInitializers();
			emitter.clearParticles();
			emitter = null;
			removeEventListener(Event.ENTER_FRAME, mainLoop);
			parent.removeChild(this);
		}
	}
}
