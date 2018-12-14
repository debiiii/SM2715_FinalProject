String[] highScore = new String[5];
//int[] scoreValue = new I
boolean onList = false; 
int listPos = 5;

void scoreList() {
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