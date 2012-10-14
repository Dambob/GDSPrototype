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
		
	
    public var PushBlock1:PushBlock = null; // strongly typed
		
		public var level:Level = null;
		public var player1:Player =  null;
		public var blocks:Array =  null;
		public var triggers:Array =  null;
		public var traps:Array =  null;
		public var spawns:Array =  null;
		public var rock2:rock =  null;
		public var ClimbingVine1:ClimbingVine =  null;
		
		public var myCollisionList:CollisionList;
		
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
			
			//Initialize variables here
			level = new Level;
			player1 = new Player;
			blocks = new Array;
			triggers = new Array;
			traps = new Array;
			spawns = new Array;
			rock2 = new rock;
			PushBlock1 = new PushBlock;
			
			stage.addChild(level);
			
			for (var i:int = 0; i < level.numChildren; i++)
			{
				var object:Object = level.getChildAt(i);
				trace(level.numChildren + " children in level");
				trace(object.name);
				if (object is Player)
				{
					trace("Found player at " + i);
					player1 = object as Player;
					player1.main = this;
					player1.level = level;
				}
				else if (object is Block)
				{
					trace("Found block at " + i);
					var block:Block = object as Block;
					
					blocks.push(block);
					
				}
				else if (object is playerSpawn)
				{
					trace("Found player spawn at " + i);

					var spawn:playerSpawn = object as playerSpawn;
					
					spawns.push(spawn);
				}
				else if (object is Trigger)
				{
					trace("Found trigger at " + i);
					var trigger:Trigger = object as Trigger;
					
					
					triggers.push(trigger);
				}
				else if (object is fallingTrap)
				{
					trace("Found trap at " + i);
					var trap:fallingTrap = object as fallingTrap;
					
					//traps.push(trap);
					trap.Floor = blocks[0];
					
					triggers[0].trap = trap;
				}
				else if (object is rock)
				{
					trace("Found trap at " + i);
					rock2 = object as rock;
					
				}
				else if (object is PushBlock) {
					trace("Found block at " + i);
				PushBlock1 = object as PushBlock;
				PushBlock1.main = this;
				}
				else if (object is ClimbingVine) {
					trace("Found Vine at " + i);
				ClimbingVine1 = object as ClimbingVine;
				}
			}
				
			
			player1.spawn = spawns[0];
			
			player1.x = player1.spawn.x;
			player1.y = player1.spawn.y;
			
			
			stage.addEventListener(Event.ENTER_FRAME, Update);
			
		}
		
		public function Update(e:Event):void
		{	
			
			//Different method of collision detection
			//Allows to us to see all objects colliding with the one we care about.
			
			//Object we are interested in
			myCollisionList = new CollisionList(triggers[0]);
			
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
				}
				trace("No More collisions");
			}
			
			
			
			if (player1 != null)
			{	
				//Immediately resets the level on death
				//Perhaps use a counter or button press to allow death animations etc. to continue
				if (player1.bDead) 
				{					
					stage.removeChild(level);
					
					//Resets the level variable
					level = new Level;
					
					init();
				}
				
				player1.Update(e);
				
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
				
				rock2.Update();
				PushBlock1.Update();
				for (i = 0; i < triggers.length; i++)
				{
					var trigger:Trigger = triggers[i];
					
					trigger.Update(player1, rock2);			
				}
				
				if (player1.hitTestObject(rock2))
				{
					trace("hit rock");
					rock2.roll(player1);
				}
				
				if (player1.hitTestObject(PushBlock1 ))
				{
					trace("hit block");
					PushBlock1.roll(player1);
				}
			}		
					
		}
		
	}
	
}