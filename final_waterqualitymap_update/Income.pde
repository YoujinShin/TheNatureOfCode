class Income {

  // Toxiblins Attraction2D example!
  int NUM_PARTICLES = 10;
  int num_state_0 = 1;
  int d = 30; // diameter of particles

  int glassWidth = width/8 + width/40;
  int glassHeight = height/3;
  float glassX = width/6 - width/150;
  float glassY = height/2.2;
  int boxW = 1100;
  int boxH = 600; 
  int pop, income, index;
  float x, y;
  
  PImage coin;

  VerletPhysics2D physics;
  AttractionBehavior mouseAttractor;
  Vec2D mousePos;

  Income() {
    
    x = width/2 - boxW/2 + 90; //20
    y = 180 + 65;//height/2 - boxH/2 ;

    physics = new VerletPhysics2D();
    physics.setDrag(0.05f); //0.05f
    physics.setWorldBounds(new Rect(x+d/2, y+d/2, boxW*0.44-d, boxH*0.65-d));
//    physics.addBehavior(new GravityBehavior(new Vec2D(0, 0.15f))); //Vec2D(0, 0.15f)

    index = 0; // increasing num of particles
    income = 0;

  }

  void display(PImage coin_, int pop_, int income_) {
    
    coin = coin_;
    pop = pop_;
    income = income_;
    NUM_PARTICLES = income_;
    
    rectMode(CORNER);
    noFill();
    strokeWeight(1);
    stroke(80);
    rect(x, y,  boxW*0.44, boxH*0.65);
  
    noStroke();
    fill(255);
    if (physics.particles.size() < NUM_PARTICLES) {

      addParticle();
    }
    physics.update();

    imageMode(CENTER);
    for (int i = 0; i<physics.particles.size(); i++) {
      VerletParticle2D p = physics.particles.get(i);
      stroke(0);
      strokeWeight(0.5);
      fill(255, 255, 0, 200);
      ellipse(p.x, p.y, d, d);
      
      fill(50);
      textAlign(CENTER, CENTER);
      textSize(20);
      text("$", p.x, p.y);
//      image(coin, p.x, p.y, d, d); 
    }
    index++;
    
    textFont(mynumber);
    textAlign(CENTER, BOTTOM);
    fill(255, 0, 0);
    textSize(350);
    text(income, width/2 + 250, height/2 + 290);
  }

  void addParticle() {

    float position = x + boxW*0.44/2;
    
    VerletParticle2D p = new VerletParticle2D(Vec2D.randomVector().scale(5).addSelf(position, y + boxH*0.65/2));
    physics.addParticle(p);

    physics.addBehavior(new AttractionBehavior(p, 45, -1.2f, 0.05f)); // (p, 20, -1.2f, 0.01f)
  }

  void removeParticle() {

    for (int i = physics.particles.size()-1; i >= 0 ; i--) {     
      ParticleBehavior2D b = physics.behaviors.get(i);
//      ParticleBehavior2D b = physics.behaviors.get(i+1); // i -> gravity, i+1 -> attraction
      physics.removeBehavior(b);

      VerletParticle2D p = physics.particles.get(i);
      physics.removeParticle(p);
    }
    index = 0;
  }
  
  void startAttract() {
    mousePos = new Vec2D(mouseX, mouseY);
    // create a new positive attraction force field around the mouse position (radius=250px)
    mouseAttractor = new AttractionBehavior(mousePos, 250, 0.9f);
    physics.addBehavior(mouseAttractor);
  }

  void updateAttract() {
    // update mouse attraction focal point
    mousePos.set(mouseX, mouseY);
  }

  void stopAttract() {
    // remove the mouse attraction when button has been released
    physics.removeBehavior(mouseAttractor);
  }

}

