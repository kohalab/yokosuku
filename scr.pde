int scrx = 0;
int scrx_;
int scry = 0;
int scry_;

int scrxs = 0;
int scrys = 0;

void scrproc() {
  int tpx = 0;
  int tpy = 0;
  int W = 0;
  for (int i = 0; i < player_num; i++) {
    tpx += player[i].x;
    tpy += player[i].y;
    W++;
  }
  tpx /= W;
  tpy /= W;
  int px = (-int(tpx))+(WIDTH/2*16);
  int py = (-int(tpy))+(HEIGH/2*16);
  scrx_ = (scrx+(scrx_*2))/3;
  
  scrx += int((-px-scrx_)/5)*5/15;
  if (scrx < 0)scrx = 0;
  int maxx = map.data.length*16-(WIDTH*16);
  if (scrx > maxx)scrx = maxx;

  scry_ = (scry+(scry_*2))/3;
  scry += int((-py-scry_)/5)*5/15;
  if (scry < 0)scry = 0;
  int maxy = map.data[0].length*16-(HEIGH*16);
  if (scry > maxy)scry = maxy;
}

void direct_scr() {
  /*
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
  */
}
