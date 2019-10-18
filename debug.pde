PGraphics debugl;

void debug() {
  if (debugl == null) {
    debugl = createGraphics(width, height);
  }
  if (debug) {
    String debugtext = "now debug";
    debugl.beginDraw();
    debugl.clear();
    debugl.textFont(r12);
    debugl.fill(255);
    debugl.text("frameRate = "+nf(frameRate, 2, 4), 1, height-4-20);
    if (map.name != null) {
      debugl.text("map.name = "+map.name, 1, height-4);
    } else {
      debugl.text("map.name = "+"NULL", 1, height-4);
    }
    String text = 
    "player.x  = "+nf(player.x, 0, 0)+"\n"+
    "player.xs = "+nf(player.xs, 0, 0)+"\n"+
    "player.y  = "+nf(player.y, 0, 0)+"\n"+
    "player.ys = "+nf(player.ys, 0, 0)+"\n"
    ;
    debugl.text(text , width/1.5, 12+(10*0));
    //
    debugl.text(debugtext, width-textWidth(debugtext), height);
    debugl.endDraw();
    tint(0);
    for (int f = -1; f < 2; f++) {
      for (int i = -1; i < 2; i++) {
        image(debugl, 0+i, 0+f);
      }
    }
    noTint();
    image(debugl, 0, 0);
  }
  if (debug) {
    tint(255, 128);
    image(sel_t, 0, 0);
    noTint();
  }
}
