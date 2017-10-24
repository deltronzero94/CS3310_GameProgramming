public class Player
{
  //Declared Variable Members
  private PImage player;
  private boolean isIdle, isAttacking, isMoving; //
  private boolean lastLeft; //Keeps track of last key released (true if last key released was left )
  private boolean left,right, up, down; //Track currentMovement
  private int x , y; //Player Movement for X and Y plane
  private float px; //Adjust player position x when screen moves
  private float py; //Adjust player position y when screen moves
  private int dim; //How space they are in the jpeg file
  private int w; //width of the sprite
  private int h; //height of the sprite
  
  private int lastAttackTime;
  private int previousAttackFrame;
  private int currentAttackFrame;
  private int activeFrame;
  
  //Default Constructor
  public Player()
  {
    x = 100;
    y = 100;
    isIdle = true;
    isAttacking = false;
    isMoving = false;
    lastLeft = false;
    px = width;
    py =  height*1.35; 
    activeFrame = -1;
  }
  
  public Player(int x, int y)
  {
    this.x = x;
    this.y = y;
    isIdle = true;
    isAttacking = false;
    isMoving = false;
    lastLeft = false;
    px = width;
    py =  height*1.35; 
    activeFrame = -1;
  }
  
  //****************************
  //Public Methods/Functions
  //****************************
  public void isPlayerIdle()
  { 
    //if(!isActiveFrame)
      //{
      if (isIdle && !isAttacking) //Player is Idle
      {    
        drawPlayerIdle();     
      }
      else if (isMoving && !isAttacking) //Player is Moving
      {
        drawPlayerMoving();
      }
      else if(isAttacking ) //Player is Attacking
      {
        drawPlayerAttacking();
      }
    //}
  }
  
  public boolean isKeyPressed()
  {
    if(left || right || up || down)
    {
      return true;
    }
    else
    {
      return false;
    }
  }
  
  public boolean isKeyReleased()
  {
    if(!(left || right || up || down))
    {
      return true;
    }
    else
    {
      return false;
    }
  }
  
  public PImage getCurrentSprite()
  {
    return player.get(currentFrameX(), 0, w, h);
  }
  
  public void playerMovement()
  {
    if(isMoving)
    {
      if(left)
      {
        x -= 14;
      }
      if(right)
      {
        x += 14;
      }
      if(up)
      {
        y -= 8;
      }
      if(down)
      {
        y += 8;
        if (y > 350) y = 350;
      }
    }
    
     int a = currentFrameX();
     int b = 0;
     PImage sprite = p.getPImage().get(a, b, w,h);
     image(sprite, width + x - px, height*1.35 + y); 
  }
  
  public float currentPlayerPositionX()
  {
    return width + x - px;
  }
  
   public float currentPlayerPositionY()
  {
    return py + y;
  }
  
  public void addPX(int x)
  {
    px += x;
  } 
  
  public void addX(int x)
  {
    this.x += x;
  }
  
  public void addY(int y)
  {
    this.y += y;
  }
  
  //***********
  //Setters
  //***********
  public void setLeft(boolean left)
  {
    this.left = left;
  }
  
  public void setRight(boolean right)
  {
    this.right = right;
  }
  
  public void setUp(boolean up)
  {
    this.up = up;
  }
  
  public void setDown(boolean down)
  {
    this.down = down;
  }
  
  public void setLastLeft(boolean lastLeft)
  {
    this.lastLeft = lastLeft;
  }
  
  public void setIsIdle(boolean isIdle)
  {
    this.isIdle = isIdle;
  }
  
  public void setIsMoving(boolean isMoving)
  {
    this.isMoving = isMoving;
  }
  
  public void setIsAttacking(boolean isAttacking)
  {
    this.isAttacking = isAttacking;
  }
  
  public void setY(int y)
  {
    this.y = y;
  }
  
  public void setX(int x)
  {
    this.x = x;
  }
  
  
  //**********
  //Getters
  //**********
  public PImage getPImage()
  {
    return this.player;
  }
  
  public int getDimension()
  {
    return this.dim;
  }
  
  public int getWidth()
  {
    return this.w;
  }
  
  public int getHeight()
  {
    return this.h;
  }
  
  public float getPX()
  {
    return this.px;
  }
  
  public float getPY()
  {
    return this.py;
  }
  
  public int getX()
  {
    return this.x;
  }
  
  public int getY()
  {
    return this.y;
  }
  
  public boolean getLeft()
  {
    return this.left;
  }
  
  public int getLastAttackTime()
  {
    return this.lastAttackTime;
  }
  
  public int getCurrentAttackFrame()
  {
    return this.currentAttackFrame;
  }
  
  public int getPreviousAttackFrame()
  {
    return this.previousAttackFrame;
  }
  
  public float getTimeBetweenAttack()
  {
    return (float)(millis() - this.lastAttackTime)/1000;
  }
  
  //********************
  //Private Methods
  //********************
  private int currentFrameX()
  {
    return frameCount % dim * w;
  }
  
  private void drawPlayerIdle()
  {
    if (lastLeft && !right)
      {
        player = loadImage("idle3.png");
        dim = 12;
        w = player.width/dim;
        h = player.height;
      }
      else
      {
        player = loadImage("idle3_R.png");
        dim = 12;
        w = player.width/dim;
        h = player.height;
      }
  }
  
  private void drawPlayerMoving()
  {
    if (!left)
      {
        if ((up && lastLeft || down &&lastLeft) && !right )
        {   
          player = loadImage("walk.png");
          dim = 24;
          w = player.width/dim;
          h = player.height;
          
        }
        else
        {
          player = loadImage("walk_right.png");
          dim = 24;
          w = player.width/dim;
          h = player.height;
        }
      }
      else
      {
        player = loadImage("walk.png");
        dim = 24;
        w = player.width/dim;
        h = player.height;
      }
  }
  
  private void drawPlayerAttacking()
  {
    print("CurrentFrame: " + activeFrame +"\n" );
    if (activeFrame != -1)
    {
      if(frameCount - activeFrame >= 0.25)
      {
        activeFrame = -1;
        print("True\n");
      }
    }
    else
    {
      if(!lastLeft && !left || right)
      {
        
        player = loadImage("punch_animation_v2_right.png");
        dim = 14;
        w = player.width/dim;
        h = player.height;
      }
      else
      {
        if((currentAttackFrame == 0 && previousAttackFrame ==0) ||
            (currentAttackFrame == 1 && previousAttackFrame ==0)) //Punch 1 & 2
        {
          if (activeFrame == -1)
          {
            activeFrame = frameCount;
          }
            
          lastAttackTime = millis(); //Timer for delay
          player = loadImage("punch1_f6_left_v2.png");
          dim = 6;
          w = player.width/dim;
          h = player.height;
   
          
          //MIGHT NEED TO DELETE
          if(currentAttackFrame == 1)
          {
            previousAttackFrame++;
            activeFrame = frameCount;
          }
          currentAttackFrame++;
        }
        else if ((currentAttackFrame == 2 && previousAttackFrame ==1)) //Punch 3 & punch4
        {
          activeFrame = frameCount;
          player = loadImage("punch3_f6_left_V2.png");
          dim = 8;
          w = player.width/dim;
          h = player.height;
          previousAttackFrame++;
          currentAttackFrame++;
          frameCount+=16;
        }
        else //Resets Attack Animation if idle
        {            
          if (getTimeBetweenAttack() > .05) 
          {
            this.lastAttackTime = millis();
            currentAttackFrame = 0;
            previousAttackFrame = 0;
            activeFrame = -1;
          }
        } 
        
      }
    }
  }
  
} //End of Player Class