class Box {
  // Toxiblins Attraction2D example!
  int NUM_PARTICLES = 200;

  VerletPhysics2D physics;
  AttractionBehavior mouseAttractor;

  Vec2D mousePos;

  Box() {
    // setup physics with 10% drag
    physics = new VerletPhysics2D();
    physics.setDrag(0.05f);
    physics.setWorldBounds(new Rect(150 + 400, 0, 1100-800, 600)); //new Rect(0, 0, width, height)
    // the NEW way to add gravity to the simulation, using behaviors
    physics.addBehavior(new GravityBehavior(new Vec2D(0, 0.15f)));
  }

  void display() {
    noStroke();
    fill(255, 0, 0);
    if (physics.particles.size() < NUM_PARTICLES) {
      addParticle();
    }
    physics.update();
    for (VerletParticle2D p : physics.particles) {
      ellipse(p.x, p.y, 15, 15);
    }
  }

  void addParticle() {
    VerletParticle2D p = new VerletParticle2D(Vec2D.randomVector().scale(5).addSelf(width / 2, 0));
    physics.addParticle(p);
    // add a negative attraction force field around the new particle
    physics.addBehavior(new AttractionBehavior(p, 20, -1.2f, 0.01f));
  }
  
  void removeParticle() {
    for (VerletParticle2D p : physics.particles) {
      println("p");
      //physics.removeParticle(p); // not working !
      //physics.removeBehavior(p);
    }
  }
}

