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
	public class LevelOne extends Level 
	{
		
		private var level:Level1 = null;
		private var player1:Player =  null;
		private var blocks:Array =  null;
		private var triggerTrap:TriggerFalling =  null;
		private var trap:fallingTrap =  null;
		private var spawn:playerSpawn =  null;
		private var rock2:rock =  null;	
		private var transition:transitionBlock = null;
		
		private var stageLink:Stage;
		
		private var myCollisionList:CollisionList;
		
		public function LevelOne() 
		{
			
		}
				
		public function init(stageRef:Stage):void 
		{					
			//Initialize variables here
			level = new Level1;
			player1 = new Player;
			blocks = new Array;
			triggerTrap = new TriggerFalling
			trap = new fallingTrap;
			spawn = new playerSpawn;
			rock2 = new rock;
			transition = new transitionBlock;
			
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
				else if (object is transitionBlock)
				{
					trace("Found transition block at " + i);
					transition = object as transitionBlock;
				}
				else if (object is Trigger)
				{
					trace("Found trigger at " + i);
					triggerTrap = object as TriggerFalling;
				}
				else if (object is fallingTrap)
				{
					trace("Found trap at " + i);
					trap = object as fallingTrap;		
					
				}
				else if (object is rock)
				{
					trace("Found rock at " + i);
					rock2 = object as rock;
				}
				
			}
			
			trap.Floor = blocks[0];
			triggerTrap.trap = trap;
				
			
			player1.spawn = spawn;
			
			player1.x = player1.spawn.x;
			player1.y = player1.spawn.y;
			
		}
		
		public function Update(e:Event):void
		{	
			
			//Different method of collision detection
			//Allows to us to see all objects colliding with the one we care about.
			
			//Object we are interested in
			
			var Collision:Event = new Event("COLLISION");
			
			myCollisionList = new CollisionList(triggerTrap);
			
			//items we care about
			myCollisionList.addItem(rock2);
			myCollisionList.addItem(player1);
			
			var collisions:Array = myCollisionList.checkCollisions();
			 
			if(collisions.length > 0) 
			{
				for (var i:int = 0; i < collisions.length; i++)
				{
					// tracing the name of the colliding object collisions[i].object1:
					trace(collisions[i].object1.name);
					stage.dispatchEvent(Collision);
				}
				trace("No More collisions");
			}
			
			
			
			if (player1 != null)
			{	
				
				//Immediately resets the level on death
				//Perhaps use a counter or button press to allow death animations etc. to continue
				if (player1.State == 3) 
				{					
					if (player1.currentAnim.currentFrame == player1.currentAnim.totalFrames - 1)
					{
						Restart();
					}
					
				}
				else
				{
					player1.Update(e);
					
					playerBlockCollision();
					
					rock2.Update();
					
					rockBlockCollision();
		
					triggerTrap.Update(player1, rock2);		
					
					if (player1.hitTestObject(rock2))
					{
						trace("hit rock");
						rock2.roll(player1);
					}
					
					if (transition != null)
					{
						if (player1.hitTestObject(transition))
						{
							bFinished = true;
						}
					}
				}
				
			}		
		}
		
		private function rockBlockCollision():void
		{
			for (var i:int = 0; i < blocks.length; i++) 
			{
				var block:Block = blocks[i];
				
				if (rock2.hitTestObject(block))
				{						
					//Not on top of block
					if (rock2.y + (rock2.height/2) > block.y - block.height/2)
					{
						trace("not on block");
						
						//block left edge further left than player right edge
						if (block.x - (block.width/2) + 1 <= rock2.x + (rock2.width/2) && (rock2.x + (rock2.width/2) < block.x))
						{	
							var j:int = rock2.x + (rock2.width / 2) - (block.x - (block.width / 2));
							
							rock2.speed *= -1;

						}
						else if (block.x + (block.width/2) - 1 >= rock2.x - (rock2.width/2) && (rock2.x - (rock2.width/2) > block.x))
						{
							var z:int = (block.x + (block.width / 2)) - (rock2.x - (rock2.width / 2));
						
							rock2.speed *= -1;
						}
					}
					
				}
			}
		}
		
		private function playerBlockCollision():void
		{
			
			if (player1.State == 1 || (player1.State == 2 && (player1.bLeft || player1.bRight) ) )
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
		
		public function Restart():void
		{
			trace("Restart");
			
			stageLink.removeChild(level);
					
			//Resets the level variable
			level = new Level1;
			
			init(stageLink);
		}
		
	}

}