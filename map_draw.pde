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
  int xs, ys;
  boolean hf, vf;
  int xscr;
  float r;
  void reset() {
    w = 16;
    h = 16;
    r = 0;
    x = 0;
    y = 0;
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


class map {
  int[][] data;
  int[][] data_old;
  int[][] data_sub;
  prf[][] pos_ofs;
  PGraphics map_buf;
  PGraphics g;
  String name = null;
  map() {
    map(map.data.length, map.data[0].length);
  }
  map(int w, int h) {
    map(w, h);
  }
  void map(int w, int h) {
    g = createGraphics(w*16, h*16);
    data = new int[w][h];
    data_old = new int[w][h];
    data_sub = new int[w][h];
    pos_ofs  = new prf[w][h];
    for (int y = 0; y < data[0].length; y++) {
      for (int x = 0; x < data.length; x++) {
        data[x][y] = 0;
        pos_ofs[x][y] = new prf(0, 0);
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
          if (grd_en) {
            map_buf.image(grd.get(0, 0, 16, 16), x*16, y*16);
          }
          if (data[x][y] >= 1 && data[x][y] < 128) {
            map_buf.image(get_cha(cha, data[x][y]), x*16, y*16);
          } else {
          }
          //println("change "+x+" "+y);
        }
        ;
      }
    }
    map_buf.endDraw();
  }


  void mob_proc() {
    for (int y = 0; y < data[0].length; y++) {
      for (int x = 0; x < data.length; x++) {
        pos_ofs[x][y].ox = pos_ofs[x][y].x;
        pos_ofs[x][y].oy = pos_ofs[x][y].y;
      }
    }
    for (int y = 0; y < data[0].length; y++) {
      for (int x = 0; x < data.length; x++) {
        int b = data[x][y];
        pos_ofs[x][y].x = 0;
        pos_ofs[x][y].y = 0;
        pos_ofs[x][y].hf = false;
        pos_ofs[x][y].vf = false;
        pos_ofs[x][y].r = 0;
        pos_ofs[x][y].xscr = 0;
        pos_ofs[x][y].w = 16;
        pos_ofs[x][y].h = 16;
        if (b == 0) {
          data_sub[x][y] = 30;
        }
        if (water_list[b]) {
          pos_ofs[x][y].xscr = int(sin(frameCount/60.0*TWO_PI)*4);
          //pos_ofs[x][y].y = int(sin( (x/30.0*TWO_PI) + (sin(frameCount/30.0*TWO_PI)/2) + (frameCount/30.0*TWO_PI) )*4+4);
        } else if (hata_list[b]) {
          pos_ofs[x][y].xscr = 0;
          pos_ofs[x][y].r = sin((float)(millis()+(x*36))/(1000+(y*4)/2)*TWO_PI)*5;
        } else if (obake_list[b]) {
          pos_ofs[x][y].r = sin((float)(millis()+(x*36))/(1000+(y*4))*TWO_PI/1)*5.1;
          pos_ofs[x][y].hf = sin((float)(millis()+(x*36))/(1000+(y*4))*TWO_PI/2) > 0;
          pos_ofs[x][y].x = int(sin((float)(millis()+(x*36))/(1000+(y*4))*TWO_PI/2)*8);
          pos_ofs[x][y].y = int(cos((float)(millis()+(x*36))/(1000+(y*4))*TWO_PI/2)*4);
        } else if (super_obake_list[b]) {
          pos_ofs[x][y].r = sin((float)(millis()+(x*36*5))/(1000+(y*4*5))*TWO_PI/2)*8;
          pos_ofs[x][y].hf = sin((float)(millis()+(x*36*5))/(1000+(y*4*5))*TWO_PI/4) > 0;
          pos_ofs[x][y].x = int(sin((float)(millis()+(x*36*5))/(1000+(y*4*5))*TWO_PI/4)*32);
          pos_ofs[x][y].y = int(cos((float)(millis()+(x*36*5))/(1000+(y*4*5))*TWO_PI/4)*32);
        } else if (aobake_list[b]) {
          pos_ofs[x][y].hf = cos((float)(millis()+(x*36*5))/(1000+(y*4*5))*TWO_PI/4) > 0;
          pos_ofs[x][y].x = int(sin((float)(millis()+(x*36*5))/(1000+(y*4*5))*TWO_PI/4)*64);
        } else if (poteto_list[b]) {
          pos_ofs[x][y].r = int(sin(millis()/900.0*TWO_PI)*3)*7;
        } else if (kinoko_list[b]) {
          pos_ofs[x][y].y = int(-sin(millis()/900.0*TWO_PI%PI)*4);
        } else if (left_jump_list[b] && right_jump_list[b] && up_jump_list[b] && down_jump_list[b]) {
          pos_ofs[x][y].x = -((data_sub[x][y]/5)-0)/2;
          pos_ofs[x][y].y = -((data_sub[x][y]/5)-0)/2;
          pos_ofs[x][y].w += ((data_sub[x][y]/5)-0);
          pos_ofs[x][y].h += ((data_sub[x][y]/5)-0);
          if (data_sub[x][y] > 0)data_sub[x][y] -= 15;
        } else if (left_jump_list[b]) {
          pos_ofs[x][y].x = -((data_sub[x][y]/5)-0);
          pos_ofs[x][y].w += ((data_sub[x][y]/5)-0);
          if (data_sub[x][y] > 0)data_sub[x][y] -= 15;
        } else if (right_jump_list[b]) {
          pos_ofs[x][y].x = 0;
          pos_ofs[x][y].w += ((data_sub[x][y]/5)-0);
          if (data_sub[x][y] > 0)data_sub[x][y] -= 15;
        } else if (up_jump_list[b]) {
          pos_ofs[x][y].y = -((data_sub[x][y]/5)-0);
          pos_ofs[x][y].h += ((data_sub[x][y]/5)-0);
          if (data_sub[x][y] > 0)data_sub[x][y] -= 15;
        } else if (down_jump_list[b]) {
          pos_ofs[x][y].y = 0;
          pos_ofs[x][y].h += ((data_sub[x][y]/5)-0);
          if (data_sub[x][y] > 0)data_sub[x][y] -= 15;
        }
        if (ugo_hor_list[b]) {
          int u = int(sin(millis()/100.0/ugo_hor_level[b]*TWO_PI)*ugo_hor_level[b]);
          pos_ofs[x][y].x += u;
          if (y > 0) {
            if (data[x][y-1] >= 128) {
              pos_ofs[x][y-1].x += u;
            }
          }
          //
        }
        if (ugo_ver_list[b]) {
          int u = int(sin(millis()/100.0/ugo_ver_level[b]*TWO_PI)*ugo_ver_level[b]);
          pos_ofs[x][y].y += u;
          if (y > 0) {
            if (data[x][y-1] >= 128) {
              pos_ofs[x][y-1].y += u;
            }
          }
          //
        }
        //
      }
    }
    for (int y = 0; y < data[0].length; y++) {
      for (int x = 0; x < data.length; x++) {
        pos_ofs[x][y].xs = pos_ofs[x][y].x-pos_ofs[x][y].ox;
        pos_ofs[x][y].ys = pos_ofs[x][y].y-pos_ofs[x][y].oy;
      }
    }
  }
  void mob_draw() {
    for (int y = 0; y < data[0].length; y++) {
      for (int x = 0; x < data.length; x++) {
        ;
        if (x*16-scrx >= -32 && x*16-scrx < (WIDTH+1)*16   &&   y*16-scry >= -32 && y*16-scry < (HEIGH+1)*16) {
          if (data[x][y] >= 0x80) {
            //else
            //stt
            if (pos_ofs[x][y].w == 16 && pos_ofs[x][y].h == 16) {
              //
              if (pos_ofs[x][y].xscr != 0) {
                //
                if (pos_ofs[x][y].xscr > 0) {
                  ik(frp(get_cha(cha, data[x][y], 32, 16).get((pos_ofs[x][y].xscr)%16, 0, 16, 16), pos_ofs[x][y].hf, pos_ofs[x][y].vf), x*16-scrx+pos_ofs[x][y].x, y*16+yofs-scry+pos_ofs[x][y].y, pos_ofs[x][y].r);
                } else {
                  ik(frp(get_cha(cha, data[x][y], 32, 16).get(15-(-pos_ofs[x][y].xscr)%16, 0, 16, 16), pos_ofs[x][y].hf, pos_ofs[x][y].vf), x*16-scrx+pos_ofs[x][y].x, y*16+yofs-scry+pos_ofs[x][y].y, pos_ofs[x][y].r);
                }
                //t
              } else {
                if (super_obake_list[data[x][y]] || aobake_list[data[x][y]]) {
                  ik(frp(get_cha(cha, data[x][y]+4), pos_ofs[x][y].hf, pos_ofs[x][y].vf), x*16-scrx, y*16+yofs-scry, 0);
                }
                ik(frp(get_cha(cha, data[x][y]), pos_ofs[x][y].hf, pos_ofs[x][y].vf), x*16-scrx+pos_ofs[x][y].x, y*16+yofs-scry+pos_ofs[x][y].y, pos_ofs[x][y].r);
              }
              //
            } else {
              image(frp(get_cha(cha, data[x][y]), pos_ofs[x][y].hf, pos_ofs[x][y].vf), x*16-scrx+pos_ofs[x][y].x, y*16+yofs-scry+pos_ofs[x][y].y, pos_ofs[x][y].w, pos_ofs[x][y].h);
            }
            //end
          }
        }
        ;
      }
    }
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
