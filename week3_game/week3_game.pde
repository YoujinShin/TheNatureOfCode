// The Nature of Code
PShape s;

// Mover object
Bob bob;
float initx;
float inity;
int n;
 
Walker[] w;

// Spring object
Spring spring;
Boolean release; // for checking the release of the object
Boolean finish = false;

void setup() {
  size(1200,600);
  
  initx = width/5;
  inity = height/2+height/4;

  spring = new Spring(initx, inity-10, 10); 
  bob = new Bob(initx, inity); 
  release = false;
  n = 0;
  
   w = new Walker[5];
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
  
  int m = 0;
  int k = 0;
  
  if (n > 4) {
    //print(0);
    fill(0, 255, 255);
    textSize(40);
    text("CONGRATULATIONS !", width/2 - 300, height/2);
    fill(255, 255, 0, 100);
    noStroke();
    ellipse(width/2 + 120, height/2 - 100, 100, 100);
    ellipse(width/2 + 200, height/2 - 100, 100, 100);
    ellipse(width/2 + 280, height/2 - 100, 100, 100);
    
    finish = true;
  } else {
    //print(1);
    spring.displayLine(bob, release); // Draw a line between spring and bob
    bob.display(); 
    spring.display(); 
    textSize(12);
    fill(0);
    text("click on bob to drag/ press key to reset",10,height-5);
      
    for (int i = 0; i < w.length; i++) {
      w[i].walk();
      k = w[i].display(bob);
      m = m+k;
    }
  }
  
  if (!finish) {
    n = m;
  }
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
