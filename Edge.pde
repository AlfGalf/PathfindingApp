
class Edge {
  Tile startTile;
  Tile endTile;
  Node startNode;
  Node endNode;
  Tile[] tiles;
  
  int lengthOfEdge;
  
  String direction;
  
  Edge(Node startNode, Node endNode) {
    this.startNode = startNode;
    this.endNode = endNode;
    startTile = startNode.tile;
    endTile = endNode.tile;
    
    lengthOfEdge = Math.abs(startNode.collumn + startNode.row - endNode.collumn - endNode.row);
    
    tiles = new Tile[lengthOfEdge];
    
    print("LOE: " + lengthOfEdge + "\n");
    
    if(startNode.collumn < endNode.collumn) { 
      direction = "Right"; 
      for(int i = 0; i < lengthOfEdge; i++) {
        tiles[i] = mAPI.tileMatrix[startTile.collumn + i][startTile.row];
      }
    }
    else if(startNode.collumn > endNode.collumn) { 
      direction = "Left"; 
      for(int i = 0; i < lengthOfEdge; i++) {
        tiles[i] = mAPI.tileMatrix[startTile.collumn - i][startTile.row];
      }
    }
    else if(startNode.row < endNode.row) { 
      direction = "Down"; 
      for(int i = 0; i < lengthOfEdge; i++) {
        tiles[i] = mAPI.tileMatrix[startTile.collumn][startTile.row + i];
      }
    }
    else {
      direction = "Up";
      for(int i = 0; i < lengthOfEdge; i++) {
        tiles[i] = mAPI.tileMatrix[startTile.collumn][startTile.row - i];
      }
    }
  }
  
  void draw() {
    if(mAPI.debug) {
      stroke(255, 0, 0);
      line((width/COLLUMN_NUM) * (startTile.collumn + 0.5),
           (height/ROW_NUM) * (startTile.row + 0.5),
           (width/COLLUMN_NUM) * (endTile.collumn + 0.5),
           (height/ROW_NUM) * (endTile.row + 0.5));
    }
  }
  
  void setPathValues(int start) {
    //for(int i = 0; i < lengthOfEdge; i++) {
    //    tiles[i].pathValue = start + i;
    //  }
  }
}
