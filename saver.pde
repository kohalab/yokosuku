class map_saver {
  map_saver() {
  }
  void save(String path, map map) {
    int[][] data = map.data;
    int w = data.length;
    int h = data[0].length;
    byte[] header = {
      'Y', 'K', 'S', 'K', //00
      '-', 'M', 'a', 'p', //04
      'D', 'a', 't', 'a', //08
      ' ', 'V', '3', ' ', //0c

      byte(w&0xff), byte(h&0xff), '.', '.', //10
      '.', '.', '.', '.', //14
      '.', '.', '.', '.', //18
      '.', '.', '.', '.'  //1c
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
  map load(String path) {
    int data_offset = 32;
    byte[] in = loadBytes(path);
    byte[] header = {'Y', 'K', 'S', 'K'};
    boolean yes = true;
    if (in == null)
      return null;
    if (in .length < data_offset)
      return null;
    for (int i = 0; i < header.length; i++) {
      if (in[i] != header[i]) {
        yes = false;
      }
    }
    if (yes) {
      map out;
      out = new map(map.data.length, map.data[0].length);
      int w = in[0x10]&0xff;
      int h = in[0x11]&0xff;
      String name = "";
      for (int i = 0; i < 8; i++) {
        int a = in[24+i]&0xff;
        if (a != '.') {
          name += char(a);
        }
      }
      if (name.length() > 0) {
        out.name = name;
        //println(name);
      }
      if (w <= map.data.length && h <= map.data[0].length) {
        //println(w, h);
        for (int y = 0; y < h; y++) {
          for (int x = 0; x < w; x++) {
            out.data[x][y+(map.data[0].length-h)] = in[x+(y*w)+data_offset]&0xff;
          }
        }
        //
      } else {
        println("dif size");
        return null;
      }
      return out;
    } else {
      println("not yokosuku map data file");
      return null;
    }
  }
}
