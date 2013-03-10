// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

import pbox2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

PBox2D box2d;    
int num, numV;

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
  size(600, 600);
  // Initialize and create the Box2D world
  box2d = new PBox2D(this);  
  box2d.createWorld();

  // Create ArrayLists
  particles = new ArrayList<Particle>();
  vacterias = new ArrayList<Vacteria>();
  boundaries = new ArrayList<Boundary>();
  //surface = new Surface();
  
  // Add a bunch of fixed boundaries
  //boundaries.add(new Boundary(width/4, height/4, 10,10));
  //boundaries.add(new Boundary(3*width/2, height-50, width/2-50, 10));
  
  wall = 300;
  bottom = 200;
  hole = 20;// size of hole
  cenX = width/2-120;
  cenY = height/2-50;
  thickness = 2;
  distance = 50;
  for (int i = 0; i < 200; i++) {
    boundaries.add(new Boundary(random(cenX-bottom/2+10,cenX+bottom/2-10), random(cenY-wall/3, cenY), 3,3, color(150)));
  }
  
  for (int i = 0; i < 400; i++) {
    boundaries.add(new Boundary(random(cenX-bottom/2,cenX+bottom/2), random(cenY+20, cenY+wall/3+20),1,1,color(10)));
  }
  
  color temp = color(0);
  // WALL
  // leftt
  boundaries.add(new Boundary(cenX - bottom/2, cenY, thickness,wall, temp));
  // right
  boundaries.add(new Boundary(cenX + bottom/2, cenY - hole/2, thickness,wall - hole,temp));
  // bottom
  boundaries.add(new Boundary(cenX, cenY+wall/2-2, bottom, thickness, temp));
  
  // PIPE
  int pipeBottom = 20;
  // right
  //boundaries.add(new Boundary(cenX + bottom/2 + distance+pipeBottom, cenY, thickness,wall, temp));
  // left
  //boundaries.add(new Boundary(cenX + bottom/2 + distance, cenY - hole/2, thickness,wall - hole,temp));
  // bottom
  //boundaries.add(new Boundary(cenX+bottom/2+(distance+pipeBottom)/2, cenY+wall/2-2,distance+pipeBottom, thickness,temp));
  // bottomup
  //boundaries.add(new Boundary(cenX+bottom/2+(distance)/2, cenY+wall/2-2-hole,distance, thickness, temp));

  // TAP
  // bottom
  boundaries.add(new Boundary(cenX+bottom/2+(distance)/2, cenY+wall/2-2-hole,distance, thickness,temp));
  // bottomup
  boundaries.add(new Boundary(cenX+bottom/2+(distance)/2, cenY+wall/2-2,distance, thickness, temp));
  
  // BUCKET
  int bucketSize = 200;
  int bucketHeight = 100;
  // bottom
  boundaries.add(new Boundary(cenX+bottom/2+(distance)/2+80, cenY+wall/2-2+100+bucketHeight/2,bucketSize, thickness,temp));
  // right
  boundaries.add(new Boundary(cenX+bottom/2+(distance)/2+bucketSize/2+80,cenY+wall/2-2+100, thickness,bucketHeight, temp));
  // left
  boundaries.add(new Boundary(cenX+bottom/2+(distance)/2-bucketSize/2+80,cenY+wall/2-2+100, thickness,bucketHeight, temp));
}

void draw() {
  background(255);
  
  //surface.display();
  for (Boundary walls: boundaries) {
    walls.display();
  }
  
  if (random(1) < 0.8 && num < 1200) {
    particles.add(new Particle(cenX,height/4 - 50,1));
    num++; 
  } 
 if (random(1) < 0.01 && numV < 20) {
    vacterias.add(new Vacteria(cenX,height/4 - 50,4));
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

