boolean debug = false;

int WIDTH = 24;//24
int HEIGH = 12;//12
int SWIDT = 24*6;
int SHEIG = 12*4;

int dw;
int dh;

int SCALE = 2;

int yofs = 0;

int select_height = 32;

PImage cha;
PImage map_cha;
PImage save_box;
PImage save_box_s;
PImage icons;

boolean[] keycode = new boolean[256*256];
boolean[] keys = new boolean[256*256];

String map_save_path = "map_saves/";

int save_load_bank;
float save_load_bank_sm;

map map;

int player_num = 1;

int mobnum = 60;

player[] player = new player[player_num];

mob[] mob = new mob[mobnum];

PGraphics grd;

int save_load_num = 50;
boolean[] load_en = new boolean[save_load_num];
String[] name_load = new String[save_load_num];

PImage[] blocks = new PImage[256];
rect[] rects;
boolean[] blocks_no = new boolean[256];

boolean grd_en = true;

boolean game_en = true;

boolean select_en = true;

void settings() {
  //size(WIDTH*16*SCALE, (HEIGH+1)*16*SCALE+yofs);
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

int[] item_list;

PImage sel_t;

boolean[] col_list = new boolean[256];
boolean[] up_col_list = new boolean[256];
boolean[] down_col_list = new boolean[256];
boolean[] right_col_list = new boolean[256];
boolean[] left_col_list = new boolean[256];

boolean[] up_jump_list = new boolean[256];
boolean[] down_jump_list = new boolean[256];
boolean[] right_jump_list = new boolean[256];
boolean[] left_jump_list = new boolean[256];

float[] up_jump_speed = new float[256];
float[] down_jump_speed = new float[256];
float[] right_jump_speed = new float[256];
float[] left_jump_speed = new float[256];

boolean[] ugo_hor_list = new boolean[256];
float[] ugo_hor_level = new float[256];
boolean[] ugo_ver_list = new boolean[256];
float[] ugo_ver_level = new float[256];

boolean[] taiho_list = new boolean[256];
float[] taiho_level = new float[256];

boolean[] guru_list = new boolean[256];
float[] guru_level = new float[256];

boolean[] tunage_list = new boolean[256];

boolean[] hari_list = new boolean[256];
boolean[] water_list = new boolean[256];
boolean[] hata_list = new boolean[256];
boolean[] obake_list = new boolean[256];
boolean[] aobake_list = new boolean[256];
boolean[] super_obake_list = new boolean[256];
boolean[] iceteki_list = new boolean[256];
boolean[] tarai_list = new boolean[256];

boolean[] milk_list = new boolean[256];
boolean[] poteto_list = new boolean[256];
boolean[] kinoko_list = new boolean[256];

boolean[] hatena_list = new boolean[256];
int[] hatena_num = new int[256];

int[] sector;

//milk_list.txt

map_saver map_saver;

PImage space;

void setup() {
  space = createImage(16, 16, ARGB);
  map_saver = new map_saver();
  loadSound();
  r10 = loadFont("10r.vlw");
  b10 = loadFont("10b.vlw");
  r12 = loadFont("12r.vlw");
  b12 = loadFont("12b.vlw");
  map = new map(SWIDT, SHEIG);
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
  //sel_t.save("sel_t.png");

  //println(blocks_no);

  String[] il = loadStrings("item_list.txt");

  sector = new int[0];
  item_list = new int[il.length];
  for (int i = 0; i < il.length; i++) {
    String a = splitTokens(il[i], "//")[0];
    item_list[i] = unhex(a.substring(0, 1+1));
    if (a.length() >= 3) {
      sector = append(sector, i);
    }
  }

  ;
  block_box = loadImage("block_box.png");
  block_box_n = loadImage("block_box_n.png");
  save_box = loadImage("savebox.png");
  save_box_s = loadImage("savebox_s.png");
  icons = loadImage("icons.png");
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
  for (int i = 0; i < player_num; i++) {
    player[i] = new player();
    player[i].map = map;
    player[i].num = i;
  }
  for (int i = 0; i < mobnum; i++) {
    mob[i] = new mob();
  }
  //
  for (int i = 0; i < 256; i++) {
    col_list[i] = true;
  }
  //

  col_list = no_col_list_gen("no_col.txt");
  up_col_list = no_col_list_gen("up_no_col.txt");
  down_col_list = no_col_list_gen("down_no_col.txt");
  left_col_list = no_col_list_gen("left_no_col.txt");
  right_col_list = no_col_list_gen("right_no_col.txt");


  //
  float[][] ujl = list_float_gen("up_jump_list.txt");
  float[][] djl = list_float_gen("down_jump_list.txt");
  float[][] ljl = list_float_gen("left_jump_list.txt");
  float[][] rjl = list_float_gen("right_jump_list.txt");
  for (int i = 0; i < 256; i++) {
    up_jump_list[i] = ujl[0][i] > 0;
    down_jump_list[i] = djl[0][i] > 0;
    left_jump_list[i] = ljl[0][i] > 0;
    right_jump_list[i] = rjl[0][i] > 0;

    up_jump_speed[i] = ujl[1][i];
    down_jump_speed[i] = djl[1][i];
    left_jump_speed[i] = ljl[1][i];
    right_jump_speed[i] = rjl[1][i];
  }

  float[][] uhl = list_float_gen("ugo_hor_list.txt");
  float[][] uvl = list_float_gen("ugo_ver_list.txt");

  float[][] thl = list_float_gen("taiho_list.txt");

  float[][] grl = list_float_gen("guru_list.txt");

  for (int i = 0; i < 256; i++) {
    ugo_hor_list[i] = uhl[0][i] > 0;
    ugo_hor_level[i] = uhl[1][i];

    ugo_ver_list[i] = uvl[0][i] > 0;
    ugo_ver_level[i] = uvl[1][i];

    guru_list[i] = grl[0][i] > 0;
    guru_level[i] = grl[1][i];

    //

    taiho_list[i] = thl[0][i] > 0;
    taiho_level[i] = thl[1][i];
  }

  tunage_list = col_list_gen("tunage_list.txt");
  //println(up_jump_speed)

  hari_list = col_list_gen("hari_list.txt");
  water_list = col_list_gen("water_list.txt");
  hata_list = col_list_gen("hata_list.txt");
  obake_list = col_list_gen("obake_list.txt");
  aobake_list = col_list_gen("aobake_list.txt");
  super_obake_list = col_list_gen("super_obake_list.txt");
  iceteki_list = col_list_gen("iceteki_list.txt");
  tarai_list = col_list_gen("tarai_list.txt");

  milk_list = col_list_gen("milk_list.txt");
  poteto_list = col_list_gen("poteto_list.txt");
  kinoko_list = col_list_gen("kinoko_list.txt");
  ;


  hatena_list = col_list_gen("hatena_list.txt");
  hatena_num = list_int_gen("hatena_list.txt");


  rects = new rect[256];
  for (int i = 0; i < 256; i++) {
    rects[i] = getrect(blocks[i]);
  }

  //map_saver.save("test.yksm", map);
  //map_saver.load("test.yksm");
  map_cha = cha;

  //test
  ;
  /*
  map test = map_saver.load(map_save_path+"0.yksm");
   String[] testout = new String[test.data[0].length*2+1];
   for (int y = 0; y < test.data[0].length; y++) {
   testout[y*2+0] = "";
   for (int x = 0; x < test.data.length; x++) {
   testout[y*2+0] += "+--";
   }
   testout[y*2+0] += "+";
   testout[y*2+1] = "|";
   for (int x = 0; x < test.data.length; x++) {
   testout[y*2+1] += hex(test.data[x][y], 2);
   testout[y*2+1] += "|";
   }
   }
   testout[testout.length-1] = "";
   for (int x = 0; x < test.data.length; x++) {
   testout[testout.length-1] += "+--";
   }
   testout[testout.length-1] += "+";
   saveStrings("test.txt", testout);
   ;
   */
  //endtest
  col_list[0] = false;
}

boolean[] col_list_gen(String path) {
  boolean[] col_list = new boolean[256];
  for (int i = 0; i < col_list.length; i++) {
    col_list[i] = false;
  }
  //
  String[] il = loadStrings(path);
  for (int i = 0; i < il.length; i++) {
    col_list[unhex(il[i].substring(0, 2))] = true;
  }
  return col_list;
}

float[][] list_float_gen(String path) {
  float[][] list = new float[2][256];
  //
  for (int i = 0; i < 256; i++) {
    list[0][i] = -1;
    list[1][i] = 1;
  }
  String[] il = loadStrings(path);
  for (int i = 0; i < il.length; i++) {
    String a = il[i];
    String[] b = splitTokens(a, " ");
    if (b.length == 1) {
      list[0][unhex(b[0])] = 1;
    }
    if (b.length == 2) {
      list[0][unhex(b[0])] = 1;
      list[1][unhex(b[0])] = float(b[1]);
    }
  }
  return list;
}

int[] list_int_gen(String path) {
  int[] list = new int[256];
  //
  for (int i = 0; i < 256; i++) {
    list[i] = 0;
  }
  String[] il = loadStrings(path);
  for (int i = 0; i < il.length; i++) {
    String[] b = splitTokens(il[i], " ");
    list[unhex(b[0])] = int(b[1]);
  }
  return list;
}

boolean[] no_col_list_gen(String path) {
  boolean[] col_list = new boolean[256];
  for (int i = 0; i < col_list.length; i++) {
    col_list[i] = true;
  }
  //
  String[] il = loadStrings(path);
  for (int i = 0; i < il.length; i++) {
    col_list[unhex(il[i].substring(0, 2))] = false;
  }
  return col_list;
}

float speed;

int repsp;

int rpchg = -1;

boolean nowrep;

int mouseX_to_x(int x) {
  //int mx = ((mouseX/SCALE)+scrx)/16;
  //int my = (mouseY+(scry*SCALE)-(32*SCALE))/SCALE/16;
  return ((x/SCALE)+scrx)/16;
}

int mouseY_to_y(int y) {
  //int mx = ((mouseX/SCALE)+scrx)/16;
  //int my = (mouseY+(scry*SCALE)-(32*SCALE))/SCALE/16;
  return (y+(scry*SCALE)-(yofs*SCALE))/SCALE/16;
}

void draw() {

  wait_wait = (System.nanoTime()/1000)-wait_wait;

  boolean[] deadnow = new boolean[player_num];
  for (int i = 0; i < player_num; i++) {
    deadnow[i] = player[i].deadnow;
  }

  surface.setSize(WIDTH*16*SCALE, (HEIGH*16+yofs)*SCALE);

  speed = frameRate/30.0;

  textFont(r12);

  //background(#83d5ff);

  if (sp < 0)sp = 0;
  if (sp > item_list.length-1)sp = item_list.length-1;

  int mx = mouseX_to_x(mouseX);
  int my = mouseY_to_y(mouseY);

  tsp = sp;

  if (game_en) {
    if (mouseY/SCALE >= yofs) {  
      if (mousePressed) {
        if (mouseButton == RIGHT)
          tsp = 0;
        setblock(mx, my, item_list[tsp], true);
      }
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
  /*--------------------表示表示表示表示---------------------*/
  if (game_en) {
    map.mob_proc();
  }
  wait_mapdraw = (System.nanoTime()/1000);
  map.draw();
  map.backup();
  wait_mapdraw = (System.nanoTime()/1000)-wait_mapdraw;
  image(map.get().get(scrx, scry, dw, dh), 0, yofs);
  //if (deadnow) {
  //}
  for (int i = 0; i < player_num; i++) {
    player[i].map = map;
    player[i].draw();
    if (game_en) {
      player[i].proc();
    }
  }

  wait_mob = (System.nanoTime()/1000);
  //if (!deadnow) {
  map.mob_draw();
  //}
  wait_mob = (System.nanoTime()/1000)-wait_mob;

  //if (mouseY >= select_height) {
  //blendMode(BLEND);
  //tint(255,128);
  //image(blocks[item_list[tsp]], (mouseX/SCALE)-8, (mouseY/SCALE)-8);
  //noTint();
  //blendMode(BLEND);
  //}

  for (int i = 0; i < mobnum; i++) {
    mob[i].proc();
    mob[i].draw();
  }

  /*--------------------表示表示表示表示---------------------*/

  /*------------------------------------------------------*/

  wait_draw = (System.nanoTime()/1000);
  if (select_en) {
    noStroke();
    fill(#83d5ff);
    rect(0, 0, dw, yofs);
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
  }
  //println(tsp);
  //fill(255, 128);
  //rect((dw/2)-24, 0, 32, 32);
  //baketu

  if (!game_en) {
    noStroke();
    fill(255, 32);
    rect(0, 0, width/SCALE, height/SCALE);
  }

  if (save_load_bank > save_load_num)save_load_bank = save_load_num;
  if (save_load_bank < 0)save_load_bank = 0;
  //println(save_load_bank);
  save_load_bank_sm = (save_load_bank+(save_load_bank_sm*2.0))/3.0;

  if (sl_e) {
    for (int i = 0; i < save_load_num; i++) {
      int alw = 128;
      int xscr = int(save_load_bank_sm*alw);
      String name = " "+i;
      int x = (i*alw)+8-xscr;
      int y = 8;
      if (name_load[i] != null) {
        name = " "+name_load[i];
      }
      textFont(b10);
      /*
      if (button("SAVE"+name, i*alw+2-xscr, 0, btw, (((select_height*SCALE)/3)/2)+1, load_en[i])) {
       sound_son.stop();
       sound_son.trigger();
       map_saver.save(map_save_path+i+".yksm", map);
       loadcheck();
       delay(100);
       }
       if (button("LOAD"+name, i*alw+2-xscr, 0+((select_height*SCALE)/3), btw, (select_height*SCALE/3)-4, load_en[i])) {
       sound_son.stop();
       sound_son.trigger();
       map load = map_saver.load(map_save_path+i+".yksm");
       if (load != null) {
       map = load;
       for (int f = 0; f < player_num; f++) {
       player[f].dead_alway(true);
       }
       } else {
       sound_son.stop();
       sound_err.stop();
       sound_err.trigger();
       }
       loadcheck();
       delay(100);
       }
       if (button("X", i*alw+2-xscr, 0+((select_height*SCALE)/3*2), 10, 12, load_en[i])) {
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
       */
      if (x >= -alw && x < width/SCALE) {
        //
        //name
        if (image_button(save_box.get(0, 0, 64, 16), save_box_s.get(0, 0, 64, 16), x, y)) {
        }

        //save
        if (image_button(save_box.get(64, 0, 32, 16), save_box_s.get(64, 0, 32, 16), x+63, y)) {
          sl_state = 1|(i<<8);
          /*
          sound_son.stop();
           sound_son.trigger();
           map_saver.save(map_save_path+i+".yksm", map);
           loadcheck();
           sl_e = false;
           */
        }

        //load
        if (image_button(save_box.get(96, 0, 32, 16), save_box_s.get(96, 0, 32, 16), x+90, y)) {
          sl_state = 2|(i<<8);
          /*
          sound_son.stop();
           sound_son.trigger();
           map load = map_saver.load(map_save_path+i+".yksm");
           if (load != null) {
           map = load;
           for (int f = 0; f < player_num; f++) {
           player[f].dead_alway(true);
           }
           } else {
           sound_son.stop();
           sound_err.stop();
           sound_err.trigger();
           }
           loadcheck();
           sl_e = false;
           */
        }
        fill(#1155cc);
        text(name, x+1, y+12);
        fill(255);
        text(name, x+1, y+11);
        //
        if (!load_en[i]) {
          stroke(255);
          for (int I = -1; I < 1; I++) {
            for (int F = -1; F < 1; F++) {
              line(x-4+I, y+4+F, x+64+4+I, y+4+8+F);
              line(x-4+I, y+4+8+F, x+64+4+I, y+4+F);
            }
          }
          noStroke();
        }
      }

      //
    }
    if (sl_state != 0) {
      noStroke();
      fill(255, 64);
      rect(0, 0, width/SCALE, height/SCALE);
      String t = "";
      if ((sl_state&0xff) == 1) {
        t = "本当にセーブする？";
      }
      if ((sl_state&0xff) == 2) {
        t = "本当にロードする？";
      }
      textFont(r10);
      entext(t, (width/SCALE/2)-int(textWidth(t)/2), (height/SCALE)/2-16+1, #1155cc, #ffffff);
      //image(icons.get(0, 0, 64, 16), (width/SCALE/2)-96, (height/SCALE)/2
      //image(icons.get(64, 0, 64, 16), (width/SCALE/2)+96-64, (height/SCALE)/2);
      fill(255);
      if (image_button("する", 3, #1155cc, #ffffff, icons.get(0, 0, 64, 16), icons.get(0, 16, 64, 16), (width/SCALE/2)-96, (height/SCALE)/2)) {
        sound_onof.trigger();
        //
        if ((sl_state&0xff) == 1) {//save
          sound_son.stop();
          sound_son.trigger();
          map_saver.save(map_save_path+(sl_state>>8)+".yksm", map);
          loadcheck();
        }
        if ((sl_state&0xff) == 2) {//load
          sound_son.stop();
          sound_son.trigger();
          map load = map_saver.load(map_save_path+(sl_state>>8)+".yksm");
          if (load != null) {
            map = load;
            for (int f = 0; f < player_num; f++) {
              player[f].dead_alway(true);
            }
          } else {
            sound_son.stop();
            sound_err.stop();
            sound_err.trigger();
          }
          loadcheck();
        }
        //
        sl_state = 0;
      }//yaru
      if (image_button("しない", 3, #1155cc, #ffffff, icons.get(0, 0, 64, 16), icons.get(0, 16, 64, 16), (width/SCALE/2)+96-64, (height/SCALE)/2)) {
        //sound_pop.trigger();
        playpop();
        sl_state = 0;
      }//yaranai
    }
  }

  try {
    image(get(0, 0, dw, dh+yofs), 0, 0, dw*SCALE, (dh+yofs)*SCALE);//スケーリング
  }
  catch(ArrayIndexOutOfBoundsException ex) {
  }
  super_sound();

  //
  game_en = true;
  if (sl_e) {
    game_en = false;
  }
  //
  wait_draw = (System.nanoTime()/1000)-wait_draw;
  debug();
  if (game_en) {
    scrproc();
  }
  smooth_proc();
  /*
  setblock(int(player.x/16)-1, int(player.y/16), 14, false);
   setblock(int(player.x/16), int(player.y/16), 14, false);
   setblock(int(player.x/16)+1, int(player.y/16), 14, false);
   */
  wait_wait = (System.nanoTime()/1000);
}

boolean sl_e;

int sl_state;

void keyPressed() {
  if (game_en) {
    if (keyCode == LEFT  || key == '1')sp -= 1;
    if (keyCode == RIGHT || key == '3')sp += 1;
    if (keyCode == DOWN) {
      //sp -= 4;
    a:
      for (int i = sector.length-1; i >= 0; i--) {
        if (sector[i] < sp) {
          sp = sector[i];
          break a;
        }
      }
    }
    if (keyCode == UP  ) {
      //sp += 4;
    a:
      for (int i = 0; i < sector.length; i++) {
        if (sector[i] > sp) {
          sp = sector[i];
          break a;
        }
      }
    }
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

    if (key == '`') {
      int mx = mouseX_to_x(mouseX);
      int my = mouseY_to_y(mouseY);
      repsp = getblock(mx, my);
      setblock(mx, my, 254, true);
    }
  }
  if (key == '-')frameRate(30);
  if (key == '^')frameRate(60);
  if (key == 'Q') {
    sl_e = !sl_e;
    loadcheck();
  }
  if (sl_e) {
    if (keyCode == LEFT) {
      save_load_bank--;
    }
    if (keyCode == RIGHT) {
      save_load_bank++;
    }
  }
  if (key == 'D')
    debug = !debug;
  if (key == 'S') {
    select_en = !select_en;
  }
  if (key == 'R') {
    frameCount = -1;
  }
}

void keyReleased() {
  keycode[keyCode] = false;
  keys[key] = false;
}

void loadcheck() {
  for (int i = 0; i < save_load_num; i++) {
    map load = map_saver.load(map_save_path+i+".yksm");
    if (load != null) {
      name_load[i] = load.name;
      load_en[i] = true;
    } else {
      name_load[i] = null;
      load_en[i] = false;
    }
  }
}
