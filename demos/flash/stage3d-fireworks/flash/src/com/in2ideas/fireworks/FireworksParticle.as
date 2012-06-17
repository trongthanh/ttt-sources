package com.in2ideas.fireworks {
	import flare.core.Particle3D;
	import flare.core.ParticleEmiter3D;
	import flash.geom.Vector3D;
	
	
	/**
	 * ...
	 * @author Ariel Nehmad
	 */
	public class FireworksParticle extends Particle3D {
		private var gravity:Number;
		private var velocity:Vector3D = new Vector3D();
		private var rotationVelocity:Number = 0;
		private var sizeVelocity:Number;
		
		public function FireworksParticle() 
		{
			
		}
		
		override public function clone():Particle3D 
		{
			// return a new custom particle.
			// the ParticleEmiter3D will clone all particles he needs.
			return new FireworksParticle();
		}
		
		override public function init( emiter:ParticleEmiter3D ):void 
		{
			super.init( emiter );
			
			/* all particle initialization here. */
			
			super.x = 0;
			super.y = 0;
			super.z = 0;
			super.sizeX = 20;
			super.sizeY = 20;
			
			gravity = 0;
			velocity.x = Math.random() * 2.0 - 1;
			velocity.y = Math.random() * 2.0 - 1;
			velocity.z = Math.random() * 2.0 - 1;
			
			velocity.normalize();
			
			
			if ( emiter.useGlobalSpace ) velocity = emiter.localToGlobalVector( velocity );
			
			velocity.scaleBy( 3 );
			
			//rotationVelocity = Math.random() * 0.3 // - 2.5
			rotationVelocity = 0;
			//sizeVelocity = Math.random() * 0.2 + 0.3;
			sizeVelocity = 0;
		}
		
		override public function update( time:Number ):void 
		{
			/* update the particle. */
			
			//gravity -= 0.05;
			x += velocity.x;
			y += velocity.y + gravity;
			z += velocity.z;
			
			//reduce speed to stop
			
			/*if (Math.abs(velocity.x) < 0.001) {
				velocity.scaleBy(0);
				velocity.
			} else {
				velocity.scaleBy(0.01);
			}*/
			
			if ( y < 0 ) y = 0;
			
			sizeX += sizeVelocity;
			sizeY += sizeVelocity;
			rotation += rotationVelocity;
		}
	}
}