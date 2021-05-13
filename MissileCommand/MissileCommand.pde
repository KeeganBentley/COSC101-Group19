/******************************************************************************
Authors: Carla Baldassara, Keegan Bentley, Caleb Cooper
Purpose: To recreate the 1980 classic Missle Command by Atari
How to compile and run: Click the start button to run. 
Controls: 

Sound effect source: 
******************************************************************************/


//Initialise all variables
ArrayList<EnemyMissile> enemyMissiles = new ArrayList<EnemyMissile>(10);
ArrayList<AntiMissile> antiMissiles = new ArrayList<AntiMissile>();

FloatList xPosCity;
FloatList xPosHitCity;
float ground, x, y, yPosCity;
//will determine the amount of missiles falling each round
int levelTotal = 10; 
int missilesThisLevel = 0;
//used to determine how long between each missile falling
int time = 120; 

int[] mags = {10, 10, 10};
int magNum = 0;
int cityWidth, cityHeight, blockWidth, score;
int[] cityHitCount;
int explosion_images = 17;

PShape city;
PShape cityHit;
PImage[] explosion;

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
  
  
  ground = height * 0.85;
  cityHeight = height / 25;
  cityWidth = width / 20;
  yPosCity = ground;
  xPosCity = new FloatList(0);
  xPosHitCity = new FloatList(0);
  explosion = new PImage[explosion_images];
  cityHitCount = new int[numCities];
  blockWidth = cityWidth / 8;
  
  float[] blockHeight = {0, 0.35, 0.65, 1, 0.75, 0.55, 0.85, 1, 0.35, 0};
  float[] blockHitHeight = {0, 0.10, 0.20, 0.20, 0.10, 0.20, 0.20, 0.1, 0.20, 0};

  setCityPos();
  setCityShape(blockHeight);
  setCityHitShape(blockHitHeight);
  createExplosion();

}


void setCityPos(){
  for (int i = 0; i < numCities; i++) {  
    if (i < numCities/2 ) {
      xPosCity.append(width * (i + 1) / 10 );
    } else {
      xPosCity.append(width * (i + 3) / 10 + cityWidth);
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


void createExplosion() {
  for (int i = 1; i <= explosion.length; i++) {
    String str = "data/" +i +".gif";
    explosion[i-1] = loadImage(str);
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
  
  println(mouseX);
  
  drawBase();
  displayCity(xPosCity, yPosCity, xPosHitCity);
  displayScore();  //TODO: is a placeholder
  
  rect(mouseX - ((width/20)/2), mouseY - ((height/20)/2), width/20, height/30);
     
  
  //draw in graphics for ammo counters *NOTE* need to actually place these correctly
  drawAmmo();
  
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
  
  missileCollision();
  cityCollision();
  
  //every 2 seconds adds a new enemymissile to the arrayList   
  if(frameCount % time == 0) {
    if (missilesThisLevel < levelTotal)  {
    enemyMissiles.add(new EnemyMissile(xPosCity.get(int(random(xPosCity.size()))) + 10, yPosCity));
    missilesThisLevel++;
    }
  }
     
  for (int i = 0; i < enemyMissiles.size(); i++)  {
    enemyMissiles.get(i).update();
  }
  
}

void drawAmmo() {
  float ammoX = width/2 - 5;
  float ammoY = height - 100;
  int ammoCount = 0;
  
  if (mags[magNum] == 0) {
    if (magNum < 2){
      magNum += 1;
    }
    else {
    //Maybe print on screen out of ammo
    println("OUT OF AMMO");
    }
  }
  for (int i=0; i < mags.length; i++) {
    if (mags[i] > 0) {
      rect(20*(i+1), height - 60, 10, 10);
    }
  }
  for (int i=0; i < mags[magNum]; i++){
    rect (ammoX, ammoY , 10, 5);
    if (ammoCount == 0) {
      ammoY += 10;
      ammoX -= 10;
    }
    else if (ammoCount == 1) {
      ammoX += 20;
    }
    else if (ammoCount == 2) {
      ammoY += 10;
      ammoX -= 30;
    }
    else if (ammoCount == 3 || ammoCount == 4) {
      ammoX += 20;
    }
    else if (ammoCount == 5) {
      ammoY += 10;
      ammoX -= 50;
    }
    else {
      ammoX += 20;
    }
    
    ammoCount++;
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


void displayCity(FloatList xPosCity, float yPosCity, FloatList xPosHitCity) {
  for (int i = 0; i < xPosCity.size(); i++) {
      shape(city, xPosCity.get(i), yPosCity);
  }
  
  for (int i = 0; i < xPosHitCity.size(); i++) {
      shape(cityHit, xPosHitCity.get(i), yPosCity);
  } 
  
}


void explodeAt(float x, float y, int frame) {
  image(explosion[frame], x, y-50);
}


//TODO: add conditions to calculate score
void displayScore() {
  textSize(32);
  textAlign(CENTER);
  fill(255);
  text(score, width/2, height*0.1);
}
//just to see how long the line is :P
//*****************************************************************************
//Missile and anti-missile collision
//BUG: detecting missiles well out of range
void missileCollision() {
  for (int i=0; i < enemyMissiles.size(); i++) {
    for (int j=0; j < antiMissiles.size(); j++) {
      
      //naming convention EN-enemy MIS-missile TL-TopLeft X-xAxisValue
      float enMisTLX = enemyMissiles.get(i).xPos;
      float enMisTLY = enemyMissiles.get(i).yPos;
      float antiRad = antiMissiles.get(j).radius;
      float antiX = antiMissiles.get(j).xPos;
      float antiY = antiMissiles.get(j).yPos;
      float enMisTRX = enMisTLX + enemyMissiles.get(i).missileWidth;
      float enMisTRY = enMisTLY;
      float enMisBLX = enMisTLX;
      float enMisBLY = enMisTLY + enemyMissiles.get(i).missileHeight;
      float enMisBRX = enMisTRX;
      float enMisBRY = enMisBLY;
      
      if (dist(enMisTLX, enMisTLY, antiX, antiY) < antiRad || dist(enMisTRX, 
        enMisTRY, antiX, antiY) < antiRad || dist(enMisBLX, enMisBLY, antiX, 
        antiY) < antiRad || dist(enMisBRX, enMisBRY, antiX, antiY) < antiRad) {
        
          enemyMissiles.remove(i);
          score += 10;
      }   
    }
  }
}


void cityCollision() { 
  for (int i=0; i < enemyMissiles.size(); i++) {
    for (int j=0; j < xPosCity.size(); j++) {
      
      //naming convention EN-enemy MIS-missile TL-TopLeft X-xAxisValue
      float enMisTLX = enemyMissiles.get(i).xPos;
      float enMisTLY = enemyMissiles.get(i).yPos;
      float enMisTRX = enMisTLX + enemyMissiles.get(i).missileWidth;
      float enMisTRY = enMisTLY;
      float enMisBLX = enMisTLX;
      float enMisBLY = enMisTLY + enemyMissiles.get(i).missileHeight;
      float enMisBRX = enMisTRX;
      float enMisBRY = enMisBLY;
      
      //removes missile ones it hits groud
      if(enMisBLY >= ground || enMisBRY >= ground) {
        enemyMissiles.remove(i);         
      }
      
      //tests city collision
      if ((enMisBRX >= xPosCity.get(j) && (enMisBRX <= xPosCity.get(j) + cityWidth)) &&
         ((enMisBRY >= yPosCity - cityHeight) && enMisBRY <= yPosCity) &&
         
          (enMisBLX >= xPosCity.get(j) && (enMisBLX <= xPosCity.get(j) + cityWidth)) &&
         ((enMisBLY >= yPosCity - cityHeight) && enMisBLY <= yPosCity) ||
         
          (enMisTLX >= xPosCity.get(j) && (enMisTLX <= xPosCity.get(j) + cityWidth)) &&
         ((enMisTLY >= yPosCity - cityHeight) && enMisTLY <= yPosCity) &&
         
          (enMisTRX >= xPosCity.get(j) && (enMisTRX <= xPosCity.get(j) + cityWidth)) &&
         ((enMisTRY >= yPosCity - cityHeight) && enMisTRY <= yPosCity)) {

          
         //explosion - need to discuss still to fix up
         if  ( xPosCity.size() < explosion_images && frameCount%4 == 0) {
               explodeAt(xPosCity.get(j), yPosCity - cityHeight, xPosCity.size()+1);
         } else if ( xPosCity.size() < explosion_images) {
               explodeAt(xPosCity.get(j), yPosCity - cityHeight, xPosCity.size());
         }

         xPosHitCity.append(xPosCity.get(j));   
         xPosCity.remove(j);
         enemyMissiles.remove(i); 

      }     
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
      if (radius > 75){
        growth *= -1;
      }
    }
    else {
      status = false;
    }
  }
}

class EnemyMissile {
  float xPos, yPos, endX, endY, speed;
  double time, distance, xVelocity, yVelocity;
  int missileWidth, missileHeight;
  
  EnemyMissile(float x, float y)  {
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
  
  void update()  {
    
    fill(255);
    rect(xPos, yPos, missileWidth, missileHeight);  
    yPos += yVelocity;
    xPos += xVelocity;
  }
}

  
  
