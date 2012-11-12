package  
{
	/**
	 * ...
	 * @author 
	 */
	public class ConveyorBelt extends Block 
	{
		
		public var power:int = 10;
		
		public function conveyorBelt() 
		{
			
		}
		
		public function Update(p:Player):void
		{
			if (bStoodOn)
			{
				p.MoveX(power);
			}
			
		}
		
		
		
	}

}