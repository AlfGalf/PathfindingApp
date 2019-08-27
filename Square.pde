
class Square {
  
  final float BUFFER = 0.5f;
  final int ROUNDING = 2;
  final int SQUARE_STROKE = 4;
  
  int collumn;
  int row;
  
  int[] colorRGB = new int[3];
  
  Square(int collumn, int row) {
    this.collumn = collumn;
    this.row = row;
    
    colorRGB[0] = 255;
    colorRGB[1] = 255;
    colorRGB[2] = 255;
    
  }
  
  void draw() {
    colorRGB = getColor();
    stroke(SQUARE_STROKE);
    fill(colorRGB[0], colorRGB[1], colorRGB[2]);
    rect(((width-BUFFER)/COLLUMN_NUM * collumn) + BUFFER, 
        ((height-BUFFER)/ROW_NUM * row) + BUFFER, 
        ((width-BUFFER)/COLLUMN_NUM) - 2 * BUFFER, 
        ((height-BUFFER)/ROW_NUM) - 2 * BUFFER,
        ROUNDING);
  }
  
  int[] getColor() {
    int[] toReturn = new int[3];
    switch(mAPI.state) {
      case SELECT_START:
        switch(findTile().tileType){
          case WALL:
            toReturn[0] = 150; toReturn[1] = 20; toReturn[2] = 150;
            break;
          case PATH:
            toReturn[0] = 255; toReturn[1] = 255; toReturn[2] = 255;
            break;
          default:
            toReturn[0] = 255; toReturn[1] = 255; toReturn[2] = 0;
            break;
        }
        break;
      case SELECT_END:
        switch(findTile().tileType){
          case WALL:
            toReturn[0] = 150; toReturn[1] = 20; toReturn[2] = 150;
            break;
          case PATH:
            toReturn[0] = 255; toReturn[1] = 255; toReturn[2] = 255;
            break;
          case START:
            toReturn[0] = 100; toReturn[1] = 255; toReturn[2] = 100;
            break;
          default:
            toReturn[0] = 255; toReturn[1] = 255; toReturn[2] = 0;
            break;
        }
      break;
      case DRAW_MAP:
        switch(findTile().tileType){
          case WALL:
            toReturn[0] = 40; toReturn[1] = 40; toReturn[2] = 40;
            break;
          case PATH:
            toReturn[0] = 200; toReturn[1] = 255; toReturn[2] = 200;
            break;
          case START:
            toReturn[0] = 100; toReturn[1] = 255; toReturn[2] = 100;
            break;
          case END:
            toReturn[0] = 255; toReturn[1] = 100; toReturn[2] = 100;
            break;
          default:
            toReturn[0] = 255; toReturn[1] = 255; toReturn[2] = 0;
            break;
        }
      break;
      case ALGORITHM:
        switch(findTile().tileType){
          case WALL:
            toReturn[0] = 40; toReturn[1] = 40; toReturn[2] = 40;
            break;
          case PATH:
            int value = (int) ((findTile().pathValue) * (255/mAPI.pathLength));
            toReturn[0] = (int) (value); toReturn[1] = 0; toReturn[2] = (int) (255 - value);
            break;
          case START:
            toReturn[0] = 100; toReturn[1] = 255; toReturn[2] = 100;
            break;
          case END:
            toReturn[0] = 255; toReturn[1] = 100; toReturn[2] = 100;
            break;
          default:
            toReturn[0] = 255; toReturn[1] = 255; toReturn[2] = 0;
            break;
        }
      break;
        
      default:
        toReturn[0] = 255; toReturn[1] = 0; toReturn[2] = 120;
      break;
    }
    return toReturn;
  }
  
  Tile findTile() {
    return mAPI.tileMatrix[collumn][row];
  }
}
