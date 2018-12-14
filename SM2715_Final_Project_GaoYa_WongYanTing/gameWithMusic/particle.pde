//Referece from wk11_02 and Daniel Shiffman <http://www.shiffman.net>

class particle{
  PVector pos;
  PVector velocity;
  PVector acceler;
  int lifeTime;
  
  particle(PVector _pos){
    acceler = new PVector(0, 0.04);
    velocity = new PVector(random(-1,1), random(-2,0));
    pos = _pos.copy();
    lifeTime = 50;
  }
  
  void update(){
    velocity.add(acceler);
    pos.add(velocity);
    lifeTime -= 2;
  }
  
  void drawParticle(){
    noStroke();
    float alpha = map(lifeTime, 50, 0, 255, 0);
    fill(250, 161, 151, alpha);
    ellipse(pos.x, pos.y, 5, 5);
  }
  
  void play(){
    update();
    drawParticle();
  }
  
  boolean isDead(){
    if(lifeTime < 0){
      return true;
    }
    else{
      return false;
    }
  }

}