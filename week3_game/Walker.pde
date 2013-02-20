import java.util.Random;

class Walker {
  
  // Declare a Random number generator object
  Random generator;
  
  PVector location;
  PVector noff;
  PVector reaction;
  
  Boolean alive;
  
  Walker() {
    location = new PVector(width/2, height);
    noff = new PVector(random(1000), random(1000));
    reaction = new PVector(0, 0);
    generator = new Random();
    alive = true;
  }
  
  void display(Bob b) {
    float tempx = b.location.x;
    float tempy = b.location.y;
    
    int radius = 50;
    float d = (float) generator.nextGaussian();
    float d2 = (float) generator.nextGaussian();
    float sd = 1;
    
    float distance = dist(location.x, location.y, tempx, tempy);
    
    if (distance < 100) {
      d = ( d * sd ) + map(distance, 0, radius, 0, radius);
      d2 = ( d * sd ) + map(distance, 0, radius, radius, 20);
      alive = false;
    } else {
      if (alive) {
        d = ( d * sd ) + radius;
        d2 = ( d2 * sd ) + 20;
        noStroke();
        fill(255, 255, 0, 150);
        ellipse(location.x, location.y, d, d);
      }
    }

  }
  
  void walk() {
   
    location.x = map(noise(noff.x), 0, 1, width/2, width);
    location.y = map(noise(noff.y), 0, 1, 0, height);
    
    noff.add(0.01, 0.01, 0);
  }
  
  void walkReset() {
    location = new PVector(width/2, height);
    noff = new PVector(random(1000), random(1000));
    reaction = new PVector(0, 0);
    generator = new Random();
    alive = true;
  }
  
}
