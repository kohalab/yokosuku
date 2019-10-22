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
    String text = "";
    for (int i = 0; i < player_num; i++) {
      text += 
        "player["+i+"].x  = "+(player[i].x >= 0?"+":"")+nf(player[i].x, 0, 3)+"\n"+
        "player["+i+"].xs = "+(player[i].xs >= 0?"+":"")+nf(player[i].xs, 0, 3)+"\n"+
        "player["+i+"].y  = "+(player[i].y >= 0?"+":"")+nf(player[i].y, 0, 3)+"\n"+
        "player["+i+"].ys = "+(player[i].ys >= 0?"+":"")+nf(player[i].ys, 0, 3)+"\n";
    }
    ;
    debugl.text(text, width/1.5, 12+(10*0));
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
