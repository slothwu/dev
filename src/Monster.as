package
{
	import com.greensock.*;
	
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
	
	public class Monster
	{
		[Embed(source="assets/monster.png")]
		public static const MonsterTexture:Class;
		[Embed(source="assets/monster.xml", mimeType="application/octet-stream")]
		public static const MonsterXML:Class;
		
		private var m_parent:Cabal = null;
		private var movie:MovieClip = null; 
		
		public function Monster()
		{
		}
		
		public function create(parent:Cabal):void
		{
			m_parent = parent;
			
			var texture:Texture = Texture.fromBitmap(new MonsterTexture(),false);
			var xml:XML = XML(new MonsterXML());
			var atlas:TextureAtlas = new TextureAtlas(texture, xml);
			
			// create movie clip
			movie = new MovieClip(atlas.getTextures("monster_"), 8);
			//movie.loop = true; // default: true
			movie.play();
			m_parent.addChild(movie);
			movie.x = m_parent.getIntRandom(0,960);
			movie.y = m_parent.getIntRandom(0,500);
			movie.pivotX = movie.width/2;
			movie.pivotY = movie.height/2;
			movie.scaleX = 3.0;
			movie.scaleY = 3.0;
			/*movie.setVertexColor(0,Color.RED);
			movie.setVertexColor(1,Color.RED);
			movie.setVertexColor(2,Color.BLUE);
			movie.setVertexColor(3,Color.BLUE);*/
			movie.smoothing = TextureSmoothing.NONE;
			
			Starling.juggler.add(movie);
			
			var destX:int = movie.x + m_parent.getIntRandom(-150,150);
			var destY:int = movie.y + m_parent.getIntRandom(-150,150);
			if(destX < 0)
				destX = 0;
			if(destX > 960)
				destX = 960;
			if(destY < 0)
				destY = 0;
			if(destY > 500)
				destY = 500
			TweenLite.to(movie,m_parent.getNumberRandom(2,5),{x:destX,y:destY,onComplete:moveOver});
		}
		
		private function moveOver():void
		{
			var destX:int = movie.x + m_parent.getIntRandom(-150,150);
			var destY:int = movie.y + m_parent.getIntRandom(-150,150);
			if(destX < 0)
				destX = 0;
			if(destX > 960)
				destX = 960;
			if(destY < 0)
				destY = 0;
			if(destY > 500)
				destY = 500
			TweenLite.to(movie,m_parent.getNumberRandom(2,5),{x:destX,y:destY,onComplete:moveOver});
		}
		
		public function isHit(posx:int,posy:int):Boolean
		{
			if(Math.abs(posx - movie.x) < 24 && Math.abs(posy - movie.y) < 24)
				return true;
			return false;
		}
		
		public function getPosX():int
		{
			return movie.x;
		}
		
		public function getPosY():int
		{
			return movie.y;
		}
		
		public function destroy():void
		{
			TweenLite.killTweensOf(movie);
			Starling.juggler.remove(movie);
			m_parent.removeChild(movie);
		}
	}
}