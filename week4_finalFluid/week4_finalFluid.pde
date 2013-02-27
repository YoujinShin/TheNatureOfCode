FlowField myFlow;
ArrayList<Vehicle> vehicles;
PImage img;
//Vehicle myVehicle;

void setup() {
  size(600, 400, P2D);
  
  img = loadImage("texture.png");
  smooth();
  
  myFlow = new FlowField(30);
  vehicles = new ArrayList<Vehicle>();
  //myVehicle = new Vehicle(width, height/2);
  
//  for(int i = 0; i < 200; i++) { // number of vehicles
//    vehicles.add(new Vehicle(random(width, width+100), random(height), img));
//  }
}

void draw() {
  background(0);
  fill(255);
  text("click to change movement",10,height-5);
  blendMode(ADD);
  
  vehicles.add(new Vehicle(random(width, width+100), random(height), img));
  //myFlow.display();
  
  for(int i = 0; i < vehicles.size(); i++) {
    Vehicle v = vehicles.get(i);
    v.follow(myFlow);
    v.update();
    v.display();
    if (v.isDead()) {
      vehicles.remove(i);
    }
  }
}

// make a new flowfield
void mousePressed() {
  myFlow.init();
  imageMode(CENTER);
  tint(0, 153, 204);  // Tint blue and set transparency
  image(img, mouseX, mouseY, 300, 300);
}
