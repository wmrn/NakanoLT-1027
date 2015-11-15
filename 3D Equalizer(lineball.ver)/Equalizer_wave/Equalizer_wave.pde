import ddf.minim.*;
Minim minim;
AudioPlayer player;
void setup(){
  size(600,600,P3D);
  minim=new Minim(this);
  player=minim.loadFile("Bad Apple.mp3");
  player.play();
  player.loop();
}
void draw(){
  background( 0 );
  stroke( random(255), random(255), random(255) );
  for(int i = 0; i < player.left.size()-1; i++)
  {
    line(i, height/2 + player.left.get(i)*100, i+1, height/2 + player.left.get(i+1)*100);
  }
}
void stop(){
  player.close();
}
