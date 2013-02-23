ArrayList<ParticleSystem> systems;
Repeller[] repeller;
//Repeller repeller;

void setup() {
  size(640, 360);
  systems = new ArrayList<ParticleSystem>();
  repeller = new Repeller[3];
  for (int i=0; i<repeller.length; i++) {
    repeller[i] = new Repeller(random(0, width), random(0 + 100, height -100));
  }
  //repeller = new Repeller(width/2, height/2);
}

void draw() {
  background(255);
  fill(0);
  text("click to make particle system/ press key to apply wind force",10,height-5);
  
  for (ParticleSystem ps: systems) {
    //ps.applyForce();
    ps.addParticle();
    ps.run();
    
    PVector gravity = new PVector(0, 0.1);
    ps.applyForce(gravity);
    
    if (keyPressed) {
      PVector wind = new PVector(0.3,0);
      ps.applyForce(wind);
    }
    
    for (int i = 0; i< repeller.length; i++) {
      ps.applyRepeller(repeller[i]);
    }
  }
  
  for (int i = 0; i< repeller.length; i++) {
    repeller[i].display();
  }
}

void mousePressed() {
  systems.add(new ParticleSystem(new PVector(mouseX, mouseY)));
}

//void keyPressed() {
//  PVector wind = new PVector(0.3,0);
//  ps.applyForce(wind);
//  //systems.remove(0);
//}


