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

void setup(){
  size(600,600);
  background(255);
  box.add(new myRect());
  
}

void draw(){
  for(int i = 0; i<box.size(); i++){
    if(box.get(i).checkAlive()){
      box.get(i).display();
    }
  }
}

void gameController(){
  //change between center mode or corner?
}