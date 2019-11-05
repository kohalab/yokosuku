PGraphics debugl;

long wait_draw;
long wait_mapdraw;
long wait_mob;
long wait_wait;

long all_wait;

// wait_draw = (System.nanoTime()/1000);
// wait_draw = (System.nanoTime()/1000)-wait_draw;

void debug() {
  if (debugl == null) {
    debugl = createGraphics(width, height);
  }
  if (debug) {
    all_wait = wait_draw+wait_mapdraw+wait_mob+wait_wait;
    float wt_draw = (float)wait_draw/all_wait;
    float wt_mapdraw = (float)wait_mapdraw/all_wait;
    float wt_mob = (float)wait_mob/all_wait;
    float wt_wait = (float)wait_wait/all_wait;
    String debugtext = "now debug";
    int sow = (int)(width/1.5);
    int sox = (width/2)-(sow/2);
    int soy = height-30;
    int soh = 10;
    stroke(0);
    fill(255);
    rect(sox, soy, (wt_wait*sow), soh);//
    stroke(255);
    fill(0, 128, 255);
    rect(sox+(wt_wait*sow), soy, (wt_draw*sow), soh);//
    //wait_draw
    stroke(255);
    fill(100, 200, 50);
    rect(sox+(wt_wait*sow)+(wt_draw*sow), soy, (wt_mapdraw*sow), soh);
    //
    stroke(255);
    fill(100, 200, 255);
    rect(sox+(wt_wait*sow)+(wt_draw*sow)+(wt_mapdraw*sow), soy, (wt_mob*sow), soh);
    //
    debugl.beginDraw();
    debugl.clear();
    debugl.textFont(r12);
    //
    debugl.fill(255);
    debugl.text("wait", sox+((wt_wait*sow)/2), soy+8);

    debugl.fill(255);
    debugl.text("draw", sox+(wt_wait*sow)+((wt_draw*sow)/2), soy+8);

    debugl.fill(255);
    debugl.text("mapdraw", sox+(wt_wait*sow)+(wt_draw*sow)+((wt_mapdraw*sow)/2), soy+8);

    debugl.fill(255);
    debugl.text("mob", sox+(wt_wait*sow)+(wt_draw*sow)+(wt_mapdraw*sow)+((wt_mob*sow)/2), soy+8);
    //
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
    text += "sp = "+sp;
    debugl.text(text, width/1.5, 12+(10*0));
    //
    debugl.text(debugtext, width-textWidth(debugtext), height-3);
    debugl.endDraw();
    tint(0);
    for (int f = -1; f < 3; f++) {
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
