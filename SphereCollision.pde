Sphere[] spheres;
int wallLeft, wallRight, wallTop, wallBottom, wallFront, wallBack;
int border = 50;
float theta = 0;
float dt = PI/2000;

boolean record = true;
int frame = 0;
import com.hamoid.*;
VideoExport videoExport;

void setup(){
  size(1000,1000, P3D);
  smooth(8);
  wallLeft = -width/2;
  wallRight = width/2;
  wallTop = -width/2;
  wallBottom = width/2;
  wallFront = -width/2;
  wallBack = width/2;
  spheres = new Sphere[8];
  
  for(int i = 0; i<spheres.length; i++){
    spheres[i] = new Sphere(i, random(wallLeft+border, wallRight-border),
                            random(wallTop+border, wallBottom-border),
                            random(wallFront+border, wallBack-border), 100);
  }
  
  if (record){
    videoExport = new VideoExport(this, "SphereCollision.mp4");
    videoExport.setFrameRate(30);
    videoExport.startMovie();
  }
}

void draw(){
  background(0);
  noLights();
  //lightSpecular(128,128,128);
  //directionalLight(255, 255, 255, 0, 0, -1);
  //ambientLight(120, 120, 120);
  
  lightFalloff(0.5, 0, 0);
  sphereDetail(60);
  noFill();
  stroke(80);  
  box(wallRight-wallLeft);
    
  camera(1500*cos(theta),  1500*sin(theta),  0.0,
         0.0,   0.0,   0.0, 
         0.0,   0.0,   -1.0);
  
  theta += dt;
  if(theta>=TWO_PI) theta = 0;
  
  
  for(int i = 0; i<spheres.length; i++){
    for(int j = 0; j<spheres.length; j++){
      if((i!=j) && distanceCheck(spheres[i],spheres[j])){
        if(!spheres[i].colliding && !spheres[j].colliding)
          collide(spheres[i],spheres[j]);        
      }   
    }
  }
  
  for(Sphere s : spheres){
    pointLight(s.alpha, s.alpha, s.alpha, s.pos.x, s.pos.y, s.pos.z);
  }  
  
  for(Sphere s : spheres){
    s.update();
    s.show();
  }
  

  
  //pointLight(spheres[0].alpha, spheres[0].alpha, spheres[0].alpha, 
  //          spheres[0].pos.x, spheres[0].pos.y, spheres[0].pos.z);
  
  if (record) videoExport.saveFrame();
  frame = frame + 1;

  if(frame>(60*30)){
     if (record){ videoExport.endMovie();}
   exit();
  }
}

boolean distanceCheck(Sphere c1, Sphere c2){  
  float distSqr = ((c1.pos.x - c2.pos.x)*(c1.pos.x - c2.pos.x)+
                   (c1.pos.y - c2.pos.y)*(c1.pos.y - c2.pos.y)+
                   (c1.pos.z - c2.pos.z)*(c1.pos.z - c2.pos.z));  
  return distSqr < (c1.r+c2.r)*(c1.r+c2.r);
}

 
void collide(Sphere c1, Sphere c2){
  //Set both spheres as colliding this frame
  c1.colliding = true;
  c2.colliding = true;

  PVector v1 = c1.vel.copy();
  PVector C1 = c1.pos.copy();
  float m1 = c1.r*c1.r;
  PVector v2 = c2.vel.copy();
  PVector C2 = c2.pos.copy();
  float m2 = c2.r*c2.r;
  PVector v1Minusv2 = new PVector(v1.x-v2.x,v1.y-v2.y, v1.z-v2.z);
  PVector C1MinusC2 = new PVector(C1.x-C2.x,C1.y-C2.y, C1.z-C2.z);
  
  //Static collision
  float distance = C1MinusC2.mag();
  float overlap = distance - c1.r - c2.r;
  c1.pos.x -= overlap*C1MinusC2.x/distance;
  c1.pos.y -= overlap*C1MinusC2.y/distance;
  c1.pos.z -= overlap*C1MinusC2.z/distance;
  c2.pos.x += overlap*C1MinusC2.x/distance;
  c2.pos.y += overlap*C1MinusC2.y/distance;
  c2.pos.z += overlap*C1MinusC2.z/distance;
  
  //Dynamic collision
  float coeff = (2*m2)/(m1+m2)*v1Minusv2.dot(C1MinusC2)/C1MinusC2.magSq();
  PVector v1Prime = v1.sub(C1MinusC2.mult(coeff));
  //invert vel/pos difference vectors for v2' coefficient
  v1Minusv2.mult(-1);
  C1MinusC2.mult(-1);
  coeff = (2*m1)/(m1+m2)*v1Minusv2.dot(C1MinusC2)/C1MinusC2.magSq();
  PVector v2Prime = v2.sub(C1MinusC2.mult(coeff));
    
  c1.vel = v1Prime;
  c2.vel = v2Prime;
  //456y7  
}
