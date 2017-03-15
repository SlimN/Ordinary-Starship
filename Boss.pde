/**
Steven Nim
February 23, 2017
A Boss takes damage from the Player's attacks, but also fights back.
*/

class Boss{
  int x;//x-position
  int y;//y-position
  PImage sprite;//the boss's look
  int health;//boss's health
  int bHeight;//height of the boss's hitbox
  int bWidth;//width of the boss's hitbox
  int bSpeed;//how fast the boss can move
  
  //Primary boss constructor
  Boss(){
    x = 0;
    y = 0;
    bSpeed = 6;//Default speed is decent
    bHeight = 90;//Default hitbox height
    bWidth = 70;//Default hitbox width
    health = 1; //Default HP
    sprite = loadImage("Spaceship.png"); //Load some placeholder image
  }
  
  //Secondary constructor
  //Accepts a given x position and given y position
  Boss(int gX, int gY){
   this();//Call primary constructor
   x = gX;
   y = gY;
  }
  //sets the boss's x position
  void setX(int givenX){
    x = givenX;
  }
  //sets the boss's y position
  void setY(int givenY){
    y = givenY;
  }
  //returnss the boss's x position
  int getX(){
    return x;
  }
  //returns the boss's y position
  int getY(){
   return y; 
  }
  //returns the boss's speed
  int getSpeed(){
   return bSpeed; 
  }
  //sets the boss's speed
  void setSpeed(int zoom){
    bSpeed = zoom;
  }
  //sets the boss's hitbox width
  void setWidth(int s){
    bWidth = s; 
  }
  //returns the boss's hitbox width
  int getWidth(){
   return bWidth; 
  }
  //sets the boss's hitbox height
  void setHeight(int s){
   bHeight = s; 
  }
  //returns the boss's hitbox height
  int getHeight(){
   return bHeight; 
  }
  //sets the boss's hp
  void setHealth(int s){
   health = s; 
  }
  //returns the boss's hp
  int getHealth(){
   return health; 
  }
  //sets the boss's image
  void setImage(PImage p){
    sprite = p;
  }
  //returns the boss's image
  PImage getImage(){
    return sprite;    
  }
  //Draws the boss to the screen
  void drawBoss(){
   image(sprite, x, y); 
  }
  //updatess the boss's y position; his movement option
  void updateY(){
    y += bSpeed;
  }
}
