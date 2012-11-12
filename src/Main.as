package 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.StageScaleMode; 
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
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
		public var level3:LevelThree = null;
		public var level4:LevelFour = null;
		public var level5:LevelFive = null;
		public var level6:LevelSix = null;
		public var level7:LevelSeven = null;
		public var bLoading:Boolean = false;
		public var versionNumber:TextField = null;
		public var textFormat:TextFormat = null;
		public var version:String = "V 0.4.1";
		
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
							stage.removeChild(versionNumber);
							
							bLoading = false;
						}
						
					}
					else
					{
						trace("Init debug");
						levelDebug = new LevelDebug;
						levelDebug.init(stage);
						
						//Adds a basic version number
						textFormat = new TextFormat;
						textFormat.font = "Arial";
						textFormat.size = 24;
						versionNumber = new TextField;
						versionNumber.defaultTextFormat = textFormat;
						versionNumber.x = 50;
						versionNumber.y = 550;
						versionNumber.text = version;
						stage.addChild(versionNumber);
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
						else if (level1.bFinished)
						{
							level1.Delete();
							level1 = null;
							currentLevel = 2;
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
						else if (level2.bFinished)
						{
							level2.Delete();
							level2 = null;
							currentLevel = 3;
						}
					}
					else
					{
						level2 = new LevelTwo;
						level2.init(stage);
					}
					
					break;
					
				case 3:
					
					if (level3 != null)
					{
						level3.Update(e);
						
						if (bQuit)
						{
							level3.Delete();
							level3 = null;
							currentLevel = 0;
							
							bQuit = false;
						}
						else if (level3.bFinished)
						{
							level3.Delete();
							level3 = null;
							currentLevel = 4;
						}
					}
					else
					{
						level3 = new LevelThree;
						level3.init(stage);
					}
					
					break;
					
				case 4:
					
					if (level4 != null)
					{
						level4.Update(e);
						
						if (bQuit)
						{
							level4.Delete();
							level4 = null;
							currentLevel = 0;
							
							bQuit = false;
						}
						else if (level4.bFinished)
						{
							level4.Delete();
							level4 = null;
							currentLevel = 5;
						}
					}
					else
					{
						level4 = new LevelFour;
						level4.init(stage);
					}
					
					break;
				
				case 5:
					
					if (level5 != null)
					{
						level5.Update(e);
						
						if (bQuit)
						{
							level5.Delete();
							level5 = null;
							currentLevel = 0;
							
							bQuit = false;
						}
						else if (level5.bFinished)
						{
							level5.Delete();
							level5 = null;
							currentLevel = 6;
						}
					}
					else
					{
						level5 = new LevelFive;
						level5.init(stage);
					}
					
					break;
					
				case 6:
					
					if (level6 != null)
					{
						level6.Update(e);
						
						if (bQuit)
						{
							level6.Delete();
							level6 = null;
							currentLevel = 0;
							
							bQuit = false;
						}
						else if (level6.bFinished)
						{
							level6.Delete();
							level6 = null;
							currentLevel = 7;
						}
					}
					else
					{
						level6 = new LevelSix;
						level6.init(stage);
					}
					
					break;
					
				case 7:
					
					if (level7 != null)
					{
						level7.Update(e);
						
						if (bQuit)
						{
							level7.Delete();
							level7 = null;
							currentLevel = 0;
							
							bQuit = false;
						}
						else if (level7.bFinished)
						{
							level7.Delete();
							level7 = null;
							currentLevel = 0;
						}
					}
					else
					{
						level7 = new LevelSeven;
						level7.init(stage);
					}
					
					break;
					
				default:
					currentLevel = 0;
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