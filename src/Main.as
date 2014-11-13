package 
{
	import flash.display.Sprite;
	import flash.display.*;
	import flash.events.*;
	import flash.utils.getTimer;
	import fl.transitions.TweenEvent;
	
	/**
	 * ...
	 * @author Zaldy Jr.
	 */
	public class Main extends Sprite 
	{
		var spinning:Boolean = false;
		var spinTween:Tween;
		var startTime:Number;
		
		
		function setStartTime(e:MouseEvent) {
			startTime = getTimer(); 
		}
		
		function spinWheel(e:MouseEvent) {
			if (!spinning) {
				spinning = true;
				var spinTime = Math.min(12.2, Math.max(2.12, ((getTimer() - startTime) / 100)));
				var endRot = Math.round((spinTime * 360) + (Math.random() * 360));
				spinTween = new Tween(wheel, "rotation", Regular.easeOut, wheel.rotation, endRot, spinTime, true);
				spinTween.addEventListener(TweenEvent.MOTION_FINISH, spinTween_finished);
			}
		}
		
		function spinTween_finished(e:TweenEvent):void
		{
			spinning = false;
		}	
	}
	
}