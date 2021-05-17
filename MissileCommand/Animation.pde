/*
 Authors: Carla Baldassara, Keegan Bentley, Caleb Cooper
 Purpose: 
 Attributes:
   x:
   y:
   images:
   status:
*/
 
class Animation {
  float x, y;
  int index;
  PImage[] images;
  boolean status;
  Animation(PImage[] images_, float x_, float y_) {
    images = images_;
    x = x_;
    y = y_;
    index=0;
    status = true;
  }
  
  void display() {
    images[index].resize(cityWidth*2, 0);
    image(images[index], x, y);
  }
  
  void update() {
    if (index < images.length-1) {
      index ++;
    }
    else {
      status = false;
    }  
  }
}
