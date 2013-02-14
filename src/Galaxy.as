package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.geom.*;
	import flash.net.*;
	import flash.system.*;
	
	import starling.core.Starling;
	import starling.display.*;
	import starling.display.shaders.vertex.*;
	import starling.events.*;
	import starling.text.TextField;
	import starling.textures.*;
	import starling.utils.*;
	import starling.filters.*;
	
	import com.greensock.*;
	import com.greensock.easing.*;
	
	public class Galaxy extends Sprite
	{
		var loader:Loader = new Loader();
		
		[Embed(source = "assets/crossline.png")]
		private static const CrossLine:Class;
		
		[Embed( source = "/assets/Rock.png" )]
		private var RockBMP			:Class;
		
		[Embed( source = "/assets/Checker.png" )]
		private var CheckerBMP		:Class;
		
		[Embed( source = "/assets/Marble.png" )]
		private var MarbleBMP		:Class;
		
		[Embed( source = "/assets/Grass.png" )]
		private var GrassBMP		:Class;
		
		public function Galaxy()
		{
			super();
			
			var mRequest:URLRequest = new URLRequest("assets/galaxy.jpg");
			loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, onComplete_handler);
			loader.load(mRequest);
			
			var cLine:Image = Image.fromBitmap(new CrossLine());
			cLine.alpha = 0.5;
			addChild(cLine);
			
			
			var shape:Shape = new Shape();
			addChild(shape);
			shape.x = 20;
			shape.y = 20;
			
			// Rect drawn with drawRect()
			shape.graphics.beginFill(0x22ffff);
			shape.graphics.drawRect(0, 0, 100, 100);
			shape.graphics.endFill();
			
			// Rect drawn with lineTo()
			shape.graphics.lineStyle(1,0xFF2222);
			//shape.graphics.beginFill(0xc72046);
			shape.graphics.moveTo(110, 0);
			shape.graphics.lineTo(210, 0);
			shape.graphics.lineTo(210, 100);
			//shape.graphics.lineTo(110, 100);
			shape.graphics.lineTo(110, 0);
			//shape.graphics.endFill();
			
			// Rounded rect
			shape.graphics.lineStyle(1,0xFF22FF);
			//shape.graphics.beginFill(0x0957c0);
			shape.graphics.drawRoundRect( 220, 0, 100, 100, 20 );
			shape.graphics.endFill();
			//shape.graphics.lineStyle();
			
			// Filled Circle
			shape.graphics.beginFill(0xfcc738);
			shape.graphics.drawCircle(380, 50, 50);
			shape.graphics.endFill();
			
			// Complex rounded rect
			shape.graphics.beginFill(0xff7b00);
			shape.graphics.drawRoundRectComplex( 0, 110, 430, 100, 0, 20, 40, 80 );
			shape.graphics.endFill();
			
			// Stroked ellipse
			shape.graphics.lineStyle(2, 0x00bff3);
			shape.graphics.drawEllipse(490, 105, 100, 200);
			
			// Multiple moveTo() test
			shape.graphics.lineStyle(2, 0xFFFFFF, 1);
			for ( var i:int = 0; i < 4; i++ )
			{
				shape.graphics.moveTo(0, 220+i*20);
				shape.graphics.lineTo(550, 220+i*20);
			}		
			
			var rockTexture:Texture = Texture.fromBitmap( new RockBMP(), false );
			var grassTexture:Texture = Texture.fromBitmap( new GrassBMP(), false );
			var checkerTexture:Texture = Texture.fromBitmap( new CheckerBMP(), false );
			var marbleTexture:Texture = Texture.fromBitmap( new MarbleBMP(), false );
			// Textured fill
			
			shape.graphics.beginTextureFill(marbleTexture);
			shape.graphics.lineTexture(20, grassTexture);
			shape.graphics.moveTo(0, 300);
			shape.graphics.lineTo(100, 400);
			shape.graphics.lineTo(0, 400);
			shape.graphics.lineTo(0, 300);
			shape.graphics.endFill();
			
			// Marble
			shape.graphics.beginTextureFill(marbleTexture);
			shape.graphics.lineTexture(20, grassTexture);
			shape.graphics.drawCircle(150, 364, 32);
			shape.graphics.endFill();
			
			// Rect drawn with textured fill and stroke
			/*shape.graphics.beginTextureFill(rockTexture);
			shape.graphics.lineTexture(20, grassTexture);
			shape.graphics.drawRect(0, 450, 550, 100);
			shape.graphics.endFill();*/
		}
		
		
		private function onComplete_handler(e:flash.events.Event):void
		{
			var drawBitmap:Bitmap = null;
			if(loader.content is Bitmap)
				drawBitmap = (loader.content as Bitmap);
			
			var background:Image = Image.fromBitmap(drawBitmap);
			background.pivotX = background.width/2;
			background.pivotY = background.height/2;
			background.scaleX = 0.005;
			background.scaleY = 0.005;
			background.x = 960/2;
			background.y = 640/2;
			
			background.smoothing = TextureSmoothing.TRILINEAR;
			addChildAt(background,0);
			
			//sharedObjTest = SharedObject.getLocal("bg5");
			//sharedObjTest.data.img = loader.content.loaderInfo.bytes;
			//sharedObjTest.flush();
			TweenLite.to(background,20,{scaleX:12,scaleY:12,rotation:50,/*onComplete:moveOver,*/ease:Expo.easeIn});
			//TweenLite.to(background,10,{scaleX:1,scaleY:1,/*onComplete:moveOver,*/ease:Linear.easeNone});
			
			var tri:Polygon = new Polygon(30,3,0xf0002f);
			//tri.pivotX = tri.width/2;
			//tri.pivotY = tri.height/2;
			//background.scaleX = 0.005;
			//background.scaleY = 0.005;
			tri.scaleX = 0.2;
			tri.scaleY = 0.2;
			tri.rotation = Math.PI/6;
			tri.x = 960/2;
			tri.y = 640/2;
			tri.alpha = 0.5;
			//tri.blendMode = BlendMode.ADD;
			addChild(tri);
			TweenLite.to(tri,3,{alpha:0,scaleX:20,scaleY:20,/*rotation:Math.PI/6+(Math.PI*2)/3,*/ease:Cubic.easeIn});
			
			var tri2:Polygon = new Polygon(30,3,0x00222f);
			//tri.pivotX = tri.width/2;
			//tri.pivotY = tri.height/2;
			//background.scaleX = 0.005;
			//background.scaleY = 0.005;
			tri2.scaleX = 0.2;
			tri2.scaleY = 0.2;
			tri2.rotation = Math.PI/6;
			tri2.x = 960/2;
			tri2.y = 640/2;
			tri2.alpha = 0.5;
			//tri2.blendMode = BlendMode.ADD;
			addChild(tri2);
			TweenLite.to(tri2,5,{alpha:0,scaleX:20,scaleY:20,/*rotation:Math.PI/6+Math.PI/18+(Math.PI*2)/3,*/ease:Cubic.easeIn});
			
			//setTimeout(
		}
	}
}