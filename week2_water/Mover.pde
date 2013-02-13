class Mover {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float mass;
  
  Mover(float m, float x, float y) {
    mass = m;
    location = new PVector(x, y);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
  }
  
  void applyForce(PVector force) {
    PVector f = PVector.div(force, mass);
    acceleration.add(f);
  }
  
  void update() {
    velocity.add(acceleration);
    location.add(velocity);
    acceleration.mult(0);
  }
  
  void display() {
    stroke(107, 246, 116);
    strokeWeight(2);
    fill(121, 246, 107, 100);
    ellipse(location.x, location.y, mass*16, mass*16);
  }
  
  void checkEdges() {
    if (location.x > width- mass*8) {
      location.x = width- mass*8;
      velocity.x *= -1;
    } else if(location.x < 0+ mass*8) {
      location.x = 0+ mass*8;
      velocity.x *= -1;
    }
    
    if (location.y > height/4 - mass*8) {
      velocity.y *= -1;
      location.y = height/4 - mass*8;
    }
  }
  
  void checkEdgesBottom() {
    if (location.x > width- mass*8) {
      location.x = width - mass*8;
      velocity.x *= -1;
    } else if(location.x < 0 + mass*8) {
      location.x = 0+ mass*8;
      velocity.x *= -1;
    }
    
    if (location.y > height - mass*8) {
      velocity.y *= -0.9;
      location.y = height - mass*8;
    }
  }
}
