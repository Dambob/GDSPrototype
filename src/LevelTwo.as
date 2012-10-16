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
		private var crates:Array = null;
		
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

					vine = object as climbingVine;
				}
				else if (object is Crate)
				{
					trace("Found crate at " + i);
					var crate:Crate = object as Crate;
					
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
					level = new Level2;	
					
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
				
				if (player1.hitTestObject(vine))
				{
					trace("CAN CLIMB");
					player1.bCanClimb = true;
				}
				else
				{
					player1.bCanClimb = false;
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
								crate.block1 = block;
														
								//Breaks out of for loop
								j = blocks.length - 1;
								
							}
						}
						else
						{
							crate.block1 = null;
						}	
					}
					
					
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
					
					
					crate.Update();
				}

			}		
			
		}
		
		private function playerBlockCollision():void
		{
			
			/* block collision */
				
			player1.block = null;
				
			for (var i:int = 0; i < blocks.length; i++) 
			{
				var block:Block = blocks[i];
				
				if (player1.hitTestObject(block))
				{
					
					if (player1.y <= block.y)
					{
						player1.block = block;
												
						//Breaks out of for loop
						//i = blocks.length - 1;
						trace("On static block");
						
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
					if (player1.y + player1.height/2 < crate.y - crate.height/2 + 10)
					{
						player1.block = crate as Block;
												
						//Breaks out of for loop
						i = crates.length - 1;
						
						trace("on crate");
						
						return;
						
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