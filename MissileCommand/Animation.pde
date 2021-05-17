/******************************************************************************
 Authors: Carla Baldassara, Keegan Bentley, Caleb Cooper
 Purpose: To recreate the 1980 classic Missle Command by Atari
 How to compile and run: Click the start button to run. 
 Controls: 
 
 Sound effect source: 
 ******************************************************************************/
 
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
