package {
	import com.adobe.utils.AGALMiniAssembler;
	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTriangleFace;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.VertexBuffer3D;
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.geom.Rectangle;
	
	/**
	 * 	
	 */
	[SWF(width="980",height="570",frameRate="60")]
	public class MolehillDemo extends Sprite {
		//Context3D là nơi xử lý hiển thị xảy ra
		//Nó giống như BitmapData đối với Bitmap (Stage3D)
		private var context3d:Context3D;
		//Đây là đối tượng sẽ lưu dữ liệu của vertex
		private var vertexBuffer:VertexBuffer3D;
		//Đối tượng này sẽ xác định thứ tự vẽ của các đỉnh vertex
		private var indexBuffer:IndexBuffer3D;
		//Chương trình này sẽ chứa 2 shader dùng để xử lý các vertex
		private var program:Program3D;
		//Đây là Ma Trận sẽ được sử dụng bởi VertexShader để xử lý vị trí của các vertex 
		//(đừng lo, bạn sẽ hiểu nó khi đọc xong bên dưới)
		private var model:Matrix3D = new Matrix3D();
		
		
		public function MolehillDemo() {
			trace("start app");
			//Các lệnh thông thường của Flash để điều chỉnh nội dung Flash không thay đổi tỉ lệ 
			//và luôn canh lề ở góc trên bên trái
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			//Lắng nghe sự kiện khi Flash sẵn sàng trả vể đối tượng Context3D. 
			//Đối tượng Context3D có thể không truy xuất được ngay tức thời nên chúng ta 
			//cần phải lắng nghe sự kiện này.
			stage.stage3Ds[0].addEventListener(Event.CONTEXT3D_CREATE, onGotContext);
			
			//Yêu cầu Flash trả về tham chiếu đến Context3D, Flash sẽ đáp trả trong hàm onGotContext
			stage.stage3Ds[0].requestContext3D();
			
			//Tại đây chúng ta đề nghị Flash hiển thị các hình ảnh 3D trong một khung hình 
			//chữ nhật rộng 980px, cao 570px bắt đầu từ tọa độ 0,0
			stage.stage3Ds[0].viewPort = new Rectangle(0, 0, 980, 570);
		}
		
		protected function onGotContext(e:Event):void {
			trace("got context");
			//Nhận được đối tượng Stage3D mà qua đó sẽ lấy được Context3D
			var stage3d:Stage3D = Stage3D(e.currentTarget);
			
			//cuối cùng cũng lấy được Context3D – Yeah!
			context3d = stage3d.context3D;
			trace("context 3D: " + context3d);
			//Khoan đã! Đến đây cũng chưa chắc bạn đã thật sự lấy được Context3D. Câu lệnh 
			//bên dưới là cách chuẩn để kiểm tra lần cuối bạn có thật sự nhận được Context3D. 
			//Trong ví dụ này, nếu điều kiện là true, chúng ta sẽ thoát khỏi hàm và không
			//làm gì cả.
			if (context3d == null)
				return;
			//Dòng dưới giúp chúng ta nhận được các thông báo lỗi nếu chương trình chạy có vấn đề. 
			//Khi xuất bản ứng dụng, chúng ta nên cài về false. (Việc này cũng sẽ giúp cải thiện tốc độ).
			context3d.enableErrorChecking = true;
			
			//Thao tác này tương tự việc khởi tạo BitmapData(980, 570). Chúng ta đang khai báo 
			//vùng dữ liệu mà chúng ta cần để xử lý. Số 4 là mức độ khử răng cưa.
			//Theo tài liệu, các giá trị cho phép của tham số này là:
			//0 không khử răng cưa
			//2 khử răng cưa ít
			//4 khử răng cưa chất lượng cao
			//16 khử răng cưa chất lượng rất cao
			//nhưng khi tôi thử đặt 16, chương trình bị lỗi nên có thể 16 hiện tại chưa hoạt động.
			context3d.configureBackBuffer(980, 570, 4, true);
			
			//Ở đây đơn giản chúng ta đang cài đặt nếu một tam giác không quay về phía người 
			//xem thì không vẽ nó ra (culling: lược bớt)
			//context3d.setCulling(Context3DTriangleFace.BACK);
			context3d.setCulling(Context3DTriangleFace.BACK);
			
			//Tạo một vertex buffer
			//Chúng ta sẽ có 3 vertex và sẽ có 6 giá trị cho mỗi vertex: x, y, z, r, g, b
			vertexBuffer = context3d.createVertexBuffer(3, 6);
			
			//Tạo một buffer chỉ mục (index) cho các vertex
			//Chúng ta sẽ vẽ một tam giác, vì vậy sẽ có 3 đỉnh (vertex) và 3 chỉ mục (index)
			indexBuffer = context3d.createIndexBuffer(3);
			
			//Tiếp theo chúng ta sẽ tạo ra mảng dữ liệu cho các vertex. Mảng dữ liệu vertex này 
			//sẽ chứa thông tin tọa độ và màu sắc của từng vertex.
			//Sau đây là giải thích cho mảng dữ liệu bên dưới:
			//Vùng thông tin cho mỗi vertex bao gồm tọa độ sau đó là màu sắc.
			//x==-1 là vị trí trái cùng của màn hình
			//x==1 là vị trí phải cùng của màn hình
			//x==0 là vị trí giữa màn hình (theo chiều ngang)
			//Tương tự theo chiều dọc cho Y
			//Màu sắc cũng được biểu diễn bằng số phân số cho nên:
			//1, 0, 0 <- màu đỏ 255 (r, g, b)
			//0.5, 0, 0 <- nửa màu đỏ 128
			
			//Mảng sau đây sẽ định nghĩa một tam giác có góc trái dưới màu đỏ, góc giữa trên 
			//màu xanh lá và góc phải dưới màu xanh dương
			var vertexData:Vector.<Number> = Vector.<Number>(
				[-1, -1, 0, 255 / 255, 0, 0, //<- 1st vertex x,y,z,r,g,b
				0, 1, 0, 0, 255 / 255, 0, //<- 2nd vertex x,y,z,r,g,b
				1, -1, 0, 0, 0, 255 / 255 //<- 3rd vertex x,y,z,r,g,b
				]);
			
			//Sau đây là thứ tự các chỉ mục mà các đỉnh sẽ được vẽ
			//0==đỉnh thứ nhất
			//1==đỉnh thứ hai
			//2==đỉnh thứ ba
			var indexData:Vector.<uint> = Vector.<uint>([0, 1, 2]);
			
			//Gửi thông tin của các vertex cho vertex buffer
			vertexBuffer.uploadFromVector(vertexData, 0, 3);
			
			//Gửi dữ liệu chỉ mục cho index buffer
			indexBuffer.uploadFromVector(indexData, 0, 3);
			
			//Chúng ta sẽ cần 1 “bộ biên dịch” AGAL cho vertex shader và 1 cho fragment shader
			var agalVertex:AGALMiniAssembler = new AGALMiniAssembler();
			var agalFragment:AGALMiniAssembler = new AGALMiniAssembler();
			
			//Bây giờ hãy cùng viết vài dòng AGAL
			//AGAL là ngôn ngữ rất cơ bản
			//Nó bao gồm các câu lệnh (statements)
			//Mỗi câu lệnh có ít nhất các thành phần sau
			//Operation OutPut, Input1 (Hành-động Dữ-liệu-ra, Dữ-liệu-vào-1)
			//Đôi khi nó có thể có 2 tham số truyền vào
			//Operation OutPut, Input1, Input2
						
			//Để xem AGAL hoạt động như thế nào, hãy giả sử chúng ta cần làm một phép tính:
			//I*J=K
			//câu lệnh AGAL sẽ như sau:
			//mul K, I, J
						
			//mul==Operation
			//K==Output
			//I==Input1
			//J==Input2
						
			//Sau đây là định nghĩa của một số biến và lệnh được thấy ở dưới
			//m44: lệnh để thực thi một ma trận (Matrix) lên dữ liệu
			//op: dữ liệu ra là vị trí của vertex trên màn hình
			//va0: x, y, z của một vertex trogn tam giác của chúng ta
			//vc0: một hằng sẽ được định nghĩa sau (trong trường hợp của chúng ta chính là 
			//ma trận để chuyển đổi các vertx)
			//v0: một “biến” ở giữa vertex shader và fragment shader
			//va1: r, g, b của một vertex
						
			//Mô tả của các dòng lệnh tiếp theo như sau:
			//m44 op, va0, vc0 -> thực thi một ma trận 4x4 lên vertex và trả về giá trị của nó trên màn hình
			//mov v0, va1 → lấy giá tri màu của vertex này và gửi nó cho fragment shader
			var agalVertexSource:String = "m44 op, va0, vc0\n" + "mov v0, va1\n";
			
			//oc: dữ liệu ra là màu hiển thị trên màn hình
			//v0: biến trung gian giữa vertex shader và fragment shader
			//mov oc, v0 -> lấy giá trị màu (biến trung gian đã được lưu từ vertex shader) và xuất ra màn hình
			var agalFragmentSource:String = "mov oc, v0\n";
			
			//Biên dịch source AGAL vừa viết thành một mảng ByteArray mà các shader có thể dùng.
			agalVertex.assemble(Context3DProgramType.VERTEX, agalVertexSource);
			agalFragment.assemble(Context3DProgramType.FRAGMENT, agalFragmentSource);
			
			//Tạo một chương trình (program) để thực thi các shader
			//Nên nhớ là chương trình này sẽ chứa một Vertex Shader và một Fragment Shader
			program = context3d.createProgram();
			
			//Gửi các shader đã được biên dịch đến program để thực thi
			//agalCode==bytearray
			program.upload(agalVertex.agalcode, agalFragment.agalcode);
			
			//Thêm hàm xử lý render liên tục
			addEventListener(Event.ENTER_FRAME, onRenderLoop);
			
		}
		
		protected function onRenderLoop(event:Event):void {
			
			//Xóa khung hình và màn hình
			context3d.clear(0.5, 0.5, 0.5, 1);
			
			//cài đặt chương trình dùng để render
			context3d.setProgram(program);
			
			//Có thể bạn sẽ thấy lạ vì 2 dòng bên dưới gần giống như nhau.
			//Về cơ bản, đoạn code bên dưới sẽ cho AGAL biết va0 sẽ là x, y, z và va1 sẽ là r, g, b
			//Dòng thứ 1
			//0: chỉ mục của biến đầu tiên, va0
			//vertexBuffer: vertex buffer mà chúng ta sẽ dùng
			//0: chỉ mục nơi bắt đầu lấy giá trị cho va0 (0 bởi vì x, y, z bắt đầu tại 0)
			//Context3DVertexBufferFormat.FLOAT_3: sẽ có 3 giá trị liên tiếp để lấy: x, y, z
			//Dòng thứ 2
			//1: chỉ mục của biến va1
			//vertexBuffer: vertex buffer mà chúng ta sẽ dùng
			//3: chỉ mục nơi bắt đầu lấy giá trị cho va1 (r, g, b bắt đầu tại chỉ mục 3)
			//Context3DVertexBufferFormat.FLOAT_3: 3 giá trị liên tiếp để lấy: r, g, b
			//Theo tôi bạn có thể dùng Context3DVertexBufferFormat.FLOAT_4 nếu bạn cần sử dụng r, g, b, a
			context3d.setVertexBufferAt(0, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			context3d.setVertexBufferAt(1, vertexBuffer, 3, Context3DVertexBufferFormat.FLOAT_3);
			
			//Lấy giá trị mặc định của ma trận
			model.identity();
			
			//Co tỉ lệ của tam giác xuống 0.5 theo x, y, z
			model.appendScale(0.5, 0.5, 0.5);
			
			//Gán ma trận vừa khai báo vào biến vc0 và nó sẽ được dùng để xử lý dữ liệu 
			//vertex của chúng ta
			context3d.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, model);
			
			//Vẽ hình tam giác của chúng ta ra màn hình
			//0 là chỉ mục của vị trí (trong vertex buffer) bắt đầu vẽ
			//1 là số tam giác sẽ vẽ
			context3d.drawTriangles(indexBuffer, 0, 1);
			
			//Hiển thị tam giác tra màn hình
			context3d.present();
		}
	}
}