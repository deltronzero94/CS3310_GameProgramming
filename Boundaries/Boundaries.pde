//Global Member Variables
//Player p;
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
  //p = new Player();
  
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
    //p.isPlayerIdle();
    //p.playerMovement();
    //print(frameRate + "\n");
    map.drawMap();
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
      map.getPlayer().setLeft(true);
      map.getPlayer().setLastLeft(true);
    }
    if(keyCode == RIGHT)
    {
      map.getPlayer().setRight(true);
      map.getPlayer().setLastLeft(false);
    }
    if(keyCode == UP)
    {
      map.getPlayer().setUp(true);
    }
    if(keyCode == DOWN) 
    {
      map.getPlayer().setDown(true);
    }
    
    
    if(map.getPlayer().isKeyPressed() && key != 'z')//Player moving
    {
      map.getPlayer().setIsAttacking(false);
      map.getPlayer().setIsIdle(false);
      map.getPlayer().setIsMoving(true);
      //print("Player is moving\n");
    }
    else if(key == 'z')
    {
       print("******************************\nZ was hit\n******************************\n");
      map.getPlayer().setIsAttacking(true);
      map.getPlayer().setIsIdle(false);
      map.getPlayer().setIsMoving(false);
      print(map.getPlayer().getTimeBetweenAttack()+"\n");
    }
    else
    {
      map.getPlayer().setIsAttacking(false);
      map.getPlayer().setIsIdle(true);
      map.getPlayer().setIsMoving(false);
    }
  }
}

void keyReleased(){
  if (isGameScreen)
  {
    if(keyCode == LEFT) 
    {
      map.getPlayer().setLeft(false);
      map.getPlayer().setLastLeft(true);
    }
    if(keyCode == RIGHT)
    {
      map.getPlayer().setRight(false);
      map.getPlayer().setLastLeft(false);
    }
    if(keyCode == UP)
    {
     map.getPlayer().setUp(false);
    }
    if(keyCode == DOWN) 
    {
      map.getPlayer().setDown(false);
    }
    
    if(map.getPlayer().isKeyReleased() && key != 'z') //Player just moving and not attacking
    {
      map.getPlayer().setIsIdle(true);
      map.getPlayer().setIsAttacking(false);
      map.getPlayer().setIsMoving(false);
    } 
    else if (key == 'z' && map.getPlayer().isKeyPressed()) //Attacking while moving
    {
      map.getPlayer().setIsAttacking(false);
      map.getPlayer().setIsIdle(false);
      map.getPlayer().setIsMoving(true);
    }
    else if (key == 'z' && map.getPlayer().isKeyReleased() ) //Attacking while standing still
    {
      map.getPlayer().setIsAttacking(false);
      map.getPlayer().setIsIdle(true);
      map.getPlayer().setIsMoving(false);
    }
  }
}

void drawTitleScreen()
{
    
  
  
}

void drawCreditScreen()
{
  
}