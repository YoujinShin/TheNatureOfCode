// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

import pbox2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

PImage img;

PBox2D box2d;    
int num, numV, numParticle;

int wall, bottom, hole;// size of hole
int cenX, cenY, thickness, distance;

// A list for all of our rectangles
ArrayList<Particle> particles;
ArrayList<Vacteria> vacterias;
ArrayList<Boundary> boundaries;

Surface surface;

void setup() {
  num = 0;
  numV = 0;
  numParticle = 500;
  size(600, 600, P2D);
  img = loadImage("texture.png");
  smooth();
  // Initialize and create the Box2D world
  box2d = new PBox2D(this);  
  box2d.createWorld();

  // Create ArrayLists
  particles = new ArrayList<Particle>();
  vacterias = new ArrayList<Vacteria>();
  boundaries = new ArrayList<Boundary>();
  //surface = new Surface();
  
  // Add a bunch of fixed boundaries
  buildBoundaries();
}

void draw() {
  background(175);
  //blendMode(ADD);
  //surface.display();
  for (Boundary walls: boundaries) {
    walls.display();
  }
  
  if (random(1) < 0.7 && num < numParticle) {
    particles.add(new Particle(cenX,height/4 - 80, img));
    num++; 
  } 
 if (random(1) < 0.05 && numV < 10) {
    vacterias.add(new Vacteria(cenX,height/4 - 80,3));
    numV++;
  }
  // We must always step through time!
  box2d.step();

  // Display all the boxes
  for (Particle p: particles) {
    p.display();
  }
  for (Vacteria v: vacterias) {
    v.display();
  }
  for (int i = particles.size()-1; i >= 0; i--) {
    Particle p = particles.get(i);
    if (p.done()) {
      particles.remove(i);
    }
  }
}

void buildBoundaries() {
  wall = 200;
  bottom = 120;
  hole = 20;// size of hole
  cenX = width/2-0;
  cenY = height/2-50;
  thickness = 2;
  distance = 20;
  for (int i = 0; i < 75; i++) {
    boundaries.add(new Boundary(random(cenX-bottom/2+3,cenX+bottom/2-3), random(cenY-wall/3+20, cenY+20), 3,3, color(10),0));
  }
  
  for (int i = 0; i < 135; i++) {
    boundaries.add(new Boundary(random(cenX-bottom/2,cenX+bottom/2), random(cenY+20, cenY+wall/2-10),1,1,color(10),0));
  }
  
  color temp = color(0);
  // WALL
  // leftt
  boundaries.add(new Boundary(cenX - bottom/2, cenY, thickness,wall, temp,0));
  // right
  boundaries.add(new Boundary(cenX + bottom/2, cenY - hole/2 , thickness,wall - hole,temp,0));
  // bottom
  boundaries.add(new Boundary(cenX, cenY+wall/2-2, bottom, thickness, temp,0));

  // TAP
  // bottom
  boundaries.add(new Boundary(cenX+bottom/2+(distance)/2, cenY+wall/2-2-hole,distance, thickness,temp,0));
  // bottomup
  boundaries.add(new Boundary(cenX+bottom/2+(distance)/2, cenY+wall/2-2,distance, thickness, temp,0));
  
  // BUCKET
  int bucketSize = 60;
  int bucketHeight = 60;
  // bottom
  boundaries.add(new Boundary(cenX+bottom/2+(distance)/2+30, cenY+wall/2-2+50+bucketHeight/2,bucketSize, thickness,temp,0));
  // right
  boundaries.add(new Boundary(cenX+bottom/2+(distance)/2+bucketSize/2+30,cenY+wall/2-2+25, thickness,bucketHeight+50, temp,0));
  // left
  boundaries.add(new Boundary(cenX+bottom/2+(distance)/2-bucketSize/2+30,cenY+wall/2-2+50, thickness,bucketHeight, temp,0));
}

