//一番汚い初期段階
import ddf.minim.*;
Minim minim;
AudioPlayer player;

int num = 700;//lineの合計の数

float[] x01 = new float[num];//lineの端の端の座標
float[] y01 = new float[num];
float[] z01 = new float[num];
float[] x02 = new float[num];
float[] y02 = new float[num];
float[] z02 = new float[num];

float[] deg01 =  new float[num];
float[] deg02 =  new float[num];

float rot_x;//回転角度
float rot_y;
float rot_z;

float amp01;
float amp02;

float range;

float [] offsetx = new float[num];//本来の波の振れ幅
float [] offsety = new float[num];

//ここから下は自分で付け足した値

float centerX;//球の中心
float centerY;
float centerZ;

float speedX;//球の移動の速さ
float speedY;
float speedZ;

float [] red=new float [num];//線の一つ一つの色の配色
float [] green=new float [num];
float [] blue =new float [num];

float colorR;//色の値を挙げる度合い？
float colorG;
float colorB;


void setup () {

  amp01 = 200.0;

  rot_x = 0.0;
  rot_y = 0.0;
  rot_z = 0.0;

  range = 4.0;

  centerX=-100.0;//球の中心の座標
  centerY=-100.0;
  centerZ=-100.0;

  speedX=1.0;//球の移動速度
  speedY=2.0;
  speedZ=-3.0;

  size (700, 700, P3D);
  colorMode (RGB, 256);
  smooth();
  frameRate (60);

  colorR=1;//色のグラデーションのズレ
  colorG=5;
  colorB=10;

  red[0]=random(255);//初期値設定
  green[0]=random(255);
  blue[0]=random(255);

  //
  for (int i=1; i<num; i++) {
    red[i]=red[i-1]-colorR;
    if (red[i]<0) {
      colorR=255;
    }
    green[i]=green[i-1]-colorG;
    if (green[i]<0) {
      colorG=255;
    } 
    blue[i]=blue[i-1]-colorB;
    if (blue[i]<0) {
      colorB=255;
    }
  }

  for (int i = 0; i < num; i++) {
    deg01[i] = random (360);
    deg02[i] = random (360);
  }

  for (int i = 0; i < num; i++) {
    x01[i] = amp01 * cos (radians (deg01[i])) * sin (radians (deg02[i]));
    y01[i] = amp01 * sin (radians (deg01[i]));
    z01[i] = amp01 * cos (radians (deg01[i])) * cos (radians (deg02[i]));
  }
  minim=new Minim(this);
  player=minim.loadFile("Bad Apple.mp3", 700);
  player.play();
  player.loop();
}

void draw () {

  background (0);
  for (int i=0; i<num; i++) {
    camera (offsetx[i]*300 - (width / 2), offsety[i]*300 - (height / 2), 0.0, 
    width / 2, height / 2, 0.0, 
    0.0, 1.0, 0.0);
  }
  //球の移動
  translate (centerX, centerY, centerZ);

  centerX+=speedX;
  if (centerX>250) {
    speedX=-speedX;
  } else if (centerX<-150) {
    speedX=-speedX;
  }
  centerY+=speedY;
  if (centerY>500) {
    speedY=-speedY;
  } else if (centerY<-150) {
    speedY=-speedY;
  }
  centerZ+=speedZ;
  if (centerZ>250) {
    speedZ=-speedZ;
  } else if (centerZ<-150) {
    speedZ=-speedZ;
  }

  rotateX (radians (rot_x));//x軸に沿って回転
  rotateY (radians (rot_y));//y軸に沿って回転
  rotateZ (radians (rot_z));//z軸に沿って回転

  //線の色
  colorR=1;//色のグラデーションのズレ
   colorG=5;
   colorB=10;
   
   red[0]=random(255);//初期値設定
   green[0]=random(255);
   blue[0]=random(255);

  for (int i=1; i<num; i++) {
    red[i]=red[i-1]-colorR;
    if (red[i]<0) {
      colorR=-colorR;
    } else {
      colorR=-colorR;
    }
    green[i]=green[i-1]-colorG;
    if (green[i]<0) {
      colorG=-colorG;
    } else {
      colorG=-colorG;
    }
    blue[i]=blue[i-1]-colorB;
    if (blue[i]<0) {
      colorB=-colorB;
    } else {
      colorB=-colorB;
    }
  }


  for (int i = 0; i < num; i++) {
    offsetx[i]=player.left.get(i);//本来の波の振れ幅
    offsety[i]=player.right.get(i);//
    float diffx = abs (offsetx[i]*500 - x01[i]);
    float diffy = abs (offsety[i]*500 - y01[i]);

    amp02 = (4000 / (diffx + diffy + 1)) + amp01 + 1;

    x02[i] = amp02 * cos (radians (deg01[i])) * sin (radians (deg02[i]));//ここの部分重要
    y02[i] = amp02 * sin (radians (deg01[i]));//ここの部分重要
    z02[i] = amp02 * cos (radians (deg01[i])) * cos (radians (deg02[i]));//ここの部分重要

    stroke (red[i], green[i], blue[i]);//(int (abs (x01[i])), int (abs (y01[i])), int (abs (z01[i])));
    strokeWeight (offsetx[i]*5);
    noFill ();
    line (x01[i], y01[i], z01[i], x02[i], y02[i], z02[i]);
  }
  for (int i=0; i<num; i++) {
    //offsetの値を0～heightの範囲から-range～rangeに置き換えた
    rot_x += map (offsetx[i], 0, width, -range, range);
    rot_y += map (offsety[i], 0, height, -range, range);
    rot_z += ((map (offsetx[i], 0, width, -range, range) + map (offsety[i], 0, height, -range, range)) / 2);
  }
  //saveFrame ();
}
void stop() {
  player.close();
}

