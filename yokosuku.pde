boolean debug = false;

int WIDTH = 24;
int HEIGH = 12;

int dw;
int dh;

int SCALE = 2;

int yofs = 32;

PImage cha;

boolean[] keycode = new boolean[256*256];
boolean[] keys = new boolean[256*256];

String map_save_path = "map_saves/";

map map;

player player;

PGraphics grd;

PImage[] blocks = new PImage[256];
boolean[] blocks_no = new boolean[256];

boolean grd_en = true;

void settings() {
  size(WIDTH*16*SCALE, (HEIGH+1)*16*SCALE+yofs);
  dw = WIDTH*16;
  dh = HEIGH*16;
  noSmooth();
}

PFont r10, b10, r12, b12;

int sp;

int tsp;

float ssp;

float jx, jy;

PImage block_box;
PImage block_box_n;

obj[] obj = new obj[16];

int[] item_list;

PImage sel_t;

boolean[] col_list = new boolean[256];

map_saver map_saver;

void setup() {
  map_saver = new map_saver();
  loadSound();
  r10 = loadFont("10r.vlw");
  b10 = loadFont("10b.vlw");
  r12 = loadFont("12r.vlw");
  b12 = loadFont("12b.vlw");
  map = new map();
  cha = loadImage("data.png");
  ;
  PImage hac = cha.get((255%16)*16, (255/16)*16, 16, 16);
  PGraphics ha = createGraphics(16, 16);
  ha.beginDraw();
  ha.textFont(b10);
  ha.endDraw();
  for (int i = 1; i < 255; i++) {
    if (alpha_nano(cha.get((i%16)*16, (i/16)*16, 16, 16))) {
      ha.beginDraw();
      ha.image(hac, 0, 0);
      ha.fill(0);
      ha.text(hex(i, 2), 1, 16);
      ha.endDraw();
      cha.set((i%16)*16, (i/16)*16, ha);
      blocks_no[i] = true;
    } else {
      blocks_no[i] = false;
    }
  }
  ha = createGraphics(cha.width+16, cha.height+16);
  ha.beginDraw();
  ha.image(cha, 16, 16);
  ha.textFont(b12);
  for (int x = 0; x < 16; x++) {
    ha.fill(0);
    ha.text(hex(x, 1), x*16+24, 16);
  }
  for (int y = 0; y < 16; y++) {
    ha.fill(0);
    ha.text(hex(y, 1), 8, y*16+32);
  }
  ha.endDraw();
  sel_t = ha.get();
  sel_t.save("sel_t.png");

  //println(blocks_no);

  String[] il = loadStrings("item_list.txt");

  item_list = new int[il.length];
  for (int i = 0; i < il.length; i++) {
    item_list[i] = unhex(il[i]);
  }

  ;
  block_box = loadImage("block_box.png");
  block_box_n = loadImage("block_box_n.png");
  frameRate(30);

  grd = createGraphics(dw, dh);
  grd.beginDraw();
  grd.noFill();
  grd.stroke(255, 75);
  for (int f = 0; f < HEIGH; f += 1) {
    for (int i = 0; i < WIDTH; i += 1) {
      grd.rect(i*16, f*16, 15, 15);
    }
  }
  grd.endDraw();
  textFont(b12);
  for (int n = 0; n < 256; n++) {
    blocks[n] = cha.get((n%16)*16, (n/16)*16, 16, 16);
    ;
  }
  if (true) {
    for (int x = 0; x < 4; x++) {
      for (int y = 0; y < 2; y++) {
        map.data[x][map.data[0].length-1-y-1] = 1;
        map.data[x][map.data[0].length-1-y] = 3;
        map.data[x+1][map.data[0].length-1-y] = 5;
      }
    }
    map.data[4][map.data[0].length-1-2] = 7;
  }
  player = new player();
  player.map = map;
  for (int i = 0; i < obj.length; i++) {
    obj[i] = new obj(0, 0, 0, 0, 0, 0, 0);
  }
  for (int i = 0; i < 256; i++) {
    col_list[i] = true;
  }
  col_list[0x81] = false;

  col_list[0xe0] = false;
  col_list[0xe1] = false;
  col_list[0xe2] = false;
  col_list[0xe3] = false;
  col_list[0xe4] = false;
  col_list[0xe5] = false;
  col_list[0xe6] = false;
  col_list[0xe7] = false;
  ;
  ;
  ;
  ;
  //map_saver.save("test.yksm", map);
  //map_saver.load("test.yksm");
}

float speed;

int repsp;

int rpchg = -1;

boolean nowrep;

void new_obj(obj p) {
  int o = int(random(obj.length));
  for (int i = 0; i < obj.length; i++) {
    if (obj[i].type == 0) {
      o = i;
      break;
    }
  }
  obj[o] = p;
}

boolean deadnow = false;

void draw() {

  deadnow = player.deadnow;

  surface.setSize(WIDTH*16*SCALE, (HEIGH*16+yofs)*SCALE);

  speed = frameRate/30.0;

  textFont(r12);

  background(#83d5ff);

  if (sp < 0)sp = 0;
  if (sp > item_list.length-1)sp = item_list.length-1;

  if (mouseY/SCALE >= yofs) {  
    int mx = mouseX/SCALE/16;
    int my = (mouseY-(32*SCALE))/SCALE/16;

    tsp = sp;

    if (mousePressed) {
      if (mouseButton == RIGHT)
        tsp = 0;
      setblock(mx, my, item_list[tsp], true);
    }
  }

  if (!now_rep()) {
    map();
  }


  /*
  for (int Y = 0; Y < HEIGH; Y++) {
   for (int X = 0; X < WIDTH; X++) {
   if (getblock(X, Y) == 13) {
   new_obj(new obj(13, 16, 16, X*16+8, Y*16+8, 0, 0));
   setblock(X, Y, 0, false);
   }
   }
   }
   
   */

  if (frameCount%4 == 0) {

    for (int Y = 0; Y < HEIGH; Y++) {
      for (int X = 0; X < WIDTH; X++) {
        if (getblock(X, Y) == 0xe7)
          setblock(X, Y, 0xe0, false);
        if (getblock(X, Y) == 0xe6)
          setblock(X, Y, 0xe7, false);
        if (getblock(X, Y) == 0xe5)
          setblock(X, Y, 0xe6, false);
        if (getblock(X, Y) == 0xe4)
          setblock(X, Y, 0xe5, false);

        if (getblock(X, Y) == 0xe3)
          setblock(X, Y, 0xe4, false);
        if (getblock(X, Y) == 0xe2)
          setblock(X, Y, 0xe3, false);
        if (getblock(X, Y) == 0xe1)
          setblock(X, Y, 0xe2, false);
        if (getblock(X, Y) == 0xe0)
          setblock(X, Y, 0xe1, false);



        if (getblock(X, Y) == 0x24)
          setblock(X, Y, 0x22, false);
        if (getblock(X, Y) == 0x23)
          setblock(X, Y, 0x24, false);

        if (getblock(X, Y) == 0x27)
          setblock(X, Y, 0x25, false);
        if (getblock(X, Y) == 0x26)
          setblock(X, Y, 0x27, false);

        if (getblock(X, Y) == 0x2a)
          setblock(X, Y, 0x28, false);
        if (getblock(X, Y) == 0x29)
          setblock(X, Y, 0x2a, false);
      }
    }
  }

  /*--------------------表示表示表示表示---------------------*/

  map.draw();
  map.backup();
  image(map.get(), 0, yofs);

  if (deadnow) {
    map.mob_draw();
  }

  player.map = map;
  player.draw();
  player.proc();

  if (!deadnow) {
    map.mob_draw();
  }

  /*--------------------表示表示表示表示---------------------*/

  /*------------------------------------------------------*/

  for (int i = 0; i < 256; i++) {
    int n = (i- ((dw/32)/2) )+tsp;
    if (n >= 0 && n < item_list.length) {
      int scrx = i*32;
      if (scrx >= -32 && scrx < dw) {
        if (n != tsp) {
          image(block_box_n, scrx, 0);
          noStroke();
          image(blocks[item_list[n]], scrx+8+2, 0+8+2, 12, 12);
        }
      }
    }
  }
  int scrx = ((dw/32)/2)*32;
  image(block_box, scrx, 0);
  noStroke();
  ik(blocks[item_list[tsp]], scrx+8, 0+8, sin(frameCount/32.0*TWO_PI)*(item_list[tsp] >= 0x80?8:0));
  //println(tsp);
  //fill(255, 128);
  //rect((dw/2)-24, 0, 32, 32);
  if (debug) {
    textFont(r10);
    fill(0);
    text(nf(frameRate, 2, 4), 1, dh-1);
  }
  //baketu
  int[][] tmp = new int[map.data.length][map.data[0].length];
  for (int i = 0; i < map.data.length; i++) {
    for (int f = 0; f < map.data[0].length; f++) {
      tmp[i][f] = map.data[i][f];
    }
  }

  if (!nowrep) {

    for (int i = 0; i < tmp.length; i++) {
      for (int f = 0; f < tmp[0].length; f++) {
        ;
        if (tmp[i][f] == 254) {
          ;
          if (i > 0) {
            if (tmp[i-1][f] == repsp) {
              setblock(i-1, f, 254, true);
              //map.data[i-1][f] = 254;
              rpchg = 5;
            }
          }
          if (f > 0) {
            if (tmp[i][f-1] == repsp) {
              setblock(i, f-1, 254, true);
              //map.data[i][f-1] = 254;
              rpchg = 5;
            }
          }

          if (i < tmp.length-1 && f >= 0) {
            if (tmp[i+1][f] == repsp) {
              setblock(i+1, f, 254, true);
              //map.data[i+1][f] = 254;
              rpchg = 5;
            }
          }

          if (f < tmp[0].length-1) {
            if (tmp[i][f+1] == repsp) {
              setblock(i, f+1, 254, true);
              //map.data[i][f+1] = 254;
              rpchg = 5;
            }
          }
          ;
        }
        ;
      }
    }
  }

  if (rpchg == 0) {
    wakattawakatta();
    nowrep = true;
  }
  if (nowrep) {
    boolean r = false;
    for (int i = 0; i < tmp.length; i++) {
      for (int f = 0; f < tmp[0].length; f++) {
        if (tmp[i][f] == 254) {
          setblock(i, f, item_list[sp], true);
          //map.data[i][f] = sp;
          r = true;
          break;
        }
      }
    }
    if (!r) {
      nowrep = false;
      wakattawakatta();
    }
  }
  //nowrep

  if (rpchg > -1)rpchg--;
  //baketu

  try {
    image(get(0, 0, dw, dh+yofs), 0, 0, dw*SCALE, (dh+yofs)*SCALE);//スケーリング
  }
  catch(ArrayIndexOutOfBoundsException ex) {
  }
  if (debug) {
    tint(255, 128);
    image(sel_t, 0, 0);
    noTint();
  }
  super_sound();
  if (sl_e) {
    for (int i = 0; i < 10; i++) {
      int alw = width/10;
      int btw = alw-4;
      textFont(r10);
      if (button("SAVE"+i, i*alw+2, 0, btw, ((yofs*SCALE)/3)-4, load_en[i])) {
        sound_son.stop();
        sound_son.trigger();
        map_saver.save(map_save_path+i+".yksm", map);
        loadcheck();
        delay(100);
      }
      if (button("LOAD"+i, i*alw+2, 0+((yofs*SCALE)/3), btw, (yofs*SCALE/3)-4, load_en[i])) {
        sound_son.stop();
        sound_son.trigger();
        map load = map_saver.load(map_save_path+i+".yksm");
        if (load != null) {
          map = load;
          player.dead_alway(true);
        } else {
          sound_son.stop();
          sound_err.stop();
          sound_err.trigger();
        }
        loadcheck();
        delay(100);
      }
      if (button("X", i*alw+2, 0+((yofs*SCALE)/3*2), 10, 12, load_en[i])) {
        map load = map_saver.load(map_save_path+i+".yksm");
        if (load != null) {
          sound_kya.stop();
          sound_kya.trigger();
          saveBytes(map_save_path+i+".yksm", new byte[] {});
        } else {
          sound_err.stop();
          sound_err.trigger();
        }
        loadcheck();
        delay(100);
      }

      //
    }
  }
}

boolean sl_e;

void keyPressed() {
  if (keyCode == LEFT  || key == '1')sp -= 1;
  if (keyCode == RIGHT || key == '3')sp += 1;
  if (keyCode == DOWN)sp -= 4;
  if (keyCode == UP  )sp += 4;
  if (key == '_')sp = 0;

  if (key == '9') {
    grd_en = true;
    map.update();
  }
  if (key == '0') {
    grd_en = false;
    map.update();
  }

  //if (key == 'l')HEIGH++;
  //if (key == 'p')WIDTH++;
  //if (key == 'o')HEIGH--;
  //if (key == 'i')WIDTH--;

  //if (key == 'z') {
  //  new_obj(new obj(13, 16, 16, mouseX, mouseY, 0, 0));
  //}

  keycode[keyCode] = true;
  keys[key] = true;

  if (key == 'K') {
    for (int i = 0; i < 256*256; i++) {
      keycode[i] = false;
      keys[i] = false;
    }
  }

  if (key == 'R') {
    int mx = mouseX/SCALE/16;
    int my = (mouseY-(32*SCALE))/SCALE/16;
    repsp = getblock(mx, my);
    setblock(mx, my, 254, true);
  }
  if (key == 'm')
    all_stop();
  if (key == 'q') {
    sl_e = !sl_e;
    loadcheck();
  }
}

void keyReleased() {
  keycode[keyCode] = false;
  keys[key] = false;
}

void loadcheck() {
  for (int i = 0; i < 10; i++) {
    map load = map_saver.load(map_save_path+i+".yksm");
    if (load != null) {
      load_en[i] = true;
    } else {
      load_en[i] = false;
    }
  }
}

boolean[] load_en = new boolean[10];
