package  
{
	/**
	 * ...
	 * @author 
	 */
	public class Trigger extends myObject 
	{
		public var trap:fallingTrap = null;
		public var bRotate:Boolean = false;
		public var bExpired:Boolean = false;
		
		public function Trigger() 
		{
			
		}
		
		public function Update(p:Player, r:rock):void
		{	
			if (trap != null && !bExpired)
			{				
				//Messy but with proper use of custom events can be cut down
				if (hitTestObject(p) || hitTestObject(r))
				{				
					trap.bFalling = true;
				}
				
				trap.Update();
				
				if (trap.bFalling)
				{
					trap.Spring(p);
				}
				
				if (trap.bTrapDone)
				{
					
					trap.bFalling = false;
					
					bExpired = true;
					
					bRotate = true;
				}
			}
/*			
			if (bRotate && !b.hitTestObject(b2))
			{
				b.rotation -= 3;
				
			}
			else if (b.hitTestObject(b2))
			{
				bRotate = false;
			}
*/
			
		}
		
		
		
		
	}

}