int scrx = 0;
int scrx_;
int scry = 0;
int scry_;

void scrproc() {
  int px = (-int(player.x))+(WIDTH/2*16);
  scrx_ = (scrx+(scrx_*3))/4;
  scrx += (-px-scrx_)/20;
  if (scrx < 0)scrx = 0;
  int maxx = map.data.length*16-(WIDTH*16);
  if (scrx > maxx)scrx = maxx;
  
  int py = (-int(player.y))+(HEIGH/2*16);
  scry_ = (scry+(scry_*3))/4;
  scry += (-py-scry_)/20;
  if (scry < 0)scry = 0;
  int maxy = map.data[0].length*16-(HEIGH*16);
  if (scry > maxy)scry = maxy;
}

void direct_scr() {
  int px = (-int(player.x))+(WIDTH/2*16);
  scrx = -px;
  if (scrx < 0)scrx = 0;
  int max = map.data.length*16-(WIDTH*16);
  if (scrx > max)scrx = max;
  
  
  
  int py = (-int(player.y))+(HEIGH/2*16);
  scry = -py;
  if (scry < 0)scry = 0;
  int maxy = map.data[0].length*16-(HEIGH*16);
  if (scry > maxy)scry = maxy;
}
