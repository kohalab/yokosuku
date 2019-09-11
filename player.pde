float gravity = 0.35;

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
  boolean lr;
  boolean ark;
  boolean ctr;
  PImage cha;
  boolean debug = false;
  boolean ugokeen = false;
  boolean no_col;
  boolean deadnow;
  int deaddeadtime;
  int jump_cooldown;
  boolean dash;
  int pw = 16;
  int ph = 32;
  float x, y, xs, ys;
  boolean head_break;
  int atamaitai_time;
  int tiniasiwotuketeiruka = 0;
  map map;
  int non_ctr_count;
  PImage frp(PImage in, boolean h, boolean v) {
    PImage out = createImage(in.width, in.height, ARGB);
    for (int y = 0; y < in.height; y++) {
      for (int x = 0; x < in.width; x++) {
        out.set(h?in.width-1-x:x, v?in.height-1-y:y, in.get(x, y));
      }
    }
    return out;
  }
  player() {
    cha = loadImage("kari.png");
  }

  float ark_sc;

  boolean first = true;

  void draw() {
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
    if (xs > 0.01 || xs < -0.01) {
      if (int(ark_sc) == 0)t = 0;
      if (int(ark_sc) == 1)t = 3;
      if (int(ark_sc) == 2)t = 0;
      if (int(ark_sc) == 3)t = 4;
    }
    if (ys < -0.1) {
      t = 5;
    }
    if (non_ctr_count > 120) {
      t = (non_ctr_count/40)%2 == 0?2:3;
      if ((non_ctr_count/20)%2 == 0) {
        if (non_ctr_count%10 == 0) {
          lr = false;
        }
      } else {
        if (non_ctr_count%10 == 0) {
          lr = true;
        }
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
    image(frp(cha.get(t*16, 0, 16, 32), hf, vf), x-(pw/2), y-ph+yofs+1, pw, ph);
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
    x += xs/speed;
    y += ys/speed;
    ys += gravity;

    if (x < pw/2)x = pw/2;
    if (x > dw-(pw/2))x = dw-(pw/2);

    head_break = false;

    //---------------dead---------------
    if (y > HEIGH*16+ph) {
      if (!deadnow)
        sound_woo.play();
      dead();
      //y = HEIGH*16+ph-10;
    }


    colp();

    ark_sc += (xs > 0?xs:-xs)/10;
    ark_sc = ark_sc%4;

    //----------------------------------
    xs /= 1.3;
    if (ugokeen && !deadnow) {
      ark = false;
      ctr = false;
      if (keys['a'] || keys['A']) {
        xs -= 0.6*(dash?2:1);
        lr = false;
        ark = true;
        ctr = true;
      }
      if (keys['d'] || keys['D']) {
        xs += 0.6*(dash?2:1);
        lr = true;
        ark = true;
        ctr = true;
      }
      if ((keys['w'] || keys[' ']) && tiniasiwotuketeiruka > 0 && jump_cooldown == 0) {
        ys = -gravity*15;
        jump_cooldown = 15;
        ctr = true;
        sound_jmp.stop();
        sound_jmp.play();
      }
      dash = keys['f'];
      if (keys['f'])ctr = true;
      if (tiniasiwotuketeiruka > 0) {
        tiniasiwotuketeiruka -= 1;
      }
    }

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
  }
  /////////////////////
  void ifblock(int a, int x, int y) {
    if (a == 12) {
      dead();
      sound_ping.rate(random(0.95, 1.05));
      sound_ping.play();
      sound_ping.amp(random(0.75, 0.8));
    }
    if (a == 13) {
      sound_jon.rate(random(0.9, 1.1));
      sound_jon.play();
      ys -= 6;
      setblock(x, y, 14, false);
    }
  }
  /////////////////////
  void dead() {
    //y = 0;
    //x = 0;
    deaddeadtime = 0;
    xs = 0;
    ys = -4;
    no_col = true;
    deadnow = true;
  }
  void dead_alway(boolean anyway) {
    if ((no_col && y > dh+ph && deadnow) || anyway) {
      y = 0;
      x = 0;
      xs = 0;
      ys = 0;
      no_col = false;
      deadnow = false;
      for (int yy = 0; yy < map.data[0].length; yy++) {
        if (map.data[0][map.data[0].length-1-yy] == 1) {
          y = (map.data[0].length-1-yy)*16;
          break;
        }
      }
      deaddeadtime = 0;
    }
    //println(deaddeadtime);
    deaddeadtime++;
    if (deaddeadtime > 65536)deaddeadtime = 65536;
  }
  void colp() {
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
            col(ex, ey, w, h, int(x-(pw/3)), int(y-ph+2))||
            col(ex, ey, w, h, int(x), int(y-ph+2))||
            col(ex, ey, w, h, int(x+(pw/3)), int(y-ph+2))
            ) {
            if (map.data[X][Y] != 0) {
              head_break = (ys < 0?-ys:ys) > 5;
              ys = ys < 0?-ys:ys;
              sound_dom.stop();
              sound_jmp.stop();
              sound_dom.play();
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
              tiniasiwotuketeiruka = 4;
            }
          }
          if (
            col(ex, ey, w, h, int(x), int(y-ph)) || 
            col(ex, ey, w, h, int(x), int(y   )) ||
            col(ex, ey, w, h, int(x-(pw/2)), int(y)) || 
            col(ex, ey, w, h, int(x+(pw/2)), int(y))
            ) {
            ifblock(map.data[X][Y], X, Y);
          }
          //
        }
      }
    }
  }
}

void wakattawakatta() {
  if (sound_pow.isPlaying() || sound_pop.isPlaying()) {
    sound_pow.stop();
    sound_pop.stop();
  }
}

void setblock(int mx, int my, int tsp, boolean s) {
  if (mx >= 0 && mx < WIDTH && my >= 0 && my < HEIGH) {
    if (s) {
      if (tsp != map.data[mx][my]) {
        if (sound_pow.isPlaying() || sound_pop.isPlaying()) {
          //sound_pow.amp(0);
          //sound_pop.amp(0);
        } else {
          if (tsp == 0) {
            sound_pop.rate(random(0.9, 1.1)-((map.data[mx][my])/500.0));
            sound_pop.play();
            sound_pop.amp(random(0.8, 1));
          } else {
            if (map.data[mx][my] != 0) {
              sound_pow.amp(random(0.5, 1));
              sound_pow.rate(random(0.5, 0.6));
              sound_pow.play();
            } else {
              sound_pow.amp(random(0.5, 1));
              sound_pow.rate(random(0.95, 1.05));
              sound_pow.play();
            }
          }
        }
      }
    }
    map.data[mx][my] = tsp;
  }
}

int getblock(int mx, int my) {
  if (mx >= 0 && mx < WIDTH && my >= 0 && my < HEIGH) {
    return map.data[mx][my];
  } else {
    return -1;
  }
}
