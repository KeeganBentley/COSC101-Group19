/******************************************************************************
Authors: Carla Baldassara, Keegan Bentley, Caleb Cooper
Purpose: To recreate the 1980 classic Missle Command by Atari
How to compile and run: Click the start button to run. 
Controls: 

Sound effect source: 
******************************************************************************/


//Initialise all variables


void setup(){
  //Assign variables 
  background(255);
  size(1000, 750);
}


void draw(){
background(255);
fill(0);
rect(mouseX - ((width/20)/2), mouseY - ((height/20)/2), width/20, height/30);
}
