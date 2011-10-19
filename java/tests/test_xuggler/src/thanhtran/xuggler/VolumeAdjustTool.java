/**
 * 
 */
package thanhtran.xuggler;

import java.nio.ShortBuffer;

import com.xuggle.mediatool.MediaToolAdapter;
import com.xuggle.mediatool.event.IAudioSamplesEvent;

/**
 * @author	Thanh Tran
 *
 */
public class VolumeAdjustTool extends MediaToolAdapter
{
  // the amount to adjust the volume by

  private double mVolume;
  
  /** 
   * Construct a volume adjustor.
   * 
   * @param volume the volume muliplier, values between 0 and 1 are
   *        recommended.
   */

  public VolumeAdjustTool(double volume)
  {
    mVolume = volume;
  }

  /** {@inheritDoc} */

  @Override
    public void onAudioSamples(IAudioSamplesEvent event)
  {
    // get the raw audio byes and adjust it's value 
    
    ShortBuffer buffer = event.getAudioSamples().getByteBuffer().asShortBuffer();
    for (int i = 0; i < buffer.limit(); ++i)
      buffer.put(i, (short)(buffer.get(i) * mVolume));
    
    // call parent which will pass the audio onto next tool in chain

    super.onAudioSamples(event);
  }
}