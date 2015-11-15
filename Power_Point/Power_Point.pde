PFont myFont;
PImage img;
int Page;

//音楽準備
import ddf.minim.*;
Minim minim;
AudioPlayer bgm;
AudioPlayer crashD;

Ajisai ajisai;

void setup() {
  size(800, 700);
  myFont = createFont("MS-Gothic-48.vlw", 50);
  img=loadImage("ajisai.png");
  minim=new Minim(this);
  ajisai = new Ajisai();
  AudioPlayer bgm;
  AudioPlayer crashD;
  textFont(myFont);
  Page=0;
}

void draw() {
  image(img, 0, 0);
  fill(255, 200);
  noStroke();
  rect(200, 230, 400, 200);
  fill(0);
  textAlign(CENTER);
  textSize(50);
  text("3D Equalizer", width/2, height/2-32);
  textSize(30);
  text("FMS 1年3組48番 和田毬那", width/2, height/2+33);

  if (Page>=1) {
    ajisai.display();
  }
}

void mousePressed() {
  Page++;
  if (Page==1) {
    ajisai.bgm();
  }
  if (Page>=2) {
    ajisai.mouse();
  }
}

