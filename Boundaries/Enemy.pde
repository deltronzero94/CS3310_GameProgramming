public class Enemy
{
  private PImage enemy;  //Enemy Avatar
  private boolean isIdle, isAttacking, isMoving, isHit; //Keeps of current state of the Enemy
  private boolean lastLeft; //Keeps track of last key released (true if last key released was left )
  private boolean left, right, up, down; //Track currentMovement
  private int dim; //How space they are in the jpeg file
  private int x, y; //Enemy Movement for X and Y plane
  private float px; //Adjust enemy position x when screen moves
  private float py; //Adjust enemy position y when screen moves
  private int w; //width of the sprite
  private int h; //height of the sprite
  private int health;  //Health of the enemy
  private int type;  //Type of Enemy
  private int activeFrame;
  private String filename;
  private float startTime;
  private float timeInterval;
  private int mode;

  public Enemy()
  { 
    getEnemyType(0);
    enemy = loadImage(filename);
    activeFrame = -1;
    type = 0;
    health = 100;
    dim = 1;
    x = 600;
    y = 100;
    w = enemy.width/dim;
    h = enemy.height;
    px = width;
    py =  height*1.35;
    isIdle = true;
    isAttacking = false;
    isMoving = false;
    lastLeft = false;
    isHit = false;
    health = 300;
    timeInterval = -1;
    mode = -1;
  }

  public Enemy(int x, int y)
  {
    getEnemyType(0);
    enemy = loadImage(filename);
    activeFrame = -1;
    type = 0;
    health = 100;
    dim = 1;
    this.x = x;
    this.y = y;
    w = enemy.width/dim;
    h = enemy.height;
    px = width;
    py =  height*1.35;
    isIdle = true;
    isAttacking = false;
    isMoving = false;
    lastLeft = false;
    isHit = false;
    health = 300;
    timeInterval = -1;
    mode = -1;
  }

  public Enemy(int x, int y, int type)
  {
    getEnemyType(type);
    enemy = loadImage(filename);
    this.type = type;
    activeFrame = -1;
    health = 300;
    dim = 1;
    this.x = x;
    this.y = y;
    w = enemy.width/dim;
    h = enemy.height;
    px = width;
    py =  height*1.35;
    isIdle = true;
    isAttacking = false;
    isMoving = false;
    lastLeft = false;
    isHit = false;
    health = 300;
    timeInterval = -1;
    mode = -1;
  }

  public void drawEnemy(Player p)
  {
    PImage sprite;

    if (enemy == null && health != 0) //Load image if image hasn't been loaded
      getEnemyType(type);

    if (health > 0 && enemy != null)
      decideAction(p);

    if (!isAttackFrameActive() && health != 0 && enemy != null)
    {
      if (!isHit)
      {
        if (isIdle && !isAttacking) //Player is Idle
        {    
          drawEnemyIdle();
        } else if (isMoving && !isAttacking && checkFileMovementName()) //Player is Moving
        { 
          drawEnemyMoving();
        } else if (isAttacking) //Player is Attacking
        {
          //drawPlayerAttacking();
        }
      } else
      {
        drawEnemyHit();
      }
      sprite = getCurrentSprite();
      image(sprite, currentEnemyPositionX(), currentEnemyPositionY());
    } else if (health == 0)
      enemy = null;
  }

  public PImage getCurrentSprite()
  {
    return enemy.get(this.currentFrameX(), 0, w, h);
  }

  public float currentEnemyPositionX()
  {
    return width + x - px;
  }
  public float currentEnemyPositionY()
  {
    return y + py ;
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

  // ******************************************
  // Private Methods
  // ******************************************
  private int currentFrameX()
  {
    return frameCount % dim * w;
  }

  private void decideAction(Player p)
  {
    float playerX = p.currentPlayerPositionX();
    float playerY = p.currentPlayerPositionY();
    int playerYValue = p.getY();
    int playerXValue = p.getX();
    int playerAttack = p.getCurrentAttack();

    if (p.getIsAttacking())
    {
      if (abs(playerY-currentEnemyPositionY()+25) <= 30 && abs(playerX - currentEnemyPositionX()) <= 300.0) //If Player is within Range
      {
        if (currentEnemyPositionX() >=playerX && !p.getFacingLeft())  //If player is facing right
        {
          timeInterval = -1;
          if (playerAttack == 0)  //Punch #1
          {
            isHit = true;
          } else if (playerAttack == 1)  //Punch #2
          {
            isHit = true;
          } else if (playerAttack == 2) //Punch #3
          {
            isHit = true;
          }
          health -=10;
        } else if (p.getFacingLeft() && currentEnemyPositionX() < playerX)//Player facing left
        {
          timeInterval = -1;
          if (playerAttack == 0)  //Punch #1
          {
            isHit = true;
          } else if (playerAttack == 1)  //Punch #2
          {
            isHit = true;
          } else if (playerAttack == 2) //Punch #3
          {
            isHit = true;
          }
          health -=10;
        }
      } else  
      {
      }
    }

    if (timeInterval == -1 && !isHit)
    {
      int rand = (int)random(1, 101);

      if (rand >=1 && rand <25) //25% chance (Attacking)
      {
        if (abs(playerX - currentEnemyPositionX()) <= 300.0 && abs(playerY - currentEnemyPositionY()) <= 25) //If Enemy is within 300 units (x) within the player
        {
          isMoving = false;
          isIdle = false;
          isAttacking = true;
          timeInterval = random(0, 2); // 0-.999 seconds
        } 
        else
        {
          isMoving = true;
          isAttacking = false;
          isIdle = false;
          rand = (int) random (1,101);
          
          if (rand < 10)  //10% for Fleeing/Running Away Mode
          {
            mode = 2;
            timeInterval = random(0, 1);
          }
          else if (rand >= 10 && rand < 45)  //35% for Chasing Player
          {
            mode = 0;
            timeInterval = random(0, 3);
          }
          else if (rand >=45 && rand < 60)  //25% Walking to random location
          {
            mode = 1;
            timeInterval = random(0, 2);
          }
          else  //35% of walking to attack 
          {
            mode = 3;
            timeInterval = random(0, 1);
          }
        }
        //currentState = 3;
      } 
      else if (rand >=25 && rand <50) //%25 chance (Moving)
      {
        isMoving = true;
        isIdle = false;
        isAttacking = false;
        
        rand = (int) random (1,101);
        if (rand < 10)  //10% for Fleeing/Running Away Mode
        {
          mode = 2;
          timeInterval = random(0, 1);
        }
        else if (rand >= 10 && rand < 45)  //35% for Chasing Player
        {
          mode = 0;
          timeInterval = random(0, 3);
        }
        else if (rand >=45 && rand < 60)  //25% Walking to random location
        {
          mode = 1;
          timeInterval = random(0, 3);
        }
        else  //35% of walking to attack 
        {
          mode = 3;
          timeInterval = random(0, 2);
        }
      } 
      else  //50% chance (Idle)
      {
        isMoving = false;
        isIdle = true;
        isAttacking = false;
        timeInterval = random(0, 2);
      }

      startTime = millis();
    } 
    else if (timeInterval == -1 && isHit) //Enemy Hit
    {
      isIdle = false;
      isMoving = false;
      isAttacking = false;

      timeInterval = .4;  //Hit Stun Timer
      startTime = millis();
    }


    //print(mode+"\n");
    if (timeElapsed() < timeInterval) //Action based on State Takes Place Here for Duration of Time
    {
      if (isIdle)
      {
        
      } 
      else if (isMoving)  //Enemy Moving
      {
        if (mode == 0) //Chasing Player
        {
          if (playerX - 250 <= currentEnemyPositionX() && playerX + 250 >=currentEnemyPositionX())
          {

          } 
          else if (playerX - 250 > currentEnemyPositionX())
          {
            right = true;
            left = false;
            addX(8);
          } 
          else if (playerX + 250 < currentEnemyPositionX())
          {
            left = true;
            right = false;
            lastLeft = true;
            addX(-8);
          }
  
          if (playerY - 24 <= currentEnemyPositionY() && playerY + 24 >= currentEnemyPositionY())
          {
            
          } 
          else if (playerY - 24 > currentEnemyPositionY()) //Enemy above Player / Enemy will down
          {
            up = true;
            down = false;
            addY(4);
          } 
          else if (playerY + 24 < currentEnemyPositionY())  //Enemy Below Player, Enemy will move up
          {
            up = false;
            down = true;
            addY(-4);
          }
          
          if(playerX - 250 <= currentEnemyPositionX() && playerX + 250 >=currentEnemyPositionX() 
              &&  playerY - 24 <= currentEnemyPositionY() && playerY + 24 >= currentEnemyPositionY())
          {
            isIdle = true;
            isMoving = false;
            
            //y = playerYValue + 8;
            if(playerX <= currentEnemyPositionX())
            {
              left = true;
              right = false;
              lastLeft = true;
            }
            else
            {
              left = false;
              right = true;
              lastLeft = false;
            }
          }
        }
        else if (mode == 1)//Enemy is moving around
        {
          addX(16);
        }
        else if (mode == 2) //Enemy is running away
        {
          if (currentEnemyPositionX() == playerX && currentEnemyPositionY() == playerY)  //Same Y & X (Enemy and Player)
          {
            int i = (int)random(0,5);
            
            if (i == 0) //Move Right
            {
              addX(12);
            }
            else if (i == 1)  //Move Left
            {
              addX(-12);
            }
            else if ( i == 2)  //Move up
            {
              addY(8);
            }
            else  //Move down
            {
              addY(-8);
            } 
          }
          else if (currentEnemyPositionY() == playerY && currentEnemyPositionX() != playerX)  //Same Height, Different X Position
          {
            if(currentEnemyPositionX() > playerX)  //Enemy Will Move to the right (away from player)
            {
              addX(8);
              if (currentEnemyPositionX() >= playerX + 300)
              {
                int j = (int)random(0,2);
                if (j == 0)      
                  addY(4);
                else
                  addY(-4);
              }
            }
            else
            {
              addX(-8);
              if (currentEnemyPositionX() <= playerX - 300)
              {
                int j = (int)random(0,2);
                if (j == 0)      
                  addY(4);
                else
                  addY(-4);
              }
            }
          }
          else if (currentEnemyPositionY() != playerY && currentEnemyPositionX() == playerX)  //Same X, Different Y Position
          {
            if(currentEnemyPositionY() > playerY)  //Enemy is above Player then enemy will move up
            {
              addY(-4);
              int j = (int)random(0,2);
              if (j == 0)      
                addX(8);
              else
                addX(-8);
            }
            else  //Enemy is below Player then enemy will move down
            {
              addY(4);
              int j = (int)random(0,2);
              if (j == 0)      
                addX(8);
              else
                addX(-8);
            }
          }
          else  //Different X and Y
          {
            if (currentEnemyPositionX() > playerX) //Enemy Moving to the right (away from Player)
            {
              left = true;
              right = false;
              addX(8);
            }
            else  //Enemy Moving to the left (away from Player)
            {
              left = false;
              right = true;
              addX(-8);
            }  
            
            if (currentEnemyPositionY() > playerY)  //Enemy Moving down (away from Player)
            {
              addY(4);
            }
            else  //Enemy Moving up (away from Player)
            {
              addY(-4);
            }
          }
          
          if (y > 350)
            y = 350;
          if (y < 45)
            y = 45;
        }
        else if(mode == 3) //Moving towards player and then fight
        {
          if (playerX - 250 <= currentEnemyPositionX() && playerX + 250 >=currentEnemyPositionX())
          {

          } 
          else if (playerX - 250 > currentEnemyPositionX())
          {
            right = true;
            left = false;
            addX(8);
          } 
          else if (playerX + 250 < currentEnemyPositionX())
          {
            left = true;
            right = false;
            lastLeft = true;
            addX(-8);
          }
  
          if (playerY - 24 <= currentEnemyPositionY() && playerY + 24 >= currentEnemyPositionY())
          {
            y = playerYValue + 8;
          } 
          else if (playerY - 24 > currentEnemyPositionY()) //Enemy above Player / Enemy will down
          {
            up = true;
            down = false;
            addY(8);
          } 
          else if (playerY + 24 < currentEnemyPositionY())  //Enemy Below Player, Enemy will move up
          {
            up = false;
            down = true;
            addY(-8);
          }
          
          if(playerX - 250 <= currentEnemyPositionX() && playerX + 250 >=currentEnemyPositionX() 
              &&  playerY - 24 <= currentEnemyPositionY() && playerY + 24 >= currentEnemyPositionY())
          {
            isAttacking = true;
            isMoving = false;
            
            y = playerYValue + 8;
            
            if(playerX <= currentEnemyPositionX())
            {
              left = true;
              right = false;
              lastLeft = true;
            }
            else
            {
              left = false;
              right = true;
              lastLeft = false;
            }
          }
        }
      } 
      else if (isAttacking)
      {
        
      }
      else if (isHit)
      {
        
      }
    } 
    else
    {
      if (isHit)
      {
        isHit = false;
        isIdle = true;
        isAttacking = false;
        isMoving = false;
      }
      timeInterval = -1;
      mode = -1;
    }
  }

  private float timeElapsed()
  {
    return (float)(millis() - this.startTime)/1000;
  }


  private boolean checkFileMovementName()
  {
    if (type == 0)  //Enemy #1
    {
      if ((filename != "Enemy1_walking_Right.png" && right && !left) 
        || (filename != "Enemy1_walking.png" && left && !right)
        || (filename != "walk.Enemy1_walking" && left && (up || down))
        || (filename != "Enemy1_walking_Right.png" && !left && (up || down)))
        return true;
      else
        return false;
    } else if (type == 1)  //Enemy #2
    {
      if ((filename != "Enemy2_walking_Right_20.png" && right && !left) 
        || (filename != "Enemy2_walking.png" && left && !right)
        || (filename != "Enemy2_walking" && left && (up || down))
        || (filename != "Enemy2_walking_Right_20.png" && !left && (up || down)))
        return true;
      else
        return false;
    } else
    {
      return false;
    }
  }

  private void getEnemyType(int type)
  {
    if (type == 0)
      filename = "Enemy1_standing_Right.png";
    else if (type == 1)
      filename = "Enemy2_standing_Right.png";
    else 
    filename = "Enemy1_standing_Right.png"; //Default
  }

  private boolean isAttackFrameActive()
  {
    if (activeFrame != -1)
    {
      if ((currentFrameX()+w)/enemy.width == 1)
      {
        print(currentFrameX()+w + "\n");
        activeFrame = -1;
      } 
      return true;
    } else
    {
      return false;
    }
  }

  private void drawEnemyMoving()
  {
    if (!left)
    {
      if ((up && lastLeft || down &&lastLeft) && !right )  //Walking Left
      {  
        if (type == 0 && filename != "Enemy1_walking.png")
        {
          filename = "Enemy1_walking.png";  //Enemy 1
          dim = 3;
          enemy = loadImage(filename);
          w = enemy.width/dim;
          h = enemy.height;
        } 
        else if (type == 1 && filename != "Enemy2_walking.png")
        {
          filename = "Enemy2_walking.png";  //Enemy 2
          dim = 9;
          enemy = loadImage(filename);
          w = enemy.width/dim;
          h = enemy.height;
        } 
      } 
      else  //Walking Right
      {
        if (type == 0 && filename != "Enemy1_walking_right.png")
        {
          filename = "Enemy1_walking_Right.png";  //Enemy 1
          dim = 3;
          enemy = loadImage(filename);
          w = enemy.width/dim;
          h = enemy.height;
        } 
        else if (type == 1 && filename != "Enemy2_walking_Right_20.png")
        {
          filename = "Enemy2_walking_Right_20.png";  //Enemy 2
          dim = 9;
          enemy = loadImage(filename);
          w = enemy.width/dim;
          h = enemy.height;
        } 
      }
    } 
    else  //Walking Left
    {
      if (type == 0 && filename != "Enemy1_walking.png")
      {
        filename = "Enemy1_walking.png";  //Enemy 1
        dim = 3;
        enemy = loadImage(filename);
        w = enemy.width/dim;
        h = enemy.height;
      } 
      else if (type == 1 && filename != "Enemy2_walking.png")
      {
        filename = "Enemy2_walking.png";  //Enemy 2
        dim = 9;
        enemy = loadImage(filename);
        w = enemy.width/dim;
        h = enemy.height;
      }
      
    }
  }

  private void drawEnemyIdle()
  { 
    dim = 1;
    
    if (lastLeft && !right)  //Standing and looking to the left
    {
      if (type == 0 && filename != "Enemy1_standing.png")
      {
        filename = "Enemy1_standing.png";  //Enemy 1
        enemy = loadImage(filename);
        w = enemy.width/dim;
        h = enemy.height;
      }
      else if (type == 1 && filename != "Enemy2_standing.png")
      {
        filename = "Enemy2_standing.png";  //Enemy 2
        enemy = loadImage(filename);
        w = enemy.width/dim;
        h = enemy.height;
      }

    } 
    else  //Standing and looking to the right
    {
      if (type == 0 && filename != "Enemy1_standing_Right.png")
      {
        filename = "Enemy1_standing_Right.png";  //Enemy 1
        enemy = loadImage(filename);
        w = enemy.width/dim;
        h = enemy.height;
      }
      else if (type == 1 && filename != "Enemy2_standing_Right.png")
      {
        filename = "Enemy2_standing_Right.png";  //Enemy 2
        enemy = loadImage(filename);
        w = enemy.width/dim;
        h = enemy.height;
      }
    
    }
  }

  private void drawEnemyHit()
  {
    if (lastLeft && !right)  //Looking Left
    {
      if (type == 0 && filename != "Enemy1_standing.png")
      {
        filename = "Enemy1_standing.png";  //Enemy 1
        enemy = loadImage(filename);
        dim = 1;
        w = enemy.width/dim;
        h = enemy.height;
      }
      else if (type == 1 && filename != "Enemy2_HitStun.png")
      {
        filename = "Enemy2_HitStun.png";  //Enemy 2
        enemy = loadImage(filename);
        dim = 1;
        w = enemy.width/dim;
        h = enemy.height;
      }
    } 
    else  //Looking right
    {
      if (type == 0 && filename != "Enemy1_standing_Right.png")  ////Enemy 1 Stunned (facing right)
      {
        filename = "Enemy1_standing_Right.png";
        enemy = loadImage(filename);
        dim = 1;
        w = enemy.width/dim;
        h = enemy.height;
      }
      else if (type == 1 && filename != "Enemy2_HitStun_right.png")  //Enemy 2 Stunned (facing right)
      {
        filename = "Enemy2_HitStun_right.png"; 
        enemy = loadImage(filename);
        dim = 1;
        w = enemy.width/dim;
        h = enemy.height;
      }
    }
  }
}