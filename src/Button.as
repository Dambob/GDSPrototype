package  
{
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.events.Event;
	/**
	 * ...
	 * @author 
	 */
	public class Button extends myObject 
	{
		
		public var level:int = 0;
		public var bLoad:Boolean = false;
		
		public function Button() 
		{
			
			
		}
		
		public function init():void
		{
			this.addEventListener(MouseEvent.CLICK, LoadLevel);
		}
		
		public function LoadLevel(e:MouseEvent = null):void
		{
			trace("HIT BUTTON");
			bLoad = true;
		}
		
	}

}