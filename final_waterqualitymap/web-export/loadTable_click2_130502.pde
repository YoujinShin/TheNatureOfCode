import toxi.geom.*;
import toxi.physics2d.*;
import toxi.physics2d.behaviors.*;

PImage img;
PImage texture;
Data mydata;
Simbol water;

float[] X; // y (-90, 90) ㅅㅔㄹㅗ
float[] Y; // x (-180, 180) ㄱㅏㄹㅗ
int size = 13;

PFont myfont;
boolean isPressed = false;
boolean isStart = false;
int boxW = 1100;
int boxH = 600;
int radiusIntro = 500;
int selectI;

void setup() {

  X = new float[size];
  Y = new float[size];

  size(1400, 800);  // 1400, 800
  mydata = new Data();
  mydata.initialize();
  water = new Simbol();
  myfont = loadFont("Haettenschweiler-48.vlw");
  textFont(myfont);

  img = loadImage("map1.jpg"); // 10 * 6.25
  texture = loadImage("texture.png");
  smooth();

  initialize();
}

void draw() {

  img.resize(width, height);
  imageMode(CORNERS);

  image(img, 10, 0);
  fill(0);
  noStroke();
  rectMode(CORNER);
  rect(0,0,width,60);//40
//  rect(0,0,0, height) ;
  
  if (mydata.isFinish ==false) {
    
    operation();
  } else {
    
    finish();
  }
}

////////////////////////////////////////////////////////////////////////////////////

void operation() {

  if (isStart) {
    
    if (isPressed == false) { 
      mydata.locDisplay(texture);
      mydata.dataDisplay(texture);
      mydata.hover();
      title();
    } 
    else {
      mydata.showBox(selectI);
    }
  } 
  else {

    intro();
//    finish();
  }
}

////////////////////////////////////////////////////////////////////////////////////

void mouseClicked() {

  // isStart == true
  if (isStart) {

    // show box, when people click country name
    if (isPressed == false) {
      for (int i = 0; i < size; i++) {  
        float distance = dist(X[i], Y[i], mouseX, mouseY); 
        if (distance < 20) {
          isPressed = true;
          mydata.clicked[i] = 1;
          selectI = i;
          mydata.state = 0;
        }
      }
    }

    // reset to initial condition
    if (dist(mydata.button[2][0], mydata.button[2][1], mouseX, mouseY) < 150*0.4/2) {
      isPressed = false;
      mydata.resetTapwater();
    }
    
    // drag?
    if (mouseX>width/6 - width/150 && mouseX<width/6 - width/150+width/8 + width/40) {
      if(mouseY>height/2.2 && mouseY<height/2.2+ height/3) {
        mydata.controlParticle();
      }
    }
  
  // isStart == false
  } 
  else {

    float distance = dist(mouseX, mouseY, width/2, height/2);
    if (distance < radiusIntro/2) {

      isStart = true;
    }
  }
}

////////////////////////////////////////////////////////////////////////////////////

void intro() {

  fill(0, 180);
  rectMode(CENTER);
  rect(width/2, height/2, width, height);

  fill(200, 160); //230
  stroke(255, 120);
  strokeWeight(20);
  ellipse(width/2, height/2, radiusIntro, radiusIntro);
  noStroke();
  water.displayWaterdrop(width/2, height/3, 3);
  water.hover();

  fill(255);
  textSize(36);
  textAlign(CENTER, CENTER);
  text("CLICK TO EXPLORE WORLD", width/2, height/2+130);
}

void finish() {

  fill(0, 180);
  rectMode(CENTER);
  rect(width/2, height/2, width, height);

  fill(200, 160); //230
  stroke(255, 120);
  strokeWeight(20);
  ellipse(width/2, height/2, radiusIntro, radiusIntro);
  noStroke();
  water.displayWaterdrop(width/2, height/3-15, 1.8);
//  water.hover();

  fill(250);
  textSize(80);
  textAlign(CENTER, CENTER);
  text("THANKS", width/2, height/2+30);
  textSize(20);
  fill(220);
  text("FOR YOUR JOURNEY WITH US", width/2, height/2+100);
}

////////////////////////////////////////////////////////////////////////////////////

void initialize() {

  for (int i = 0; i < size; i++) {
    //println(mywater.lat[i]);
    float y = map(mydata.lat[i], -90, 90, height, height*65/400);// ㅅㅔㄹㅗ
    float x = map(mydata.lon[i], -180, 180, width*(10/700), width*660/700); // ㄱㅏㄹㅗ
    X[i] = x;
    Y[i] = y;
  }
}

void title() {
  
//  fill(200, 160);
  rect(0,0,width,59);
  stroke(255);
  line(20,60,width-20,59);
  
  textAlign(LEFT, BOTTOM);
  textSize(34);
  fill(255);
  text("WATER QUALITY OF THE WORLD 2008", 50, 60);
  
      // reference 
    fill(180);
    textSize(22);
    text("© WHO - UNICEF 2008",  width - 200, height-65);  // reference
    
}

class Data {
  
  Table table;
  PImage texture;
  String[] nation;
  int[] improvedWater;
  int[] population;
  float[] lat; // y (-90, 90) ㅅㅔㄹㅗ
  float[] lon; // x (-180, 180) ㄱㅏㄹㅗ
  float[] X;
  float[] Y;
  int[] DiarD; // child diarrhea death from 0 - 12
  int[] clicked; // 0: no, 1: yes
  int size = 13; // 175 for 2010, 18 for click
  int boxW = 1100;
  int boxH = 600; 
   
  float[][] button; 
  int state = 0; // 0: initial, 1: tap water, 2: bottle
  
  Particle myparticle;
  Simbol water;
  People mypeople;
  
  boolean isFinish = false;
  float noff = 0;
  int selectI = 0;
  
  Data() {
    
    table = loadTable("improved_click2008.csv");
    nation = new String[size];
    improvedWater = new int[size];
    lat = new float[size];
    lon = new float[size];
    Y = new float[size];
    X = new float[size];
    clicked = new int[size];
    DiarD = new int[size];
    population = new int[size];
    
    button = new float[3][2]; 
    noff = random(1000);
    
    myparticle = new Particle();
    water = new Simbol();
    mypeople = new People();
  }
  
  void locDisplay(PImage texture_) {
    
    texture = texture_;
    noStroke();
    fill(255, 140);

    for(int i = 0; i < size; i++) {   

      imageMode(CENTER);

      if(clicked[i] == 0) {
        
        tint(255);
        image(texture, X[i], Y[i], 15, 15); 
      } else {
        
        tint(140);
        image(texture, X[i], Y[i], 25, 25); 
      }    
    }
    
    checkClicked();
  }
  
  void dataDisplay(PImage texture_) {
    
    ellipseMode(CENTER);
    texture = texture_;
    
    for (int i = 0; i < size; i++) {  

      int r = 200-improvedWater[i]; //100
      float d = map(noise(noff), 0, 1, r/3, r);

      stroke(255, 100);
      noFill();
      strokeWeight(1.2);
      
      if(clicked[i] == 0) {
        ellipse(X[i], Y[i], r/3, r/3);
        noff= noff+0.005;
        noStroke();
      }
    }
    
//    checkClicked();
  }
  
  void initialize() {
    
    for(int i = 0; i < size; i++) {
      nation[i] = table.getString(i+1,0);
      improvedWater[i] = (int) table.getFloat(i+1,1); // 0 ~ 100
      lat[i] = table.getFloat(i+1,2); // horizontal -90 ~ 90 (y) ㅅㅔㄹㅗ
      lon[i] = table.getFloat(i+1,3); // vertical -180 ~ 180 (x) ㄱㅏㄹㅗ
      DiarD[i] = table.getInt(i+1,4);
      population[i] = table.getInt(i+1,6);
      clicked[i] = 0;
      //println("nation: "+nation[i]+", water: "+improvedWater[i]+", lat: "+lat[i]+", lon: "+lon[i]);
    }
    
    for(int i = 0; i < size; i++) {
      Y[i] = map(lat[i], -90, 90, height,height*65/400);// ㅅㅔㄹㅗ
      X[i] = map(lon[i], -180, 180, width*(10/700), width*660/700); // ㄱㅏㄹㅗ
    }
  }
  
  void checkClicked() {
    
    int sum = 0;
    for(int i = 0; i < size; i++) {
      sum = sum + clicked[i];
    }
    
    if (sum == size) {
      isFinish = true;
    }
  }
  
  ///////////////////////////////////////////////////////////////////////////////////////
  
  void showBox(int selectI_) {
    
    selectI = selectI_;
    
    fill(0, 210);
    stroke(255);
    strokeWeight(0.4);
    rectMode(CENTER);
    rect(width/2, height/2, boxW, boxH);

    showName();
    showButton();
    showTapwater();
//    showPeople();
    
    if(dist(button[0][0], button[0][1], mouseX, mouseY) < 150*0.4/2) {
      if(mousePressed) {
        state = 1; // 0: initial, 1: tap water, 2: bottle
      }
    } else if(dist(button[1][0], button[1][1], mouseX, mouseY) < 150*0.4/2) {
      if(mousePressed) {
        state = 2; // 0: initial, 1: tap water, 2: bottle
      }
    }
  }
  
  ///////////////////////////////////////////////////////////////////////////////////////
  
  void hover() {
  
    for (int i = 0; i < size; i++) {   
  
      ellipseMode(CENTER);
      noStroke();
      float distance = dist(X[i], Y[i], mouseX, mouseY); 
  
      if (distance < 20 && clicked[i] == 0) {
  
        float d = map(noise(noff), 0, 1, 60, 120);
        fill(0, 255, 255, 120);  
        ellipse(X[i], Y[i], d, d);
      }
      noff= noff+0.01;
    }
    noFill();
  }

  void showTapwater() {
    
    myparticle.display(texture, improvedWater[selectI], DiarD[selectI], state, population[selectI]);
  }
  
  void resetTapwater() {
    
    myparticle.removeParticle();
  }
  
  void showName() {
    
    rectMode(CORNER);
    fill(200, 100); //230
    noStroke();
    rect((width-1100)/2 + 20, 150 - 20, 1100 - 40, 50);
    
    textAlign(LEFT, BOTTOM);
    fill(0); 
    textSize(42);
    text(nation[selectI],width/6 - width/150, 200 - 20); // nation name


  }
  
  void showButton() {
    
    int t = -100;
    water.displayWaterButton(width/2 + 1100/2 + 35, height/2-80 - t, 0.4);
    water.displayBottleButton(width/2 + 1100/2 + 35, height/2 - t, 0.4);
    water.displayExitButton(width/2 + 1100/2 + 35, height/2+80 - t, 0.4);
    
    // button 1 position
    button[0][0] = width/2 + 1100/2 + 35;
    button[0][1] = height/2-80 - t;
    
    // button 2 position
    button[1][0] = width/2 + 1100/2 + 35;
    button[1][1] = height/2 - t;
    
    // button 3 position
    button[2][0] = width/2 + 1100/2 + 35;
    button[2][1] = height/2+80 - t;
  }
  
  void controlParticle() {
    
    myparticle.mousePressed();
    myparticle.mouseDragged();
    myparticle.mouseReleased();
  }
  
}
class Particle {

  // Toxiblins Attraction2D example!
  int NUM_PARTICLES = 200;
  int NUM_PARTICLES_WATER = 50;
  int NUM_PARTICLES_VIRUS = 50;
  int d = 10; // diameter of particles

  int glassWidth = width/8 + width/40;
  int glassHeight = height/3;
  float glassX = width/6 - width/150;
  float glassY = height/2.2;
  int quality;
  int pop;
  color colorParticle[];

  PImage img;
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

  Particle() {

    physics = new VerletPhysics2D();
    physics.setDrag(0.05f); //0.05f
    physics.setWorldBounds(new Rect(glassX, glassY +20, glassWidth, glassHeight -20)); //new Rect(0, 0, width, height)
    physics.addBehavior(new GravityBehavior(new Vec2D(0, 0.15f))); //Vec2D(0, 0.15f)
    
    mysimbol = new Simbol();
    colorParticle = new color[NUM_PARTICLES];
    mytapwater = new TapWater();
    mypeople = new People();

    index = 0; // increasing num of particles
    indexCD = 0; // increasing num of child deaths
    indexContaminant = 0;
    indexPeople = 0;
    cd = 0;
  }

  void display(PImage img_, int quality_, int cd_, int state_, int pop_) {

    //    println(glassX+", "+glassY+", "+glassWidth+", "+glassHeight);
    img = img_;
    quality = quality_;
    cd = cd_;
    state = state_; // 0: initial, 1: tap water, 2: bottle
    pop = pop_;

    NUM_PARTICLES_WATER = (int) map(quality, 0, 100, 0, NUM_PARTICLES); // for water
    NUM_PARTICLES_VIRUS = NUM_PARTICLES - NUM_PARTICLES_WATER;

    if (state == 1 || state == 2) {
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

    if (state == 1) {

      drawGlass();
      mytapwater.display(width/4.5, height/3 - height/30, 0.85); // 0.82
      enterTextPeople();
    } 
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

    // muliply
    rectMode(CENTER);
//    noFill();
    noStroke();
    fill(120);
    pushMatrix();
    translate(60, -5);
    rect(width/2.5, height/2 + 80, 80,100);
    triangle(width/2.5+40, height/2 + 80 + 120, width/2.5+40, height/2 + 80 - 120, width/2.5+40 + 100, height/2 + 80);
    
    fill(140, 100);
    translate(-5, 0);
    rect(width/2.5, height/2 + 80, 80,100);
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

    fill(255);
    textSize(52);
    text("CHILD DEATH", width/2 -2*20+ 330, height/2 -120); // width/2 -2*20+ 330, height/2 -100

    fill(150);
    textSize(20);
    text("FROM DIARRHEA", width/2 -2*20+ 330, height/2 - 120 + 60); //  width/2 -2*20+ 330, height/2 - 50

    fill(255, 0, 0);
    textSize(200);
    text(indexCD, width/2 -2*20 + 330, height/2 +4*20);

    if (indexCD < cd) {
      indexCD++;
    }
  }

  void enterTextPeople() {

    fill(255);
    textSize(48);
    text("ACCESS TO CLEAN WATER", width/2 + 150, height/2 - 120);
    
    int popRatio = int( pop*0.01);
    fill(150);
    textSize(20);
    text("= "+popRatio+"x 1,000 person", width/2 + 260 + 50, height/2 - 120 + 50);
    mypeople.display( width/2 + 130 + 50, height/2 - 125 + 50, 0.2, color(255, 120));  // (100, 90)
     
    int numP = 0;
    color c;

    for (int i = 0; i < 20; i++) {
      for (int j = 0; j < 5; j++) {

        if (numP <= quality) {
          c = color(255, 120);
        } 
        else {
          c = color(100, 90);
        }

        float mult = 0.4;
        mypeople.display(width/3+120 + i*mult*70, height/3+110 + j*mult*150, 0.3, c);
        numP++;
      }
    }

    fill(255);
    textSize(200);
    //    text(indexPeople+"%", width/2 -2*20 + 330, height/2 +4*20);

    if (indexPeople < quality) {
      indexPeople++;
    }
  }


  void mousePressed() {
    mousePos = new Vec2D(mouseX, mouseY);
    // create a new positive attraction force field around the mouse position (radius=250px)
    mouseAttractor = new AttractionBehavior(mousePos, 250, 0.9f);
    physics.addBehavior(mouseAttractor);
  }

  void mouseDragged() {
    // update mouse attraction focal point
    mousePos.set(mouseX, mouseY);
  }

  void mouseReleased() {
    // remove the mouse attraction when button has been released
    physics.removeBehavior(mouseAttractor);
  }

}

class People {
  
  float x, y, a;
  color c;
  
  People() {
    
    x = 0;
    y = 0;
    a = 1;
  }
  
  void display(float x_, float y_, float a_, color c_) {
    
    x = x_;
    y = y_;
    a = a_;
    c = c_;
    
    pushMatrix();
    
    translate(x, y);
    fill(c);
    noStroke();
//    stroke(c);
    smooth();
    
    ellipseMode(CENTER);
    ellipse(0, 0, 40*a, 40*a);
    
    rectMode(CORNER);
    arc(0, 50*a, 50*a, 50*a, PI, 2*PI); 
    rect(-25*a, 50*a, 50*a, 40*a);
    
    popMatrix();
  }
}
class Simbol {
  
  float w = 1;
  float x, y;
  
  Simbol() {
    
    x = 0;
    y = 0;
  }
  
  void displayWaterdrop(float x_, float y_, float w_) { // x, y, width of glass
    
    x = x_;
    y = y_;
    w = w_;
    
    ellipseMode(CENTER);
    pushMatrix();
    
    translate(x, y);
    fill(0, 255, 255, 200); // blue
    noStroke();
    
    triangle(0, 0, -20*w, 50*w, 20*w, 50*w);
    arc(0, 50*w, 40*w, 40*w, 0, PI, OPEN);    
    popMatrix();
  }
  
  void displayWaterButton(float x_, float y_, float w_) { // x, y, width of glass
    
    x = x_;
    y = y_;
    w = w_;
    
    pushMatrix();
    translate(x, y);
    
    // background circle
    fill(200, 100); //230
    stroke(255, 120);
    strokeWeight(w*6);
    ellipseMode(CENTER);
    ellipse(0, 0,150*w, 150*w);
    
    // water drop
    ellipseMode(CENTER);
    
//    fill(0, 255, 255, 200); // blue
    fill(255, 220); // white
    noStroke();
    
    translate(0, -w*30);
    triangle(0, 0, -20*w, 50*w, 20*w, 50*w);
    arc(0, 50*w, 40*w, 40*w, 0, PI, OPEN);    
    popMatrix();
  }
  
   void displayExitButton(float x_, float y_, float w_) { // x, y, width of glass
    
    x = x_;
    y = y_;
    w = w_;
    
    pushMatrix();
    translate(x, y);
    
    // background circle
    fill(200, 100); //(200, 100)
    stroke(255, 120);
    strokeWeight(w*6);
    ellipseMode(CENTER);
    ellipse(0, 0,150*w, 150*w);
    
    // text
    fill(255, 150);
    textSize(32);
    textAlign(CENTER,CENTER);
    text("X", 0, 0); 
//    text("EXIT", 0, 0); // font size 20
    popMatrix(); 
  }
  
  void displayBottleButton(float x_, float y_, float w_) { // x, y, width of glass
    
    x = x_;
    y = y_;
    w = w_;
    
    pushMatrix();
    translate(x, y);
    
    // background circle
    fill(200, 100); //230
    stroke(255, 120);
    strokeWeight(w*6);
    ellipseMode(CENTER);
    ellipse(0, 0,150*w, 150*w);
    
    // text
    float glassX = 224;
    float glassY = 364;
    int glassWidth = 210;
    int glassHeight = 266;
    
    float rHW = glassHeight/glassWidth;
    float bottleWidth = 200;
    float bottleHeight = rHW * bottleWidth;
    float upperHeight = bottleWidth* 40 / 230;
    
    float mult = 0.3;

    stroke(255);
    strokeWeight(w*2);
    
    translate(0, w*15);
    // rect
    rectMode(CENTER);
    noFill();
    rect(0, 0, bottleWidth*w * mult, bottleHeight *w *mult, 10);
    fill(255, 180);
    rect(0, (-bottleHeight/2 -upperHeight/2)*w* mult, bottleWidth*0.8 *w *mult, upperHeight *w *mult, 10);
    
    // ellipse
    fill(255);
    ellipseMode(CENTER);
    arc(0, (-bottleHeight/2 -upperHeight)*w *mult, bottleWidth*0.6*w *mult, bottleWidth*0.6*w *mult, PI, 2*PI);
    ellipse(0, (-bottleHeight/2 -upperHeight*3)*w *mult, upperHeight*w *mult, upperHeight*w *mult);
  
    popMatrix();
  }
  
  void hover() {
    
    float distance = dist(mouseX, mouseY, width/2, height/2);
    if(distance < 500/2) {
      
      ellipseMode(CENTER);
      
      // ellipse
      fill(180, 180);
      ellipse(width/2, height/2, 500, 500);

      // water drop
      pushMatrix();
      translate(x, y);
      fill(255, 200); // 180
      noStroke();
      
      triangle(0, 0, -20*w, 50*w, 20*w, 50*w);
      arc(0, 50*w, 40*w, 40*w, 0, PI, OPEN);    
      popMatrix();
    }
  }
}
class TapWater {
  
  float a, x, y;
  
  TapWater() {
    
    a = 1;
    x = 0;
    y = 0;
  }
  
  void display(float x_, float y_, float a_) {
  
    x = x_;
    y = y_;
    a = a_;
    
    pushMatrix();
    translate(x - 50*a, y);
    rectMode(CENTER);
    ellipseMode(CENTER);
    
    fill(255);
    noStroke();
    
    rect(0, 0, 60*a, 10*a);
    ellipse(30*a, 0, 10*a, 10*a);
    ellipse(-30*a, 0, 10*a, 10*a);
    rect(0, 20*a, 10*a, 40*a);
    ellipse(0, 30*a, 30*a, 30*a);
    rect(0, 50*a, 40*a, 40*a);
    rect(0, 70*a, 100*a, 30*a);
    arc(50*a, 85*a, 60*a, 60*a, PI, 2*PI);
    rect(65*a, 91*a, 30*a, 15*a);// rect(65*a, 91*a, 30*a, 15*a);
    
    rect(-55*a, 70*a, 10*a, 100*a);
    popMatrix();
  }
}

