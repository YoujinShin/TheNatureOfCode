class Particle {

  // Toxiblins Attraction2D example!
  int NUM_PARTICLES = 200;
  int NUM_PARTICLES_WATER = 50;
  int NUM_PARTICLES_VIRUS = 50;
  int num_state_0 = 1;
  int d = 10; // diameter of particles

  int glassWidth = width/8 + width/40;
  int glassHeight = height/3;
  float glassX = width/6 - width/150;
  float glassY = height/2.2;
  int quality;
  int pop, income;
  color colorParticle[];

  PImage img;
  PImage coin;
  boolean isWater = true;
  int index, indexCD, indexContaminant, indexPeople;
  int cd;
  int state = 0; // 0: initial, 1: tap water, 2: bottle

  VerletPhysics2D physics;
  AttractionBehavior mouseAttractor;
  Vec2D mousePos;

  Simbol mysimbol;
  TapWater mytapwater;
  People mypeople;
  Spring myspring;
  Spring USspring;
  Income myincome;

  Particle() {

    physics = new VerletPhysics2D();
    physics.setDrag(0.05f); //0.05f
    physics.setWorldBounds(new Rect(glassX, glassY +20, glassWidth, glassHeight -20)); //new Rect(0, 0, width, height)
    physics.addBehavior(new GravityBehavior(new Vec2D(0, 0.15f))); //Vec2D(0, 0.15f)

    mysimbol = new Simbol();
    colorParticle = new color[NUM_PARTICLES];
    mytapwater = new TapWater();
    mypeople = new People();
    
    myspring = new Spring();
    USspring = new Spring();
    myincome = new Income();

    index = 0; // increasing num of particles
    indexCD = 0; // increasing num of child deaths
    indexContaminant = 0;
    indexPeople = 0;
    cd = 0;
    income = 0;
  }

  void display(PImage img_, PImage coin_, int quality_, int cd_, int state_, int pop_, int income_) {

    img = img_;
    coin = coin_;
    quality = quality_;
    cd = cd_;
    state = state_; // 0: initial, 1: tap water, 2: bottle
    pop = pop_;
    income = income_;

    NUM_PARTICLES_WATER = (int) map(quality, 0, 100, 0, NUM_PARTICLES); // for water
    NUM_PARTICLES_VIRUS = NUM_PARTICLES - NUM_PARTICLES_WATER;
    
//////////////////////////////////////////// STATE 0 ///////////////////////////////////////////
    if (state == 1) {
      
      if(num_state_0 == 1) { // for the first spring initialization
        
//        myspring.initialize(1, income);
        num_state_0 = 0;
        
      } else {
        num_state_0 = 0;
      }
      
//      myspring.display();
      myincome.display(coin, pop, income);
      enterIncome();
    }
 
//////////////////////////////////////////// STATE 1, 2 ///////////////////////////////////////////   
    if (state == 0 || state == 2) {
      drawWater();

      noStroke();
      fill(255);
      if (physics.particles.size() < NUM_PARTICLES) {

        addParticle();

        float prob = random(1);
        float qualityRatio = (float) quality/100;

        if (prob < (qualityRatio)) {
          colorParticle[index] = color(0, 255, 255, 100); // blue
        } 
        else {
          indexContaminant++;
          colorParticle[index] = color(255, 0, 0); // red
        }
      }
      physics.update();

      for (int i = 0; i<physics.particles.size(); i++) {
        VerletParticle2D p = physics.particles.get(i);
        imageMode(CENTER);
        tint(colorParticle[i]);
        image(img, p.x, p.y, d, d);
      }
      index++;
    }

//////////////////////////////////////////// STATE 1 ///////////////////////////////////////////
    if (state == 0) {

      drawGlass();
      mytapwater.display(width/4.5, height/3 - height/30, 0.85); // 0.82
      enterTextPeople();
    } 
    
//////////////////////////////////////////// STATE 2 ///////////////////////////////////////////
    else if (state == 2) {

      drawBottle();
      enterText();
    }

    noTint();
  }

  void addParticle() {

    float position = glassX + glassWidth/2;

    VerletParticle2D p = new VerletParticle2D(Vec2D.randomVector().scale(5).addSelf(position, glassY + 20));
    physics.addParticle(p);

    // add a negative attraction force field around the new particle 
    if (isWater) {
      physics.addBehavior(new AttractionBehavior(p, 20, -1.2f, 0.05f)); // (p, 20, -1.2f, 0.01f)
    } 
    else {
      physics.addBehavior(new AttractionBehavior(p, 50, -4f, 0.2f));
    }
  }

  void removeParticle() {

    for (int i = physics.particles.size()-1; i >= 0 ; i--) {
      //      print("Deleting Particle number ");
      //      println(i);      
      ParticleBehavior2D b = physics.behaviors.get(i+1); // i -> gravity, i+1 -> attraction
      physics.removeBehavior(b);

      VerletParticle2D p = physics.particles.get(i);
      physics.removeParticle(p);
    }
    index = 0;
    indexCD = 0;
    indexContaminant = 0;
    indexPeople = 0;
  }

  void removesSpr() {
    
    myspring.removeSpring();
//    USspring.removeSpring();
    num_state_0 = 1;
  }
  
  void removeIncome() {
    
    myincome.removeParticle();
//    USspring.removeSpring();
    num_state_0 = 1;
  }
  
  
  void drawGlass() {

    int w = 5;
    float xl = glassX-d;
    float xr = glassX+glassWidth+d;
    float yu = glassY;
    float yd = glassY+glassHeight+d;

    noFill();
    stroke(255); // 255, 70
    strokeWeight(w);
    ellipseMode(CORNER);
    //ellipse(xl, yu, glassWidth+2*d, 30);// upper

    line(xl, yu+15, xl, yd); // left
    line(xr, yu+15, xr, yd); // right

    rectMode(CORNER);
    fill(255, 40);
    rect(xl, yd, xr-xl, height/50);
    //    line(xl, yd, xr, yd); // bottom
  }

  void drawBottle() {

    int w = 10;
    float xl = glassX-d;
    float xr = glassX+glassWidth+d;
    float yu = glassY;
    float yd = glassY+glassHeight+d;
    int add = 20;

    stroke(255);
    strokeWeight(w);

    // rect
    rectMode(CORNER);
    noFill();
    rect(xl, yu+add, xr - xl, yd - yu-add, 10);
    fill(255, 180);
    rect(xl+ (xr - xl)*0.1, yu-40+add, (xr - xl)*0.8, 40, 10);

    // ellipse
    fill(255);
    ellipseMode(CORNER);
    arc(xl+ (xr - xl)*0.2, yu-(xr - xl)*0.3-40+add, (xr - xl)*0.6, (xr - xl)*0.6, PI, 2*PI);
    ellipseMode(CENTER);
    ellipse(xl + (xr-xl)/2, yu-120+add, 40, 40);

    // line
    line(xl, yu+(yd - yu)/2+add, xl + 50, yu+(yd - yu)/2+add); // center
    line(xl, yu+(yd - yu)/2+add - 50, xl + 50, yu+(yd - yu)/2+add - 50); // up
    line(xl, yu+(yd - yu)/2+add + 50, xl + 50, yu+(yd - yu)/2+add + 50); // down

    // arrow
    rectMode(CENTER);
    fill(100, 180); //120
    pushMatrix();
    translate(-10, 30);
    stroke(180, 180);
    noFill();
    strokeWeight(2);
    triangle(width/2.5+40, height/2 + 80 + 120, width/2.5+40, height/2 + 80 - 120, width/2.5+40 + 100, height/2 + 80);
    popMatrix();
  }

  void drawWater() {

    int w = 2;
    float xl = glassX-d;
    float xr = glassX+glassWidth+d;
    float yu = glassY;
    float yd = glassY+glassHeight+d;
    float yg = glassY+70;

    rectMode(CORNER);
    noStroke();
    //    fill(0, 255, 255, 200); // blue - clean water
    fill(0, 255, 255, 200-1.3*indexContaminant); 

    noStroke();
    rect(xl + w/2+1, yg, glassWidth+2*d - w, yd-yg-w/2);
    ellipseMode(CENTER); 
    ellipse(xl + w/2+1 +glassWidth/2 +d, yg, glassWidth+2*d, 30);
    arc(xl + w/2+1 +glassWidth/2 +d, yg, glassWidth+2*d, 30, PI, 2*PI);
    //    arc(xl + w/2+1 +glassWidth/2 +d, yd, glassWidth+2*d , 30, 0, PI);
  }

  void enterText() {
    
    textAlign(CENTER);
    textFont(myfont);
    fill(255);
    textSize(60);
    text("NO. OF CHILD DEATH",  width/2 + 250, height/2 - 110); //width/2 + 250, height/2 -120); // width/2 -2*20+ 330, height/2 -100

    fill(120);
    textSize(35);
    
    text("FROM DIARRHEA", width/2 +250, height/2 - 55); //  width/2 -2*20+ 330, height/2 - 50 // 250

    textFont(mynumber);
    textAlign(CENTER, BOTTOM);
    fill(255, 0, 0);
    textSize(350);
    text(indexCD, width/2 + 250, height/2 + 290); 

    if (indexCD < cd) {
      indexCD++;
    }
  }
  
  void enterIncome() {
    
    textAlign(CENTER);
    textFont(myfont);
    fill(255);
    textSize(60);
    text("INCOME PER DAY",  width/2 + 250, height/2 - 110); //width/2 + 250, height/2 -120); // width/2 -2*20+ 330, height/2 -100

    fill(150);
    textSize(25);
//    text("PER PERSON", width/2 +250, height/2 - 70); //  width/2 -2*20+ 330, height/2 - 50
    
    fill(120);
    textSize(35);
    text("PER PERSON, ", width/2 + 230, height/2 - 55);
    
    fill(190);
    textSize(35);
    text("US$", width/2 + 320, height/2 - 55);
//    text("USD", width/2 + 450, height/2 + 230);
  }

  void enterTextPeople() {
    
    textFont(myfont);
    textAlign(CENTER);
    fill(255);
    textSize(60);
    text("ACCESS TO CLEAN WATER", width/2 + 150, height/2 - 110);

    int popRatio = int( pop*0.01);
    fill(120);
    textAlign(LEFT);
    textSize(35);
    text("of total "+pop, width/2 + 100, height/2 - 55);
    
    fill(0,255,255, 140);
    text(quality+"%", width/2 +43, height/2 - 55);
//    mypeople.display( width/2 + 180 + 42, height/2 - 125 + 40, 0.18, color(255, 120));  // (100, 90)

    int numP = 0;
    color c;

    for (int j = 0; j < 5; j++) {
      for (int i = 0; i < 20; i++) {

        if (numP <= quality) {
          c = color(0,255,255, 100);
        } 
        else {
          c = color(100, 90);
        }

        float mult = 0.4;
        mypeople.display(width/3+120 + i*mult*70, height/3+126 + j*mult*150, 0.3, c);
        numP++;
      }
    }

    fill(255);
    textSize(200);

    if (indexPeople < quality) {
      indexPeople++;
    }
  }

  void startAttract() {
    mousePos = new Vec2D(mouseX, mouseY);
    // create a new positive attraction force field around the mouse position (radius=250px)
    mouseAttractor = new AttractionBehavior(mousePos, 250, 0.9f);
    physics.addBehavior(mouseAttractor);
  }

  void updateAttract() {
    // update mouse attraction focal point
    mousePos.set(mouseX, mouseY);
  }

  void stopAttract() {
    // remove the mouse attraction when button has been released
    physics.removeBehavior(mouseAttractor);
  }
  
  void incomestartAttract() {
    myincome.startAttract();
  }

  void incomeupdateAttract() {
    myincome.updateAttract();
  }

  void incomestopAttract() {
    // remove the mouse attraction when button has been released
    myincome.stopAttract();
  }
}

