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
	public class LevelThree extends Level 
	{
		
		private var level:Level3 = null;
		private var player1:Player =  null;
		private var blocks:Array = null;
		private var spawn:playerSpawn = null;
		
		private var stageLink:Stage = null;
		
		private var myCollisionList:CollisionList;
		
		public function LevelThree() 
		{
			
		}
		
		public function init(stageRef:Stage):void
		{
			
			level = new Level3;
			player1 =  new Player;
			blocks = new Array;
			spawn = new playerSpawn;
				
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
					level = new Level3;	
					
					init(stageLink);
				}
				
				player1.Update(e);
				
				
				playerBlockCollision();
				
			}		
			
		}
		
		private function playerBlockCollision():void
		{
			
			/* block collision */
				
			player1.block = null;
			player1.crate = null;
				
			for (var i:int = 0; i < blocks.length; i++) 
			{
				var block:Block = blocks[i];
				
				if (player1.hitTestObject(block))
				{
					
					if (player1.y <= block.y)
					{
						player1.block = block;
					
						
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