color bg_color = #bbeeff;

PImage get_cha(PImage in, int n) {
  return in.get((n%16)*16, (n/16)*16, 16, 16);
}

PImage get_cha(PImage in, int n, int w, int h) {
  return in.get((n%16)*w, (n/16)*h, w, h);
}


class map {
  int[][] data;
  int[][] data_old;
  PGraphics map_buf;
  map() {
    data = new int[WIDTH][HEIGH];
    data_old = new int[WIDTH][HEIGH];
    for (int y = 0; y < HEIGH; y++) {
      for (int x = 0; x < WIDTH; x++) {
        data[x][y] = 0;
      }
    }
    for (int y = 0; y < HEIGH; y++) {
      for (int x = 0; x < WIDTH; x++) {
        data_old[x][y] = -1;
      }
    }
    map_buf = createGraphics(WIDTH*16, HEIGH*16);
    map_buf.beginDraw();
  }
  void backup() {
    for (int y = 0; y < HEIGH; y++) {
      for (int x = 0; x < WIDTH; x++) {
        data_old[x][y] = data[x][y];
      }
    }
  }
  void draw() {
    map_buf.beginDraw();
    for (int y = 0; y < HEIGH; y++) {
      for (int x = 0; x < WIDTH; x++) {
        ;
        if (data_old[x][y] != data[x][y]) {
          map_buf.noStroke();
          map_buf.fill(bg_color);
          map_buf.rect(x*16, y*16, 16, 16);
          if (data[x][y] >= 1) {
            map_buf.image(get_cha(cha, data[x][y]), x*16, y*16);
          } else {
            if (grd_en) {
              map_buf.image(grd.get(0, 0, 16, 16), x*16, y*16);
            }
          }
          //println("change "+x+" "+y);
        }
        ;
      }
    }
    map_buf.endDraw();
  }

  void update() {
    for (int y = 0; y < HEIGH; y++) {
      for (int x = 0; x < WIDTH; x++) {
        data_old[x][y] = -1;
      }
    }
  }

  PImage get() {
    return map_buf.get();
  }
}
