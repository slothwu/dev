package
{
	import starling.display.*;
	import starling.textures.*;
	
	import com.greensock.*;
	import com.greensock.easing.Linear;

	public class Bullet
	{
		[Embed(source="assets/bullet.png")]
		public static const bulletTexture:Class;
		
		public static var bulletBmp:* = null;
		
		private var m_img:Image;
		private var m_parent:Cabal;
		
		public function Bullet(parent:Cabal)
		{
			m_parent = parent;
		}
		
		public function create(posx:int,posy:int,destX:int,destY:int):void
		{
			if(bulletBmp == null)
				bulletBmp = new bulletTexture();
			
			m_img = Image.fromBitmap(bulletBmp);
			m_img.pivotX =m_img.width/2;
			m_img.pivotY =m_img.height/2;
			m_img.scaleX = 2.0;
			m_img.scaleY = 2.0;
			m_img.smoothing = TextureSmoothing.NONE;
			m_img.x = posx;
			m_img.y = posy;
			m_parent.addChild(m_img);
			
			var gotoPosX:int = ((destX - posx)*-posy)/(destY - posy) + posx;
			
			var roadLength:Number = Math.sqrt( posy*posy + (gotoPosX - posx)*(gotoPosX - posx) );
			roadLength/=512;
			TweenLite.to(m_img,roadLength,{x:gotoPosX,y:0,onComplete:moveOver,ease:Linear.easeNone});
			
		}
		
		public function getPosX():int
		{
			return m_img.x;
		}
		
		public function getPosY():int
		{
			return m_img.y;
		}
		
		public function destroy():void
		{
			TweenLite.killTweensOf(m_img);
			m_parent.removeChild(m_img);
			//m_parent.removeBullet(this);
			m_img = null;
			m_parent = null;
		}
		
		private function moveOver():void
		{
			m_parent.removeChild(m_img);
			m_parent.removeBullet(this);
			m_img = null;
			m_parent = null;
		}
	}
}