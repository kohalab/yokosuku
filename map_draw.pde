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
  PGraphics g;
  map() {
    map(WIDTH, HEIGH);
  }
  map(int w, int h) {
    map(w, h);
  }
  void map(int w, int h) {
    g = createGraphics(w*16, h*16);
    data = new int[w][h];
    data_old = new int[w][h];
    for (int y = 0; y < data[0].length; y++) {
      for (int x = 0; x < data.length; x++) {
        data[x][y] = 0;
      }
    }
    for (int y = 0; y < data[0].length; y++) {
      for (int x = 0; x < data.length; x++) {
        data_old[x][y] = -1;
      }
    }
    map_buf = createGraphics(w*16, h*16);
    map_buf.beginDraw();
  }
  void backup() {
    for (int y = 0; y < data[0].length; y++) {
      for (int x = 0; x < data.length; x++) {
        data_old[x][y] = data[x][y];
      }
    }
  }
  void draw() {
    map_buf.beginDraw();
    for (int y = 0; y < data[0].length; y++) {
      for (int x = 0; x < data.length; x++) {
        ;
        if (data_old[x][y] != data[x][y]) {
          map_buf.noStroke();
          map_buf.fill(bg_color);
          map_buf.rect(x*16, y*16, 16, 16);
          if (data[x][y] >= 1 && data[x][y] < 128) {
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


  void mob_draw() {
    g.beginDraw();
    g.clear();
    for (int y = 0; y < data[0].length; y++) {
      for (int x = 0; x < data.length; x++) {
        if (data[x][y] == 0x80) {
          float i = (((float)x/WIDTH)+((float)((float)y/HEIGH)*WIDTH))*TWO_PI;
          float xt = sin(frameCount/60.0*TWO_PI+i)*3;
          image(frp(get_cha(cha, data[x][y]), xt >= 0, false), x*16+xt, (y*16)
            +int(sin(frameCount/30.0*TWO_PI+i)*3)
            +yofs);
        } else
          if (data[x][y] == 0x81) {
            float i = (((float)x/WIDTH)+((float)((float)y/HEIGH)*WIDTH))*TWO_PI;
            float xt = sin(frameCount/60.0*TWO_PI+i)*3;
            g.image(get_cha(cha, data[x][y]), x*16+xt-8, (y*16-8)
              +int(sin(frameCount/30.0*TWO_PI+i)*3)
              +0);
            g.image(get_cha(cha, data[x][y]), x*16+xt+8, (y*16-8)
              +int(sin(frameCount/30.0*TWO_PI+i)*3)
              +0);
            g.image(get_cha(cha, data[x][y]+1), x*16+xt-8, (y*16)+16-8
              +int(sin(frameCount/30.0*TWO_PI+i)*3)
              +0, 
              32, (HEIGH-1)*16);
          } else {
            if (data[x][y] > 0x80) {
              //else
              image(get_cha(cha, data[x][y]), x*16, y*16+yofs);
            }
          }
      }
    }
    g.endDraw();
    image(dis(g.get(), frameCount%2 == 0), 0, yofs);
  }

  void update() {
    for (int y = 0; y < data[0].length; y++) {
      for (int x = 0; x < data.length; x++) {
        data_old[x][y] = -1;
      }
    }
  }

  PImage get() {
    return map_buf.get();
  }
}
