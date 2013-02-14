package
{
	//import flash.display.MovieClip;
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
	
	public class Cabal extends Sprite
	{
		//[Embed(source = "assets/bg.png")]
		[Embed(source = "assets/testgrid.jpg")]
		private static const Background:Class;
		
		[Embed(source="assets/man.xml", mimeType="application/octet-stream")]
		public static const ManXML:Class;

		[Embed(source="assets/man.png")]
		public static const ManTexture:Class;
		
		[Embed(source="assets/moveBar.png")]
		public static const MoveBarTexture:Class;
		
		[Embed(source="assets/bomb.xml", mimeType="application/octet-stream")]
		public static const BombXML:Class;
		
		[Embed(source="assets/bomb.png")]
		public static const BombTexture:Class;

		
		private var movie:MovieClip;
		
		private var sharedObjTest:SharedObject;
		
		private static var clc:LoaderContext = new LoaderContext(false,ApplicationDomain.currentDomain);

		private var m_monsterList:Array = new Array();
		private var m_bulletList:Array = new Array();
		
		public function Cabal()
		{
			clc.allowCodeImport = true;
			super();
			
			var blur:BlurFilter = new BlurFilter();
			var dropShadow:BlurFilter = BlurFilter.createDropShadow();
			var glow:BlurFilter = BlurFilter.createGlow();
			
			var background:Image = Image.fromBitmap(new Background());
			background.scaleX = 960/background.width;
			background.scaleY = 640/background.height;
			background.smoothing = TextureSmoothing.NONE;
			addChild(background);
			//background.filter = blur;
			
			
			// Some styles
			var lavaThickness:Number = 90;
			var bankThickness:Number = lavaThickness*2.2;
			
			/*var background:Image = new Image(Texture.fromBitmap(new FinalBackgroundBMP()));
			background.width = 960;
			background.height = 640;
			addChild(background);*/
			
			
			// create atlas
			var texture:Texture = Texture.fromBitmap(new ManTexture(),false);
			var xml:XML = XML(new ManXML());
			var atlas:TextureAtlas = new TextureAtlas(texture, xml);
			
			// create movie clip
			movie = new MovieClip(atlas.getTextures("m_walk_"), 8);
			//movie.loop = true; // default: true
			movie.play();
			addChild(movie);
			movie.x = 480;
			movie.y = 550;
			movie.pivotX = movie.width/2;
			movie.pivotY = movie.height/2;
			movie.scaleX = 3.0;
			movie.scaleY = 3.0;
			/*movie.setVertexColor(0,Color.RED);
			movie.setVertexColor(1,Color.RED);
			movie.setVertexColor(2,Color.BLUE);
			movie.setVertexColor(3,Color.BLUE);*/
			movie.smoothing = TextureSmoothing.NONE;
			
			
			
			
			movie.filter = glow;
			
			Starling.juggler.add(movie);
			// control playback
			//movie.play();
			//movie.pause();
			//movie.stop();
			
			var moveBar:Image = Image.fromBitmap(new MoveBarTexture());
			moveBar.scaleX = 2;
			moveBar.scaleY = 2;
			moveBar.x = 0;
			moveBar.y = 590;
			
			moveBar.smoothing = TextureSmoothing.NONE;
			addChild(moveBar);
			
			this.addEventListener(TouchEvent.TOUCH, onTouch);
			this.addEventListener(starling.events.Event.ENTER_FRAME,updateFrame);
			
			
			for(var i:int = 0;i<10;i++)
			{
				var monster:Monster = new Monster();
				monster.create(this);
				m_monsterList.push(monster);
			}
			/*sharedObjTest = SharedObject.getLocal("bg5");
			if(sharedObjTest.data.img)
			{
				loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, onComplete_handler);
				loader.loadBytes(sharedObjTest.data.img,clc);
			}
			else
			{
				var mRequest:URLRequest = new URLRequest("http://wiki.starling-framework.org/_media/manual/penguflip_atlas.png");
				loader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, onComplete_handler);
				loader.load(mRequest);
			}*/
			

		}
		var loader:Loader = new Loader();
		private function onComplete_handler(e:flash.events.Event):void
		{
			var drawBitmap:Bitmap = null;
			if(loader.content is Bitmap)
				drawBitmap = (loader.content as Bitmap);
			else
			{
				var bdBp:BitmapData = new BitmapData(loader.content.width,loader.content.height);
				bdBp.draw(loader.content);
				drawBitmap = new Bitmap(bdBp);
			}
			var background:Image = Image.fromBitmap(drawBitmap);
			background.scaleX = 960/background.width;
			background.scaleY = 640/background.height;
			background.smoothing = TextureSmoothing.NONE;
			addChildAt(background,0);
			
			sharedObjTest = SharedObject.getLocal("bg5");
			sharedObjTest.data.img = loader.content.loaderInfo.bytes;
			//sharedObjTest.flush();
		}
		
		private var lastPos:Point = null;
		private var m_touch:Touch = null;
		private function onTouch(event:starling.events.TouchEvent):void
		{
			var touch:Touch = event.getTouch(this, TouchPhase.BEGAN);
			if(touch)
			{
				var localPos:Point = touch.getLocation(this);
				if(localPos.y > 500 && m_touch == null)
				{
					m_touch = touch;
				}
			}	
			
			
			if (touch)
			{
				var localPos:Point = touch.getLocation(this);
				
				if(localPos.y>500)
					return;
				//astPos = localPos;
				
				/*var texture:Texture = Texture.fromBitmap(new BombTexture());
				var xml:XML = XML(new BombXML());
				var atlas:TextureAtlas = new TextureAtlas(texture, xml);
				// create movie clip
				var bombMovie:MovieClip = new MovieClip(atlas.getTextures("bomb_"), 12);
				bombMovie.loop = false;
				bombMovie.play();
				addChild(bombMovie);
				
				bombMovie.pivotX = bombMovie.width/2;
				bombMovie.pivotY = bombMovie.height/2;
				
				bombMovie.x = localPos.x;
				bombMovie.y = localPos.y;
				bombMovie.scaleX = 3.0;
				bombMovie.scaleY = 3.0;
				bombMovie.smoothing = TextureSmoothing.NONE;
				bombMovie.addEventListener(starling.events.Event.COMPLETE,onBombOver);
				Starling.juggler.add(bombMovie);
				
				for(var i:int = 0;i<m_monsterList.length;i++)
				{
					if(m_monsterList[i].isHit(localPos.x,localPos.y))
					{
						m_monsterList[i].destroy();
						m_monsterList.splice(i,1);
						break;
					}
				}*/
				
				var bullet:Bullet = new Bullet(this);
				bullet.create(movie.x,movie.y-20,localPos.x,localPos.y);
				m_bulletList.push(bullet);
			}
			
			
			touch = event.getTouch(this, TouchPhase.ENDED);
			if(touch)
			{
				if(touch == m_touch)
					m_touch = null;
			}
			
			//trace("Touched");
			
			
		}
		
		private function onBombOver(e:starling.events.Event):void
		{
			e.target.removeEventListener(starling.events.Event.COMPLETE,onBombOver);
			Starling.juggler.remove(e.target as MovieClip);
			this.removeChild(e.target as MovieClip,true);
		}
		
		private function updateFrame(e:starling.events.Event):void
		{
			if (m_touch)
			{
				/*if(lastPos == null)
				{
				lastPos = m_touch.getLocation(this);
				return;
				}*/
				var localPos:Point = m_touch.getLocation(this);
				if(localPos.x < 200 && movie.x > 0)
					movie.x -= ((200-localPos.x)/10+1);
				if(localPos.x > 200 && localPos.x < 400 && movie.x < 960)
					movie.x += ((localPos.x-200)/10+1);;
				//astPos = localPos;
				
				//trace("Touched object at position: " + localPos);
			}
			
			shotIt:
			for(var i:int = 0;i<m_bulletList.length;i++)
			{
				var nTest:int = 0;
				for(var j:int = 0;j<m_monsterList.length;j++)
				{
					var p1:Point = new Point(m_bulletList[i].getPosX(), m_bulletList[i].getPosY());
					var p2:Point = new Point(m_monsterList[j].getPosX(), m_monsterList[j].getPosY());
					
					var distance:Number = Point.distance(p1, p2);
					var radius1:Number = 8;
					var radius2:Number = 24;
					
					if (distance < radius1 + radius2)
					{
						var texture:Texture = Texture.fromBitmap(new BombTexture());
						var xml:XML = XML(new BombXML());
						var atlas:TextureAtlas = new TextureAtlas(texture, xml);
						// create movie clip
						var bombMovie:MovieClip = new MovieClip(atlas.getTextures("bomb_"), 12);
						bombMovie.loop = false;
						bombMovie.play();
						addChild(bombMovie);
						
						bombMovie.pivotX = bombMovie.width/2;
						bombMovie.pivotY = bombMovie.height/2;
						
						bombMovie.x = m_bulletList[i].getPosX();
						bombMovie.y = m_bulletList[i].getPosY();
						bombMovie.scaleX = 3.0;
						bombMovie.scaleY = 3.0;
						bombMovie.smoothing = TextureSmoothing.NONE;
						bombMovie.addEventListener(starling.events.Event.COMPLETE,onBombOver);
						Starling.juggler.add(bombMovie);
						
						m_monsterList[j].destroy();
						m_monsterList.splice(j,1);
						j--;
						
						m_bulletList[i].destroy();
						m_bulletList.splice(i,1);
						i--;
						continue shotIt;
					}
				}
			}
		}
		
		public function removeBullet(bullet:Bullet):void
		{
			for(var i:int = 0;i<m_bulletList.length;i++)
			{
				if(m_bulletList[i] == bullet)
				{
					m_bulletList.splice(i,1);
					return;
				}
			}
		}
		
		public function getIntRandom(min:int,max:int):int
		{
			return Math.round(min+(max-min)*Math.random());
		}
		
		public function getNumberRandom(min:Number,max:Number):Number
		{
			return min+(max-min)*Math.random();
		}
	}
}