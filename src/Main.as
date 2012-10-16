package 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.StageScaleMode; 
	
	/**
	 * ...
	 * @author 
	 */

	public class Main extends MovieClip 
	{		
		
		public var currentLevel:int = 0;
		public var level1:LevelOne = null;
		public var level2:LevelTwo = null;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
			
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			//Sets stage scaling
			stage.scaleMode = StageScaleMode.EXACT_FIT
			
			//Init everthing here
			currentLevel = 2;		
			
			
			
			stage.addEventListener(Event.ENTER_FRAME, Update);
			
		}
		
		public function Update(e:Event):void
		{	
			
			switch (currentLevel)
			{
				case 0: //menu for selecting level
						//will be for testing only
					break;
				case 1:
					
					if (level1 != null)
					{
						level1.Update(e);
					}
					else
					{
						level1 = new LevelOne;
						level1.init(stage);
					}
					
					break;
					
				case 2:
					
					if (level2 != null)
					{
						level2.Update(e);
					}
					else
					{
						level2 = new LevelTwo;
						level2.init(stage);
					}
					
					break;
			}
			
		}
		
	}
	
}