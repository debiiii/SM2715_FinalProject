//array list for my bee
//bee fly - noise
//bee tail -bimage get color
//rect - gradient?

//game flow
boolean gameOver = false;
int cubeL = 150;
int cubeS = 20;
ArrayList<myRect> box = new ArrayList<myRect>();
float speedIndex=1;

//boundary
int lBB = 600;
int rBB = 0;
int uBB = 600;
int dBB = 0;

//test
int dirCount = 0;

void setup() {
  size(600, 600);
  background(255);
  box.add(new myRect());
}

void draw() { 
  noStroke();
  fill(255);
  rectMode(CORNER);
  rect(0, 0, 600, 600);

  updateBoundary();
  gameController();
  
}

//update the boundary for the whole box
void updateBoundary() {
  //reset the original values for the boundaries
  lBB = 600;
  rBB = 0;
  uBB = 600;
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
  fill(158, 226, 213);
  rectMode(CORNERS);
  rect(lBB, uBB, rBB, dBB);
}

void checkOrigDelta() {
}

void moveToZero() {
}


//control the whole game flow
void gameController() {
  //add one box to the screen in some frequency
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
    box.add(new myRect(dirCount, addAt, color(158, 226, 213)));
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
  if (!box.get(box.size()-1).theSlideOne && !box.get(box.size()-1).cutFinished) {
    //if so, cut all the boxes accordingly
    doCutting();
    //play notes while do cuttings 
  } else {
    //keep sliding
    box.get(box.size()-1).slideIn();
  }

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
  }
  box.get(box.size()-1).isSliding = false;
  box.get(box.size()-1).cutFinished = true;
}


//if spacebar is pressed, do...
void keyPressed() {
  if (key == ' ') {
    //play note also okay
    sc.playNote(note[noteCounter%note.length][0] + 12, 100, 1.0);
    sc2.playNote(note[noteCounter%note.length][1] + 12, 100, 4.0);
    sc3.playNote(note[noteCounter%note.length][2] + 12, 100, 4.0);
    sc4.playNote(note[noteCounter%note.length][3] + 12, 100, 1.0);
    sc5.playNote(note[noteCounter%note.length][4] + 12, 100, 0.5);
    noteCounter += 1;

    //1。check if totally out of boundary
    //2 check and cut 
    //print("low: " + box.get(box.size()-1).lowMost + " ubb " + uBB);
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