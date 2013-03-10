class Boundary {
  
  float x;
  float y;
  float w;
  float h;
  color c;
  
  Body b;
  
  Boundary(float x_, float y_, float w_, float h_, color c_) {
    x = x_;
    y = y_;
    w = w_;
    h = h_;
    c = c_;
    
    // Define 
    PolygonShape ps = new PolygonShape();
    float box2dW = box2d.scalarPixelsToWorld(w/2);
    float box2dH = box2d.scalarPixelsToWorld(h/2);
    ps.setAsBox(box2dW, box2dH);
    
    // Create
    BodyDef bd = new BodyDef();
    bd.type = BodyType.STATIC;
    bd.position.set(box2d.coordPixelsToWorld(x,y));
    b = box2d.createBody(bd);
    
    // Attach 
    b.createFixture(ps, 1);
  }
  
  void display() {
    fill(c);
    //stroke(0);
    noStroke();
    rectMode(CENTER);
    rect(x,y,w,h);
  }
}
