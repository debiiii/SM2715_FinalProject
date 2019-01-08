import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.sound.*; 
import arb.soundcipher.*; 
import arb.soundcipher.constants.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class gameWithMusic extends PApplet {



SoundFile canon;
Amplitude amp;

AudioIn input;
Amplitude rms;

//game flow
boolean resetDone = false;
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
boolean useKeyboard = true;
boolean openScreen = true;
boolean startedRecording = false;
int gameOverCount = 0;
boolean gameOverNext = false;
boolean canClap = true;

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

float beeTime = 0.0f;
float beeTimeIncrease = 0.008f;

//bee particle
ArrayList<particle> beeParticles;
boolean getBeePosDone = false;
int beeParticlesCounter = 150;

//opening
int openingCounter = 0;
int openingTimeStamp = 0;
float openingT = 0.0f;
float openingTIncrease = 0.004f;
float openingBeeX, openingBeeY;

public void setup() {
  
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

  input = new AudioIn(this, 0);
}

public void draw() { 
  noStroke();
  fill(50);
  //fill(254,255,250);
  rectMode(CORNER);
  rect(0, 0, width, height);
  
  if(gameOver){
    gameOverCount += 1;
    //remove the ones that have no volume
  for (int i = box.size()-1; i>=0; i--) {
    if (!box.get(i).checkAlive()) {
      box.remove(i);
    }
  }
  }

  if (openScreen) {
    drawOpening();
  } else {
    voiceControl();
    drawDecos();  
    if (!gameOver) {
      updateBoundary();
      gameController();
      checkFirstDeath();
    }
    moveToCenter();
    if (!gameOver) {
      updateBeePos();
    }
    //if(gameOverCount <= 1){
      fillGap();
    //}
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
}

public void drawOpening() {
  noStroke();
  fill(50, endAlpha);
  rectMode(CORNER);
  rect(0, 0, width, height);
  if (endAlpha<255) {
    endAlpha += 30;
  } else {
    endAlpha = 255;
  }

  fill(255);
  textFont(font, 50);
  textAlign(CENTER, CENTER);
  text("BeeCut", width/2, height/2 - 150);

  textFont(font, 16);
  text("--  (K)eyboard /  (V)oice  --", width/2, height - 100);

  float tempX = noise(openingT);
  openingBeeX = map(tempX, 0, 1, width/2 - 100, width/2 + 100);
  float tempY = noise(openingT + 150);
  openingBeeY = map(tempY, 0, 1, height/2 - 100, height/2 + 100);
  println(" ");
  println("x " + openingBeeX + " y " + openingBeeY);
  println(" ");

  tint(255, beePicAlpha);
  image(beePic[openingCounter%beePicName.length], openingBeeX, openingBeeY, 50, 50);
  if (millis() - openingTimeStamp > 100) {
    openingCounter += 1; 
    openingTimeStamp = millis();
  }
  openingT += openingTIncrease;

  resetDone = false;
}

public void drawEnding() {
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
  if (amp.analyze()>0.3f) {
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

  fill(255);
  textAlign(CENTER, CENTER);
  textFont(font, 16);
  text("--  (R)estart  --", width/2, height - 80);
}


public void drawDecos() {

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
public void updateBoundary() {
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

public void origData() {

  xTo0 = width/2-((rBB-lBB)/2 + lBB);
  yTo0 = height/2-((dBB-uBB)/2 + uBB);
  println("center: "+ ((rBB-lBB)/2 + lBB)+ " x: " + xTo0 + " ,y: " + yTo0);


  moveBackSpdX = xTo0/8;
  moveBackSpdY = yTo0/8;
}

public void moveToCenter() {
  origData();
  if (stepCounter<16) {
    for (int i = 0; i<box.size(); i++) {  
      box.get(i).rx += moveBackSpdX;
      box.get(i).ry += moveBackSpdY;
    }
  }
  stepCounter += 1;
}

public void fillGap() {
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

public void checkFirstDeath() {
  if (!box.get(0).isAlive) {
    gameOver = true;
  }
}

//control the whole game flow
public void gameController() {
  //add one box to the screen in some frequency
  if (frameCount%600 == 0 && frameCount <= 18000) {
    speedIndex-=0.02f;
    smallSpd += 1;
  }
  if (floor(frameCount % 60*speedIndex) == 1) {
    int addAt = 0;
    //generate the position of the sliding box
    switch(dirCount) {
    case 0:
      //half chance from one side, half chance from the other
      if (random(1)>0.5f) {
        addAt = rBB + cubeS/2;
      } else {
        addAt = lBB - cubeS/2;
      }
      break;
    case 1:
      if (random(1)>0.5f) {
        addAt = uBB - cubeS/2;
      } else {
        addAt = dBB + cubeS/2;
      }
      break;
    case 2:
      if (random(1)>0.5f) {
        addAt = rBB + cubeS/2;
      } else {
        addAt = lBB - cubeS/2;
      }
      break;
    case 3:
      if (random(1)>0.5f) {
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
    sc.playNote(note[noteCounter%note.length][0] + 12, 100, 1.0f);
    sc2.playNote(note[noteCounter%note.length][1] + 12, 100, 4.0f);
    sc3.playNote(note[noteCounter%note.length][2] + 12, 100, 4.0f);
    sc4.playNote(note[noteCounter%note.length][3] + 12, 100, 1.0f);
    sc5.playNote(note[noteCounter%note.length][4] + 12, 100, 0.5f);
    noteCounter += 1;
    //add note effect
    for (int i = 0; i < 5; i++) {
      if (note[noteCounter][i] != 0) {
        deco.add(new myDeco(note[noteCounter][i], 5, 1));
        deco.add(new myDeco(90, 5, 1));
      }
    }
    doCutting();
    //origData();
    stepCounter = 0;
    myScore += 1;
  } else {
    //keep sliding
    box.get(box.size()-1).slideIn();
  }
}

public void displayAlive() {
  //diso=play all the boxes that are alive
  for (int i = 0; i<box.size(); i++) {
    if (box.get(i).checkAlive()) {
      box.get(i).display();
    }
  }
}

//cute all the boxes
public void doCutting() {
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

public void updateBeePos() {
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

public void drawBee() {

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

public void drawBeeParticle() {

  beeParticles.add(new particle(new PVector(beeX, beeY)));
  canClap = true;

  for (int i = 0; i < beeParticles.size(); i++) {
    particle p = beeParticles.get(i);
    p.play();
    if (p.isDead()) {
      beeParticles.remove(i);
    }
  }
}

public void checkBeeDie() {

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


public void voiceControl() {
  if (!useKeyboard) {
    if (rms.analyze()>0.2f) {

      println("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");

      if (!gameOver && canClap) {
        canClap = false;
        //play note also okay
        sc.playNote(note[noteCounter%note.length][0] + 12, 100, 1.0f);
        sc2.playNote(note[noteCounter%note.length][1] + 12, 100, 4.0f);
        sc3.playNote(note[noteCounter%note.length][2] + 12, 100, 4.0f);
        sc4.playNote(note[noteCounter%note.length][3] + 12, 100, 1.0f);
        sc5.playNote(note[noteCounter%note.length][4] + 12, 100, 0.5f);
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
}


//if spacebar is pressed, do...
public void keyPressed() {
  if (endScreen) {
    if (key == 'R' || key == 'r') {
      if (!resetDone) {
        resetAll();
        resetDone = true;
      }
    }
  }

  if (key == 'K' || key == 'k') {
    openScreen = false;
    useKeyboard = true;
  } else if (key == 'V' || key == 'v') {
    openScreen = false;
    useKeyboard = false;
    if (!startedRecording) {
      input.start();
      // create a new Amplitude analyzer
      rms = new Amplitude(this);
      // Patch the input to an volume analyzer
      rms.input(input);
      input.amp(1.0f);
      startedRecording = true;
    }
  }

  if (useKeyboard) {
    if (!gameOver) {
      if (key == ' ') {
        //play note also okay



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
}



SoundCipher sc = new SoundCipher(this);
SoundCipher sc2 = new SoundCipher(this);
SoundCipher sc3 = new SoundCipher(this);
SoundCipher sc4 = new SoundCipher(this);
SoundCipher sc5 = new SoundCipher(this);

boolean canPlay = false;

int noteCounter = 0;

int[][] note = { {48, 0, 0, 0, 0}, 
  {48, 52, 0, 0, 0}, 
  {48, 55, 0, 0, 0}, 
  {48, 60, 0, 0, 0}, 

  {43, 0, 0, 0, 0}, 
  {43, 50, 0, 0, 0}, 
  {43, 55, 0, 0, 0}, 
  {43, 59, 0, 0, 0}, 

  {45, 0, 0, 0, 0}, 
  {45, 48, 0, 0, 0}, 
  {45, 52, 0, 0, 0}, 
  {45, 57, 0, 0, 0}, 

  {40, 0, 0, 0, 0}, 
  {40, 47, 0, 0, 0}, 
  {40, 52, 0, 0, 0}, 
  {40, 55, 0, 0, 0}, 

  {41, 0, 0, 0, 0}, 
  {41, 45, 0, 0, 0}, 
  {41, 48, 0, 0, 0}, 
  {41, 53, 0, 0, 0}, 

  {36, 0, 0, 0, 0}, 
  {36, 43, 0, 0, 0}, 
  {36, 48, 0, 0, 0}, 
  {36, 52, 0, 0, 0}, 

  {41, 0, 0, 0, 0}, 
  {41, 45, 0, 0, 0}, 
  {41, 48, 0, 0, 0}, 
  {41, 53, 0, 0, 0}, 

  {43, 0, 0, 0, 0}, 
  {43, 47, 0, 0, 0}, 
  {43, 50, 0, 0, 0}, 
  {43, 55, 0, 0, 0}, 

  //8 - 32
  {36, 64, 0, 0, 0}, 
  {40, 0, 0, 0, 0}, 
  {43, 0, 0, 0, 0}, 
  {48, 0, 0, 0, 0}, 

  {31, 62, 0, 0, 0}, 
  {38, 0, 0, 0, 0}, 
  {43, 0, 0, 0, 0}, 
  {47, 0, 0, 0, 0}, 

  {33, 60, 0, 0, 0}, 
  {36, 0, 0, 0, 0}, 
  {40, 0, 0, 0, 0}, 
  {45, 0, 0, 0, 0}, 

  {28, 59, 0, 0, 0}, 
  {35, 0, 0, 0, 0}, 
  {40, 0, 0, 0, 0}, 
  {43, 0, 0, 0, 0}, 

  {29, 57, 0, 0, 0}, 
  {33, 0, 0, 0, 0}, 
  {36, 0, 0, 0, 0}, 
  {41, 0, 0, 0, 0}, 

  {24, 55, 0, 0, 0}, 
  {31, 0, 0, 0, 0}, 
  {36, 0, 0, 0, 0}, 
  {40, 0, 0, 0, 0}, 

  {29, 57, 0, 0, 0}, 
  {33, 0, 0, 0, 0}, 
  {36, 0, 0, 0, 0}, 
  {41, 0, 0, 0, 0}, 

  {31, 59, 0, 0, 0}, 
  {35, 0, 0, 0, 0}, 
  {38, 0, 0, 0, 0}, 
  {43, 0, 0, 0, 0}, 

  //16 - 64
  {36, 60, 64, 0, 0}, 
  {40, 0, 0, 0, 0}, 
  {43, 0, 0, 0, 0}, 
  {48, 0, 0, 0, 0}, 

  {31, 59, 62, 0, 0}, 
  {38, 0, 0, 0, 0}, 
  {43, 0, 0, 0, 0}, 
  {47, 0, 0, 0, 0}, 

  {33, 57, 60, 0, 0}, 
  {36, 0, 0, 0, 0}, 
  {40, 0, 0, 0, 0}, 
  {45, 0, 0, 0, 0}, 

  {28, 55, 59, 0, 0}, 
  {35, 0, 0, 0, 0}, 
  {40, 0, 0, 0, 0}, 
  {43, 0, 0, 0, 0}, 

  {29, 53, 57, 0, 0}, 
  {33, 0, 0, 0, 0}, 
  {36, 0, 0, 0, 0}, 
  {41, 0, 0, 0, 0}, 

  {24, 52, 55, 0, 0}, 
  {31, 0, 0, 0, 0}, 
  {36, 0, 0, 0, 0}, 
  {40, 0, 0, 0, 0}, 

  {29, 53, 57, 0, 0}, 
  {33, 0, 0, 0, 0}, 
  {36, 0, 0, 0, 0}, 
  {41, 0, 0, 0, 0}, 

  {31, 55, 59, 0, 0}, 
  {35, 0, 0, 0, 0}, 
  {38, 0, 0, 0, 0}, 
  {43, 0, 0, 0, 0}, 

  //24 - 96
  {36, 0, 0, 60, 0}, 
  {43, 0, 0, 59, 0}, 
  {48, 0, 0, 60, 0}, 
  {0, 0, 0, 48, 0}, 

  {31, 0, 0, 47, 0}, 
  {38, 0, 0, 55, 0}, 
  {47, 0, 0, 50, 0}, 
  {47, 0, 0, 52, 0}, 

  {33, 0, 0, 48, 0}, 
  {40, 0, 0, 60, 0}, 
  {45, 0, 0, 59, 0}, 
  {45, 0, 0, 57, 0}, 

  {28, 0, 0, 59, 0}, 
  {35, 0, 0, 64, 0}, 
  {43, 0, 0, 67, 0}, 
  {43, 0, 0, 69, 0}, 

  {29, 0, 0, 65, 0}, 
  {36, 0, 0, 64, 0}, 
  {41, 0, 0, 62, 0}, 
  {41, 0, 0, 65, 0}, 

  {24, 0, 0, 64, 0}, 
  {31, 0, 0, 62, 0}, 
  {40, 0, 0, 60, 0}, 
  {40, 0, 0, 59, 0}, 

  {29, 0, 0, 57, 0}, 
  {36, 0, 0, 55, 0}, 
  {41, 0, 0, 53, 0}, 
  {41, 0, 0, 52, 0}, 

  {31, 0, 0, 50, 0}, 
  {38, 0, 0, 53, 0}, 
  {43, 0, 0, 52, 0}, 
  {43, 0, 0, 50, 0}, 

  {36, 0, 0, 48, 0}, 
  {43, 0, 0, 50, 0}, 
  {48, 0, 0, 52, 0}, 
  {48, 0, 0, 53, 0}, 

  {33, 0, 0, 52, 0}, 
  {40, 0, 0, 57, 0}, 
  {45, 0, 0, 55, 0}, 
  {45, 0, 0, 53, 0}, 

  {28, 0, 0, 55, 0}, 
  {55, 0, 0, 53, 0}, 
  {43, 0, 0, 52, 0}, 
  {43, 0, 0, 50, 0}, 

  {29, 0, 0, 48, 0}, 
  {36, 0, 0, 45, 0}, 
  {41, 0, 0, 57, 0}, 
  {41, 0, 0, 59, 0}, 

  {24, 0, 0, 60, 0}, 
  {31, 0, 0, 59, 0}, 
  {40, 0, 0, 57, 0}, 
  {40, 0, 0, 55, 0}, 

  {29, 0, 0, 53, 0}, 
  {36, 0, 0, 52, 0}, 
  {41, 0, 0, 50, 0}, 
  {41, 0, 0, 57, 0}, 

  {31, 0, 0, 55, 0}, 
  {38, 0, 0, 57, 0}, 
  {43, 0, 0, 55, 0}, 
  {47, 0, 0, 55, 0}, 

  //39 - 156
  {36, 0, 0, 67, 0}, 
  {43, 0, 0, 0, 64}, 
  {43, 0, 0, 0, 65}, 
  {48, 0, 0, 67, 0}, 
  {48, 0, 0, 0, 64}, 
  {0, 0, 0, 0, 65}, 

  {31, 0, 0, 0, 67}, 
  {31, 0, 0, 0, 55}, 
  {38, 0, 0, 0, 57}, 
  {38, 0, 0, 0, 59}, 
  {47, 0, 0, 0, 60}, 
  {0, 0, 0, 0, 62}, 
  {47, 0, 0, 0, 64}, 
  {0, 0, 0, 0, 65}, 

  {33, 0, 0, 64, 0}, 
  {40, 0, 0, 0, 60}, 
  {40, 0, 0, 0, 62}, 
  {45, 0, 0, 0, 64}, 
  {45, 0, 0, 0, 52}, 
  {0, 0, 0, 0, 53}, 

  {28, 0, 0, 0, 55}, 
  {28, 0, 0, 0, 57}, 
  {35, 0, 0, 0, 55}, 
  {35, 0, 0, 0, 53}, 
  {43, 0, 0, 0, 55}, 
  {0, 0, 0, 0, 52}, 
  {43, 0, 0, 0, 53}, 
  {0, 0, 0, 0, 55}, 

  {29, 0, 0, 53, 0}, 
  {36, 0, 0, 0, 57}, 
  {36, 0, 0, 0, 55}, 
  {41, 0, 0, 53, 0}, 
  {41, 0, 0, 0, 52}, 
  {0, 0, 0, 0, 50}, 

  {24, 0, 0, 0, 52}, 
  {24, 0, 0, 0, 50}, 
  {31, 0, 0, 0, 48}, 
  {31, 0, 0, 0, 50}, 
  {40, 0, 0, 0, 52}, 
  {0, 0, 0, 0, 53}, 
  {40, 0, 0, 0, 55}, 
  {0, 0, 0, 0, 57}, 

  {29, 0, 0, 53, 0}, 
  {36, 0, 0, 0, 57}, 
  {36, 0, 0, 0, 55}, 
  {41, 0, 0, 0, 57}, 
  {41, 0, 0, 0, 59}, 
  {0, 0, 0, 0, 60}, 

  {31, 0, 0, 0, 55}, 
  {31, 0, 0, 0, 57}, 
  {38, 0, 0, 0, 59}, 
  {38, 0, 0, 0, 60}, 
  {43, 0, 0, 0, 62}, 
  {0, 0, 0, 0, 64}, 
  {43, 0, 0, 0, 65}, 
  {0, 0, 0, 0, 67}, 

  {36, 0, 0, 64, 0}, 
  {43, 0, 0, 0, 60}, 
  {43, 0, 0, 0, 62}, 
  {48, 0, 0, 64, 0}, 
  {48, 0, 0, 0, 62}, 
  {0, 0, 0, 0, 60}, 

  {31, 0, 0, 0, 62}, 
  {31, 0, 0, 0, 59}, 
  {38, 0, 0, 0, 60}, 
  {38, 0, 0, 0, 62}, 
  {47, 0, 0, 0, 64}, 
  {0, 0, 0, 0, 62}, 
  {47, 0, 0, 0, 60}, 
  {0, 0, 0, 0, 59}, 

  {33, 0, 0, 60, 0}, 
  {40, 0, 0, 0, 57}, 
  {40, 0, 0, 0, 59}, 
  {45, 0, 0, 0, 60}, 
  {45, 0, 0, 0, 48}, 
  {0, 0, 0, 0, 50}, 

  {28, 0, 0, 0, 52}, 
  {28, 0, 0, 0, 53}, 
  {35, 0, 0, 0, 52}, 
  {35, 0, 0, 0, 50}, 
  {43, 0, 0, 0, 52}, 
  {0, 0, 0, 0, 60}, 
  {43, 0, 0, 0, 59}, 
  {0, 0, 0, 0, 60}, 

  {29, 0, 0, 57, 0}, 
  {36, 0, 0, 0, 60}, 
  {36, 0, 0, 0, 59}, 
  {41, 0, 0, 57, 0}, 
  {41, 0, 0, 0, 55}, 
  {0, 0, 0, 0, 53}, 

  {24, 0, 0, 0, 55}, 
  {24, 0, 0, 0, 53}, 
  {31, 0, 0, 0, 52}, 
  {31, 0, 0, 0, 53}, 
  {40, 0, 0, 0, 55}, 
  {40, 0, 0, 0, 57}, 
  {0, 0, 0, 0, 60}, 

  {29, 0, 0, 57, 0}, 
  {36, 0, 0, 0, 60}, 
  {36, 0, 0, 0, 59}, 
  {41, 0, 0, 60, 0}, 
  {41, 0, 0, 0, 59}, 
  {0, 0, 0, 0, 60}, 

  {31, 0, 0, 0, 59}, 
  {38, 0, 0, 0, 62}, 
  {38, 0, 0, 0, 60}, 
  {43, 0, 0, 0, 59}, 
  {0, 0, 0, 0, 60}, 
  {43, 0, 0, 0, 57}, 
  {0, 0, 0, 0, 59}, 

  //266 - 1067
  {36, 60, 64, 0, 0}, 
  {40, 0, 0, 0, 0}, 
  {43, 0, 0, 0, 0}, 
  {48, 0, 0, 0, 0}, 

  {31, 59, 62, 0, 0}, 
  {38, 0, 0, 0, 0}, 
  {43, 0, 0, 0, 0}, 
  {47, 0, 0, 0, 0}, 

  {33, 57, 60, 0, 0}, 
  {36, 0, 0, 0, 0}, 
  {40, 0, 0, 0, 0}, 
  {45, 0, 0, 0, 0}, 

  {28, 55, 59, 0, 0}, 
  {35, 0, 0, 0, 0}, 
  {40, 0, 0, 0, 0}, 
  {43, 0, 0, 0, 0}, 

  {29, 53, 57, 0, 0}, 
  {33, 0, 0, 0, 0}, 
  {36, 0, 0, 0, 0}, 
  {41, 0, 0, 0, 0}, 

  {24, 52, 55, 0, 0}, 
  {31, 0, 0, 0, 0}, 
  {36, 0, 0, 0, 0}, 
  {40, 0, 0, 0, 0}, 

  //295 - 1180
  {57, 53, 0, 0, 29}, 
  {57, 0, 0, 0, 33}, 
  {62, 0, 0, 0, 36}, 
  {62, 0, 0, 0, 41}, 

  {59, 55, 0, 0, 31}, 
  {59, 0, 0, 0, 35}, 
  {62, 0, 0, 0, 38}, 
  {62, 0, 0, 0, 43}, 

  {36, 43, 55, 60, 64}

};
class myDeco {

  int waveX;
  int waveY;
  int waveSizeNum;
  int waveCur = 1;
  int waveStart = 0;
  int spdControl = 1;
  boolean finished= false;
  int rotateIndex = 0;
  int rotateAdd = 0;

  myDeco(int waveSize, int spd, int ra) {
    // constructor code
    waveX = 5+floor(random(width-10));
    waveY = 5+floor(random(height-10));
    //24,72
    waveSizeNum = floor(map(waveSize, 30, 90, 3, 12));
    spdControl = spd;
    rotateAdd = ra;
  }
  
  myDeco(int x, int y, int waveSize, int spd, int ra) {
    // constructor code
    waveX = x;
    waveY = y;
    //24,72
    waveSizeNum = floor(map(waveSize, 30, 90, 3, 12));
    spdControl = spd;
    rotateAdd = ra;
  }

  public void wave() {
    //push pop
    pushMatrix();        
    translate(waveX, waveY);
    rotate(radians(rotateIndex));
    rotateIndex += rotateAdd;
    for (int i = waveStart; i < waveCur; i++) {
      rectMode(CENTER);
      stroke(166, 229, 215, (1-i*0.08f)*255);
      noFill();
      rect(0, 0, 10 + i * (15+i/2), 10 + i * (15+i/2));
    }
    popMatrix();
    //growing wave
    if (frameCount%spdControl == 0) {
      if (waveCur < waveSizeNum) {
        waveCur ++;
      } else {
        waveCur = waveSizeNum;
      }

      if (waveCur == waveSizeNum && waveStart<waveCur) {
        waveStart ++;
      }
    }
    if (waveStart == waveSizeNum) {
      finished = true;
    }
  }
}
class myRect {
  int rx;
  int ry;
  int a = 1;
  //long side = cubeL
  //short side = cubeS
  int rw;
  int rh;
  int dir;
  int c;
  int fromSide; //0 = up, 1 = right, 2 = down; 3 = left
  boolean isAlive = true;
  boolean isSliding = true; //if space, is sliding = false;
  boolean theSlideOne = true;
  boolean cutFinished = false;
  int topMost = 0;
  int lowMost = 600;
  int leftMost = 0;
  int rightMost = 600;
  int speed = smallSpd;

  //the constructor for the basic one
  myRect() {
    rx = width/2;
    ry = height/2;
    rw = cubeL;
    rh = cubeL;
    c = color(249, 139, 127);
    isSliding = false;
    theSlideOne = false;
    cutFinished = true;
    topMost = ry - rh/2;
    lowMost = ry + rh/2;
    leftMost = rx - rw/2;
    rightMost = rx + rw/2;
  }

  myRect(int from, int inXY, int fillc) {
    c = fillc;
    fromSide = from;
    if (fromSide%2 == 0) {
      rx = inXY;
      if (fromSide == 0)
        ry = -cubeL/2;
      else
        ry = height + cubeL/2;
      rw = cubeS;
      rh = cubeL;
    } else {
      ry = inXY;
      if (fromSide == 1)
        rx = -cubeL/2;
      else
        rx = width + cubeL/2;
      rw = cubeL;
      rh = cubeS;
    }

    if (fromSide<2) {
      dir = 1;
    } else {
      dir = -1;
    }
  }

  public void slideIn() {
    if (theSlideOne) {
      if (frameCount % 3 ==0) { 
        speed = speed + a;
      }
      if (fromSide%2 == 1) {
        rx += dir * speed;
      } else {
        ry += dir * speed;
      }
    }
  }

  public void display() {
    noStroke();
    fill(c);
    rectMode(CENTER);
    rect(rx, ry, rw, rh);
    topMost = ry - rh/2;
    lowMost = ry + rh/2;
    leftMost = rx - rw/2;
    rightMost = rx + rw/2;
  }

  public void dieAnimate() {
    noStroke();
    int alp = 200;
    fill(red(c), green(c), blue(c), alp);
    rectMode(CENTER);
    rect(rx, ry, rw, rh);
    topMost = ry - rh/2;
    lowMost = ry + rh/2;
    leftMost = rx - rw/2;
    rightMost = rx + rw/2;
    alp -= 10;
  }

  public boolean checkAlive() {
    if (rw <=0 || rh <=0) {
      isAlive = false;
      return false;
    } else if ((leftMost > rBB && fromSide == 1)
      || (rightMost < lBB && fromSide == 3)
      || (topMost > dBB && fromSide == 0)
      || (lowMost < uBB && fromSide == 2)) {
      isAlive = false;
      gameOver = true;
      //dieAnimate();
      return false;
    }
    return true;
  }

  public void cutExtra(boolean cutX, int lowerBond, int higherBond) {

    if (cutX) {
      leftMost = rx - rw/2;
      rightMost = rx + rw/2;
      if (rightMost < lowerBond) {
        rw = 0;
        //die
      } else if (leftMost > higherBond) {
        rw = 0;
        //die
      } else {
        if (leftMost < lowerBond) {
          int delX = abs(lowerBond - leftMost);
          rx += delX/2;
          rw -= delX;
        }
        if (rightMost > higherBond) {
          int delX = abs(rightMost - higherBond);
          rx -= delX/2;
          rw -= delX;
        }
      }
    } else {
      topMost = ry - rh/2;
      lowMost = ry + rh/2;

      if (lowMost < lowerBond) {
        rh = 0;
      } else if (topMost > higherBond) {
        rh = 0;
      } else {
        if (topMost < lowerBond) {
          int delY = abs(lowerBond - topMost);
          ry += delY/2;
          rh -= delY;
        }
        if (lowMost > higherBond) {
          int delY = abs(lowMost - higherBond);
          ry -= delY/2;
          rh -= delY;
        }
      }
    }
  }

}
//Referece from wk11_02 and Daniel Shiffman <http://www.shiffman.net>

class particle{
  PVector pos;
  PVector velocity;
  PVector acceler;
  int lifeTime;
  
  particle(PVector _pos){
    acceler = new PVector(0, 0.04f);
    velocity = new PVector(random(-1,1), random(-2,0));
    pos = _pos.copy();
    lifeTime = 50;
  }
  
  public void update(){
    velocity.add(acceler);
    pos.add(velocity);
    lifeTime -= 2;
  }
  
  public void drawParticle(){
    noStroke();
    float alpha = map(lifeTime, 50, 0, 255, 0);
    fill(250, 161, 151, alpha);
    ellipse(pos.x, pos.y, 5, 5);
  }
  
  public void play(){
    update();
    drawParticle();
  }
  
  public boolean isDead(){
    if(lifeTime < 0){
      return true;
    }
    else{
      return false;
    }
  }

}
public void resetAll() {
  canon.stop();
  myScore = 0;
  smallSpd = 2;
  speedIndex = 1;
  xTo0 = 0;
  yTo0 = 0;
  stepCounter = 0;
  box.clear();
  deco.clear();
  endDeco.clear();
  endScreen = false;
  cPlayed = false;
  useKeyboard = true;  
  startedRecording = false;
  gameOverNext = false;
  gameOverCount = 0;
  canClap = true;
  endAlpha = 20;

  lBB = width;
  rBB = 0;
  uBB = height;
  dBB = 0;

  dirCount = 0;

  beePicCounter = 0;
  beePicTimeStamp = 0;
  beePicAlpha = 255;
  beePrevPt.clear();
  beeTailTimeStamp = 0;
  beeTailAlpha = 30;




  beeTime = 0.0f;
  beeTimeIncrease = 0.008f;

  //bee particle
  beeParticles.clear();
  getBeePosDone = false;
  beeParticlesCounter = 150;

  //opening
  openingCounter = 0;
  openingTimeStamp = millis();
  openingT = 0.0f;
  openingTIncrease = 0.004f;
  box.add(new myRect());  

  for (int i = 0; i < beePicName.length; i++) {
    beePic[i] = loadImage(beePicName[i]);
  }
  onList = false; 
  listPos = 5;

  gameOver = false;
  openScreen = true;
}
String[] highScore = new String[5];
//int[] scoreValue = new I
boolean onList = false; 
int listPos = 5;

public void scoreList() {
  highScore = loadStrings("score.txt");
  for (int i = 0; i < highScore.length; i++) {
    println(highScore[i]);
  }


  if (myScore >= Integer.parseInt(highScore[4])) {
    highScore[4] = str(floor(myScore));
    onList = true;
  }

  //bubble sort
  for (int i = 0; i < 4; i++) {
    for (int j = 4; j > i; j--) {
      if (Integer.parseInt(highScore[j]) > Integer.parseInt(highScore[j - 1])) {
        int tmp = Integer.parseInt(highScore[j]);
        highScore[j] = highScore[j - 1];
        highScore[j - 1] = str(tmp);
      }
    }
  }

  if (onList) {
    for (int i = 0; i < highScore.length; i++) {
      if (myScore == Integer.parseInt(highScore[i])) {
        listPos = i;
      }
    }
  }

  //write to the highScore txt
  saveStrings(dataPath("score.txt"), highScore);
}
  public void settings() {  size(600, 600); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "gameWithMusic" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
