package  
{

	import flash.display.MovieClip;
	import flash.events.Event;
	
<<<<<<< HEAD
	public class PushBlock extends myObject 
	{
		
		private var accel:int = 0;
		private var speed:int = 0;
		private var weight:int = 2;
		public function PushBlock() 
		{
=======
	public class PushBlock extends myObject {
		public var main:Main = null;
		private var vY:int = 0;
		public function PushBlock() {
>>>>>>> origin/brian
			// constructor code
		}
		
		// Function called every frame to handle  ball movement & rotation.
		public function Update():void 
		{			
<<<<<<< HEAD
			speed += accel;	// Change speed based on acceleration (Frame rate dependent but should be fine for this project)
			
			//rotation += speed / 3; // Rotate ball based on speed of ball, 3 is a magic number to make rotation believable assuming no sliding motion
			
			x += speed / (10 + weight);	// Change position based off speed, weight may be adjusted to give slightly different feel
			
			accel = 1 * ( -speed / Math.abs(speed));	// Assuming no object hits ball at later point deceleration will be set due to friction.
			
			//Stops the ball at the edges of the screen.
	/*		if (x > stage.stageWidth)
			{
				speed = 0;
			}
			else if (x < 0)
			{
				speed = 0;
	*/	}
=======

			for (var i:int = 0; i < main.blocks.length; i++) 
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
		}
>>>>>>> origin/brian
		
		// Function called on player impact with ball
		public function roll(p:Player):void
		{
			var direction:int = x - p.x;
			
			direction = direction / Math.abs(direction); // Calculate which side of ball player is on
			
			if (direction > 0)
			{
				x = p.x + (p.width / 2);
			}
			else
			{
				x = p.x - (p.width / 2) - width;
			}
			
			p.maxVel = 2;
		}
	
	}
}
