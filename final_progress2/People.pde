class People {
  
  float x, y, a;
  color c;
  
  People() {
    
    x = 0;
    y = 0;
    a = 1;
  }
  
  void display(float x_, float y_, float a_, color c_) {
    
    x = x_;
    y = y_;
    a = a_;
    c = c_;
    
    pushMatrix();
    
    translate(x, y);
    fill(c);
    noStroke();
    smooth();
    
    ellipseMode(CENTER);
    ellipse(0, 0, 40*a, 40*a);
    
    rectMode(CORNER);
    arc(0, 50*a, 50*a, 50*a, PI, 2*PI); 
    rect(-25*a, 50*a, 50*a, 40*a);
    
    popMatrix();
  }
}
