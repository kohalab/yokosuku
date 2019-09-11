import processing.sound.*;
SoundFile sound_pow;
SoundFile sound_pop;
SoundFile sound_ping;
SoundFile sound_woo;
SoundFile sound_jon;

void loadSound() {
  sound_pow = new SoundFile(this, "sound/pow.wav");
  sound_pop = new SoundFile(this, "sound/pop.wav");
  sound_ping = new SoundFile(this, "sound/ping.wav");
  sound_woo = new SoundFile(this, "sound/woo.wav");
  sound_jon = new SoundFile(this, "sound/jon.wav");
}
