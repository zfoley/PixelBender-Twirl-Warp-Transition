package effects 
{
	import com.greensock.easing.Back;
	import com.greensock.easing.Expo;
	import com.greensock.easing.Sine;
	import com.greensock.TweenMax;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.IBitmapDrawable;
	import flash.display.Shader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.ShaderFilter;
	
	/**
	 * ...
	 * @author Zach
	 */
	public class TwirlEffect extends Sprite
	{
		// Grab the pixelBender Filters
		[Embed(source='twirl_scale.pbj', mimeType='application/octet-stream')]
		private var twirl:Class;
		[Embed(source='ripple.pbj', mimeType='application/octet-stream')]
		private var ripple:Class;

		private var shader:Shader;
		private var rippleshader:Shader;
		private var filter:ShaderFilter;
		private var ripplefilter:ShaderFilter;
		private var photo:Bitmap;
		public var amount:Number
		public var scale:Number
		
		public function TwirlEffect() 
		{
			trace("TwirlEffect");
			photo = new Bitmap(null, "auto", true);
		}
		private function reset(filterClass:Class):void 
		{
			shader = new Shader(new filterClass());
			filter = new ShaderFilter(shader);
			
			rippleshader = new Shader(new ripple());
			ripplefilter = new ShaderFilter(rippleshader);
					
			rippleshader.data.size.value = [0.8];
			rippleshader.data.amount.value = [0.9];
			rippleshader.data.phase.value = [0];
			rippleshader.data.radius.value = [300];
			rippleshader.data.center.value = [photo.width/2, photo.height/2];

		}
		public function effectIn(source:Bitmap):void {
			amount = 1;
			scale = 0.05;
			var data:BitmapData = new BitmapData(source.width, source.height, true, 0x00000000);
			data.draw(source);
			photo.bitmapData = data;
			addChild(photo);
			reset(twirl);
			TweenMax.to(this, 1.0,	{ scale:1, onUpdate:linearUpdate, ease:Expo.easeOut} );
			TweenMax.to(this, 1.0, { amount:0, onUpdate:update, ease:Back.easeOut, onComplete:repeatBuildOut, onCompleteParams:[source] } );
		}
		
		private function repeatBuildOut(source:Bitmap):void
		{
			TweenMax.delayedCall(1, effectOut, [source]);
		}
		private function repeatBuildIn(source:Bitmap):void
		{
			photo.bitmapData = null;
			TweenMax.delayedCall(1, effectIn, [source]);
		}
		public function effectOut(source:Bitmap):void {
			
			amount = 0;
			scale = 1;
			var data:BitmapData = new BitmapData(source.width, source.height, true, 0x00000000);
			data.draw(source);
			photo.bitmapData = data;
			addChild(photo);
			reset(twirl);
			TweenMax.to(this, 0.75,	{ scale:0.05, onUpdate:linearUpdate, ease:Sine.easeInOut} );
			TweenMax.to(this, 0.75, { amount:0.5, onUpdate:updateOut, ease:Sine.easeInOut, onComplete:repeatBuildIn, onCompleteParams:[source] } );			
		}
		private function linearUpdate(e:Event = null):void {
			shader.data.scale.value = [scale];

		}
		
		private function update(e:Event = null):void {
			if (filter == null) return;
			// TWIRL
			// Some other parameters you might want to play with are commented out here.
			//shader.data.size.value = [photo.width, photo.height];
			//shader.data.outputSize.value = [585, 341];
			//shader.data.latitude.value = [s * 90];
			//shader.data.longitude.value = [c * 360];
			//shader.data.bulge.value = [0];
			shader.data.center.value = [photo.width/2, photo.height/2];
			shader.data.scale.value = [scale];
			shader.data.radius.value = [75+(amount*180)];
			shader.data.twirlAngle.value = [amount * 180];

			// RIPPLE
			// Some other parameters you might want to play with are commented out here.
			//rippleshader.data.size.value = [amount-1];
			rippleshader.data.amount.value = [1-scale];
			rippleshader.data.phase.value[0] += 0.4;
			
			// Apply filter to the photo
			photo.filters = [filter, ripplefilter];
		}
		private function updateOut(e:Event = null):void {
			// These values are different so that the build-out looks different than the build-in.
			
			if (filter == null) return;
			// TWIRL 
			// Some other parameters you might want to play with are commented out here.
			//shader.data.size.value = [photo.width, photo.height];
			//shader.data.outputSize.value = [585, 341];
			//shader.data.latitude.value = [s * 90];
			//shader.data.longitude.value = [c * 360];
			//shader.data.bulge.value = [0];
			shader.data.center.value = [photo.width/2, photo.height/2];			
			shader.data.scale.value = [scale];			
			shader.data.radius.value = [0+(amount*180)];
			shader.data.twirlAngle.value = [amount*360];
			
			// RIPPLE
			// Some other parameters you might want to play with are commented out here.
			//rippleshader.data.size.value = [amount-1];
			rippleshader.data.amount.value = [0.09];
			rippleshader.data.phase.value[0] += 0.4;
					
			// Apply filter to the photo
			photo.filters = [filter, ripplefilter];
		}

	}

}