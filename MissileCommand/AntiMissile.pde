/*
 Authors: Carla Baldassara, Keegan Bentley, Caleb Cooper
 Purpose: To define an AntiMissile object and include a method to allow it to 
           move and grow.
 Attributes: 
   xPos: current x axis coordinate of the centre of the circle
   yPos: current y axis coordinate of the centre of the circle
   radius:
   growth:
   endX:
   endY:
   speed:
   time:
   distance:
   xVelocity:
   yVelocity:
   missileWidth:
   missileLength:
   status:
*/

class AntiMissile {
  float xPos, yPos, radius, growth, endX, endY, speed;
  double time, distance, xVelocity, yVelocity;
  boolean status;
  

  AntiMissile (float x, float y) {
    endX = x;
    endY = y;
    radius = 10;
    growth = 0.5;
    status = true;
    xPos = width/2;
    yPos = height - 120;
    speed = 3;
    distance = Math.sqrt((xPos - endX) * (xPos - endX) + (yPos - endY) * 
      (yPos - endY));
    time = distance / speed;
    xVelocity = (endX - xPos)/time;
    yVelocity = (endY - yPos)/time;
  }


  /*
    Purpose: Creates and displays and moves AntiMissile object
    Args: None
    Return: None
  */
  void update() {
    fill(0,255,0); 
    circle(xPos, yPos, radius);
    yPos += yVelocity;
    xPos += xVelocity;
    
    if (yPos <= endY)  {
      yPos = endY;
      xPos = endX;
      if (radius >= 10) {
        radius += growth;

        if (radius > 50) {
          growth *= -1;
        }
      } else {
        status = false;
      }
    }
  }
}
