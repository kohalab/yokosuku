int scrx_;

void scrproc() {
  int px = (-int(player.x))+(WIDTH/2*16);
  scrx_ = (scrx+(scrx_*4))/5;
  scrx += (-px-scrx_)/20;
  if (scrx < 0)scrx = 0;
  int max = map.data.length*16-(WIDTH*16);
  if (scrx > max)scrx = max;
}

void direct_scr() {
  int px = (-int(player.x))+(WIDTH/2*16);
  scrx = -px;
  if (scrx < 0)scrx = 0;
  int max = map.data.length*16-(WIDTH*16);
  if (scrx > max)scrx = max;
}
