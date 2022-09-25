class Sphere{
  int ID;
  PVector pos = new PVector();
  PVector vel = new PVector();
  PVector acc = new PVector();
  float r;
  float maxSpeed = 2;
  int alpha = 80;
  boolean colliding = false;
  
  
  Sphere(int _ID, float x, float y, float z, float _r){
    ID = _ID;
    pos.x = x;
    pos.y = y;
    pos.z = z;
    r = _r;
    vel.x = random(-maxSpeed, maxSpeed);
    vel.y = random(-maxSpeed, maxSpeed);
    vel.z = random(-maxSpeed, maxSpeed);
    vel.limit(maxSpeed);
  }
  
  void show(){
      
      fill(alpha);
      //stroke(255);
      noStroke();
      //stroke(255,0,0);
      pushMatrix();
      translate(pos.x,pos.y, pos.z);
      emissive(0.75*alpha, 0.75*alpha, 0.75*alpha);
      sphere(r);
      popMatrix();
      if(alpha>80)
        alpha-=2;
  }
  
  void update(){
      edges();
          
      pos.add(vel);
      vel.limit(maxSpeed);
      vel.add(acc);
      acc.mult(0);
      
      if(colliding)
        alpha = 200;
      this.colliding = false;
  }
  
  void edges() {
    if(pos.x + r > wallRight){
      vel.x *= -1;
      pos.x = wallRight - r;
      //alpha = 200;
    }
    
    if(pos.x - r < wallLeft){
      vel.x *= -1;
      pos.x = wallLeft + r;
      //alpha = 200;
    }
      
      
    if(pos.y + r > wallBottom){
      vel.y *= -1;
      pos.y = wallBottom - r;
      //alpha = 200;
    }
    if(pos.y - r < wallTop) {
      vel.y *= -1;
      pos.y = wallTop + r;
      //alpha = 200;
    }
    if(pos.z + r > wallBack){
      vel.z *= -1;
      pos.z = wallBack - r;
      //alpha = 200;
    }
    if(pos.z- r < wallFront) {
      vel.z *= -1;
      pos.z = wallFront + r;
      //alpha = 200;
    }
  }
}
