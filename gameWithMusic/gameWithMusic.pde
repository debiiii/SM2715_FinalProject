import processing.sound.*;

SoundFile canon;
Amplitude amp;

//game flow
boolean gameOver = false;
int cubeL = 150;
int cubeS = 20;
ArrayList<myRect> box = new ArrayList<myRect>();
float speedIndex=1;
int xTo0 = 0;
int yTo0 = 0;
int moveBackSpdX = 1;
int moveBackSpdY = 1;
int stepCounter = 0;
int myScore = 0;
int smallSpd = 2;
boolean endScreen = false;
boolean cPlayed = false;

//Visual effect
PImage img;
PFont font;
ArrayList<myDeco> deco = new ArrayList<myDeco>();
ArrayList<myDeco> endDeco = new ArrayList<myDeco>();
int endAlpha = 20;

//boundary
int lBB = width;
int rBB = 0;
int uBB = height;
int dBB = 0;

//test
int dirCount = 0;

//bee
String[] beePicName = {"bee1.png", "bee2.png", "bee3.png", "bee4.png"};
PImage[] beePic = new PImage[beePicName.length];
int beePicCounter = 0;
int beePicTimeStamp = 0;
int beePicAlpha = 255;

float beeX;
float beeY;

ArrayList<PVector> beePrevPt = new ArrayList<PVector>();
int beeTailTimeStamp = 0;
int beeTailAlpha = 30;

float beeTime = 0.0;
float beeTimeIncrease = 0.008;

//bee particle
ArrayList<particle> beeParticles;
boolean getBeePosDone = false;
int beeParticlesCounter = 150;

void setup() {
  size(600, 600);
  img = loadImage("bg03.png");
  font = createFont("UniSansThin.otf", 32, true);
  canon = new SoundFile(this, "canon.mp3");
  amp = new Amplitude(this);
  amp.input(canon);
  //loadFont("UniSansThin.otf");
  background(255);
  box.add(new myRect());  

  //bee
  for (int i = 0; i < beePicName.length; i++) {
    beePic[i] = loadImage(beePicName[i]);
  }

  //bee particle
  beeParticles = new ArrayList<particle>();
}

void draw() { 
  noStroke();
  fill(50);
  //fill(254,255,250);
  rectMode(CORNER);
  rect(0, 0, width, height);

  drawDecos();  
  if (!gameOver) {
    updateBoundary();
    gameController();
  }
  moveToCenter();
  if (!gameOver) {
    updateBeePos();
  }
  fillGap();
  displayAlive();
  drawBee();
  checkBeeDie();

  //show score
  fill(249, 139, 127);
  textFont(font, 15);
  textAlign(CENTER);
  String scoreTxt = nf(myScore, 5);
  text("Score: " + scoreTxt, 60, 35); 

  if (endScreen) {
    drawEnding();
  }
}

void drawEnding() {
  noStroke();
  fill(50, endAlpha);
  rectMode(CORNER);
  rect(0, 0, width, height);
  if (endAlpha<255) {
    endAlpha += 30;
  } else {
    endAlpha = 255;
  }
  if (!cPlayed) {
    canon.loop();
    scoreList();
    cPlayed = true;
  }
  //for start
  //if(endDeco.size() == 0){
  //  endDeco.add(new myDeco(100,100,floor(random(50,70)),2,1));
  //}
  if (amp.analyze()>0.3) {
    endDeco.add(new myDeco(floor(amp.analyze()*100), 2, 1));
  }  
  for (int i = 0; i<endDeco.size(); i++) {
    endDeco.get(i).wave();
  }  

  fill(255);
  textFont(font, 50);
  textAlign(CENTER, CENTER);
  text(myScore, width/2, 100); 

  for (int i = 0; i<5; i++) {   
    noStroke();
    fill(0, 150);
    if (onList && i == listPos) {
      fill(17, 122, 131, 150);
    }
    rectMode(CENTER);
    rect(width/2, 205+ i*60, 250, 40, 10);
    //fill(249, 139, 127);
    fill(255);
    textFont(font, 15);
    textAlign(CENTER, CENTER);
    String scoreTxt = nf(myScore, 5);
    text("RANKING No." + (i+1) + "            " + nf(Integer.parseInt(highScore[i]), 5), width/2, 205+ i*60);
  }
}

void drawDecos() {

  for (int i = deco.size()-1; i>=0; i--) {
    if (deco.get(i).finished == true) {
      deco.remove(i);
    }
  }

  for (int i = 0; i<deco.size(); i++) {
    deco.get(i).wave();
  }
}

//update the boundary for the whole box
void updateBoundary() {
  //reset the original values for the boundaries
  lBB = width;
  rBB = 0;
  uBB = height;
  dBB = 0;

  //for all the boxes,except the one that is sliding
  for (int i = 0; i<box.size(); i++) {
    if (!box.get(i).isSliding) {
      //check lbb, if the left most value of the box is smaller than the lBB, update the lBB
      if (box.get(i).leftMost < lBB) {
        lBB = box.get(i).leftMost;
        //println("lbb " + lBB);
      }
      //same as above
      if (box.get(i).rightMost > rBB) {
        rBB = box.get(i).rightMost;
        //println("rbb " + rBB);
      }
      //same as above
      if (box.get(i).lowMost > dBB) {
        dBB = box.get(i).lowMost;
        //println("dbb " + dBB);
      }
      //same as above
      if (box.get(i).topMost < uBB) {
        uBB = box.get(i).topMost;
        //println("ubb " + uBB);
      }
    }
  }
  //draw a box with the same color at the back to fill up the blanks
  //fill(158, 226, 213);
  //rectMode(CORNERS);
  //rect(lBB, uBB, rBB, dBB);
}

void origData() {

  xTo0 = width/2-((rBB-lBB)/2 + lBB);
  yTo0 = height/2-((dBB-uBB)/2 + uBB);
  println("center: "+ ((rBB-lBB)/2 + lBB)+ " x: " + xTo0 + " ,y: " + yTo0);


  moveBackSpdX = xTo0/8;
  moveBackSpdY = yTo0/8;
}

void moveToCenter() {
  origData();
  if (stepCounter<16) {
    for (int i = 0; i<box.size(); i++) {  
      box.get(i).rx += moveBackSpdX;
      box.get(i).ry += moveBackSpdY;
    }
  }
  stepCounter += 1;
}

void fillGap() {
  for (int i = 0; i<box.size(); i++) {
    for (int j = 0; j<box.size(); j++) {
      if (i!=j && !box.get(i).theSlideOne && !box.get(j).theSlideOne) {
        if (abs(box.get(i).rightMost - box.get(j).leftMost)<=5) {

          rectMode(CORNERS);
          if (box.get(i).rh < box.get(j).rh) {   
            fill(box.get(i).c);
            rect(floor(box.get(i).rightMost), floor(box.get(i).topMost), 
              ceil(box.get(j).leftMost), ceil(box.get(i).lowMost));
          } else {
            fill(box.get(j).c);
            rect(floor(box.get(i).rightMost), floor(box.get(j).topMost), 
              ceil(box.get(j).leftMost), ceil(box.get(j).lowMost));
          }
        }

        if (abs(box.get(i).lowMost - box.get(j).topMost)<=5) {
          rectMode(CORNERS);
          if (box.get(i).rw < box.get(j).rw) {   
            fill(box.get(i).c);
            rect(floor(box.get(i).leftMost), floor(box.get(i).lowMost), 
              ceil(box.get(i).rightMost), ceil(box.get(j).topMost));
          } else {
            fill(box.get(j).c);
            rect(box.get(j).leftMost, floor(box.get(i).lowMost), 
              box.get(j).rightMost, ceil(box.get(j).topMost));
          }
        }
      }
    }
  }
}

void checkFirstDeath() {
  if (!box.get(0).isAlive) {
    gameOver = true;
  }
}

//control the whole game flow
void gameController() {
  //add one box to the screen in some frequency
  if (frameCount%600 == 0 && frameCount <= 18000) {
    speedIndex-=0.02;
    smallSpd += 1;
  }
  if (floor(frameCount % 60*speedIndex) == 1) {
    int addAt = 0;
    //generate the position of the sliding box
    switch(dirCount) {
    case 0:
      //half chance from one side, half chance from the other
      if (random(1)>0.5) {
        addAt = rBB + cubeS/2;
      } else {
        addAt = lBB - cubeS/2;
      }
      break;
    case 1:
      if (random(1)>0.5) {
        addAt = uBB - cubeS/2;
      } else {
        addAt = dBB + cubeS/2;
      }
      break;
    case 2:
      if (random(1)>0.5) {
        addAt = rBB + cubeS/2;
      } else {
        addAt = lBB - cubeS/2;
      }
      break;
    case 3:
      if (random(1)>0.5) {
        addAt = uBB - cubeS/2;
      } else {
        addAt = dBB + cubeS/2;
      }
      break;
    }
    //push one rect to the arraylist
    box.add(new myRect(dirCount, addAt, color(floor(random(158)), 226, 213)));
    //update the adding direction for the next time
    dirCount = (dirCount+floor(random(5)))%4;
  }

  //remove the ones that have no volume
  for (int i = box.size()-1; i>=0; i--) {
    if (!box.get(i).checkAlive()) {
      box.remove(i);
    }
  }

  //check if the sliding box should be fixed
  if (box.size()>0 && !box.get(box.size()-1).theSlideOne && !box.get(box.size()-1).cutFinished) {
    //if so, cut all the boxes accordingly
    doCutting();
    //origData();
    stepCounter = 0;
    myScore += 1;
  } else {
    //keep sliding
    box.get(box.size()-1).slideIn();
  }
}

void displayAlive() {
  //diso=play all the boxes that are alive
  for (int i = 0; i<box.size(); i++) {
    if (box.get(i).checkAlive()) {
      box.get(i).display();
    }
  }
}

//cute all the boxes
void doCutting() {
  int tempLB;
  int tempHB;
  if (box.get(box.size()-1).fromSide%2 == 1) {

    if (box.get(box.size()-1).leftMost > lBB) {
      tempLB = box.get(box.size()-1).leftMost;
    } else {
      tempLB = lBB;
    }

    if (box.get(box.size()-1).rightMost < rBB) {
      tempHB = box.get(box.size()-1).rightMost;
    } else {
      tempHB = rBB;
    }
    for (int i = 0; i<box.size(); i++) {
      box.get(i).cutExtra(true, tempLB, tempHB);
    }

    //check bee x out of cutting lines
    if (beeX < tempLB || beeX > tempHB) {
      gameOver = true;
    }
  } else {
    if (box.get(box.size()-1).topMost > uBB) {
      tempLB = box.get(box.size()-1).topMost;
    } else {
      tempLB = uBB;
    }

    if (box.get(box.size()-1).lowMost < dBB) {
      tempHB = box.get(box.size()-1).lowMost;
    } else {
      tempHB = dBB;
    }
    println("low " + box.get(box.size()-1).lowMost);
    println("dBB " + dBB);
    println("the new tempHB " + tempHB);

    for (int i = 0; i<box.size(); i++) {
      box.get(i).cutExtra(false, tempLB, tempHB);
    }

    //check bee y out of cutting lines
    if (beeY < tempLB || beeY > tempHB) {
      gameOver = true;
    }
  }
  box.get(box.size()-1).isSliding = false;
  box.get(box.size()-1).cutFinished = true;
}

void updateBeePos() {
  //bee X, Y pos
  float tempX = noise(beeTime);
  beeX = map(tempX, 0, 1, lBB, rBB);
  float tempY = noise(beeTime + 150);
  beeY = map(tempY, 0, 1, uBB, dBB);

  //bee tail pos
  if (millis() - beeTailTimeStamp > 600) {
    beePrevPt.add(new PVector(beeX, beeY, 0));
    beeTailTimeStamp = millis();
  }

  //only keeping 10 point for bee tail
  if (beePrevPt.size() > 10) {
    beePrevPt.remove(0);
  }

  //bee flying noise 
  beeTime += beeTimeIncrease;
}

void drawBee() {

  //draw bee tail
  for (int i = 0; i < beePrevPt.size(); i++) {
    PVector pt = beePrevPt.get(i);
    //fill(249, 139, 127, i * 30);
    //fill(255, i * 30);
    fill(img.get(floor(pt.x), floor(pt.y)), i * beeTailAlpha);
    ellipse(pt.x, pt.y, 5, 5);
  }

  //draw bee pic animation
  imageMode(CENTER);
  tint(255, beePicAlpha);
  image(beePic[beePicCounter%beePicName.length], beeX, beeY, 30, 30);
  if (millis() - beePicTimeStamp > 100) {
    beePicCounter += 1; 
    beePicTimeStamp = millis();
  }
}

void drawBeeParticle() {

  beeParticles.add(new particle(new PVector(beeX, beeY)));

  for (int i = 0; i < beeParticles.size(); i++) {
    particle p = beeParticles.get(i);
    p.play();
    if (p.isDead()) {
      beeParticles.remove(i);
    }
  }
}

void checkBeeDie() {

  //when the tail is outside boundry
  for (int i = 0; i < beePrevPt.size(); i++) {
    PVector pt = beePrevPt.get(i);
    if (pt.x < lBB || pt.x > rBB || pt.y < uBB || pt.y > dBB) {
      beePrevPt.remove(i);
    }
  }

  if (gameOver) {
    beePicAlpha -= 2;
    beeTailAlpha -= 5;
    if (beeParticlesCounter > 0) {
      drawBeeParticle();
    }
    beeParticlesCounter--;
    if (beeParticlesCounter <= 0) {
      endScreen = true;
    }
  }
}


//if spacebar is pressed, do...
void keyPressed() {
  if (!gameOver) {
    if (key == ' ') {
      //play note also okay
      sc.playNote(note[noteCounter%note.length][0] + 12, 100, 1.0);
      sc2.playNote(note[noteCounter%note.length][1] + 12, 100, 4.0);
      sc3.playNote(note[noteCounter%note.length][2] + 12, 100, 4.0);
      sc4.playNote(note[noteCounter%note.length][3] + 12, 100, 1.0);
      sc5.playNote(note[noteCounter%note.length][4] + 12, 100, 0.5);
      noteCounter += 1;
      //add note effect
      for (int i = 0; i < 5; i++) {
        if (note[noteCounter][i] != 0) {
          deco.add(new myDeco(note[noteCounter][i], 5, 1));
          deco.add(new myDeco(90, 5, 1));
        }
      }   


      if (box.get(box.size()-1).leftMost > rBB 
        || box.get(box.size()-1).rightMost < lBB
        || box.get(box.size()-1).topMost > dBB
        || box.get(box.size()-1).lowMost < uBB) {
        print("game over");
        //play die animation
      } else {
        box.get(box.size()-1).theSlideOne = false;
      }
    }
  }
}