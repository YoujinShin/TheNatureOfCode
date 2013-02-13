
//Nature of Code week1 assignment

//Walker w;
Walker[] w;

void setup() {
  size(600, 600);
  frameRate(30);
  
  w = new Walker[4];
  //w = new Walker();
  for(int i = 0; i < w.length; i++) {
    w[i] = new Walker();
  }
}

void draw() {
 // background(240, 255, 255);
  background(244, 255, 255);
  
//  w.walk();
//  w.display();
  for (int i = 0; i < w.length; i++) {
    w[i].walk();
    w[i].display();
  }
}
