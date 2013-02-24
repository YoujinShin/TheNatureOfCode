class Particle {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float lifespan;
  PImage img;
  
  Particle(PVector loc, PImage img_) {
    acceleration = new PVector(0, 0.05);
    velocity = new PVector(random(-1, 1), random(-1, 0));
    location = loc.get();
    lifespan = 255.0;
    img = img_;
  }
  
  void applyForce(PVector Force) { 
    acceleration.add(Force);
  }
  
  void run() {
    update();
    display();
  }
  
  void update() {
    velocity.add(acceleration);
    location.add(velocity);
    lifespan -= 1.0;
    acceleration.mult(0);
  }
  
  void display() {
    imageMode(CENTER);
    tint(255,lifespan);
//    tint(0, 0, 204, lifespan);
//    image(img,location.x, location.y, 70, 70);
    image(img,location.x, location.y);
  }
  
  boolean isDead() {
    if(lifespan < 0.0) {
      return true;
    } else {
      return false;
    }
  }
}
