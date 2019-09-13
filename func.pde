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
