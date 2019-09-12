boolean debug = false;

int WIDTH = 35;
int HEIGH = 20;

int dw;
int dh;

int SCALE = 1;

int yofs = 32;

PImage cha;

boolean[] keycode = new boolean[256*256];
boolean[] keys = new boolean[256*256];

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

void setup() {
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

  //println(blocks_no);

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
  for (int x = 0; x < 4; x++) {
    for (int y = 0; y < 2; y++) {
      map.data[x][map.data[0].length-1-y-1] = 1;
      map.data[x][map.data[0].length-1-y] = 3;
      map.data[x+1][map.data[0].length-1-y] = 5;
    }
  }
  map.data[4][map.data[0].length-1-2] = 7;
  player = new player();
  player.map = map;
  for (int i = 0; i < obj.length; i++) {
    obj[i] = new obj(0, 0, 0, 0, 0, 0, 0);
  }
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

void draw() {

  surface.setSize(WIDTH*16*SCALE, (HEIGH+1)*16*SCALE+yofs);

  speed = frameRate/30.0;

  textFont(r12);

  background(#83d5ff);

  if (sp < 0)sp = 0;
  if (sp > 255)sp = 255;

  int mx = mouseX/SCALE/16;
  int my = (mouseY-(32*SCALE))/SCALE/16;

  tsp = sp;

  if (mousePressed) {
    if (mouseButton == RIGHT)
      tsp = 0;
    setblock(mx, my, tsp, true);
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

  if (frameCount%2 == 0) {

    for (int Y = 0; Y < HEIGH; Y++) {
      for (int X = 0; X < WIDTH; X++) {
        if (getblock(X, Y) == 15)
          setblock(X, Y, 13, false);
        if (getblock(X, Y) == 14)
          setblock(X, Y, 15, false);
      }
    }
  }

  map.draw();
  map.backup();
  image(map.get(), 0, yofs);

  player.map = map;
  player.draw();
  player.proc();

  for (int i = 0; i < obj.length; i++) {
    obj[i].draw();
    obj[i].proc();
  }

  /*------------------------------------------------------*/

  for (int i = 0; i < 256; i++) {
    int n = (i- ((dw/32)/2) )+tsp;
    if (n >= 0 && n < 256) {
      int scrx = i*32+16;
      if (scrx >= -32 && scrx < dw) {
        if (n != tsp) {
          image(block_box_n, scrx, 0);
          noStroke();
          image(blocks[n], scrx+8+2, 0+8+2,12,12);
        }
      }
    }
  }
  int scrx = ((dw/32)/2)*32+16;
  image(block_box, scrx, 0);
  noStroke();
  image(blocks[tsp], scrx+8, 0+8);
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
          setblock(i, f, sp, true);
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
    image(get(0, 0, dw, dh+(16*SCALE)), 0, 0, dw*SCALE, (dh+(16*SCALE))*SCALE);//スケーリング
  }
  catch(ArrayIndexOutOfBoundsException ex) {
  }
}

void keyPressed() {
  if (keyCode == LEFT  || key == '1')sp -= 1;
  if (keyCode == RIGHT || key == '3')sp += 1;
  if (keyCode == DOWN)sp -= 16;
  if (keyCode == UP  )sp += 16;
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
    int mx = (mouseX/SCALE)/16;
    int my = ((mouseY-yofs)/SCALE)/16;
    repsp = getblock(mx, my);
    setblock(mx, my, 254, true);
  }
}

void keyReleased() {
  keycode[keyCode] = false;
  keys[key] = false;
}
