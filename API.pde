
class API {
  State state;

  Tile[][] tileMatrix;
  
  Tile start;
  Tile end;
  
  int pathLength = 20;
  
  ArrayList<Node> nodes = new ArrayList<Node>();
  
  ArrayList<Edge> route = new ArrayList<Edge>();
  
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
        dijkstra();
      }
    }
  }
  
  void findNodesAndEdges() {
    print("find nodes and edges \n");
    ArrayList<Node> listOfNodes = new ArrayList<Node>();
    ArrayList<Node> visitedNodes = new ArrayList<Node>();
    
    for(int i = 0; i < COLLUMN_NUM; i++) {
      for(int j = 0; j< ROW_NUM; j++) {
        if(tileMatrix[i][j].isNode()) {
          Node newNode = new Node(i, j);
          tileMatrix[i][j].node = newNode;
          nodes.add(newNode);
        }
      }
    }
    
    listOfNodes.add(start.node);
    
    Node currentNode;
    while(listOfNodes.size() > 0) {
      currentNode = listOfNodes.get(0);
      
      //UP
      int newCol = currentNode.collumn;
      int newRow = currentNode.row;
      boolean going = true;
      if(newRow > 0){
        if(tileMatrix[newCol][newRow-1].tileType != TileType.WALL) {
          print("UP From: (" + currentNode.collumn + "," + currentNode.row + ") ");
          newRow = newRow - 1;
          going = true;
          while(going){
            if(tileMatrix[newCol][newRow].node == null){
              if(tileMatrix[newCol][newRow].tileType != TileType.START &&
                 tileMatrix[newCol][newRow].tileType != TileType.END){
                   if(tileMatrix[newCol][newRow-1].tileType != TileType.WALL) {
                     newRow = newRow - 1;
                   } else {going = false;}
                 } else {going = false;}
            } else {going = false;}
          }
          print("TO: (" + newCol + "," + newRow + ")\n");
          if(!visitedNodes.contains(tileMatrix[newCol][newRow].node)){
            listOfNodes.add(tileMatrix[newCol][newRow].node);}
          currentNode.addEdge(currentNode, tileMatrix[newCol][newRow].node);
        }
      }
        
      //DOWN
      newCol = currentNode.collumn;
      newRow = currentNode.row;
      if(newRow < ROW_NUM-1) {
        if(tileMatrix[newCol][newRow + 1].tileType != TileType.WALL) {
          print("Down From: (" + currentNode.collumn + "," + currentNode.row + ")");
          newRow = newRow+1;
          going = true;
          while(going){
            if(tileMatrix[newCol][newRow].node == null){
              if(tileMatrix[newCol][newRow].tileType != TileType.START &&
                 tileMatrix[newCol][newRow].tileType != TileType.END){
                   if(tileMatrix[newCol][newRow+1].tileType != TileType.WALL) {
                     newRow = newRow + 1;
                   } else {going = false;}
                 } else {going = false;}
               } else {going = false;}
          }
          print("TO: (" + newCol + "," + newRow + ")\n");
          if(!visitedNodes.contains(tileMatrix[newCol][newRow].node)){
            listOfNodes.add(tileMatrix[newCol][newRow].node);}
          currentNode.addEdge(currentNode, tileMatrix[newCol][newRow].node);
        }
      }
      
      //LEFT
      newCol = currentNode.collumn;
      newRow = currentNode.row;
      if(newCol > 0) {
        if(tileMatrix[newCol - 1][newRow].tileType != TileType.WALL) {
          print("Left From: (" + currentNode.collumn + "," + currentNode.row + ") ");
          newCol = newCol-1;
          going = true;
          while(going){
            if(tileMatrix[newCol][newRow].node == null){
              if(tileMatrix[newCol][newRow].tileType != TileType.START &&
                 tileMatrix[newCol][newRow].tileType != TileType.END){
                   if(tileMatrix[newCol-1][newRow].tileType != TileType.WALL) {
                     newCol = newCol - 1;
                   } else {going = false;}
                 } else {going = false;}
              } else {going = false;}
          }
          if(!visitedNodes.contains(tileMatrix[newCol][newRow].node)){
            listOfNodes.add(tileMatrix[newCol][newRow].node);}
          currentNode.addEdge(currentNode, tileMatrix[newCol][newRow].node);
          print("TO: (" + newCol + "," + newRow + ")\n");
        }
      }
      
      //RIGHT
      newCol = currentNode.collumn;
      newRow = currentNode.row;
      if(newCol < COLLUMN_NUM-1) {
        if(tileMatrix[newCol + 1][newRow].tileType != TileType.WALL) {
          print("Right From: (" + currentNode.collumn + "," + currentNode.row + ") ");
          if(newCol < COLLUMN_NUM-1){
            newCol = newCol+1;
            going = true;
            while(going){
              if(tileMatrix[newCol][newRow].node == null){
                if(tileMatrix[newCol][newRow].tileType != TileType.START &&
                   tileMatrix[newCol][newRow].tileType != TileType.END){
                     if(tileMatrix[newCol + 1][newRow].tileType != TileType.WALL) {
                       newCol = newCol + 1;
                     } else {going = false;}
                   } else {going = false;}
              } else {going = false;}
            }
            currentNode.addEdge(currentNode, tileMatrix[newCol][newRow].node);
            if(!visitedNodes.contains(tileMatrix[newCol][newRow].node)){
              listOfNodes.add(tileMatrix[newCol][newRow].node);}
            print("TO: (" + newCol + "," + newRow + ")\n");
          }
        }
      }
      visitedNodes.add(currentNode);
      listOfNodes.remove(currentNode);
      print("List of nodes size: ",listOfNodes.size());
    }
  }
  
  void drawNodes() {
    for(int i =0; i < nodes.size(); i++) {
      nodes.get(i).draw();
    }
  }
  
  void dijkstra(){
    boolean finished = false;
    
    // Stack to keep current nodes on
    ArrayList<Node> nodeStack = new ArrayList<Node>();
    
    // List of visited nodes
    ArrayList<Node> visitedNodes = new ArrayList<Node>();
    
    // Add first node
    nodeStack.add(start.node);
    
    Node current;
    
    while(!finished) {
      print("Node stack length = ", nodeStack.size(), "\n");
      if(nodeStack.size() == 0) { // Node stack is empty, either path is impossible or something has gone very wrong
        print("nodeStack is empty, path impossible");
      }
      
      current = findShortest(nodeStack); // Find shortest node
      print("Current node = (", current.tile.collumn , ",", current.tile.collumn ,"). \n");
      if(current == end.node) { // If reached end break from loop
        finished = true;
        makeRoute();
        break;
      }
      
      nodeStack.remove(current);
      visitedNodes.add(current);
      
      println("Num Nodes connected = ", current.edges.size());
      for(int i = 0; i < current.edges.size(); i++) { // Go through edges on shortest node
        if (visitedNodes.contains(current.edges.get(i).endNode)) { // Already visited node
          if(current.dijPathLength + current.edges.get(i).lengthOfEdge < current.edges.get(i).endNode.dijPathLength) { // new path length is shorter than old length
            current.edges.get(i).endNode.dijPathLength = current.dijPathLength + current.edges.get(i).lengthOfEdge;
            current.edges.get(i).endNode.dijVia = current.edges.get(i);
            print("Shortest route to: ",current.edges.get(i).endNode.tile.collumn , ",", current.edges.get(i).endNode.tile.collumn ,") updated.\n");
          }
        } else { // Haven't visited node
          nodeStack.add(current.edges.get(i).endNode);
          current.edges.get(i).endNode.dijPathLength = current.dijPathLength + current.edges.get(i).lengthOfEdge;
          current.edges.get(i).endNode.dijVia = current.edges.get(i);
          print("Added node: = (", current.edges.get(i).endNode.tile.collumn , ",", current.edges.get(i).endNode.tile.collumn ,").\n");
        }
      }
    }
  }
    
  // Find shortest node in a stack
  Node findShortest(ArrayList<Node> nodeStack) {
    
    Node shortest = null;
    
    if(nodeStack.size() > 0){
      shortest = nodeStack.get(0);
      
      for(int i = 0; i < nodeStack.size(); i++) {
        if(nodeStack.get(i).dijPathLength < shortest.dijPathLength) {
          shortest = nodeStack.get(i);
        }
      }
    } else { // Given a array of length 0 (should never happen)
      print("'findShortest()' passed array of length 0.\n");
    }
    
    return shortest;
  }
  
  // Make the api details for the path
  void makeRoute() {
     print("Make route ran\n");
     boolean finished = false;
     
     pathLength = 1;
     
     Node current = end.node;
     
     while(!finished) {
       route.add(current.dijVia);
       
       pathLength = pathLength + current.dijVia.lengthOfEdge;
       
       current = current.dijVia.startNode;
       
       print("Edge ending at X: ", current.tile.collumn, " Y: ", current.tile.row, "\n");
       
       if (current.tile == start) {
         finished = true;
         drawRoute();
         break;
       }
     }
  }
    
   void drawRoute() {
     int currentDist = 0;
     for(int i = 0; i < route.size(); i++) {
       for(int j = route.get(i).lengthOfEdge-1; j >= 0; j--) {
         route.get(i).tiles[j].pathValue = currentDist;
         route.get(i).tiles[j].tileType = TileType.ROUTE;
         currentDist = currentDist + 1;
       }
     }
  }
}
