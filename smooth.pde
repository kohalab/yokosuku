float[][] _smooth_buffer = new float[16][16];
float float_smooth(float a, int smooth_level, int c) {
  _smooth_buffer[c][0] = a;
  float out = 0;
  for (int f = 0; f < smooth_level; f++) {
    out += _smooth_buffer[c][f];
  }
  out /= smooth_level;
  return out;
}

void smooth_proc() {
  //
  for (int i = 0; i < 16; i++) {
    //
    float[] tmp = copy_float(_smooth_buffer[i]);
    for (int f = 0; f < 16; f++) {
      _smooth_buffer[i][f] = 0;
    }
    for (int f = 0; f < 16-1; f++) {
      _smooth_buffer[i][f+1] = tmp[f];
    }
    //
  }
  //
}

float[] copy_float(float[] in) {
  float[] c = new float[in.length];
  for (int i = 0; i < in.length; i++) {
    c[i] = in[i];
  }
  return c;
}
