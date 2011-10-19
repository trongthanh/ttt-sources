/*
 * Copyright (c) 2010 Thanh Tran - trongthanh@gmail.com
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package int3ractive.arinvitation.faces.back {
	import com.google.maps.LatLng;
	import int3ractive.arinvitation.config.Locale;
	/**
	 * ...
	 * @author Thanh Tran
	 */
	public class VenueInfo{
		
		public static const LOCATION: String = "location" ;
		public static const NAME: String = "name";
		public static const ADDRESS: String = "address";
		private static const DATA_VN: Object = 
		{
			name: "Nhà Hàng Khách Sạn Tân Sơn Nhất"
			,address: "200 Hoàng Văn Thụ, Phường 9, Quận Phú Nhuận, TP.HCM, Việt Nam."
			,location: new LatLng(10.800115885200299, 106.6721498966217)
		}
		
		private static const DATA_EN: Object = 
		{
			name: "Tan Son Nhat Hotel"
			,address: "200 Hoang Van Thu, Ward 9, Phu Nhuan District, Ho Chi Minh city, Vietnam."
			,location: new LatLng(10.800115885200299, 106.6721498966217)
		}
		
		
		public static function getInfo(fieldName: String, locale: String = "vn"): Object {
			var data: Object;
			switch(locale) {
				case Locale.EN:
					data = DATA_EN;
					break;
				case Locale.VN:
				default:
					data = DATA_VN;
					break;
			}
			
			return data[fieldName];
		}
		
	}

}