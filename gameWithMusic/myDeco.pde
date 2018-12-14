class myDeco {

    int waveX;
    int waveY;
    int waveSizeNum;
    int waveCur = 1;
    int waveStart = 0;
    boolean finished= false;

    myDeco(int waveSize) {
      // constructor code
      waveX = 5+floor(random(width-10));
      waveY = 5+floor(random(height-10));
      //24,72
      waveSizeNum = floor(map(waveSize, 30, 90, 3, 9));
    }

    void wave() {
      //push pop
      for (int i = waveStart; i < waveCur; i++) {
        rectMode(CENTER);
        stroke(166,229,215,(1-i*0.1)*255);
        noFill();
        rect(waveX, waveY,10 + i * (15+i/2),10 + i * (15+i/2));
        //s.graphics.lineStyle(15+i/2, 0x339BDCCF, 1-i*0.1);
        //s.graphics.drawCircle(waveX, waveY, 10 + i * (15+i/2));
      }
      //growing wave
      if (waveCur < waveSizeNum) {
        waveCur ++;
      } else {
        waveCur = waveSizeNum;
      }
      
      if(waveCur == waveSizeNum && waveStart<waveCur){
        waveStart ++;
      }
      if(waveStart == waveSizeNum){
        finished = true;
      }      
    }

  }