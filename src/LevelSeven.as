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
	public class LevelSeven extends Level 
	{
		private var level:Level7 = null;
		private var player1:Player =  null;
		private var blocks:Array = null;
		private var spawn:playerSpawn = null;
		private var killboxes:Array = null;
		private var vines:Array = null;
		
		private var stageLink:Stage = null;
		
		private var myCollisionList:CollisionList;
		
		public function LevelSeven() 
		{
			
		}
		
		public function init(stageRef:Stage):void
		{
			
			level = new Level7;
			player1 =  new Player;
			blocks = new Array;
			spawn = new playerSpawn;
			killboxes = new Array;
			vines = new Array;
				
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

					var vine:climbingVine = object as climbingVine
					
					vines.push(vine);
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
					level = new Level7;	
					
					init(stageLink);
				}
				
				player1.Update(e);
				
				playerBlockCollision();
				
				for (var i:int = 0; i < killboxes.length; i++) 
				{
					var killbox:KillBox = killboxes[i];
					
					if (player1.hitTestObject(killbox))
					{
						killbox.Activate(player1);
					}	
				}
				
				for (var i:int = 0; i < vines.length; i++) 
				{
					var vine:climbingVine = vines[i];
					
					if (player1.hitTestObject(vine))
					{
						player1.bCanClimb = true;
						i = vines.length;
					}
					else
					{
						player1.bCanClimb = false;
					}
				}
				
			}		
			
		}
		
		private function playerBlockCollision():void
		{
			
			playerHorizBlockCollision();
			
			/* block collision */
				
			player1.block = null;
			player1.crate = null;
				
			for (var i:int = 0; i < blocks.length; i++) 
			{
				var block:Block = blocks[i];
				
				if (player1.hitTestObject(block))
				{										
					if (player1.y + 53 - 30 <= block.y - block.height/2)
					{
						player1.block = block;
						
						return;
					}	
				}	
			}
			
		}
		
		private function playerHorizBlockCollision():void
		{
			for (var i:int = 0; i < blocks.length; i++) 
			{
				var block:Block = blocks[i];
				
				if (player1.hitTestObject(block))
				{						
					//Not on top of block
					if (player1.y + 53 - 30 > block.y - block.height/2)
					{
						trace("not on block");
						
						//block left edge further left than player right edge
						if (block.x - (block.width/2) + 1 <= player1.x + (player1.width/2) && (player1.x + (player1.width/2) < block.x))
						{	
							trace("cutting left");
							var j:int = player1.x + (player1.width / 2) - (block.x - (block.width / 2));
							
							trace(j);
							
							player1.x -= j;
							level.x += j;

						}
						else if (block.x + (block.width/2) - 1 >= player1.x - (player1.width/2) && (player1.x - (player1.width/2) > block.x))
						{
							trace("cutting right");
							
							var z:int = (block.x + (block.width / 2)) - (player1.x - (player1.width / 2));
							
							trace((block.x + (block.width / 2)));
							trace((player1.x - (player1.width / 2)));
							
							trace(z);
							
							player1.x += z;
							level.x -= z;

						}
					}
					
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