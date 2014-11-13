package  
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.*;

	/**
	 * ...
	 * @author ...
	 */
	public class SpinWheel extends Sprite
	{
		[Embed(source="../images/wheel.png")]
		public var SwWheel:Class;
		public var wheel:DisplayObject  = new SwWheel;
		[Embed(source="../images/cta_def.png")]
		public var Cta1:Class;
		public var CtaDef:DisplayObject  = new Cta1;
		[Embed(source="../images/cta_alt.png")]
		public var Cta2:Class;
		public var CtaAlt:DisplayObject  = new Cta2;
		
        public var holder:Sprite = new Sprite();  
		public var holder1:Sprite = new Sprite();  
		public var button:Sprite = new Sprite(); 
		
		public var spinning:Boolean = false;
		public var spinTween:Tween;
		public var startTime:Number;
		
		public var STAGE_SIZE:Number = 614;
		
		public function SpinWheel() 
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			holder1.addChild(wheel);
			wheel.x -= 307;
			wheel.y -= 307;
			holder.addChild(holder1);
			holder1.x += 307;
			holder1.y += 307;
			holder.addChild(CtaAlt);
			CtaAlt.x = (STAGE_SIZE - CtaAlt.width) / 2;
			CtaAlt.y = (STAGE_SIZE - CtaAlt.height) / 2;
			button.addChild(CtaDef);
			holder.addChild(button);
			CtaDef.x = (STAGE_SIZE - CtaDef.width) / 2;
			CtaDef.y = (STAGE_SIZE - CtaDef.height) / 2;
			addChild(holder);
			button.addEventListener(MouseEvent.CLICK, spinWheel);
		}
		
		private function spinWheel(e:MouseEvent):void {
			var pick:int = (Math.random() * 100) + 1;
			var bonus = 0;
			if (pick > 1) {
				bonus += 30;
			}
			if (pick > 2) {
				bonus += 30;
			}
			if (pick > 5) {
				bonus += 30;
			}
			if (pick > 7) {
				bonus += 30;
			}
			if (pick > 10) {
				bonus += 30;
			}
			if (!spinning) {
				spinning = true;
				var spinTime = 2;
				var endRot = 360*1 + bonus;
				spinTween = new Tween(holder1, "rotation", Regular.easeOut, holder1.rotation, endRot, spinTime, true);
				spinTween.addEventListener(TweenEvent.MOTION_FINISH, spinTween_finished);
			}//*/
		}
		
		private function spinTween_finished(e:TweenEvent):void
		{
			trace("4");
			spinning = false;
		}	
	}

}