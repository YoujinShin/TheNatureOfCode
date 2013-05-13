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
    buttonHover();
    
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
  
    void displayIncomeButton(float x_, float y_, float w_) { // x, y, width of glass
    
    x = x_;
    y = y_;
    w = w_;
    
    pushMatrix();
    translate(x, y);
    
    // background circle
    fill(200, 100); //230
    buttonHover();
    
    stroke(255, 120);
    strokeWeight(w*6);
    ellipseMode(CENTER);
    ellipse(0, 0,150*w, 150*w);
    
    // text
    fill(255, 180);
    
    int t = int(w*37/0.4);
    textSize(t);
    textAlign(CENTER,CENTER);
    text("$", 0, 0); 
    
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
    buttonHover();
    stroke(255, 120);
    strokeWeight(w*6);
    ellipseMode(CENTER);
    ellipse(0, 0,150*w, 150*w);
    
    // text
    fill(255, 150);
    
    textSize(35);
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
    buttonHover();
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
  
    void buttonHover() {
    
    float distance = dist(mouseX, mouseY, x, y);
    if(distance < 150*w/2) { //150*w/2
      
      fill(255, 150);
    } else {
      fill(200, 100); 
    }
  }
}
