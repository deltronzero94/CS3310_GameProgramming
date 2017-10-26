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
  
  private PriorityQueue<Entry> q;
  
  //Default Constructor
  public TiledMap(PApplet applet)
  {
    this.applet = applet;
    sx = 300;
    sy = 170;
    leftSideBorder = 50.0;
    rightSideBorder = 1650.0;
    player = new Player();
    enemy = new Enemy[]{new Enemy(200, 200, 1), new Enemy(500,50), new Enemy(1000,200)};
    
    map = new Ptmx(applet,"sor2_1v3.tmx");
    map.setDrawMode(CENTER);
    map.setPositionMode("CANVAS");//Default Position Mode
  }
  
  //Public Methods/Functions
  public void drawMap()
  { 
    //Check State of Player
    player.isPlayerIdle();
    player.playerMovement();
    
    float px = player.getPX();
    int x = player.getX();
    int topBorder;
    PImage sprite;
    
    //Prevents player from moving beyond top boundary/walls
    PVector overTile = map.canvasToMap(player.currentPlayerPositionX(), player.currentPlayerPositionY());
    topBorder = map.getTileIndex(0, round(overTile.x), round(overTile.y));
   
    if(topBorder == -1 || (topBorder>10000 && topBorder < 16000 ))
    {
      player.setY(45);
    }
    
    if  (rightSideBorder < 1656.6) //If screen hasn't reached the end of the map
    {
      //If player movement is greater than left screen boundary
      if (player.currentPlayerPositionX() >leftSideBorder)
      { 
        if ( width/4 + x + px/3  > sx + px + width/4 + 100) //When Crossing midway point
        {
          leftSideBorder+= 0.01;
          rightSideBorder+=0.01;
          sx+= 2;
          player.addPX(6);
          
          for (int num = 0; num < enemy.length; num++)
             enemy[num].addPX(6);
             
          sprite = player.getCurrentSprite();
          map.draw(applet.g, sx , sy);
          
          if (player.currentPlayerPositionX() >rightSideBorder) //If player goes beyond right boundary screen
          {
            player.addX(-14);
          }
          //image(sprite, player.currentPlayerPositionX(), player.currentPlayerPositionY());  //Centers image to screen.
        }
        else //Standing Still/Before Halfway point 
        { 
          sprite = player.getCurrentSprite();
          map.draw(applet.g, sx , sy);
          //image(sprite, player.currentPlayerPositionX(), player.currentPlayerPositionY());  
        }
      }
      else //When Going Beyond left boundary 
      { 
        
        if (player.getLeft())
        {
          player.addX(14);
          sprite = player.getCurrentSprite();
          map.draw(applet.g, sx , sy);
          //image(sprite, player.currentPlayerPositionX() , player.currentPlayerPositionY());  
        }
        else
        {
          sprite = player.getCurrentSprite();
          map.draw(applet.g, sx , sy);
          //image(sprite, player.currentPlayerPositionX(), player.currentPlayerPositionY()); 
        }
      }
    }
    else
    {
      if ( width/4 + x + px/3  > sx + px + width/4) //When Crossing midway point
        {
          sprite = player.getCurrentSprite();
          map.draw(applet.g, sx , sy);
          
          if (player.currentPlayerPositionX() >rightSideBorder) //If player goes beyond right boundary screen
          {
            player.addX(-14);
          }
          //image(sprite, player.currentPlayerPositionX(),player.currentPlayerPositionY());  //Centers image to screen.
        }
        else //Standing Still/Before Halfway point 
        { 
          if (player.currentPlayerPositionX() > leftSideBorder)
          {
            
            sprite = player.getCurrentSprite();
            map.draw(applet.g, sx , sy);
            image(sprite, player.currentPlayerPositionX(), player.currentPlayerPositionY());  
          }
          else //If player attemps to move beyond the left border, prevent it by adding 14 to player position x
          {
            player.addX(14);
            sprite = player.getCurrentSprite();
            map.draw(applet.g, sx , sy);
            //image(sprite, player.currentPlayerPositionX() , player.currentPlayerPositionY());
          }
        }
      }
      
      //Checks the depth images and then draws them based on height priority queue 
      checkDepth();
       Iterator itr = q.iterator();
       while (itr.hasNext())
       {
         int num = ((Entry) itr.next()).getKey();

         if (num != enemy.length)
           enemy[num].drawEnemy();
         else
           image(sprite, player.currentPlayerPositionX(),player.currentPlayerPositionY());
       }
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
    q = new PriorityQueue<Entry>(enemy.length, new Comparator<Entry>() {
    public int compare(Entry edge1, Entry edge2) {
        if (edge1.getValue() < edge2.getValue()) return -1;
        if (edge1.getValue() > edge2.getValue()) return 1;
        return 0;
    } });
    
    for(int num = 0; num <= enemy.length ; num++)
    {
      if( num < enemy.length) //For Enemy height
      {
        float enemyHeight = enemy[num].currentEnemyPositionY();
        q.add(new Entry(num, enemyHeight));
      }
      else //For Player Height
      {
        q.add(new Entry(num, player.currentPlayerPositionY()));
      } 
    }
  }
  
  private class Entry 
  {
    private int key;
    private float value;
    
    
    public Entry(int key, float value) {
        this.key = key;
        this.value = value;
    }

    // getters
    public int getKey()
    {
      return this.key;
    }
    
    public float getValue()
    {
      return this.value;
    }
  }
  
}