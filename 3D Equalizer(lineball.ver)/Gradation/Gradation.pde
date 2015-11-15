//Gradation
int R;
int G;
int B;
int stage;
void setup() {
  R=255;
  G=0;
  B=0;
  stage=0;
}

void draw() {
  background(R, G, B);
  println(R+","+G+","+B);
  if (stage==0) {
    G++;
    if (G>=255) {
      stage=1;
      G=255;
    }
  }
  if (stage==1) {
    R--;
    if (R<0) {
      stage=2;
      R=0;
    }
  }

  if (stage==2) {
    B++;
    if (B>255) {
      stage=3;
      B=255;
    }
  }
  if (stage==3) {
    G--;
    if (G<0) {
      stage=4;
      G=0;
    }
  }
  if (stage==4) {
    R++;
  }
}

