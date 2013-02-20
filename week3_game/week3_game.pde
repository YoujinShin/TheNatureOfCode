// The Nature of Code
PShape s;

// Mover object
Bob bob;
float initx;
float inity;

Walker[] w;

// Spring object
Spring spring;
Boolean release; // for checking the release of the object

void setup() {
  size(1200,400);
 // s = loadShape("bird.svg");
  
  initx = width/5;
  inity = height/2;

  spring = new Spring(initx, inity-10, 10); 
  bob = new Bob(initx, inity); 
  release = false;
  
   w = new Walker[40];
  for(int i = 0; i < w.length; i++) {
    w[i] = new Walker();
  }
  
}

void draw()  {
  background(255); 
  // Apply a gravity force to the bob
  PVector gravity = new PVector(0,2);
  bob.applyForce(gravity);
  
  // Connect the bob to the spring 
  if (release == false) {
    spring.connect(bob);
  }
  // Constrain spring distance between min and max
  //spring.constrainLength(bob,0,200);
  
  // Update bob
  bob.update();
  bob.drag(mouseX,mouseY);
  
  // Draw everything
  spring.displayLine(bob, release); // Draw a line between spring and bob
  bob.display(); 
  spring.display(); 
  
  for (int i = 0; i < w.length; i++) {
    w[i].walk();
    w[i].display(bob);
  }
  
  fill(0);
  text("click on bob to drag/ press key to reset",10,height-5);
}

void mousePressed()  {
  bob.clicked(mouseX,mouseY);
}

void mouseReleased()  {
  bob.stopDragging(); 
  release = true;
}

void keyPressed()  {
  reset();
}

void reset() {
  release = false;
  bob.location.x = initx;
  bob.location.y = inity;
  bob.velocity.x = 0;
  bob.velocity.y = 0;
  
  
}
