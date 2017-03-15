/**
Steven Nim
Feb 8, 2017
The stuff that floats across the screen (stars, bubbles, etc.) to give the illusion of movement.
The planets in the background also fall under this category, but they move at a much slower pace.
*/

class Floaties{
  int x;//x coord
  int y;//y coord
  int speed;//speed of the floating thing
  PImage sprite;//its image
  
  //Primary constructor; x and y position are given
  Floaties(int gX, int gY){
    x = gX;
    y = gY;
    speed = 12;//Set default speed
    sprite = loadImage("Floating.png");//Set placeholder image
  }
  
  //Secondary constructor; also accept a given image in addition to x and y coords
  Floaties(int gX, int gY, PImage p){
    this(gX, gY);//call primary constructor
    sprite = p;//set object's image based on given one
  }
  //sets the floating object's x coord
  void setX(int givenX){
    x = givenX;
  }
  //sets the floating object's y coord
  void setY(int givenY){
    y = givenY;
  }
  //gets the floating object's x coord
  int getX(){
    return x;
  }
  //gets the floating object's y coord
  int getY(){
   return y; 
  }
  //sets the floating object's speed
  int getSpeed(){
   return speed; 
  }
  //returns the floating object's speed
  void setSpeed(int s){
    speed = s;
  }
  //sets the floating object's image
  void setImage(PImage p){
    sprite = p;
  }
  //returns the floating object's image
  PImage getImage(){
   return sprite;  
  }
  //draws the floating object
  void drawFloaty(){
   image(sprite, x, y); 
  } 
  //Updates the floating object to keep it moving
  void updateX(){
    x -= speed;
  }
  //Specific method used for updating the planet in the background to keep it moving
  void updatePlanet(){
    x -= (speed - 11);//Planet moves at a slower pace than the regular floating objects
  }
}
