
class Tile {
  int collumn;
  int row;
  
  Node node = null;
  
  TileType tileType;
  
  int pathValue ;
  
  Tile(int collumn, int row) {
    this.collumn = collumn;
    this.row = row;
    
    if(collumn == 0 ||
       row == 0 ||
       collumn == COLLUMN_NUM-1 ||
       row == ROW_NUM - 1) {
         tileType = tileType.WALL;
       } else {
         tileType = tileType.PATH;
       }
  }
  
  Square findSquare() {
    return mUI.mGrid.squareMatrix[collumn][row];
  }
  
  void onClicked() {
    print("Collumn: " + collumn + ", Row: " + row + " clicked, Path Value: " + pathValue+ " \n");
    
    switch(mAPI.state) {
      case SELECT_START:
        if(tileType == TileType.WALL)  {
          mAPI.start = this;
          mAPI.state = State.SELECT_END;
          tileType = TileType.START;
        }
        break;
      case SELECT_END:
        if(tileType == TileType.WALL)  {
            mAPI.end = this;
            mAPI.state = State.DRAW_MAP;
            tileType = TileType.END;
          }
        break;
      case DRAW_MAP:
        if(tileType == TileType.PATH) {
          tileType = TileType.WALL;
        }
        break;
      default:
        break;
    }
  }
  
  boolean isNode() {
    boolean isUpPath;
    boolean isDownPath;
    boolean isLeftPath;
    boolean isRightPath;
    
    if(node == null) {
      // is it the start or end?
      if(tileType == TileType.START || tileType == TileType.END) {
        return true;
        // is it a wall and/or at the edge
      } else if(tileType == TileType.WALL) {
        return false;
      } else {
        // find if all the directions are walls or not
        isUpPath = (mAPI.tileMatrix[collumn][row-1].tileType == TileType.PATH) || (mAPI.tileMatrix[collumn][row-1].tileType == TileType.END) || (mAPI.tileMatrix[collumn][row-1].tileType == TileType.START);
        isDownPath = (mAPI.tileMatrix[collumn][row+1].tileType == TileType.PATH) || (mAPI.tileMatrix[collumn][row+1].tileType == TileType.END) || (mAPI.tileMatrix[collumn][row+1].tileType == TileType.START);
        isLeftPath = (mAPI.tileMatrix[collumn-1][row].tileType == TileType.PATH) || (mAPI.tileMatrix[collumn-1][row].tileType == TileType.END) || (mAPI.tileMatrix[collumn-1][row].tileType == TileType.START);
        isRightPath = (mAPI.tileMatrix[collumn+1][row].tileType == TileType.PATH) || (mAPI.tileMatrix[collumn+1][row].tileType == TileType.END) || (mAPI.tileMatrix[collumn+1][row].tileType == TileType.START);
        //Up & Down only
        if(isUpPath && isDownPath && !isLeftPath && !isRightPath) {
          return false;
          //Left & Right only
        } else if(isLeftPath && isRightPath && !isUpPath && !isDownPath) {
          return false;
        } else {
          return true;
        }
      }
    } else {
      return false;
    }
  }
  
}
