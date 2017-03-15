/**
Steven Nim
February 14, 2017
The projectiles fired by enemies that can kill the Player.
They're basically just normal Projectiles except they hurt the player and move to the left of the screen instead of the right.
*/

class EnemyProjectile{
  int x;//X-Position
  int y;//Y-Position
  PImage sprite;//how the projectile looks
  int pWidth;//its hitbox width
  int pHeight;//its hitbox height
  int speed;//how fast it travels
  
  //Primary constructor
  public EnemyProjectile(int gX, int gY){
    x = gX;
    y = gY;
    pHeight = 10;//set default hitboxes
    pWidth = 30;
    speed = 8;//default speed is pretty fast
    sprite = loadImage("Lazor4.png"); //default image
  }
  //sets the x coordinate
  void setX(int givenX){
    x = givenX;
  }
  //sets the y coordinate
  void setY(int givenY){
    y = givenY;
  }
  //returns the enemy projectile's x coordinate value
  int getX(){
    return x;
  }
  //returns the enemy projectile's y coordinate value
  int getY(){
   return y; 
  }
  //returns the enemy projectile's hitbox width
  int getWidth(){
   return pWidth; 
  }
  //sets the enemy projectile's hitbox width
  void setWidth(int w){
   pWidth = w; 
  }
  //returns the enemy projectile's hitbox height
  int getHeight(){
   return pHeight; 
  }
  //sets the enemy projectile's hitbox height
  void setHeight(int p){
   pHeight = p; 
  }
  //returns the enemy projectile's speed
  int getSpeed(){
   return speed; 
  }
  //sets the enemy projectile's speed
  void setSpeed(int s){
   speed = s; 
  }
  //sets the enemy projectile's image
  void setImage(PImage p){
    sprite = p;
  }
  //returns the enemy projectile's image
  PImage getImage(){
    return sprite;    
  }
  //draws the enemy projectilee
  void drawProjectile(){
   image(sprite, x, y); 
  } 
  //updates the enemy projectile's x position so it keeps moving to the left
  void updateX(){
    x -= speed;
  }
}
