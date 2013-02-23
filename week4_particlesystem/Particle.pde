class Particle {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float lifespan;
  
  Particle(PVector loc) {
    acceleration = new PVector(0, 0.05);
    velocity = new PVector(random(-1, 1), random(-2, 0));
    location = loc.get();
    lifespan = 255.0;
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
    lifespan -= 2.0;
    acceleration.mult(0);
  }
  
  void display() {
    noStroke();
    fill(0, 255, 255, lifespan);
    ellipse(location.x, location.y, 12, 12);
  }
  
  boolean isDead() {
    if(lifespan < 0.0) {
      return true;
    } else {
      return false;
    }
  }
}
