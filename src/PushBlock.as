package  {

	import flash.display.MovieClip;
		import flash.events.Event;
	
	public class PushBlock extends myObject {
		public var main:Main = null;
		private var vY:int = 0;
		public function PushBlock() {
			// constructor code
		}
				// Function called every frame to handle  ball movement & rotation.
		public function Update():void 
		{			

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
