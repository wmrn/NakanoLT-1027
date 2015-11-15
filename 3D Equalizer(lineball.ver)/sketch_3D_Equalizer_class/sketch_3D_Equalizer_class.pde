//音楽流れるけどplater.left.git(i)の値が取れない
//もしかするとplayer.だからまた置き方が違うかも？
//クラス化断念。
import ddf.minim.*;//この3つのはここに置く！
Minim minim;
AudioPlayer player;

LineBall lineball;

void setup () {
  minim =new Minim(this);//これを先にしないとLoadFileが反応しなくなっちゃう
  lineball = new LineBall();
  AudioPlayer player;
  size (700, 700, P3D);
  colorMode (RGB, 256);
  smooth();
  frameRate (60);
}

void draw () {
  background (0);
  //球の移動

  lineball.display();
  lineball.roll();
  lineball.move();
  lineball.rgb();
  lineball.stop();
}

