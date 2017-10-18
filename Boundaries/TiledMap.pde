import ptmx.*;

public class TiledMap
{
  //Declared Member Variables
  private int sx, sy;  //Screen Position X and Y
  private float leftSideBorder, rightSideBorder;  //Edge of the Screen
  private Ptmx map;
  private PApplet applet;
  
  //Default Constructor
  public TiledMap(PApplet applet)
  {
    this.applet = applet;
    sx = 300;
    sy = 170;
    leftSideBorder = 50.0;
    rightSideBorder = 1650.0;
    
    map = new Ptmx(applet,"sor2_1v3.tmx");
    map.setDrawMode(CENTER);
    map.setPositionMode("CANVAS");//Default Position Mode
  }
  
  //Public Methods/Functions
  public void drawMap(Player p)
  {  
    float px = p.getPX();
    int x = p.getX();
    
    if  (rightSideBorder < 1656.6) //If screen hasn't reached the end of the map
    {
      //If player movement is greater than left screen boundary
      if (p.currentPlayerPositionX() >leftSideBorder)
      { 
        if ( width/4 + x + px/3  > sx + px + width/4 + 100) //When Crossing midway point
        {
          leftSideBorder+= 0.01;
          rightSideBorder+=0.01;
          sx+= 2;
          p.addPX(6);
          PImage sprite = p.getCurrentSprite();
          map.draw(applet.g, sx , sy);
          
          if (p.currentPlayerPositionX() >rightSideBorder) //If player goes beyond right boundary screen
          {
            p.addX(-14);
          }
          image(sprite, p.currentPlayerPositionX(), p.currentPlayerPositionY());  //Centers image to screen.
        }
        else //Standing Still/Before Halfway point 
        { 
          PImage sprite = p.getCurrentSprite();
          map.draw(applet.g, sx , sy);
          image(sprite, p.currentPlayerPositionX(), p.currentPlayerPositionY());  
        }
      }
      else //When Going Beyond left boundary 
      { 
        
        if (p.getLeft())
        {
          p.addX(14);
          PImage sprite = p.getCurrentSprite();
          map.draw(applet.g, sx , sy);
          image(sprite, leftSideBorder , p.currentPlayerPositionY());  
        }
        else
        {
          PImage sprite = p.getCurrentSprite();
          map.draw(applet.g, sx , sy);
          image(sprite, p.currentPlayerPositionX(), p.currentPlayerPositionY()); 
        }
      }
    }
    else
    {
      if ( width/4 + x + px/3  > sx + px + width/4) //When Crossing midway point
        {
          PImage sprite = p.getCurrentSprite();
          map.draw(applet.g, sx , sy);
          
          if (p.currentPlayerPositionX() >rightSideBorder) //If player goes beyond right boundary screen
          {
            p.addX(-14);
          }
          image(sprite, p.currentPlayerPositionX(),p.currentPlayerPositionY());  //Centers image to screen.
        }
        else //Standing Still/Before Halfway point 
        { 
          if (p.currentPlayerPositionX() > leftSideBorder)
          {
            
            PImage sprite = p.getCurrentSprite();
            map.draw(applet.g, sx , sy);
            image(sprite, p.currentPlayerPositionX(), p.currentPlayerPositionY());  
          }
          else //If player attemps to move beyond the left border, prevent it by adding 14 to player position x
          {
            p.addX(14);
            PImage sprite = p.getCurrentSprite();
            map.draw(applet.g, sx , sy);
            image(sprite, leftSideBorder , p.currentPlayerPositionY());
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
}