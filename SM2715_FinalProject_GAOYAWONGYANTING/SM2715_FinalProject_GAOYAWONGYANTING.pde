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
int uBB = 0;
int dBB = 600;

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

  for(int i = 0; i<box.size(); i++){
    if(!box.get(i).isSliding){
      //lbb
      if(box.get(i).leftMost < lBB){
        lBB = box.get(i).leftMost;
        println("lbb " + lBB);
      }
      if(box.get(i).rightMost > rBB){
        rBB = box.get(i).rightMost;
        println("rbb " + rBB);
      }
      if(box.get(i).lowMost < dBB){
        dBB = box.get(i).lowMost;
        println("dbb " + dBB);
      }
      if(box.get(i).topMost > uBB){
        uBB = box.get(i).topMost;
        println("ubb " + uBB);
      }
    }
  }

  
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
  
  for(int i = box.size()-1; i>=0; i--){
     box.get(i).slideIn();    
  }
  for(int i = 0; i<box.size(); i++){
    if(box.get(i).checkAlive()){
      box.get(i).display();
    }
  }
}

void keyPressed(){
  if(key == ' '){
    //1。check if totally out of boundary
    //2 check and cut 
    //print("low: " + box.get(box.size()-1).lowMost + " ubb " + uBB);
    if(box.get(box.size()-1).leftMost > rBB 
    || box.get(box.size()-1).rightMost < lBB
    || box.get(box.size()-1).topMost > dBB
    || box.get(box.size()-1).lowMost < uBB){
      print("game over");
    }else{
      box.get(box.size()-1).isSliding = false;
      
    }
    
  }
}