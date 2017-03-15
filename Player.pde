/**
Steven Nim
February 7, 2017
The Player is a spaceship controlled by the user and it is restricted to vertical movement. It can also fire projectiles.
The Spaceship is always 100x100 pixels
*/

class Player{
  int x;//x-position
  int y;//y-position
  PImage sprite;//the player's look
  final int pHeight = 90;//Player's height hitbox is always defined by a constant value
  final int pWidth = 70;//Player's width hitbox is always defined by a constant value
  int playerSpeed;//how fast the player can move
  
  //Primary constructor; x and y coords are given
  Player(int gX, int gY){
   playerSpeed = 4;//default player speed
   x = gX;
   y = gY;
   sprite = loadImage("Spaceship.png"); //Set the player's default image
  }
  //sets the player's x coord
  void setX(int givenX){
    x = givenX;
  }
  //sets the player's y coord
  void setY(int givenY){
    y = givenY;
  }
  //returns the player's x coord
  int getX(){
    return x;
  }
  //returns the player's y coord
  int getY(){
   return y; 
  }
  //returns the player's speed
  int getSpeed(){
   return playerSpeed; 
  }
  //sets the player's speed
  void setSpeed(int zoom){
    playerSpeed = zoom;
  }
  //sets the player's image
  void setImage(PImage p){
    sprite = p;
  }
  //returns the width of the player's hitbox
  int getWidth(){
   return pWidth; 
  }
  //returns the height of the player's hitbox
  int getHeight(){
   return pHeight; 
  }
  //returns the player's image
  PImage getImage(){
    return sprite;    
  }
  //draws the player ship to the screen
  void drawPlayer(){
   image(sprite, x, y); 
  }
}
