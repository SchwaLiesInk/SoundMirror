abstract class Screen {

  Vector cam=new Vector(0, 0, 10);
  Vector angle=new Vector(Math.PI*0.5, Math.PI*0.5, 0);
  Vector lookat=new Vector(0, 0, 0);
  Normal up=new Normal(0, 1, 0);

  double radius=20;
  float spin=0;
  int mx;  
  int my;  
  boolean zoomUp=false;
  boolean zoomDown=false; 
  boolean scaleUp=false;
  boolean scaleDown=false; 
  boolean offCenter=false;
  boolean offUp=false;
  boolean offDown=false; 
  boolean offLeft=false;
  boolean offRight=false; 
  boolean turnLeft=false;
  boolean turnRight=false; 
  boolean turnUp=false;
  boolean turnDown=false; 
  abstract void mPressed();
  abstract void mReleased();
  abstract void mDragged();
  abstract void kPressed();
  abstract void kReleased();
  abstract void Keys();
  abstract void Draw();
}
class GalaxyScreen extends Screen {
  int layers=GT/2;
  Galaxy gal[];
  GalaxyScreen() {
    gal=new Galaxy[layers];
    gal[0]=new Galaxy();
    for (int i=1; i<layers; i++) {
      gal[i]=new Galaxy(gal[0]);
    }
    cam=new Vector();
    cam.x=radius*Math.cos(angle.x);
    cam.z=radius*Math.sin(angle.x);
    cam.y=radius*Math.cos(angle.y);
    lookat=new Vector(0, 0, 0);
    up=new Normal(0, 1, 0);
  }
  void mPressed() {

    mx=(mouseX);
    my=(mouseY);
  }
  void mReleased() {
    mx=(mouseX);
    my=(mouseY);
  }
  void mDragged() {
    /* double x=(mx-mouseX);
     double xs=Math.sqrt(Math.abs(x*Math.PI));
     double y=(my-mouseY);
     double ys=Math.sqrt(Math.abs(y*Math.PI));
     if (x>0) {
     x=Math.PI;
     } else if (x<0) {
     x=-Math.PI;
     }
     if (y>0) {
     y=Math.PI;
     } else if (y<0) {
     y=-Math.PI;
     }
     angle.x-=(double)(x)/width*xs;
     angle.y-=(double)(y)/height*ys;
     if (angle.x<-Math.PI) {
     angle.x+=Math.PI*2;
     } else
     if (angle.x>Math.PI) {
     angle.x-=Math.PI*2;
     }
     if (angle.y<-Math.PI) {
     angle.y+=Math.PI*2;
     } else
     if (angle.y>Math.PI) {
     angle.y-=Math.PI*2;
     }
     cam.x=radius*Math.cos(angle.x);
     cam.z=radius*Math.sin(angle.x);
     cam.y=radius*Math.cos(angle.y);
     mx=(mouseX);
     my=(mouseY);*/
  }
  void kPressed() {

    if (key =='c') {
      offCenter=true;
    }
    if (key =='r') {
      offUp=true;
    } else
      if (key=='f') {
        offDown=true;
      }
    if (key =='q') {
      offRight=true;
    } else
      if (key=='e') {
        offLeft=true;
      }
    /*if (key =='w') {
     zoomUp=true;
     } else
     if (key=='s') {
     zoomDown=true;
     }*/
    if (key =='w') {
      scaleUp=true;
    } else
      if (key=='s') {
        scaleDown=true;
      }
    /* if (keyCode==LEFT) {
     turnLeft=true;
     } else
     if (keyCode==RIGHT) {
     turnRight=true;
     }
     if (keyCode==UP) {
     turnUp=true;
     } else
     if (keyCode==DOWN) {
     turnDown=true;
     }*/
  }
  void kReleased() {

    if (key =='c') {
      offCenter=false;
    }
    if (key =='r') {
      offUp=false;
    } else
      if (key=='f') {
        offDown=false;
      }
    if (key =='q') {
      offRight=false;
    } else
      if (key=='e') {
        offLeft=false;
      }
    /*if (key =='w') {
     zoomUp=false;
     } else
     if (key=='s') {
     zoomDown=false;
     }*/
    if (key =='w') {
      scaleUp=false;
    } else
      if (key=='s') {
        scaleDown=false;
      }
    /*if (keyCode==LEFT) {
     turnLeft=false;
     } else
     if (keyCode==RIGHT) {
     turnRight=false;
     }
     if (keyCode==UP) {
     turnUp=false;
     } else
     if (keyCode==DOWN) {
     turnDown=false;
     }*/
  }
  void Keys() {
    for (int i=0; i<layers; i++) {
      if (offCenter) {
        gal[i].ResetCenter();
        gal[i].ResetScale(frame/gtscale);
        radius=20;
      }
      if (offLeft) {
        gal[i].vx-=gal[i].iscale;
      } else
        if (offRight) {
          gal[i].vx+=gal[i].iscale;
        }
      if (offUp) {
        gal[i].vy+=gal[i].iscale;
      } else
        if (offDown) {
          gal[i].vy-=gal[i].iscale;
        }

      /*if (gal[i].vx>gal[i].scale) {
       gal[i].vx-=gal[i].scale;
       }
       if (gal[i].vy<-gal[i].scale) {
       gal[i].vy+=gal[i].scale;
       }
       if (gal[i].vx<-gal[i].scale) {
       gal[i].vx+=gal[i].scale;
       }
       if (gal[i].vy>gal[i].scale) {
       gal[i].vy-=gal[i].scale;
       }*/
      if (scaleUp) {
        if (gal[i].scale<(gal[i].w*gal[i].h*36000)) {
          gal[i].scale*=1.1;
          gal[i].ResetInvScale();
        }
      }
      if (scaleDown) {
        if (gal[i].scale>((float)(gal[i].h)/gal[i].w)) {
          gal[i].scale*=0.9;
          gal[i].ResetInvScale();
        }
      }
    }

    if (zoomUp) {
      radius*=0.99;
      if (radius<1.25) {
        radius=1.25;
      } 

      cam.x=radius*Math.cos(angle.x);
      cam.z=radius*Math.sin(angle.x);
      cam.y=radius*Math.cos(angle.y);
    } else {
      if (zoomDown) {
        radius*=1.01;
        if (radius>25) {
          radius=25;
        }

        cam.x=radius*Math.cos(angle.x);
        cam.z=radius*Math.sin(angle.x);
        cam.y=radius*Math.cos(angle.y);
      }
    }
    double x=0;
    double y=0;
    if (turnLeft) {
      x-=Math.PI;
    }
    if (turnRight) {
      x+=Math.PI;
    }
    if (turnUp) {
      y-=Math.PI;
    }
    if (turnDown) {
      y+=Math.PI;
    }

    double xs=Math.sqrt(Math.abs(x*Math.PI));
    double ys=Math.sqrt(Math.abs(y*Math.PI));
    angle.x-=(double)(x)/width*xs;
    angle.y-=(double)(y)/height*ys;
    if (angle.x<-Math.PI) {
      angle.x+=Math.PI*2;
    } else
      if (angle.x>Math.PI) {
        angle.x-=Math.PI*2;
      }
    if (angle.y<-Math.PI) {
      angle.y+=Math.PI*2;
    } else
      if (angle.y>Math.PI) {
        angle.y-=Math.PI*2;
      }
    cam.x=radius*Math.cos(angle.x);
    cam.z=radius*Math.sin(angle.x);
    cam.y=radius*Math.cos(angle.y);
  }
  void Draw() {

    clear();
    for (int i=0; i<layers; i++) {
      gal[i].Draw();
    }
    gal[0].graph.Update();
    camera((float)cam.x*100, (float) cam.y*100, (float)cam.z*100, (float)lookat.x, (float)lookat.y, (float)lookat.z, (float)up.x, (float)up.y, (float)up.z);
    pushMatrix();
    scale(2.0, 2.0, 2.0);
    for (int i=0; i<layers; i++) {
      gal[i].graph.Draw3D();
    }
    popMatrix();
    fill(255); 
    pushMatrix();
    textFont(createFont("Uroob", 72));
    translate(0, 0, 1);
    text("Scale:"+((float)((int)((3.0e8/(gal[0].scale*gal[0].graph.Width()))*10)*1000))/(gtscale*1000)+" Ly/Pix offset X:"+(int)gal[0].vx+" Y:"+(int)gal[0].vy, gal[0].graph.Width()>>1, gal[0].graph.Height()>>2);
    text("Galaxy:"+((float)(age)/gtscale)+" Billion Years", gal[0].graph.Width()>>1, gal[0].graph.Height()>>1);
    popMatrix();
  }
}
