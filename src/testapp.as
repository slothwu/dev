package
{
	import flash.display.Sprite;
	import starling.core.Starling;
	
	[SWF(width="960", height="640", frameRate="60", backgroundColor="#000000")]
	public class testapp extends Sprite
	{
		private var _starling:Starling;
		
		public function testapp()
		{
			Starling.multitouchEnabled = true;

			//_starling = new Starling(Cabal, stage);
			_starling = new Starling(MapTest, stage);
			//_starling = new Starling(DragonBonesTest, stage);
			
			_starling.showStats =  true;
			_starling.simulateMultitouch = true;
			_starling.start();
		}
	}
}