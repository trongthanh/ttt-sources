/**
* ...
* @author Trong Thanh
* @version 0.1
*/

package org.trongthanh.flickr {
	import org.trongthanh.flickr.FlickrPhotoSize;
	import com.adobe.webapis.flickr.Photo;

	public class FlickrPhotoURL {
		
		
		public function FlickrPhotoURL() {
			
		}
		
		/* *
		 * Get the literal url of the Photo
		 * http://farm{farm-id}.static.flickr.com/{server-id}/{id}_{secret}.jpg
		 * OR
		 * http://farm{farm-id}.static.flickr.com/{server-id}/{id}_{secret}_[mstb].jpg
		 * OR
		 * http://farm{farm-id}.static.flickr.com/{server-id}/{id}_{o-secret}_o.(jpg|gif|png)
		 * */
		public static function getURL(photoId: String, serverId: String, farmId: String, secret: String, size: String = "medium"): String {
			var urlStr: String = "";
			if (size == FlickrPhotoSize.ORIGINAL) {
				//not code yet.!
			} else {
				urlStr = "http://farm" + farmId + ".static.flickr.com/" + serverId + "/" + photoId + "_" + secret;
				switch (size) {
					case FlickrPhotoSize.SMALL_SQUARE:
						urlStr += "_" + FlickrPhotoSize.SMALL_SQUARE;
						break;
					case FlickrPhotoSize.SMALL:
						urlStr += "_" + FlickrPhotoSize.SMALL;
						break;
					case FlickrPhotoSize.LARGE:
						urlStr += "_" + FlickrPhotoSize.LARGE;
						break;
					case FlickrPhotoSize.THUMBNAIL:
						urlStr += "_" + FlickrPhotoSize.THUMBNAIL;
						break;
					default:
						break;
				}
				urlStr += ".jpg";
				
				
			}
			return urlStr;
			
		}
		
		public static function getURLfromPhoto(photo: Photo, size: String = "medium"): String {
			return getURL(photo.id, photo.server.toString(), photo.farm.toString(), photo.secret, size);
		}
		
	}
	
}
