//Global Member Variables
Player p;
TiledMap map;

void setup()
{
  //fullScreen();
  size(600,340);

  map = new TiledMap(this);
  p = new Player();
  
  imageMode(CENTER);
  noCursor();  // hide the mouse cursor
  frameRate(24);  
}

void draw()
{  
  scale(.35);
  background(map.getMap().getBackgroundColor());
  fill(128);
  
  p.isPlayerIdle();
  p.playerMovement();
  map.drawMap(p);
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
  if(keyCode == UP)
  {
    p.setUp(true);
  }
  if(keyCode == DOWN) 
  {
    p.setDown(true);
  }
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
  }
  if(keyCode == DOWN) 
  {
    p.setDown(false);
  }
  if(p.isKeyReleased())
  {
    p.setIsIdle(true);
    p.setIsMoving(false);
  }
}