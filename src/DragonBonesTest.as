package
{
	import com.greensock.*;
	import com.greensock.easing.*;
	
	import dragonBones.Armature;
	import dragonBones.factorys.StarlingFactory;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.geom.*;
	import flash.net.*;
	import flash.system.*;
	import flash.utils.ByteArray;
	
	import starling.core.Starling;
	import starling.display.*;
	import starling.display.Sprite;
	import starling.display.shaders.vertex.*;
	import starling.events.EnterFrameEvent;
	import starling.filters.*;
	import starling.text.TextField;
	import starling.textures.*;
	import starling.utils.*;
	
	public class DragonBonesTest extends Sprite
	{
		[Embed(source = "assets/DragonWalk.png", mimeType = "application/octet-stream")]
		public static const ResourcesData:Class;
		
		private var armature:Armature;
		private var armatureClip:Sprite;
		private var factory:StarlingFactory;
		
		var loader:Loader = new Loader();
		
		var urlLoader:URLLoader =new URLLoader();
		
		public function DragonBonesTest()
		{
			super();
			
			factory = new StarlingFactory();
			factory.addEventListener(Event.COMPLETE, textureCompleteHandler);
			//factory.parseData(new ResourcesData());
			
			var mRequest:URLRequest = new URLRequest("assets/DragonWalk.png");
			
			urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			urlLoader.addEventListener(flash.events.Event.COMPLETE, onComplete_handler);
			urlLoader.load(mRequest);
		}
		
		private function onComplete_handler(e:flash.events.Event):void
		{
			
			factory.parseData(urlLoader.data);
		}


		
		private function textureCompleteHandler(e:Event):void {
			armature = factory.buildArmature("Dragon");
			armatureClip = armature.display as Sprite;
			armatureClip.x = 400;
			armatureClip.y = 550;
			addChild(armatureClip);
			armature.animation.gotoAndPlay("walk");
			addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrameHandler);
		}
		
		private function onEnterFrameHandler(e:EnterFrameEvent):void
		{
			armature.update()
		}
	}
}