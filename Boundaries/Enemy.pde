public class Enemy
{
  private PImage enemy;  //Enemy Avatar
  private boolean isIdle, isAttacking, isMoving; //Keeps of current state of the Enemy
  private int dim; //How space they are in the jpeg file
  private int x , y; //Enemy Movement for X and Y plane
  private float px; //Adjust enemy position x when screen moves
  private float py; //Adjust enemy position y when screen moves
  private int w; //width of the sprite
  private int h; //height of the sprite
  private int health;
  
  public Enemy()
  {
    enemy = loadImage("Enemy1_standing.png");
    health = 100;
    dim = 1;
    x = 600;
    y = 100;
    w = enemy.width/dim;
    h = enemy.height;
    px = width;
    py =  height*1.35; 
  }
  
  public Enemy(int x, int y)
  {
    enemy = loadImage("Enemy1_standing.png");
    health = 100;
    dim = 1;
    this.x = x;
    this.y = y;
    w = enemy.width/dim;
    h = enemy.height;
    px = width;
    py =  height*1.35; 
  }
  
  public Enemy(int x, int y, int type)
  {
    enemy = getEnemyType(type);
    health = 100;
    dim = 1;
    this.x = x;
    this.y = y;
    w = enemy.width/dim;
    h = enemy.height;
    px = width;
    py =  height*1.35; 
  }
  
  public void drawEnemy()
  {
    PImage sprite = getCurrentSprite();
    image(sprite, currentEnemyPositionX(), currentEnemyPositionY());  
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
  
  private int currentFrameX()
  {
    return frameCount % dim * w;
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
  
  private PImage getEnemyType(int type)
  {
    if (type == 0)
      return loadImage("Enemy1_standing.png");
    else if (type == 1)
      return loadImage("Enemy2_standing.png");
    else 
      return loadImage("Enemy1_standing.png"); //Default
  }
}