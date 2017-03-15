import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;
import java.util.Random;

/**
Steven Nim
February 7, 2017
In this side-scrolling game, you control a spaceship, avoid asteroids, and take down bosses as you try to reach the end of all 4 levels.

~~~~~~~~~~~~~~~MARK BREAKDOWN~~~~~~~~~~~~~~~~~~~~~
5 Marks for Concept
-Shapes and images are drawn to the screen (buttons, asteroids, etc.)
-Animated scene (See the gigantic draw function)
-Interaction through keyboard and mouse (player movement and firing lasers)
-Goal/Endgame implemented (game ends after 4 levels; player can accumulate a score)
-Code is commented and a program header is present (yeah boiiiiiiiii)

5 Marks for Coding Strategies
-If Statements (Used for drawing different things to the screen depending on level)
-Arrays/ArrayLists (Used to store projectiles, asteroids, etc. for drawing)
-For Loops (Used when drawing asteroids, projectiles, etc.)
-User-defined functions (Enhanced Rectangle method, countless methods in other classes)
-User-defined objects (Asteroid, Player, Boss, etc.)

4 Marks for Complexity
RAZZLE DAZZLE:
  -Uses both pre-made and custom-made graphical assets to improve overall look
  -Multiple audio files for different levels and the game over screen
  -Each Level has a unique look for the player, the asteroid, and the planet in the background. Each level also has a different musical track.
  -Multiple equippable weapon types with different effects (the Laser Cannon in particular was a pain to make)
  -Boss Fight!
  -Animation for when the user clears a level (ship flies off to the right)

4 Marks for User-Friendliness
-Instructions screen exists
-Controls are simple: move up and down and shoot sometimes
-Appropriate variable names are used (asteroidArray for an array of asteroids), code is readable and formatted reasonably well
-Program header documentation for guidance through marking process (hey that's me)
*/

final static String ICON = "Icon.png";//Icon for the program window
Minim minim;
AudioPlayer audio;//Used for playing music
Floaties planet;//the planet that moves in the background
Player player;//the player's ship!
ArrayList <Projectile> lazerArray = new ArrayList <Projectile>();//ArrayList of projectiles on the screen
ArrayList <Floaties> floatiesArray = new ArrayList <Floaties>();//ArrayList of floating objects on the screen
ArrayList <Asteroid> asteroidArray = new ArrayList <Asteroid>();//ArrayList of asteroids on the screen
ArrayList <EnemyProjectile> enemyLazerArray = new ArrayList <EnemyProjectile>();//ArrayList of Enemy projectiles on the screen
int lagLaser;//Boolean like variable used to prevent user from spamming lasers
int lagFrames;//Lag the player's projectiles based on this number of frames
int score;//The Player's Score
int gunType;//Changes the Player's weapon depending on its value
int asteroidSpawn;//Rate at which the astroids spawn; changes based on the level
int screen;//changes the current screen depending on its value
int screenPrev;//holds a value corresponding to the previous screen displayed
int startLevelTimer;//Timer for when the level starts
int endLevelTimer;//When a certain amount of time has passed, as tracked by this timer, the level will end
int levelClearTimer;//Timer used to keep track of how long the Level Clear screen is displayed
int currentCannonFrame;//This variable and the one below are used for firing projectiles with the Laser Cannon weapon
int startCannonFrame;
int levelLength;//how long a level lasts
boolean flag;//arbitrary boolean for indicating when to draw lazers; i don't wanna remove it in case it breaks something haha
boolean deathFlag;//When set to true, the Game Over screen is displayed
boolean boomSound;//Used on the Game Over screen to play the death sound so that it doesn't infinitely loop
boolean cannonFrameIndicator;//Laser Cannon is only fired when this variable is set to true, every 
boolean cannonFire = false;//indicates if the lazer cannon is fired
Boss boss1;//The first and only boss: Fox

/**
Screen variable values:
0 - Main Menu
1 - Instructions/Credits
2 - Star Galaxy
3 - Galaxy 20XX
4 - Fancy Galaxy
5 - Earth
6 - Game Over Screen
7 - End of Level Animation + Level Clear Screen
8 - End Credits Screen
9 - Boss Battle 1
*/

void setup(){
  changeIcon(loadImage(ICON));//change icon of the program window
  size(1000,600);
  background(0);
  minim = new Minim(this);//Create new minim object for audio stuff
  flag = false;
  deathFlag = false;//user doesn't seem to be dead right now

  lagLaser = 0;//when set to 0, the laser can fire; when set to 1, user cannot fire
  score = 0;
  gunType = 0;
  
  //User can only fire a laser once every 25 frames on the first level
  //Length of the first level is 1200 frames - 20 seconds
  lagFrames = 25;
  levelLength = 1200;
  
  //Set up stuff for the Laser Cannon
  startCannonFrame = 0;
  currentCannonFrame = 0;
  cannonFrameIndicator = false;
  
  //Set up initial screen
  screenPrev = 2;
  screen = 0;
  
  //Create the first boss
  boss1 = new Boss(850,200);
  boss1.setImage(loadImage("fox.png"));
  boss1.setSpeed(5);
  boss1.setHeight(80);
  boss1.setWidth(100);
  boss1.setHealth(100);
  
  //Create player ship
  player = new Player(100, 100);
  
  Random r = new Random();
  for (int i = 0; i <= 5; i++) {//Create 6 floating objects whose only use is to create the illusion of movement
    int randomX = r.nextInt((1500 - 1020) + 1) + 1020;
    int randomY = r.nextInt((590 - 10) + 1) + 10;
    Floaties f = new Floaties(randomX, randomY);
    floatiesArray.add(f);
  }
 
  //Create the random floating planet in the background, used for parallax scrolling
  PImage planetImg = loadImage("Planet.gif"); 
  planet = new Floaties(1150, 300, planetImg);
}

/**
Changes the Icon of the Program
*/
void changeIcon(PImage img) {
  final PGraphics pg = createGraphics(16, 16, JAVA2D);

  pg.beginDraw();
  pg.image(img, 0, 0, 16, 16);
  pg.endDraw();

  frame.setIconImage(pg.image);
}

void keyPressed(){
  //Player can only control their ship on Level or Boss screens
  if (screen == 2 || screen == 3 || screen == 4 || screen == 5 || screen == 9){
    if (keyPressed == true) {
    if (key == 'w' && player.getY() > 0) {//Player moves up when W is pressed
      player.setY(player.getY() - player.getSpeed());
    } else if (key == 's' && player.getY() < 500) {//Player moves down when S is pressed
      player.setY(player.getY() + player.getSpeed());
    } else if (key == 'm') {//Mutes the audio
      audio.pause();
    } else if (key == 'n') {//Plays the audio again
      audio.play();
    } else if (key == 'p' && flag == false) {//Back-up method of shooting projectiles in case mouse doesn't work
      if (lagLaser == 0) {//User fires a projectile
        Projectile pj = new Projectile(player.getX() + 100, player.getY() + 47);
        lazerArray.add(pj); 
        lagLaser = 1;
      }
      
    //The following conditional statements were used for testing, but feel free to use them if you need to skip to a certain level quickly
    } else if (key == 't') {//Warps user to World 1
      screen = 2;
      audio.pause();
      audio = minim.loadFile("StarGalaxy.mp3");
      audio.play();
    } else if (key == 'y') {//Warps user to World 2
      screen = 3;
      audio.pause();
      audio = minim.loadFile("Galaxy20XX.mp3");
      audio.play();
    } else if (key == 'u') {//Warps user to World 3
      screen = 4;
      audio.pause();
      audio = minim.loadFile("FancyGalaxy.mp3");
      audio.play();
    } else if (key == 'i') {//Warps user to World 4
      screen = 5;
      audio.pause();
      audio = minim.loadFile("Earth.mp3");
      audio.play();
    }
  }
  
  } else if (screen == 6) {//Game Over Screen
    if (keyPressed == true) {
      if (key == 'a') {//User can return to Main Menu if they press A on the Game Over screen
        screen = 0;
      }
    }
  } else if (screen == 8) {//End Credits Screen
    if (keyPressed == true) {
      if (key == 'a') {//User can return to Main Menu if they press A on the Credits screen
        audio.pause();
        screen = 0;
      }
    }
  }
}

void keyReleased(){
  //Freeze the Player after a movement key (W, S) is released so they don't fly off into infinity
  player.setX(player.getX());
  player.setY(player.getY());
}

void mousePressed(){
  if (screen == 0) {//Main Menu screen
    if (mouseX > 400 && mouseX < 600 && mouseY > 200 && mouseY < 250 && mousePressed) {//The Start Button is pressed
      for (int i = 0; i < asteroidArray.size(); i++){//Remove all existing asteroids so that they don't spawnkill the player
        Asteroid a = asteroidArray.get(i);
        a.setX(-200);
        asteroidArray.set(i, a);
      }
      for (int j = 0; j < enemyLazerArray.size(); j++){//Remove all enemy projectiles so that they don't spawnkill the player
        EnemyProjectile e = enemyLazerArray.get(j);
        e.setX(-600);
        enemyLazerArray.set(j, e);
      }
      score = 0;//Reset Player's Score
      startLevelTimer = millis();//Start the level timer
      endLevelTimer = 0;//Reset the end level timer
      //Reset player's position
      player.setX(100);
      player.setY(300);
      
      //Set the boss's health
      boss1.setHealth(150);
      
      //Music that plays will depend on the level the user was last in
      if (screenPrev == 2) {//World 1
        audio = minim.loadFile("StarGalaxy.mp3");
        audio.pause();
        audio = minim.loadFile("StarGalaxy.mp3");
        audio.play();
        frame.setTitle("Welcome to the Galaxy!");
      } else if (screenPrev == 3) {//World 2
        audio = minim.loadFile("Galaxy20XX.mp3");
        audio.pause();
        audio = minim.loadFile("Galaxy20XX.mp3");
        audio.play();
        frame.setTitle("FIYAAHHHH");
      } else if (screenPrev == 4) {//World 3
        audio = minim.loadFile("FancyGalaxy.mp3");
        audio.pause();
        audio = minim.loadFile("FancyGalaxy.mp3");
        audio.play();
        frame.setTitle("The Feeling of Space is a Zealous Circulation");
      } else if (screenPrev == 5) {//World 4
        audio = minim.loadFile("Earth.mp3");
        audio.pause();
        audio = minim.loadFile("Earth.mp3");
        audio.play();
        frame.setTitle("ALIENSSSSS");
      } else if (screenPrev == 9) {//Boss Fight
        audio = minim.loadFile("BossFightTheme.mp3");
        audio.pause();
        audio = minim.loadFile("BossFightTheme.mp3");
        audio.play();
        frame.setTitle("Welcome to 20XX"); 
      }
      screen = screenPrev;//change screen to previous level (goes to World 1 upon initial start-up)
    }
    
    if (mouseX > 400 && mouseX < 600 && mouseY > 300 && mouseY < 350 && mousePressed) {//The Instructions Button is pressed
      frame.setTitle("How does one play this game? :Thinking:");
      screen = 1;//change to instructions/credits screen
    }
    
    if (mouseX > 400 && mouseX < 600 && mouseY > 400 && mouseY < 450 && mousePressed) {//The Exit Button is pressed
      System.exit(0);//cy@
    }
    
    if (mouseX > 400 && mouseX < 600 && mouseY > 500 && mouseY < 550 && mousePressed) {//The Weapon Button is pressed
      gunType += 1;//Changes user's gun type
      if (gunType > 2) {//If user changes from laser cannon, put them back to single laser
        gunType = 0;
      }
    }
    
  } else if (screen == 1){//On Instructions/Credits screen
    if (mouseX > 700 && mouseX < 900 && mouseY > 450 && mouseY < 500 && mousePressed) {//The Back Button is pressed
      screen = 0;//go back to main menu
    }
    
    //When the user is in a Game Level or Boss fight
  } else if (screen == 2 || screen == 3 || screen == 4 || screen == 5 || screen == 9){
    if (lagLaser == 0 && flag == false && mousePressed) {
        Projectile pj = new Projectile(0, 0);//Create a projectile if the user clicks the mouse
        
        //Prjectile attributes depend on the gun type
        if (gunType == 0) {//Single Laser
          pj.setWidth(20);
          pj.setHeight(5);
          pj.setX(player.getX() + 80);
          pj.setY(player.getY() + 47);
          pj.setSpeed(8);
          lagFrames = 30;//User must wait 25 frames between shots
          
        } else if (gunType == 1) {//Double Lasers
          pj.setWidth(20);
          pj.setHeight(5);
          pj.setX(player.getX() + 80);
          pj.setY(player.getY() + 15);
          pj.setSpeed(6);
          
          //We need to create a second projectile for the double lasers
          Projectile pj2 = new Projectile(player.getX() + 80, player.getY() + 75);
          pj2.setSpeed(6);
          lagFrames = 40;//User must wait 35 frames between shots
          
          //Sets the image of the SECOND laser depending on the Level, then adds it to the array of projectiles
          if (screen == 2) {//World 1
            PImage setImg = loadImage("Lazor.png");
            pj2.setImage(setImg);
            lazerArray.add(pj2);
          } else if (screen == 3) {//World 2
            PImage setImg = loadImage("Lazor2.png");
            pj2.setImage(setImg);
            lazerArray.add(pj2);
          } else if (screen == 4) {//World 3
            PImage setImg = loadImage("Lazor3.png");
            pj2.setImage(setImg);
            lazerArray.add(pj2);
          } else if (screen == 5) {//World 4
            PImage setImg = loadImage("Lazor4.png");
            pj2.setImage(setImg);
            lazerArray.add(pj2);
          }
          
        } else if (gunType == 2) {//Laser Cannon
          pj.setWidth(1000);
          pj.setHeight(32);
          pj.setX(player.getX() + 60);
          pj.setY(player.getY() + 33);
          pj.setSpeed(0);//The Laser Cannon's speed is set to 0 as it mimics the player's movement instead of firing offscreen
          pj.setImage(loadImage("LAZERBEAM.png"));
          lazerArray.add(pj);
          lagFrames = 25;//User must wait 45 frames between shots
          
        } else {//Error catching: Sets to single projectile
          pj.setX(player.getX() + 80);
          pj.setY(player.getY() + 47);
        }
        
        //Sets the image of the FIRST laser depending on the Level, then adds it to the array of projectiles
        //Note that the Laser Cannon's look remains consistant throughout all levels, so its image does not need to be changed
        if (screen == 2 && gunType != 2) {//World 1
          frame.setTitle("Welcome to the Galaxy!");
          PImage set = loadImage("Lazor.png");
          pj.setImage(set);
          lazerArray.add(pj); 
        } else if (screen == 3 && gunType != 2) {//World 2
          frame.setTitle("FIYAAAHHHH");
          PImage set = loadImage("Lazor2.png");
          pj.setImage(set);
          lazerArray.add(pj); 
        } else if (screen == 4 && gunType != 2) {//World 3
          frame.setTitle("The Feeling of Space is a Zealous Circulation");
          PImage set = loadImage("Lazor3.png");
          pj.setImage(set);
          lazerArray.add(pj); 
        } else if (screen == 5 && gunType != 2) {//World 4
          frame.setTitle("ALIENSSSSS");
          PImage set = loadImage("Lazor4.png");
          pj.setImage(set);
          lazerArray.add(pj); 
        } else if (screen == 9 && gunType != 2) {//Boss Fight 1
          frame.setTitle("Welcome to 20XX");
          PImage set = loadImage("Lazor2.png");
          pj.setImage(set);
          lazerArray.add(pj); 
        }
        
        //Set this value to 1, indicating that the user recently fired a laser
        //User cannot fire another projectile for a certain number of frames (lagFrames)
        lagLaser = 1;
    }
  }
}

void draw(){
  if (screen == 0) {//Title Screen
    background(0);
    Rectangle startButton, instButton, exitButton, weaponButton;//Rectangles that act as buttons
    frame.setTitle("Ordinary Starship");//Set game title
    
    //Draw the Logo Image
    PImage logo = loadImage("Logo.png");
    image(logo, 322, 70);
    
    //Creates the Start Button, which drops the player into the game upon being clicked
    textSize(20);
    startButton = new Rectangle(400, 200, 200, 50);
    fill(255,255,255);
    rect(startButton.x, startButton.y, startButton.w, startButton.h);
    fill(0);
    text("Start Game",450,230);
    
    //Creates the Instructions/Credits Button, which teaches how to play the game and gives credits to sources
    textSize(16);
    instButton = new Rectangle(400, 300, 200, 50);
    fill(255,255,255);
    rect(instButton.x, instButton.y, instButton.w, instButton.h);
    fill(0);
    text("Instructions/Credits",425,330);
    
    //Creates the Exit Button, where the user can leave the game to go do taxes or smth idk
    textSize(20);
    exitButton = new Rectangle(400, 400, 200, 50);
    fill(255,255,255);
    rect(exitButton.x, exitButton.y, exitButton.w, exitButton.h);
    fill(0);
    text("Exit",480,430);
    
    //Creates the Change Weapon button, which does as its name suggests
    textSize(11);
    weaponButton = new Rectangle(400, 500, 200, 50);
    fill(105,55,55);
    rect(weaponButton.x, weaponButton.y, weaponButton.w, weaponButton.h);
    fill(0);
    String pewpew;
    //Changes the name of the gun displayed based on the user's currently equipped weapon
    if (gunType == 0) {
      pewpew = "Single Laser";
    } else if (gunType == 1) {
      pewpew = "Double Laser";
    } else {
      pewpew = "Laser Cannon";
      fill(255,255,255);
      text("Cannon is buggy, beware!", 700, 580);
    }
    fill(0);
    text("Current Gun Type: " + pewpew,413,530);
    
  } else if (screen == 1) {//Instructions/Credits screen
    background(0);
    Rectangle homeButton;
    
    //Creates the Back Button, which sends the user back to the Main Menu upon clicked
    textSize(20);
    homeButton = new Rectangle(700, 450, 200, 50);
    fill(255,255,255);
    rect(homeButton.x, homeButton.y, homeButton.w, homeButton.h);
    fill(0);
    text("Back to Main Menu",710,480);
    
    //Create strings of text to display to screen
    fill(255,255,255);
    String str = "Control a spaceship and clear all 4 levels!\n\nMove vertically using the W and S keys.";
    str += "\nFire projectiles with the mouse.\nDestroy asteroids to increase your score.\nDon't get hit!\nP.S. The slow, floating object in the background is harmless.";
    text(str, 50, 30, 800, 400);//Text wraps within text box
    
    fill(25,255,205);
    str = "Spaceship and Laser sprites by Steven Nim.\nAll other sprites from Google Images or Spriters' Resource";
    str += "\nTracks used: \nKirby's Epic Yarn - Outer Rings\nSuper Smash Bros. Melee - Dream Land 64\nQonell - Renai Circulation (Orchestral Cover)";
    str += "\nSuper Smash Bros. Brawl - Corneria\nERASED - Re:Re: (Instrumental)";
    text(str, 50, 315, 800, 700);//Text wraps within text box

  } else if (screen == 2 || screen == 3 || screen == 4 || screen == 5) {//All Playable Levels (There's Four of Them)
    endLevelTimer += 1;//increment the amount of time the user has spent in the level
    if (cannonFrameIndicator == false) {//If false, then the user is not firing a Laser Cannon at the moment
      startCannonFrame = frameCount;//Prepare stuff so that the Laser Cannon is ready for use again
      cannonFrameIndicator = true;
    }
    
    if (endLevelTimer > levelLength) {//The level will progress until the Timer reaches a certain amount; length of time depends with each level
      screenPrev = screen;//Get the current level's screen value
      screen = 7;//end the level  
      
    } else {//If timer has not reached its certain value yet, continue playing the level
      if (screen == 2 || screen == 3) {//World 1 and 2 have black backgrounds
        background(0); 
      } else if (screen == 4) {//World 3 has a brownish-orange background
        background(100,50,0);
      } else if (screen == 5) {//World 4 has a sky blue background
        background(50,215,235);
      }
      
      //Check for if keys were pressed and released, and check if the mouse was pressed
      keyPressed();
      keyReleased();
      mousePressed();
    
      currentCannonFrame += 1;//Increment a counter that indicates the amount of time between each Laser Cannon shot
    
    //Sets some images for the planet in the background and the player's spaceship
    //Also sets the number of frames for which asteroids spawn at
    //Values set depend on current level
      if (screen == 2) {//World 1: Star Galaxy
        PImage set = loadImage("Planet.gif");
        planet.setImage(set);
        set = loadImage("Spaceship.png");
        player.setImage(set); 
        asteroidSpawn = 40;//Asteroids spawn every 40 frames in World 1
        fill(255,255,255);
      
      } else if (screen == 3) {//World 2: Galaxy 20XX
        PImage set = loadImage("Shine.png");
        planet.setImage(set);
        set = loadImage("Spaceship2.png");
        player.setImage(set);
        asteroidSpawn = 20;//Asteroids spawn every 20 frames in World 2
        fill(255,255,255);
      
      } else if (screen == 4) {//World 3: Fancy Galaxy
        PImage set = loadImage("BagOfMoney.png");
        planet.setImage(set);
        set = loadImage("Spaceship3.png");
        player.setImage(set);
        asteroidSpawn = 15;//Asteroids spawn every 15 frames in World 3
        fill(0);
      
      } else if (screen == 5) {//World 4: Earth
        PImage set = loadImage("Sun.gif");
        planet.setImage(set);
        set = loadImage("Spaceship4.png");
        player.setImage(set);
        asteroidSpawn = 50;//Asteroids spawn every 50 frames in World 4
        fill(0);
      }
      
      //draw the user's score to the screen
      textSize(20);
      text("Score: " + score,900,30);
    
      //Draws the random floating planet in the background
      planet.drawFloaty();
      planet.updatePlanet();
      //If the planet goes off the screen, place it back on the right side of the screen at a random new position
      if (planet.getX() < -400) {
        Random r = new Random();
        int randomX = r.nextInt((1300 - 1150) + 1) + 1150;
        int randomY = r.nextInt((550 - 50) + 1) + 50;
        planet.setX(randomX);
        planet.setY(randomY);
      }
    
      if (frameCount % asteroidSpawn == 0) {//Creates Asteroids; rate of creation depends on level
        //Assign random X and Y values to new asteroid
        Random r = new Random();
        int randomX = r.nextInt((1500 - 1020) + 1) + 1020;
        int randomY = r.nextInt((570 - 30) + 1) + 10;
        Asteroid a = new Asteroid(randomX, randomY);
        PImage setI;
        
        //The image of the asteroid, its speed, and its hitboxes depend on the level
        if (screen == 2) {//In World 1, asteroids are asteroids
          setI = loadImage("AsteroidImg.png");//
          a.setImage(setI);
          a.setSpeed(5);//Slow Speed
          a.setHitboxWidth(50);
          a.setHitboxHeight(50);
          asteroidArray.add(a); 
        } else if (screen == 3) {//In World 2, asteroids are replaced by speedy, thin lasers
          setI = loadImage("Asteroid2.png");
          a.setImage(setI);
          a.setSpeed(9);//Lasers are very fast
          a.setHitboxWidth(50);
          a.setHitboxHeight(8);
          asteroidArray.add(a);
        } else if (screen == 4) {//In World 3, asteroids are replaced by giant golden coins
          setI = loadImage("Asteroid3.png");
          a.setImage(setI);
          a.setSpeed(11);//Coins are big and move REALLY FAST
          a.setHitboxWidth(100);
          a.setHitboxHeight(108);
          asteroidArray.add(a);
        } else if (screen == 5) {//In World 4, asteroids are replaced by enemy spaceships, which can fire lasers as well
          setI = loadImage("EnemyShip.png");
          a.setImage(setI);
          a.setSpeed(6);//Ships move slow
          a.setHitboxWidth(68);
          a.setHitboxHeight(38);
          asteroidArray.add(a);
          //Enemy ships can fire their own lasers
          EnemyProjectile eb = new EnemyProjectile(a.getX() - 2, a.getY() + 21);
          enemyLazerArray.add(eb);    
        }
      }
  
      for (int i = 0; i < lazerArray.size(); i++) {//Draws the Player's Projectiles
        Projectile p = lazerArray.get(i);//Get existing laser created when the user clicked the mouse button
        currentCannonFrame += 1;
        noStroke();
        fill(0);
        if (gunType == 2) {//If the Laser Cannon is in use, some special stuff needs to be adjusted
          p.setY(player.getY() + 33);//Adjust laser's y position
          if (currentCannonFrame > 80) {//Every 80 frames, the user can fire their laser cannon
            lazerArray.remove(p);//once fired, remove the laser beam from existence
            currentCannonFrame = 0;//set to 0 so that the user has to charge their laser back up
          }
        }
        p.updateX();//Update the projectile's X position to move it to the right
        p.drawProjectile(); //Draw the projectile
        if (p.getX() > 980) {//if the projectile goes off screen, remove it from the projectile arraylist
          lazerArray.remove(p);//therefore erasing it from existence
        }
       }
       
       for (int i = 0; i < asteroidArray.size(); i++) {//draw asteroids
         Asteroid a = asteroidArray.get(i);//get existing asteroid from asteroid arraylist
         noStroke();
         a.updateX();//Update asteroid's x position
         fill(0,0,0,5);
         //rect(a.getX(),a.getY(),a.getHitboxWidth(),a.getHitboxHeight());
         a.drawAsteroid();//draw the asteroid
        
        //If the asteroid and the player collide
        if (!(player.getX() > a.getX() + a.getWidth() ||
          player.getX() + player.getWidth() < a.getX() ||
          player.getY() > a.getY() + a.getHeight() ||
          player.getY() + player.getHeight() < a.getY())) {
            asteroidArray.remove(a);//remove the asteroid so that we don't have infinite death loops
            deathFlag = true;//It's game over!
        }
      
        for (int l = 0; l < lazerArray.size(); l++) {//Checks existing lasers to see if they collide with anything
          Projectile p = lazerArray.get(l);//Get existing laser being drawn currently
        
          //If the asteroid and the player's projectile collide
          if (!(p.getX() > a.getX() + a.getWidth() ||
            p.getX() + p.getWidth() < a.getX() ||
            p.getY() > a.getY() + a.getHeight() ||
            p.getY() + p.getHeight() < a.getY())) {
              asteroidArray.remove(a);//Remove the asteroid from existence
              lazerArray.remove(p);//Remove the player's laser from existence
              if (screen == 3) {//Shooting "asteroids" in World 2 is hard, so the player will be rewarded more points
                score += 3;//Increment Player score by 3
              } else {//Destroying asteroids in any other wield yields 1 point
                score += 1;//Increment Player score by 1
              }
          }
        }
        
        if (a.getX() < -200) {//If an asteroid goes offscreen, erase it from existence
          asteroidArray.remove(a);
        }
       }
    
      //World 1 and World 4 are the only stages where random stars or clouds fly by
      if (screen == 2 || screen == 5) {
       for (int i = 0; i < floatiesArray.size(); i++) {//Draws Random floating objects
          Floaties f = floatiesArray.get(i);
          if (screen == 2) {//Stars are drawn in World 1
            f.setSpeed(13);
            PImage sett = loadImage("Floating.png");
            f.setImage(sett);
          } else {//Clouds are drawn in World 4
            f.setSpeed(9);
            PImage sett = loadImage("Cloud.png");
            f.setImage(sett);
          }
          noStroke();
          fill(0);
          f.updateX();//Update floating object's x position
          f.drawFloaty();//draw the flaoting object
          if (f.getX() < -120) {//if the object goes offscreen, redraw it in a random new spot on the right side of the screen
            Random r = new Random();
            int randomX = r.nextInt((1500 - 1020) + 1) + 1020;
            int randomY = r.nextInt((590 - 10) + 1) + 10;
            f.setX(randomX);
            f.setY(randomY);
          }
       } 
      }
    
      //Stage 4 is the only stage where the "asteroids", in this case enemy ships, fire back
      if (screen == 5) {
        for (int q = 0; q < enemyLazerArray.size(); q++) {//Draws the enemy ships' projectiles
          EnemyProjectile ep = enemyLazerArray.get(q);
          ep.updateX();//updates their x position
          fill(100,255,255,5);
          ep.drawProjectile();//draws the enemy's projectile
          
          //If the Enemy's Projectile and the player collide
          if (!(player.getX() > ep.getX() + ep.getWidth() ||
            player.getX() + player.getWidth() < ep.getX() ||
            player.getY() > ep.getY() + ep.getHeight() ||
            player.getY() + player.getHeight() < ep.getY())) {
              enemyLazerArray.remove(q);//Remove the enemy's projectile from existence
              deathFlag = true;//It's game over!
          }
          
          if (ep.getX() < -100) {//If the enemy's projectile flies off screen, erase it
            enemyLazerArray.remove(ep);
          }
         }
      }
    
      player.drawPlayer();//Draw the player
    
      //user is prevented from spamming projectiles; lag time between lasers depends on gun type
      //Once a certain amount of frames has passed, tick a flag to indicate the user can fire again
      if (frameCount % lagFrames == 0) {
        lagLaser = 0;
      } 
    
      if (deathFlag == true) {//Checks to see if the user died; runs code below if yes
        deathFlag = false;
        screenPrev = screen;//store the current screen's value
        audio.pause();//stop the music
        boomSound = true;//play the death sound
        screen = 6;//go to game over screen
      }
    }
    
  } else if (screen == 6) {//Game Over Screen
    //Background drawn depends on the level the user died in
    if (screenPrev == 2 || screenPrev == 3 || screenPrev == 9) {
      background(0);
      fill(255,255,255); 
    } else if (screenPrev == 4) {
      background(100,50,0);
      fill(255,255,255);
    } else if (screenPrev == 5) {
      background(50,215,235);
      fill(0);
    }
    
    //Plays the death sound once
   if (boomSound == true) {
     if (score > 0) {//user has a decent score
       audio = minim.loadFile("Explosion.mp3");//load an explosion track
     } else {//user has no score
       audio = minim.loadFile("HAHA.wav");//laugh at the user
     }
    audio.play();
    boomSound = false;//Set to false so that the explosion sound isn't looped over and over and over and AHHHH
   }
    
    //Simulate the player's ship falling out of the sky
    player.setX(player.getX() + 1);
    player.setY(player.getY() + 12);
    player.drawPlayer();
    
    //Once the player is reasonably off screen, tell the user that THEY LOST
    if (player.getY() > 800) {
      textSize(50);
      fill(255,255,255);
      text("Game Over", 360, 200);//HAHA YOU LOSE
      textSize(30);
      if (score == 0) {//if the user doesn't have a score
        text("no score lol", 400, 400);//haha
      } else {//if the user actually has a score
        text("Final Score: " + score, 400, 400);//tell them it 
      }
      boss1.setHealth(150);//oh yeah reset the boss's health too lol
      text("Press 'A' to return to Main Menu", 270, 500);  
    }
    
  } else if (screen == 7) {//End of Level Screen
    //Sets background depending on the level the user just cleared
    if (screenPrev == 2 || screenPrev == 3 || screenPrev == 9) {
      background(0);
      fill(255,255,255); 
    } else if (screenPrev == 4) {
      background(100,50,0);
      fill(255,255,255);
    } else if (screenPrev == 5) {
      background(50,215,235);
      fill(0);
    }
    
    //Player accelerates off the screen before the level clear message plays
    player.setX(player.getX() + 8);
    player.drawPlayer();
    
    if (player.getX() > 1200) {//once the player has exited the screen
      levelClearTimer += 1;//update a timer that indicates how long the level clear message should be displayed
      textSize(30);
      if (screenPrev == 9) {//Player just beat the boss
        text("Boss Defeated!", 400, 300);//display a boss defeat message!
      } else {//Otherwise, the player just completed a normal level
        text("Level Clear!", 400, 300);//display a level clear message!
      }
      
      for (int i = 0; i < asteroidArray.size(); i++){//Remove all existing asteroids so that they don't spawnkill the player
        Asteroid a = asteroidArray.get(i);
        a.setX(-200);//Throws the asteroid in some far off position where it'll be caught and erased
        asteroidArray.set(i, a);
      }
      for (int j = 0; j < lazerArray.size(); j++) {//Remove all existing player projectiles
        Projectile l = lazerArray.get(j);
        l.setX(1500);//Throws the projectile in some far off position where it'll be caught and erased
        lazerArray.set(j, l);
      }
 
      if (levelClearTimer > 200) {//Once the level clear message has displayed for about 3.5 seconds
        player.setX(100);//Fix the player's positioning
        if (screenPrev == 2) {//Player was just in World 1
          //Change the music
          audio.pause();
          audio = minim.loadFile("Galaxy20XX.mp3");
          audio.play();
          
          endLevelTimer = 0;//Reset the level timer
          levelClearTimer = 0;//Reset the timer for the level clear message
          levelLength = 1500;//World 2 will last for 25 seconds
          screen = 3;//switch the World 2
          
        } else if (screenPrev == 3) {//Player was just in World 2
          //Change the music
          audio.pause();
          audio = minim.loadFile("BossFightTheme.mp3");
          audio.play();
          
          endLevelTimer = 0;//Reset the level timer
          levelClearTimer = 0;//Reset the timer for the level clear message
          player.setSpeed(6);//buff the player's speed for the incoming fight
          screen = 9;//switch the Boss Fight 1
          
        } else if (screenPrev == 4) {//Player was just in World 3
          //Change the music
          audio.pause();
          audio = minim.loadFile("Earth.mp3");
          audio.play();
          
          endLevelTimer = 0;//Reset the level timer
          levelClearTimer = 0;//Reset the timer for the level clear message
          levelLength = 1200;//World 4 lasts for 20 seconds
          screen = 5;//switch the World 4
          
        } else if (screenPrev == 5) {//Player was just in World 4
          //Change the music
          audio.pause();
          audio = minim.loadFile("ReRe.mp3");
          audio.play();
          
          endLevelTimer = 0;//Reset the level timer
          levelClearTimer = 0;//Reset the timer for the level clear message
          screen = 8;//switch the End Credits Screen
          
        } else if (screenPrev == 9) {//Player has finished the first boss fight
          //Change the music
          audio.pause();
          audio = minim.loadFile("FancyGalaxy.mp3");
          audio.play();
          
          
          endLevelTimer = 0;//Reset the level timer
          levelClearTimer = 0;//Reset the timer for the level clear message
          player.setSpeed(4);//nerf the player's speed back to normal
          levelLength = 1800;//World 3 lasts for 30 seconds 
          
          screen = 4;//switch the World 3
        }
      }
      
      
    }
  } else if (screen == 8) {//End Credits Screen
    frame.setTitle("Victory!");
    background(0);
    fill(250,200,40);
    textSize(44);
    text("You Win!",385, 200);
    text("Final Score: " + score,340, 270);//display user's score
    textSize(22);
    text("Press A to return to Main Menu",320, 350);
    screenPrev = 2;//Reset the previous screen value so that the player can play the game again!
    
  } else if (screen == 9) {//Boss Fight 1
    if (cannonFrameIndicator == false) {//If false, then the user is not firing a Laser Cannon at the moment
      startCannonFrame = frameCount;//Prepare stuff so that the Laser Cannon is ready for use again
      cannonFrameIndicator = true;
    }
    if (boss1.getHealth() < 0) {//Once the user has defeated the boss
      screenPrev = screen;//Get the current level's screen value
      screen = 7;//end the level  
    } else {//If the boss ain't dead yet, keep fighting
      frame.setTitle("Welcome to 20XX");//Set the window's title
      background(0);
      keyPressed();
      keyReleased();
      mousePressed();
    
      currentCannonFrame += 1;//update counter for how long until the user can fire their Laser Cannon again
      PImage set = loadImage("Spaceship2.png");//Set user's spaceship image
      player.setImage(set);
      asteroidSpawn = 25;//Asteroids (or in this case, enemy lasers) spawn every 35 frames in this boss fight
      
      fill(255,255,255);
      textSize(20);
      text("Score: " + score,500,30);//Display user's score
      
      fill(255,0,0);
      textSize(20);
      text("Boss HP: " + boss1.getHealth(),700,30);//Display the boss's health
    
      if (frameCount % asteroidSpawn == 0) {//Creates Asteroids every 35 frames
        //Assign asteroid a random x and y value
        Random r = new Random();
        int randomX = r.nextInt((1500 - 1020) + 1) + 1020;
        int randomY = r.nextInt((570 - 30) + 1) + 10;
        Asteroid a = new Asteroid(randomX, randomY);
        PImage setI = loadImage("Asteroid2.png");
        a.setImage(setI);
        a.setSpeed(7);//These asteroids, which look like laser, are decently quick
        a.setHitboxWidth(50);
        a.setHitboxHeight(8);
        asteroidArray.add(a);//Add asteroid to the array
      }
      
      //Creates the Boss's projectile attacks
      //The boss attacks every 300 frames, or 5 seconds
      if (frameCount % 300 == 0) {
        //Assign boss's projectile a random x and y value
        Random r = new Random();
        int randomX = r.nextInt((1500 - 1020) + 1) + 1020;
        int randomY = r.nextInt((570 - 30) + 1) + 10;
        //create new boss projectile
        EnemyProjectile eb = new EnemyProjectile(boss1.getX(), boss1.getY() + 40);
        eb.setImage(loadImage("Shine.png"));
        eb.setHeight(116);
        eb.setWidth(100);
        eb.setSpeed(4);//The boss's projectile moves slow but takes up a lot of space
        enemyLazerArray.add(eb);//Add it to boss projectile array list
      }
  
      for (int i = 0; i < lazerArray.size(); i++) {//Draws the Player's Projectiles
        Projectile p = lazerArray.get(i);//Pluck a player projectile from the arraylist
        currentCannonFrame += 1;//Soon the user can fire their laser cannon again
        noStroke();
        fill(0);
        if (gunType == 2) {//If the user is equipping a Laser Cannon
          p.setY(player.getY() + 33);//Adjust Laser Cannon's position when drawn
          if (currentCannonFrame > 80) {//User can only fire the Laser Cannon once every 80 frames
            lazerArray.remove(p);//Remove laser from existence
            currentCannonFrame = 0;//Reset timer until user can use their Laser Cannon again
          }
        }
        p.updateX();
        p.drawProjectile();//Draw the player's projectile
        if (p.getX() > 980) {//Erases projectile if it flies off screen (Single or Double Lasers only)
          lazerArray.remove(p);
        }
       }
       
       for (int i = 0; i < asteroidArray.size(); i++) {//draw asteroids
         Asteroid a = asteroidArray.get(i);
         noStroke();
         a.updateX();
         fill(0,0,0,5);
         rect(a.getX(),a.getY(),a.getHitboxWidth(),a.getHitboxHeight());
         a.drawAsteroid();
        
        //If the asteroid and the player collide
        if (!(player.getX() > a.getX() + a.getWidth() ||
          player.getX() + player.getWidth() < a.getX() ||
          player.getY() > a.getY() + a.getHeight() ||
          player.getY() + player.getHeight() < a.getY())) {
            asteroidArray.remove(a);//remove the projectile so that we don't have infinite death loops
            deathFlag = true;//It's game over!
        }
      
        for (int l = 0; l < lazerArray.size(); l++) {
          Projectile p = lazerArray.get(l);
        
          //If the asteroid and the player's projectile collide
          if (!(p.getX() > a.getX() + a.getWidth() ||
            p.getX() + p.getWidth() < a.getX() ||
            p.getY() > a.getY() + a.getHeight() ||
            p.getY() + p.getHeight() < a.getY())) {
              asteroidArray.remove(a);//Remove the asteroid from existence
              boss1.setHealth(boss1.getHealth() - 2);//Destroying an asteroid depletes the boss's health
              score += 3;//Destroying an asteroid increments the player's score
          }
          
          //If the boss and the player's projectile collide
          if (!(p.getX() > boss1.getX() + boss1.getWidth() ||
            p.getX() + p.getWidth() < boss1.getX() ||
            p.getY() > boss1.getY() + boss1.getHeight() ||
            p.getY() + p.getHeight() < boss1.getY())) {
              lazerArray.remove(p);//Remove the lazer so we don't get multihit shenanigans
              boss1.setHealth(boss1.getHealth() - 5);//Boss gets hurt when player shoots 'em
          }
        }
        
        if (a.getX() < -180) {//Asteroids are removed from existence if they exceed the left side screen boundary
          asteroidArray.remove(a);
        }
       }
    
      player.drawPlayer();//Draw the player
      boss1.drawBoss();//Draws the boss
      boss1.updateY();//Update boss's position
      
      if (boss1.getY() > 500 || boss1.getY() < 0) {//If boss is about to go offscreen, switch their direction
        boss1.setSpeed((-1) * boss1.getSpeed());
      }
    
      //user is prevented from spamming projectiles; lag time between lasers depends on gun type
      //Once a certain amount of frames has passed, tick a flag to indicate the user can fire again
      if (frameCount % lagFrames == 0) {
        lagLaser = 0;
      }
     
      for (int q = 0; q < enemyLazerArray.size(); q++) {//Draws the Boss's projectiles
          EnemyProjectile ep = enemyLazerArray.get(q);//Grabs boss projectile from the arraylist
          ep.updateX();//update boss projectile's x position
          ep.drawProjectile();//draw the boss's projectile
          
          //If the Boss's Projectile and the player collide
          if (!(player.getX() > ep.getX() + ep.getWidth() ||
            player.getX() + player.getWidth() < ep.getX() ||
            player.getY() > ep.getY() + ep.getHeight() ||
            player.getY() + player.getHeight() < ep.getY())) {
              enemyLazerArray.remove(q);//Remove the boss's projectile from existence
              deathFlag = true;//It's game over!
          }
          
          if (ep.getX() < -300) {//If the enemy's projectile flies off screen, erase it
            enemyLazerArray.remove(ep);
          }
      } 
    
      if (deathFlag == true) {//Checks to see if the user died; runs code below if yes
        deathFlag = false;//Change the flag so that we don't get an infinite loop

        screen = 6;//Change to game over screen
        audio.pause();//Pause the music
      }
      
       if (deathFlag == true) {//Checks to see if the user died; runs code below if yes
        deathFlag = false;
        audio.pause();//stop the music
        boomSound = true;//play the death sound
        screen = 6;//go to game over screen
      }
    }
    
  }
}

class Rectangle{//An enhanced class for a Rectangle
  int x;//x position
  int y;//y position
  int w;//width
  int h;//height

  public Rectangle(int x, int y, int w, int h){
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  
  
}


