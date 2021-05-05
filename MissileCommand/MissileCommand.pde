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
float[] xPosCity;
float enemyMissileSpeed = 2;
float ground, x, y, yPosCity;
int levelTotal = 10; //will determine the amount of missiles falling each round
int time = 120; //used to determine how long between each missile falling
int[] mags = {10, 10, 10};
int magNum = 0;
int cityWidth, cityHeight, blockWidth, score;
int[] cityHitCount;
ArrayList<AntiMissile> antiMissiles = new ArrayList<AntiMissile>();
PShape city;
PShape cityHit;

final int numCities = 6;

color cityCol = color(55, 155, 255);
color baseCol = color(126, 0, 126);  //TODO: Set color to change on next level

void setup()
{
  //Assign variables 
  size(800, 600);
  background(0);
  noStroke();
  frameRate(60);
  
  enemyMissile_x = new float[0];
  enemyMissile_y = new float[0];
  
  ground = height * 0.85;
  cityHeight = height / 25;
  cityWidth = width / 20;
  yPosCity = ground;
  xPosCity = new float[0];
  cityHitCount = new int[numCities];
  blockWidth = cityWidth / 8;
  
  float[] blockHeight = {0, 0.35, 0.65, 1, 0.75, 0.55, 0.85, 1, 0.35, 0};
  float[] blockHitHeight = {0, 0.10, 0.20, 0.20, 0.10, 0.20, 0.20, 0.1, 0.20, 0};

  setCityPos();
  setCityShape(blockHeight);
  setCityHitShape(blockHitHeight);

}


void setCityPos(){
  for (int i = 0; i < numCities; i++) {  
    if (i < numCities/2 ) {
      xPosCity = append(xPosCity, width * (i + 1) / 10 );
    } else {
      xPosCity = append(xPosCity, width * (i + 3) / 10 + cityWidth);
    }
  }
}


void setCityShape(float[] bHeight){ 
  city = createShape();
  city.setFill(cityCol);
  city.beginShape();
  city.noStroke();
  
  for (int i = 0; i < bHeight.length-1; i++) {
    city.vertex(x + i * blockWidth, y - bHeight[i] * cityHeight);
    city.vertex(x + i * blockWidth, y - bHeight[i+1] * cityHeight);
  }
  
  city.endShape(CLOSE);
}


void setCityHitShape(float[] bHitHeight){ 
  cityHit = createShape();
  cityHit.setFill(cityCol);
  cityHit.beginShape();
  cityHit.noStroke();
  
  for (int i = 0; i < bHitHeight.length-1; i++) {
    cityHit.vertex(x + i * blockWidth, y - bHitHeight[i] * cityHeight);
    cityHit.vertex(x + i * blockWidth, y - bHitHeight[i+1] * cityHeight);
  }
  
  cityHit.endShape(CLOSE);
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
       fill(255);
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
  background(0);
  fill(255);
  
  drawBase();
  displayCity(xPosCity, yPosCity);
  displayScore();  //TODO: is a placeholder
  
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


void drawBase() {
  int sideWidth = width / 20;
  int sideHeight = height / 25;
  int stepHeight = sideHeight / 3;
  
  fill(baseCol);  
  noStroke();

  //base
  rect(0, ground, width, height / 10);  

  //sides
  rect(0, ground - sideHeight, sideWidth, sideHeight);
  rect(width - sideWidth, ground - sideHeight, sideWidth, sideHeight);

  //middle steps using x,y centred
  push();
  noStroke();
  rectMode(CENTER);
  rect(width / 2, ground - stepHeight * 0.5, sideWidth * 3, stepHeight);
  rect(width / 2, ground - stepHeight * 1.5, sideWidth * 2, stepHeight);
  rect(width / 2, ground - stepHeight * 2.5, sideWidth, stepHeight);
  pop();
  
}


void displayCity(float[] xPosCity, float yPosCity) {
  for (int i = 0; i < xPosCity.length; i++) {
      shape(city, xPosCity[i], yPosCity);
  }
}


//TODO: add conditions to calculate score
void displayScore() {
  textSize(32);
  textAlign(CENTER);
  fill(255);
  text(score, width/2, height*0.1);
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
