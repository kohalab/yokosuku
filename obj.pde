class obj {
  int type = 0;
  int pw = 16;
  int ph = 16;
  float x = 0;
  float y = 0;
  float xs = 0;
  float ys = 0;
  boolean no_col = false;
  obj(int itype, int w, int h, float ix, float iy, float ixs, float iys) {
    x = ix;
    y = iy;
    xs = ixs;
    ys = iys;
    pw = w;
    ph = h;
    type = itype;
  }

  void draw() {
    if (type > 0) {
      image(get_cha(cha, type, pw, ph), x-(pw/2), y-ph+yofs);
    }
  }

  void proc() {
    if (type > 0) {
      colp();
      if (x < pw/2)x = pw/2;
      if (x > dw-(pw/2))x = dw-(pw/2);
      xs /= 1.3;
      ;

      ;
      x += xs/speed;
      y += ys/speed;
      ys += gravity;
      if (y > HEIGH*16+ph) {
        type = 0;
      }
    }
  }

  void colp() {
    if (!no_col) {
      for (int Y = 0; Y < HEIGH; Y++) {
        for (int X = 0; X < WIDTH; X++) {
          int ex = X*16;
          int ey = Y*16;
          int w = 16;
          int h = 16;
          //
          noStroke();

          if (col(ex, ey, w, h, int(x-(pw/2)), int(y-(ph-8))) || col(ex, ey, w, h, int(x-(pw/2)), int(y-12))) {
            if (map.data[X][Y] != 0) {
              x = ex+w+(pw/2);
              xs = 0;
            }
          }
          if (col(ex, ey, w, h, int(x+(pw/2)), int(y-(ph-8))) || col(ex, ey, w, h, int(x+(pw/2)), int(y-12))) {
            if (map.data[X][Y] != 0) {
              x = ex-(pw/2);
              xs = 0;
            }
          }
          if (
            col(ex, ey, w, h, int(x-(pw/3)), int(y-ph))||
            col(ex, ey, w, h, int(x), int(y-ph))||
            col(ex, ey, w, h, int(x+(pw/3)), int(y-ph))
            ) {
            if (map.data[X][Y] != 0) {
              ys = ys < 0?-ys:ys;
            }
          }
          if (
            col(ex, ey, w, h, int(x-(pw/3)), int(y+1))||
            col(ex, ey, w, h, int(x), int(y+1))||
            col(ex, ey, w, h, int(x+(pw/3)), int(y+1))
            ) {
            if (map.data[X][Y] != 0) {
              if (debug) {
                fill(255, 128);
                rect(ex, ey+yofs, w-1, h-1);
              }
              ys = -0.01;
              if (y < ey+15) {
                y = ey;
              }
            }
          }
          if (
            col(ex, ey, w, h, int(x), int(y-ph+4)) || 
            col(ex, ey, w, h, int(x), int(y   -4)) ||
            col(ex, ey, w, h, int(x-(pw/2)+4), int(y)) || 
            col(ex, ey, w, h, int(x+(pw/2)-4), int(y))
            ) {
            //ifblock(map.data[X][Y]);
          }
          //
        }
      }
    }
  }
}
