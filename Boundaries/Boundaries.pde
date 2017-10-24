//Global Member Variables
Player p;
TiledMap map;
boolean isTitleScreen, isGameScreen, isCreditScreen, isGamePause;

void setup()
{
  //fullScreen();
  size(600,340);
 
 //Probably Needs to changed (NEED 1 SINGLE VARIABLE RATHER THAN 4) -------
  isTitleScreen = false;
  isGameScreen = true;
  isGamePause = false;
  isCreditScreen = false;
  // ---------------------------------------
  
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
  
  if (isTitleScreen) //Title Screen Mode
  {
 
  }
  else if (isGameScreen) //Game Screen Mode
  {
    p.isPlayerIdle();
    p.playerMovement();
    map.drawMap(p);
  }
  else if (isCreditScreen) //Credit Screen Mode
  {
    
  }
  
}

void keyPressed(){
  if(isGameScreen)
  {
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
    
    
    if(p.isKeyPressed() && key != 'z')//Player moving
    {
      p.setIsAttacking(false);
      p.setIsIdle(false);
      p.setIsMoving(true);
      print("Inside the other\n");
    }
    else if(key == 'z')
    {
      p.setIsAttacking(true);
      p.setIsIdle(false);
      p.setIsMoving(false);
      print(p.getTimeBetweenAttack()+"\n");
    }
    else
    {
      p.setIsAttacking(false);
      p.setIsIdle(true);
      p.setIsMoving(false);
    }
  }
}

void keyReleased(){
  if (isGameScreen)
  {
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
    
    if(p.isKeyReleased() && key != 'z') //Player just moving and not attacking
    {
      p.setIsIdle(true);
      p.setIsAttacking(false);
      p.setIsMoving(false);
    } 
    else if (key == 'z' && p.isKeyPressed()) //Attacking while moving
    {
      p.setIsAttacking(false);
      p.setIsIdle(false);
      p.setIsMoving(true);
    }
    else if (key == 'z' && p.isKeyReleased() ) //Attacking while standing still
    {
      p.setIsAttacking(false);
      p.setIsIdle(true);
      p.setIsMoving(false);
    }
  }
}

void drawTitleScreen()
{
    
  
  
}