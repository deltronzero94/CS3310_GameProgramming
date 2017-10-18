import ptmx.*;

//Global Member Variables
//PImage player;
Player p;
Ptmx map;
int DIM; //How space they are in the jpeg file
int W;
int H;
int x = 100, y = 100;
boolean left, right, up, down;
boolean isIdle = true, isAttacking = false, isMoving = false;
boolean lastLeft = false;
int sx = 300; //Screen Postion X
int sy = 170; // Screen positon y
float px = width; //Adjust player position x when screen moves
float py =  height*1.35; //Adjust player position y when screen moves
float leftSideBorder = 50.0; //Left Edge of the screen
float rightSideBorder = 1650.0; //Left Edge of the screen

void setup()
{
  //fullScreen();
  size(600,340);
  pushMatrix();

  map = new Ptmx(this, "sor2_1v3.tmx");
  map.setDrawMode(CENTER);
  map.setPositionMode("CANVAS");//Default Position Mode
  x = int(map.mapToCanvas(map.getMapSize()).x / 12);
  y = int(map.mapToCanvas(map.getMapSize()).y / 6);
  
  popMatrix();
  
  p = new Player();
  
  imageMode(CENTER);
  noCursor();  // hide the mouse cursor
  frameRate(24);  
}

void draw()
{  
  scale(.35);

   background(255); //TESTING
  //background(map.getBackgroundColor());
  //map.draw(this.g, x, y);
  //fill(128);
  
  p.isPlayerIdle();
  p.playerMovement();
  
  
  //print("\nPX\n");
  //print(width + x - px);
  //print("\nSX\n");
  //print(sx - width/4 + 50);
  //print("\nLeftScreenBorder\n");
  //print(leftSideBorder);
  //print("\n");
  
  //if  (rightSideBorder < 1656.6)
  //{
  //  //If player movement is greater than left screen boundary
  //  if (width + x - px >leftSideBorder)
  //  { 
  //    if ( width/4 + x + px/3  > sx + px + width/4) //When Crossing midway point
  //    {
  //      leftSideBorder+= 0.01;
  //      rightSideBorder+=0.01;
  //      sx+= 2;
  //      px+= 6;
  //      PImage sprite = player.get(a, b, W, H);
  //      map.draw(this.g, sx , sy);
        
  //      if (width + x - px >rightSideBorder) //If player goes beyond right boundary screen
  //      {
  //        x-=14;
  //      }
  //      image(sprite, width + x - px, height*1.35 + y);  //Centers image to screen.
  //    }
  //    else //Standing Still/Before Halfway point 
  //    { 
  //      PImage sprite = player.get(a, b, W, H);
  //      map.draw(this.g, sx , sy);
  //      image(sprite, width + x - px, height*1.35 + y);  
  //    }
  //  }
  //  else //When Going Beyond left boundary (NEEDS TO BE WORKED ON!!!)
  //  { 
      
  //    if (left)
  //    {
  //      x+=14;
  //      PImage sprite = player.get(a, b, W, H);
  //      map.draw(this.g, sx , sy);
  //      image(sprite, leftSideBorder , height*1.35 + y);  
  //    }
  //    else
  //    {
  //      PImage sprite = player.get(a, b, W, H);
  //      map.draw(this.g, sx , sy);
  //      image(sprite, width + x - px, height*1.35 + y); 
  //    }
  //  }
  //}
  //else
  //{
  //  if ( width/4 + x + px/3  > sx + px + width/4) //When Crossing midway point
  //    {
  //      //sx+= 2;
  //      //px+= 6;
  //      PImage sprite = player.get(a, b, W, H);
  //      map.draw(this.g, sx , sy);
        
  //      if (width + x - px >rightSideBorder) //If player goes beyond right boundary screen
  //      {
  //        x-=14;
  //      }
  //      image(sprite, width + x - px, height*1.35 + y);  //Centers image to screen.
  //    }
  //    else //Standing Still/Before Halfway point 
  //    { 
  //      if (width + x - px > leftSideBorder)
  //      {
          
  //        PImage sprite = player.get(a, b, W, H);
  //        map.draw(this.g, sx , sy);
  //        image(sprite, width + x - px, height*1.35 + y);  
  //      }
  //      else
  //      {
  //        x+=14;
  //        PImage sprite = player.get(a, b, W, H);
  //        map.draw(this.g, sx , sy);
  //        image(sprite, leftSideBorder , height*1.35 + y);
  //      }
  //    }
  //}
}

void keyPressed(){
  if(keyCode == LEFT)
  {
    p.setLeft(true);
    p.setLastLeft(true);
  }
  if(keyCode == RIGHT)
  {
    p.setRight(true);
    p.setLastLeft(false);
  }
  if(keyCode == UP) p.setUp(true);
  if(keyCode == DOWN) p.setDown(true);
  if(p.isKeyPressed())
  {
    p.setIsIdle(false);
    p.setIsMoving(true);
  }
}

void keyReleased(){
  if(keyCode == LEFT) 
  {
    p.setLeft(false);
    p.setLastLeft(true);
  }
  if(keyCode == RIGHT)
  {
    p.setRight(false);
    p.setLastLeft(false);
  }
  if(keyCode == UP)
  {
   p.setUp(false);
    //lastLeft = false;
  }
  if(keyCode == DOWN) 
  {
    p.setDown(false);
    //lastLeft = false;
  }
  if(p.isKeyReleased())
  {
    p.setIsIdle(true);
    p.setIsMoving(false);
  }
}