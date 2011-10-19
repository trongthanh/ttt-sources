package thanhtran.xuggler;
import java.nio.ShortBuffer;

import com.xuggle.mediatool.IMediaReader;
import com.xuggle.mediatool.MediaToolAdapter;
import com.xuggle.mediatool.ToolFactory;
import com.xuggle.mediatool.event.IAudioSamplesEvent;
import com.xuggle.xuggler.IAudioSamples;

/**
 * 
 */

/**
 * @author	Thanh Tran
 *
 */
public class AudioMixerTool extends MediaToolAdapter {

	private AudioReader beatReader;

	public AudioMixerTool(String beatURL)
	{
		beatReader = new AudioReader(beatURL);
	}
	
	@Override
	public void onAudioSamples(IAudioSamplesEvent event)
	{
		IAudioSamples sample1 = event.getAudioSamples();
		
	    // get the raw audio byes and adjust it's value 
	    
		/*
	    ShortBuffer buffer = event.getAudioSamples().getByteBuffer().asShortBuffer();
	    for (int i = 0; i < buffer.limit(); ++i)
	      buffer.put(i, (short)(buffer.get(i) * mVolume));
	    */
	    // call parent which will pass the audio onto next tool in chain
	
	    super.onAudioSamples(event);
    }
}
