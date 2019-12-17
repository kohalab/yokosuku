int bewx = 16;
int bewy = 16;

boolean bewd;

boolean bep;
void bgeditwindow() {
  //8
  image(bgedit_img, bewx, bewy);
  if(bep)image(bgedit_img_v, bewx, bewy);
  for (int i = -2; i < 3; i++) {
    int a = bp+i;
    if (a >= 0 && a < bgblocks.length)image(bgblocks[a], bewx+(i*24)+55, bewy+16);
  }
  if (col(bewx, bewy-2, (bgedit_img.width), 8+4, mouseX/SCALE, (mouseY/SCALE)) && mousePressed) {
    bewd = true;
  }
  if (col(bewx+128, bewy+8, 30, 30, mouseX/SCALE, (mouseY/SCALE)) && !pmousePressed && mousePressed) {
    bep = !bep;
  }
  if (bewd) {
    bewx += (mouseX/SCALE)-(pmouseX/SCALE);
    bewy += (mouseY/SCALE)-(pmouseY/SCALE);
    if (!mousePressed)bewd = false;
  }
}

boolean itbgeditwindow() {
  return col(bewx, bewy, (bgedit_img.width), (bgedit_img.height), mouseX/SCALE, (mouseY/SCALE));
}
