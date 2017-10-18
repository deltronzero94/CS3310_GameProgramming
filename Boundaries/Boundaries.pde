import ptmx.*;

//Global Member Variables
PImage player;
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
  //isPlayerIdle();
  //fullScreen();
  size(600,340);
  pushMatrix();

  map = new Ptmx(this, "sor2_1v3.tmx");
  map.setDrawMode(CENTER);
  map.setPositionMode("CANVAS");//Default Position Mode
  x = int(map.mapToCanvas(map.getMapSize()).x / 12);
  y = int(map.mapToCanvas(map.getMapSize()).y / 6);
  
  popMatrix();
  
  imageMode(CENTER);
  noCursor();  // hide the mouse cursor
  frameRate(24);  
}

void draw()
{  
  scale(.35);
  //isPlayerIdle();

  background(map.getBackgroundColor());
  //map.draw(this.g, x, y);
  fill(128);
  isPlayerIdle();
  
  int a = frameCount % DIM * W; //Divide
  int b = 0;
  
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
  
  print("\nPX\n");
  print(width + x - px);
  print("\nSX\n");
  print(sx - width/4 + 50);
  print("\nLeftScreenBorder\n");
  print(leftSideBorder);
  print("\n");
  
  if  (rightSideBorder < 1656.6)
  {
    //If player movement is greater than left screen boundary
    if (width + x - px >leftSideBorder)
    { 
      if ( width/4 + x + px/3  > sx + px + width/4) //When Crossing midway point
      {
        leftSideBorder+= 0.01;
        rightSideBorder+=0.01;
        sx+= 2;
        px+= 6;
        PImage sprite = player.get(a, b, W, H);
        map.draw(this.g, sx , sy);
        
        if (width + x - px >rightSideBorder) //If player goes beyond right boundary screen
        {
          x-=14;
        }
        image(sprite, width + x - px, height*1.35 + y);  //Centers image to screen.
      }
      else //Standing Still/Before Halfway point 
      { 
        PImage sprite = player.get(a, b, W, H);
        map.draw(this.g, sx , sy);
        image(sprite, width + x - px, height*1.35 + y);  
      }
    }
    else //When Going Beyond left boundary (NEEDS TO BE WORKED ON!!!)
    { 
      
      if (left)
      {
        x+=14;
        PImage sprite = player.get(a, b, W, H);
        map.draw(this.g, sx , sy);
        image(sprite, leftSideBorder , height*1.35 + y);  
      }
      else
      {
        PImage sprite = player.get(a, b, W, H);
        map.draw(this.g, sx , sy);
        image(sprite, width + x - px, height*1.35 + y); 
      }
    }
  }
  else
  {
    if ( width/4 + x + px/3  > sx + px + width/4) //When Crossing midway point
      {
        //sx+= 2;
        //px+= 6;
        PImage sprite = player.get(a, b, W, H);
        map.draw(this.g, sx , sy);
        
        if (width + x - px >rightSideBorder) //If player goes beyond right boundary screen
        {
          x-=14;
        }
        image(sprite, width + x - px, height*1.35 + y);  //Centers image to screen.
      }
      else //Standing Still/Before Halfway point 
      { 
        if (width + x - px > leftSideBorder)
        {
          
          PImage sprite = player.get(a, b, W, H);
          map.draw(this.g, sx , sy);
          image(sprite, width + x - px, height*1.35 + y);  
        }
        else
        {
          x+=14;
          PImage sprite = player.get(a, b, W, H);
          map.draw(this.g, sx , sy);
          image(sprite, leftSideBorder , height*1.35 + y);
        }
      }
  }
}

void isPlayerIdle()
{
  if (isIdle)
  {    
    if (lastLeft && !right)
    {
      player = loadImage("idle3.png");
      DIM = 12;
      W = player.width/DIM;
      H = player.height;
    }
    else
    {
      player = loadImage("idle3_R.png");
      DIM = 12;
      W = player.width/DIM;
      H = player.height;
    }     
  }
  else
  {
    if (!left)
    {
      player = loadImage("walk_right.png");
      DIM = 24;
      W = player.width/DIM;
      H = player.height;
    }
    else
    {
      player = loadImage("walk.png");
      DIM = 24;
      W = player.width/DIM;
      H = player.height;
    }
  }
}

void keyPressed(){
  if(keyCode == LEFT)
  {
    left = true;
    lastLeft = true;
  }
  if(keyCode == RIGHT)
  {
    right = true;
    lastLeft = false;
  }
  if(keyCode == UP) up = true;
  if(keyCode == DOWN) down = true;
  if(left || right || up || down)
  {
    isIdle = false;
    isMoving = true;
  }
}

void keyReleased(){
  if(keyCode == LEFT) 
  {
    left = false;
    lastLeft = true;
  }
  if(keyCode == RIGHT)
  {
    right = false;
    lastLeft = false;
  }
  if(keyCode == UP)
  {
    up = false;
    //lastLeft = false;
  }
  if(keyCode == DOWN) 
  {
    down = false;
    //lastLeft = false;
  }
  if(!left && !right && !up && !down)
  {
    isIdle = true;
    isMoving = false;
  }
}