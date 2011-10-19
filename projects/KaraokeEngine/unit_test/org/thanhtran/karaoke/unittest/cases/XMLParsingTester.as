package org.thanhtran.karaoke.unittest.cases {
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.engine.TextBlock;
	import org.flexunit.Assert;
	import org.flexunit.async.Async;
	import org.thanhtran.karaoke.data.LyricBitInfo;
	import org.thanhtran.karaoke.data.LyricBlockInfo;
	import org.thanhtran.karaoke.data.SongInfo;
	import org.thanhtran.karaoke.data.SongLyrics;
	import org.thanhtran.karaoke.utils.StringUtil;
	import org.thanhtran.karaoke.utils.TimedTextParser;

	public class XMLParsingTester {
		public var xmlPath: String = "xml/song1_unittest.xml";

		[Embed(source = "/../bin/xml/song1_unittest.xml", mimeType="application/octet-stream")]
		public var SongXML: Class;
		//
		default xml namespace = new Namespace("","http://www.w3.org/ns/ttml");
		
		private var songInfo: SongInfo;
		private var xml:XML;
		
		[Before]
		public function setUp(): void {
			songInfo = new SongInfo();
			xml = new XML(new SongXML());
		}
		
		[Test(async, order=1, description="Test Load XML")]
		public function loadXML(): void {
			trace('xmlPath: ' + (xmlPath));
			var loader: URLLoader = new URLLoader();
			var asyncHandler: Function = Async.asyncHandler(this, loadCompleteHandler, 1000, null, timeoutHandler);
			loader.addEventListener(Event.COMPLETE, asyncHandler);
			loader.load(new URLRequest(xmlPath));
			
		}

		private function timeoutHandler(): void {
			Assert.fail("Load failed");
		}

		private function loadCompleteHandler(event: Event, passData: Object) : void {
			var loader: URLLoader = URLLoader(event.target);
			
			var xml: XML = new XML(loader.data);
			if (xml) {
				Assert.assertTrue("Load XML success", true);
			} else {
				Assert.fail("Load XML failed");
			}
			
		}
		
		[Test(order=2, description="Test get song header")]
		public function getSongHeader(): void {
			
			TimedTextParser.parseSongHead(xml.head[0], songInfo);
			
			Assert.assertEquals("Verifying title", "Hạnh Phúc Bất Tận", songInfo.title);
			Assert.assertEquals("Verifying desc", "Composed by: Nguyễn Đức Thuận<br/>Singers: Hồ Ngọc Hà ft. V.Music Band", songInfo.description);
			Assert.assertEquals("Verifying desc", "Copyright (C) 2010 Thanh Tran - trongthanh@gmail.com", songInfo.copyright);
			Assert.assertEquals("Verifying audio", "mp3/hanh_phuc_bat_tan.mp3", songInfo.audio);
		}
		
		/**
		 * <div style="f">
			<p begin="00:00:21.260">* * *</p> <!-- this first version will only support sequential begin -->
			<p begin="00:00:23.780">Thắp nến đêm nay</p>
		</div>
		<div style="f">
			<p begin="00:00:25.780">ấm áp trong tay</p>
		</div>
		<div style="f">
			<p begin="00:00:27.500">của người</p>
			<p begin="00:00:27.860">yêu dấu</p>
		</div>
		<div style="f">
			<p begin="00:00:29.540">xiết bao ngọt ngào</p>
		</div>
		<div style="f">
			<p begin="00:00:31.940">vu vơ mơ về</p>
		</div>
		 */
		[Test(order=3, description="Test parse song lyrics")]
		public function getSongLyrics(): void {
			
			TimedTextParser.parseSongLyrics(xml.body[0], songInfo);
			
			var songLyrics: SongLyrics = songInfo.lyrics;
			try {
				var blocks: Array = songLyrics.blockArray;
				//check block length
				Assert.assertEquals(21, blocks.length);
				//test first block
				var block1: LyricBlockInfo = blocks[0];
				Assert.assertEquals("f", block1.lyricStyle);
				
				var bits1: Array = block1.lyricBits;
					
				Assert.assertEquals(21260, block1.startTime);
				
				Assert.assertEquals("* * *", LyricBitInfo(bits1[0]).text);
				Assert.assertEquals(2520, LyricBitInfo(bits1[0]).duration);
				
				Assert.assertEquals("Thắp nến đêm nay", LyricBitInfo(bits1[1]).text);
				Assert.assertEquals(1720, LyricBitInfo(bits1[1]).duration);
				
				//test second block
				var block2: LyricBlockInfo = blocks[0];
				var bits2: Array = block2.lyricBits;
				
				Assert.assertEquals(21260, block2.startTime);
				
				Assert.assertEquals("* * *", LyricBitInfo(bits2[0]).text);
				Assert.assertEquals(2520, LyricBitInfo(bits2[0]).duration);
				
				Assert.assertEquals("Thắp nến đêm nay", LyricBitInfo(bits2[1]).text);
				Assert.assertEquals(1720, LyricBitInfo(bits2[1]).duration);
				
				
				
			} catch (err:Error){
				Assert.fail("songLyrics parse failed: \n" + StringUtil.truncate(err.getStackTrace(), 1000));
			}
			
			
			
			
			
			
			
			
		}
		
	}
		
}