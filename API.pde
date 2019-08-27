
class API {
  State state;

  Tile[][] tileMatrix;
  
  Tile start;
  Tile end;
  
  int pathLength = 8;
  
  ArrayList<Node> nodes = new ArrayList<Node>();
  
  ArrayList<Edge> route = new ArrayList<edges>();
  
  API() {
    state = State.SELECT_START;
    
    tileMatrix = new Tile[COLLUMN_NUM][ROW_NUM];
    
    for(int i =0; i < COLLUMN_NUM; i++) {
      for(int j =0; j < ROW_NUM; j++) {
        tileMatrix[i][j] = new Tile(i, j);
      }
    }
  }
  
  void mousePressed() {
    tileMatrix[mouseX/( width/COLLUMN_NUM)][mouseY/( height/ROW_NUM)].onClicked();
  }
  
  void keyPressed() {
    if(key == 'd' || key == 'D') {
      if(state == State.DRAW_MAP) {
        findNodesAndEdges();
        state = State.ALGORITHM;
        
      }
    }
  }
  
  void findNodesAndEdges() {
    print("find nodes and edges \n");
    ArrayList<Node> listOfNodes = new ArrayList<Node>();
    
    for(int i = 0; i < COLLUMN_NUM; i++) {
      for(int j = 0; j< ROW_NUM; j++) {
        if(tileMatrix[i][j].isNode()) {
          Node newNode = new Node(i, j);
          tileMatrix[i][j].node = newNode;
          nodes.add(newNode);
          listOfNodes.add(newNode);
        }
      }
    }
    
    Node currentNode;
    while(listOfNodes.size() > 0) {
      currentNode = listOfNodes.get(0);
      
      //UP
      int newCol = currentNode.collumn;
      int newRow = currentNode.row;
      boolean going = true;
      if(newRow > 0){
        if(tileMatrix[newCol][newRow-1].tileType != TileType.WALL) {
          print("UP From: (" + currentNode.collumn + "," + currentNode.row + ")\n");
          newRow = newRow-1;
          going = true;
          while(going){
            if(tileMatrix[newCol][newRow].tileType != TileType.START &&
               tileMatrix[newCol][newRow].tileType != TileType.END){
                 if(tileMatrix[newCol][newRow-1].tileType != TileType.WALL) {
                   newRow = newRow - 1;
                 } else {going = false;}
               } else {going = false;}
          }
          currentNode.addEdge(currentNode, tileMatrix[newCol][newRow].node);
        }
      }
        
      //DOWN
      newCol = currentNode.collumn;
      newRow = currentNode.row;
      if(newRow < ROW_NUM-1) {
        if(tileMatrix[newCol][newRow + 1].tileType != TileType.WALL) {
          print("Down From: (" + currentNode.collumn + "," + currentNode.row + ")\n");
          newRow = newRow+1;
          going = true;
          while(going){
            if(tileMatrix[newCol][newRow].tileType != TileType.START &&
               tileMatrix[newCol][newRow].tileType != TileType.END){
                 if(tileMatrix[newCol][newRow+1].tileType != TileType.WALL) {
                   newRow = newRow + 1;
                 } else {going = false;}
               } else {going = false;}
          }
          currentNode.addEdge(currentNode, tileMatrix[newCol][newRow].node);
        }
      }
      
      //LEFT
      newCol = currentNode.collumn;
      newRow = currentNode.row;
      if(newCol > 0) {
        if(tileMatrix[newCol - 1][newRow].tileType != TileType.WALL) {
          print("Left From: (" + currentNode.collumn + "," + currentNode.row + ")\n");
          newCol = newCol-1;
          going = true;
          while(going){
            if(tileMatrix[newCol][newRow].tileType != TileType.START &&
               tileMatrix[newCol][newRow].tileType != TileType.END){
                 if(tileMatrix[newCol-1][newRow].tileType != TileType.WALL) {
                   newCol = newCol - 1;
                 } else {going = false;}
               } else {going = false;}
          }
          currentNode.addEdge(currentNode, tileMatrix[newCol][newRow].node);
        }
      }
      
      //RIGHT
      newCol = currentNode.collumn;
      newRow = currentNode.row;
      if(newCol < COLLUMN_NUM-1){
        if(tileMatrix[newCol + 1][newRow].tileType != TileType.WALL) {
          print("Right From: (" + currentNode.collumn + "," + currentNode.row + ")\n");
          if(newCol < COLLUMN_NUM-1){
            going = true;
            while(going){
              if(tileMatrix[newCol][newRow].tileType != TileType.START &&
                 tileMatrix[newCol][newRow].tileType != TileType.END){
                   if(tileMatrix[newCol + 1][newRow].tileType != TileType.WALL) {
                     newCol = newCol + 1;
                   } else {going = false;}
                 } else {going = false;}
            }
            currentNode.addEdge(currentNode, tileMatrix[newCol][newRow].node);
          }
        }
      }
      
      listOfNodes.remove(0);
    }
  }
  
  void drawNodes() {
    for(int i =0; i < nodes.size(); i++) {
      nodes.get(i).draw();
    }
  }
  
  void dijkstra() {
    boolean finished = false;
    
    // Stack to keep current nodes on
    ArrayList<Node> nodeStack = new ArrayList<Node>();
    
    // List of visited nodes
    ArrayList<Node> visitedNodes = new ArrayList<Node>();
    
    // Add first node
    nodeStack.add(start.node);
    
    Node current;
    
    while !finished {
      if(nodeStack.size() = 0) { // Node stack is empty, either path is impossible or something has gone very wrong
        throw new Exception("nodeStack is empty, path impossible");
        break;
      
      current = findShortest(nodeStack); // Find shortest node
      if(current == end.node) { // If reached end break from loop
        finished = true;
        makeRoute();
        break;
      }
      
      nodeStack.remove(current);
      visitedNodes.add(current);
      
      for(int i = 0; i < current.edges.size(); i++) { // Go through edges on shortest node
        if visitedNodes.contains(current.edges.get(i).endNode) { // Already visited node
          if(current.dijPathLength + current.edges.get(i).lengthOfEdge < current.edges.get(i).endNode.dijPathLength) { // new path length is shorter than old length
            current.edges.get(i).endNode.dijPathLength = current.dijPathLength + current.edges.get(i).lengthOfEdge;
            current.edges.get(i).endNode.dijVia = current.edges.get(i);
          }
        } else { // Haven't visited node
          nodeStack.add(current.edges.get(i).endNode);
          current.edges.get(i).endNode.dijPathLength = current.dijPathLength + current.edges.get(i).lengthOfEdge;
          current.edges.get(i).endNode.dijVia = current.edges.get(i);
        }
      }
    }
    
    // Find shortest node in a stack
    Node findShortest(ArrayList<Node> nodeStack) {
      if(nodeStack.size() > 0){
        Node shortest = nodeStack.get(0);
        
        for(int i = 0; i < nodeStack.size(); i++) {
          if(nodeStack.get(i).dijPathLength < shortest.dijPathLength) {
            shortest = nodeStack.get(i);
          }
        }
      } else { // Given a array of length 0 (should never happen)
        throw new Exception("'findShortest()' passed array of length 0");
      }
    }
    
    void makeRoute() {
       m
    }
  }
}
