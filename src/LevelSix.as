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
	public class LevelSix extends Level 
	{
		private var level:Level6 = null;
		private var player1:Player =  null;
		private var blocks:Array = null;
		private var spawn:playerSpawn = null;
		private var killboxes:Array = null;
		private var vines:Array = null;
		private var crates:Array = null;
		
		private var stageLink:Stage = null;
		
		private var myCollisionList:CollisionList;
		
		public function LevelSix() 
		{
			
		}
		
		public function init(stageRef:Stage):void
		{
			
			level = new Level6;
			player1 =  new Player;
			blocks = new Array;
			spawn = new playerSpawn;
			killboxes = new Array;
			vines = new Array;
			crates = new Array;
				
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
				else if (object is Crate)
				{
					trace("Found crate at " + i);

					var crate:Crate = object as Crate
					
					crates.push(crate);
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
					level = new Level6;	
					
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
				
				for (var i:int = 0; i < crates.length; i++)
				{
					//crate colliding with platforms
					
					var crate:Crate = crates[i];
										
					for (var j:int = 0; j < blocks.length; j++) 
					{
						var block:Block = blocks[j];
						
						if (crate.hitTestObject(block))
						{
							
							if (crate.y <= block.y)
							{
								crate.block = block;
														
								//Breaks out of for loop
								j = blocks.length - 1;
								
							}
						}
						else
						{
							crate.block = null;
						}	
						
					}
						
/*					for (var j:int = 0; j < crates.length; j++) 
					{
						if (j != i)
						{
							var crate1:Crate = crates[j];
							
							if (crate.hitTestObject(crate1))
							{
								
								if (crate.y <= crate1.y)
								{
									crate.crate = crate1;
															
									//Breaks out of for loop
									j = crate1.length - 1;
									
								}
							}
							else
							{
								crate.crate1 = null;
							}	
						}
						
					}
*/
					
					if (player1.hitTestObject(crate))
					{
						
						var playerFeet:int = player1.y + (player1.height / 2);
						var playerHead:int = player1.y - (player1.height / 2);
						
						var crateTop:int = crate.y - (crate.height / 2);
						var crateBottom:int = crate.y + (crate.height / 2);
						
						if ( (playerHead < crateTop) && (playerFeet > crateBottom) )
						{
							trace("pushing");
							crate.roll(player1);
						}
	/*					else if (playerFeet < crateBottom)
						{
							trace("above");
							if ( player1.block == null )
							{
								trace("Player on block!");
								player1.block = crate as Block;
							}
						}
						
	*/				
					}
					
					crate.Update(player1);
					
					crateBlockCollision(crate);
				}
				
			}		
			
		}
		
		private function crateBlockCollision(c:Crate):void
		{
			for (var i:int = 0; i < blocks.length; i++) 
			{
				var block:Block = blocks[i];
				
				if (c.hitTestObject(block))
				{						
					//Not on top of block
					if (c.y + (c.height/2) > block.y - block.height/2)
					{
						trace("not on block");
						
						//block left edge further left than player right edge
						if (block.x - (block.width/2) + 1 <= c.x + (c.width/2) && (c.x + (c.width/2) < block.x))
						{	
							var j:int = c.x + (c.width / 2) - (block.x - (block.width / 2));
							
							c.speed *= -1;

						}
						else if (block.x + (block.width/2) - 1 >= c.x - (c.width/2) && (c.x - (c.width/2) > block.x))
						{
							var z:int = (block.x + (block.width / 2)) - (c.x - (c.width / 2));
						
							c.speed *= -1;
						}
					}
					
				}
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
			
			//if player isn't on a static block, check to see if he's on a moveable one
			for (var i:int = 0; i < crates.length; i++)
			{
				var crate:Crate = crates[i];
				
				if (player1.hitTestObject(crate))
				{

					if (player1.y + 53 - 30 <= crate.y - crate.height/2)
					{
						player1.crate = crate;
						
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