class TapWater {
  
  float a, x, y;
  
  TapWater() {
    
    a = 1;
    x = 0;
    y = 0;
  }
  
  void display(float x_, float y_, float a_) {
  
    x = x_;
    y = y_;
    a = a_;
    
    pushMatrix();
    translate(x - 50*a, y);
    rectMode(CENTER);
    ellipseMode(CENTER);
    
    fill(255);
    noStroke();
    
    rect(0, 0, 60*a, 10*a);
    ellipse(30*a, 0, 10*a, 10*a);
    ellipse(-30*a, 0, 10*a, 10*a);
    rect(0, 20*a, 10*a, 40*a);
    ellipse(0, 30*a, 30*a, 30*a);
    rect(0, 50*a, 40*a, 40*a);
    rect(0, 70*a, 100*a, 30*a);
    arc(50*a, 85*a, 60*a, 60*a, PI, 2*PI);
    rect(65*a, 91*a, 30*a, 15*a);// rect(65*a, 91*a, 30*a, 15*a);
    
    rect(-55*a, 70*a, 10*a, 100*a);
    popMatrix();
  }
}
