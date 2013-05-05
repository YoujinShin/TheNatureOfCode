import toxi.geom.*;
import toxi.physics2d.*;
import toxi.physics2d.behaviors.*;

// loadTable_click2
PImage img;
Water mywater;
Box mybox;

float[] X; // y (-90, 90) ㅅㅔㄹㅗ
float[] Y; // x (-180, 180) ㄱㅏㄹㅗ
int size = 17;

PFont font2;
float noff = 0;
boolean isPressed = false;
int boxW = 1100;
int boxH = 600;

void setup() {
  X = new float[size];
  Y = new float[size];
  noff = random(1000);

  size(700*2, 400*2);  // (700, 400)
  mywater = new Water();
  mybox = new Box();
  mywater.initialize();

  img = loadImage("map1.jpg"); // 10 * 6.25
  initialize();
  font2 = loadFont("LucidaSans-TypewriterBold-22.vlw");
  textFont(font2, 22);
}

void draw() {
  background(0);
  img.resize(width, height);
  image(img, 10, 0);

  mywater.locDisplay();  
  if (isPressed == false) {
    hover();
  } 
  else {
    showBox();
  }
  fill(0);
  rectMode(CENTER);
  rect(width/2, 20, width, 40);
}

void mouseClicked() {
  // show box
  for (int i = 0; i < size; i++) {  
    float distance = dist(X[i], Y[i], mouseX, mouseY); 
    if (distance < 10) {
      isPressed = true;
    } 
  }
  // reset to initial condition
  if((mouseX<width/2-boxW/2)||(mouseX>width/2+boxW/2)||(mouseY<height/2-boxH/2)||(mouseY>height/2+boxH/2)) {
    isPressed = false;
    mybox.removeParticle();
  }
}

void showBox() { 
  fill(0, 210);
  rectMode(CENTER);
  rect(width/2, height/2, 1100, 600);
  mybox.display();
}


void initialize() {
  for (int i = 0; i < size; i++) {
    //println(mywater.lat[i]);
    float y = map(mywater.lat[i], -90, 90, height, height*65/400);// ㅅㅔㄹㅗ
    float x = map(mywater.lon[i], -180, 180, width*(10/700), width*660/700); // ㄱㅏㄹㅗ
    X[i] = x;
    Y[i] = y;
  }
}

void hover() {
  for (int i = 0; i < size; i++) {  
    float distance = dist(X[i], Y[i], mouseX, mouseY); 
    if (distance < 10) {
      float d = map(noise(noff), 0, 1, 30, 80);
      fill(0, 255, 255, d*4);
      ellipse(X[i], Y[i], d, d);
      fill(255);
      text(mywater.nation[i], mouseX + 20, mouseY - 10);
    }
    noff= noff+0.01;
  }
}


