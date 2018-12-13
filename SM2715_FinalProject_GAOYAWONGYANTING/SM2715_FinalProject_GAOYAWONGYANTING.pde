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
int speed = 1;
ArrayList<myRect> box = new ArrayList<myRect>();

//boundary
int lBB = 0;
int rBB = 600;
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
  updateBoundary();
  gameController();

}

void updateBoundary(){
  for(int i = 0; i<box.size(); i++){
    if(box.get(i).checkAlive()){
      box.get(i).display();
    }
  }

  
}


void gameController(){
  if(frameCount % 600 == 1){
    //box.add(new myRect(dirCount, ));
    
  }
  //change between center mode or corner?
  for(int i = 0; i<box.size(); i++){
    if(box.get(i).checkAlive()){
      box.get(i).display();
    }
  }
}

void keyPressed(){
  if(key == ' '){
  }
}