class myRect {
  int rx;
  int ry;
  int a = 1;
  //long side = cubeL
  //short side = cubeS
  int rw;
  int rh;
  int dir;
  color c;
  int fromSide; //0 = up, 1 = right, 2 = down; 3 = left
  boolean isAlive = true;
  boolean isSliding = true; //if space, is sliding = false;
  boolean theSlideOne = true;
  boolean cutFinished = false;
  int topMost = 0;
  int lowMost = 600;
  int leftMost = 0;
  int rightMost = 600;
  int speed = 2;

  //the constructor for the basic one
  myRect() {
    rx = width/2;
    ry = height/2;
    rw = cubeL;
    rh = cubeL;
    c = color(249,139,127);
    isSliding = false;
    theSlideOne = false;
    cutFinished = true;
    topMost = ry - rh/2;
    lowMost = ry + rh/2;
    leftMost = rx - rw/2;
    rightMost = rx + rw/2;
  }

  myRect(int from, int inXY, color fillc) {
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

  void slideIn() {
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

  void display() {
    noStroke();
    fill(c);
    rectMode(CENTER);
    rect(rx, ry, rw, rh);
    topMost = ry - rh/2;
    lowMost = ry + rh/2;
    leftMost = rx - rw/2;
    rightMost = rx + rw/2;
  }

  void dieAnimate() {
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

  boolean checkAlive() {
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

  void cutExtra(boolean cutX, int lowerBond, int higherBond) {

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

  //move the whole shape to the center point
  void backToOrig(int deltaX, int deltaY) { 
  }
}