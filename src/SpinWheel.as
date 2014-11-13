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
		[Embed(source="../images/arrow.png")]
		public var arr:Class;
		public var Arrow:DisplayObject  = new arr;
		
        public var holder:Sprite = new Sprite();  
		public var holder1:Sprite = new Sprite();  
		public var button:Sprite = new Sprite(); 
		
		public var spinning:Boolean = false;
		public var spinTween:Tween;
		public var startTime:Number;
		
		public var PICKER:int = 0;
		
		public var STAGE_SIZE:Number = 614;
		
		private var _proxy:WebServiceProxy;
		public var proxy:WebServiceProxy = new WebServiceProxy();
		
		public function SpinWheel() 
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		public function setChance(x:int):void {
			PICKER = x;
			if (PICKER > 12) {
				PICKER = 12;
			}
		}
		
		private function onAddedToStage(e:Event):void 
		{
			
			proxy.initialize();
			
			proxy.addEventListener(WebServiceProxy.READY, generateUI);
			
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function generateUI(e:Event):void 
		{
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
			Arrow.x = (STAGE_SIZE - Arrow.width);
			Arrow.y = (STAGE_SIZE - Arrow.height)/2;
			addChild(Arrow);
			button.addEventListener(MouseEvent.CLICK, spinWheel);
			proxy.getRandomNumber();
			
			
		}
		
		private function loop(e:Event):void 
		{
			trace(holder1.rotation);
		}
		
		private function spinWheel(e:MouseEvent):void {
			addEventListener(Event.ENTER_FRAME, loop);
			proxy.getRandomNumber();
			//PICKER = proxy.randomInt();
			PICKER = proxy.getrandomInt();
			
			var gap:Number = 150;	
			if (PICKER == 6 || PICKER == 12) {
				trace("$500");
				gap = 0;
			}else
			if (PICKER == 5 || PICKER == 11) {
				trace("$100");
				gap = 60;
			}else
			if (PICKER == 4 || PICKER == 10) {
				trace("$50");
				gap = 120;
			}else
			if (PICKER == 3 || PICKER == 9) {
				trace("$20");
				gap = 90;
			}else
			if (PICKER == 2 || PICKER == 8) {
				trace("$10");
				gap = 30;
			}else
			if (PICKER == 1 || PICKER == 7) {
				trace("$5");
				gap = 150;
			}
			
			
			if (!spinning) {
				spinning = true;
				var spinTime:Number = 2;
				var endRot:Number = 360*6 + gap;
				spinTween = new Tween(holder1, "rotation", Regular.easeOut, holder1.rotation, endRot, spinTime, true);
				spinTween.addEventListener(TweenEvent.MOTION_FINISH, spinTween_finished);
			}//*/
			removeEventListener(Event.ENTER_FRAME, loop);
		}
		
		private function spinTween_finished(e:TweenEvent):void
		{
			spinning = false;
		}	
	}

}