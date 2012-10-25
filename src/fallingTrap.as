package  
{
	/**
	 * ...
	 * @author 
	 */
	public class fallingTrap extends Trap 
	{
		
		public var bFalling:Boolean = false;
		public var Floor:Block = null;
		private var speed:int = 0;
		private var accel:int = 2;

		public function fallingTrap() 
		{
			
		}
		
		public function Update():void
		{			
			if (bFalling)
			{
				if (hitTestObject(Floor))
				{
					bTrapDone = true;
					bFalling = false;
				}
				else
				{
					speed += accel;
				}
			}
			
			y += speed;
		}
		
		override public function Spring(p:Player):void
		{			
			super.Spring(p);
		}
		
	}

}