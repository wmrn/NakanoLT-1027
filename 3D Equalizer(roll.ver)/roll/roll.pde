//rollのtの値が変化してくっようにしたもの
import ddf.minim.analysis.*;
import ddf.minim.*;
Minim minim;
AudioPlayer player;
FFT fft;

float velocity = 0;        // tに足す値
float acceleration = 0.05; // velocityに足す値
int count=0;
void setup() {
  size(700, 700, P3D);
  minim=new Minim(this);
  player=minim.loadFile("Twinkle twinkle.mp3");
  player.play();
  player.loop();

  fft=new FFT(player.bufferSize(), player.sampleRate());
}

void draw() {
  fft.forward(player.mix);
  background(255);

  translate(width/2, height/2, 0);
  rotateX(frameCount*0.01);
  rotateY(frameCount*0.01);

  float lastX = 0, lastY = 0, lastZ = 0;
  float radius ;//= player.mix.get(count)*700;
  float Radius = 200;//player.mix.get(count)*700;
  float s = 0, t = 0;
  float weight;

  while (s <= 180) {
    radius=player.mix.get(count)*700;

    weight=fft.getBand(count)*100;
    if (weight>=100) {
      stroke(255, 255, 255, 255);
    } else {
      stroke(0, 100, 128, 100);
    }

    float radianS = radians(s);
    float radianT = radians(t);
    float x = radius * cos(radianS) * sin(radianT);
    float y = radius * cos(radianS) * cos(radianT);
    float z = radius * sin(radianS);

    float X = Radius * cos(radianS) * sin(radianT);
    float Y = Radius * cos(radianS) * cos(radianT);
    float Z = Radius * sin(radianS);

    //stroke(0, 100, 128,100);
    strokeWeight(weight);
    point(x, y, z);
    lastX = x;
    lastY = y;
    lastZ = z;

    s++;
    t += velocity;//rollのｔの値をどんどん増やしてくのがこれ
    count++;
    if (count>=1024) {
      count=0;
    }
  }

  velocity += acceleration;
}

