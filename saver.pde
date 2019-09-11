class map_saver {
  map_saver() {
  }
  void save(String path, map map) {
    int[][] data = map.data;
    int w = data.length;
    int h = data[0].length;
    byte[] header = {
      'Y', 'K', 'S', 'K', 
      's', 'M', 'a', 'p', 
      'D', 'a', 't', 'a', 
      ' ', 'V', '1', ' ', 

      'W', byte(w&0xff), 'H', byte(h&0xff), 
      '.', '.', '.', '.', 
      '.', '.', '.', '.', 
      '.', '.', '.', '.'
    };
    byte[] out = new byte[header.length+(w*h)];
    for (int i = 0; i < header.length; i++) {
      out[i] = header[i];
    }
    for (int y = 0; y < h; y++) {
      for (int x = 0; x < w; x++) {
        out[header.length+(x+(y*w))] = byte(data[x][y]);
      }
    }
    saveBytes(path, out);
  }
  map load(String path){
    map out = new map();
    
    return out;
  }
}
