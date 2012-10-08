package  

{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	/**
	 * ...
	 * @author 
	 */
	public class Player extends myObject 
	{
		
		private var State:int = 0;
		
		public var level:Level = null;
		
		private var bUp:Boolean = false;
		private var bLeft:Boolean = false;
		private var bRight:Boolean = false;
		
		private var bToggle:Boolean = false;
		
		public var bJumping:Boolean = false;
		private var JumpCounter:int = 0;
		private var bFalling:Boolean = false;
		public var block:Block = null;
		
		public var spawn:playerSpawn = null;
		public var bDead:Boolean = false;
		
		private var currentAnim:MovieClip = null;
		private var idleAnim:MovieClip = new IdleAnim();
		private var runAnim:MovieClip = new RunAnim();
		private var jumpAnim:MovieClip = new IdleAnim();
		private var deathAnim:MovieClip = new IdleAnim();
		private var animScale:int = 1;
	
		private var velocity:int = 0;
		
		public function Player() 
		{
			
		}
		
		public function Update(e:Event):void
		{
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			
			
			UpdateState();
			
		}
		
		
		private function UpdateState():void
		{
			
			if (bDead)
			{
				State = 3;
			}			
			else if ((bUp && !bFalling) || bJumping)
			{
				State = 2;
			}
			else if (bLeft)
			{
				State = 1;
			}
			else if (bRight)
			{
				State = 1;
			}
			else
			{
				State = 0;
			}
			
			switch(State)
			{
				case 0: ///idle
					playAnim(idleAnim);
					break;
					
				case 1: ///moving
					playAnim(runAnim);
					Moving();
					break;
					
				case 2: //jumping
					playAnim(jumpAnim);
					
					Jump();
					
					Moving();
					break;
					
				case 3: //dead
					playAnim(deathAnim);
					
					//Currently redundant as level is recreated on death
					//Keep as it may be useful with larger levels
					Respawn();
					break;				
			}
						
			//Gravity
			// Brian B - A lot of the below code is redundant but some parts still use
			// the bFalling and bJumping variables so kept code in for that just now.
			
			/* Damien
			 * 
			 * Tried to condense some of this code, removing what I could.
			 * 
			 */
			
			velocity--;
			
			if (block == null || bJumping)
			{
				y -= velocity;
			}
			else if (block != null)
			{				
				bFalling = false;
				velocity = 0;
				
				y = block.y - height / 2 - block.height / 2;
			}
			
			//Reverses the animation on the X if appropriate
			currentAnim.scaleX = animScale;
			
		}
		
		public function Moving():void
		{
			//No horizontal velocity but can be added in easily.
			if (bRight)
			{
				x += 5;
				
				//Apply inverse to level for scrolling 
				level.x -= 5;
				
				animScale = 1;
			}
			else if (bLeft)
			{
				x -= 5;
				
				level.x += 5;
				
				animScale = -1;
			}
						
		}
		
		public function playAnim(newAnim:MovieClip):void
		{
			// check to see if the anim we want to play is different from the current one
			if(currentAnim != newAnim)
			{
				// remove the previous anim from the stage (if it is set to something)
				if (currentAnim != null)
				{
					removeChild(currentAnim);
				}

				// set the current anim to be the new one
				currentAnim = newAnim;

				// add the anim movie clip back to the stage
				addChild(currentAnim);
			}
		}
		
		private function Respawn():void
		{
			trace ("Respawning player");
			if (spawn != null)
			{
				x = spawn.x;
				y = spawn.y;
			}
			
			bDead = false;
			State = 0;
			
		}
		
		private function Jump():void
		{
			if (!bJumping)
			{
				bJumping = true;
				velocity = 15;
			}
			
			if (velocity <= 0)
			{
				bJumping = false;
				bFalling = true;
			}

		}
		
		private function onKeyDown(event:KeyboardEvent):void
		{
			if (event.keyCode == 87)
			{
				bUp = true;				
			}
			else if (event.keyCode == 65)
			{
				bLeft = true;
			}
			else if (event.keyCode == 68)
			{
				bRight = true;
			}
			else if (event.keyCode == 69)
			{
				bToggle = true;
			}
		}
		
		private function onKeyUp(event:KeyboardEvent):void
		{
			if (event.keyCode == 87)
			{
				bUp = false;
			}
			else if (event.keyCode == 65)
			{
				bLeft = false;
			}
			else if (event.keyCode == 68)
			{
				bRight = false;
			}
			else if (event.keyCode == 69)
			{
				bToggle = true;
			}
		}
		
		
		
	}

}