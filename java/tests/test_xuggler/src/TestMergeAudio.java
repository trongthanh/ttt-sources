import java.nio.ByteBuffer;

import javax.management.RuntimeErrorException;

import com.xuggle.ferry.IBuffer;
import com.xuggle.mediatool.event.ICoderEvent;
import com.xuggle.xuggler.IAudioSamples;
import com.xuggle.xuggler.ICodec;
import com.xuggle.xuggler.IContainer;
import com.xuggle.xuggler.IContainerFormat;
import com.xuggle.xuggler.IError;
import com.xuggle.xuggler.IPacket;
import com.xuggle.xuggler.IStream;
import com.xuggle.xuggler.IStreamCoder;

/**
 * 
 */

/**
 * 
 * @author	Thanh Tran
 *
 */
public class TestMergeAudio {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		String audio1 = "vocal3.mp3";//"st2.wav";
		String audio2 = "beat3.mp3";//"st4.wav";
		//open first audio
		IContainer container1 = IContainer.make();

		if(container1.open(audio1, IContainer.Type.READ, null)<0) {
			throw new RuntimeException("cannot open input.mp3");
		}

		int numStream = container1.getNumStreams();
		System.out.printf("There are %d streams in %s\n", numStream, audio1);

		IStream stream1 = container1.getStream(0);
		IStreamCoder coder1 = stream1.getStreamCoder();

		System.out.printf("%s uses %s codec\n", audio1, coder1.getCodec().getName());

		if(coder1.open() < 0)
			throw new RuntimeException("error opening coder1");

		//open beat audio
		IContainer container2 = IContainer.make();

		if(container2.open(audio2, IContainer.Type.READ, null)<0) {
			throw new RuntimeException("cannot open beat.mp3");
		}

		numStream = container2.getNumStreams();
		System.out.printf("There are %d streams in %s\n", numStream, audio2);

		IStream stream2 = container2.getStream(0);
		IStreamCoder coder2 = stream2.getStreamCoder();

		System.out.printf("%s uses %s codec\n", audio2, coder2.getCodec().getName());

		if(coder2.open() < 0)
			throw new RuntimeException("error opening coder1");		

		IContainer outContainer = IContainer.make();
		outContainer.open("output.mp3", IContainer.Type.WRITE, null);
		IStream outStream = outContainer.addNewStream(0);

		IStreamCoder outCoder = outStream.getStreamCoder();
		outCoder.setCodec(ICodec.ID.CODEC_ID_MP3);
		outCoder.setSampleRate(coder1.getSampleRate());
		outCoder.setBitRate(coder1.getBitRate());
		outCoder.setChannels(2);


		if(outCoder.open() < 0)
			throw new RuntimeException("error opening coder1");

		if (0 != outContainer.writeHeader())
			throw new RuntimeException("write header to out container error");


		//read packet and merge files
		while (readPackets(container1, coder1, 
				container2, coder2, 
				outContainer, outCoder) >= 0)
			;


	}

	private static int readPackets(IContainer container1, IStreamCoder coder1, 
			IContainer container2, IStreamCoder coder2,
			IContainer outContainer, IStreamCoder outCoder)
	{
		IPacket packet1 = IPacket.make();
		int rv = container1.readNextPacket(packet1);
		if (rv < 0)
		{
			// if this is an end of file, or unknow, call close
			return rv;
		}

		IPacket packet2 = IPacket.make();
		rv = container2.readNextPacket(packet2);
		if (rv < 0)
		{
			// if this is an end of file, or unknow, call close
			return rv;
		}

		writePackets(packet1, coder1,
				packet2, coder2,
				outContainer, outCoder);

		return rv;
	}

	
	/*
	 * this function is copied from 
	 * http://groups.google.com/group/xuggler-users/browse_thread/thread/109c861457695ce4/d3af17e25b4685ec?lnk=gst&q=merge+audio+files#d3af17e25b4685ec
	 */
	private static void writePackets(IPacket iPacket1, IStreamCoder iCoder1, IPacket 
			iPacket2, IStreamCoder iCoder2, IContainer container, IStreamCoder oCoder) 
	{ 
		if (iCoder1.getChannels() != iCoder2.getChannels()) 
			throw new RuntimeException("Both audio inputs must have the same number of	channels"); 
		IPacket oPacket = IPacket.make(); 
		IAudioSamples samples; 
		IAudioSamples samples1 = IAudioSamples.make(1024, iCoder1.getChannels()); 
		IAudioSamples samples2 = IAudioSamples.make(1024, iCoder2.getChannels()); 
		int retval = 0; 
		int offset = 0; 
		// Decode iPacket1 into samples1 
		retval = 0; 
		offset = 0; 
		while (offset < iPacket1.getSize()) 
		{ 
			retval = iCoder1.decodeAudio(samples1, iPacket1, offset); 
			if (retval <= 0) 
				throw new RuntimeException("Could not decode audio"); 
			offset += retval; 
		} 
		// Decode iPacket2 into samples2 
		retval = 0; 
		offset = 0; 
		while (offset < iPacket2.getSize()) 
		{ 
			retval = iCoder2.decodeAudio(samples2, iPacket2, offset); 
			if (retval <= 0) {
				//throw new RuntimeException("Could not decode audio");
				return;
			}
				 
			offset += retval; 
		} 
		// Create a new IAudioSamples to be encoded later 
		samples = IAudioSamples.make(samples1.getNumSamples(), 
				samples1.getChannels()); 
		samples.setPts(samples1.getPts()); 
		samples.setTimeBase(samples1.getTimeBase()); 
		samples.setTimeStamp(samples1.getTimeStamp()); 
		// Merge both IAudioSamples' data 
		byte[] bytes1 = samples1.getData().getByteArray(0, 
				samples1.getSize()); 
		byte[] bytes2 = samples2.getData().getByteArray(0, 
				samples2.getSize()); 
		byte[] mergedBytes = new byte[bytes1.length > bytes2.length ? 
				bytes1.length : bytes2.length]; 
		for (int i = 0; i < bytes1.length && i < bytes2.length; i++) 
		{ 
			int sum = ((short)bytes1[i] + (short)bytes2[i]) /2; 
			mergedBytes[i] = (byte) (sum < Short.MIN_VALUE ? Short.MIN_VALUE : 
				sum > Short.MAX_VALUE ? Short.MAX_VALUE : sum); 
		} 

		// Create buffer 
		IBuffer buffer = samples.getData(); 
		ByteBuffer rawBytes = buffer.getByteBuffer(0, 
				buffer.getBufferSize()); 
		// Write data to buffer 
		rawBytes.put(mergedBytes); 
		rawBytes = null; 
		// Set data 
		samples.setComplete(true, samples1.getNumSamples(), 
				samples1.getSampleRate(), samples1.getChannels(), samples1.getFormat(), 
				samples1.getPts()); 
		int samplesConsumed = 0; 
		// Encode IAudioSamples into oPacket and write it on the output IContainer 
		while (samplesConsumed < samples.getNumSamples()) 
		{ 
			retval = oCoder.encodeAudio(oPacket, samples, samplesConsumed); 
			if (retval <= 0) 
				throw new RuntimeException("Could not encode audio"); 
			samplesConsumed += retval; 
			if (oPacket.isComplete()) 
			{ 
				retval = container.writePacket(oPacket); 
				if (retval < 0) 
					throw new RuntimeException("Could not write output packet"); 
			} 
		} 
	} 


}
