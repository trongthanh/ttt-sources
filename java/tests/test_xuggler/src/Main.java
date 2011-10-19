import java.awt.image.BufferedImage;

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
public class Main {
	public static void main(String [] args) {
		IMediaReader reader = ToolFactory.makeReader("input.flv");
		
		IMediaWriter writer = ToolFactory.makeWriter("output.mov",reader);
		
		reader.setBufferedImageTypeToGenerate(BufferedImage.TYPE_3BYTE_BGR);
		
		TimeStampTool tsTool = new TimeStampTool();		
		reader.addListener(tsTool);
		
		VolumeAdjustTool volTool = new VolumeAdjustTool(5);
		
		tsTool.addListener(volTool);
		
		volTool.addListener(writer);
		
		while (reader.readPacket() == null)
			;
		
		
	}
}
