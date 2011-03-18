package 
{
	import effects.TwirlEffect;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	
	/**
	 * ...
	 * @author Zach
	 */
	public class Main extends Sprite 
	{
		[Embed(source = '300px-Convento_Cristo_December_2008-2a.jpg')]
		private var screengrab:Class
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			//Draw grey shape
			var s:Shape = new Shape();
			s.graphics.beginFill(0xFFFFFF);
			s.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			s.graphics.endFill();
			s.filters = [new GlowFilter(0x000000, 1, 32, 32, 0.5, 3, true, false)];
			addChild(s);
			// Create Image that we will twist
			var bmb:Bitmap = new screengrab() as Bitmap;
			// Create twist. It works as a display object, so you add it to the stage instead of the object you see getting twisted.
			var twist:TwirlEffect = new TwirlEffect();
			addChild(twist);
			twist.effectIn(bmb);
		}
		
	}
	
}