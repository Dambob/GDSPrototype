package  
{
	/**
	 * ...
	 * @author 
	 */
	public class fallingBlock extends Block 
	{
		
		private var Counter:int = 0;
		
		public function fallingBlock() 
		{
			
		}
		
		public function Update():void
		{
			if (bStoodOn)
			{
				Counter++;
			}
			
			if (Counter >= 10)
			{
				x = -1000;
				Counter = 0;
				bStoodOn = false;
			}
		}
		
	}

}