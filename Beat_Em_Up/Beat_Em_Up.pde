//Global Member Variables
PImage player;
PImage level;
int DIM; //How space they are in the jpeg file
int W;
int H;
int x = 100, y = 100;
boolean left, right, up, down;
boolean isIdle = true, isAttacking = false, isMoving = false;
boolean lastLeft = false;

void setup()
{
  isPlayerIdle();
  fullScreen();
  camera(70.0, 35.0, 120.0,PosX(), PosY(), 0.0, 0.0, 1.0, 0.0);
  //level = loadImage("StreetsOfRage2-Stage1.png");
  //imageMode(CENTER); //use the center of the image to represent the image location
  noCursor();  // hide the mouse cursor
  frameRate(24); 
}

void draw()
{
  //x = constrain(x, 0, level.width - width);
  //y = constrain(y, 0, level.height - height);
  //image(level, -x, -y); 
  
  println(frameCount);
  isPlayerIdle();
  background(0);
  int a = frameCount % DIM * W; //Divide
  int b = 0;;
  //PImage sprite = player.get(a, b, W, H);
  
  if(left)
  {
    x -= 7;
  }
  if(right)
  {
    x += 7;
  }
  if(up)
  {
    y -= 8;
  }
  if(down)
  {
    y += 8;
  }
     
  PImage sprite = player.get(a, b, W, H);
  
  image(sprite, x, y);
}

void isPlayerIdle()
{
  if (isIdle)
  {
    
    if (lastLeft)
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
    if (!lastLeft)
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

int PosX(){
  return  x;
}
 
int PosY(){
  return y;
}


public PImage getReversePImage( PImage image ) {
 PImage reverse = new PImage( image.width, image.height );
 for( int i=0; i < image.width; i++ ){
   for(int j=0; j < image.height; j++){
     reverse.set( image.width - 10 - i, j, image.get(i, j) );
   }   
 }
 return reverse;
}