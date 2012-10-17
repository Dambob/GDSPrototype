package  
{

	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class PushBlock extends myObject 
	{
		
		private var accel:int = 0;
		private var speed:int = 0;
		private var weight:int = 3;
		private var vY:int = 0;
		
		public var block:Block = null;
		public var crate:Crate = null;
		public var bOnPlatform:Boolean = false;
		public var velocity:int = 0;
		
		public function PushBlock() 
		{
			// constructor code
		}
		
		// Function called every frame to handle  ball movement & rotation.
		public function Update(p:Player):void 
		{			
			speed += accel;	// Change speed based on acceleration (Frame rate dependent but should be fine for this project)
	
			x += speed / (10 + weight);	// Change position based off speed, weight may be adjusted to give slightly different feel
			
			accel = weight * ( -speed / Math.abs(speed) );	// Assuming no object hits ball at later point deceleration will be set due to friction.

			if ( (p.y + 60 > y) && (p.y - 30 < y))
			{
				var direction:int = x - p.x;
				
				direction = direction / Math.abs(direction); // Calculate which side of ball player is on
				
				if (direction > 0)
				{
					//player at left
					if ( (p.x + (p.width / 2)) > (x - width / 2) )
					{
						trace("Player intersecting left");
						
						x += (p.x + (p.width / 2)) - (x - width / 2);
					}
				}
				else
				{
					//player at right
					if ( (p.x - (p.width / 2)) < (x + width / 2) )
					{
						x -= (p.x + (p.width / 2)) - (x - width / 2);
					}
				}
			}
			
			//gravity
			//similar to player
			
			if (block != null)
			{
				if (block.y - (block.height/2) >= y)
				{
					
					//Play landing anim
					//playAnim(landingAnim);
					
					y = block.y - height / 2 - block.height / 2 + 1;
					
					velocity = 0;
				}
			}
			else if (crate != null)
			{
				if (crate.y - (crate.height/2) >= y)
				{
					
					//Play landing anim
					//playAnim(landingAnim);
					
					
					y = crate.y - height / 2 - crate.height / 2 + 1;
					
					
					velocity = 0;
					bOnPlatform = true;
					
				}
			}
			else	//in air
			{
				bOnPlatform = false;
				
				y 	-= velocity;
				
				velocity--;				
				
			}
			
		}

		//Some function
		public function collisionOrSomething():void
		{
		/*	for (var i:int = 0; i < main.blocks.length; i++) 
			{
				var block:Block = main.blocks[i];
				
				if (hitTestObject(block))
				{
					
					if (y <= block.y)
					{
						vY = 0;
						break;
					}
				}
				else
				{
					vY++;
				}
				
			}
				
				y += vY;
				
		*/
		}
		
		// Function called on player impact with ball
		public function roll(p:Player):void
		{
			var direction:int = x - p.x;
			
			direction = direction / Math.abs(direction); // Calculate which side of ball player is on
			
			accel += (10 + p.maxVel) * direction ;
			
			
			
			p.maxVel = 2;
		}
	}
	
}
