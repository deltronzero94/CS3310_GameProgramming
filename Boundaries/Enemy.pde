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
  private int health;
  private int type;
  private int activeFrame;
  
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
  }
  
  public void drawEnemy()
  {
    PImage sprite;
    
    if (enemy == null) //Load image if image hasn't been loaded
      getEnemyType(type);
    
    isIdle = false;
    isMoving = true;
    
    if (!isAttackFrameActive())
    {
      if (isIdle && !isAttacking) //Player is Idle
      {    
        drawEnemyIdle();
        sprite = getCurrentSprite();
        image(sprite, currentEnemyPositionX(), currentEnemyPositionY());  
      }
      else if (isMoving && !isAttacking) //Player is Moving
      {
        drawEnemyMoving();
        sprite = getCurrentSprite();
        image(sprite, currentEnemyPositionX(), currentEnemyPositionY());  
      }
      else if(isAttacking) //Player is Attacking
      {
        //drawPlayerAttacking();
      }
    }
  }
  
   public PImage getCurrentSprite()
  {
    return enemy.get(currentFrameX(), 0, w, h);
  }
  
  public float currentEnemyPositionX()
  {
    return width + x - px;
  }
  public float currentEnemyPositionY()
  {
    return y + py + 130;
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
    String filename;
    
    if (!left)
      {
        if ((up && lastLeft || down &&lastLeft) && !right )  //Walking Left
        {  
           if (type == 0)
            filename = "Enemy1_walking.png";  //Enemy 1
          else if (type == 1)
            filename = "Enemy2_walking.png";  //Enemy 2
          else
            filename = "Enemy1_walking.png";  //Default
          
          enemy = loadImage(filename);
          dim = 3;
          w = enemy.width/dim;
          h = enemy.height;
          
        }
        else  //Walking Right
        {
          if (type == 0)
            filename = "Enemy1_walking_Right.png";  //Enemy 1
          else if (type == 1)
            filename = "Enemy2_walking_Right.png";  //Enemy 2
          else
            filename = "Enemy1_walking_Right.png";  //Default
          
          enemy = loadImage(filename);
          dim = 3;
          w = enemy.width/dim;
          h = enemy.height;
        }
      }
      else  //Walking Left
      {
        if (type == 0)
          filename = "Enemy1_walking.png";  //Enemy 1
        else if (type == 1)
          filename = "Enemy2_walking.png";  //Enemy 2
        else
          filename = "Enemy1_walking.png";  //Default
        
        enemy = loadImage("walk.png");
        dim = 3;
        w = enemy.width/dim;
        h = enemy.height;
      }
  }
 
  private void drawEnemyIdle()
  {
    String filename;
    
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