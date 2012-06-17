package com.in2ideas.fireworks {
	import flare.core.ParticleEmiter3D;
	import flare.core.Texture3D;
	import flare.materials.filters.ColorParticleFilter;
	import flare.materials.filters.TextureFilter;
	import flare.materials.Material3D;
	import flare.materials.ParticleMaterial3D;
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 * @author Thanh Tran - thanh.tran@in2ideas.com
	 */
	public class FireworksEmitter extends ParticleEmiter3D {
		public static const PARTICLE_PER_FRAME: int = 200;
		
		public var directionChunk: Vector.<Vector3D>;
		
		public var color: uint;
		
		public function FireworksEmitter(name: String, texture: Texture3D, color: uint = 0xFFFFFF) {
			super(name);
			this.color = color;
			//material set up
			var material:ParticleMaterial3D = new ParticleMaterial3D();
			material.filters.push( new TextureFilter( texture ) );
			material.filters.push( new ColorParticleFilter( [color, color, color, color], [1, 1, 1, 0] ) );
			material.build();
			
			this.material = material;
			this.particle = new FireworksParticle();
			this.useGlobalSpace = true;
			this.particlesLife = 80;
			this.decrementPerFrame = -1; //emit only once
			
		}
		
		public function emit(): void {
			var randIdx: int = int(Math.random() * 4);
			//this.material = _matList[randIdx];
			this.emitParticlesPerFrame = PARTICLE_PER_FRAME;
			
			var light: FireworksLight = FireworksLight.getNextLight();
			light.flash(this.getPosition(), this.color);
			
		}
		
	}

}