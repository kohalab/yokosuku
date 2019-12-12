class map {
  boolean onof;
  int[][] data;
  int[][] data_old;
  int[][] data_sub;
  prf[][] pos_ofs;
  //
  int[][] bg_data;
  int[][] bg_data_old;
  //
  PGraphics bg_map_buf;
  PGraphics map_buf;
  PGraphics g;
  String name = null;

  long flags;
  map() {
    map(map.data.length, map.data[0].length);
  }
  map(int w, int h) {
    map(w, h);
  }
  void map(int w, int h) {
    onof = false;
    g = createGraphics(w*16, h*16);
    data = new int[w][h];
    data_old = new int[w][h];
    data_sub = new int[w][h];
    pos_ofs  = new prf[w][h];
    bg_data = new int[w][h];
    bg_data_old = new int[w][h];
    for (int y = 0; y < data[0].length; y++) {
      for (int x = 0; x < data.length; x++) {
        data[x][y] = 0;
        pos_ofs[x][y] = new prf(0, 0);
      }
    }
    for (int y = 0; y < data[0].length; y++) {
      for (int x = 0; x < data.length; x++) {
        data_old[x][y] = -1;
        bg_data_old[x][y] = -1;
      }
    }
    map_buf = createGraphics(w*16, h*16);
    bg_map_buf = createGraphics(w*16, h*16);
    map_buf.beginDraw();
  }
  void mobreset() {
    for (int y = 0; y < pos_ofs[0].length; y++) {
      for (int x = 0; x < pos_ofs.length; x++) {
        pos_ofs[x][y] = new prf(0, 0);
      }
    }
    map.mob_time = 0;
  }
  void backup() {
    for (int y = 0; y < data[0].length; y++) {
      for (int x = 0; x < data.length; x++) {
        data_old[x][y] = data[x][y];
      }
    }
  }
  void bgbackup() {
    for (int y = 0; y < bg_data[0].length; y++) {
      for (int x = 0; x < bg_data.length; x++) {
        bg_data_old[x][y] = bg_data[x][y];
      }
    }
  }
  void draw() {
    //
    bg_map_buf.beginDraw();
    for (int y = 0; y < bg_data[0].length; y++) {
      for (int x = 0; x < bg_data.length; x++) {
        ;
        if (bg_data_old[x][y] != bg_data[x][y]) {
          bg_map_buf.noStroke();
          bg_map_buf.fill(bg_color);
          bg_map_buf.rect(x*16, y*16, 16, 16);
          bg_map_buf.image(bgblocks[bg_data[x][y]], x*16, y*16);
          if (grd_en) {
            bg_map_buf.image(grd.get(0, 0, 16, 16), x*16, y*16);
          }
        }
        ;
      }
    }
    bg_map_buf.endDraw();
    //
    map_buf.beginDraw();
    for (int y = 0; y < data[0].length; y++) {
      for (int x = 0; x < data.length; x++) {
        ;
        if (data_old[x][y] != data[x][y] || bg_data_old[x][y] != bg_data[x][y]) {
          map_buf.noStroke();
          map_buf.fill(bg_color);
          map_buf.rect(x*16, y*16, 16, 16);
          map_buf.image(bg_map_buf.get(x*16, y*16, 16, 16), x*16, y*16);
          if (grd_en) {
            //map_buf.image(grd.get(0, 0, 16, 16), x*16, y*16);
          }
          if (data[x][y] >= 1 && data[x][y] < 128) {
            map_buf.image(get_cha(cha, data[x][y]), x*16, y*16);
          } else {
          }
          ////////////////////////////////////////////////////////////////
          //map_buf.stroke(0,32);
          //map_buf.fill(255,255,0,64);
          //map_buf.rect(x*16+rects[data[x][y]].x, y*16+rects[data[x][y]].y, rects[data[x][y]].w, rects[data[x][y]].h);
          //println("change "+x+" "+y);
          ////////////////////////////////////////////////////////////////
        }
        ;
      }
    }
    map_buf.endDraw();
    //
  }

  int mob_time = 0;

  int of_ofs = 0xF2;
  int of_ons = 0xF3;
  int of_ofb = 0xF4;
  int of_onb = 0xF5;
  int of_sofb = 0xF6;
  int of_sonb = 0xF7;


  void mob_proc() {
    if (onof) {//on
      //
      for (int y = 0; y < data[0].length; y++) {
        for (int x = 0; x < data.length; x++) {
          //
          if (getblock(x, y) == of_ofs || getblock(x, y) == of_ons) {
            setblock(x, y, of_ons, false);
          }
          if (getblock(x, y) == of_ofb || getblock(x, y) == of_sofb) {
            setblock(x, y, of_sofb, false);
          }
          if (getblock(x, y) == of_onb || getblock(x, y) == of_sonb) {
            setblock(x, y, of_onb, false);
          }
        }
        //
      }
      //
    } else {   //off
      //
      for (int y = 0; y < data[0].length; y++) {
        for (int x = 0; x < data.length; x++) {
          //
          if (getblock(x, y) == of_ofs || getblock(x, y) == of_ons) {
            setblock(x, y, of_ofs, false);
          }
          if (getblock(x, y) == of_ofb || getblock(x, y) == of_sofb) {
            setblock(x, y, of_ofb, false);
          }
          if (getblock(x, y) == of_onb || getblock(x, y) == of_sonb) {
            setblock(x, y, of_sonb, false);
          }
        }
        //
      }
      //
    }

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
    for (int y = data[0].length-1; y > 0; y--) {
      for (int x = 0; x < data.length; x++) {
        int b = data[x][y];
        int tx = x*16;
        int ty = y*16;
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
          pos_ofs[x][y].x += int(sin((float)(mob_time+(x*36*5))/(1000+(y*4*5))*TWO_PI/4)*40);
          pos_ofs[x][y].y += int(cos((float)(mob_time+(x*36*5))/(1000+(y*4*5))*TWO_PI/4)*40);
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
          pos_ofs[x][y].x += -((data_sub[x][y]/5)-0)*left_jump_speed[b];
          pos_ofs[x][y].w += ((data_sub[x][y]/5)-0)*left_jump_speed[b];
          if (data_sub[x][y] > 0)data_sub[x][y] -= 15;
        } else if (right_jump_list[b]) {
          pos_ofs[x][y].x += 0;
          pos_ofs[x][y].w += ((data_sub[x][y]/5)-0)*right_jump_speed[b];
          if (data_sub[x][y] > 0)data_sub[x][y] -= 15;
        } else if (up_jump_list[b]) {
          pos_ofs[x][y].y += -((data_sub[x][y]/5)-0)*up_jump_speed[b];
          pos_ofs[x][y].h += ((data_sub[x][y]/5)-0)*up_jump_speed[b];
          if (data_sub[x][y] > 0)data_sub[x][y] -= 15;
        } else if (down_jump_list[b]) {
          pos_ofs[x][y].y += 0;
          pos_ofs[x][y].h += ((data_sub[x][y]/5)-0)*down_jump_speed[b];
          if (data_sub[x][y] > 0)data_sub[x][y] -= 15;
        } else
          if (iceteki_list[b]) {
            pos_ofs[x][y].hf = player[0].x < tx;
            pos_ofs[x][y].x = int(pos_ofs[x][y].ofx);
            pos_ofs[x][y].y = round(cos(mob_time/500.0*2*TWO_PI)*1);
            float o = player[0].x - (tx+pos_ofs[x][y].x) + (sin(mob_time/500.0*TWO_PI)*64);
            o /= 16;
            if (o > 2)o = 2;
            if (o < -2)o = -2;
            pos_ofs[x][y].ofx += o;
            if (pos_ofs[x][y].ofx > +64)pos_ofs[x][y].ofx = +64;
            if (pos_ofs[x][y].ofx < -64)pos_ofs[x][y].ofx = -64;
            ;
          } else if (tarai_list[b]) {
            int mxy = 0;
          OUT0:
            for (int Y = 1; Y < data[0].length; Y++) {
              if (y+Y < data[0].length) {
                //
                if (col_list[data[x][y+Y]]) {
                  //println(x, y+Y, data[x][y+Y]);
                  break OUT0;
                }
                mxy = Y;
                //
              } else {
                break OUT0;
              }
            }

            //println(mxy);
            pos_ofs[x][y].ints0 = mxy;
            //
            pos_ofs[x][y].y = int(pos_ofs[x][y].ofy);
            //
            if (pos_ofs[x][y].ofx < pos_ofs[x][y].ofy-4) {
              pos_ofs[x][y].ofy -= 4;
            }
            if (pos_ofs[x][y].ofx > pos_ofs[x][y].ofy+4) {
              pos_ofs[x][y].ofy += (pos_ofs[x][y].y/12.0)+2;
            }
            //
            if (tx+16+12 > player[0].x && tx-12 < player[0].x) {
              if (pos_ofs[x][y].ofy < 4) {
                pos_ofs[x][y].ofx = mxy*16+5;
              }
            } else {
              if (pos_ofs[x][y].ofy > (mxy*16)) {
                pos_ofs[x][y].ofx = 0;
              }
            }
            if (y > 0) {
              pos_ofs[x][y-1].y = pos_ofs[x][y].y;
            }
            //
          } else if (hatena_list[b]) {
            if (data_sub[x][y] == 1) {
              coin(x, y, hatena_num[b]);
            }
            if (data_sub[x][y] > 0 && data_sub[x][y] < 20)data_sub[x][y]--;
          } else if (tama_list[b]) {
            if (col((int)(tx+pos_ofs[x][y].ofx)-8, (int)(ty+pos_ofs[x][y].ofy)-8, 8+4, 32, (int)player[0].x, (int)player[0].y)) {
              pos_ofs[x][y].ofx += 1;
              //println("O!");
            }
            if (col((int)(tx+pos_ofs[x][y].ofx)+8+8-4, (int)(ty+pos_ofs[x][y].ofy)-8, 8+4, 32, (int)player[0].x, (int)player[0].y)) {
              pos_ofs[x][y].ofx -= 1;
              //println("E!");
            }
            //println((pos_ofs[x][y].x+tx), (pos_ofs[x][y].y+ty), player[0].x, player[0].y);
            pos_ofs[x][y].x = (int)pos_ofs[x][y].ofx;
            pos_ofs[x][y].y = (int)pos_ofs[x][y].ofy;
            pos_ofs[x][y].r = (int)pos_ofs[x][y].ofx*4;
          } else {
            pos_ofs[x][y].ofx = 0;
            pos_ofs[x][y].ofy = 0;
            pos_ofs[x][y].xs = 0;
            pos_ofs[x][y].ys = 0;
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
        //
        //
        if (b == of_ons || b == of_ofs) {
          if (data_sub[x][y] == 1) {
            onof = !onof;
            sound_onof.stop();
            sound_onof.trigger();
          }
          if (data_sub[x][y] > 0 && data_sub[x][y] < 20)data_sub[x][y]--;
        }
        //
      }
    }
    for (int y = data[0].length-1; y > 0; y--) {
      for (int x = 0; x < data.length; x++) {
        int b = data[x][y];
        //
        if (tunage_list[b]) {// 下の位置を上に反映(ついでに自分も)
          //
          int gx = 0;
          int gy = 0;
          if (y < data[0].length-1) {
            if (data[x][y+1] >= 128) {
              gx = pos_ofs[x][y+1].x;
              gy = pos_ofs[x][y+1].y;
            }
          }
          if (y > 0) {
            if (data[x][y-1] >= 128) {
              pos_ofs[x][y-1].x += gx;
              pos_ofs[x][y-1].y += gy;
            }
          }
          pos_ofs[x][y].x += gx;
          pos_ofs[x][y].y += gy;
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
    //x*16-scrx+pos_ofs[x][y].x
    for (int y = 0; y < data[0].length; y++) {
      for (int x = 0; x < data.length; x++) {
        //
        int b = data[x][y];
        int X = (x*16+pos_ofs[x][y].x)/16;
        int Y = (y*16+pos_ofs[x][y].y)/16;
        //
        if (X >= 0 && Y >= 0) {
          if (X < data.length && Y < data[0].length-1) {
            //
            if (obake_list[b] || super_obake_list[b] || kinoko_list[b] || tarai_list[b]) {
              data_sub[X][Y] = 2;
              data_sub[X][Y+1] = 2;
            }
            //
          }
        }
        //
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
                if (iceteki_list[data[x][y]]) {
                  image(get_cha(cha, 0x8d), x*16-scrx, y*16+yofs-scry);
                  for (int k = 0; k < 8; k++) {
                    float p = k/8.0;
                    float xx = aida( x*16-scrx, x*16-scrx+pos_ofs[x][y].x, p);
                    float yy = aida( y*16+yofs-scry, y*16+yofs-scry+pos_ofs[x][y].y, p);
                    image(get_cha(cha, 0x87), xx, yy+4+round(sin( (p*8)+(mob_time/240.0)*TWO_PI )*1));
                  }
                }
                //
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
              if (L == 2) {
                if (tarai_list[data[x][y]]) {
                  tint(255, 32);
                  image(get_cha(cha, 0x8f), x*16-scrx, (y+pos_ofs[x][y].ints0)*16+yofs-scry+8);
                  noTint();
                }
              }
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

void map() {
  //
  //
  for (int i = 0; i < map.data.length; i++) {
    for (int f = 0; f < map.data[0].length; f++) {
      ;
      if (getblock(i, f) > 0&& getblock(i, f) <= 31) {
        int d = 1;
        int u = 0x23;
        boolean bou = true;
        if (gbc(i, f, d, u, 0, 0, 0, 0)) {
          setblock(i, f, 0x01, false);
        }
        if (gbc(i, f, d, u, 0, 0, 0, 1)) {
          //setblock(i, f, bou?0x0d:0x01, false);
          setblock(i, f, 0x01, false);
        }
        if (gbc(i, f, d, u, 0, 0, 1, 0)) {
          setblock(i, f, bou?0x0e:0x01, false);
        }
        if (gbc(i, f, d, u, 0, 0, 1, 1)) {
          setblock(i, f, 0x07, false);
        }

        if (gbc(i, f, d, u, 0, 1, 0, 0)) {
          //setblock(i, f, bou?0x0c:0x01, false);
          setblock(i, f, 0x01, false);
        }
        if (gbc(i, f, d, u, 0, 1, 0, 1)) {
          //setblock(i, f, bou?0x0a:0x01, false);
          setblock(i, f, 0x01, false);
        }
        if (gbc(i, f, d, u, 0, 1, 1, 0)) {
          setblock(i, f, 0x06, false);
        }
        if (gbc(i, f, d, u, 0, 1, 1, 1)) {
          setblock(i, f, 0x01, false);
        }

        /////

        if (gbc(i, f, d, u, 1, 0, 0, 0)) {
          setblock(i, f, bou?0x0f:0x03, false);
        }
        if (gbc(i, f, d, u, 1, 0, 0, 1)) {
          setblock(i, f, 0x09, false);
        }
        if (gbc(i, f, d, u, 1, 0, 1, 0)) {
          setblock(i, f, bou?0x0b:0x03, false);
        }
        if (gbc(i, f, d, u, 1, 0, 1, 1)) {
          setblock(i, f, 0x05, false);
        }

        if (gbc(i, f, d, u, 1, 1, 0, 0)) {
          setblock(i, f, 0x08, false);
        }
        if (gbc(i, f, d, u, 1, 1, 0, 1)) {
          setblock(i, f, 0x02, false);
        }
        if (gbc(i, f, d, u, 1, 1, 1, 0)) {
          setblock(i, f, 0x04, false);
        }
        ;
        for (int l = 0; l < 16; l++) {
          if (gbc(i, f, d, u, 1, 1, 1, 1, 1-(l%2), 1-(l/2%2), 1-(l/2/2%2), 1-(l/2/2/2%2), 0)) {
            setblock(i, f, 0x10+l, false);
            //println("nim");
          }
        }
        ;
      }
    }
  }
  //
  for (int i = 0; i < map.data.length; i++) {
    for (int f = 0; f < map.data[0].length; f++) {
      ;
      int d = 0x50;
      int u = 0x60;
      if (getblock(i, f) >= 0x50 && getblock(i, f) < 0x60) {
        //
        if (gbc(i, f, d, u, 0, 0, 0, 0)) {
          setblock(i, f, d+0x0f, false);
        }
        if (gbc(i, f, d, u, 0, 0, 0, 1)) {
          setblock(i, f, d+0x0b, false);
        }
        //
        if (gbc(i, f, d, u, 0, 0, 1, 0)) {
          setblock(i, f, d+0x0c, false);
        }
        if (gbc(i, f, d, u, 0, 0, 1, 1)) {
          setblock(i, f, d+0x02, false);
        }
        //
        //
        //
        //
        if (gbc(i, f, d, u, 0, 1, 0, 0)) {
          setblock(i, f, d+0x09, false);
        }
        if (gbc(i, f, d, u, 0, 1, 0, 1)) {
          setblock(i, f, d+0x0A, false);
        }
        //
        if (gbc(i, f, d, u, 0, 1, 1, 0)) {
          setblock(i, f, d+0x00, false);
        }
        if (gbc(i, f, d, u, 0, 1, 1, 1)) {
          setblock(i, f, d+0x01, false);
        }
        //
        //----------------------------------
        //
        if (gbc(i, f, d, u, 1, 0, 0, 0)) {
          setblock(i, f, d+0x0e, false);
        }
        if (gbc(i, f, d, u, 1, 0, 0, 1)) {
          setblock(i, f, d+0x08, false);
        }
        //
        if (gbc(i, f, d, u, 1, 0, 1, 0)) {
          setblock(i, f, d+0x0d, false);
        }
        if (gbc(i, f, d, u, 1, 0, 1, 1)) {
          setblock(i, f, d+0x05, false);
        }
        //
        //
        //
        //
        if (gbc(i, f, d, u, 1, 1, 0, 0)) {
          setblock(i, f, d+0x06, false);
        }
        if (gbc(i, f, d, u, 1, 1, 0, 1)) {
          setblock(i, f, d+0x07, false);
        }
        //
        if (gbc(i, f, d, u, 1, 1, 1, 0)) {
          setblock(i, f, d+0x03, false);
        }
        if (gbc(i, f, d, u, 1, 1, 1, 1)) {
          setblock(i, f, d+0x04, false);
        }
        //
      }
    }
  }
  //
  //
  //
  for (int i = 0; i < map.data.length; i++) {
    for (int f = 0; f < map.data[0].length; f++) {
      ;
      int d = 0x60;
      int u = 0x70;
      if (getblock(i, f) >= 0x60 && getblock(i, f) < 0x70) {
        //
        if (gbc(i, f, d, u, 0, 0, 0, 0)) {
          setblock(i, f, d+0x0f, false);
        }
        if (gbc(i, f, d, u, 0, 0, 0, 1)) {
          setblock(i, f, d+0x0b, false);
        }
        //
        if (gbc(i, f, d, u, 0, 0, 1, 0)) {
          setblock(i, f, d+0x0c, false);
        }
        if (gbc(i, f, d, u, 0, 0, 1, 1)) {
          setblock(i, f, d+0x02, false);
        }
        //
        //
        //
        //
        if (gbc(i, f, d, u, 0, 1, 0, 0)) {
          setblock(i, f, d+0x09, false);
        }
        if (gbc(i, f, d, u, 0, 1, 0, 1)) {
          setblock(i, f, d+0x0A, false);
        }
        //
        if (gbc(i, f, d, u, 0, 1, 1, 0)) {
          setblock(i, f, d+0x00, false);
        }
        if (gbc(i, f, d, u, 0, 1, 1, 1)) {
          setblock(i, f, d+0x01, false);
        }
        //
        //----------------------------------
        //
        if (gbc(i, f, d, u, 1, 0, 0, 0)) {
          setblock(i, f, d+0x0e, false);
        }
        if (gbc(i, f, d, u, 1, 0, 0, 1)) {
          setblock(i, f, d+0x08, false);
        }
        //
        if (gbc(i, f, d, u, 1, 0, 1, 0)) {
          setblock(i, f, d+0x0d, false);
        }
        if (gbc(i, f, d, u, 1, 0, 1, 1)) {
          setblock(i, f, d+0x05, false);
        }
        //
        //
        //
        //
        if (gbc(i, f, d, u, 1, 1, 0, 0)) {
          setblock(i, f, d+0x06, false);
        }
        if (gbc(i, f, d, u, 1, 1, 0, 1)) {
          setblock(i, f, d+0x07, false);
        }
        //
        if (gbc(i, f, d, u, 1, 1, 1, 0)) {
          setblock(i, f, d+0x03, false);
        }
        if (gbc(i, f, d, u, 1, 1, 1, 1)) {
          setblock(i, f, d+0x04, false);
        }
        //
      }
    }
  }
  //
}

boolean gbc(int x, int y, int f, int t, 
  int u, int r, int d, int l, 
  int lu, int ru, int rd, int ld, int kn) {
  return 
    ((getblock_lmt(x, y-1) >= f && getblock_lmt(x, y-1) < t)^(u == 0)||(u == -1)) && 
    ((getblock_lmt(x+1, y) >= f && getblock_lmt(x+1, y) < t)^(r == 0)||(r == -1)) && 
    ((getblock_lmt(x, y+1) >= f && getblock_lmt(x, y+1) < t)^(d == 0)||(d == -1)) && 
    ((getblock_lmt(x-1, y) >= f && getblock_lmt(x-1, y) < t)^(l == 0)||(l == -1)) &&

    ((getblock_lmt(x-1, y-1) >= f && getblock_lmt(x-1, y-1) < t)^(lu == 0) || (kn == 1)) && 
    ((getblock_lmt(x+1, y-1) >= f && getblock_lmt(x+1, y-1) < t)^(ru == 0) || (kn == 1)) && 
    ((getblock_lmt(x+1, y+1) >= f && getblock_lmt(x+1, y+1) < t)^(rd == 0) || (kn == 1)) && 
    ((getblock_lmt(x-1, y+1) >= f && getblock_lmt(x-1, y+1) < t)^(ld == 0) || (kn == 1));
}
boolean gbc(int x, int y, int f, int t, 
  int u, int r, int d, int l) {
  return gbc(x, y, f, t, u, r, d, l, 0, 0, 0, 0, 1);
}
