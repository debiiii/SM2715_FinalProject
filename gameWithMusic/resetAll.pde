void resetAll() {
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




  beeTime = 0.0;
  beeTimeIncrease = 0.008;

  //bee particle
  beeParticles.clear();
  getBeePosDone = false;
  beeParticlesCounter = 150;

  //opening
  openingCounter = 0;
  openingTimeStamp = millis();
  openingT = 0.0;
  openingTIncrease = 0.004;
  box.add(new myRect());  

  for (int i = 0; i < beePicName.length; i++) {
    beePic[i] = loadImage(beePicName[i]);
  }

  gameOver = false;
  openScreen = true;
}