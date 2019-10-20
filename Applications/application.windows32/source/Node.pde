
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
  
  void addEdge(Edge edge) {
    edges.add(edge);
  }
  
  void addEdge(Node start, Node end) {
    edges.add(new Edge(start, end));
  }
  
  void draw() {
    if(mAPI.debug) {
      fill( 0, 0, 255 );
      circle((width/COLLUMN_NUM) * (tile.collumn +0.5),
             (height/ROW_NUM) * (tile.row +0.5),
             min(width/COLLUMN_NUM, height/ROW_NUM)/2);
      for(int i =0; i < edges.size(); i++) {
        edges.get(i).draw();
      }
    }
  }
}
