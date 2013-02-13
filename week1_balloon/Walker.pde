import java.util.Random;

class Walker {
  

  // Declare a Random number generator object
  Random generator;
  
  PVector location;
  PVector noff;
  PVector reaction;
  
  Walker() {
    location = new PVector(width/2, height);
    noff = new PVector(random(1000), random(1000));
    reaction = new PVector(0, 0);
    generator = new Random();
  }
  
  void display() {
    
    float d = (float) generator.nextGaussian();
    float d2 = (float) generator.nextGaussian();
    float sd = 1;
    
    float distance = dist(location.x, location.y, mouseX, mouseY);
    
    if (distance < 100) {
      d = ( d * sd ) + map(distance, 0, 100, 0, 100);
      d2 = ( d * sd ) + map(distance, 0, 100, 100, 20);
    } else {
      d = ( d * sd ) + 100;
      d2 = ( d2 * sd ) + 20;
    }
    
    noStroke();
    fill(255, 255, 0, 150);
    ellipse(location.x, location.y, d, d);
    
    stroke(0, 255, 255, 200);
    strokeWeight(5);
    fill(255, 255, 255, 100);
    ellipse(mouseX, mouseY, d2, d2);
  }
  
  void walk() {
   
    location.x = map(noise(noff.x), 0, 1, 0, width);
    location.y = map(noise(noff.y), 0, 1, 0, height);
    
    noff.add(0.01, 0.01, 0);
  }
  
}
