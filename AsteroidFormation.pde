/**
Steven Nim
February 9, 2017
Used for picking the formation in which asteroid spawn.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~CURRENTLY UNUSED~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
*/

class AsteroidFormation{
  public AsteroidFormation(){
    
  }
  
  //Returns the number of asteroids to be drawn depending on the formation chosen
  ArrayList getFormation(int formationNum){
    ArrayList <Asteroid> asteroidArr = new ArrayList <Asteroid>();//ArrayList of asteroids
    int index = 0;//holds the current index of the array
    
    if (formationNum == 0) {//FORMATION 1: Four asteroids that are lined up vertically.
      int changeY = 100;
      
      for (int i = 0; i < 4; i++) {
        Asteroid a = new Asteroid(1100, changeY);//create new asteroid
        asteroidArr.add(a);//add to arraylist
        changeY += 100;//increment Y
      }
      return asteroidArr;
      
    } else if (formationNum == 1) {//FORMATION 2: Five asteroids in a staircase pattern.
      int changeX = 1100;
      int changeY = 100;
      
      for (int i = 0; i < 5; i++) {
        Asteroid a = new Asteroid(changeX, changeY);//create new asteroid
        asteroidArr.add(a);//add to arraylist
        changeX += 50;//increment X
        changeY += 100;//increment Y
      }
      return asteroidArr;
      
    } else if (formationNum == 2) {//FORMATION 3: Five asteroids in a straight line.
      Random r = new Random();
      int changeX = 1100;
      int changeY = r.nextInt((590 - 10) + 1) + 10;
      
      for (int i = 0; i < 5; i++) {
        Asteroid a = new Asteroid(changeX, changeY);//create new asteroid
        asteroidArr.add(a);//add to arraylist
        changeX += 70;//increment X
      }
      return asteroidArr;
      
    } else {
      return null;
    }
  }
}
