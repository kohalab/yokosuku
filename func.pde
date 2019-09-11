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
