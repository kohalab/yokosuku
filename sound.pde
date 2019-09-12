import processing.sound.*;
SoundFile sound_pow;
SoundFile sound_pop;
SoundFile sound_ping;
SoundFile sound_woo;
SoundFile sound_jon;
SoundFile sound_jmp;
SoundFile sound_dom;
SoundFile sound_boh;
SoundFile sound_pyn;

void loadSound() {
  sound_pow = new SoundFile(this, "sound/pow.wav");
  sound_pop = new SoundFile(this, "sound/pop.wav");
  sound_ping = new SoundFile(this, "sound/ping.wav");
  sound_woo = new SoundFile(this, "sound/woo.wav");
  sound_jon = new SoundFile(this, "sound/jon.wav");
  sound_jmp = new SoundFile(this, "sound/jmp.wav");
  sound_dom = new SoundFile(this, "sound/dom.wav");
  sound_boh = new SoundFile(this, "sound/boh.wav");
  sound_pyn = new SoundFile(this, "sound/pyn.wav");
}
