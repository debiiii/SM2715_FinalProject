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
  int topMost = 0;
  int lowMost = 600;
  int leftMost = 0;
  int rightMost = 600;
  
  //the constructor for the basic one
  myRect(){
    rx = width/2;
    ry = height/2;
    rw = 80;
    rh = 80;
    c = color(62,198,172);
    isSliding = false;
    topMost = ry - rh/2;
    lowMost = ry + rh/2;
    leftMost = rx - rw/2;
    rightMost = rx + rw/2;
  }
  
  myRect(int from, int inXY, color fillc){
    c = fillc;
    fromSide = from;
    if(fromSide%2 == 0){
      rx = inXY;
      if(fromSide == 0)
      ry = -cubeL/2;
      else
      ry = height + cubeL/2;
      rw = 10;
      rh = 80;           
    }else{
      ry = inXY;
      if(fromSide == 1)
      rx = -cubeL/2;
      else
      rx = width + cubeL/2;
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
      if(fromSide%2 == 1){
        rx += dir * speed;
      }
      else{
        ry += dir * speed;
      }
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
  
  void cutExtra(boolean cutX, int lowerBond, int higherBond){
        
    if(cutX){
      leftMost = rx - rw/2;
      rightMost = rx + rw/2;
      if(rightMost < lowerBond){
        rw = 0;
      }else if(leftMost > higherBond){
        rw = 0;
      }else{
        if(leftMost < lowerBond){
          int delX = abs(lowerBond - leftMost);
          rx += delX/2;
          rw -= delX;            
        }
        if(rightMost > higherBond){
          int delX = abs(rightMost - higherBond);
          rx -= delX;
          rw -= delX;       
        }
      }     
    }else{
      topMost = ry - rh/2;
      lowMost = ry + rh/2;
      
      if(topMost < lowerBond){
        rh = 0;
      }else if(lowMost > higherBond){
        rh = 0;
      }else{
        if(topMost < lowerBond){
          int delY = abs(lowerBond - topMost);
          ry += delY/2;
          rh -= delY;            
        }
        if(lowMost > higherBond){
          int delY = abs(lowMost - higherBond);
          ry -= delY;
          rh -= delY;       
        }
      }
      
    }
    
    
  }
  
  //move the whole shape to the center point
  void backToOrig(int deltaX, int deltaY){
    rx += deltaX;
    ry += deltaY;
  }
  
  
  
  
  

}