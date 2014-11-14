package  
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	import fl.transitions.Tween;
	import fl.transitions.TweenEvent;
	import fl.transitions.easing.*;
	import flash.utils.Timer;

	/**
	 * ...
	 * @author ...
	 */
	public class SpinWheel extends Sprite
	{
		public var STAGE_SIZE:Number = 614;
		
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
		[Embed(source="../images/shadowl.png")]
		public var shad:Class;
		public var Shadow:DisplayObject  = new shad;
		public var Result:TextField = new TextField;
		public var txt:TextField = new TextField;
		
        public var holder:Sprite = new Sprite();  
		public var holder1:Sprite = new Sprite();  
		public var button:Sprite = new Sprite(); 
		 
		public var shadowholder:Sprite = new Sprite(); 
		
		public var spinning:Boolean = false;
		public var spinTween:Tween;
		public var aniWin:Tween;
		public var startTime:Number;
		
		public var PICKER:int = 1;
		
		private var _proxy:WebServiceProxy;
		public var proxy:WebServiceProxy = new WebServiceProxy();
		
		public function SpinWheel() 
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			txt.text = "WSDL Loading";
			addChild(txt);
			
			proxy.initialize();
			proxy.addEventListener(WebServiceProxy.READY, generateUI);
		}
		
		private function generateUI(e:Event):void 
		{
			trace("READY!");
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
			holder.addChild(CtaAlt);
			CtaAlt.x = (STAGE_SIZE - CtaAlt.width) / 2;
			CtaAlt.y = (STAGE_SIZE - CtaAlt.height) / 2;
			CtaAlt.visible = false;
			addChild(holder);
			Arrow.x = (STAGE_SIZE - Arrow.width);
			Arrow.y = (STAGE_SIZE - Arrow.height)/2;
			addChild(Arrow);
			Shadow.alpha = 0.8;
			shadowholder.addChild(Shadow);
			txt.text = "WSDL Loaded";
			
			var myFormat:TextFormat = new TextFormat();
			myFormat.size = 150;
			myFormat.color = 0xffffff
			myFormat.font = "Haettenschweiler"
			myFormat.bold = true;
			Result.defaultTextFormat = myFormat;
			Result.text = "+$500";
			Result.autoSize = TextFieldAutoSize.CENTER;
			Result.x = (STAGE_SIZE - Result.width) / 2;
			Result.y = (STAGE_SIZE - Result.height) / 2;
			Result.mouseEnabled = false;
			shadowholder.addChild(Result);
			
			addChild(shadowholder);
			shadowholder.visible = false;
			button.addEventListener(MouseEvent.CLICK, spinWheel);
			
			
		}
		
		private function spinWheel(e:MouseEvent):void {
			if (!spinning) {
				spinning = true;
				addEventListener(Event.ENTER_FRAME, loop);
				proxy.getRandomNumber();
				//PICKER = proxy.randomInt();
				proxy.addEventListener(WebServiceProxy.RANDOM_NUMBER_GENERATED, spinIt);
			}
			
		}
		
		private function spinIt(e:Event):void 
		{
			if(proxy.getrandomInt() != 0){
				PICKER = proxy.getrandomInt();
				
				var gap:Number = 150;	
				if (PICKER == 6 || PICKER == 12) {
					trace("$500");
					Result.text = "+$500";
					gap = 0;
				}else
				if (PICKER == 5 || PICKER == 11) {
					trace("$100");
					Result.text = "+$100";
					gap = 60;
				}else
				if (PICKER == 4 || PICKER == 10) {
					trace("$50");
					Result.text = "+$50";
					gap = 120;
				}else
				if (PICKER == 3 || PICKER == 9) {
					trace("$20");
					Result.text = "+$20";
					gap = 90;
				}else
				if (PICKER == 2 || PICKER == 8) {
					trace("$10");
					Result.text = "+$10";
					gap = 30;
				}else{
					trace("$5");
					Result.text = "+$5";
					gap = 150;
				}
				
				
				var spinTime:Number = 7;
				var endRot:Number = 360*5 + gap;
				spinTween = new Tween(holder1, "rotation", Regular.easeOut, holder1.rotation, endRot, spinTime, true);
				spinTween.addEventListener(TweenEvent.MOTION_FINISH, spinTween_finished);
				
			}
		}
		
		private function loop(e:Event):void 
		{
			if ((holder1.rotation % 30 < 20 && holder1.rotation % 30 > 10) || (holder1.rotation % 30 < -10 && holder1.rotation % 30 > -20)) {
				Arrow.rotation = -10;
				Arrow.y = ((STAGE_SIZE - Arrow.height) / 2) + 20;
				CtaAlt.visible = true;
			}else {
				Arrow.rotation = 0;
				Arrow.y = ((STAGE_SIZE - Arrow.height) / 2);
				CtaAlt.visible = false;
			}
		}
		
		private function spinTween_finished(e:TweenEvent):void
		{
			trace('spinTween_finished');
			Arrow.rotation = 0;
			Arrow.y = ((STAGE_SIZE - Arrow.height)/2);
			removeEventListener(Event.ENTER_FRAME, loop);
			shadowholder.visible = true;
			aniWin = new Tween(shadowholder, "alpha", Regular.easeIn, 0, 1, 0.5, true);
			var myTimer:Timer = new Timer(1000, 4);
			myTimer.addEventListener(TimerEvent.TIMER, timerListener);
			var tm:int = 0;
			function timerListener (e:TimerEvent):void {
				//do nothing
			}
			myTimer.start();
			myTimer.addEventListener(TimerEvent.TIMER_COMPLETE, estaato);
		}
		
		private function estaato(e:TimerEvent):void 
		{
			trace('estaato');
			aniWin = new Tween(shadowholder, "alpha", Regular.easeIn, 1, 0, 0.5, true);
			aniWin.addEventListener(TweenEvent.MOTION_FINISH, 
				function clearScrn(e:TweenEvent):void 
				{
					
					trace('clearScrn');
					shadowholder.visible = false;
					spinning = false;
				}
			);
		}
	}

}