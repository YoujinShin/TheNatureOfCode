import toxi.geom.*;
import toxi.physics2d.*;
import toxi.physics2d.behaviors.*;

PImage img;
PImage texture;
Data mydata;
Particle myparticle;
Simbol water;

float[] X; // y (-90, 90) ㅅㅔㄹㅗ
float[] Y; // x (-180, 180) ㄱㅏㄹㅗ
int size = 13;

PFont font2;
float noff = 0;
boolean isPressed = false;
boolean isStart = false;
int boxW = 1100;
int boxH = 600;
int radiusIntro = 500;
int selectI;

void setup() {

  X = new float[size];
  Y = new float[size];
  noff = random(1000);

  size(1400,800);  // (700, 400)
  mydata = new Data();
  myparticle = new Particle();
  mydata.initialize();
  water = new Simbol();

  img = loadImage("map1.jpg"); // 10 * 6.25
  texture = loadImage("texture.png");
  smooth();

  initialize();
  textSize(22);
}

void draw() {

  img.resize(width, height);
  imageMode(CORNERS);

  image(img, 10, 0);
  
  if (mydata.isFinish ==false) {
    
    operation();
  } else {
    
    finish();
  }

  fill(0);
  noStroke();
  rectMode(CENTER);
  rect(width/2, 20, width, 40);//40
  rect(0, height/2, 20, height);//40
}

////////////////////////////////////////////////////////////////////////////////////

void operation() {

  if (isStart) {
    if (isPressed == false) { 
      mydata.locDisplay(texture);
      mydata.dataDisplay(texture);
      hover();
    } 
    else {
      showBox();
    }
  } 
  else {

    intro();
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
        if (distance < 10) {
          isPressed = true;
          mydata.clicked[i] = 1;
          selectI = i;
        }
      }
    }

    // reset to initial condition
    if ((mouseX<width/2-boxW/2)||(mouseX>width/2+boxW/2)||(mouseY<height/2-boxH/2)||(mouseY>height/2+boxH/2)) {
      isPressed = false;
      myparticle.removeParticle();
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

  fill(0);
  textSize(22);
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

void showBox() { 

  fill(0, 210);
  rectMode(CENTER);
  rect(width/2, height/2, boxW, boxH);
  myparticle.display(texture, mydata.improvedWater[selectI]);

  textAlign(LEFT, BOTTOM);
  fill(230, 250);
  textSize(30);
  text(mydata.nation[selectI],300 - 15, 200); // nation name

  // simbol
  fill(200, 160); //230
  stroke(255, 120);
  strokeWeight(3);
  ellipse(300 - 70, 160,40, 40);
  noStroke();
  water.displayWaterdrop(300 - 50, 170, 0.3);

  fill(150);
  textSize(12);
  text("© WHO - UNICEF 2010", width-260, height-80);  // reference
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

void hover() {

  for (int i = 0; i < size; i++) {  

    ellipseMode(CENTER);
    noStroke();
    float distance = dist(X[i], Y[i], mouseX, mouseY); 

    if (distance < 10 && mydata.clicked[i] == 0) {

      float d = map(noise(noff), 0, 1, 60, 120);
      fill(0, 255, 255, 120);  
      ellipse(X[i], Y[i], d, d);
    }
    noff= noff+0.01;
  }
}

class Data {
  
  Table table;
  PImage texture;
  String[] nation;
  int[] improvedWater;
  float[] lat; // y (-90, 90) ㅅㅔㄹㅗ
  float[] lon; // x (-180, 180) ㄱㅏㄹㅗ
  float[] X;
  float[] Y;
  int[] clicked; // 0: no, 1: yes
  int size = 13; // 175 for 2010, 18 for click
  
  boolean isFinish = false;
  float noff = 0;
  
  Data() {
    
    table = loadTable("improved_click2.csv");
    nation = new String[size];
    improvedWater = new int[size];
    lat = new float[size];
    lon = new float[size];
    Y = new float[size];
    X = new float[size];
    clicked = new int[size];
    noff = random(1000);
  }
  
  void locDisplay(PImage texture_) {
    
    texture = texture_;
    noStroke();
    fill(255, 140);

    for(int i = 0; i < size; i++) {   
//      ellipse(X[i], Y[i], 25, 25);
      imageMode(CENTER);
      tint(255);
      
      if(clicked[i] == 0) {
        image(texture, X[i], Y[i], 15, 15); 
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
    
    checkClicked();
  }
  
  void initialize() {
    
    for(int i = 0; i < size; i++) {
      nation[i] = table.getString(i+1,0);
      improvedWater[i] = table.getInt(i+1,1); // 0 ~ 100
      lat[i] = table.getFloat(i+1,2); // horizontal -90 ~ 90 (y) ㅅㅔㄹㅗ
      lon[i] = table.getFloat(i+1,3); // vertical -180 ~ 180 (x) ㄱㅏㄹㅗ
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
}
class Particle {

  // Toxiblins Attraction2D example!
  int NUM_PARTICLES = 10;
  int d = 30; // diameter of particles
  
  int glassWidth = 200;
  int glassHeight = 300;
  float glassX = width/3;
  float glassY = 300;
  int quality;

  VerletPhysics2D physics;
  AttractionBehavior mouseAttractor;

  Vec2D mousePos;
  PImage img;
  Simbol mysimbol;

  Particle() {
    
    physics = new VerletPhysics2D();
    physics.setDrag(0.05f); //0.05f
    physics.setWorldBounds(new Rect(glassX, glassY, glassWidth, glassHeight)); //new Rect(0, 0, width, height)
    physics.addBehavior(new GravityBehavior(new Vec2D(0, 0.15f))); //Vec2D(0, 0.15f)
    
    mysimbol = new Simbol();
  }

  void display(PImage img_, int quality_) {
    img = img_;
    quality = quality_;
    
    NUM_PARTICLES = (int) map(quality, 0, 100, 20, 0);
   
    drawGlass();

    noStroke();
    fill(255);
    if (physics.particles.size() < NUM_PARTICLES) {
      addParticle();
    }
    physics.update();
    
    for(int i = 0; i<physics.particles.size(); i++) {
      VerletParticle2D p = physics.particles.get(i);
    }
    
    for (VerletParticle2D p : physics.particles) {
      imageMode(CENTER);
      tint(255, 255, 0);
      image(img, p.x, p.y, d, d);
    }
    noTint();
  }

  void addParticle() {
    
    float position = random(glassX, glassX + glassWidth);
    VerletParticle2D p = new VerletParticle2D(Vec2D.randomVector().scale(5).addSelf(position, glassY));
    physics.addParticle(p);
    // add a negative attraction force field around the new particle 
    physics.addBehavior(new AttractionBehavior(p, 50, -4f, 0.2f)); // (attractor, radius, strength, jitter), (p, 20, -1.2f, 0.01f)
  }

  void removeParticle() {

    for(int i = physics.particles.size()-1; i >= 0 ; i--) {
      //      print("Deleting Particle number ");
      //      println(i);      
      ParticleBehavior2D b = physics.behaviors.get(i+1); // i -> gravity, i+1 -> attraction
      physics.removeBehavior(b);

      VerletParticle2D p = physics.particles.get(i);
      physics.removeParticle(p);
    }
  }

  void drawGlass() {
    
    int w = 5;
    float xl = glassX-d;
    float xr = glassX+glassWidth+d;
    float yu = glassY;
    float yd = glassY+glassHeight+d;
    
    // glass
    noFill();
    stroke(255, 70);
    strokeWeight(w);
    ellipseMode(CORNER);
    ellipse(xl, yu-d/2, glassWidth+2*d, 30);// upper
    //ellipse(glassX-d, glassY+glassHeight+d/2, glassWidth+2*d, 30); // bottom
    
    line(xl, yu, xl, yd); // left
    line(xr, yu, xr, yd); // right
    line(xl, yd, xr, yd); // bottom
    
    // water
    rectMode(CORNER);
    noStroke();
    //fill(0, 255,255,130); // blue - clean water
    
    float yg = yu+100;
    rect(xl + w/2+1, yg, glassWidth+2*d - w, yd-yg-w/2);
  }
}

class Simbol {
  
  float w = 1;
  float x, y;
  
  Simbol() {
    x = 0;
    y = 0;
  }
  
  void displayWaterdrop(float x, float y) { // x, y, width of glass
    
    ellipseMode(CENTER);
    pushMatrix();
    
    translate(x, y);
    fill(252, 128, 165); // pink
    noStroke();
    
    triangle(0, 0, -20, 50, 20, 50);
    arc(0, 50, 40, 40, 0, PI, OPEN);    
    popMatrix();
  }
  
  void displayWaterdrop(float x_, float y_, float w_) { // x, y, width of glass
    
    x = x_;
    y = y_;
    w = w_;
    
    ellipseMode(CENTER);
    pushMatrix();
    
    translate(x, y);
//    fill(252, 128, 165); // pink
//    fill(239, 48, 36); // red
    fill(0, 255, 255, 200); // blue
    noStroke();
    
    triangle(0, 0, -20*w, 50*w, 20*w, 50*w);
    arc(0, 50*w, 40*w, 40*w, 0, PI, OPEN);    
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

