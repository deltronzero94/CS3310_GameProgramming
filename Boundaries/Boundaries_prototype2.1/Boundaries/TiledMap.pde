import ptmx.*;
import java.util.*;
static float rectWidth = 500;

public class TiledMap
{
  //Declared Member Variables
  private int sx, sy;  //Screen Position X and Y
  private float leftSideBorder, rightSideBorder;  //Edge of the Screen
  private Ptmx map;
  private PApplet applet;
  private Player player;
 // private Enemy[] enemy;
  private ArrayList<Enemy> e;
  private int spawn;
  private boolean bossSpawned;
  private boolean gameOver;
  
  private PriorityQueue<Image> q;
  
  //Default Constructor
  public TiledMap(PApplet applet)
  {
    gameOver = false;
    this.applet = applet;
    sx = 1000;  //sx = 300
    sy = 550;  //sy = 170
    leftSideBorder = 50.0;
    rightSideBorder = 1660.0;  //1650
    player = new Player();
    //enemy = new Enemy[]{new Enemy(200, -700, 1), new Enemy(500,-700,1), new Enemy(1000,-700,1), new Enemy(1000,-700,1), new Enemy(800, -700)};
   // enemy = new Enemy[]{new Enemy(800,-700, 1)};
    map = new Ptmx(applet,"sor2_1v4.tmx");
    map.setDrawMode(CENTER);
    map.setPositionMode("CANVAS");//Default Position Mode
    e = new ArrayList<Enemy>();
    e.add(new Enemy(800,-700));    
    spawn = 1;
    bossSpawned=false;
    q = new PriorityQueue<Image>(e.size(), new Comparator<Image>() {
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
    
    //print(spawn + "\n");
    if (spawn % 150 == 0)
    {
      spawn = 1;
      e.add(new Enemy((int)rightSideBorder + 150, -700, 1));
      e.add(new Enemy((int)rightSideBorder + 150, -800));
      e.add(new Enemy((int)rightSideBorder + 150, -650,1));
      //print(e.size() + "\n");
    }
    
    
    if (rightSideBorder < 1681.0) //If screen hasn't reached the end of the map
    {
      //If player movement is greater than left screen boundary
      if (player.currentPlayerPositionX() >leftSideBorder)
      { 
        if ( width/4 + x + px/3  > px/3 + sx+ width/4 ) //When Crossing midway point
        {
          leftSideBorder+= 0.04;
          rightSideBorder+=0.04;
          spawn += 1;
          sx+= 4;
          player.addPX(4);
          
          if ( e != null)
          {
            for (int num = 0; num < e.size(); num++)
               e.get(num).addPX(4);
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
        
        if (noEnemies())
        {
            if (bossSpawned==false)
            {
              getSome.play();
              e.add(new Enemy(round(player.currentPlayerPositionX()),round(player.currentPlayerPositionY()),2));
            }
            bossSpawned=true;
            if (noEnemies()&&(bossSpawned==true))
            {
              e = null;
              gameOver = true;
            }
        }
      }
      
      
      //Checks the depth images and then draws them based on height priority queue 
      if (e != null)
      {
         for(int num = 0; num < e.size(); num++) 
         {
           e.get(num).drawEnemy(player);
           for(int count = 0; count < e.size(); count++) 
           {
             if (num != count && e.get(num).getCurrentSprite() != null)
               e.get(num).checkDistanceBetweenEnemy(e.get(count));  //Helps stop enemies from stacking when fighting player
           }  
           player.checkIfPlayerWasHit(e.get(num));
         }  
         
         checkDepth();
         Iterator itr = q.iterator();
         while (itr.hasNext())
         {
           Image temp = (Image) itr.next();
           int num = temp.getKey();
           
           itr.remove();
            
           if (num != e.size())
           {
             sprite = e.get(num).getCurrentSprite();
             
             if (sprite != null)
               image(sprite, e.get(num).currentEnemyPositionX(),e.get(num).currentEnemyPositionY()); 
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
      }
      
      
      //Delete Enemy with 0 Health
      checkEnemyHealth();
     
      //Draw Player HealthBar
      drawPlayerHealthBar();
    }
    
    public boolean getGameOver()
    {
      return this.gameOver;
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
  
  public boolean noEnemies()
  {
    if (e.size() == 0)
    {
      return true;
    }
    else 
    {
      return false;
    }
  }
  
  //Check and prioritize drawing queue based on height (the higher the y position of image, the higher priority it has)
  private void checkDepth()
  {
    for(int num = 0; num <= e.size() ; num++)
    {
      if( num < e.size()) //For Enemy height
      {
        float enemyHeight = e.get(num).currentEnemyPositionY();
        q.add(new Image(num, enemyHeight - 15));
      }
      else //For Player Height
      {
        q.add(new Image(num, player.currentPlayerPositionY()));
      } 
    }
  }
  
  private void drawPlayerHealthBar()
  {
      // Outline
      stroke(0);
      fill(255,0,0);
      rect(100, 100, rectWidth, 50);
    
      fill(255, 255, 0);
      // Draw bar
      noStroke();
      // Get fraction 0->1 and multiply it by width of bar
      float drawWidth = ((float)player.getHealth() / 300.0) * rectWidth;
      rect(100, 100, drawWidth, 50);
      
  }
  
  private void checkEnemyHealth()
  {
    if( e != null)
    {
      for (int x = 0; x < e.size(); x++)
      {
        if (e.get(x).getHealth() <= 0 && e.get(x).isDeathAnimationFinished())
        {
          e.remove(x);
        }
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