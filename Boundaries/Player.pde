public class Player
{
  //Declared Variable Members
  private PImage player; //Player avatar
  private boolean isIdle, isAttacking, isMoving; //Keeps of current state of the player
  private boolean lastLeft; //Keeps track of last key released (true if last key released was left )
  private boolean left,right, up, down; //Track currentMovement
  private int x , y; //Player Movement for X and Y plane
  private float px; //Adjust player position x when screen moves
  private float py; //Adjust player position y when screen moves
  private int dim; //How space they are in the jpeg file
  private int w; //width of the sprite
  private int h; //height of the sprite
  private int lastAttackTime; //Tracks time between attacks for combos
  private int currentAttack; //Current Attack Being Animated (Punch 1, Punch 2, and Kick)
  private int activeFrame; //Keeps Track of Active Attack Frames (helps attack animation finish)
  private String filename;
  
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
    py = height * 1.35; 
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
    py = height*1.35; 
    activeFrame = -1;
  }
  
  //****************************
  //Public Methods/Functions
  //****************************
  public void isPlayerIdle()
  {    
    if (player == null) //initialize image if there is no image
    {
      drawPlayerIdle(); 
    }
    
    if(!isAttackFrameActive()) //If player is not attacking
    {
      if (isIdle && !isAttacking) //Player is Idle
      {    
        drawPlayerIdle();     
      }
      else if (isMoving && !isAttacking && ((filename != "walk_right.png" && right && !left) || (filename != "walk.png" && left && !right))) //Player is Moving
      {
        //print(frameRate + "\n");
        drawPlayerMoving();
      }
      else if(isAttacking) //Player is Attacking
      {
        drawPlayerAttacking();
      }
      
      playerMovement();
    }
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
    if(isMoving && !isAttackFrameActive())
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
        if (y > 350) y = 350; //Prevent player from going too far bottom
      }
    }
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
  
  public int getCurrentAttack()
  {
    return this.currentAttack;
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
  
  private boolean isAttackFrameActive()
  {
    if (activeFrame != -1)
    {
      if ((currentFrameX()+w)/player.width == 1)
      {
        print(currentFrameX()+w + "\n");
        activeFrame = -1;
      } 
      return true;
    }
    else
    {
      return false;
    }
  }
  
  private void drawPlayerIdle()
  {
    if (lastLeft && !right)
      {
        filename = "idle3.png";
        player = loadImage(filename);
        dim = 12;
        w = player.width/dim;
        h = player.height;
      }
      else
      {
        filename = "idle3_R.png";
        player = loadImage(filename);
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
          filename = "walk.png";
          player = loadImage(filename);
          dim = 24;
          w = player.width/dim;
          h = player.height;
          
        }
        else
        {
          filename = "walk_right.png";
          player = loadImage(filename);
          dim = 24;
          w = player.width/dim;
          h = player.height;
        }
      }
      else
      {
        filename = "walk.png";
        player = loadImage(filename);
        dim = 24;
        w = player.width/dim;
        h = player.height;
      }
  }
  
  private void drawPlayerAttacking()
  {
    if (activeFrame == -1)
    {
      frameCount = 0;
      //currentAttack = 0; //FOR TESTING
      
      if(!lastLeft && !left || right) //Attacking right
      {        
       if(currentAttack == 0 ) //Punch 1 
          {
            activeFrame = frameCount;
            lastAttackTime = millis(); //Timer for delay
            filename = "punch1_f6_right_v2.png";
            player = loadImage(filename);
            dim = 4;
            w = player.width/dim;
            h = player.height;
            currentAttack++;
          }
          else if (currentAttack == 1 && getTimeBetweenAttack() < .5) //Punch 2
          {
            activeFrame = frameCount;
            lastAttackTime = millis(); 
            filename = "punch3_f6_right_V2.png";
            player = loadImage(filename);
            dim = 6;
            w = player.width/dim;
            h = player.height;
            currentAttack++;
          }
          else if (currentAttack == 2 && getTimeBetweenAttack() < .5) //Kick
          {
            activeFrame = frameCount;
            lastAttackTime = millis(); 
            filename = "punch4_f6_right.png";
            player = loadImage(filename);
            dim = 8;
            w = player.width/dim;
            h = player.height;
            currentAttack = 0; 
          }
          else if (getTimeBetweenAttack() >= .5) //Resets Attack Animation if idle for more than .5 seconds
          {   
            currentAttack = 0; 
            lastAttackTime = millis();     
            activeFrame = frameCount;  
            filename = "punch1_f6_right_v2.png";
            player = loadImage(filename);
            dim = 4;
            w = player.width/dim;
            h = player.height;
            currentAttack++;
          }
      }
      else //Attacking left
      {
        if(currentAttack == 0 ) //Punch 1 
        {
          activeFrame = frameCount;
          lastAttackTime = millis(); //Timer for delay
          filename = "punch1_f6_left_v2.png";
          player = loadImage(filename);
          dim = 4;
          w = player.width/dim;
          h = player.height;
          currentAttack++;
        }
        else if (currentAttack == 1 && getTimeBetweenAttack() < .5) //Punch 2
        {
          activeFrame = frameCount;
          lastAttackTime = millis(); 
          filename = "punch3_f6_left_V2.png";
          player = loadImage(filename);
          dim = 6;
          w = player.width/dim;
          h = player.height;
          currentAttack++;
        }
        else if (currentAttack == 2 && getTimeBetweenAttack() < .5) //Kick
        {
          activeFrame = frameCount;
          lastAttackTime = millis(); 
          filename = "punch4_f6_leftV2.png";
          player = loadImage(filename);
          dim = 8;
          w = player.width/dim;
          h = player.height;
          currentAttack = 0;  
        }
        else if (getTimeBetweenAttack() >= .5) //Resets Attack Animation if idle for more than .5 seconds
        {   
            currentAttack = 0; 
            activeFrame = frameCount;
            lastAttackTime = millis(); //Timer for delay
            filename = "punch1_f6_left_v2.png";
            player = loadImage(filename);
            dim = 4;
            w = player.width/dim;
            h = player.height;
            currentAttack++; 
        }
      }
    }
  }
  
} //End of Player Class