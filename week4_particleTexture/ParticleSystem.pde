class ParticleSystem {
  ArrayList<Particle> particles;
  PVector origin;
  PImage img;
  
  ParticleSystem(PVector location, PImage img_) {
    img = img_;
    origin = location.get();
    particles = new ArrayList<Particle>();
  }
  
  void applyForce(PVector Force) { 
    for(Particle p: particles) {
      p.applyForce(Force);
    }
  }
  
  void applyRepeller(Repeller repeller) {
    for(Particle p: particles) {
      PVector repel = repeller.repel(p);
      p.applyForce(repel);
    }
  }
  
  void addParticle() {
    particles.add(new Particle(origin, img));
//    float i = random(1);
//    if (i < 0.9) {
//      particles.add(new Particle(origin));
//    } else {
//      particles.add(new RedParticle(origin));
//    }
  }
  
  void run() {
    for(int i = particles.size()-1; i>=0; i--) {
      Particle p = particles.get(i);
      p.run();
      if (p.isDead()) {
        particles.remove(i);
      }
    }
  }
}
