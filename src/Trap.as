package  
{
	/**
	 * ...
	 * @author 
	 */
	public class Trap extends myObject 
	{
		
		public var bTrapDone:Boolean = false;
		
		public function Trap() 
		{
			
		}
		
		public function Spring(p:Player):void
		{
			if (hitTestObject(p))
			{
				p.bDead = true;
			}
		}
		
	}

}