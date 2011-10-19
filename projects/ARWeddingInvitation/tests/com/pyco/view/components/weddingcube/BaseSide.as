package com.pyco.view.components.weddingcube {
	import flash.events.Event;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.objects.primitives.Plane;
	
	/**
	 * Base side of wedding cube
	 * @author Thu.Hoang
	 */
	[Event(name='openSideComplete', type='com.pyco.view.components.weddingcube.BaseSide')]
	[Event(name='closeSideComplete', type='com.pyco.view.components.weddingcube.BaseSide')]
	public class BaseSide extends Plane {
		public static const OPEN_SIDE_COMPLETE: String = "openSideComplete";
		public static const CLOSE_SIDE_COMPLETE: String = "closeSideComplete";
		
		public var sideMaterial: MaterialObject3D;
		public var currentAngle: Number;
		
		public function BaseSide(material: MaterialObject3D = null, width: Number = 0, height: Number = 0, segmentsW: Number = 0, segmentsH: Number = 0) {
			super(material, width, height, segmentsW, segmentsH);
		}
		
		override public function toString(): String {
			return "Name : " + name + ", currentAngle : " + currentAngle;
		}
		
		public function close(): void {
			// do something
			dispatchEvent(new Event(CLOSE_SIDE_COMPLETE));
		}
		
		public function open(): void {
			// do something
			dispatchEvent(new Event(OPEN_SIDE_COMPLETE));
		}
	}

}