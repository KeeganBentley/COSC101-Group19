/*
 Authors: Carla Baldassara, Keegan Bentley, Caleb Cooper
 Purpose: 
 Attributes:
   x: x axis position of the animation
   y: y axis position of the animation
   images: array of images that make up the animation
   status: variable to indication animation has ended
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
