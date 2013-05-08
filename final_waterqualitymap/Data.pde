class Data {
  
  Table table;
  PImage texture;
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
    
    button = new float[3][2]; 
    noff = random(1000);
    
    myparticle = new Particle();
    water = new Simbol();
    mypeople = new People();
  }
  
  void locDisplay(PImage texture_) {
    
    textFont(myfont);
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
      // original
//      Y[i] = map(lat[i], -90, 90, height,height*65/400);// ㅅㅔㄹㅗ
//      X[i] = map(lon[i], -180, 180, width*(10/700), width*660/700); // ㄱㅏㄹㅗ
      
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

//    showName();
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
    } else if(checkNameHover()) {
      if(mousePressed) {
        state = 0; // 0: initial, 1: tap water, 2: bottle
      }
    }
    
    showName();
  }
  
  ///////////////////////////////////////////////////////////////////////////////////////
  
  void hover() {
  
    for (int i = 0; i < size; i++) {   
  
      ellipseMode(CENTER);
      noStroke();
      float distance = dist(X[i], Y[i], mouseX, mouseY); 
  
      if (distance < 30 && clicked[i] == 0) {
  
        float d = map(noise(noff), 0, 1, 60, 120);
        fill(0, 255, 255, 120);  
        ellipse(X[i], Y[i], d, d);
      }
      noff= noff+0.01;
    }
    noFill();
  }

  void showTapwater() {
    
    myparticle.display(texture, improvedWater[selectI], DiarD[selectI], state, population[selectI], incomeperday[selectI]);
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
  
}
