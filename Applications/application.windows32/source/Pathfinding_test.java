import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Pathfinding_test extends PApplet {

API mAPI;
Handler mHandler;
UI mUI;

final int ROW_NUM = 20;
final int COLLUMN_NUM = 20;

public void setup() {
  
  background(255);
  
  mUI = new UI();
  mAPI = new API();
  mHandler = new Handler();
  
}

public void mousePressed() {
  mAPI.mousePressed();
}

public void mouseDragged() {
  mAPI.mousePressed();
}

public void draw(){
  mUI.mGrid.draw();
  mAPI.drawNodes();
}

public void keyPressed() {
  mAPI.keyPressed();
}

class API {
  State state;
  boolean debug = false;

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
  
  public void mousePressed() {
    tileMatrix[mouseX/( width/COLLUMN_NUM)][mouseY/( height/ROW_NUM)].onClicked();
  }
  
  public void keyPressed() {
    if(key == 'd' || key == 'D') {
      if(state == State.DRAW_MAP) {
        findNodesAndEdges();
        state = State.ALGORITHM;
        dijkstra();
      }
    } else if (key == 'm' || key == 'M') {
      debug = !debug;
    }
  }
  
  public void findNodesAndEdges() {
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
      boolean removing = true;
      while (removing) {
        if(!listOfNodes.remove(currentNode)) {
          removing = false;
        }
      }
      print("List of nodes size: ",listOfNodes.size());
    }
  }
  
  public void drawNodes() {
    for(int i =0; i < nodes.size(); i++) {
      nodes.get(i).draw();
    }
  }
  
  public void dijkstra(){
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
      
      boolean removing = true;
      while(removing) {
        if(!nodeStack.remove(current)) {
          removing = false; 
        }
      }
      visitedNodes.add(current);
      
      println("Num Nodes connected = ", current.edges.size());
      for(int i = 0; i < current.edges.size(); i++) { // Go through edges on shortest node
        if (visitedNodes.contains(current.edges.get(i).endNode)) { // Already visited node
          if(current.dijPathLength + current.edges.get(i).lengthOfEdge < current.edges.get(i).endNode.dijPathLength) { // new path length is shorter than old length
            current.edges.get(i).endNode.dijPathLength = current.dijPathLength + current.edges.get(i).lengthOfEdge;
            current.edges.get(i).endNode.dijVia = current.edges.get(i);
            print("Shortest route to: ",current.edges.get(i).endNode.tile.collumn , ",", current.edges.get(i).endNode.tile.row ,") updated.\n");
          }
        } else { // Haven't visited node
          nodeStack.add(current.edges.get(i).endNode);
          current.edges.get(i).endNode.dijPathLength = current.dijPathLength + current.edges.get(i).lengthOfEdge;
          current.edges.get(i).endNode.dijVia = current.edges.get(i);
          print("Added node: = (", current.edges.get(i).endNode.tile.collumn , ",", current.edges.get(i).endNode.tile.row ,").\n");
        }
      }
    }
  }
    
  // Find shortest node in a stack
  public Node findShortest(ArrayList<Node> nodeStack) {
    
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
  public void makeRoute() {
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
    
   public void drawRoute() {
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
  
  public void draw() {
    if(mAPI.debug) {
      stroke(255, 0, 0);
      line((width/COLLUMN_NUM) * (startTile.collumn + 0.5f),
           (height/ROW_NUM) * (startTile.row + 0.5f),
           (width/COLLUMN_NUM) * (endTile.collumn + 0.5f),
           (height/ROW_NUM) * (endTile.row + 0.5f));
    }
  }
  
  public void setPathValues(int start) {
    //for(int i = 0; i < lengthOfEdge; i++) {
    //    tiles[i].pathValue = start + i;
    //  }
  }
}
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
  
  public void draw() {
    for(int i = 0; i < COLLUMN_NUM; i++) {
      for(int j = 0; j < ROW_NUM; j++) {
        squareMatrix[i][j].draw();
      }
    }
  }
  
  public Square getSquare(int collumn, int row) {
    return squareMatrix[collumn][row];
  }
}

class Handler {
  Handler() {
    
  }
}

class Node {
  int collumn;
  int row;
  Tile tile;
  
  int dijPathLength;
  Edge dijVia;
  
  ArrayList<Edge> edges = new ArrayList<Edge>();
  
  Node(int collumn, int row) {
    this.collumn = collumn;
    this.row = row;
    tile = mAPI.tileMatrix[collumn][row];
  }
  
  public void addEdge(Edge edge) {
    edges.add(edge);
  }
  
  public void addEdge(Node start, Node end) {
    edges.add(new Edge(start, end));
  }
  
  public void draw() {
    if(mAPI.debug) {
      fill( 0, 0, 255 );
      circle((width/COLLUMN_NUM) * (tile.collumn +0.5f),
             (height/ROW_NUM) * (tile.row +0.5f),
             min(width/COLLUMN_NUM, height/ROW_NUM)/2);
      for(int i =0; i < edges.size(); i++) {
        edges.get(i).draw();
      }
    }
  }
}

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
  
  public void draw() {
    colorRGB = getColor();
    stroke(SQUARE_STROKE);
    fill(colorRGB[0], colorRGB[1], colorRGB[2]);
    rect(((width-BUFFER)/COLLUMN_NUM * collumn) + BUFFER, 
        ((height-BUFFER)/ROW_NUM * row) + BUFFER, 
        ((width-BUFFER)/COLLUMN_NUM) - 2 * BUFFER, 
        ((height-BUFFER)/ROW_NUM) - 2 * BUFFER,
        ROUNDING);
  }
  
  public int[] getColor() {
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
            toReturn[0] = 250; toReturn[1] = 250; toReturn[2] = 250;
            break;
          case ROUTE:
            float fraction = (float) (findTile().pathValue) / mAPI.pathLength;
            toReturn[0] = ceil(127* sin(TWO_PI* ((fraction +1.0f/3) %1)) + 128); toReturn[1] = ceil(127*sin(TWO_PI*((fraction+2.0f/3)%1)) + 128); toReturn[2] = ceil(127*sin(TWO_PI*((fraction)%1)) + 128);
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
  
  public Tile findTile() {
    return mAPI.tileMatrix[collumn][row];
  }
}

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
  
  public Square findSquare() {
    return mUI.mGrid.squareMatrix[collumn][row];
  }
  
  public void onClicked() {
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
  
  public boolean isNode() {
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

class UI {
  
  Grid mGrid;
  
  UI() {
    mGrid = new Grid();
  }
}
  public void settings() {  size(600, 600); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Pathfinding_test" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
