/**
Steven Nim
February 7, 2017
Projectiles are fired from the Player's ship, and can destroy asteroids and harm monsters.
Projectiles are always 20x5 pixels.
*/

class Projectile{
  int x;//X-Position
  int y;//Y-Position
  PImage sprite;//how the projectile looks
  int pWidth;//Projectile's hitbox width
  int pHeight;//Projectile's hitbox height
  int speed;//Projectile's speed
  boolean drawFlag;//Indicates the object is being drawn
  
  public Projectile(int gX, int gY){
    x = gX;
    y = gY;
    pWidth = 20;
    pHeight = 5;
    speed = 8;//default speed
    sprite = loadImage("Lazor.png"); //default img
  }
  //sets the x coordinate of the Projectile
  void setX(int givenX){
    x = givenX;
  }
  //sets the y coordinate of the Projectile
  void setY(int givenY){
    y = givenY;
  }
  //returns the Projectile's x coord
  int getX(){
    return x;
  }
  //returns the Projectile's y coord
  int getY(){
   return y; 
  }
  //returns the Projectile's hitbox width
  int getWidth(){
   return pWidth; 
  }
  //sets the Projectile's hitbox width
  void setWidth(int s){
   pWidth = s; 
  }
  //returns the Projectile's hitbox height
  int getHeight(){
   return pHeight; 
  }
  //sets the Projectile's hitbox height
  void setHeight(int s){
   pHeight = s; 
  }
  //returns the Projectile's SPEED
  int getSpeed(){
   return speed; 
  }
  //sets the Projectile's SPEED
  void setSpeed(int s){
   speed = s; 
  }
  //sets the Projectile's image
  void setImage(PImage p){
    sprite = p;
  }
  //returns the Projectile's image
  PImage getImage(){
    return sprite;    
  }
  //draws the projectile to the screen
  void drawProjectile(){
   image(sprite, x, y); 
   drawFlag = true;
  } 
  //updates the projectile's position so it keeps moving to the right
  void updateX(){
    x += speed;
  }
}

