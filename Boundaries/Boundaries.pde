import ddf.minim.*;

//Global Member Variables
TiledMap map;
Minim minim;
AudioPlayer player, hitSFX, strongSFX,floorHit, gameMusic, deathSFX, getSome;
AudioInput input;
PImage bg, story, ending, logo;
PFont titleFont;

boolean isTitleScreen, isGameScreen, isCreditScreen, isGamePause, isStoryScreen;

void setup()
{
  fullScreen();
  //size(600,340);
  
  //Audio Player
  minim = new Minim(this);
  player = minim.loadFile("soldiers.mp3");
  gameMusic = minim.loadFile("oddlook.mp3");
  hitSFX = minim.loadFile("punchsfx.wav");
  floorHit = minim.loadFile("floorHit.wav");
  strongSFX = minim.loadFile("strongAttack.wav");
  deathSFX = minim.loadFile("deathsfx.wav");
  getSome = minim.loadFile("getsome.mp3");
  input = minim.getLineIn();
  
  //titleScreen image
  bg = loadImage("skyline.png");
  story = loadImage("street.jpg");
  ending = loadImage("sunrise.png");
  logo = loadImage("Logo.PNG");
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
    player.play();
    drawTitleScreen("Road of Anger", "Press Space to Start");
  }
  else if (isStoryScreen)//Story Screen Mode
  {
    drawStoryScreen();
  }
  else if (isGameScreen) //Game Screen Mode
  {
    player.close();
    gameMusic.setGain(-15);
    gameMusic.play();
    if (map == null)
      map = new TiledMap(this);
    
    if (!map.getGameOver())
      map.drawMap();
    else
    {
      map = null;
      isCreditScreen = true;
      isGameScreen = false;
    }
    
    if (map != null && map.getPlayer().getHealth() <= 0)
    {
      map = null;
      isTitleScreen = true;
      isStoryScreen = true;
      isGameScreen = false;
    }
  }
  else if (isCreditScreen) //Credit Screen Mode
  { 
    drawCreditScreen("Peace is restored!", "Thank you for playing"+"\nPress Space to Start to back to the Title Screen");
  }
  
}

void keyPressed(){
  if(isTitleScreen && key == ' '){
    isStoryScreen = true;
    isTitleScreen = false;
    imageMode(CORNER);
  }
  
  if(isStoryScreen && key == 's'){
    isGameScreen = true;
    isStoryScreen = false;
    imageMode(CENTER);
  }
  
  
  if (isCreditScreen && key == ' ')
  {
    isCreditScreen = false;
    isTitleScreen = true;
  }
  if(isGameScreen && map != null)
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
  if (isGameScreen && map != null)
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
      map.getPlayer().setIsMoving(false);}   }
}

void drawTitleScreen(String title, String instructions)
{
  
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

void drawStoryScreen()
{
  background(0, 0, 0);
  imageMode(CORNER);
  image(story, 0, 0, width, height);
  

  textFont(titleFont);
  textSize(50);
  textAlign(CENTER, BOTTOM);
  fill(255, 255, 255);
  String gameStory = "A man who lost his family to gang violence\n sets out to take vengeance against the streets";
  translate(width/4, height/4);
  text(gameStory, width/8, height/3);
  text("Press S to Skip", width/2, height/2);
  
}


void drawCreditScreen(String heading, String body)
{
  imageMode(CORNER);
   
  int x = height;
  int y = width;
  background(0, 0, 0);
  image(ending, 0, 0, width, height);
  textFont(titleFont);
  // draw title
  fill(240, 0, 0);
  textSize(100);
  textAlign(CENTER);
  translate(0, -height/4);
  text(heading, width/2, height/2);
  
  // draw instructions
  fill(255,255,255);
  textSize(50);
  textAlign(CENTER, TOP);
  text(body, width/2, height/2);
  //translate();
  image(logo, (width/2)+(width/4)+(width/16), (height/2)+(height/2)+(height/16), 400, 200 );
  
}