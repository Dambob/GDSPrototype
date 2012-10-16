package  
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.Stage;
	/**
	 * ...
	 * @author 
	 */
	public class LevelTwo extends Level 
	{
		
		private var level:Level2 = null;
		private var player1:Player =  null;
		private var blocks:Array = null;
		private var spawn:playerSpawn = null;
		private var killboxes:Array = null;
		private var vine:climbingVine = null;
		
		private var stageLink:Stage = null;
		
		private var myCollisionList:CollisionList;
		
		
		public function LevelTwo() 
		{
			
		}
		
		public function init(stageRef:Stage)
		{
			
			level = new Level2;
			player1 =  new Player;
			blocks = new Array;
			spawn = new playerSpawn;
			killboxes = new Array;
			vine = new climbingVine;
				
			stageLink = stageRef;
			
			stageLink.addChild(level);
			
			
			for (var i:int = 0; i < level.numChildren; i++)
			{
				var object:Object = level.getChildAt(i);
				
			
				if (object is Player)
				{
					trace("Found player at " + i);
					player1 = object as Player;
					player1.level = level;
				}
				else if (object is Block)
				{
					trace("Found block at " + i);
					var block1:Block = object as Block;
					
					blocks.push(block1);
					
				}
				else if (object is playerSpawn)
				{
					trace("Found player spawn at " + i);

					spawn = object as playerSpawn;
				}
				else if (object is KillBox)
				{
					var killbox:KillBox = object as KillBox
					
					killboxes.push(killbox);
				}
				else if (object is climbingVine)
				{
					trace("Found vine at " + i);

					vine = object as climbingVine;
				}
			}	
			
			player1.spawn = spawn;
			
			player1.x = player1.spawn.x;
			player1.y = player1.spawn.y;
			
		}
		
		public function Update(e:Event):void
		{
			
			if (player1 != null)
			{	
				//Immediately resets the level on death
				//Perhaps use a counter or button press to allow death animations etc. to continue
				if (player1.bDead) 
				{					
					stageLink.removeChild(level);
					
					//Resets the level variable
					level = new Level2;	
					
					init(stageLink);
				}
				
				player1.Update(e);

				/* block collision */
				for (var i:int = 0; i < blocks.length; i++) 
				{
					var block:Block = blocks[i];
					
					if (player1.hitTestObject(block))
					{
						
						if (player1.y <= block.y)
						{
							player1.block = block;
													
							//Breaks out of for loop
							i = blocks.length - 1;
							
						}
					}
					else
					{
						player1.block = null;
					}	
				}
				
				for (var i:int = 0; i < killboxes.length; i++) 
				{
					var killbox:KillBox = killboxes[i];
					
					if (player1.hitTestObject(killbox))
					{
						killbox.Activate(player1);
					}	
				}
				
				if (player1.hitTestObject(vine))
				{
					trace("CAN CLIMB");
					player1.bCanClimb = true;
				}
				else
				{
					player1.bCanClimb = false;
				}

			}		
			
		}
		
		public function Delete():void
		{
			stageLink.removeChild(level)
			
			level = null;
			
		}
	}

}