class mob {
  int seido = 8;
  PImage img;
  int x = -4096*16, y, xs, ys;
  float sr, ss, srr;
  int gravity = (int)(0.35*seido);
  float air = 1.01;
  float rep = 0.5;//反発
  int age = 0;
  void run(PImage i, float ix, float iy, float isr, float iss, float isrr, int a) {
    img = i;
    x = (int)(ix*16*seido);
    y = (int)(iy*16*seido);
    sr = isr;
    ss = iss;
    srr = isrr;
    age = a;
    //
    //0PI = UP | 0.5PI = RIGHT
    sr += random(-srr/2, srr/2);
    xs = (int)(sin(sr)*ss*seido);
    ys = (int)(-cos(sr)*ss*seido);
  }
  mob(float ix, float iy, float ixs, float iys) {
    x = (int)(ix*16*seido);
    y = (int)(iy*16*seido);
    xs = (int)(ixs*seido);
    ys = (int)(iys*seido);
  }
  mob(float ix, float iy) {
    x = (int)(ix*seido);
    y = (int)(iy*seido);
  }
  mob() {
  }
  //x*16-scrx+pos_ofs[x][y].x, y*16+yofs-scry+pos_ofs[x][y].y
  float screenx(float x) {
    return x*1-scrx;
  }
  float screeny(float y) {
    return y*1+yofs-scry;
  }
  void proc() {
    if (img == null)return;
    if (age == 0)return;
    age--;
    //
    float srx = screenx(x/seido);
    float sry = screeny(y/seido);
    if (srx > -img.width && srx < width/SCALE && sry > -img.height && sry < height/SCALE) {
      ys += gravity;
      xs /= air;
      //
      x += xs;
      y += ys;
    } else {
      age = 0;
    }
    //
  }
  void draw() {
    if (img == null)return;
    if (age == 0)return;
    float srx = screenx(x/seido);
    float sry = screeny(y/seido);
    if (srx > -img.width && srx < width/SCALE && sry > -img.height && sry < height/SCALE) {
      image(img, srx, sry);
    }
  }
  boolean en() {
    return age != 0;
  }
}

void runmob(PImage i, float ix, float iy, float isr, float iss, float isrr, int a) {
  int index = int(random(mobnum));
  for (int n = 0; n < mobnum; n++) {
    //
    if (!mob[n].en()) {
      index = n;
    }
    //
  }
  mob[index].run(i, ix, iy, isr, iss, isrr, a);
}

void coin(int x, int y, int n) {
  for (int i = 0; i < n; i++) {
    runmob(blocks[0xE4], x, y-0.5, 0, 3, PI/2, 120);
  }
  sound_cin.trigger();
}

int mobfree() {
  int n = 0;
  for (int i = 0; i < mobnum; i++) {
    if (!mob[i].en()) {
      n++;
    }
  }
  return n;
}
