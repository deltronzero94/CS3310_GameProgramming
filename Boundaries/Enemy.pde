public class Enemy
{
  private PImage enemy;  //Enemy Avatar
  private boolean isIdle, isAttacking, isMoving, isHit; //Keeps of current state of the Enemy
  private boolean lastLeft; //Keeps track of last key released (true if last key released was left )
  private boolean left,right, up, down; //Track currentMovement
  private int dim; //How space they are in the jpeg file
  private int x , y; //Enemy Movement for X and Y plane
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
    health = 100;
    timeInterval = -1;
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
    health = 100;
    timeInterval = -1;
  }
  
  public Enemy(int x, int y, int type)
  {
    getEnemyType(type);
    enemy = loadImage(filename);
    this.type = type;
    activeFrame = -1;
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
    health = 100;
    timeInterval = -1;
  }
  
  public void drawEnemy(Player p)
  {
    PImage sprite;
    
    if (enemy == null && health != 0) //Load image if image hasn't been loaded
      getEnemyType(type);
    
    decideAction(p);
    
    if (!isAttackFrameActive() && health != 0)
    {
      if (!isHit)
      {
        if (isIdle && !isAttacking) //Player is Idle
        {    
          drawEnemyIdle();
        }
        else if (isMoving && !isAttacking && checkFileMovementName()) //Player is Moving
        { 
          print("testing\n");
          drawEnemyMoving();  
        }
        else if(isAttacking) //Player is Attacking
        {
          //drawPlayerAttacking();
        }
      }
      else
      {
        drawEnemyHit();
      }
     sprite = getCurrentSprite();
     image(sprite, currentEnemyPositionX(), currentEnemyPositionY());
    }
    else if (health == 0)
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
    int playerAttack = p.getCurrentAttack();
    
    if(p.getIsAttacking())
    {
      if(abs(playerY-currentEnemyPositionY()+25) <= 25 && abs(playerX - currentEnemyPositionX()) <= 300.0) //If Player is within Range
      {
        if (currentEnemyPositionX() >=playerX && !p.getFacingLeft())  //If player is facing right
        {
          timeInterval = -1;
          if (playerAttack == 0)  //Punch #1
          {
            isHit = true;
          }
          else if (playerAttack == 1)  //Punch #2
          {
            isHit = true;
          }
          else if (playerAttack == 2) //Punch #3
          {
            isHit = true;
          }
        }
        else if(p.getFacingLeft() && currentEnemyPositionX() < playerX)//Player facing left
        {
          timeInterval = -1;
          if (playerAttack == 0)  //Punch #1
          {
            isHit = true;
          }
          else if (playerAttack == 1)  //Punch #2
          {
            isHit = true;
          }
          else if (playerAttack == 2) //Punch #3
          {
             isHit = true;
          }
        }
      }
      else  
      {

      }
    }
  
    if(timeInterval == -1 && !isHit)
    {
      int rand = (int)random(1,101);
       
      if (rand >=1 && rand <25) //25% chance (Attacking)
      {
        if (abs(playerX - currentEnemyPositionX()) <= 300.0 && abs(playerY - currentEnemyPositionY()) <= 25) //If Enemy is within 300 units (x) within the player
        {
          isMoving = false;
          isIdle = false;
          isAttacking = true;
          timeInterval = random(0,2); // 0-.999 seconds
        }
        else
        {
          isMoving = true;
          isAttacking = false;
          isIdle = false;
          timeInterval = random(0,1);
        }
        //currentState = 3;
      }
      else if (rand >=25 && rand <60) //%35 chance (Moving)
      {
        isMoving = true;
        isIdle = false;
        isAttacking = false;
        timeInterval = random(0,4);
      }
      else  //40% chance (Idle)
      {
        isMoving = false;
        isIdle = true;
        isAttacking = false;
        timeInterval = random(0,2);
      }
      
      startTime = millis();
    }
    else if (timeInterval == -1 && isHit) //Enemy Hit
    {
      isIdle = false;
      isMoving = false;
      isAttacking = false;
      
      timeInterval = .4;
      startTime = millis();
    }
    
    
    if (timeElapsed() < timeInterval) //Action based on State Takes Place Here for Duration of Time
    {
      if (isIdle)
      {
          
      }
      else if (isMoving)
      {
        if (playerX - 250 <= currentEnemyPositionX() && playerX + 250 >=currentEnemyPositionX())
        {
          //right = false;
          //left = false;
          //lastLeft = false;
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
        
      }
      else if(isAttacking)
      {
        
      }
      else if (isHit)
      {
        
      }
    }
    else
    {
      if(isHit)
      {
        isHit = false;
        isIdle = true;
        isAttacking = false;
        isMoving = false;
      }
      timeInterval = -1;
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
      if((filename != "Enemy1_walking_Right.png" && (right || up || down) && !left) || (filename != "Enemy1_walking.png" && (left || up || down) && !right))
        return true;
      else
        return false;
    }
    else if (type == 1)  //Enemy #2
    {
      if((filename != "Enemy2_walking_Right_20.png" && (right || up || down) && !left) || (filename != "Enemy2_walking.png" && (left || up || down) && !right))
        return true;
      else
        return false;
    }
    else
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
    }
    else
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
           if (type == 0)
           {
            filename = "Enemy1_walking.png";  //Enemy 1
            dim = 3;
           }
          else if (type == 1)
          {
            filename = "Enemy2_walking.png";  //Enemy 2
            dim = 9;
          }
          else
          {
            filename = "Enemy1_walking.png";  //Default
            dim = 3;
          }
          
          enemy = loadImage(filename);
          w = enemy.width/dim;
          h = enemy.height;
          
        }
        else  //Walking Right
        {
          if (type == 0)
          {
            filename = "Enemy1_walking_Right.png";  //Enemy 1
            dim = 3;
          }
          else if (type == 1)
          {
             filename = "Enemy2_walking_Right_20.png";  //Enemy 2
             dim = 9;
          }
          else
          {
            filename = "Enemy1_walking_Right.png";  //Default
            dim = 3;
          }
          
          enemy = loadImage(filename);
          w = enemy.width/dim;
          h = enemy.height;
        }
      }
      else  //Walking Left
      {
        if (type == 0)
        {
          filename = "Enemy1_walking.png";  //Enemy 1
          dim = 3;
        }
        else if (type == 1)
        {
          filename = "Enemy2_walking.png";  //Enemy 2
          dim = 9;
        }
        else
        {
          filename = "Enemy1_walking.png";  //Default
          dim = 3;
        }
        
        enemy = loadImage(filename);
        w = enemy.width/dim;
        h = enemy.height;
      }
      
      //addX(12);
  }
 
  private void drawEnemyIdle()
  { 
    if (lastLeft && !right)  //Poition to the left
      {
        if (type == 0)
          filename = "Enemy1_standing.png";  //Enemy 1
        else if (type == 1)
          filename = "Enemy2_standing.png";  //Enemy 2
        else
          filename = "Enemy1_standing.png";  //Default
        
        enemy = loadImage(filename);
        dim = 1;
        w = enemy.width/dim;
        h = enemy.height;
      }
      else  //Position to the right
      {
        if (type == 0)
          filename = "Enemy1_standing_Right.png";  //Enemy 1
        else if (type == 1)
          filename = "Enemy2_standing_Right.png";  //Enemy 2
        else
          filename = "Enemy1_standing_Right.png";  //Default
          
        enemy = loadImage(filename);
        dim = 1;
        w = enemy.width/dim;
        h = enemy.height;
      }
  }
  
  private void drawEnemyHit()
  {
    if (lastLeft && !right)  //Looking Left
      {
        if (type == 0)
          filename = "Enemy1_standing.png";  //Enemy 1
        else if (type == 1)
          filename = "Enemy2_HitStun.png";  //Enemy 2
        else
          filename = "Enemy1_standing.png";  //Default
        
        enemy = loadImage(filename);
        dim = 1;
        w = enemy.width/dim;
        h = enemy.height;
      }
      else  //Looking right
      {
        if (type == 0)
          filename = "Enemy1_standing_Right.png";  //Enemy 1
        else if (type == 1)
          filename = "Enemy2_HitStun_right.png";  //Enemy 2
        else
          filename = "Enemy1_standing_Right.png";  //Default
          
        enemy = loadImage(filename);
        dim = 1;
        w = enemy.width/dim;
        h = enemy.height;
      }
  }
}