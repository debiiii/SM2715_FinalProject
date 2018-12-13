class myRect{
  int rx;
  int ry;
  //long side = 80
  //short side = 10
  int rw;
  int rh;
  int dir;
  color c;
  int fromSide; //0 = up, 1 = right, 2 = down; 3 = left
  boolean isAlive = true;
  boolean isSliding = true; //if space, is sliding = false;
  
  //the constructor for the basic one
  myRect(){
    rx = width/2;
    ry = height/2;
    rw = 80;
    rh = 80;
    c = color(62,198,172);
    isSliding = false;
  }
  
  myRect(int from, int inXY, color fillc){
    c = fillc;
    fromSide = from;
    if(fromSide%2 == 0){
      rx = inXY;
      rw = 10;
      rh = 80;           
    }else{
      ry = inXY;
      rw = 80;
      rh = 10;      
    }
    
    if(fromSide<2){
      dir = 1;      
    }else{
      dir = -1;
    }    
  }
  
  void slideIn(){
    if(isSliding){
      rx += dir * speed;
    }
  }
  
  void display(){
    noStroke();
    fill(c);
    rectMode(CENTER);
    rect(rx,ry,rw,rh);
  }
  
  boolean checkAlive(){
    if(rw <=0 || rh <=0){
      isAlive = false;
      return false;
    }
    return true;
  }
  
  void cutExtra(){
    
  }
  
  //move the whole shape to the center point
  void backToOrig(int deltaX, int deltaY){
    rx += deltaX;
    ry += deltaY;
  }
  
  
  
  
  

}