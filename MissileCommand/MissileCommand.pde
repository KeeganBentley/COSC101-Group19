/******************************************************************************
 Authors: Carla Baldassara, Keegan Bentley, Caleb Cooper
 Purpose: To recreate the 1980 classic Missle Command by Atari
 How to compile and run: Click the start button to run. 
 Controls: 
 
 Sound effect source: 
 ******************************************************************************/
import processing.sound.*;

ArrayList<EnemyMissile> enemyMissiles = new ArrayList<EnemyMissile>();
ArrayList<AntiMissile> antiMissiles = new ArrayList<AntiMissile>();
ArrayList<Animation> explosions = new ArrayList<Animation>();

boolean gameOver;
//Will determine the amount of missiles falling each round
int levelTotal = 10; 

int missilesThisLevel = 0;
int levelNumber = 1;

//Used to determine how long between each missile falling
int time = 120; 

int[] mags = {10, 10, 10};
int magNum = 0;

PShape city;
PShape cityHit;
PImage[] explosion;
FloatList xPosCity;
FloatList xPosHitCity;
float ground, x, y, yPosCity;
int cityWidth, cityHeight, blockWidth, score;
int explosion_images = 34;
final int numCities = 6;
SoundFile explosionSound, missileSound, missileLaunch;

color cityCol = color(55, 155, 255);
color baseCol = color(126, 0, 126);  

void setup()
{
  size(800, 600);
  background(0);
  noStroke();
  frameRate(60);
  noCursor();
  
  gameOver = false;
  ground = height * 0.85;
  cityHeight = height / 25;
  cityWidth = width / 20;
  yPosCity = ground;
  xPosCity = new FloatList(0);
  xPosHitCity = new FloatList(0);
  explosion = new PImage[explosion_images];
  blockWidth = cityWidth / 8;

  explosionSound = new SoundFile(this, "explosion.mp3");
  explosionSound.amp(0.05);
  missileSound = new SoundFile(this, "spaceMissile.wav");
  missileSound.amp(0.1);
  missileLaunch = new SoundFile(this, "missileLaunch.wav");
  explosionSound.amp(0.3);

  //City block height ratio relative to city height
  float[] blockHeight = {0, 0.35, 0.65, 1, 0.75, 0.55, 0.85, 1, 0.35, 0};
  float[] blockHitHeight = {0, 0.10, 0.20, 0.20, 0.10, 0.20, 0.20, 0.1, 0.20, 0};

  setCityPos();
  setCityShape(blockHeight);
  setCityHitShape(blockHitHeight);
  createExplosion();
}


void draw()
{
  if (gameOver == false ) {
    background(0);
    //Display user cursor
    fill(255);
    rect(mouseX - ((width/20)/2), mouseY - ((height/20)/2), width/30, height/40);
    
    //Draw in game elements
    drawBase();
    displayCity(xPosCity, yPosCity, xPosHitCity);
    displayScore(); 
    drawAmmo();
    
    //Update all Anti-Missiles
    displayAntiMissiles();
    
    //Launch enemy missiles
    dropMissiles();
    
    //Collision Detection
    if (enemyMissiles.size() > 0) {
      collisionDetect();
    }
    
    //Move enemy missiles
    for (int i = 0; i < enemyMissiles.size(); i++) {
      enemyMissiles.get(i).update();
    }
    
    //Handle explosion animations
    runAnimations();
    
    //Test if the next level should run
    if (enemyMissiles.size() == 0 && missilesThisLevel == levelTotal) {
      nextLevel();
    }
    //Test end game state
    if (xPosCity.size() == 0)
      {
        gameOver = true;
      }
    }
    else {
      background(255,0,0);
      fill(0,255,0);
      textSize(64);
      text("GAME OVER", width/2, height/2);
  }
}

/*
  Purpose: Detects missile collision with the anti missiles and cities.
  Args: None
  Return: None
*/
void collisionDetect() { 
  ArrayList<EnemyMissile> enemyMissilesCopy = enemyMissiles; 
  for (int i=0; i < enemyMissiles.size(); i++) {
    //naming convention EN-enemy MIS-missile TL-TopLeft X-xAxisValue
    float enMisTLX = enemyMissiles.get(i).xPos;
    float enMisTLY = enemyMissiles.get(i).yPos;
    float enMisTRX = enMisTLX + enemyMissiles.get(i).missileWidth;
    float enMisTRY = enMisTLY;
    float enMisBLX = enMisTLX;
    float enMisBLY = enMisTLY + enemyMissiles.get(i).missileHeight;
    float enMisBRX = enMisTRX;
    float enMisBRY = enMisBLY;

    for (int j=0; j < antiMissiles.size(); j++) {
      float antiRad = antiMissiles.get(j).radius;
      float antiX = antiMissiles.get(j).xPos;
      float antiY = antiMissiles.get(j).yPos;

      if (dist(enMisTLX, enMisTLY, antiX, antiY) < antiRad || dist(enMisTRX, 
        enMisTRY, antiX, antiY) < antiRad || dist(enMisBLX, enMisBLY, antiX, 
        antiY) < antiRad || dist(enMisBRX, enMisBRY, antiX, antiY) < antiRad) {

        enemyMissilesCopy.remove(i);
        score += 10;
      }
    }
    if (enemyMissiles.size() > 0) {
      for (int j=0; j < xPosCity.size(); j++) {
        //naming convention EN-enemy MIS-missile TL-TopLeft X-xAxisValue
        //Tests city collision
        if ((enMisBRX >= xPosCity.get(j) && 
          (enMisBRX <= xPosCity.get(j) + cityWidth)) &&
          ((enMisBRY >= yPosCity - cityHeight) && enMisBRY <= yPosCity) &&

          (enMisBLX >= xPosCity.get(j) && 
          (enMisBLX <= xPosCity.get(j) + cityWidth)) &&
          ((enMisBLY >= yPosCity - cityHeight) && enMisBLY <= yPosCity) ||

          (enMisTLX >= xPosCity.get(j) && 
          (enMisTLX <= xPosCity.get(j) + cityWidth)) &&
          ((enMisTLY >= yPosCity - cityHeight) && enMisTLY <= yPosCity) &&

          (enMisTRX >= xPosCity.get(j) && 
          (enMisTRX <= xPosCity.get(j) + cityWidth)) &&
          ((enMisTRY >= yPosCity - cityHeight) && enMisTRY <= yPosCity)) {

          explosions.add(new Animation
            (explosion, xPosCity.get(j), yPosCity - cityHeight*2));
          explosionSound.play();
          xPosHitCity.append(xPosCity.get(j));   
          xPosCity.remove(j);
          enemyMissilesCopy.remove(i);
        }
      }
      if (enMisBRY > ground) {
        enemyMissilesCopy.remove(i);
      }
    }
  }
  enemyMissiles = enemyMissilesCopy;
}


/*
  Purpose: Loads the explosion images in an array
  Args: None
  Return: None
*/
void createExplosion() {
  for (int i = 1; i <= explosion.length; i++) {
    String str = "data/" +i +".gif";
    explosion[i-1] = loadImage(str);
  }
}

/*
  Purpose: Displays city and hit city shapes in specified locations
  Args: xPosCity The x-cordinate of the city location
        yPosCity The y-cordinate of the city and hit city location
        xPosHitCity The x-cordinate of the hit city location
  Return: None
*/
void displayCity(FloatList xPosCity, float yPosCity, FloatList xPosHitCity) {
  for (int i = 0; i < xPosCity.size(); i++) {
    shape(city, xPosCity.get(i), yPosCity);
  }

  for (int i = 0; i < xPosHitCity.size(); i++) {
    shape(cityHit, xPosHitCity.get(i), yPosCity);
  }
}

/*
  Purpose: Displays and updates all anti-missiles
  Args: None
  Return: None
*/
void displayAntiMissiles() {
  ArrayList<AntiMissile> antiMissilesCopy = antiMissiles; 
  for (int i=0; i < antiMissiles.size(); i++) {
    if (antiMissiles.get(i).status == true) {
      antiMissiles.get(i).update();
    } else {
      antiMissilesCopy.remove(i);
    }
  }
  antiMissiles = antiMissilesCopy;
}

/*
  Purpose: Displays the score at the top centre of screen
  Args: None
  Return: None
*/
void displayScore() {
  textSize(32);
  textAlign(CENTER);
  fill(255);
  text(score, width/2, height*0.1);
  textSize(18);
  text("Level "+levelNumber, width/2, height-10);
}

/*
  Purpose: Draws ammo and removes from display when used
  Args: None
  Return: None
*/
void drawAmmo() {
  float ammoX = width/2 - 5;
  float ammoY = height - 100;
  int ammoCount = 0;
  fill(0);

  if (mags[magNum] == 0) {
    if (magNum < 2) {
      magNum += 1;
    } else {
      gameOver = true;
    }
  }
  for (int i=0; i < mags.length; i++) {
    if (mags[i] > 0) {
      rect(20*(i+1), height - 60, 10, 10);
    }
  }
  for (int i=0; i < mags[magNum]; i++) {
    rect (ammoX, ammoY, 10, 5);
    if (ammoCount == 0) {
      ammoY += 10;
      ammoX -= 10;
    } else if (ammoCount == 1) {
      ammoX += 20;
    } else if (ammoCount == 2) {
      ammoY += 10;
      ammoX -= 30;
    } else if (ammoCount == 3 || ammoCount == 4) {
      ammoX += 20;
    } else if (ammoCount == 5) {
      ammoY += 10;
      ammoX -= 50;
    } else {
      ammoX += 20;
    }

    ammoCount++;
  }
}


/*
  Purpose: Draws ground level and each side base
 Args: None
 Return: None
 */
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

/*
 Purpose: Controls the creation of new enemy missiles
 Args: None
 Return: None
 */
void dropMissiles() {
  //every 2 seconds adds a new enemymissile to the arrayList   
  if (frameCount % time == 0) {
    if (missilesThisLevel < levelTotal) {
      if (xPosCity.size() > 0)  {
      enemyMissiles.add(new EnemyMissile(xPosCity.get(int(random(xPosCity.size()))) + 20, yPosCity - 20));
      missileSound.play();
      missilesThisLevel++;
      }
    }
  }
}

/*
  Purpose: Creates a missile and adds location to array as 
 mouse is clicked
 Args: None
 Return: None
 */
void mousePressed() {
  if (mouseY < height - 120) {
    mags[magNum] -= 1;
    if (mags[magNum] >= 0) {
      antiMissiles.add(new AntiMissile(mouseX, mouseY));
      missileLaunch.play();
    }
  }
}

/*
  Purpose: Resets variables for next level and calculates score
  Args: None
  Return: None
*/
void nextLevel(){
  for (int j = 0; j < xPosCity.size(); j++) {
    score += 10;
  }
    
  for(int k = 0; k < mags.length; k++){
    if(mags[k] >= 0) {
      score += mags[k]*10;
    }
    mags[k] = 10;
  }
    
    baseCol = color(int(random(255)),int(random(255)),int(random(255)));
    magNum = 0;
    missilesThisLevel = 0;
    levelNumber++; 
  }


/*
  Purpose: Updates animations
  Args: None
  Return: None
*/
void runAnimations() {
  ArrayList<Animation> explosionsCopy = explosions;
  for (int i=0; i < explosions.size(); i++) {
    if (explosions.get(i).status == true) {
      explosions.get(i).display();
      explosions.get(i).update();
    }
    else {
      explosionsCopy.remove(i);
    }
  }
  explosions = explosionsCopy;
}

/*
  Purpose: Draws the hit city shape
 Args: bHeight An array of ratios for building heights
 Return: None
 */
void setCityHitShape(float[] bHitHeight) { 
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

/*
  Purpose: Sets and appends x-cordinates for cities
 Args: None
 Return: None
 */
void setCityPos() {
  for (int i = 0; i < numCities; i++) {  
    if (i < numCities/2 ) {
      xPosCity.append(width * (i + 1) / 10 );
    } else {
      xPosCity.append(width * (i + 3) / 10 + cityWidth);
    }
  }
}

/*
  Purpose: Draws the city shape
  Args: bHeight An array of ratios for building heights
  Return: None
*/
void setCityShape(float[] bHeight) { 
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
