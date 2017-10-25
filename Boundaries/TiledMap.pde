import ptmx.*;

public class TiledMap
{
  //Declared Member Variables
  private int sx, sy;  //Screen Position X and Y
  private float leftSideBorder, rightSideBorder;  //Edge of the Screen
  private Ptmx map;
  private PApplet applet;
  private Player player;
  
  //Default Constructor
  public TiledMap(PApplet applet)
  {
    this.applet = applet;
    sx = 300;
    sy = 170;
    leftSideBorder = 50.0;
    rightSideBorder = 1650.0;
    player = new Player();
    
    map = new Ptmx(applet,"sor2_1v3.tmx");
    map.setDrawMode(CENTER);
    map.setPositionMode("CANVAS");//Default Position Mode
  }
  
  //Public Methods/Functions
  public void drawMap()
  { 
    //Draw Player
    player.isPlayerIdle();
    player.playerMovement();
    
    float px = player.getPX();
    int x = player.getX();
    int topBorder;
    
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
          PImage sprite = player.getCurrentSprite();
          map.draw(applet.g, sx , sy);
          
          if (player.currentPlayerPositionX() >rightSideBorder) //If player goes beyond right boundary screen
          {
            player.addX(-14);
          }
          image(sprite, player.currentPlayerPositionX(), player.currentPlayerPositionY());  //Centers image to screen.
        }
        else //Standing Still/Before Halfway point 
        { 
          PImage sprite = player.getCurrentSprite();
          map.draw(applet.g, sx , sy);
          image(sprite, player.currentPlayerPositionX(), player.currentPlayerPositionY());  
        }
      }
      else //When Going Beyond left boundary 
      { 
        
        if (player.getLeft())
        {
          player.addX(14);
          PImage sprite = player.getCurrentSprite();
          map.draw(applet.g, sx , sy);
          image(sprite, player.currentPlayerPositionX() , player.currentPlayerPositionY());  
        }
        else
        {
          PImage sprite = player.getCurrentSprite();
          map.draw(applet.g, sx , sy);
          image(sprite, player.currentPlayerPositionX(), player.currentPlayerPositionY()); 
        }
      }
    }
    else
    {
      if ( width/4 + x + px/3  > sx + px + width/4) //When Crossing midway point
        {
          PImage sprite = player.getCurrentSprite();
          map.draw(applet.g, sx , sy);
          
          if (player.currentPlayerPositionX() >rightSideBorder) //If player goes beyond right boundary screen
          {
            player.addX(-14);
          }
          image(sprite, player.currentPlayerPositionX(),player.currentPlayerPositionY());  //Centers image to screen.
        }
        else //Standing Still/Before Halfway point 
        { 
          if (player.currentPlayerPositionX() > leftSideBorder)
          {
            
            PImage sprite = player.getCurrentSprite();
            map.draw(applet.g, sx , sy);
            image(sprite, player.currentPlayerPositionX(), player.currentPlayerPositionY());  
          }
          else //If player attemps to move beyond the left border, prevent it by adding 14 to player position x
          {
            player.addX(14);
            PImage sprite = player.getCurrentSprite();
            map.draw(applet.g, sx , sy);
            image(sprite, leftSideBorder , player.currentPlayerPositionY());
          }
        }
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
}