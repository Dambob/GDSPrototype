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
	public class LevelFour extends Level 
	{
		private var level:Level4 = null;
		private var player1:Player =  null;
		private var blocks:Array = null;
		private var spawn:playerSpawn = null;
		private var vine:climbingVine = null;
		private var killboxes:Array = null;
		private var fallingBoxes:Array = null;
		
		private var stageLink:Stage = null;
		
		private var myCollisionList:CollisionList;
		
		public function LevelFour() 
		{
			
		}
		
		public function init(stageRef:Stage):void
		{
			
			level = new Level4;
			player1 =  new Player;
			blocks = new Array;
			spawn = new playerSpawn;
			killboxes = new Array;			
			vine = new climbingVine;
			fallingBoxes = new Array;
				
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
				else if (object is climbingVine)
				{
					trace("Found vine at " + i);

					vine = object as climbingVine;
				}
				else if (object is KillBox)
				{
					trace("Found killbox at " + i);
					var killbox:KillBox = object as KillBox
					
					killboxes.push(killbox);
				}
				
				if (object is movingBlock)
				{
					
					trace("Found falling block at " + i);
					
					var fallingBox:movingBlock = object as movingBlock
					
					fallingBoxes.push(fallingBox);
				}
				
			}	
			
			player1.spawn = spawn;
			
			player1.x = player1.spawn.x;
			player1.y = player1.spawn.y;
			
		}
		
		public function Update(e:Event):void
		{
			//
			if (player1 != null)
			{	
				//Immediately resets the level on death
				//Perhaps use a counter or button press to allow death animations etc. to continue
				if (player1.bDead) 
				{					
					stageLink.removeChild(level);
					
					//Resets the level variable
					level = new Level4;	
					
					init(stageLink);
				}
				
				player1.Update(e);
				
				//Algorithm for climbable objects
				if (player1.hitTestObject(vine))
				{
					player1.bCanClimb = true;
				}
				else
				{
					player1.bCanClimb = false;
				}
				
				//Algorithm for killboxes
				for (var i:int = 0; i < killboxes.length; i++) 
				{
					var killbox:KillBox = killboxes[i];
					
					if (player1.hitTestObject(killbox))
					{
						killbox.Activate(player1);
					}	
				}
				
				
				//Algorithm for falling platforms
				for (var i:int = 0; i < fallingBoxes.length; i++) 
				{
					var fallingBox:movingBlock = fallingBoxes[i];
					fallingBoxes.splice(i,1);
					
					if (player1.hitTestObject(fallingBox))
					{
						fallingBox.bStoodOn = true;
					}	
					
					fallingBox.Update();
					
					fallingBoxes.splice(i,0, fallingBox);
				}

				
				playerBlockCollision();
				
			}		
			
		}
		
		private function playerBlockCollision():void
		{
			
			if ( player1.State == 1 || (player1.State != 2 && player1.State != 4 && player1.State != 5))
			{
				playerHorizBlockCollision();
			}
			
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