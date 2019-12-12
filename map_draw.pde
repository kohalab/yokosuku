color bg_color = #bbeeff;

PImage get_cha(PImage in, int n) {
  return in.get((n%16)*16, (n/16)*16, 16, 16);
}

PImage get_cha(PImage in, int n, int w, int h) {
  return in.get((n%16)*16, (n/16)*16, w, h);
}

class prf {
  int x, y;
  int w, h;
  int ox, oy;
  float ofx, ofy;
  float xs, ys;
  boolean hf, vf;
  int xscr;
  float r, or;
  int ints0;
  int ints1;
  int ints2;
  int ints3;
  void reset() {
    ints0 = 0;
    ints1 = 0;
    ints2 = 0;
    ints3 = 0;
    w = 16;
    h = 16;
    r = 0;
    x = 0;
    y = 0;
    ox = 0;
    oy = 0;
    ofx = 0;
    ofy = 0;

    xs = 0;
    ys = 0;
    hf = false;
    vf = false;
    xscr = 0;
  }
  prf(int i, int f) {
    x = i;
    y = f;
  }
  prf(int i, int f, boolean h, boolean v) {
    x = i;
    y = f;
    hf = h;
    vf = v;
  }
  prf() {
  }
}

void dead_map() {
  map.onof = false;
  map.mob_time = 0;
  for (int y = 0; y < map.data[0].length; y++) {
    for (int x = 0; x < map.data.length; x++) {
      map.data_sub[x][y] = -1;
    }
  }
  map.mobreset();
}
