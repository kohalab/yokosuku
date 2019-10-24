float gravity = 0.35;
float jump_level = 7;
float side_jump_level = 15;
float friction = 1.4;
float nowfriction = 1.3;

boolean speed_fix = true;

void zht(int x, int y) {
  if (x >= 0) {
    stroke(255, 0, 0, 128);
    line(x, 0, x, height);
  }
  if (y >= 0) {
    stroke(0, 255, 0, 128);
    line(0, y, width, y);
  }
}

class player {
  int num = 0;
  boolean bubo = true;
  boolean down;
  boolean lr;
  boolean ark;
  boolean ctr;
  PImage cha;
  boolean debug = false;
  boolean ugokeen = false;
  boolean no_col;
  boolean deadnow;
  int deaddeadtime;
  int muteki_time = 0;
  int muteki_length = 60;

  int jump_cooldown;
  boolean dash;
  int dpw = 16;
  int dph = 32;
  int pw = 16;
  int ph = 32;
  float x, y, xs, ys;
  boolean head_break;
  int atamaitai_time;
  int tiniasiwotuketeiruka = 0;
  int tiniasiwotuketeiruka_max = 2;
  int big;
  int now_col;
  map map;
  int non_ctr_count;
  int jump_count;
  int jump_counter;
  player() {
    cha = loadImage("kari.png");
  }

  float ark_sc;

  boolean first = true;

  boolean otjm = false;

  boolean asl = false;

  void draw() {
    pw = dpw;
    ph = dph;
    if (big == 1) {
      pw *= 2;
      ph *= 2;
    }
    if (big == -1) {
      pw = 9;
      ph = 32;
    }
    if(down){
      ph /= 1.3;
    }
    if (first) {
      dead_alway(true);
      first = false;
    }
    noStroke();
    if (debug) {
      //zht(int(x-(pw>>1)), int(y-ph+yofs));
      //zht(int(x-(pw>>1))+pw, int(y-ph+yofs)+ph);
    }
    //fill(200, 0, 200);
    //rect(x-(pw>>1), y-ph+yofs, pw, ph);
    int t = 0;
    if (non_ctr_count > 60) {
      t = 1;
    }
    if (non_ctr_count > 120) {
      t = (non_ctr_count/40)%2 == 0?2:((non_ctr_count/80)%2 == 0?3:4);
      if ((non_ctr_count/20)%2 == 0) {
        if (non_ctr_count%10 == 0) {
          lr = false;
        }
      } else {
        if (non_ctr_count%10 == 0) {
          lr = true;
        }
      }
      if (non_ctr_count/40%4 == 0) {
        t = 7;
      }
    }
    if (xs > 0.01 || xs < -0.01) {
      if (int(ark_sc) == 0)t = 0;
      if (int(ark_sc) == 1)t = 3;
      if (int(ark_sc) == 2)t = 0;
      if (int(ark_sc) == 3)t = 4;
    }

    if (ys < -0.1) {
      t = 5;
    }
    if (bubo) {
      if (keys['b'] || keys['B']) {
        t = 7;
      }
      if (xs > 0.03 || xs < -0.03) {
        if (int(ark_sc) == 0)t = 0;
        if (int(ark_sc) == 1)t = 3;
        if (int(ark_sc) == 2)t = 0;
        if (int(ark_sc) == 3)t = 4;
      }
    }
    if (atamaitai_time > 0) {
      t = 6;
    }
    if (deadnow) {
      t = 6;
    }
    boolean hf = !lr;
    boolean vf = false;
    if (deadnow) {
      if (ys > 0.4)vf |= true;
    }
    //
    if (muteki_time%2 == 0 || muteki_time == 0) {
      image(frp(cha.get(t*16, 0, 16, 32), hf, vf), x-(pw/2)-scrx, y-ph+yofs+1-scry+((vf?t==2?10:4:0)*((float)ph/dph)), pw, ph);
      if (bubo) {
        if (keys['b'] || keys['B']) {
          image(frp(get_cha(map_cha, 0xf0+(frameCount%2)), frameCount/2%2 == 0, false), x-(pw/2)-scrx, y+yofs+1-scry-(frameCount%2), 16, 8+(frameCount*3%7*1));
          println("bbb");
        }
      }
    }
    //
    if (!ctr) {
      non_ctr_count++;
    } else {
      non_ctr_count = 0;
    }
    if (head_break) {
      atamaitai_time = 10;
    }
    if (atamaitai_time > 0)atamaitai_time--;
    ugokeen = atamaitai_time == 0;
  }
  void proc() {
    //
    float yys = ys;
    if (yys < -15)yys = -15;
    x += xs*(big == -1?2:1);
    y += yys*(big == -1?1.5:1);
    ys += gravity;
    if (big == -1) {
      ys -= gravity/4;
    }

    if (x < pw/2)x = pw/2;
    if (x > (map.data.length*16)-(pw/2))x = (map.data.length*16)-(pw/2);

    head_break = false;

    //---------------dead---------------
    if (y > map.data[0].length*16+ph) {
      if (!deadnow) {
        //sound_woo.amp(1);
        sound_woo.trigger();
      }
      dead(0);
      //y = map.data[0].length*16+ph-10;
    }


    colp();

    ark_sc += (xs > 0?xs:-xs)/10;
    ark_sc = ark_sc%4;

    //----------------------------------
    if (keys['*']) {
      dead(0);
    }
    xs /= nowfriction;
    if (ugokeen && !deadnow) {
      ark = false;
      ctr = false;
      if (keys['a'] || keys['A']) {
        xs -= 0.6*(dash?2:1)*nowfriction/1.3;
        lr = false;
        ark = true;
        ctr = true;
      }
      if (keys['d'] || keys['D']) {
        xs += 0.6*(dash?2:1)*nowfriction/1.3;
        lr = true;
        ark = true;
        ctr = true;
      }
      if ((keys['w'] || keys[' ']) && (tiniasiwotuketeiruka > 0 || keys['_'])) {
        jump_count += 1;
        if (jump_counter == 0) {
          jump_counter = 4;
        }
        ;
      }
      if (jump_counter > 0)jump_counter--;
      if (jump_counter == 0) {
        jump_count = 0;
      }
      if (jump_counter == 1) {
        ys = -gravity*((jump_count/1)+2)*3.5;
        //jump_cooldown = 15;
        ctr = true;
        if (jump_count == 1) {
          sound_ujp.stop();
          sound_ujp.trigger();
        }
        if (jump_count == 2) {
          sound_mjp.stop();
          sound_mjp.trigger();
        }
        if (jump_count >= 3) {
          sound_jmp.stop();
          sound_jmp.trigger();
        }
        //sound_jmp.amp(1);
        otjm = true;
        jump_count = 0;
      }
      down = keys['s'];
      if (down) {
        ys += 0.7;
        y--;
      }

      //println(tiniasiwotuketeiruka);

      dash = keys['f'];
      if (keys['f'])ctr = true;
      if (tiniasiwotuketeiruka > 0) {
        tiniasiwotuketeiruka -= 1;
      }
    }

    if (keys['¥'] || keys['\\']) {
      deadnow = false;
      no_col = false;
    }

    ///////////////////////////////

    if (bubo) {
      if (keys['b'] || keys['B']) {
        y -= 2;
        ys -= gravity*1.045;
      }
    }

    ///////////////////////////////

    if (tiniasiwotuketeiruka > 0 && debug) {
      textFont(b12);
      fill(0);
    }
    if (jump_cooldown > 0 && debug) {
      textFont(b12);
      fill(0);
      text("ジャンプ無敵時間　 "+jump_cooldown, 0, 64);
    }
    if (jump_cooldown > 0)jump_cooldown--;
    dead_alway(false);
    if (muteki_time > 0)muteki_time--;
  }
  //////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////
  void ifblock(int a, int xx, int yy) {
    //pow(2.0, (notenumber - 69.0) / 12.0)
    if (hari_list[a]) {
      dead(0);
      //sound_ping.rate(random(0.95, 1.05));
      //sound_ping.amp(1);
      sound_ping.trigger();
      //sound_ping.amp(random(0.75, 0.8));
    }
    /*
    if (a == 0x22) {
     //sound_jon.rate(random(0.9, 1.1));
     sound_jon.stop();
     sound_jon.trigger();
     //sound_jon.amp(0.3);
     ys -= 8;
     y -= 3;
     setblock(xx, yy, 0x23, false);
     }
     if (a == 0x25) {
     //sound_jon.rate(random(0.9, 1.1));
     sound_jon.stop();
     sound_jon.trigger();
     //sound_jon.amp(0.3);
     xs += 8;
     x += 3;
     setblock(xx, yy, 0x26, false);
     }
     if (a == 0x28) {
     //sound_jon.rate(random(0.9, 1.1));
     sound_jon.stop();
     sound_jon.trigger();
     //sound_jon.amp(0.3);
     xs -= 8;
     x -= 3;
     setblock(xx, yy, 0x29, false);
     }
     */
    if (blocks_no[a] && frameCount%5 == 0) {
      sound_boh.stop();
      //sound_boh.amp(0.25);
      sound_boh.trigger();
      //println("stt"+s);    
      //otjm = false;
    }
    if (obake_list[a] || super_obake_list[a]) {
      //sound_jon.amp(1);
      sound_woo.trigger();
      dead(3);
    }
    if (water_list[a]) {
      ys -= 0.2;
      y -= 0.5;
    }
    if (milk_list[a]) {
      big = 1;
    }
    if (poteto_list[a]) {
      big = 0;
    }
    if (kinoko_list[a]) {
      big = -1;
    }
    if (a == 0x2b) {
      float tx = xs;
      if (tx < 0) {
        xs = (tx > 0?-tx:tx)*1.09;
      } else {
        xs = (tx < 0?-tx:tx)*1.09;
      }
      ark_sc += (xs > 0?xs:-xs)/20;
      ark_sc %= 4;
    }
    if (a == 0x90) {
      xs += 0.35;
    }
    if (a == 0x91) {
      xs -= 0.35;
    }
    //sound_pyn
  }
  //////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////
  void dead(int type) {
    if (muteki_time == 0 || type == 0) {
      if (big == 1) {
        muteki_time = muteki_length;
        big = 0;
        return;
      }
      //y = 0;
      //x = 0;
      deaddeadtime = 0;
      xs = 0;
      ys = -4;
      no_col = true;
      deadnow = true;
    }
  }
  void dead_alway(boolean anyway) {
    if ((no_col && y > map.data[0].length*16+ph && deadnow) || anyway) {
      y = 0;
      x = 16+(num*16);
      xs = 0;
      ys = 0;
      big = 0;
      no_col = false;
      deadnow = false;
      muteki_time = muteki_length;
      for (int yy = 0; yy < map.data[0].length; yy++) {
        if (
          map.data[1][map.data[0].length-1-yy] == 0x00||
          map.data[1][map.data[0].length-1-yy] == 0x06||
          map.data[1][map.data[0].length-1-yy] == 0x07
          ) {
          y = (map.data[1].length-1-yy)*16;
          break;
        }
      }
      deaddeadtime = 0;
      direct_scr();
      dead_map();
    }
    //println(deaddeadtime);
    deaddeadtime++;
    if (deaddeadtime > 65536)deaddeadtime = 65536;
  }
  void colp() {
    nowfriction = friction;
    if (!no_col) {
      /*
      for (int i = 0; i < obj.length; i++) {
       float ox = obj[i].x;
       float oy = obj[i].y;
       int ow = obj[i].pw;
       int oh = obj[i].ph;
       int type = obj[i].type;
       if (type == 13) {//bane
       if (col((int)x, (int)y-ph, pw, ph, (int)ox, (int)oy-oh, ow, oh)) {
       ys -= 1;
       }
       }
       }
       */
      for (int Y = 0; Y < map.data[0].length; Y++) {
        for (int X = 0; X < map.data.length; X++) {
          int ex = (X*16)+map.pos_ofs[X][Y].x;
          int ey = (Y*16)+map.pos_ofs[X][Y].y;
          int w = map.pos_ofs[X][Y].w;
          int h = map.pos_ofs[X][Y].h;
          //
          noStroke();
          boolean iya = true;
          if (col(ex, ey, w, h, int(x), int(y-8)) || col(ex, ey, w, h, int(x), int(y-(ph-8)))) {
            if (map.data[X][Y] != 0 && col_list[map.data[X][Y]]) {
              iya = false;
              //dead();
            }
          }
          if (
            col(ex, ey, w, h, int(x-(pw/2)), int(y-aida(12, (ph-8), 0)))||
            col(ex, ey, w, h, int(x-(pw/2)), int(y-aida(12, (ph-8), 0.25)))||
            col(ex, ey, w, h, int(x-(pw/2)), int(y-aida(12, (ph-8), 0.5)))||
            col(ex, ey, w, h, int(x-(pw/2)), int(y-aida(12, (ph-8), 0.75)))||
            col(ex, ey, w, h, int(x-(pw/2)), int(y-aida(12, (ph-8), 1)))
            ) {
            if (map.data[X][Y] != 0 && iya && col_list[map.data[X][Y]] && left_col_list[map.data[X][Y]]) {
              x = ex+w+(pw/2);
              xs = 0;
              if (right_jump_list[map.data[X][Y]]) {
                map.data_sub[X][Y] = 30;
                sound_jon.stop();
                sound_jon.trigger();
                //map.data[X][Y] = 0x26;
                xs += side_jump_level*right_jump_speed[map.data[X][Y]];
                //x += 2;
                ys -= gravity*2;
              }
            }
          }
          if (
            col(ex, ey, w, h, int(x+(pw/2)), int(y-aida(12, (ph-8), 0)))||
            col(ex, ey, w, h, int(x+(pw/2)), int(y-aida(12, (ph-8), 0.25)))||
            col(ex, ey, w, h, int(x+(pw/2)), int(y-aida(12, (ph-8), 0.5)))||
            col(ex, ey, w, h, int(x+(pw/2)), int(y-aida(12, (ph-8), 0.75)))||
            col(ex, ey, w, h, int(x+(pw/2)), int(y-aida(12, (ph-8), 1)))
            ) {
            if (map.data[X][Y] != 0 && iya && col_list[map.data[X][Y]] && right_col_list[map.data[X][Y]]) {
              x = ex-(pw/2);
              xs = 0;
              if (left_jump_list[map.data[X][Y]]) {
                map.data_sub[X][Y] = 30;
                sound_jon.stop();
                sound_jon.trigger();
                //map.data[X][Y] = 0x29;
                xs -= side_jump_level*left_jump_speed[map.data[X][Y]];
                //x -= 2;
                ys -= gravity*2;
              }
            }
          }
          if (
            col(ex, ey, w, h, int(x-(pw/3)), int(y-ph+2))||
            col(ex, ey, w, h, int(x), int(y-ph+2))||
            col(ex, ey, w, h, int(x+(pw/3)), int(y-ph+2))
            ) {
            if (map.data[X][Y] != 0 && iya && col_list[map.data[X][Y]] && up_col_list[map.data[X][Y]]) {
              head_break = (ys < 0?-ys:ys) > 5;
              ys = ys < 0?-ys:ys;
              sound_dom.stop();
              sound_jmp.stop();
              //sound_dom.amp(1);
              sound_dom.trigger();
              if (down_jump_list[map.data[X][Y]]) {
                map.data_sub[X][Y] = 30;
                sound_jon.stop();
                sound_jon.trigger();
                //map.data[X][Y] = 0x29;
                ys += jump_level*down_jump_speed[map.data[X][Y]];
                //ys += 2;
              }
            }
          }
          if (
            col(ex, ey, w, h, int(x), int(y-ph+1)) || 
            col(ex, ey, w, h, int(x), int(y   +1.5)) ||
            col(ex, ey, w, h, int(x-(pw/2)  -1), int(y-ph+1)) || 
            col(ex, ey, w, h, int(x-(pw/2)  -1), int(y   +1.5)) ||
            col(ex, ey, w, h, int(x+(pw/2)  -0), int(y-ph+1)) || 
            col(ex, ey, w, h, int(x+(pw/2)  -0), int(y   +1.5)) ||
            col(ex, ey, w, h, int(x-(pw/2)  -1), int(y)) || 
            col(ex, ey, w, h, int(x+(pw/2)  -0), int(y))
            ) {
            ifblock(map.data[X][Y], X, Y);
            if (map.data[X][Y] != 0 && col_list[map.data[X][Y]]) {
              now_col = 3;
            }
            //println(map.data[X][Y]);
          }
          if (col(ex, ey, w, h, int(x), int(y+4)) || 
            col(ex, ey, w, h, int(x-(pw/2)  -1), int(y)) || 
            col(ex, ey, w, h, int(x+(pw/2)  -0), int(y))
            ) {
            if (map.data[X][Y] != 0 && col_list[map.data[X][Y]] && down_col_list[map.data[X][Y]]) {
              x += map.pos_ofs[X][Y].xs;
              y += map.pos_ofs[X][Y].ys;
            }
          }
          if (
            col(ex, ey, w, h, int(x-(pw/3)), int(y+1))||
            col(ex, ey, w, h, int(x), int(y+1))||
            col(ex, ey, w, h, int(x+(pw/3)), int(y+1))
            ) {
            if (map.data[X][Y] != 0 && col_list[map.data[X][Y]] && down_col_list[map.data[X][Y]]) {
              if (debug) {
                fill(255, 128);
                rect(ex, ey+yofs, w-1, h-1);
              }
              ys = -0.01;
              if (y < ey+15) {
                y = ey;
              }
              if (up_jump_list[map.data[X][Y]]) {
                map.data_sub[X][Y] = 30;
                sound_jon.stop();
                sound_jon.trigger();
                //map.data[X][Y] = 0x29;
                ys -= jump_level*up_jump_speed[map.data[X][Y]];
                //y -= 2;
              }
              tiniasiwotuketeiruka = tiniasiwotuketeiruka_max;
            }
            if (!down_col_list[map.data[X][Y]]) {
              sound_ohn.stop();
              sound_ohn.trigger();
            }
          }
          //
        }
      }
      if (now_col > -3)now_col--;
      if (now_col <= 0) {
        //println(frameCount+"now");
        nowfriction = 1.2;
      }
    }
  }
}

void wakattawakatta() {
  if (true) {
    sound_pow.stop();
    sound_pop.stop();
  }
}
