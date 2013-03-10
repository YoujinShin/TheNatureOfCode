class Boundary {
  
  float x;
  float y;
  float w;
  float h;
  color c;
  int k;
  
  Body b;
  
  Boundary(float x_, float y_, float w_, float h_, color c_, int k_) {
    x = x_;
    y = y_;
    w = w_;
    h = h_;
    c = c_;
    k = k_;
    
    // Define 
    PolygonShape ps = new PolygonShape();
    float box2dW = box2d.scalarPixelsToWorld(w/2);
    float box2dH = box2d.scalarPixelsToWorld(h/2);
    if (k == 1) {
      Vec2[] vertices = new Vec2[4];
      vertices[0] = box2d.vectorPixelsToWorld(new Vec2(x-50, y));
      vertices[1] = box2d.vectorPixelsToWorld(new Vec2(x+50, y+5));
      vertices[2] = box2d.vectorPixelsToWorld(new Vec2(x+50, y+10));
      vertices[3] = box2d.vectorPixelsToWorld(new Vec2(x-50, y+5));
      ps.set(vertices, vertices.length);
    } else {
      ps.setAsBox(box2dW, box2dH);
    }
    
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
    
    if (k==1) {
      beginShape();
      vertex(x-50, y);
      vertex(x+50, y+5);
      vertex(x+50, y+10);
      vertex(x-50, y+5);
      endShape();
    } else {
      rectMode(CENTER);
      rect(x,y,w,h);
    }
  }
}
