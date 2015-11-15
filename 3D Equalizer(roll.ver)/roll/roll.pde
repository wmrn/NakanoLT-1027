//周りにballを3つ追加して雰囲気をよくした
import ddf.minim.analysis.*;
import ddf.minim.*;
Minim minim;
AudioPlayer player;
FFT fft;
Object object;

float velocity = 0;// tに足す値
float acceleration = 0.05;// velocityに足す値
int count=0;//半径のgetの値をどの数からとるか決めてる
int colorchange=0;//真ん中のクネクネの色の変化

void setup() {
  size(700, 700, P3D);
  
  minim=new Minim(this);
  player=minim.loadFile("Twinkle twinkle.mp3");
  player.play();
  player.loop();
  fft=new FFT(player.bufferSize(), player.sampleRate());
  
  object=new Object(3);
}

void draw() {
  fft.forward(player.mix);
  background(255);
  
  object.display(3);
  object.move(3);

  translate(width/2, height/2, 0);//画面の中心に移動
  rotateX(frameCount*0.01);//ちょっとずつ回転
  rotateY(frameCount*0.01);

  float radius ;//半径は外と内側の2つ用意する
  float Radius = 200;//固定
  float s = 0, t = 0;//毎回リセットして書き直し
  float weight;
  
　//中心のクネクネを書いてる部分
  while (s <= 180) {//180度回して球が書けることになる
    radius=player.mix.get(count)*700;//周波数の値でpointの表示するrとRの位置の差を作る
    weight=fft.getBand(count)*100;//フーリエ変換の値でpointの円の大きさを変えてる
    
    //色
    noFill();
    if (weight>=100) {//フーリエ変換の値が大きすぎると視界の邪魔になるから排除。
      noStroke();
      colorchange++;//値が多きすぎるものが出たのを区切りにcolorchangeする
    } else {
      if(colorchange==0){//規則性が見いだせずに地道にするしかなくなった色の変化のパターン
        stroke(204,40,65,80);
      }else if(colorchange==1){
       stroke(204,40,97,80);
      }else if(colorchange==2){
        stroke(204,62,137,80);
      }else if(colorchange==3){
        stroke(191,81,204,80);
      }else if(colorchange==4){
        stroke(173,81,204,80);
      }else if(colorchange==5){
        stroke(96,61,204,80);
      }else if(colorchange==6){
        stroke(40,70,204,80);
      }else if(colorchange==7){
        stroke(40,119,204,80);
      }else if(colorchange==8){
        stroke(20,151,204,80);
      }else if(colorchange==9){
        stroke(0,187,204,80);
      }else if(colorchange==10){
        stroke(0,204,200,80);
      }else if(colorchange==11){
        stroke(0,204,132,80);
      }else if(colorchange==12){
        stroke(0,204,95,80);
      }else if(colorchange==13){
        stroke(78,204,40,80);
      }else if(colorchange==14){
        stroke(197,204,0,80);
      }else if(colorchange==15){
        stroke(204,139,0,80);
      }else if(colorchange==16){
        stroke(204,92,40,80);
      }else if(colorchange==17){
        stroke(204,61,61,80);
      }
      }
      if(colorchange>=18){//真ん中のところの色のパターンを最初にふり戻す
      colorchange=0;
      }

　　//書くときに回してる角度の代入
    float radianS = radians(s);
    float radianT = radians(t);
    
    //大文字と小文字で半径が違う
    float x = radius * cos(radianS) * sin(radianT);//点で球を書く書き方
    float y = radius * cos(radianS) * cos(radianT);
    float z = radius * sin(radianS);

    float X = Radius * cos(radianS) * sin(radianT);
    float Y = Radius * cos(radianS) * cos(radianT);
    float Z = Radius * sin(radianS);

    strokeWeight(weight);//フーリエ変換した値を点の太さに反映させてる
    point(x, y, z);
    
    s++;//点の数の調整 数が増えると減ってく。
    t += velocity;//rollのｔの値をどんどん増やしてくのがこれ。多角形の角の数が増える
    count++;//whileの中でcount++;して一つ一つのpointでgetする値の部分を変えてる
    if (count>=1024) {
      count=0;
    }
  }
  
//tの値の増やし方を調節してる。多角形の数を増やしたり減らしたりしてる。
if (velocity>30) {
    acceleration=-acceleration;
  } else if (velocity<0) {
    acceleration=-acceleration;
  }
  velocity += acceleration;
}

