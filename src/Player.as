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
		
		////////////////////Stick a move x move y function in here!!!!!!!!
		
		
		
		public var main:Main = null;
		
		public var State:int = 0;
		
		public var level:baseFlashLevel = null;
		
		private var bUp:Boolean = false;
		public var bLeft:Boolean = false;
		public var bRight:Boolean = false;
		public var bClimb:Boolean = false;
		private var bToggle:Boolean = false;
		public var maxVel:int = 5;
		public var bJumping:Boolean = false;
		private var JumpCounter:int = 0;
		public var bFalling:Boolean = false;
		public var block:Block = null;
		public var crate:Crate = null;
		
		public var spawn:playerSpawn = null;
		public var bDead:Boolean = false;
		
		public var currentAnim:MovieClip = null;
		
		private var idleAnim:MovieClip = new IdleAnim();
		private var runAnim:MovieClip = new RunAnim();
		private var jumpAnim:MovieClip = new JumpAnim();
		public var deathAnim:MovieClip = new DeathAnim();
		private var climbAnim:MovieClip = new ClimbAnim();
		
		private var animScale:int = 1;
		
		public var bCanClimb:Boolean = false;
		public var bClimbDown:Boolean = false;
		
	
		private var velocity:int = 0;
		public var bOnPlatform:Boolean = false;
		
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
			if (bClimb && bCanClimb && !bClimbDown)  
			{
				State = 4;				
			}
			else if (bClimbDown && bCanClimb && !bClimb) 
			{
				State = 5;				
			}
			else if (bDead)
			{
				State = 3;
			}			
			else if ( (bUp && bOnPlatform) || bJumping)
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
					if (currentAnim != idleAnim)
					{
						playAnim(idleAnim);
					}
					break;
					
				case 1: ///moving
					if (currentAnim != runAnim)
					{
						playAnim(runAnim);
					}
					
					Moving();
					break;
					
				case 2: //jumping
				
					if (currentAnim != jumpAnim)
					{
						playAnim(jumpAnim);
					}
					
					Jump();
					
					Moving();
					break;
					
				case 3: //dead
					playAnim(deathAnim);
					
					break;
				case 4: //climbing
					
					if (currentAnim != climbAnim)
					{
						playAnim(climbAnim);
					}
					
					if (bCanClimb)
					{
						velocity = 5;
						bJumping = true;
					}
					else
					{
						velocity = 0;
						bJumping = true;
						bClimb = false;
					}
					
					break;
				case 5: //climbing down
					
					if (currentAnim != climbAnim)
					{
						playAnim(climbAnim);
					}
					
					if (bCanClimb)
					{
						velocity = -5;
						bJumping = true;
					}
					else
					{
						velocity = 0;
						bJumping = true;
						bClimbDown = false;
					}
					
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
			
			if (State != 4 && State != 5)
			{
				if (block != null)
				{
					if (block.y - (block.height/2) >= y)
					{
						//Play landing anim
						//playAnim(landingAnim);
						
						var j:int = block.y - height / 2 - block.height / 2 + 1;
						
						velocity = y - j;
						
						y -= velocity;
						level.y += velocity;
						
						
						velocity = 0;
						bOnPlatform = true;
					}
				}
				else if (crate != null)
				{
					if (crate.y - (crate.height/2) >= y)
					{
						
						//Play landing anim
						//playAnim(landingAnim);
						
						var j:int = crate.y - height / 2 - crate.height / 2 + 1;
						
						velocity = y - j;
						
						y -= velocity;
						level.y += velocity;
						
						
						velocity = 0;
						bOnPlatform = true;
						
					}
				}
				else	//in air
				{
					bOnPlatform = false;
					
					if (velocity < 0)
					{
						bJumping = false;
						bFalling = true;
						
						//play falling anim
						//playAnim(fallAnim);
					}
					else if (velocity > 0)
					{
						bJumping = true;
						bFalling = false;
					}
					else
					{
						bJumping = false;
						bFalling = false;
						
					}
					
					y 	-= velocity;
					level.y += velocity;
					
					velocity--;				
					
				}
			}
			else if (State == 4 || State == 5)
			{
				y -= velocity;
				level.y += velocity;
			}
			
			if (velocity > 15)
			{
				velocity = 15;
			}
			else if (velocity < -15)
			{
				velocity = -15;
			}
			
			
			//Reverses the animation on the X if appropriate
			currentAnim.scaleX = animScale;
			
		}
		
		public function Moving():void
		{
			//No horizontal velocity but can be added in easily.
			if (bRight)
			{
				x += maxVel;
				
				//Apply inverse to level for scrolling 
				level.x -= maxVel;
				
				animScale = 1;
			}
			else if (bLeft)
			{
				x -= maxVel;
				
				level.x += maxVel;
				
				animScale = -1;
			}
			
			maxVel = 5;
						
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
		
		public function Respawn():void
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
			if (!bJumping && bOnPlatform)
			{
				velocity = 15;
			}			
		}
		
		private function onKeyDown(event:KeyboardEvent):void
		{
			if (event.keyCode == 32)
			{
				bUp = true;				
			}
			else if (event.keyCode == 87)
			{
				bClimb = true;
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
			else if (event.keyCode == 75)			//Suicide
			{
				bDead = true;
			}
			else if (event.keyCode == 83)
			{
				bClimbDown = true;
			}
		}
		
		private function onKeyUp(event:KeyboardEvent):void
		{
			if (event.keyCode == 32)
			{
				bUp = false;
			}
			else if (event.keyCode == 87)
			{
					bClimb = false;
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
				bToggle = false;
			}
			else if (event.keyCode == 83)
			{
				bClimbDown = false;
			}
		}
		
		
		
	}

}