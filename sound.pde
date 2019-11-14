import ddf.minim.*; 

int popnum = 5;
int pownum = 5;

Minim minim;
AudioOutput out;
//AudioSample sound_pow;
AudioSample[] sound_pow = new AudioSample[popnum];
//AudioSample sound_pop;
AudioSample[] sound_pop = new AudioSample[popnum];
AudioSample sound_ping;
AudioSample sound_woo;
AudioSample sound_jon;


AudioSample sound_jmp;
AudioSample sound_mjp;
AudioSample sound_ujp;

AudioSample sound_dom;
AudioSample sound_boh;
AudioSample sound_pyn;
AudioSample sound_dho;
AudioSample sound_son;
AudioSample sound_err;
AudioSample sound_kya;
AudioSample sound_ohn;

AudioSample sound_onof;

void loadSound() {
  minim = new Minim(this);
  out = minim.getLineOut();
  int buffer_size = 512;
  //sound_pow = minim.loadSample( "sound/pow.wav", buffer_size);
  
  for (int i = 0; i < pownum; i++) {
    sound_pow[i] = minim.loadSample( "sound/pows/"+i+".wav", buffer_size);
  }

  //sound_pop = minim.loadSample( "sound/pop.wav", buffer_size);

  for (int i = 0; i < popnum; i++) {
    sound_pop[i] = minim.loadSample( "sound/pops/"+i+".wav", buffer_size);
  }

  sound_ping= minim.loadSample("sound/ping.wav", buffer_size);
  sound_woo = minim.loadSample( "sound/woo.wav", buffer_size);
  sound_jon = minim.loadSample( "sound/jon.wav", buffer_size);
  sound_jmp = minim.loadSample( "sound/jmp.wav", buffer_size);
  sound_mjp = minim.loadSample( "sound/mjp.wav", buffer_size);
  sound_ujp = minim.loadSample( "sound/ujp.wav", buffer_size);
  sound_dom = minim.loadSample( "sound/dom.wav", buffer_size);
  sound_boh = minim.loadSample( "sound/boh.wav", buffer_size);
  sound_pyn = minim.loadSample( "sound/pyn.wav", buffer_size);
  sound_dho = minim.loadSample( "sound/dho.wav", buffer_size);
  sound_son = minim.loadSample( "sound/son.wav", buffer_size);
  sound_err = minim.loadSample( "sound/err.wav", buffer_size);
  sound_kya = minim.loadSample( "sound/kya.wav", buffer_size);
  sound_ohn = minim.loadSample( "sound/ohn.wav", buffer_size);

  sound_onof = minim.loadSample( "sound/onof.wav", buffer_size);

  float gain = -9;
  for (int i = 0; i < pownum; i++) {
    sound_pow[i].setGain(gain);
  }
  for (int i = 0; i < popnum; i++) {
    sound_pop[i].setGain(gain-6);
  }
  sound_ping.setGain(gain);
  sound_woo.setGain(gain);
  sound_jon.setGain(gain);
  sound_jmp.setGain(gain);
  sound_mjp.setGain(gain);
  sound_ujp.setGain(gain);
  sound_dom.setGain(gain);
  sound_boh.setGain(gain);
  sound_pyn.setGain(gain);
  sound_dho.setGain(gain);
  sound_son.setGain(gain);
  sound_err.setGain(gain);
  sound_kya.setGain(gain);
  sound_ohn.setGain(gain);

  sound_onof.setGain(gain);
}

void super_sound() {
}

void all_stop() {
  for (int i = 0; i < popnum; i++) {
    sound_pow[i].stop();
  }
  for (int i = 0; i < popnum; i++) {
    sound_pop[i].stop();
  }
  sound_ping.stop();
  sound_woo.stop();
  sound_jon.stop();
  sound_jmp.stop();
  sound_dom.stop();
  sound_boh.stop();
  sound_pyn.stop();
  sound_dho.stop();
  sound_son.stop();
  sound_err.stop();
  sound_kya.stop();

  sound_onof.stop();
  /*
  sound_pow.amp(0);
   sound_pop.amp(0);
   sound_ping.amp(0);
   sound_woo.amp(0);
   sound_jon.amp(0);
   sound_jmp.amp(0);
   sound_dom.amp(0);
   sound_boh.amp(0);
   sound_pyn.amp(0);
   sound_dho.amp(0);
   */
}

void playpop() {
  sound_pop[int(random(popnum))].trigger();
}

void stoppop() {
  for (int i = 0; i < popnum; i++) {
    sound_pop[i].stop();
  }
}


void playpow() {
  sound_pow[int(random(pownum))].trigger();
}

void stoppow() {
  for (int i = 0; i < popnum; i++) {
    sound_pow[i].stop();
  }
}
