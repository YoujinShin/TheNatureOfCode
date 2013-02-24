import java.util.Random;

PImage img;
ArrayList<ParticleSystem> systems;
Repeller[] repeller;
//Repeller repeller;

void setup() {
  size(640, 360, P2D);
  
  img = loadImage("texture.png");
  smooth();
  
  systems = new ArrayList<ParticleSystem>();
  repeller = new Repeller[20];
  for (int i=0; i<repeller.length; i++) {
    repeller[i] = new Repeller(random(0, width), height - 10);
  }
  //repeller = new Repeller(width/2, height/2);
}

void draw() {
  background(0);
  blendMode(ADD);
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
  systems.add(new ParticleSystem(new PVector(mouseX, mouseY), img));
}

//void keyPressed() {
//  PVector wind = new PVector(0.3,0);
//  ps.applyForce(wind);
//  //systems.remove(0);
//}

        
