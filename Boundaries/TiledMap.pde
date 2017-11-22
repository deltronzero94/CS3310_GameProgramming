import ptmx.*;
import java.util.*;

public class TiledMap
{
  //Declared Member Variables
  private int sx, sy;  //Screen Position X and Y
  private float leftSideBorder, rightSideBorder;  //Edge of the Screen
  private Ptmx map;
  private PApplet applet;
  private Player player;
  private Enemy[] enemy;
  private ArrayList<Enemy> e;
  
  private PriorityQueue<Image> q;
  
  //Default Constructor
  public TiledMap(PApplet applet)
  {
    this.applet = applet;
    sx = 1000;  //sx = 300
    sy = 550;  //sy = 170
    leftSideBorder = 50.0;
    rightSideBorder = 1660.0;  //1650
    player = new Player();
    enemy = new Enemy[]{new Enemy(200, -700, 1), new Enemy(500,-700,1), new Enemy(1000,-700,1), new Enemy(1000,-700,1), new Enemy(800, -700)};
    //enemy = new Enemy[]{new Enemy(800,-700, 1)};
    map = new Ptmx(applet,"sor2_1v4.tmx");
    map.setDrawMode(CENTER);
    map.setPositionMode("CANVAS");//Default Position Mode
    q = new PriorityQueue<Image>(enemy.length, new Comparator<Image>() {
    public int compare(Image edge1, Image edge2) {
        if (edge1.positionY < edge2.positionY) return -1;
        if (edge1.positionY > edge2.positionY) return 1;
        return 0;
    } });
  }
  
  //Public Methods/Functions
  public void drawMap()
  { 
    //Check State of Player
    player.isPlayerIdle();
    
    float px = player.getPX();
    int x = player.getX();
    PImage sprite;
   
    if (player.getY() <= -1020)
    {
      player.setY(-1020);
    }
    
    if  (rightSideBorder < 1681.0) //If screen hasn't reached the end of the map
    {
      //If player movement is greater than left screen boundary
      if (player.currentPlayerPositionX() >leftSideBorder)
      { 
        if ( width/4 + x + px/3  > px/3 + sx+ width/4 ) //When Crossing midway point
        {
          leftSideBorder+= 0.04;
          rightSideBorder+=0.04;
          sx+= 4;
          player.addPX(4);
          
          if ( enemy != null)
          {
            for (int num = 0; num < enemy.length; num++)
               enemy[num].addPX(4);
          }
             
          //sprite = player.getCurrentSprite();
          map.draw(applet.g, sx , sy);
          
          if (player.currentPlayerPositionX() >  rightSideBorder + 190) //If player goes beyond right boundary screen
          {
            player.addX(-14);
          }
        }
        else //Standing Still/Before Halfway point 
        { 
          //sprite = player.getCurrentSprite();
          map.draw(applet.g, sx , sy);
        }
      }
      else //When Going Beyond left boundary 
      { 
        
        if (player.getLeft())
        {
          player.addX(14);
          //sprite = player.getCurrentSprite();
          map.draw(applet.g, sx , sy);
        }
        else
        {
          //sprite = player.getCurrentSprite();
          map.draw(applet.g, sx , sy);
        }
      }
    }
    else
    {
      if ( width/4 + x + px/3  >  px/3 + sx+ width/4) //When Crossing midway point
        {
          //sprite = player.getCurrentSprite();
          map.draw(applet.g, sx , sy);
          
          if (player.currentPlayerPositionX() > rightSideBorder + 190) //If player goes beyond right boundary screen
          {
            player.addX(-14);
          }
        }
        else //Standing Still/Before Halfway point 
        { 
          if (player.currentPlayerPositionX() > leftSideBorder)
          {
            
            //sprite = player.getCurrentSprite();
            map.draw(applet.g, sx , sy);
          }
          else //If player attemps to move beyond the left border, prevent it by adding 14 to player position x
          {
            player.addX(14);
            //sprite = player.getCurrentSprite();
            map.draw(applet.g, sx , sy);
          }
        }
      }
      
      
      //Checks the depth images and then draws them based on height priority queue 
      if (enemy != null)
      {
         for(int num = 0; num < enemy.length; num++) 
         {
           enemy[num].drawEnemy(player);
           for(int count = 0; count < enemy.length; count++) 
           {
             if (num != count && enemy[num].getCurrentSprite() != null)
               enemy[num].checkDistanceBetweenEnemy(enemy[count]);  //Helps stop enemies from stacking when fighting player
           }  
           player.checkIfPlayerWasHit(enemy[num]);
         }  
         
         checkDepth();
         Iterator itr = q.iterator();
         while (itr.hasNext())
         {
           Image temp = (Image) itr.next();
           int num = temp.getKey();
           
           itr.remove();
            
           if (num != enemy.length)
           {
             sprite = enemy[num].getCurrentSprite();
             
             if (sprite != null)
               image(sprite, enemy[num].currentEnemyPositionX(),enemy[num].currentEnemyPositionY()); 
           }
           else
           {
             sprite = player.getCurrentSprite();
             if (sprite != null)
               image(sprite, player.currentPlayerPositionX(),player.currentPlayerPositionY()); //Draw Player
           }
         }
      }
      else
      {
        sprite = player.getCurrentSprite();
        image(sprite, player.currentPlayerPositionX(),player.currentPlayerPositionY());
        if (player.getIsKnocked())
        {
          if (player.currentPlayerPositionX() <= leftSideBorder)
          {
            player.setX((int)leftSideBorder);
          }
          else if ((player.currentPlayerPositionX() >  rightSideBorder + 190))
          {
            player.setX((int)rightSideBorder + 190);
          }
        }
      }
      
      textSize(32);
      text(player.getHealth(), width/2, 60);
    }
  
  //Setters
  public void setSX(int sx)
  {
    this.sx = sx;
  }
  
  public void setSY(int sy)
  {
    this.sy = sy;
  }
  
  //Getters
  public int getSX()
  {
    return this.sx;
  }
  
  public int getSY()
  {
    return this.sy;
  }
  
  public float getLeftSideBorder()
  {
    return this.leftSideBorder;
  }
  
  public float getRightSideBorder()
  {
    return this.rightSideBorder;
  }
  
  public Ptmx getMap()
  {
    return this.map;
  }
  
  public Player getPlayer()
  {
    return this.player;
  }
  
  //Check and prioritize drawing queue based on height (the higher the y position of image, the higher priority it has)
  private void checkDepth()
  {
    for(int num = 0; num <= enemy.length ; num++)
    {
      if( num < enemy.length) //For Enemy height
      {
        float enemyHeight = enemy[num].currentEnemyPositionY();
        q.add(new Image(num, enemyHeight - 15));
      }
      else //For Player Height
      {
        q.add(new Image(num, player.currentPlayerPositionY()));
      } 
    }
  }
  
  private class Image 
  {
    private int key;
    private float positionY;
    
    public Image(int key, float positionY) {
        this.key = key;
        this.positionY = positionY;
    }

    // getters
    public int getKey()
    {
      return this.key;
    }
    
    public float getPositionY()
    {
      return this.positionY;
    }
  }
  
}