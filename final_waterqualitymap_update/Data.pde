class Data {
  
  Table table;
  PImage texture;
  PImage coin;
  String[] nation;
  int[] improvedWater;
  int[] population;
  int[] incomeperday; // per person per day in 2008 // gapminder
  int[] lifeExpectancy;
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
    incomeperday = new int[size];
    population = new int[size];
    lifeExpectancy = new int[size];
    
    button = new float[6][2]; 
    noff = random(1000);
    
    myparticle = new Particle();
    water = new Simbol();
    mypeople = new People();
  }
  
  void locDisplay(PImage texture_, PImage coin_) {
    
    textFont(myfont);
    texture = texture_;
    coin = coin_;
    noStroke();
    fill(255, 140);

    for(int i = 0; i < size; i++) {   

      imageMode(CENTER);

//      if(clicked[i] == 0) {
        
        tint(255);
        image(texture, X[i], Y[i], 15, 15); 
//      } else {
//        
//        tint(100);
//        image(texture, X[i], Y[i], 15, 15);  
//      }  
      noTint();  
    }
    showButton2();
    
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
      
//      if(clicked[i] == 0) {
        stroke(255, 100);
//      } else {
//        stroke(100, 100);
//      }
      
      ellipse(X[i], Y[i], 50, 50);
//      ellipse(X[i], Y[i], r/3, r/3);
      noff= noff+0.005;
      noStroke();
    }
//    checkClicked();
  }
  
  void initialize() {
    
    for(int i = 0; i < size; i++) {
      
      nation[i] = table.getString(i+1,0);
      improvedWater[i] = round(table.getFloat(i+1,1)); // 0 ~ 100
      lat[i] = table.getFloat(i+1,2); // horizontal -90 ~ 90 (y) ㅅㅔㄹㅗ
      lon[i] = table.getFloat(i+1,3); // vertical -180 ~ 180 (x) ㄱㅏㄹㅗ
      DiarD[i] = round(table.getFloat(i+1,4));
      population[i] = table.getInt(i+1,6);
      lifeExpectancy[i] = round(table.getFloat(i+1, 9));
      incomeperday[i] = round(table.getFloat(i+1,10));
      clicked[i] = 0;
      //println("nation: "+nation[i]+", water: "+improvedWater[i]+", lat: "+lat[i]+", lon: "+lon[i]);
    }
    
    for(int i = 0; i < size; i++) {
      
      Y[i] = map(lat[i], -90, 90, height,height*65/400);// ㅅㅔㄹㅗ
      X[i] = map(lon[i], -180, 180, width*(10/700), width*653/700); // ㄱㅏㄹㅗ
    }
  }
  
  void checkClicked() {
    
    int sum = 0;
    for(int i = 0; i < size; i++) {
      sum = sum + clicked[i];
    }
    
    if (sum == size) {
//      isFinish = true;
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

    showButton();
    showTapwater();
    
    if(dist(button[0][0], button[0][1], mouseX, mouseY) < 150*0.4/2) {
      if(mousePressed) {
        state = 1; // 0: initial, 1: tap water, 2: bottle
      }
    } else if(dist(button[1][0], button[1][1], mouseX, mouseY) < 150*0.4/2) {
      if(mousePressed) {
        state = 2; // 0: initial, 1: tap water, 2: bottle
      }
    } else if(checkNameHover()) {
      if(mousePressed) {
        state = 0; // 0: initial, 1: tap water, 2: bottle
      }
    } 
//    else if(dist(button[3][0], button[3][1], mouseX, mouseY) < 150*0.4/2) {
//      if(mousePressed) {
//        state = 4; // 0: initial, 1: tap water, 2: bottle
//      }
//    } else if(dist(button[4][0], button[4][1], mouseX, mouseY) < 150*0.4/2) {
//      if(mousePressed) {
//        state = 5; // 0: initial, 1: tap water, 2: bottle
//      }
//    } else if(dist(button[5][0], button[5][1], mouseX, mouseY) < 150*0.4/2) {
//      if(mousePressed) {
//        state = 6; // 0: initial, 1: tap water, 2: bottle
//      }
//    }
    
    showName();
  }
  
  ///////////////////////////////////////////////////////////////////////////////////////
  
  void hover() {
  
    for (int i = 0; i < size; i++) {   
  
      ellipseMode(CENTER);     
      float distance = dist(X[i], Y[i], mouseX, mouseY); 
      if (distance < 30 && clicked[i] == 0) {
        
        float d = map(noise(noff), 0, 1, 60, 120);
        fill(0, 255, 255, 120); //120 
        noStroke();
        ellipse(X[i], Y[i], d, d);
      }
      
      noff= noff+0.01;
    }
    noFill();
  }

  void showTapwater() {
    
    myparticle.display(texture, coin, improvedWater[selectI], DiarD[selectI], state, population[selectI], incomeperday[selectI]);
  }
  
  void resetTapwater() {
    
    myparticle.removeParticle();
  }
  
  void showName() {
    
    textFont(myfont);
    rectMode(CORNER);
    fill(200, 100); //230
    nameHover();
    noStroke();
    rect((width-1100)/2 + 20, 150 - 20, 1100 - 40, 50);
    
    textAlign(LEFT, BOTTOM);
    fill(0); 
    textSize(42);
    text(nation[selectI],width/6 - width/150, 200 - 20); // nation name
  }
  
  void nameHover() {
    
    float xl = (width-1100)/2 + 20;
    float xr = (width-1100)/2 + 20 + 1100 - 40;
    float yu = 150 - 20;
    float yd = 150 - 20 + 50;
    
    if(mouseX> xl && mouseX < xr){
      if(mouseY>yu && mouseY <yd) {
        fill(255, 150);
      }
    }
  }
  
  boolean checkNameHover() {
    
    boolean temp = false;
    
    float xl = (width-1100)/2 + 20;
    float xr = (width-1100)/2 + 20 + 1100 - 40;
    float yu = 150 - 20;
    float yd = 150 - 20 + 50;
    
    if(mouseX> xl && mouseX < xr){
      if(mouseY>yu && mouseY <yd) {
        fill(255, 150);
        
        temp = true;
      }
    }
    
    return temp;
  }
  
  void showButton() {
    
    int t = -100;
//    water.displayWaterButton(width/2 + 1100/2 + 35, height/2-80 - t, 0.4);
    water.displayIncomeButton(width/2 + 1100/2 + 35, height/2-80 - t, 0.4);
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
  
  void showButton2() {
    
    water.displayWaterButton(width*0.07, height*0.5, 0.55);
    water.displayBottleButton(width*0.07, height*0.65, 0.55);
    water.displayIncomeButton(width*0.07, height*0.8, 0.55);
    
    // button 4 position
    button[3][0] = width*0.07;
    button[3][1] = height*0.5;
    
    // button 5 position
    button[4][0] = width*0.07;
    button[4][1] = height*0.65;
    
    // button 6 position
    button[5][0] = width*0.07;
    button[5][1] = height*0.8;
  }
  
  void statWater() {
    
    ellipseMode(CENTER);
    
    for (int i = 0; i < size; i++) {  

      int r = improvedWater[i]; //100

      noStroke();
      fill(0, 255, 255, 180); 
      ellipse(X[i], Y[i], r, r);
      
      textAlign(CENTER, CENTER);
      textSize(32);
      fill(210);
      text(improvedWater[i]+" %", X[i], Y[i]);
    }
  }
  
  void statCD() {
    
    ellipseMode(CENTER);
    
    for (int i = 0; i < size; i++) {  

      int r = DiarD[i]; //100

      noStroke();
      fill(255, 0, 0, 120); 
      ellipse(X[i], Y[i], r*3, r*3);
      
      textAlign(CENTER, CENTER);
      textSize(32);
      fill(210);
      text(DiarD[i], X[i], Y[i]);
    }
  }
  
  void statIncome() {
    
    ellipseMode(CENTER);
    
    for (int i = 0; i < size; i++) {  

      int r = incomeperday[i]; //100

      noStroke();
      fill(255, 255, 0, 200); 
      ellipse(X[i], Y[i], r*1.8, r*1.8);
//      imageMode(CENTER);
//      image(coin,X[i], Y[i], r*1.8, r*1.8); 
      
      textAlign(CENTER, CENTER);
      textSize(28);
      if(r < 10) {
        fill(240);
      } else {
        fill(0);
      }
      text("$"+incomeperday[i], X[i], Y[i]);
    }
  }
}
