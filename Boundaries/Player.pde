public class Player
{
  //Declared Variable Members
  private PImage player; //Player avatar
  private boolean isIdle, isAttacking, isMoving, isHit, isKnocked; //Keeps of current state of the player
  private boolean lastLeft; //Keeps track of last key released (true if last key released was left )
  private boolean left, right, up, down; //Track currentMovement
  private int x, y; //Player Movement for X and Y plane
  private float px; //Adjust player position x when screen moves
  private float py; //Adjust player position y when screen moves
  private int dim; //How space they are in the jpeg file
  private int w; //width of the sprite
  private int h; //height of the sprite
  private int lastAttackTime; //Tracks time between attacks for combos
  private int currentAttack; //Current Attack Being Animated (Punch 1, Punch 2, and Kick)
  private int activeFrame; //Keeps Track of Active Attack Frames (helps attack animation finish)
  private String filename;
  private int currentFrame;
  private boolean facingLeft;
  private float timeInterval;
  private float startTime;
  private int health;
  private boolean isHitLeft;

  //Default Constructor
  public Player()
  {
    x = 100;
    y = -700;
    health = 300;
    isIdle = true;
    isAttacking = false;
    isMoving = false;
    lastLeft = false;
    isHit = false;
    isKnocked = false;
    px = width;
    py = height * 1.35; 
    activeFrame = -1;
    currentFrame = -1;
    timeInterval = -1;
  }

  public Player(int x, int y)
  {
    this.x = x;
    this.y = y;
    health = 300;
    isIdle = true;
    isAttacking = false;
    isMoving = false;
    lastLeft = false;
    isHit = false;
    isKnocked = false;
    px = width;
    py = height*1.35; 
    activeFrame = -1;
    currentFrame = -1;
    timeInterval = -1;
  }

  //****************************
  //Public Methods/Functions
  //****************************
  public void checkIfPlayerWasHit(Enemy e)
  {
    int enemyAttack = e.getCurrentAttack();
    
    
    if (e.getIsAttacking() && !isKnocked)
    {  
      if (e.currentEnemyPositionX() > currentPlayerPositionX())
        isHitLeft = false;
      else
        isHitLeft = true;
      
      if (!isMoving && currentPlayerPositionY() + 24 >= e.currentEnemyPositionY() && currentPlayerPositionY() - 24 <= e.currentEnemyPositionY())
      {
        if (e.getType() == 0)
        {
          if (e.getCurrentFrame() == 2)
          {
            hitSFX.play();
            hitSFX.rewind();
            isHit = true;
            health -=10;
          }
        }
        else if (e.getType() == 1)
        {
          if (e.getCurrentFrame() == 2)
          {
            isHit = true;
            if(enemyAttack != 3)
            {
              hitSFX.play();
              hitSFX.rewind();
              health -= 10;
            }
            else
            {
              //timeInterval = 1;
              strongSFX.play();
              strongSFX.rewind();
              isKnocked = true;
              health -= 30;  
            }
            //print(enemyAttack + ", "+ health + "\n");
          }
        }
      }
      else if (isMoving)
      {
        if (e.getType() == 0)
        {
          if (e.getCurrentFrame() == 2)
          {
            hitSFX.play();
            hitSFX.rewind();
            isHit = true;
            health -=10;
          }
        }
        else if (e.getType() == 1)
        {
          if (e.getCurrentFrame() == 2)
          {
            isHit = true;
            if(enemyAttack != 3)
            {
              hitSFX.play();
              hitSFX.rewind();
              health -= 10;
            }
            else
            {
              // timeInterval = 1;
              strongSFX.play();
              strongSFX.rewind();
              isKnocked = true;
              health -= 30;  
            }
            //print(enemyAttack + ", "+ health + "\n");
          }
        }
      }
      
      if (isHit && isAttackFrameActive())
      {
        currentFrame = 0;
        activeFrame = -1;
      }
    }
    
    if (timeInterval == -1 && isHit) //Enemy Hit
    {
      isIdle = false;
      isMoving = false;
      isAttacking = false;
      isHit = true;
      
      if (isKnocked)
        timeInterval = .8;
      else
        timeInterval = .4;  //Hit Stun Timer
      startTime = millis();
    }
    else if ((isHit || isKnocked) && (millis() - startTime)/1000 >= timeInterval && timeInterval != -1)
    {
      isIdle = true;
      isHit = false;
      isMoving = false;
      isAttacking = false;
      isKnocked = false;
      timeInterval = -1;
    }
  }
  
  public void isPlayerIdle()
  {    
    if (player == null) //initialize image if there is no image
    {
      drawPlayerIdle();
    }

    if (!isAttackFrameActive()) //If player is not attacking
    {
      if (!isHit)
      {
        if (isIdle && !isAttacking ) //Player is Idle
        {    
          drawPlayerIdle();
        } else if (isMoving && !isAttacking && checkMovement()) //Player is Moving
        {
          drawPlayerMoving();
        } else if (isAttacking) //Player is Attacking
        {
          drawPlayerAttacking();
        }
        
        playerMovement();
      }
      else
      {
        if (!isKnocked)
          drawPlayerHit();
        else
        {
          drawPlayerKnocked();
        }
      }
    }
  }

  public boolean isKeyPressed()
  {
    if (left || right || up || down)
    {
      return true;
    } else
    {
      return false;
    }
  }

  public boolean isKeyReleased()
  {
    if (!(left || right || up || down))
    {
      return true;
    } else
    {
      return false;
    }
  }

  public PImage getCurrentSprite()
  {
    if (activeFrame == -1 && !isKnocked)
      return player.get(currentFrameX(), 0, w, h);
    else
      return player.get(currentFrame % dim * w, 0, w, h);
  }

  public void playerMovement()
  {
    if (isMoving && !isAttackFrameActive() && !isHit)
    {
      if (left)
      {
        x -= 14;
      }
      if (right)
      {
        x += 14;
      }
      if (up)
      {
        y -= 8;
      }
      if (down)
      {
        y += 8;
        if (y > -580) y = -580; //Prevent player from going too far bottom
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
    ///if (activeFrame == -1)
    this.isAttacking = isAttacking;
    //else
    //  this.isAttacking = true;
  }

  public void setY(int y)
  {
    if(!isHit)
      this.y = y;
  }

  public void setX(int x)
  {
    if(!isHit)
      this.x = x;
  }


  //**********
  //Getters
  //**********
  public PImage getPImage()
  {
    return this.player;
  }
  
  public int getHealth()
  {
    return this.health;
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

  public boolean getIsAttacking()
  {
    return this.isAttacking;
  }

  public float getTimeBetweenAttack()
  {
    return (float)(millis() - this.lastAttackTime)/1000;
  }

  public boolean getLastLeft()
  {
    return this.lastLeft;
  }

  public boolean getFacingLeft()
  {
    return this.facingLeft;
  }
  
  public boolean getIsPlayerHit()
  {
    return this.isHit;
  }
  public boolean getIsKnocked()
  {
    return this.isKnocked;
  }
  
  public boolean getIsHit()
  {
    return this.isHit;
  }
  
  public int getCurrentFrame()
  {
    return this.currentFrame;
  }
  
  public int getActiveFrame()
  {
    return this.activeFrame;
  }

  //********************
  //Private Methods
  //********************
  private int currentFrameX()
  {
    return frameCount % dim * w;
  }

  private boolean checkMovement()
  {
    if ((filename != "walk_right.png" && right  && !left) 
      || (filename != "walk.png" && left  && !right)
      || (filename != "walk.png" && facingLeft && (up || down))
      || (filename != "walk_right.png" && !facingLeft && (up || down)))
    {
      return true;
    } else
    {
      return false;
    }
  }

  private boolean isAttackFrameActive()
  {
    if (activeFrame != -1)
    {    
      if (currentFrame +  1 == dim)
      {
        currentFrame = 0;
        activeFrame = -1;
        
        return true;
      }
      currentFrame++;

      return true;
    } else
    {
      return false;
    }
  }
  
  private void drawPlayerKnocked()
  {
    if (isHitLeft && filename != "Player_Knockedv2.png" )
    {
      currentFrame = 0;
      facingLeft = true;
      filename = "Player_Knockedv2.png";
      player = loadImage(filename);
      dim = 4;
      w = player.width/dim;
      h = player.height;
    } 
    else if (!isHitLeft && filename != "Player_Knockedv2_right.png")
    {
      currentFrame = 0;
      facingLeft = false;
      filename = "Player_Knockedv2_right.png";
      player = loadImage(filename);
      dim = 4;
      w = player.width/dim;
      h = player.height;
    }
    else if (filename == "Player_Knockedv2.png")
    {
      if (currentFrame == 0 || currentFrame == 1)  //Move player back when hit during 0 and 1st frames
      {
        x+=24;
      } 
      if ( (millis() - startTime)/1000 >= .20 *(currentFrame + 1))
      {
         if (currentFrame + 1 >= dim )
        {
          isIdle = true;
          isHit = false;
          isMoving = false;
          isAttacking = false;
          isKnocked = false;
          timeInterval = -1;
          
          filename = "idle3.png";
          player = loadImage(filename);
          dim = 12;
          w = player.width/dim;
          h = player.height;
        }
        else
        {
           if (currentFrame == 0)
           {
             floorHit.play();
             floorHit.rewind();
           }
           currentFrame++;
        }
      }
    }
    else if (filename == "Player_Knockedv2_right.png")
    {
      if (currentFrame == 0 || currentFrame == 1)  //Move player back when hit during 0 and 1st frames
      {
        x-=24;
      } 
      if ( (millis() - startTime)/1000 >= .20 *(currentFrame + 1))
      {
         if (currentFrame + 1 >= dim )
        {
          isIdle = true;
          isHit = false;
          isMoving = false;
          isAttacking = false;
          isKnocked = false;
          timeInterval = -1;
          
          filename = "idle3_R.png";
          player = loadImage(filename);
          dim = 12;
          w = player.width/dim;
          h = player.height;
        }
        else
        {
           if (currentFrame == 0)
           {
             floorHit.play();
             floorHit.rewind();
           }
           currentFrame++;
        }
      }
    }
  }
  
  private void drawPlayerHit()
  {
    if (facingLeft && filename != "PlayerHit.png" )
    {
      facingLeft = true;
      filename = "PlayerHit.png";
      player = loadImage(filename);
      dim = 1;
      w = player.width/dim;
      h = player.height;
    } 
    else if (!facingLeft && filename != "PlayerHit_right.png")
    {
      facingLeft = false;
      filename = "PlayerHit_right.png";
      player = loadImage(filename);
      dim = 1;
      w = player.width/dim;
      h = player.height;
    }
  }

  private void drawPlayerIdle()
  {
    if ((lastLeft || facingLeft) && !right && filename != "idle3.png" )
    {
      facingLeft = true;
      filename = "idle3.png";
      player = loadImage(filename);
      dim = 12;
      w = player.width/dim;
      h = player.height;
    } 
    else if (facingLeft == false && filename != "idle3_R.png")
    {
      facingLeft = false;
      filename = "idle3_R.png";
      player = loadImage(filename);
      dim = 12;
      w = player.width/dim;
      h = player.height;
    }
    else if (filename == null)
    {
      facingLeft = false;
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
        facingLeft = true;
        filename = "walk.png";
        player = loadImage(filename);
        dim = 24;
        w = player.width/dim;
        h = player.height;
      } else
      {
        facingLeft = false;
        filename = "walk_right.png";
        player = loadImage(filename);
        dim = 24;
        w = player.width/dim;
        h = player.height;
      }
    } else
    {
      facingLeft = true;
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
      currentFrame = 0;
      //currentAttack = 0; //FOR TESTING

      if (!lastLeft && !left || right) //Attacking right
      {        
        facingLeft = false;
        if (currentAttack == 0 ) //Punch 1 
        {
          activeFrame = frameCount;
          lastAttackTime = millis(); //Timer for delay
          filename = "punch1_f6_right_v2.png";
          player = loadImage(filename);
          dim = 4;
          w = player.width/dim;
          h = player.height;
          currentAttack++;
        } else if (currentAttack == 1 && getTimeBetweenAttack() < .5) //Punch 2
        {
          activeFrame = frameCount;
          lastAttackTime = millis(); 
          filename = "punch3_f6_right_V2.png";
          player = loadImage(filename);
          dim = 6;
          w = player.width/dim;
          h = player.height;
          currentAttack++;
        } else if (currentAttack == 2 && getTimeBetweenAttack() < .6) //Kick
        {
          activeFrame = frameCount;
          lastAttackTime = millis(); 
          filename = "punch4_f6_right.png";
          player = loadImage(filename);
          dim = 8;
          w = player.width/dim;
          h = player.height;
          currentAttack = 0;
        } else if (getTimeBetweenAttack() >= .5) //Resets Attack Animation if idle for more than .5 seconds
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
      } else //Attacking left
      {
        facingLeft = true;
        if (currentAttack == 0 ) //Punch 1 
        {
          activeFrame = frameCount;
          lastAttackTime = millis(); //Timer for delay
          filename = "punch1_f6_left_v2.png";
          player = loadImage(filename);
          dim = 4;
          w = player.width/dim;
          h = player.height;
          currentAttack++;
        } else if (currentAttack == 1 && getTimeBetweenAttack() < .5) //Punch 2
        {
          activeFrame = frameCount;
          lastAttackTime = millis(); 
          filename = "punch3_f6_left_V2.png";
          player = loadImage(filename);
          dim = 6;
          w = player.width/dim;
          h = player.height;
          currentAttack++;
        } else if (currentAttack == 2 && getTimeBetweenAttack() < .6) //Kick
        {
          activeFrame = frameCount;
          lastAttackTime = millis(); 
          filename = "punch4_f6_leftV2.png";
          player = loadImage(filename);
          dim = 8;
          w = player.width/dim;
          h = player.height;
          currentAttack = 0;
        } else if (getTimeBetweenAttack() >= .5) //Resets Attack Animation if idle for more than .5 seconds
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