package
{
	import com.greensock.*;
	import com.greensock.easing.*;
	
	import flash.display3D.*;
	
	import starling.*;
	import starling.core.*;
	import starling.display.*;
	import starling.errors.*;
	import starling.events.*;
	import starling.text.TextField;
	import starling.textures.*;
	import starling.utils.*;
	
	public class Game extends Sprite
	{
		public var quadSize:int = 30;
		public function getIntRandom(min:int,max:int):int
		{
			return Math.round(min+(max-min)*Math.random());
		}
		
		public function getNumberRandom(min:Number,max:Number):Number
		{
			return min+(max-min)*Math.random();
		}
		
		private var m_quadList:Array= new Array();
		public var colorMap:Array = new Array();
		var qdBatch:QuadBatch = new QuadBatch();
		public function Game()
		{
			
			
			
			var bottomColor:uint = 0x000000; // blue
			var topColor:uint    = 0xff0000; // red
			
			
			colorMap = new Array();
			for(var i:int = 0;i<(960/quadSize) + 1;i++)
			{
				var colorRow:Array = new Array();
				var fColor:int = 0;
				for(var j:int = 0;j<(640/quadSize) + 1;j++)
				{
					var red:int = Color.getRed(fColor);
					var blue:int = Color.getBlue(fColor);
					var green:int = Color.getGreen(fColor);
					red+=getIntRandom(10,45);;
					blue+=getIntRandom(10,15);;
					green+=getIntRandom(5,25);;
					fColor = Color.argb(1,red,green,blue);
					colorRow.push(fColor);
				}
				colorMap.push(colorRow);
			}
	
			
			//960 600
			for(var i:int = 0;i<960/quadSize;i++)
			{
				var quadRow:Array = new Array;
				for(var j:int = 0;j<640/quadSize;j++)
				{
					var quad:starling.display.Quad = new starling.display.Quad(quadSize, quadSize);
					quad.x = i*quadSize;
					quad.y = j*quadSize;
					
					quad.setVertexColor(0, colorMap[i][j]);
					quad.setVertexColor(1, colorMap[i+1][j]);
					quad.setVertexColor(2, colorMap[i][j+1]);
					quad.setVertexColor(3, colorMap[i+1][j+1]);
					quad.touchable = false;
					quad.blendMode = BlendMode.NONE;
					//addChild(quad);
					qdBatch.addQuad(quad);
					quadRow.push(quad);
				}
				m_quadList.push(quadRow);
			}
			
			addChild(qdBatch);
			//qdBatch.scaleX = 4;
			this.addEventListener(Event.ENTER_FRAME,onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void
		{
			/*colorMap = new Array();
			for(var i:int = 0;i<(960/quadSize) + 1;i++)
			{
				var colorRow:Array = new Array();
				var fColor:int = 0;
				for(var j:int = 0;j<(640/quadSize) + 1;j++)
				{
					var red:int = Color.getRed(fColor);
					var blue:int = Color.getBlue(fColor);
					var green:int = Color.getGreen(fColor);
					red+=getIntRandom(10+i+j,35+i+j);;
					blue+=getIntRandom(5+i+j,15+i+j);;
					green+=getIntRandom(5+i+j,35+i+j);;
					fColor = Color.argb(1,red,green,blue);
					colorRow.push(fColor);
				}
				colorMap.push(colorRow);
			}*/
			
			/*var red:int = Color.getRed(colorMap[5][5]);
			var blue:int = Color.getBlue(colorMap[5][5]);
			var green:int = Color.getGreen(colorMap[5][5]);
			red++;
			blue++;
			green++;
			if(red>255)
				red = 255;
			if(blue>255)
				blue = 255;
			if(green>255)
				green = 255;
			colorMap[5][5] = Color.argb(1,red,green,blue);
			colorMap[5][6] = Color.argb(1,red,green,blue);
			colorMap[6][6] = Color.argb(1,red,green,blue);
			colorMap[6][5] = Color.argb(1,red,green,blue);*/
			qdBatch.reset();
			//qdBatch.blendMode = BlendMode.ADD;
			for(var i:int = 0;i<960/quadSize;i++)
			{
				for(var j:int = 0;j<640/quadSize;j++)
				{
					m_quadList[i][j].setVertexColor(0, colorMap[i][j]);
					m_quadList[i][j].setVertexColor(1, colorMap[i+1][j]);
					m_quadList[i][j].setVertexColor(2, colorMap[i][j+1]);
					m_quadList[i][j].setVertexColor(3, colorMap[i+1][j+1]);
					qdBatch.addQuad(m_quadList[i][j]);
				}
			}
			//qdBatch.scaleX = getNumberRandom(1.0,8.0);
			//qdBatch.scaleY = getNumberRandom(1.0,4.0);
			//qdBatch.alpha = getNumberRandom(0.2,1.0);
			//qdBatch.alpha = 0.1;
		}
	}
}