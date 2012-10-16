package 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.StageScaleMode; 
	import flash.events.KeyboardEvent;
	
	/**
	 * ...
	 * @author 
	 */

	public class Main extends MovieClip 
	{		
		
		public var main:Main = null;
		
		public var currentLevel:int = 0;
		public var levelDebug:LevelDebug = null;
		public var level1:LevelOne = null;
		public var level2:LevelTwo = null;
		public var bLoading:Boolean = false;
		
		public var bQuit:Boolean = false;
		
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
			currentLevel = 0;		
			
			
			
			stage.addEventListener(Event.ENTER_FRAME, Update);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			
		}
		
		public function Update(e:Event):void
		{	
			
			switch (currentLevel)
			{
				case 0: //menu for selecting level
						//will be for testing only
					if (levelDebug != null)
					{
						
						
						for (var i:int = 0; i < levelDebug.buttons.length; i++)
						{
							if (levelDebug.buttons[i].bLoad)
							{
								currentLevel = levelDebug.buttons[i].level;
									
								bLoading = true;
								
							}
						}
						
						if (bLoading)
						{
							levelDebug.Delete();
							
							levelDebug = null;
							
							bLoading = false;
						}
						
					}
					else
					{
						trace("Init debug");
						levelDebug = new LevelDebug;
						levelDebug.init(stage);
					}
					break;
				case 1:
					
					if (level1 != null)
					{
						level1.Update(e);
						
						if (bQuit)
						{
							level1.Delete();
							level1 = null;
							currentLevel = 0;
							
							bQuit = false;
						}
						
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
						
						if (bQuit)
						{
							level2.Delete();
							level2 = null;
							currentLevel = 0;
							
							bQuit = false;
						}
					}
					else
					{
						level2 = new LevelTwo;
						level2.init(stage);
					}
					
					break;
			}
			
		}
		
		private function onKeyDown(event:KeyboardEvent):void
		{
			if (event.keyCode == 27)
			{
				//delete current level
				//load debug menu level
				
				trace("Escape");
				
				bQuit = true;
			}
			
		}
		
		
	}
	
}