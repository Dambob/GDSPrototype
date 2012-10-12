package  {

	import flash.display.MovieClip;
		import flash.events.Event;
	
	public class PushBlock extends myObject {
		
		private var accel:int = 0;
		private var speed:int = 0;
		private var weight:int = 2;
		public function PushBlock() {
			// constructor code
		}
				// Function called every frame to handle  ball movement & rotation.
		public function Update():void 
		{			
			speed += accel;	// Change speed based on acceleration (Frame rate dependent but should be fine for this project)
			//rotation += speed / 3; // Rotate ball based on speed of ball, 3 is a magic number to make rotation believable assuming no sliding motion
			x += speed / (10 + weight);	// Change position based off speed, weight may be adjusted to give slightly different feel
			accel = 1 * ( -speed / Math.abs(speed));	// Assuming no object hits ball at later point deceleration will be set due to friction.
			
			//Stops the ball at the edges of the screen.
			if (x > stage.stageWidth)
			{
				speed = 0;
			}
			else if (x < 0)
			{
				speed = 0;
			}
		}
		
		// Function called on player impact with ball
		public function roll(p:Player):void
		{
			var direction:int = x-p.x;
			direction = direction / Math.abs(direction); // Calculate which side of ball player is on
			if (direction > 0)
			x = p.x + (p.width/2);
			else
			x = p.x - (p.width / 2) - width;
			p.maxVel = 2;
		}
	}
	
}
