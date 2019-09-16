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
  boolean bubo = true;
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
  player() {
    cha = loadImage("kari.png");
  }

  float ark_sc;

  boolean first = true;

  boolean otjm = false;

  boolean asl = false;

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
    image(frp(cha.get(t*16, 0, 16, 32), hf, vf), x-(pw/2)-scrx, y-ph+yofs+1, pw, ph);
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
    float yys = ys/speed;
    if (yys < -15)yys = -15;
    x += xs/speed;
    y += yys;
    ys += gravity;

    if (x < pw/2)x = pw/2;
    if (x > (map.data.length*16)-(pw/2))x = (map.data.length*16)-(pw/2);

    head_break = false;

    //---------------dead---------------
    if (y > map.data[0].length*16+ph) {
      if (!deadnow) {
        //sound_woo.amp(1);
        sound_woo.trigger();
      }
      dead();
      //y = map.data[0].length*16+ph-10;
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
        sound_jmp.trigger();
        //sound_jmp.amp(1);
        otjm = true;
      }
      dash = keys['f'];
      if (keys['f'])ctr = true;
      if (tiniasiwotuketeiruka > 0) {
        tiniasiwotuketeiruka -= 1;
      }
    }

    if (bubo) {
      if (keys['b'] || keys['B']) {
        y -= 1;
        ys -= gravity*1.042;
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
  //////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////
  void ifblock(int a, int xx, int yy) {
    //pow(2.0, (notenumber - 69.0) / 12.0)
    if (a == 0x21) {
      dead();
      //sound_ping.rate(random(0.95, 1.05));
      //sound_ping.amp(1);
      sound_ping.trigger();
      //sound_ping.amp(random(0.75, 0.8));
    }
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
    if (blocks_no[a] && frameCount%5 == 0) {
      sound_boh.stop();
      //sound_boh.amp(0.25);
      sound_boh.trigger();
      //println("stt"+s);    
      //otjm = false;
    }
    if (a == 0x80) {
      //sound_jon.amp(1);
      sound_woo.trigger();
      dead();
    }
    if (a == 0x81) {
      ys -= 0.3;
      y -= 0.3;
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
    //sound_pyn
  }
  //////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////
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
      x = 16;
      xs = 0;
      ys = 0;
      no_col = false;
      deadnow = false;
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
      for (int Y = 0; Y < map.data[0].length; Y++) {
        for (int X = 0; X < map.data.length; X++) {
          int ex = X*16;
          int ey = Y*16;
          int w = 16;
          int h = 16;
          //
          noStroke();
          boolean iya = true;
          if (col(ex, ey, w, h, int(x), int(y-8)) || col(ex, ey, w, h, int(x), int(y-(ph-8)))) {
            if (map.data[X][Y] != 0 && col_list[map.data[X][Y]]) {
              iya = false;
              //dead();
            }
          }
          if (col(ex, ey, w, h, int(x-(pw/2)), int(y-(ph-8))) || col(ex, ey, w, h, int(x-(pw/2)), int(y-12))) {
            if (map.data[X][Y] != 0 && iya && col_list[map.data[X][Y]]) {
              x = ex+w+(pw/2);
              xs = 0;
            }
          }
          if (col(ex, ey, w, h, int(x+(pw/2)), int(y-(ph-8))) || col(ex, ey, w, h, int(x+(pw/2)), int(y-12))) {
            if (map.data[X][Y] != 0 && iya && col_list[map.data[X][Y]]) {
              x = ex-(pw/2);
              xs = 0;
            }
          }
          if (
            col(ex, ey, w, h, int(x-(pw/3)), int(y-ph+2))||
            col(ex, ey, w, h, int(x), int(y-ph+2))||
            col(ex, ey, w, h, int(x+(pw/3)), int(y-ph+2))
            ) {
            if (map.data[X][Y] != 0 && iya && col_list[map.data[X][Y]]) {
              head_break = (ys < 0?-ys:ys) > 5;
              ys = ys < 0?-ys:ys;
              sound_dom.stop();
              sound_jmp.stop();
              //sound_dom.amp(1);
              sound_dom.trigger();
            }
          }
          if (
            col(ex, ey, w, h, int(x), int(y-ph+1)) || 
            col(ex, ey, w, h, int(x), int(y   +1.5)) ||
            col(ex, ey, w, h, int(x-(pw/2)-1-0), int(y)) || 
            col(ex, ey, w, h, int(x+(pw/2)  +0), int(y))
            ) {
            ifblock(map.data[X][Y], X, Y);
            //println(map.data[X][Y]);
          }
          if (
            col(ex, ey, w, h, int(x-(pw/3)), int(y+1))||
            col(ex, ey, w, h, int(x), int(y+1))||
            col(ex, ey, w, h, int(x+(pw/3)), int(y+1))
            ) {
            if (map.data[X][Y] != 0 && col_list[map.data[X][Y]]) {
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
          //
        }
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
