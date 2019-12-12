class map_saver {
  map_saver() {
  }
  void save(String path, map map) {
    int w = map.data.length;
    int h = map.data[0].length;
    byte[] nameheader = {
      'Y', 'K', 'S', 'K', //00-03
      '-', 'M', 'a', 'p', //04-07
      'D', 'a', 't', 'a', //08-0b
      ' ', 'V', '0', '4', //0c-0f
    };
    byte[] header = new byte[512];
    for (int i = 0; i < header.length; i++) {
      header[i] = (byte)0xff;
    }
    for (int i = 0; i < nameheader.length; i++) {
      header[i] = nameheader[i];
    }
    header[nameheader.length+0x00] = (byte)(w>>8);
    header[nameheader.length+0x01] = (byte)(w>>0);
    header[nameheader.length+0x02] = (byte)(h>>8);
    header[nameheader.length+0x03] = (byte)(h>>0);
    int maplength = (w*h);
    header[nameheader.length+0x04] = (byte)(maplength>>24);
    header[nameheader.length+0x05] = (byte)(maplength>>16);
    header[nameheader.length+0x06] = (byte)(maplength>> 8);
    header[nameheader.length+0x07] = (byte)(maplength>> 0);
    //
    header[nameheader.length+0x20] = (byte)(year()>>8);
    header[nameheader.length+0x21] = (byte)(year()>>0);
    header[nameheader.length+0x22] = (byte)(month());
    header[nameheader.length+0x23] = (byte)(day());
    header[nameheader.length+0x24] = (byte)(hour());
    header[nameheader.length+0x25] = (byte)(minute());
    header[nameheader.length+0x26] = (byte)(second());

    header[nameheader.length+0x27] = (byte)(frameCount>>24);
    header[nameheader.length+0x28] = (byte)(frameCount>>16);
    header[nameheader.length+0x29] = (byte)(frameCount>> 8);
    header[nameheader.length+0x2A] = (byte)(frameCount>> 0);

    header[nameheader.length+0x40] = (byte)(map.flags>>56);
    header[nameheader.length+0x41] = (byte)(map.flags>>48);
    header[nameheader.length+0x42] = (byte)(map.flags>>40);
    header[nameheader.length+0x43] = (byte)(map.flags>>32);
    header[nameheader.length+0x44] = (byte)(map.flags>>24);
    header[nameheader.length+0x45] = (byte)(map.flags>>16);
    header[nameheader.length+0x46] = (byte)(map.flags>> 8);
    header[nameheader.length+0x47] = (byte)(map.flags>> 0);
    byte[] out = new byte[header.length+maplength+maplength];
    for (int i = 0; i < header.length; i++) {
      out[i] = header[i];
    }
    int name_len = 0;
    for (int i = 0; i < 256; i += 2) {
      out[256+i+1] = '.';
    }
    if (map.name != null) {
      for (int i = 0; i < map.name.length(); i++) {
        out[256+(i*2)+0] = byte(map.name.charAt(i)>>8);//up
        out[256+(i*2)+1] = byte(map.name.charAt(i)>>0);//down
      }
      name_len = map.name.length();
    }
    out[0xff] = (byte)name_len;
    for (int y = 0; y < h; y++) {
      for (int x = 0; x < w; x++) {
        out[header.length+(x+(y*w))] = byte(map.data[x][y]);
      }
    }
    for (int y = 0; y < h; y++) {
      for (int x = 0; x < w; x++) {
        out[header.length+(x+(y*w))+maplength] = byte(map.bg_data[x][y]);
      }
    }
    saveBytes(path, out);
  }
  int loadversion(String path) {
    byte[] in = loadBytes(path);
    if (in == null)
      return 0;
    if (in.length < 32)
      return 0;
    int i = -1;
    if (in[15] == ' ') {
      i = (in[14]-'0');
    } else {
      i = ((in[14]-'0')*10)+(in[15]-'0');
    }
    return i;
  }
  map load(String path) {
    int v = loadversion(path);
    if (v < 3) {
      return load_3(path);
    } else
      if (v >= 3) {
        return null;
      } else {
        return null;
      }
  }
  map load_3(String path) {
    int data_offset = 32;
    byte[] in = loadBytes(path);
    byte[] header = {'Y', 'K', 'S', 'K'};
    boolean yes = true;
    if (in == null)
      return null;
    if (in .length < data_offset)
      return null;
    for (int i = 0; i < header.length; i++) {
      if (in[i] != header[i]) {
        yes = false;
      }
    }
    if (yes) {
      map out;
      out = new map(map.data.length, map.data[0].length);
      int w = in[0x10]&0xff;
      int h = in[0x11]&0xff;
      String name = "";
      for (int i = 0; i < 8; i++) {
        int a = in[24+i]&0xff;
        if (a != '.') {
          name += char(a);
        }
      }
      if (name.length() > 0) {
        out.name = name;
        //println(name);
      }
      if (w <= map.data.length && h <= map.data[0].length) {
        //println(w, h);
        for (int y = 0; y < h; y++) {
          for (int x = 0; x < w; x++) {
            out.data[x][y+(map.data[0].length-h)] = in[x+(y*w)+data_offset]&0xff;
          }
        }
        //
      } else {
        println("dif size");
        return null;
      }
      return out;
    } else {
      println("not yokosuku map data file");
      return null;
    }
  }

  map load_4(String path) {
    int data_offset = 512;
    byte[] in = loadBytes(path);
    byte[] header = {'Y', 'K', 'S', 'K'};
    int nameheader = 16;
    boolean yes = true;
    if (in == null)
      return null;
    if (in .length < data_offset)
      return null;
    for (int i = 0; i < header.length; i++) {
      if (in[i] != header[i]) {
        yes = false;
      }
    }
    if (yes) {
      map out;
      out = new map(map.data.length, map.data[0].length);
      int maplength = ((in[nameheader+0x04]&0xff)<<24)|((in[nameheader+0x05]&0xff)<<16)|((in[nameheader+0x06]&0xff)<<8)|((in[nameheader+0x07]&0xff)<<0);
      int w = ((in[nameheader+0x00]&0xff)<<8)|((in[nameheader+0x01]&0xff)<<0);
      int h = ((in[nameheader+0x02]&0xff)<<8)|((in[nameheader+0x03]&0xff)<<0);
      String name = "";
      for (int i = 0; i < 128; i++) {
        int a = ((in[256+(i*2+0)]&0xff)<<8)+((in[256+(i*2+1)]&0xff)<<0);
        if (a != '.') {
          name += char(a);
        }
      }
      if (name.length() > 0) {
        out.name = name;
        //println(name);
      }
      if (w <= map.data.length && h <= map.data[0].length) {
        //println(w, h);
        //maplength
        for (int y = 0; y < h; y++) {
          for (int x = 0; x < w; x++) {
            out.data[x][y+(map.data[0].length-h)] = in[x+(y*w)+data_offset]&0xff;
          }
        }
        for (int y = 0; y < h; y++) {
          for (int x = 0; x < w; x++) {
            out.bg_data[x][y+(map.data[0].length-h)] = in[x+(y*w)+data_offset+maplength]&0xff;
          }
        }
        //
      } else {
        println("dif size");
        return null;
      }
      return out;
    } else {
      println("not yokosuku map data file");
      return null;
    }
  }
}
