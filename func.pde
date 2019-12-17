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

boolean col(PImage col, int x1, int y1, int w1, int h1, int x2, int y2) {
  //if(( (x1 <= x2 && x1+w1 > x2) && (y1 <= y2 && y1+h1 > y2) ))println((x2-x1), (y2-y1));
  return getalpha(col, (x2-x1), (y2-y1)) && ( (x1 <= x2 && x1+w1 > x2) && (y1 <= y2 && y1+h1 > y2) );
}


boolean col(PImage col, int x1, int y1, int w1, int h1, int x2, int y2, int w2, int h2) {
  return getalpha(col, (x2-x1), (y2-y1)) && (x2 < (x1+w1)) && (x1 < (x2+w2)) && (y2 < (y1+h1)) && (y1 < (y2+h2));
}

int col_x(int x1, int y1, int w1, int h1, int x2, int y2) {
  return (x2-x1);
}
int col_y(int x1, int y1, int w1, int h1, int x2, int y2) {
  return (y2-y1);
}

boolean simple_button(String txt,int x, int y, int w, int h) {
  boolean p = col(x, y, w, h, mouseX/SCALE, mouseY/SCALE);
  stroke(0);
  fill(p?240:255);
  if (p&&mousePressed)fill(200);
  rect(x, y, w, h);
  fill(0);
  text(txt,x+(w/2)-(textWidth(txt)/2),y+(h/2)+(((-textDescent())+textAscent())/1));
  return p&mousePressed;
}

boolean getalpha(PImage in, int x, int y) {
  if (x >= 0 && y >= 0 && x < in.width && y < in.height) {
    return (((in.get(x, y)>>24) &(1<<7)) != 0 );
  } else {
    return false;
  }
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
          //sound_pop.trigger();
          playpop();
          //sound_pop.amp(random(0.8, 1));
        }
      } else {
        if (map.data[mx][my] != tsp) {
          //sound_pow.amp(random(0.5, 1));
          //sound_pow.rate(random(0.5, 0.6));
          //sound_pow.trigger();
          playpow();
        } else {
          //sound_pow.amp(random(0.5, 1));
          //sound_pow.rate(random(0.95, 1.05));
          //sound_pow.trigger();
          //playpow();
        }
      }
    }
    map.data[mx][my] = tsp;
  }
}
void setbg(int mx, int my, int tsp) {
  if (mx >= 0 && mx < map.data.length && my >= 0 && my < map.data[0].length) {
    map.bg_data[mx][my] = tsp;
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

void ik(PImage data, int x, int y, float k) {
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

boolean image_button(PImage img, PImage imgs, int x, int y) {
  boolean p = 
    x < mouseX/SCALE && y < mouseY/SCALE &&
    mouseX/SCALE < x+img.width && mouseY/SCALE < y+img.height
    ;
  image(p?imgs:img, x, y);
  return p&&mousePressed;
}

boolean image_button(String str, int th, color bg, color fg, PImage img, PImage imgs, int x, int y) {
  boolean p = 
    x < mouseX/SCALE && y < mouseY/SCALE &&
    mouseX/SCALE < x+img.width && mouseY/SCALE < y+img.height
    ;
  image(p?imgs:img, x, y);
  fill(bg);
  text(str, x+(img.width/2)-(textWidth(str)/2), y+(img.height/2)+th+1);
  fill(fg);
  text(str, x+(img.width/2)-(textWidth(str)/2), y+(img.height/2)+th);
  return p&&mousePressed;
}

float aida(float a, float b, float s) {
  return a + ((b-a)*s);
}

void entext(String s, int x, int y, color b, color f) {
  fill(b);
  for (int X = -1; X < 2; X++) {
    for (int Y = -1; Y < 2; Y++) {
      text(s, x+X, y+Y);
    }
  }
  fill(f);
  text(s, x, y);
}

class rect {
  int x = 0;
  int y = 0;
  int w = 0;
  int h = 0;
  rect(int p0, int p1, int p2, int p3) {
    x = p0;
    y = p1;
    w = p2;
    h = p3;
  }
}

rect getrect(PImage in) {
  int X = 0;
  int Y = 0;
  int W = 0;
  int H = 0;
  for (int y = 0; y < in.height; y++) {
    boolean a = false;
    for (int x = 0; x < in.width; x++) {
      if (alpha(in.get(x, y)) > 128) {
        a = true;
      }
    }
    if (a) {
      Y = y;
      break;
    }
  }
  for (int y = 0; y < in.height; y++) {
    boolean a = false;
    for (int x = 0; x < in.width; x++) {
      if (alpha(in.get(x, y)) > 128) {
        a = true;
      }
    }
    if (a) {
      H = y;
    }
  }
  //
  for (int x = 0; x < in.height; x++) {
    boolean a = false;
    for (int y = 0; y < in.width; y++) {
      if (alpha(in.get(x, y)) > 1) {
        a = true;
      }
    }
    if (a) {
      X = x;
      break;
    }
  }
  for (int x = 0; x < in.height; x++) {
    boolean a = false;
    for (int y = 0; y < in.width; y++) {
      if (alpha(in.get(x, y)) > 1) {
        a = true;
      }
    }
    if (a) {
      W = x;
    }
  }
  W -= X;
  H -= Y;
  return new rect(X, Y, W, H);
}
