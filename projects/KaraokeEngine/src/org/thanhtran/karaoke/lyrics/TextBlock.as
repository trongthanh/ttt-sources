/**
 * Copyright 2010 Thanh Tran - trongthanh@gmail.com
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.thanhtran.karaoke.lyrics {
	import org.osflash.signals.Signal;
	import org.thanhtran.karaoke.data.LyricBitInfo;
	import org.thanhtran.karaoke.data.LyricBlockInfo;
	import flash.display.Sprite;
	/**
	 * A line of text
	 * @author Thanh Tran
	 */
	public class TextBlock extends Sprite {
		public var completed: Signal;
		/* timestamp millisecond */
		public var startTime: Number;
		public var textBits: Array;
		
		public var duration: uint = 0;
		private var data: LyricBlockInfo;
		/* number of bits */
		private var len: uint;
		

		public function TextBlock() {
			completed = new Signal(TextBlock);
		}

		public function init(data: LyricBlockInfo): void {
			this.data = data;
			len = data.lyricBits.length;
			textBits = new Array();
			var bitInfo: LyricBitInfo;
			var bit: TextBit;
			var lastX: Number = 0;
			for (var i : int = 0; i < len; i++) {
				bitInfo = data.lyricBits[i];
				bit = new TextBit();
				bit.duration = bitInfo.duration;
				//calculate block duration
				duration += bit.duration; 
				bit.text = bitInfo.text;
				bit.completed.add(textBitCompleteHandler);
				textBits.push(bit);
				if(i > 0) {
					TextBit(textBits[i - 1]).next = bit;
				}
				//render
				bit.x = lastX;
				addChild(bit);
				lastX += bit.width;
			} 
		}

		private function textBitCompleteHandler(tb: TextBit): void {
//			trace('text bit ' + tb.text + ' complete, next:  ' + (tb.next));
			if(tb.next) {
				tb.next.play();
			} else {
				completed.dispatch(this);
			}
		}
		
		public function play(): void {
			for (var i : int = 0; i < len; i++) {
				textBits[i].reset();
			}
			textBits[0].play();
		}
		
		public function dispose(): void {
			for (var i : int = 0; i < len; i++) {
				textBits[i].dispose();
			}
		}
	}

}