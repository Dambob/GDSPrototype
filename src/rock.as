package  
{
	import flash.events.Event;
	/**
	 * ...
	 * @author 
	 */
	public class rock extends myObject 
	{
		
		private var accel:int = 0;
		private var speed:int = 0;
		private var weight:int = 2;
		public function rock() 
		{
			
		}
		
		// Function called every frame to handle  ball movement & rotation.
		public function Update():void 
		{			
			speed += accel;	// Change speed based on acceleration (Frame rate dependent but should be fine for this project)
			rotation += speed / 3; // Rotate ball based on speed of ball, 3 is a magic number to make rotation believable assuming no sliding motion
			x += speed / (10 + weight);	// Change position based off speed, weight may be adjusted to give slightly different feel
			accel = 1 * ( -speed / Math.abs(speed));	// Assuming no object hits ball at later point deceleration will be set due to friction.
			
		}
		
		// Function called on player impact with ball
		public function roll(p:Player):void
		{
			var direction:int = x-p.x;
			direction = direction / Math.abs(direction); // Calculate which side of ball player is on
			accel += 8 * direction;	// Apply an acceleration away from the player			
		}
		
	}

}