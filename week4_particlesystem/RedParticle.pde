class RedParticle extends Particle {
  
  RedParticle(PVector l) {
    super(l);
  }
  
  void display() {
    rectMode(CENTER);
    fill(255, 255, 102,lifespan);
    noStroke();
//    stroke(0,lifespan);
    strokeWeight(2);
    pushMatrix();
    translate(location.x,location.y);
    float theta = map(location.x,0,width,0,TWO_PI*2);
    rotate(theta);
    rect(0,0,12,12);
    popMatrix();
  }
}
