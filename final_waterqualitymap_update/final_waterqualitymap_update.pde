import java.util.Iterator; 
//import processing.op engl.*;

import toxi.geom.*;
import toxi.math.*;
import toxi.physics2d.*;
import toxi.physics2d.behaviors.*;

PImage img;
PImage coin;
PImage texture;
Data mydata;
Simbol water;

float[] X; // y (-90, 90) ㅅㅔㄹㅗ
float[] Y; // x (-180, 180) ㄱㅏㄹㅗ
int size = 13;

PFont myfont;
PFont myfont2;
PFont mynumber;
boolean isPressed = false;
boolean isStart = false;
boolean isStat = false;
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
  myfont2 = loadFont("HelveticaNeue-CondensedBold-22.vlw");
  mynumber = createFont("DS-Digital", 32);
  textFont(myfont);

  img = loadImage("map1.jpg"); // 10 * 6.25
  texture = loadImage("texture.png");
//  coin = loadImage("dollar_coin.jpg");
  coin = loadImage("dollar_coin2.png");
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
  rect(0, 0, width, 65);//40
  //  rect(0,0,0, height) ;

  if (mydata.isFinish ==false) {

    operation();
  } 
  else {

    finish();
  }
}

////////////////////////////////////////////////////////////////////////////////////

void operation() {

  if (isStart) {

    if (isPressed == false) { 
      
      if(isStat == false) {
        
        mydata.locDisplay(texture, coin);
        mydata.dataDisplay(texture);
        mydata.hover();
        title();
      } else {
        
        title();
        mydata.showButton2();
        
        if(mydata.state == 4) {
          
          mydata.statWater();
          textAlign(LEFT, BOTTOM);
          textSize(34);
          fill(180);
          text(">>    ACCESS TO CLEAN WATER", 450, 65);
        } else if(mydata.state == 5) {
          
          mydata.statCD();
          textAlign(LEFT, BOTTOM);
          textSize(34);
          fill(180);
          text(">>    NO. OF CHILD DEATH", 450, 65);
        } else if(mydata.state == 6) {
          
          mydata.statIncome(); 
          textAlign(LEFT, BOTTOM);
          textSize(34);
          fill(180);
          text(">>    INDIVIDUAL INCOME PER DAY", 450, 65);
        }
        
      }
      
//      title();
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
        if (distance < 30) {
          
          isPressed = true;
          mydata.clicked[i] = 1;
          selectI = i;
          mydata.state = 0;
        } else if (dist(mydata.button[3][0], mydata.button[3][1], mouseX, mouseY) < 150*0.55/2) {
          
          isStat = true;
          mydata.state = 4;
        } else if (dist(mydata.button[4][0], mydata.button[4][1], mouseX, mouseY) < 150*0.55/2) {
          
          isStat = true;
          mydata.state = 5;
        } else if (dist(mydata.button[5][0], mydata.button[5][1], mouseX, mouseY) < 150*0.55/2) {
          
          isStat = true;
          mydata.state = 6;
        } else {
      
          isStat = false;
        }
      } 
    } 


    // reset to initial condition
    if (dist(mydata.button[2][0], mydata.button[2][1], mouseX, mouseY) < 150*0.4/2) {
      isPressed = false;
      mydata.resetTapwater();
//      mydata.myparticle.removesSpr();
      mydata.myparticle.removeIncome();
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
  textSize(70);
  textAlign(CENTER, CENTER);
  text("T H A N K S", width/2, height/2+50);
  
  textSize(28);
  fill(220);
  text("FOR YOUR JOURNEY WITH US", width/2, height/2+120);
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
  rect(0, 0, width, 59);
  stroke(150);
  strokeWeight(1);
  line(20, 65, width-20, 65);

  textAlign(LEFT, BOTTOM);
  textSize(34);
  fill(255);
  text("WATER QUALITY OF THE WORLD 2008", 50, 65);

  // reference 
  fill(180);
  textSize(22);
  text("© WHO - UNICEF - IMF 2008", width - 300, height-65);  // reference
  
  noStroke();
  noFill();
}

void mousePressed() {
 mydata.myparticle.startAttract();
 mydata.myparticle.incomestartAttract();
}

void mouseDragged() {
  // update mouse attraction focal point
 mydata.myparticle.updateAttract();
 mydata.myparticle.incomeupdateAttract();
}

void mouseReleased() {
  // remove the mouse attraction when button has been released
 mydata.myparticle.stopAttract();
 mydata.myparticle.incomestopAttract();
}

