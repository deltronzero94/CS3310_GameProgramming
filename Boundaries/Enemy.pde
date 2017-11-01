public class Enemy
{
  private PImage enemy;  //Enemy Avatar
  private boolean isIdle, isAttacking, isMoving; //Keeps of current state of the Enemy
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
  private int currentState;
  
  public Enemy()
  { 
    enemy = loadImage("Enemy1_standing_Right.png");
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
    health = 100;
    timeInterval = -1;
  }
  
  public Enemy(int x, int y)
  {
    enemy = loadImage("Enemy1_standing_Right.png");
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
    health = 100;
    timeInterval = -1;
  }
  
  public Enemy(int x, int y, int type)
  {
    enemy = getEnemyType(type);
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
      if (isIdle && !isAttacking) //Player is Idle
      {    
        drawEnemyIdle();
      }
      else if (isMoving && !isAttacking ) //Player is Moving
      { 
        drawEnemyMoving();  
      }
      else if(isAttacking) //Player is Attacking
      {
        //drawPlayerAttacking();
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
  
  public int getState()
  {
    if (isIdle)
      return 1;
    else if (isMoving)
      return 2;
    else if (isAttacking)
      return 3;
    else
      return -1;  //Error
  }
  
  
  // ******************************************
  // Private Methods
  // ******************************************
   private int currentFrameX()
  {
    return frameCount % dim * w;
  }
  
  public void decideAction(Player p)
  {
    if(timeInterval == -1)
    {
      timeInterval = random(0,6);
      int rand = (int)random(1,101);
      
      if (rand >=1 && rand <20) //20% chance (Attacking)
      {
        isMoving = false;
        isIdle = false;
        isAttacking = true;
        //currentState = 3;
      }
      else if (rand >=20 && rand <60) //%40 chance (Moving)
      {
        isMoving = true;
        isIdle = false;
        isAttacking = false;
      }
      else  //60% chance (Idle)
      {
        isMoving = false;
        isIdle = true;
        isAttacking = false;
        //currentState = 2;
      }
      
      startTime = millis();
    }
    
    if (timeElapsed() < timeInterval) //Action based on State Takes Place Here for Duration of Time
    {
      //print("Current State: " + currentState + "\n");
    }
    else
    {
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
      if((filename != "Enemy1_walking_Right.png" && (right || up || down) && !left) || (filename != "Enemy1_walking" && (left || up || down) && !right))
        return true;
      else
        return false;
    }
    else if (type == 1)  //Enemy #2
    {
      if((filename != "Enemy2_walking_Right_20.png" && (right || up || down) && !left) || (filename != "Enemy2_walking" && (left || up || down) && !right))
        return true;
      else
        return false;
    }
    else
    {
      return false;
    }
  }

  private PImage getEnemyPicture(int type)
  {
    if (type == 0) //Enemy #1
    {
       int state = this.getState();
       
       if(state == 1)  //isIdle State
       {
         
       }
       else if(isMoving)  //isMoving State
       {
         
       }
       else if(isAttacking)
       {
         
       }
       else
       {
         
       }
    }
    else  //Enemy #2
    {
      
    }
    
    return null;
  }
  
  private PImage getEnemyType(int type)
  {
    if (type == 0)
      return loadImage("Enemy1_standing_Right.png");
    else if (type == 1)
      return loadImage("Enemy2_standing_Right.png");
    else 
      return loadImage("Enemy1_standing_Right.png"); //Default
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
            dim = 3;
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
          dim = 3;
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
      addX(12);
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
}