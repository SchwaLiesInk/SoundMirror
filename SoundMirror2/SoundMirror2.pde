int gtscale=100;
int GT=6;
int GTL=10;
int tmillions=GTL*gtscale;

double lypp;
int frame=0;
int age;
GalaxyScreen gScreen;
Screen cScreen;
void setup() {

  size(1024, 768, P3D);
  background(0);
  gScreen=new GalaxyScreen();  
  cScreen=gScreen;
}

void mousePressed() {
  cScreen.mPressed();
}
void mouseReleased() {
  cScreen.mReleased();
}
void mouseDragged() {

  cScreen.mDragged();
}
void keyPressed() {

  cScreen.kPressed();
}
void keyReleased() {

  cScreen.kReleased();
}
void draw() {

  background(color(0, 0, 0, 0));
  cScreen.Keys();
  lights();
  if (frame<tmillions) {
    cScreen.Draw(); 
    age++;
    if (age%gtscale==0) {
      println((double)(age)/gtscale+" Billion Years");
    }
  } else {

  if(frame==tmillions){
  
    for (int i=0; i<gScreen.layers; i++) {
      gScreen.gal[i].active=false;
    }}
    cScreen.Draw(); 
    //frame++;
    //println((double)(frame)/tscale+" Billion Years");
  }
  frame++;
  if(frame>100){
    frame=0;
    System.gc();
  }
  //if(frame==1000){gScreen.gal.active=false;}
  //if(anim && frame>0){save("D:\\Jones1\\"+frame+".bmp");}
}
