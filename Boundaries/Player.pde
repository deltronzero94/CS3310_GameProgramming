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
  }
  
   //Public Methods/Functions
  public void isPlayerIdle()
  { 
    if (isIdle)
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
    else
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
  }
 
  public int currentFrameX()
  {
    return frameCount % dim * w;
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
  
  public void playerMovement()
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
    
     int a = currentFrameX(); //Divide
     int b = 0;
     PImage sprite = p.getPImage().get(a, b, w,h);
     image(sprite, width + x - px, height*1.35 + y); 
  }
  
  public float currentPlayerPosition()
  {
    return width + x - px;
  }
  
  public void addPX(int x)
  {
    px += x;
  } 
  
  public void addX(int x)
  {
    this.x += x
  }
  
  //Setters
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
  
  //Getters
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
  
} //End of Player Class