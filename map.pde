void map() {
  for (int i = 0; i < map.data.length; i++) {
    for (int f = 0; f < map.data[0].length; f++) {
      ;
      if (getblock(i, f) > 0&& getblock(i, f) <= 31) {
        int d = 1;
        int u = 0x23;
        boolean bou = true;
        if (gbc(i, f, d, u, 0, 0, 0, 0)) {
          setblock(i, f, 0x01, false);
        }
        if (gbc(i, f, d, u, 0, 0, 0, 1)) {
          setblock(i, f, bou?0x0d:0x01, false);
        }
        if (gbc(i, f, d, u, 0, 0, 1, 0)) {
          setblock(i, f, bou?0x0e:0x01, false);
        }
        if (gbc(i, f, d, u, 0, 0, 1, 1)) {
          setblock(i, f, 0x07, false);
        }

        if (gbc(i, f, d, u, 0, 1, 0, 0)) {
          setblock(i, f, bou?0x0c:0x01, false);
        }
        if (gbc(i, f, d, u, 0, 1, 0, 1)) {
          setblock(i, f, bou?0x0a:0x01, false);
        }
        if (gbc(i, f, d, u, 0, 1, 1, 0)) {
          setblock(i, f, 0x06, false);
        }
        if (gbc(i, f, d, u, 0, 1, 1, 1)) {
          setblock(i, f, 0x01, false);
        }

        /////

        if (gbc(i, f, d, u, 1, 0, 0, 0)) {
          setblock(i, f, bou?0x0f:0x03, false);
        }
        if (gbc(i, f, d, u, 1, 0, 0, 1)) {
          setblock(i, f, 0x09, false);
        }
        if (gbc(i, f, d, u, 1, 0, 1, 0)) {
          setblock(i, f, bou?0x0b:0x03, false);
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
        ;
        for (int l = 0; l < 16; l++) {
          if (gbc(i, f, d, u, 1, 1, 1, 1, 1-(l%2), 1-(l/2%2), 1-(l/2/2%2), 1-(l/2/2/2%2), 0)) {
            setblock(i, f, 0x10+l, false);
            //println("nim");
          }
        }
        ;
      }
    }
  }
}

boolean gbc(int x, int y, int f, int t, 
  int u, int r, int d, int l, 
  int lu, int ru, int rd, int ld, int kn) {
  return 
    ((getblock_lmt(x, y-1) >= f && getblock_lmt(x, y-1) < t)^(u == 0)||(u == -1)) && 
    ((getblock_lmt(x+1, y) >= f && getblock_lmt(x+1, y) < t)^(r == 0)||(r == -1)) && 
    ((getblock_lmt(x, y+1) >= f && getblock_lmt(x, y+1) < t)^(d == 0)||(d == -1)) && 
    ((getblock_lmt(x-1, y) >= f && getblock_lmt(x-1, y) < t)^(l == 0)||(l == -1)) &&

    ((getblock_lmt(x-1, y-1) >= f && getblock_lmt(x-1, y-1) < t)^(lu == 0) || (kn == 1)) && 
    ((getblock_lmt(x+1, y-1) >= f && getblock_lmt(x+1, y-1) < t)^(ru == 0) || (kn == 1)) && 
    ((getblock_lmt(x+1, y+1) >= f && getblock_lmt(x+1, y+1) < t)^(rd == 0) || (kn == 1)) && 
    ((getblock_lmt(x-1, y+1) >= f && getblock_lmt(x-1, y+1) < t)^(ld == 0) || (kn == 1));
}
boolean gbc(int x, int y, int f, int t, 
  int u, int r, int d, int l) {
  return gbc(x, y, f, t, u, r, d, l, 0, 0, 0, 0, 1);
}
