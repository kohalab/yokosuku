void map() {
  for (int i = 0; i < map.data.length; i++) {
    for (int f = 0; f < map.data[0].length; f++) {
      ;
      if (getblock(i, f) > 0&& getblock(i, f) <= 0x13) {
        int d = 1;
        int u = 256;
        boolean bou = false;
        if (gbc(i, f, d, u, 0, 0, 0, 0)) {
          setblock(i, f, 0x01, false);
        }
        if (gbc(i, f, d, u, 0, 0, 0, 1)) {
          setblock(i, f, bou?0x11:0x03, false);
        }
        if (gbc(i, f, d, u, 0, 0, 1, 0)) {
          setblock(i, f, bou?0x12:0x01, false);
        }
        if (gbc(i, f, d, u, 0, 0, 1, 1)) {
          setblock(i, f, 0x07, false);
        }

        if (gbc(i, f, d, u, 0, 1, 0, 0)) {
          setblock(i, f, bou?0x10:0x03, false);
        }
        if (gbc(i, f, d, u, 0, 1, 0, 1)) {
          setblock(i, f, bou?0x0b:0x03, false);
        }
        if (gbc(i, f, d, u, 0, 1, 1, 0)) {
          setblock(i, f, 0x06, false);
        }
        if (gbc(i, f, d, u, 0, 1, 1, 1)) {
          setblock(i, f, 0x01, false);
        }

        /////

        if (gbc(i, f, d, u, 1, 0, 0, 0)) {
          setblock(i, f, bou?0x13:0x03, false);
        }
        if (gbc(i, f, d, u, 1, 0, 0, 1)) {
          setblock(i, f, 0x09, false);
        }
        if (gbc(i, f, d, u, 1, 0, 1, 0)) {
          setblock(i, f, bou?0x0c:0x03, false);
        }
        if (gbc(i, f, d, u, 1, 0, 1, 1)) {
          setblock(i, f, 0x05, false);
        }

        if (gbc(i, f, d, u, 1, 1, 0, 0)) {
          setblock(i, f, 0x08, false);
        }
        if (gbc(i, f, d, u, 1, 1, 0, 1)) {
          setblock(i, f, 0x02, false);
        }
        if (gbc(i, f, d, u, 1, 1, 1, 0)) {
          setblock(i, f, 0x04, false);
        }
        if (gbc(i, f, d, u, 1, 1, 1, 1)) {
          setblock(i, f, 0x03, false);
          //println("nim");
        }
      }
    }
  }
}

boolean gbc(int x, int y, int f, int t, 
  int u, int r, int d, int l) {
  return 
    (getblock(x, y-1) >= f && getblock(x, y-1) < t)^(u == 0) && 
    (getblock(x+1, y) >= f && getblock(x+1, y) < t)^(r == 0) && 
    (getblock(x, y+1) >= f && getblock(x, y+1) < t)^(d == 0) && 
    (getblock(x-1, y) >= f && getblock(x-1, y) < t)^(l == 0);
}
