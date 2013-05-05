class Water {
  Table table;
  String[] nation;
  int[] improvedWater;
  float[] lat; // y (-90, 90) ㅅㅔㄹㅗ
  float[] lon; // x (-180, 180) ㄱㅏㄹㅗ
  int size = 17; // 175 for 2010, 18 for click
  
  Water() {
    table = loadTable("improved_click.csv");
    nation = new String[size];
    improvedWater = new int[size];
    lat = new float[size];
    lon = new float[size];
  }
  
  void locDisplay() {
    noStroke();
    fill(255, 140);
    for(int i = 0; i < size; i++) {   
      float y = map(lat[i], -90, 90, height,height*65/400);// ㅅㅔㄹㅗ
      float x = map(lon[i], -180, 180, width*(10/700), width*660/700); // ㄱㅏㄹㅗ
      float distance = dist(x, y, mouseX, mouseY);
      ellipse(x, y, 25, 25);     
    }
  }
  
  void initialize() {
    for(int i = 0; i < size; i++) {
      nation[i] = table.getString(i+1,0);
      improvedWater[i] = table.getInt(i+1,1); // 0 ~ 100
      lat[i] = table.getFloat(i+1,2); // horizontal -90 ~ 90 (y) ㅅㅔㄹㅗ
      lon[i] = table.getFloat(i+1,3); // vertical -180 ~ 180 (x) ㄱㅏㄹㅗ
      //println("nation: "+nation[i]+", water: "+improvedWater[i]+", lat: "+lat[i]+", lon: "+lon[i]);
    }
  }
}
