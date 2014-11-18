package  
{
	import flash.display.*;
	import flash.events.*;
	import flash.filters.BlurFilter;
	import flash.filters.DropShadowFilter;
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
	 * @author Zaldy
	 */
	public class SpinWheel extends Sprite
	{
		public var STAGE_SIZE:Number = 614;
		[Embed(source="../images/wheel.svg")]
		public var SwWheel:Class;
		public var wheel:Sprite  = new SwWheel;
		[Embed(source="../images/cta_def.png")]
		public var Cta1:Class;
		public var CtaDef:DisplayObject  = new Cta1;
		[Embed(source="../images/cta_alt.png")]
		public var Cta2:Class;
		public var CtaAlt:DisplayObject  = new Cta2;
		[Embed(source="../images/arrow.svg")]
		public var arr:Class;
		public var Arrow:Sprite  = new arr;
		[Embed(source="../images/shadowl.svg")]
		public var shad:Class;
		public var Shadow:Sprite  = new shad;
		public var Result:TextField = new TextField;
		
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
		private var text1:String;
		public var proxy:WebServiceProxy = new WebServiceProxy();
		
		public function SpinWheel() 
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			this.loaderInfo.addEventListener(Event.COMPLETE, loaderComplete);
						
			proxy.initialize();
			proxy.addEventListener(WebServiceProxy.READY, generateUI);
		}
		
		private function loaderComplete(e:Event):void 
		{
			trace("LoaderComplete");
			var ping:TextField = new TextField;
			ping.text = "x:";
			var paramObj:Object = LoaderInfo(this.root.loaderInfo).parameters;
			ping.text += " "+paramObj.USERNAME + ", "+paramObj.PASSWORD; 
			//addChild(ping);
			Settings.USERNAME = paramObj.USERNAME;
			Settings.PASSWORD = paramObj.PASSWORD;
			Settings.API_URL = paramObj.API_URL;
		}
		
		private function generateUI(e:Event):void 
		{
			trace("READY!");
			holder1.addChild(wheel);
			wheel.width =STAGE_SIZE;
			wheel.height = STAGE_SIZE;
			wheel.x -= STAGE_SIZE / 2;
			wheel.y -= STAGE_SIZE / 2;
			holder.addChild(holder1);
			holder1.x += STAGE_SIZE / 2;
			holder1.y += STAGE_SIZE / 2;
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
			Shadow.width =STAGE_SIZE;
			Shadow.height = STAGE_SIZE;
			shadowholder.addChild(Shadow);
			
			var myFormat:TextFormat = new TextFormat();
			myFormat.size = 150;
			myFormat.color = 0xffffff
			myFormat.font = "Haettenschweiler"
			myFormat.bold = true;
			Result.defaultTextFormat = myFormat;
			Result.text = "+$500";
			Result.autoSize = TextFieldAutoSize.CENTER;
			Result.x = (STAGE_SIZE - Result.width) / 2;
			Result.y = (STAGE_SIZE - Result.height) / 2;//15,45,10,0.5, 10.0, 10.0,1.0
			Result.mouseEnabled = false;
			var dropshadow:BlurFilter = new BlurFilter();
			Shadow.filters = [dropshadow];
			shadowholder.addChild(Result);
			
			addChild(shadowholder);
			shadowholder.visible = false;
			button.addEventListener(MouseEvent.MOUSE_DOWN, spinWheelpressed);
			button.addEventListener(MouseEvent.MOUSE_UP, spinWheel);
			button.addEventListener(MouseEvent.MOUSE_OUT, spinWheelaway);
		}
		
		private function spinWheelaway(e:MouseEvent):void 
		{
			CtaAlt.visible = false;
		}
		
		private function spinWheelpressed(e:MouseEvent):void 
		{
			CtaAlt.visible = true;
		}
		
		private function spinWheel(e:MouseEvent):void {
			CtaAlt.visible = false;
			if (!spinning) {
				spinning = true;
				proxy.getRandomNumber();
				//PICKER = proxy.randomInt();
				proxy.addEventListener(WebServiceProxy.RANDOM_NUMBER_GENERATED, spinIt);
			}
			
		}
		
		private function spinIt(e:Event):void 
		{
			if(proxy.getrandomInt() != 0){
				PICKER = proxy.getrandomInt();
				
				var gap:Number = 150;// default to $5
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
		
		private function spinTween_finished(e:TweenEvent):void
		{
			Arrow.rotation = 0;
			Arrow.y = ((STAGE_SIZE - Arrow.height)/2);
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
			aniWin = new Tween(shadowholder, "alpha", Regular.easeIn, 1, 0, 0.5, true);
			aniWin.addEventListener(TweenEvent.MOTION_FINISH, 
				function clearScrn(e:TweenEvent):void 
				{
					shadowholder.visible = false;
					spinning = false;
				}
			);
		}
	}

}