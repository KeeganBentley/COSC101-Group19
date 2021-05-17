/*
 Authors: Carla Baldassara, Keegan Bentley, Caleb Cooper
 Purpose: Defines an enemy Missile object with and includes a method to move
           the missile.
 Attributes: 
   xPos: current x axis coordinate of the missile
   yPos: current y axis coordinate of the missile
   endX: x axis coordinate of the target of the missile
   endY: y axis coordinate of the target of the missile
   speed: speed fo the missile
   time: modifier for speed of the missile
   distance: distance between current location and end loaction
   xVelocity: velocity of the missile along the x axis
   yVelocity: velocity of the missile along the y axis
   missileWidth: width of the missile
   missileHeight: height of the missile
*/

class EnemyMissile {
  float xPos, yPos, endX, endY, speed;
  double time, distance, xVelocity, yVelocity;
  int missileWidth, missileHeight;

  EnemyMissile(float x, float y, float missileSpeed) {
    xPos = random(width);
    yPos = 0;
    endX = x;
    endY = y;
    speed = missileSpeed;
    distance = Math.sqrt((xPos - endX) * (xPos - endX) + (yPos - endY)
      * (yPos - endY));
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
