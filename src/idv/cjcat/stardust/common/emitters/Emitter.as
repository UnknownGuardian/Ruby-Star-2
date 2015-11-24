package idv.cjcat.stardust.common.emitters {
	import idv.cjcat.signals.ISignal;
	import idv.cjcat.signals.Signal;
	import idv.cjcat.stardust.common.actions.Action;
	import idv.cjcat.stardust.common.actions.ActionCollection;
	import idv.cjcat.stardust.common.actions.ActionCollector;
	import idv.cjcat.stardust.common.clocks.Clock;
	import idv.cjcat.stardust.common.clocks.SteadyClock;
	import idv.cjcat.stardust.common.initializers.Initializer;
	import idv.cjcat.stardust.common.initializers.InitializerCollector;
	import idv.cjcat.stardust.common.particles.InfoRecycler;
	import idv.cjcat.stardust.common.particles.Particle;
	import idv.cjcat.stardust.common.particles.ParticleCollection;
	import idv.cjcat.stardust.common.particles.ParticleCollectionType;
	import idv.cjcat.stardust.common.particles.ParticleFastArray;
	import idv.cjcat.stardust.common.particles.ParticleIterator;
	import idv.cjcat.stardust.common.particles.ParticleList;
	import idv.cjcat.stardust.common.particles.PooledParticleFactory;
	import idv.cjcat.stardust.common.StardustElement;
	import idv.cjcat.stardust.common.xml.XMLBuilder;
	import idv.cjcat.stardust.sd;
	
	use namespace sd;
	
	/**
	 * This class takes charge of the actual particle simulation of the Stardust particle system.
	 */
	public class Emitter extends StardustElement implements ActionCollector, InitializerCollector {
		
		
		//signals
		//------------------------------------------------------------------------------------------------
		
		private var _onEmpty:ISignal = new Signal(Emitter);
		/**
		 * Dispatched when the emitter is empty of particles.
		 * <p/>
		 * Signature: (emitter:Emitter)
		 */
		public function get onEmpty():ISignal { return _onEmpty; }
		
		private var _onParticleAdd:ISignal = new Signal(Emitter, ParticleCollection);
		/**
		 * Dispatched when particles are added to the emitter.
		 * <p/>
		 * Signature: (emitter:Emitter, particles:ParticleCollection)
		 */
		public function get onParticleAdd():ISignal { return _onParticleAdd; }
		
		private var _onParticleRemove:ISignal = new Signal(Emitter, ParticleCollection);
		/**
		 * Dispatched when particles are removed from the emitter.
		 * <p/>
		 * Signature: (emitter:Emitter, particles:ParticleCollection)
		 */
		public function get onParticleRemove():ISignal { return _onParticleRemove; }
		
		private var _onStep:ISignal = new Signal(Emitter, ParticleCollection, Number);
		/**
		 * Dispatched when a single emitter step is complete.
		 * <p/>
		 * Signature: (emitter:Emitter, particles:ParticleCollection, time:Number)
		 */
		public function get onStep():ISignal { return _onStep; }
		
		//------------------------------------------------------------------------------------------------
		//end of signals
		
		
		//particle collections
		//------------------------------------------------------------------------------------------------
		
		/** @private */
		sd var _particles:ParticleCollection;
		/**
		 * Returns an array of particles for custom parameter manipulation. 
		 * Note that the returned array is merely a copy of the internal particle array, 
		 * so splicing particles out from this array does not remove the particles from simulation.
		 * @return
		 */
		public function get particles():ParticleCollection { return _particles; }
		
		//------------------------------------------------------------------------------------------------
		//end of particle collections
		
		
		private var _clock:Clock;
		/**
		 * Whether the emitter is active, true by default.
		 * 
		 * <p>
		 * If the emitter is active, it creates particles in each step according to its clock. 
		 * Note that even if an emitter is not active, the simulation of existing particles still goes on in each step.
		 * </p>
		 */
		public var active:Boolean;
		/** @private */
		public var needsSort:Boolean;
		
		/** @private */
		protected var factory:PooledParticleFactory;
		
		private var _actionCollection:ActionCollection = new ActionCollection();
		
		public function Emitter(clock:Clock = null, particlesCollectionType:int = 0) {
			needsSort = false;
			
			this.clock = clock;
			this.active = true;
			this.particleCollectionType = particlesCollectionType;
		}
		
		/**
		 * The clock determines how many particles the emitter creates in each step.
		 */
		public function get clock():Clock { return _clock; }
		public function set clock(value:Clock):void {
			if (!value) value = new SteadyClock(0);
			_clock = value;
		}
		
		//main loop
		//------------------------------------------------------------------------------------------------
		
		private var deadParticles:ParticleCollection = new ParticleFastArray();
		
		/**
		 * [Abstract Method] This method is invoked at the beginning of each step.
		 */
		protected function preStep():void {
			
		}
		
		/**
		 * [Abstract Method] This method is invoked at the end of each step.
		 */
		protected function postStep():void {
			
		}
		
		/**
		 * This method is the main simulation loop of the emitter.
		 * 
		 * <p>
		 * In order to keep the simulation go on, this method should be called continuously. 
		 * It is recommended that you call this method through the <code>Event.ENTER_FRAME</code> event or the <code>TimerEvent.TIMER</code> event.
		 * </p>
		 * @param	time The time interval of a single step of simulation. For instance, doubling this parameter causes the simulation to go twice as fast.
		 */
		public final function step(time:Number = 1):void {
			preStep();
			
			var i:int, len:int;
			var action:Action;
			var activeActions:Array;
			var p:Particle;
			var iter:ParticleIterator;
			var live:Boolean;
			var sorted:Boolean = false;
			
			//query clock ticks
			if (active) {
				var pCount:int = clock.getTicks(time);
				var newParticles:ParticleCollection = factory.createParticles(pCount);
				addParticles(newParticles);
			}
			
			//filter out active actions
			activeActions = [];
			
			for (i = 0, len = actions.length; i < len; ++i) {
				action = actions[i];
				if (action.active && action.mask) activeActions.push(action);
			}
			
			
			//sorting
			for (i = 0, len = activeActions.length; i < len; ++i) {
				action = activeActions[i];
				if (action.needsSortedParticles) {
					//sort particles
					_particles.sort();
					
					//set sorted index iterators
					iter = _particles.getIterator();
					while (p = iter.particle) {
						//p.sortedIndexIterator = iter.dump(ParticleListIteratorPool.get());
						p.sortedIndexIterator = iter.clone();
						iter.next();
					}
					sorted = true;
					break;
				}
			}
			
			len = activeActions.length;
			
			//update the first particle + invoke action preupdates.
			iter = _particles.getIterator();
			p = iter.particle;
			if (p) {
				live = true;
				for (i = 0; i < len; ++i) {
					action = activeActions[i];
					
					//preUpdate
					action.preUpdate(this, time);
					
					//main update
					if (action.mask & p.mask) action.update(this, p, time);
					
					//collect dead particle
					if (live && p.isDead) {
						deadParticles.add(p);
						live = false;
					}
				}
				if (live) iter.next();
				else iter.remove();
			}
			
			//update the remaining particles
			while (p = iter.particle) {
				live = true;
				
				for (i = 0; i < len; ++i) {
					action = activeActions[i];
					if (p.mask & action.mask) {
						//update particle
						action.update(this, p, time);
					}
					//collect dead particle
					if (live && p.isDead) {
						deadParticles.add(p);
						live = false;
					}
				}
				if (live) iter.next();
				else iter.remove();
			}
			
			//postUpdate
			for (i = 0; i < len; ++i) {
				action = activeActions[i];
				action.postUpdate(this, time);
			}
			
			//remove dead particles
			if (deadParticles.size) onParticleRemove.dispatch(this, deadParticles);
			
			iter = deadParticles.getIterator();
			while (p = iter.particle) {
				for (var key:* in p.recyclers) {
					var recycler:InfoRecycler = key as InfoRecycler;
					if (recycler) recycler.recycleInfo(p);
				}
				p.destroy();
				factory.recycle(p);
				iter.next();
			}
			deadParticles.clear();
			
			onStep.dispatch(this, particles, time);
			if (!numParticles) onEmpty.dispatch(this);
			
			postStep();
		}
		
		//------------------------------------------------------------------------------------------------
		//end of main loop
		
		
		//actions & initializers
		//------------------------------------------------------------------------------------------------
		/** @private */
		sd final function get actions():Array { return _actionCollection.sd::actions; }
		
		/**
		 * Adds an action to the emitter.
		 * @param	action
		 */
		public function addAction(action:Action):void {
			_actionCollection.addAction(action);
		}
		
		/**
		 * Removes an action from the emitter.
		 * @param	action
		 */
		public final function removeAction(action:Action):void {
			_actionCollection.removeAction(action);
		}
		
		/**
		 * Removes all actions from the emitter.
		 */
		public final function clearActions():void {
			_actionCollection.clearActions();
		}
		
		/** @private */
		sd final function get initializers():Array { return factory.sd::initializerCollection.sd::initializers; }
		
		/**
		 * Adds an initializer to the emitter.
		 * @param	initializer
		 */
		public function addInitializer(initializer:Initializer):void {
			factory.addInitializer(initializer);
		}
		
		/**
		 * Removes an initializer form the emitter.
		 * @param	initializer
		 */
		public final function removeInitializer(initializer:Initializer):void {
			factory.removeInitializer(initializer);
		}
		
		/**
		 * Removes all initializers from the emitter.
		 */
		public final function clearInitializers():void {
			factory.clearInitializers();
		}
		//------------------------------------------------------------------------------------------------
		//end of actions & initializers
		
		
		//particles
		//------------------------------------------------------------------------------------------------
		
		/**
		 * The number of particles in the emitter.
		 */
		public final function get numParticles():int {
			return _particles.size;
		}
		
		/**
		 * This method is used to manually add existing particles to the emitter's simulation.
		 * 
		 * <p>
		 * You should use the <code>particleFactory</code> class to manually create particles.
		 * </p>
		 * @param	particles
		 */
		public final function addParticles(particles:ParticleCollection):void {
			var particle:Particle;
			var iter:ParticleIterator = particles.getIterator();
			while (particle = iter.particle) {
				_particles.add(particle);
				iter.next();
			}
			
			if (particles.size) onParticleAdd.dispatch(this, particles);
		}
		
		/**
		 * Clears all particles from the emitter's simulation.
		 */
		public final function clearParticles():void {
			var temp:ParticleCollection = _particles;
			
			if (temp.size) onParticleRemove.dispatch(this, temp);
			
			var particle:Particle;
			var iter:ParticleIterator = temp.getIterator();
			while (particle = iter.particle) {
				particle.destroy();
				factory.recycle(particle);
				
				iter.remove();
			}
			
			//create new empty particle collection
			_particles = null;
			this.particleCollectionType = this.particleCollectionType;
		}
		
		/**
		 * Determines the collection used internally by the emitter. There are two options: linked-lists and arrays. 
		 * Linked-Lists are generally faster to iterate through and remove particles from, while arrays are faster at sorting. 
		 * By default, linked-lists are used. Switch to arrays if the particles need to be sorted.
		 * 
		 * <p>
		 * There are two possible values that can assigned to this property: <code>ParticleCollectionType.LINKED_LIST</code> and <code>ParticleCollectionType.ARRAY</code>.
		 * </p>
		 * @see idv.cjcat.stardust.common.particles.ParticleCollectionType
		 */
		public function get particleCollectionType():int {
			if (_particles is ParticleFastArray) return ParticleCollectionType.FAST_ARRAY;
			else if (_particles is ParticleList) return ParticleCollectionType.LINKED_LIST;
			return -1;
		}
		
		public function set particleCollectionType(value:int):void {
			var temp:ParticleCollection;
			
			switch (value) {
				case ParticleCollectionType.FAST_ARRAY:
					temp = new ParticleFastArray();
					break;
				default:
				case ParticleCollectionType.LINKED_LIST:
					temp = new ParticleList();
					break;
			}
			
			if (_particles) {
				var iter:ParticleIterator = _particles.getIterator();
				var p:Particle;
				while (p = iter.particle) {
					temp.add(p);
					iter.remove();
				}
			}
			
			_particles = temp;
		}
		
		//------------------------------------------------------------------------------------------------
		//end of particles
		
		
		//XML
		//------------------------------------------------------------------------------------------------
		
		override public function getRelatedObjects():Array {
			return [_clock].concat(initializers).concat(actions);
		}
		
		override public function getXMLTagName():String {
			return "Emitter";
		}
		
		override public function getElementTypeXMLTag():XML {
			return <emitters/>;
		}
		
		override public function toXML():XML {
			var xml:XML = super.toXML();
			
			xml.@active = active.toString();
			
			xml.@clock = _clock.name;
			
			if (actions.length) {
				xml.appendChild(<actions/>);
				for each (var action:Action in actions) {
					xml.actions.appendChild(action.getXMLTag());
				}
			}
			
			if (initializers.length) {
				xml.appendChild(<initializers/>);
				for each (var initializer:Initializer in initializers) {
					xml.initializers.appendChild(initializer.getXMLTag());
				}
			}
			
			return xml;
		}
		
		override public function parseXML(xml:XML, builder:XMLBuilder = null):void {
			super.parseXML(xml, builder);
			
			_actionCollection.clearActions();
			factory.clearInitializers();
			
			if (xml.@active.length()) active = (xml.@active == "true");
			if (xml.@clock.length()) clock = builder.getElementByName(xml.@clock) as Clock;
			
			var node:XML;
			for each (node in xml.actions.*) {
				addAction(builder.getElementByName(node.@name) as Action);
			}
			for each (node in xml.initializers.*) {
				addInitializer(builder.getElementByName(node.@name) as Initializer);
			}
		}
		
		//------------------------------------------------------------------------------------------------
		//end of XML
	}
}