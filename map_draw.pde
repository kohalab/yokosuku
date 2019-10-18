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
  float r, or;
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

  int mob_time = 0;


  void mob_proc() {
    for (int y = 0; y < data[0].length; y++) {
      for (int x = 0; x < data.length; x++) {
        pos_ofs[x][y].ox = pos_ofs[x][y].x;
        pos_ofs[x][y].oy = pos_ofs[x][y].y;
        pos_ofs[x][y].or = pos_ofs[x][y].r;
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
      }
    }
    for (int y = 0; y < data[0].length; y++) {
      for (int x = 0; x < data.length; x++) {
        int b = data[x][y];
        if (b == 0) {
          data_sub[x][y] = 30;
        }
        if (water_list[b]) {
          pos_ofs[x][y].xscr = int(sin(mob_time/33/60.0*TWO_PI)*4);
          //pos_ofs[x][y].y = int(sin( (x/30.0*TWO_PI) + (sin(frameCount/30.0*TWO_PI)/2) + (frameCount/30.0*TWO_PI) )*4+4);
        } else if (hata_list[b]) {
          pos_ofs[x][y].xscr += 0;
          pos_ofs[x][y].r += sin((float)(mob_time+(x*36))/(1000+(y*4)/2)*TWO_PI)*5;
        } else if (obake_list[b]) {
          pos_ofs[x][y].r += sin((float)(mob_time+(x*36))/(1000+(y*4))*TWO_PI/1)*5.1;
          pos_ofs[x][y].hf = sin((float)(mob_time+(x*36))/(1000+(y*4))*TWO_PI/2) > 0;
          pos_ofs[x][y].x += int(sin((float)(mob_time+(x*36))/(1000+(y*4))*TWO_PI/2)*8);
          pos_ofs[x][y].y += int(cos((float)(mob_time+(x*36))/(1000+(y*4))*TWO_PI/2)*4);
        } else if (super_obake_list[b]) {
          pos_ofs[x][y].r += sin((float)(mob_time+(x*36*5))/(1000+(y*4*5))*TWO_PI/2)*8;
          pos_ofs[x][y].hf = sin((float)(mob_time+(x*36*5))/(1000+(y*4*5))*TWO_PI/4) > 0;
          pos_ofs[x][y].x += int(sin((float)(mob_time+(x*36*5))/(1000+(y*4*5))*TWO_PI/4)*32);
          pos_ofs[x][y].y += int(cos((float)(mob_time+(x*36*5))/(1000+(y*4*5))*TWO_PI/4)*32);
        } else if (aobake_list[b]) {
          pos_ofs[x][y].hf = cos((float)(millis()+(x*36*5))/(1000+(y*4*5))*TWO_PI/4) > 0;
          pos_ofs[x][y].x += int(sin((float)(mob_time+(x*36*5))/(1000+(y*4*5))*TWO_PI/4)*64);
        } else if (poteto_list[b]) {
          pos_ofs[x][y].r += int(sin(mob_time/900.0*TWO_PI)*3)*7;
        } else if (kinoko_list[b]) {
          pos_ofs[x][y].y += int(-sin(mob_time/900.0*TWO_PI%PI)*4);
        } else if (left_jump_list[b] && right_jump_list[b] && up_jump_list[b] && down_jump_list[b]) {
          pos_ofs[x][y].x += -((data_sub[x][y]/5)-0)/2;
          pos_ofs[x][y].y += -((data_sub[x][y]/5)-0)/2;
          pos_ofs[x][y].w += ((data_sub[x][y]/5)-0);
          pos_ofs[x][y].h += ((data_sub[x][y]/5)-0);
          if (data_sub[x][y] > 0)data_sub[x][y] -= 15;
        } else if (left_jump_list[b]) {
          pos_ofs[x][y].x += -((data_sub[x][y]/5)-0);
          pos_ofs[x][y].w += ((data_sub[x][y]/5)-0);
          if (data_sub[x][y] > 0)data_sub[x][y] -= 15;
        } else if (right_jump_list[b]) {
          pos_ofs[x][y].x += 0;
          pos_ofs[x][y].w += ((data_sub[x][y]/5)-0);
          if (data_sub[x][y] > 0)data_sub[x][y] -= 15;
        } else if (up_jump_list[b]) {
          pos_ofs[x][y].y += -((data_sub[x][y]/5)-0);
          pos_ofs[x][y].h += ((data_sub[x][y]/5)-0);
          if (data_sub[x][y] > 0)data_sub[x][y] -= 15;
        } else if (down_jump_list[b]) {
          pos_ofs[x][y].y += 0;
          pos_ofs[x][y].h += ((data_sub[x][y]/5)-0);
          if (data_sub[x][y] > 0)data_sub[x][y] -= 15;
        }
        if (ugo_hor_list[b]) {
          int u = int(sin(mob_time/100.0/ugo_hor_level[b]*TWO_PI)*ugo_hor_level[b]);
          pos_ofs[x][y].x += u;
          for (int i = 0; i < 2; i++) {
            if (y > i) {
              if (data[x][y-(i+1)] >= 128) {
                pos_ofs[x][y-(i+1)].x += pos_ofs[x][y].x;
                pos_ofs[x][y-(i+1)].y += pos_ofs[x][y].y;
              }
            }
          }
          //
        }
        if (ugo_ver_list[b]) {
          int u = int(cos(mob_time/100.0/ugo_ver_level[b]*TWO_PI)*ugo_ver_level[b]);
          pos_ofs[x][y].y += u;
          for (int i = 0; i < 2; i++) {
            if (y > i) {
              if (data[x][y-(i+1)] >= 128) {
                pos_ofs[x][y-(i+1)].x += pos_ofs[x][y].x;
                pos_ofs[x][y-(i+1)].y += pos_ofs[x][y].y;
              }
            }
          }
          //
        }
        //
        if (taiho_list[b]) {
          int n = int((float)mob_time/33%taiho_level[b]*4);
          if (x > 0) {
            if (data[x-1][y] >= 128) {
              pos_ofs[x-1][y].x -= n;
              pos_ofs[x-1][y].x += pos_ofs[x][y].x;
              pos_ofs[x-1][y].y += pos_ofs[x][y].y;
            }
          }
          if (x < data.length-1) {
            if (data[x+1][y] >= 128) {
              pos_ofs[x+1][y].x += n;
              pos_ofs[x+1][y].x += pos_ofs[x][y].x;
              pos_ofs[x+1][y].y += pos_ofs[x][y].y;
            }
          }
        }
        //
        if (guru_list[b]) {
          float n = ((float)mob_time/33*360.0/guru_level[b]);
          pos_ofs[x][y].r += n;
          if (x > 0) {
            if (data[x-1][y] >= 128 && !guru_list[data[x-1][y]]) {
              pos_ofs[x-1][y].r -= n;
            }
          }
          if (x < data.length-1) {
            if (data[x+1][y] >= 128 && !guru_list[data[x+1][y]]) {
              pos_ofs[x+1][y].r -= n;
            }
          }
          if (y > 0) {
            if (data[x][y-1] >= 128 && !guru_list[data[x][y-1]]) {
              pos_ofs[x][y-1].r -= n;
            }
          }
          if (y < data[0].length-1) {
            if (data[x][y] >= 128 && !guru_list[data[x][y+1]]) {
              pos_ofs[x][y+1].r -= n;
            }
          }
        }
        //
      }
    }
    for (int y = 0; y < data[0].length; y++) {
      for (int x = 0; x < data.length; x++) {
        int b = data[x][y];
        //
        if (tunage_list[b]) {
          //
          if (x > 0) {
            if (data[x-1][y] >= 128) {
              pos_ofs[x-1][y].x += pos_ofs[x][y].x;
              pos_ofs[x-1][y].y += pos_ofs[x][y].y;
            }
          }
          if (x < data.length-1) {
            if (data[x+1][y] >= 128) {
              pos_ofs[x+1][y].x += pos_ofs[x][y].x;
              pos_ofs[x+1][y].y += pos_ofs[x][y].y;
              //println(pos_ofs[x][y].xs, pos_ofs[x][y].ys);
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
        pos_ofs[x][y].xs += (pos_ofs[x][y].r-pos_ofs[x][y].or)/5.0;
        pos_ofs[x][y].ys = pos_ofs[x][y].y-pos_ofs[x][y].oy;
      }
    }
    mob_time += 33.3333333;
  }
  void mob_draw() {
    for (int L = 0; L < 4; L++) {
      //
      for (int y = 0; y < data[0].length; y++) {
        for (int x = 0; x < data.length; x++) {
          ;
          if (
            ((x*16-scrx)+pos_ofs[x][y].x) >= -32 && ((x*16-scrx)+pos_ofs[x][y].x) < (WIDTH+1)*16   &&   ((y*16-scry)+pos_ofs[x][y].y) >= -32 && ((y*16-scry)+pos_ofs[x][y].y) < (HEIGH+1)*16 || 
            ((x*16-scrx)+0) >= -32 && ((x*16-scrx)+0) < (WIDTH+1)*16   &&   ((y*16-scry)+0) >= -32 && ((y*16-scry)+0) < (HEIGH+1)*16
            ) {
            if (data[x][y] >= 0x80) {
              //
              if (L == 0) {
                //layer0 begin
                if (ugo_hor_list[data[x][y]] || ugo_ver_list[data[x][y]]) {
                  stroke(#afafaf);
                  for (int i = 0; i < 2; i++) {
                    for (int f = 0; f < 2; f++) {
                      line(x*16-scrx+7+i, y*16+yofs-scry+7+f, x*16-scrx+pos_ofs[x][y].x+7+i, y*16+yofs-scry+pos_ofs[x][y].y+7+f);
                    }
                  }
                  noStroke();
                }
                if (super_obake_list[data[x][y]] || aobake_list[data[x][y]]) {
                  ik(frp(get_cha(cha, data[x][y]+4), pos_ofs[x][y].hf, pos_ofs[x][y].vf), x*16-scrx, y*16+yofs-scry, 0);
                }
                //layer0 end
              }
              //layer1 begin
              if (L == 1) {
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
                    ik(frp(get_cha(cha, data[x][y]), pos_ofs[x][y].hf, pos_ofs[x][y].vf), x*16-scrx+pos_ofs[x][y].x, y*16+yofs-scry+pos_ofs[x][y].y, pos_ofs[x][y].r);
                  }
                  //
                } else {
                  image(frp(get_cha(cha, data[x][y]), pos_ofs[x][y].hf, pos_ofs[x][y].vf), x*16-scrx+pos_ofs[x][y].x, y*16+yofs-scry+pos_ofs[x][y].y, pos_ofs[x][y].w, pos_ofs[x][y].h);
                }
                //end
              }
              //layer1 end
            }
          }
          ;
        }
      }
      //
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

void dead_map() {
  map.mob_time = 0;
  for (int y = 0; y < map.data[0].length; y++) {
    for (int x = 0; x < map.data.length; x++) {
      map.data_sub[x][y] = -1;
    }
  }
}
