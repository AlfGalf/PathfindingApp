class Grid {
  
  Square[][] squareMatrix;
  
  Grid() {
    squareMatrix = new Square[COLLUMN_NUM][ROW_NUM];
    for(int i = 0; i < COLLUMN_NUM; i++) {
      for(int j = 0; j < ROW_NUM; j++) {
        squareMatrix[i][j] = new Square(i, j);
      }
    }
  }
  
  void draw() {
    for(int i = 0; i < COLLUMN_NUM; i++) {
      for(int j = 0; j < ROW_NUM; j++) {
        squareMatrix[i][j].draw();
      }
    }
  }
  
  Square getSquare(int collumn, int row) {
    return squareMatrix[collumn][row];
  }
}
