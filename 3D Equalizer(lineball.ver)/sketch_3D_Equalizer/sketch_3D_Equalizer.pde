//classを使わないでとりあえず進める 10/18
//長さはmixを使わないで周波数帯？ごとの音量を使うようにした→これがフーリエ変換？使ってる？
//太さはイヤホンの音量のデータを取るやり方を使った。
//回転の部分はぶっちゃけ回ったなかったから排除した
import ddf.minim.analysis.*;
import ddf.minim.*;
Minim minim;
AudioPlayer player;
FFT fft;

//↓書くために必要な値
int num ;//lineの合計の数
float[] xIn;//lineの内と外の座標
float[] yIn;
float[] zIn;
float[] xOut;
float[] yOut;
float[] zOut;
//lineの座標を設定するために座標とは別に半径の値を指定してる
float r;//小さいほうの半径
float R;//大きいほうの半径
//音量のデータの値 これをもとに長さを決めてる
float [] Amix;//本来の波の振れ幅
float difmix;
float[] radian01;//球書くための角度
float[] radian02;

//↓移動させるのに必要な値
float centerX;//球の中心
float centerY;
float centerZ;
float speedX;//球の移動の速さ
float speedY;
float speedZ;

//↓色を決めるのに必要な値
float [] red;//線の一つ一つの色の配色
float [] green;
float [] blue;
float colorR;//色の値を挙げる度合い？
float colorG;
float colorB;


void setup () {
size (700, 700, P3D);
  colorMode (RGB, 256);
  smooth();
  frameRate (60);
  
  minim=new Minim(this);
  player=minim.loadFile("Bad Apple.mp3", 1024);
  player.play();
  player.loop();
  
  //FFTオブジェクトを作成。bufferSize()は1024、sampleRateは再生するサウンドのサンプリングレートによる。
  //通常、44100Hzか22050Hz。このサンプルは22050Hz。
  fft=new FFT(player.bufferSize(), player.sampleRate());
  println("sampling reate is " +player.sampleRate());
  println("spec size is " +fft.specSize());
  println("bandwidth is: " +fft.getBandWidth());
  //BandWidthにiを掛けると、それぞれ何番目のブロックに目当ての周波数が含まれるかが分かる。
  //コンソール（一番したのエリア）を確認すること
  for (int i = 0; i < fft.specSize (); i++) {  
    println(i + " = " + fft.getBandWidth()*i + " ~ "+ fft.getBandWidth()*(i+1));
  }
  
  //↓書くのに必要な値の代入
  num=fft.specSize ();//ブロック×1個 fftの要素分だけlineを配置する
  xIn = new float[num];//lineの内と外の座標
  yIn = new float[num];
  zIn = new float[num];
  xOut = new float[num];
  yOut = new float[num];
  zOut = new float[num];
  Amix = new float[num];//本来の波の振れ幅
  radian01 =  new float[num];//球書くための角度
  radian02 =  new float[num];
  r = 150.0;//固定値
  
  for (int i=1; i<num; i++) {
    radian01[i] = random (360);//ここで一回設定してdrawの方で変更なし
    radian02[i] = random (360);
    
    xIn[i] = r * cos (radians (radian01[i])) * sin (radians (radian02[i]));
    yIn[i] = r * sin (radians (radian01[i]));
    zIn[i] = r * cos (radians (radian01[i])) * cos (radians (radian02[i]));
  }

  //↓移動させるために必要な値の代入
  centerX=-100.0;//球の中心の座標
  centerY=-100.0;
  centerZ=-100.0;
  speedX=1.0;//球の移動速度
  speedY=3.0;
  speedZ=-5.0;

  //↓色を決めるために必要な値の代入
  red=new float [num];//線の一つ一つの色の配色
  green=new float [num];
  blue =new float [num];
  colorR=1;//色のグラデーションのズレ
  colorG=5;
  colorB=10;
  
  red[0]=random(255);//初期値設定
  green[0]=random(255);
  blue[0]=random(255);
  for (int i=1; i<num; i++) {
    red[i]=red[i-1]-colorR;
    if (red[i]<0) {
      red[i]=255;
    }
    green[i]=green[i-1]-colorG;
    if (green[i]<0) {
      green[i]=255;
    } 
    blue[i]=blue[i-1]-colorB;
    if (blue[i]<0) {
      blue[i]=255;
    }
  }
}

void draw () {
background (0);
fft.forward(player.mix);//ここでフーリエ変換？の値を取得してる
  for (int i=0; i<num; i++) {
    camera (Amix[i]*300 - (700 / 2), Amix[i]*300 - (700 / 2), 0.0, width / 2, height / 2, 0.0, 0.0, 1.0, 0.0);
  }
  
  //球の移動壁にぶつかって跳ね返る感じ
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

for (int i=0; i<num; i++) {
   Amix[i]=fft.getBand(i);//フーリエ変換？使ってみた

    difmix = abs (Amix[i]*500 - xIn[i]);//absは絶対値を示す//内側の値との差を求めて線の長さを決めた

    R = (4000 / (difmix + 1)) + r + 1;//ここちょっとよくわかんないけど外側の基準値を設定した

    xOut[i] = R * cos (radians (radian01[i])) * sin (radians (radian02[i]));//ここの部分重要
    yOut[i] = R * sin (radians (radian01[i]));//ここの部分重要
    zOut[i] = R * cos (radians (radian01[i])) * cos (radians (radian02[i]));//ここの部分重要
    stroke (red[i], green[i], blue[i]);//(int (abs (x01[i])), int (abs (y01[i])), int (abs (z01[i])));
    strokeWeight (player.mix.get(i)*5);//太さはイヤホンのLRmixの音量のデータを取るやり方を使った。
    noFill ();
    line (xIn[i], yIn[i], zIn[i], xOut[i], yOut[i], zOut[i]);//長さはmixを使わないで周波数帯？ごとの音量を使うようにした→これがフーリエ変換？使ってる？
  }
  
  //線の色は値をある一定の分だけ増やしたり減らしたりする
  for (int i=0; i<num; i++) {
    red[i]-=colorR;
    if (red[i]<0) {
      colorR=-colorR;
    } else if (red[i]>255) {
      colorR=-colorR;
    }
    green[i]-=colorG;
    if (green[i]<0) {
      colorG=-colorG;
    } else if (green[i]>255) {
      colorG=-colorG;
    }
    blue[i]-=colorB;
    if (blue[i]<0) {
      colorB=-colorB;
    } else if (blue[i]>255) {
      colorB=-colorB;
    }
  }
}
void stop() {
  player.close();
}

