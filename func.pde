boolean alpha_nano(PImage in) {
  boolean e = true;
  for (int i = 0; i < 256; i++) {
    if (alpha(in.get(i%16, i/16)) > 0) {
      e = false;
    }
  }
  return e;
}

boolean col(int x1, int y1, int w1, int h1, int x2, int y2, int w2, int h2) {
  return (x2 < (x1+w1)) && (x1 < (x2+w2)) && (y2 < (y1+h1)) && (y1 < (y2+h2));
}

boolean col(int x1, int y1, int w1, int h1, int x2, int y2) {
  return (x1 <= x2 && x1+w1 > x2) && (y1 <= y2 && y1+h1 > y2);
}

char smal(char in) {
  char out = in;
  if (in >= 'A' && in <= 'Z')
    out += 32;
  return out;
}

void setblock(int mx, int my, int tsp, boolean s) {
  if (mx >= 0 && mx < map.data.length && my >= 0 && my < map.data[0].length) {
    if (s) {
      if (tsp == 0) {
        if (tsp != map.data[mx][my]) {
          //sound_pop.rate(random(0.9, 1.1)-((map.data[mx][my])/500.0));
          sound_pop.trigger();
          //sound_pop.amp(random(0.8, 1));
        }
      } else {
        if (map.data[mx][my] != 0) {
          //sound_pow.amp(random(0.5, 1));
          //sound_pow.rate(random(0.5, 0.6));
          sound_pow.trigger();
        } else {
          //sound_pow.amp(random(0.5, 1));
          //sound_pow.rate(random(0.95, 1.05));
          sound_pow.trigger();
        }
      }
    }
    map.data[mx][my] = tsp;
  }
}

int getblock(int mx, int my) {
  if (mx >= 0 && mx < map.data.length && my >= 0 && my < map.data[0].length) {
    return map.data[mx][my];
  } else {
    return -1;
  }
}

int getblock_lmt(int mx, int my) {
  if (mx < 0)mx = 0;
  if (my < 0)my = 0;
  if (mx > map.data.length-1)mx = map.data.length-1;
  if (my > map.data[0].length-1)my = map.data[0].length-1;
  return map.data[mx][my];
}

boolean now_rep() {
  boolean e = false;
  for (int i = 0; i < map.data.length; i++) {
    for (int f = 0; f < map.data[0].length; f++) {
      if (getblock(i, f) == 254) {
        e = true;
      }
    }
  }
  return e;
}

void ik(PImage data, float x, float y, float k) {
  //x -= (data.width/2);
  //y -= (data.height/2);
  pushMatrix();
  translate(x + (data.width/2), y + (data.height/2));
  rotate(radians(k));
  image(data, 0-data.width/2, 0-data.height/2);  
  popMatrix();
}

PImage frp(PImage in, boolean h, boolean v) {
  PImage out = createImage(in.width, in.height, ARGB);
  for (int y = 0; y < in.height; y++) {
    for (int x = 0; x < in.width; x++) {
      out.set(h?in.width-1-x:x, v?in.height-1-y:y, in.get(x, y));
    }
  }
  return out;
}

PImage dis(PImage in, boolean f) {
  PImage out = createImage(in.width, in.height, ARGB);
  for (int y = 0; y < in.height; y++) {
    for (int x = 0; x < in.width; x++) {
      if (((x+y)%2 == 0)^f) {
        out.set(x, y, in.get(x, y));
      }
    }
  }
  return out;
}

boolean button(String t, int x, int y, int w, int h, boolean e) {
  boolean p = 
    x < mouseX && y < mouseY &&
    mouseX < x+w && mouseY < y+h
    ;
  fill(255, 128);
  if (e)fill(128, 255, 128, 128);
  if (p) {
    fill(0, 128);
    if (e)fill(0, 128, 0, 128);
  }
  stroke(0);
  if (e)stroke(0, 128, 0);
  if (p) {
    stroke(255);
    if (e)stroke(128, 256, 128);
  }
  rect(x, y, w, h);
  fill(0);
  if (p) {
    fill(255);
  }
  text(t, (x+(w/2))-(textWidth(t)/2), (y+(h/2)+5));
  return p&&mousePressed;
}
