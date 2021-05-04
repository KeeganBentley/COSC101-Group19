/******************************************************************************
Authors: Carla Baldassara, Keegan Bentley, Caleb Cooper
Purpose: To recreate the 1980 classic Missle Command by Atari
How to compile and run: Click the start button to run. 
Controls: 

Sound effect source: 
******************************************************************************/


//Initialise all variables
float[] enemyMissile_x;
float[] enemyMissile_y;
float enemyMissileSpeed = 2;
int levelTotal = 10; //will determine the amount of missiles falling each round
int time = 120; //used to determine how long between each missile falling
int[] mags = {10, 10, 10};
int magNum = 0;
ArrayList<AntiMissile> antiMissiles = new ArrayList<AntiMissile>();


void setup()
{
  //Assign variables 
  size(800, 600);
  noStroke();
  frameRate(60);
  
  enemyMissile_x = new float[0];
  enemyMissile_y = new float[0];

}

void createMissile()
{
   enemyMissile_x = append(enemyMissile_x, random(width));
   enemyMissile_y = append(enemyMissile_y, 0);
}

void missile_fall()
{
  for( int i = 0; i < enemyMissile_x.length; i++)
     {
       fill(0,0,0);
       rect(enemyMissile_x[i], enemyMissile_y[i], 5, 25);
       enemyMissile_y[i] += enemyMissileSpeed;
       //creates a missile. currently falls from top of screen. need to figure out
       //how to get this to aim at cities once they are added.
     }
}

void mouseClicked() {
  mags[magNum] -= 1;
  if (mags[magNum] > 0) {
    antiMissiles.add(new AntiMissile(mouseX, mouseY));
  }
}

void draw()
{
  background(255);
  fill(0);
  rect(mouseX - ((width/20)/2), mouseY - ((height/20)/2), width/20, height/30);
  //every 2 seconds this will update the x and y position for a new enemy missile
  if(frameCount % time == 0) 
  {
    createMissile();
  }
  
  missile_fall();
  
  //draw in graphics for ammo counters *NOTE* need to actually place these correctly
  if (mags[magNum] == 0) {
    if (magNum < 2){
      magNum += 1;
    }
    else {
    println("OUT OF AMMO");
    }
  }
  for (int i=0; i < mags.length; i++) {
    if (mags[i] > 0) {
      rect(20*(i+1), height - 30, 10, 10);
    }
  }
  for (int i=0; i < mags[magNum]; i++){
    rect (75, 10*(i+1), 5, 5);
  }
  
  //Update all Anti-Missiles
  for (int i=0; i < antiMissiles.size(); i++) {
    AntiMissile currentAnti = antiMissiles.get(i);
    if (currentAnti.status == true) {
      currentAnti.update();
    }
    else {
      antiMissiles.remove(i);
    }
  }
  
}

class AntiMissile {
  float xPos, yPos;
  int radius, growth;
  boolean status;
  AntiMissile (float x, float y) {
    xPos = x;
    yPos = y;
    radius = 10;
    growth = 1;
    status = true;
  }
  void update() {
    if (radius >= 10){
      circle(xPos, yPos, radius);
      radius += growth;
      if (radius > 150){
        growth *= -1;
      }
    }
    else {
      status = false;
    }
  }
}
