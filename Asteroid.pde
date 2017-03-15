/**
Steven Nim
February 7, 2017
Asteroids float across the screen and try to destroy the Player's ship
*/

class Asteroid{
  int x;//X-Position
  int y;//Y-Position
  PImage sprite;//how the asteroid looks
  PImage fire;//how the the enemy's projectile looks (World 4: Earth ONLY)
  int speed;//how fast the asteroid travels across the screen
  int aWidth;//width of asteroid's hitbox
  int aHeight;//height of asteroid's hitbox
  
  //Primary constructor
  //gX = given x value
  //gY = given y value
  public Asteroid(int gX, int gY){
    x = gX;
    y = gY;
    aWidth = 50;//default width
    aHeight = 40;//default height
    speed = 3;//Default speed is 3 pixels
    sprite = loadImage("AsteroidImg.png"); //Load default asteroid image
  }
  //Set x value of the asteroid
  void setX(int givenX){
    x = givenX;
  }
  //Set y value of the asteroid
  void setY(int givenY){
    y = givenY;
  }
  //Get x value of the asteroid
  int getX(){
    return x;
  }
  //Get y value of the asteroid
  int getY(){
   return y; 
  }
  //Get width of the asteroid
  int getWidth(){
   return aWidth; 
  }
  //Get height of the asteroid
  int getHeight(){
   return aHeight; 
  }
  //Get the asteroid's speed
  int getSpeed(){
    return speed;
  }
  //Set speed of the asteroid
  void setSpeed(int i){
   speed = i; 
  }
  //Get the width of the asteroid's hitbox
  int getHitboxWidth(){
   return aWidth; 
  }
  //Set the asteroid's hitbox width
  void setHitboxWidth(int i){
   aWidth = i; 
  }
  //Get the height of the asteroid's hitbox
  int getHitboxHeight(){
   return aHeight; 
  }
  //Set the asteroid's hitbox height
  void setHitboxHeight(int i){
   aHeight = i; 
  }
  //changes the image of the asteroid
  void setImage(PImage p){
    sprite = p;
  }
  //gets the image of the asteroid
  PImage getImage(){
    return sprite;    
  }
  //draws the asteroid
  void drawAsteroid(){
   image(sprite, x, y); 
  } 
  //update's the asteroid's position so that it keeps moving to the left of the screen
  void updateX(){
    x -= speed;
  }
}
