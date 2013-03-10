// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// A circular particle

class Particle {

  // We need to keep track of a Body and a radius
  Body body;
  PImage img;
  PVector[] trail;  
 
  Particle(float x_, float y_, PImage img_) {
    float x = x_;
    float y = y_;
    img = img_;
    
    // This function puts the particle in the Box2d world
    trail = new PVector[5];
    for (int i = 0; i < trail.length; i++) {
      trail[i] = new PVector(x, y);
    }
    makeBody(new Vec2(x, y), 1.3); //0.2f
  }

  // This function removes the particle from the box2d world
  void killBody() {
    box2d.destroyBody(body);
  }

  // Is the particle ready for deletion?
  boolean done() {
    // Let's find the screen position of the particle
    Vec2 pos = box2d.getBodyPixelCoord(body);
    // Is it off the bottom of the screen?
    if (pos.y > height+20) {
      killBody();
      return true;
    }
    return false;
  }

  // 
  void display() {
    // We look at each body and get its screen position
    Vec2 pos = box2d.getBodyPixelCoord(body);
    
    // Keep track of a history of screen positions in an array
    for (int i = 0; i < trail.length-1; i++) {
      trail[i] = trail[i+1];
    }
    trail[trail.length-1] = new PVector(pos.x, pos.y);
    
    imageMode(CENTER);
    for (int i = 0; i < trail.length; i++) {
      tint(255,130);
      image(img,trail[i].x, trail[i].y,5,5);
    }
    
//    beginShape();
//    noFill();
//    strokeWeight(3);
//    stroke(0,255,255,100);
//    for (int i = 0; i < trail.length; i++) {
//      vertex(trail[i].x, trail[i].y,0, 0);
//    }
//    endShape();
  }

  // Here's our function that adds the particle to the Box2D world
  void makeBody(Vec2 center, float r) {
    // Define a body
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    // Set its position
    bd.position.set(box2d.coordPixelsToWorld(center));
    body = box2d.world.createBody(bd);

    // Make the body's shape a circle
    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(r);
    
    FixtureDef fd = new FixtureDef();
    fd.shape = cs;
    
    // Parameters that affect physics
    fd.density = 0.01;
    //fd.friction = 0.01;
    fd.friction = 0; // Slippery when wet!
    fd.restitution = 0.2;
    
    // Attach fixture to body
    body.createFixture(fd);

    // Give it a random initial velocity (and angular velocity)
    body.setLinearVelocity(new Vec2(random(-1,1),random(-1,1)));
//    body.setLinearVelocity(new Vec2(random(2,8),random(-8,-4)));
  }

}

