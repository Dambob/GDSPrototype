package  
{
	/**
	 * ...
	 * @author 
	 */
	public class TriggerKill extends Trigger 
	{
		
		public function TriggerKill() 
		{
			
		}
		
		public function Activate(p:Player):void
		{
			p.bDead = true;
		}
		
	}

}