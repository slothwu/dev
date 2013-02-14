package
{
	import com.greensock.*;
	import com.greensock.easing.*;
	
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
	import starling.filters.*;
	import starling.text.TextField;
	import starling.textures.*;
	import starling.utils.*;
	
	public class MapTest extends Sprite
	{
		[Embed(source = "assets/bg.png")]
		private static const Background:Class;
		
		private var m_sizeGrid:int = 80;
		private var m_numGrid:int = 20;
		
		private var bgHold:Sprite;
		
		public function MapTest()
		{
			super();
			
			bgHold = new Sprite();
			
			var background:Image = Image.fromBitmap(new Background());
			background.scaleX = m_sizeGrid*m_numGrid/background.width;
			background.scaleY = m_sizeGrid*m_numGrid/background.height;
			background.smoothing = TextureSmoothing.NONE;
			bgHold.addChild(background);
			
			var shape:Shape = new Shape();
			bgHold.addChild(shape);

			shape.graphics.lineStyle(1,0xFF2222);
			
			for(var i:int = 0;i<m_numGrid+1;i++)
			{
				shape.graphics.moveTo(0, m_sizeGrid*i);
				shape.graphics.lineTo(m_sizeGrid*m_numGrid, m_sizeGrid*i);
				
				shape.graphics.moveTo(m_sizeGrid*i, 0);
				shape.graphics.lineTo(m_sizeGrid*i, m_sizeGrid*m_numGrid);
			}
			
			var numView:Sprite = new Sprite();
			
			for(var i:int = 0;i<m_numGrid;i++)
			{
				for(var j:int = 0;j<m_numGrid;j++)
				{
					var ss:TextField = new TextField(50,30,i.toString()+"-"+j.toString(),"Verdana",12,0xff00ff);
					ss.x = i*m_sizeGrid;
					ss.y = 20+j*m_sizeGrid;
					//numView.addChild(ss);
				}
			}
			numView.flatten();
			
			bgHold.addChild(numView);
			
			addChild(bgHold);
			this.touchable = true;
			this.addEventListener(TouchEvent.TOUCH, onTouch);
			this.addEventListener(starling.events.Event.ENTER_FRAME,updateFrame);
			/*shape.graphics.moveTo(110, 0);
			shape.graphics.lineTo(210, 0);
			shape.graphics.lineTo(210, 100);
			//shape.graphics.lineTo(110, 100);
			shape.graphics.lineTo(110, 0);*/
		}
		
		private var m_touch:Touch = null;
		private var m_lastX:int = 0;
		private var m_lastY:int = 0;
		private function onTouch(event:starling.events.TouchEvent):void
		{
			/*var touch:Touch = event.getTouch(this, TouchPhase.MOVED);
			if(touch)
			{
				bgHold.x -= touch.previousGlobalX - touch.globalX;
				bgHold.y -= touch.previousGlobalY - touch.globalY;
			}	*/
			var touch:Touch = event.getTouch(this, TouchPhase.BEGAN);
			if(touch)
			{
				trace("touche begin")
				m_touch = touch;
				m_lastX = m_touch.getLocation(this).x;
				m_lastY = m_touch.getLocation(this).y;
			}
			
			if(m_touch!= null && event.getTouch(this, TouchPhase.ENDED) == m_touch)
			{
				trace("touche end")
				m_touch = null;
			}
		}
			//trace("Touched");
		
		private function updateFrame(e:starling.events.Event):void
		{
			if (m_touch)
			{
				var localPos:Point = m_touch.getLocation(this);
				bgHold.x -= m_lastX - localPos.x;
				bgHold.y -= m_lastY - localPos.y;
				m_lastX = localPos.x;
				m_lastY = localPos.y;
				trace("moveing");
			}
		}
	}
}