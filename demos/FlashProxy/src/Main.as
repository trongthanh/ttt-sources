/**
 * Copyright (c) 2010 Thanh Tran - trongthanh@gmail.com
 * 
 * Licensed under the MIT License.
 * http://www.opensource.org/licenses/mit-license.php
 */
package {
	import flash.display.Sprite;
	import flash.events.Event;
	import org.thanhtran.model.data.OrderedObject;
	import org.thanhtran.model.data.QueryString;
	
	/**
	 * ...
	 * @author Thanh Tran
	 */
	[SWF(backgroundColor='#FFFFFF', frameRate='31', width='550', height='400')]
	public class Main extends Sprite {
		
		public function Main():void {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			//testNormalObject();
			testOrderedObject();
			testTraversableObject();
			//testQueryString();
			
		}
		
		public function testNormalObject(): void {
			//test normal object
			var obj: Object = { a: 1, b:2, c: 3, d: 4, e: 5 };
			trace("obj.hasOwnProperty: c - " + obj.hasOwnProperty("c"));
			//trace("decendant: " + obj..a);
			
			for (var prop: String in obj) {
				//trace("obj prop: " + prop + " - " + obj[prop]);
			}
			
			for each (var item: int in obj ) {
				//trace("obj item: " + item);
			}
		}
		
		public function testOrderedObject(): void {
			//test ordered object
			var obj: OrderedObject = new OrderedObject( ["a", 1, "b", 2, "c", 3, "d", 4, "e", 5 ] );
			trace("obj.hasOwnProperty: c - " + obj.hasOwnProperty("c"));
			trace("decendant: " + obj..e);
			
			for (var prop: String in obj) {
				trace("ordered prop: " + prop + " - " + obj[prop]);
			}
			
			for each (var item: int in obj ) {
				trace("ordered item: " + item);
			}
		}
		
		private function testTraversableObject():void {
			var obj: TestTraversableObject = new TestTraversableObject();
			
			
			for (var prop: String in obj) {
				trace("traversable prop: " + prop + " - " + obj[prop]);
			}
			
			for each (var item: Object in obj ) {
				trace("traversable item: " + item);
			}
		}
		
		private function testQueryString():void {
			var query: QueryString = new QueryString("a=1&b=2&c=3&d=4&e=5");
			trace(query.toString());
			//change parameters
			query.a = "one";
			query.e = "five";
			trace(query.toString());
		}
		
		
	}
	
}