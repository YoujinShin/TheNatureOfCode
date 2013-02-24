class Repeller {
  
  float G = 100;
  PVector location;
  
  Repeller(float x, float y) {
    location = new PVector(x, y);
  }
  
  void display() {
    noStroke();
    
    fill(170);
    ellipse(location.x, location.y, 48, 48);
    //rectMode(CENTER);
    //rect(location.x, location.y, 30, 60);
  }
  
  PVector repel(Particle p) {
    PVector dir = PVector.sub(location, p.location);
    float d = dir.mag();
    dir.normalize();
    float force = -1 * G /(d * d);
    dir.mult(force);
    return dir;
  }
}
