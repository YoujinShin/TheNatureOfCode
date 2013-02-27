class Vehicle {
  PVector location;
  PVector velocity;
  PVector acceleration;
  
  float r; //size
  float maxforce;
  float maxspeed;
  PImage img;
  
  Vehicle(float x, float y, PImage img_) {
    acceleration = new PVector(0, 0);
    velocity = new PVector(0, 0);
    location = new PVector(x, y);
    
    r = 3.0;
    maxspeed = 4;
    maxforce = 0.1;
    img = img_;
  }
  
  void update() {
    velocity.add(acceleration);
    velocity.limit(maxspeed);
    location.add(velocity);
    acceleration.mult(0);
  }
  
  void applyForce(PVector force) {
    acceleration.add(force);
  }
  
  void seek(PVector target) {
    PVector desired = PVector.sub(target, location);
    desired.normalize();
    desired.mult(maxspeed);
    
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);
    
    applyForce(steer);
  }
  
  void follow(FlowField flow) {
    PVector desired = flow.lookup(location);
    desired.mult(maxspeed);
    
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);
    applyForce(steer);
  }
  
  void display() {
    float theta = velocity.heading2D() + PI/2; // velocity.heading()
    //fill(174);
    //stroke(0);
    
    pushMatrix();
    translate(location.x, location.y);
    noTint();
    imageMode(CENTER);
    image(img, 0, 0);
    //rotate(theta);
//    beginShape();
//    vertex(0, -r*2);
//    vertex(-r, r*2);
//    vertex(r, r*2);
    //endShape(CLOSE);
    popMatrix();
  }
  
  boolean isDead() {
    if((location.x<0)||(location.y<0)||(location.y>height)) {
      //location.x = width + 5;
      //location.y = random(height);
      return true;
    } else {
      return false;
    }
  }
}
