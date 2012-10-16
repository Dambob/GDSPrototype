package  
{
	import flash.display.Stage;
	import flash.events.Event;
	/**
	 * ...
	 * @author 
	 */
	public class LevelDebug extends Level 
	{
		
		public var level:debugLevel = null;
		public var stageLink:Stage = null;
		
		public var buttons:Array = null;
		private var buttonCounter:int = 0;
		
		public function LevelDebug() 
		{
			
		}
		
		public function init(stageRef:Stage, e:Event = null):void
		{
			
			level = new debugLevel;
			buttons = new Array;
			
			stageLink = stageRef;
			
			trace("Added level");
			
			trace(level.numChildren);
			
			//crashes when trying to add level!!!!
			stageLink.addChild(level);
			
			trace(level.numChildren);
			
			for (var i:int = 0; i < level.numChildren; i++)
			{
				var object:Object = level.getChildAt(i);
				
				if (object is button)
				{
					trace("Found button at " + i);
					var button1:button = object as button;
					
					buttonCounter++;
					
					button1.level = buttonCounter;
					button1.init();
					
					buttons.push(button1);
				}
			}
			
		}
		
		public function Update(e:Event):void
		{
			
		}
		
		public function Delete():void
		{
			stageLink.removeChild(level)
			
			level = null;
			
		}
		
	}

}