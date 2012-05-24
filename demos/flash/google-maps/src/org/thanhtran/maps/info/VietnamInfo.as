/*
 * Copyright (c) 2008 Tran Trong Thanh - trongthanh@gmail.com
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
package org.thanhtran.maps.info {
	import com.google.maps.LatLng;
	import com.google.maps.LatLngBounds;
	
	/**
	* This class generates common geographical information of Vietnam
	* @author Thanh Tran - trongthanh@gmail.com
	*/
	public class VietnamInfo {
		
		public function VietnamInfo() {
			
		}
		
		public static function getVNLatLngBounds(): LatLngBounds {
			var vnLatLngBounds: LatLngBounds = 
			new LatLngBounds (
				new LatLng(8.407168163601074, 104.1448974609375),
				new LatLng(23.170663827102235, 108.0780029296875)
			);
			return vnLatLngBounds;
		}
		
		public static function getHCMLatLng(): LatLng {
			return new LatLng(10.772392307117563, 106.6981029510498);
		}
		
		public static function getHaNoiLatLng(): LatLng {
			return new LatLng(21.033978268569264, 105.84182381629944);
		}
		
	}
	
}