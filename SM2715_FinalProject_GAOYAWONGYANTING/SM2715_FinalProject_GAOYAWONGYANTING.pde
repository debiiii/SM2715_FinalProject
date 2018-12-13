//array list for my Rect x
//array list for my bee
//function update boundary
//bee fly - noise
//bee tail -bimage get color
//rect - gradient?
//sound?
//game controller - function

//game flow
boolean gameOver = false;
int cubeL = 80;
int cubeS = 10;
ArrayList<myRect> box = new ArrayList<myRect>();

//boundary
int lBB = 600;
int rBB = 0;
int uBB = 600;
int dBB = 0;

//test
int dirCount = 0;

void setup(){
  size(600,600);
  background(255);
  box.add(new myRect());
  
}

void draw(){ 
  noStroke();
  fill(255);
  rectMode(CORNER);
  rect(0,0,600,600);
  
  updateBoundary();
  gameController();

}

void updateBoundary(){
  //reset
  lBB = 600;
  rBB = 0;
  uBB = 600;
  dBB = 0;

  for(int i = 0; i<box.size(); i++){
    if(!box.get(i).isSliding){
      //lbb
      if(box.get(i).leftMost < lBB){
        lBB = box.get(i).leftMost;
        //println("lbb " + lBB);
      }
      if(box.get(i).rightMost > rBB){
        rBB = box.get(i).rightMost;
        //println("rbb " + rBB);
      }
      if(box.get(i).lowMost > dBB){
        dBB = box.get(i).lowMost;
        //println("dbb " + dBB);
      }
      if(box.get(i).topMost < uBB){
        uBB = box.get(i).topMost;
        //println("ubb " + uBB);
      }
    }
  }  
}

void checkOrigDelta(){
}


void gameController(){
  if(frameCount % 100 == 1){
    int addAt = 0;
    switch(dirCount){
      case 0:
      //add possiblilty
      addAt = rBB + cubeS/2;
      break;
      case 1:
      addAt = uBB - cubeS/2;
      break;
      case 2:
      addAt = lBB - cubeS/2;
      break;
      case 3:
      addAt = dBB + cubeS/2;
      break;
            
    }
    box.add(new myRect(dirCount, addAt, color(62,198,172,200)));
    dirCount = (dirCount+1)%4;
    
  }
  for(int i = box.size()-1; i>=0; i--){
    if(!box.get(i).checkAlive()){
      box.remove(i);
    }
  }
  
  
  box.get(box.size()-1).slideIn();    
  
  for(int i = 0; i<box.size(); i++){
    if(box.get(i).checkAlive()){
      box.get(i).display();
    }
  }
}

void keyPressed(){
  if(key == ' '){
    box.get(box.size()-1).theSlideOne = false;
    //1。check if totally out of boundary
    //2 check and cut 
    //print("low: " + box.get(box.size()-1).lowMost + " ubb " + uBB);
    if(box.get(box.size()-1).leftMost > rBB 
    || box.get(box.size()-1).rightMost < lBB
    || box.get(box.size()-1).topMost > dBB
    || box.get(box.size()-1).lowMost < uBB){
      print("game over");
      //play die animation
    }else{
      
      updateBoundary();
      int tempLB;
      int tempHB;
      if(box.get(box.size()-1).fromSide%2 == 1){
          
          if(box.get(box.size()-1).leftMost > lBB){
            tempLB = box.get(box.size()-1).leftMost;
          }else{
            tempLB = lBB;
          }
          
          if(box.get(box.size()-1).rightMost < rBB){
            tempHB = box.get(box.size()-1).rightMost;
          }else{
            tempHB = rBB;
          }
          for(int i = 0; i<box.size(); i++){
            box.get(i).cutExtra(true, tempLB, tempHB);      
          }
                             
        }
        else{
          if(box.get(box.size()-1).topMost > uBB){
            tempLB = box.get(box.size()-1).topMost;
          }else{
            tempLB = uBB;
          }
          
          if(box.get(box.size()-1).lowMost < dBB){
            tempHB = box.get(box.size()-1).lowMost;
          }else{
            tempHB = dBB;            
          }
          println("low " + box.get(box.size()-1).lowMost);
          println("dBB " + dBB);
          println("the new tempHB " + tempHB);
                   
          for(int i = 0; i<box.size(); i++){
            box.get(i).cutExtra(false, tempLB, tempHB);      
          }
        }
        box.get(box.size()-1).isSliding = false;
  
      
      
    }
    
  }
}