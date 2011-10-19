

import java.awt.image.BufferedImage;

import thanhtran.xuggler.AudioMixerTool;
import thanhtran.xuggler.TimeStampTool;
import thanhtran.xuggler.VolumeAdjustTool;

import com.xuggle.mediatool.IMediaReader;
import com.xuggle.mediatool.IMediaWriter;
import com.xuggle.mediatool.ToolFactory;

/**
 * 
 */

/**
 * @author	Thanh Tran
 *
 */
public class AudioMixerTest {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		IMediaReader reader = ToolFactory.makeReader("input.mp3");
		
		IMediaWriter writer = ToolFactory.makeWriter("output.mp3",reader);
		
		AudioMixerTool mixer = new AudioMixerTool("beat.mp3");		
		reader.addListener(mixer);
		
		mixer.addListener(writer);
		
		while (reader.readPacket() == null)
			;

	}

}
