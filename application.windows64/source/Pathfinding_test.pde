API mAPI;
Handler mHandler;
UI mUI;

final int ROW_NUM = 20;
final int COLLUMN_NUM = 20;

void setup() {
  size(600, 600);
  background(255);
  
  mUI = new UI();
  mAPI = new API();
  mHandler = new Handler();
  
}

void mousePressed() {
  mAPI.mousePressed();
}

void mouseDragged() {
  mAPI.mousePressed();
}

void draw(){
  mUI.mGrid.draw();
  mAPI.drawNodes();
}

void keyPressed() {
  mAPI.keyPressed();
}
