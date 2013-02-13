// The nature of code week2: friction and drag force

Mover[] movers = new Mover[5];
Liquid liquid;

int holeWidth = 88;

void setup() {
  size(500, 360);
  randomSeed(4);
  for (int i =0; i < movers.length; i++) {
    movers[i] = new Mover(random(1, 4), random(width), 0);
  }
  
  liquid = new Liquid(0, height/2, width, height/2, 0.2);
}

void draw() {
  background(255);
  
  rectDisplay();
  liquid.display();
  
  for (int i = 0; i < movers.length; i++) {
    
    PVector wind = new PVector(0.025, 0);
    PVector gravity = new PVector(0, 0.1*movers[i].mass);
    
    if (liquid.contains(movers[i])) {
      PVector dragForce = liquid.drag(movers[i]);
      movers[i].applyForce(dragForce);
      
      wind.mult(0); // no wind inside of water
    }

    float c = 0.05;
    PVector friction = movers[i].velocity.get();
    friction.mult(-1);
    friction.normalize();
    friction. mult(c);
    
    movers[i].applyForce(gravity);
    movers[i].applyForce(friction);
    movers[i].applyForce(wind);
    
    
    movers[i].update();
    movers[i].display();
    
    if (movers[i].location.y < height/4 + 20) {
      int goCheck = check(movers[i]); // 1: go through hole
      if (goCheck == 0) {
        movers[i].checkEdges();
      } else {
        movers[i].checkEdgesBottom();
      }
    } else {
      movers[i].checkEdgesBottom();
    }
    
  }
}

int check(Mover m) {
  int go = 0;
  int left = width/ 2 - holeWidth/2;
  int right = width/ 2 + holeWidth/2;
 
  if((m.location.x - m.mass*8 >left)&&(m.location.x + m.mass*8 <right)) {
    if((m.location.y > height/4 - m.mass*8)&&(m.location.y < height)) {
      go = 1;
    } else {
      go = 0;
    }
  } else {
    go = 0;
  }
  
  return go;
}

void rectDisplay() {
  stroke(204, 102, 0);
  noStroke();
  fill(246, 195, 107);
  rect(0, height/4, width/2 - holeWidth/2, 20);
  rect(width/2 + holeWidth/2, height/4, width/2 - holeWidth/2, 20);
}
