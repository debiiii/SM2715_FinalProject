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

  void wave() {
    //push pop
    pushMatrix();        
    translate(waveX, waveY);
    rotate(radians(rotateIndex));
    rotateIndex += rotateAdd;
    for (int i = waveStart; i < waveCur; i++) {
      rectMode(CENTER);
      stroke(166, 229, 215, (1-i*0.08)*255);
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