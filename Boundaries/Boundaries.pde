import ddf.minim.*;

//Global Member Variables
TiledMap map;
Minim minim;
AudioPlayer player;
AudioInput input;
PImage bg;
PFont titleFont;

boolean isTitleScreen, isGameScreen, isCreditScreen, isGamePause;

void setup()
{
  fullScreen();
  //size(600,340);
  
  //Audio Player
  minim = new Minim(this);
  player = minim.loadFile("soldiers.mp3");
  input = minim.getLineIn();
  
  //titleScreen image
  bg = loadImage("skyline.png");
  image(bg, 0, 0, width, height);
  titleFont = createFont("ARCADECLASSIC.TTF", 32);
  
 
 //Probably Needs to changed (NEED 1 SINGLE VARIABLE RATHER THAN 4) -------
  isTitleScreen = true;
  isGameScreen = false;
  isGamePause = false;
  isCreditScreen = false;
  // ---------------------------------------
  
  map = new TiledMap(this);
  
  imageMode(CENTER);
  noCursor();  // hide the mouse cursor
  frameRate(24);  
}

void draw()  
{  
  //scale(.35);
  //background(map.getMap().getBackgroundColor());
  //fill(128);
  ///print(frameRate + "\n");
  
  if (isTitleScreen) //Title Screen Mode
  {
    
    drawTitleScreen("Road of Anger", "Press Space to Start");
  
    
  }
  else if (isGameScreen) //Game Screen Mode
  {
    //print(frameRate + "\n");
    map.drawMap();
  }
  else if (isCreditScreen) //Credit Screen Mode
  {
    
  }
  
}

void keyPressed(){
  if(isTitleScreen && key == ' '){
    isGameScreen = true;
    isTitleScreen = false;
  }
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
      map.getPlayer().setIsAttacking(false);
      map.getPlayer().setIsIdle(true);
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

void drawTitleScreen(String title, String instructions)
{
   player.play();
   imageMode(CORNER);
   
   int x = height;
   int y = width;
  background(0, 0, 0);
  image(bg, 0, 0, width, height);
  textFont(titleFont);
  // draw title
  fill(240, 0, 0);
  textSize(100);
  textAlign(CENTER);
  translate(0, -height/4);
  text(title, width/2, height/2);
  
  // draw instructions
  fill(255,255,255);
  textSize(50);
  textAlign(CENTER, TOP);
  text(instructions, width/2, height/2);
  
}

void drawCreditScreen()
{
  
}