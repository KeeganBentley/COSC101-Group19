/*
 Authors: Carla Baldassara, Keegan Bentley, Caleb Cooper
 Purpose: Defines an enemy Missile object with and includes a method to move
           the missile.
 Attributes: 
   xPos: current x axis coordinate of the centre of the circle
   yPos: current y axis coordinate of the centre of the circle
   endX: 
   endY:
   speed:
   time:
   distance:
   xVelocity:
   yVelocity:
   missileWidth:
   missileHeight:
*/

class EnemyMissile {
  float xPos, yPos, endX, endY, speed;
  double time, distance, xVelocity, yVelocity;
  int missileWidth, missileHeight;

  EnemyMissile(float x, float y) {
    xPos = random(width);
    yPos = 0;
    endX = x;
    endY = y;
    speed = 1;
    distance = Math.sqrt((xPos - endX) * (xPos - endX) + (yPos - endY) * (yPos - endY));
    time = distance / speed;
    xVelocity = (endX - xPos)/time;
    yVelocity = (endY - yPos)/time;
    missileWidth = 5;
    missileHeight = 25;
  }


  /*
    Purpose: Creates and displays and accelerates missile 
   Args: None
   Return: None
   */
  void update() {
    fill(255,0, 0);
    rect(xPos, yPos, missileWidth, missileHeight);  

    yPos += yVelocity;
    xPos += xVelocity;
  }
}
