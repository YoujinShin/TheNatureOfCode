class Spring {
  
  int USincome = round(115.6892604); // dollar, income per person per day (gdp/(population*365)) in 2008;
  int income = 0;
  int USlifeExpectancy = round(77.8); // 
  int lifeExpectancy = 0;
  
  float usX, usY;
  float nX, nY;
  int multnum = 0;
  
  int DIM=12;
  int REST_LENGTH=100; // 20 (4-> attraction 100, 10 -> 200)
  float STRENGTH=0.5; // 0.125
  float INNER_STRENGTH = 1; // 0.13
  int type = 0;
  int boxW = 1100;
  int boxH = 600; 
  
  float x, y;
  
  VerletPhysics2D physics;
  VerletParticle2D head,tail;
  
  Spring() {
    
    usX = 0;
    usY = 0;
    nX = 0;
    nY = 0;
    
    x = width/2 - boxW/2 + 90; //20
    y = 180 + 65;//height/2 - boxH/2 ;
    
    physics=new VerletPhysics2D();
    physics.addBehavior(new GravityBehavior(new Vec2D(0,0.1)));
    physics.setWorldBounds(new Rect(x, y, boxW*0.44, boxH*0.65));
  }
  
  void display() {
    
    rectMode(CORNER);
    noFill();
//    fill(0);
    strokeWeight(1);
    stroke(80);
    rect(x, y,  boxW*0.44, boxH*0.65);
    
    
    if(type == 1) {
      strokeWeight(2);
      stroke(255, 0, 0);
    } else {
      strokeWeight(2);
      stroke(120, 90);
    }
    
    if(mousePressed && type==1) { //if(mousePressed && type==1) {
      head.set(mouseX,mouseY);
    }
    physics.update();

    for(int i=0;i<physics.springs.size()-1; i++) {
      VerletSpring2D s=physics.springs.get(i);
//      fill(255,0,0);
//      noStroke();
//      ellipse(s.a.x,s.a.y, 20, 20);

      line(s.a.x,s.a.y,s.b.x,s.b.y);
    }

//    VerletSpring2D s=physics.springs.get(physics.springs.size()/2);
//    fill(255);
//    ellipse(s.a.x, s.a.y, 20,20);
    
    textFont(mynumber);
    textAlign(CENTER, BOTTOM);
    fill(255, 0, 0);
    textSize(350);
    text(income, width/2 + 250, height/2 + 290);
  }
  
  void initialize(int type_, int income_) {
    
    type = type_;
    income = income_;
//    println(income);
    
    if(type == 1) { // nation
      
      REST_LENGTH = int(map(income, 0, 116, 2, 22)); // 4, 10
      
    } else {  // type == 0, US
      
      REST_LENGTH = int(map(USincome, 0, 116, 2, 22)); // 20
    }
    int AttactionStrength = REST_LENGTH*25;
    
    for(int y = 0, idx = 0; y < DIM; y++) {
      
      for(int x = 0; x < DIM; x++) {
        
        VerletParticle2D p = new VerletParticle2D(x*REST_LENGTH,y*REST_LENGTH);
        physics.addParticle(p);
        ////// youjin /////
        physics.addBehavior(new AttractionBehavior(p, AttactionStrength, -1.2f, 0.01f)); // (p, 20, -1.2f, 0.01f))
        ////////////////////
        
        if(x > 0) {
          VerletSpring2D s=new VerletSpring2D(p,physics.particles.get(idx-1),REST_LENGTH,STRENGTH);
          physics.addSpring(s);
        }
        if(y > 0) {
          VerletSpring2D s=new VerletSpring2D(p,physics.particles.get(idx-DIM),REST_LENGTH,STRENGTH);
          physics.addSpring(s);
        }
        idx++;
      }
    }
    
    VerletParticle2D p = physics.particles.get(0);
    VerletParticle2D q = physics.particles.get(physics.particles.size()-1);
    float len = sqrt(sq(REST_LENGTH*(DIM-1))*2);
    VerletSpring2D s = new VerletSpring2D(p,q,len,INNER_STRENGTH);
    physics.addSpring(s);
    
    p = physics.particles.get(DIM-1);
    q = physics.particles.get(physics.particles.size()-DIM);
    s = new VerletSpring2D(p,q,len,INNER_STRENGTH);
    physics.addSpring(s);
    
    if(type == 1) {
      head = physics.particles.get((DIM-1)/2);
    }
    
//    println("init particle size: "+physics.particles.size());
//    println("init spring size: "+physics.springs.size());
  }
  
  void removeSpring() {

    for (int i = physics.particles.size()-1; i >= 0 ; i--) { // (int i = physics.particles.size()-1; i >= 0 ; i--)
    
//      print("Deleting Particle number ");
//      println(i);      
      ParticleBehavior2D b = physics.behaviors.get(i+1); // i -> gravity, i+1 -> attraction
      physics.removeBehavior(b);

      VerletParticle2D p = physics.particles.get(i);
      physics.removeParticle(p);
    }
    
    for (int i = physics.springs.size()-1; i>=0; i--) { //numS-1
    
//      print("Deleting Spring number ");
//      println(i);  
      VerletSpring2D s = physics.springs.get(i);
      physics.removeSpring(s);
    }
    
    physics.removeParticle(head);
//    physics.removeParticle(tail);
  }
}
