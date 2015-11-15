//rollのtの値が変化してくっようにしたもの
import ddf.minim.analysis.*;
import ddf.minim.*;
Minim minim;
AudioPlayer player;
float velocity = 0;        // tに足す値
float acceleration = 0.05; // velocityに足す値
int count=0;
void setup() {
  size(700, 700, P3D);
  minim=new Minim(this);
  player=minim.loadFile("Bad Apple.mp3", 1024);
  player.play();
  player.loop();
}

void draw() {
  count++;
  if (count>=1024) {
    count=0;
  }
  background(0, 15, 30);

  translate(width/2, height/2, 0);
  rotateX(frameCount*0.01);
  rotateY(frameCount*0.01);

  float lastX = 0, lastY = 0, lastZ = 0;
  float radius = 200;
  float Radius = player.mix.get(count)*700;
  float s = 0, t = 0;

  while (s <= 180) {
    float radianS = radians(s);
    float radianT = radians(t);
    float x = radius * cos(radianS) * sin(radianT);
    float y = radius * cos(radianS) * cos(radianT);
    float z = radius * sin(radianS);

    float X = Radius * cos(radianS) * sin(radianT);
    float Y = Radius * cos(radianS) * cos(radianT);
    float Z = Radius * sin(radianS);

    stroke(0, t*0.05, 128);
    /*if(lastX != 0){
     strokeWeight(1);
     line(x, y, z, lastX, lastY, lastZ);
     }
     strokeWeight(15);
     point(x, y, z);*/
    strokeWeight(2);
    line(x, y, z, X, Y, Z);

    lastX = x;
    lastY = y;
    lastZ = z;

    s++;
    t += velocity;//rollのｔの値をどんどん増やしてくのがこれ
  }
  velocity += acceleration;
}

