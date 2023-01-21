class Galaxy {
  GImage graph;
  double G=50.0+random(50)-random(50);
  double ac=G/3e8;
  //double k;
  int w=48;
  int h=16;
  boolean active=true;
  double scale;
  double iscale;
  double b=w/3.0*4.0;//100.0/22.0;//4.56476797456
  double f(double n) {
    return n/b*4.0/3.0;
  }
  double r(double x) {
    //units 1.0/r-r*(1.0-1.0/ir);
    return 1.0/x-x*(1.0-1.0/b);
  }
  double r(double y, double ir) {
    //units 1.0/r-r*(1.0-1.0/ir);
    return 1.0/y-y*(ir-1.0/b);
  }
  double r(double z, double ir, double d) {
    //units 1.0/r-r*(1.0-1.0/ir);
    return d/z-z*(ir-d/b);
  }
  double rc(double x, double c) {
    //units 1.0/r-r*(1.0-1.0/ir);
    return 1.0/x-x*(1.0-1.0/c);
  }
  void ResetScale() {

    scale=(double)(w*h)/(1+seedx+seedy);
    ResetInvScale();
  }
  void ResetInvScale() {

    iscale=(double)(w+h)/(double)(scale);
  }
  void ResetScale(int s) {

    scale=(double)(w*h)/(1+s+seedx+seedy);
    ResetInvScale();
  }
  void ResetCenter() {

    vx=0;
    vy=0;
  }
  double xx[][][]=new double[w][h][w];
  double yy[][][]=new double[w][h][w];
  double zz[][][]=new double[w][h][w];
  double mm[][][]=new double[w][h][w];
  double mx[][][]=new double[w][h][w];
  double my[][][]=new double[w][h][w];
  double seedx;
  double seedy;
  double seedz;
  double seedr;
  double sx;
  double sy;
  double sz;
  double vx=0;
  double vy=vx;
  void Seed() {

    seedr=3+random(7)+random(2)-random(2);
    seedx=3+random((float)seedr)+random(2)-random(2);
    seedy=3+random((float)seedr)+random(2)-random(2);
    seedz=3+random((float)seedr)+random(2)-random(5);
    sx=3+random((float)seedr)+random(2)-random(5);
    sy=sx;
    sz=3+random((float)seedr)+random(2)-random(2);
  }
  void Seed(Galaxy g) {

    seedx=g.seedx+random(2)-random(2);
    seedy=g.seedy+random(2)-random(2);
    seedz=g.seedz+random(2)-random(2);
    seedr=g.seedr+random(2)-random(2);
    sx=g.sx+random(2)-random(2);
    sy=sx;
    sz=g.sz+random(2)-random(2);
  }
  Galaxy() {
    graph=new GImage(width, width);
    Seed();
    ResetScale();
    ResetCenter();
  }
  Galaxy(Galaxy g) {
    graph=g.graph;
    Seed(g);
    ResetScale();
    ResetCenter();
  }
  void Draw() {
    lypp=(float)((int)((3.0e8/(scale*graph.Width()))*10)/gtscale);
    for (int i=0; i<graph.Width(); i++) {
      for (int j=0; j<graph.Height(); j++) {
        color col=graph.GetPixel(i, j);
        //graph.AddPixel(i, j,(int)(alpha(col)*0.5f),(int)(red(col)*0.5f),(int)(green(col)*0.5f),(int)(blue(col)*0.5f));
        graph.SetPixel(i, j, 0, 0, 0, 0);
      }
    }  
    //boolean test=true;
    //graph=new PImage(width, height);
    for (int i=1; i<w; i++) {
      for (int j=1; j<h; j++) {
        double x=(double)(i-(w>>1))/w;
        double y=(double)(j-(h>>1))/h;
        for (int k=1; k<w; k++) {
          double z=(double)(k-(w>>1))/w;
          double xr=(f(rc(seedr+x*x, y)))/seedr*(z/sz);
          double ir=1.0/(Math.abs(xr));
          if (active) {
            mm[i][j][k]+=(ac)*ir;
          }
          double gd=mm[i][j][k]*ir;
          double va=seedx*f(seedy*rc(seedy*x*x*gd, z*sz));
          double pa=seedx*f(seedy*rc(seedy*y*y*gd, z*sz));
          yy[i][j][k]=Math.sin(va);//*ir;//star
          xx[i][j][k]=Math.cos(pa);
          zz[i][j][k]=Math.sin(pa);

          if (active) { 
            mx[i][j][k]+=xx[i][j][k]*sz/seedz;
            my[i][j][k]+=zz[i][j][k]*sz/seedz;
          }
          //xx[i][j][k]*=0.9;yy[i][j][k]*=0.9;
          double mag=xr*scale*(h+yy[i][j][k]);
          //double rm=Math.sqrt(mx[i][j][k]*mx[i][j][k]+my[i][j][k]+my[i][j][k]);//(/xr=butterfly curve)
          double rmx=seedy;//Math.sqrt(mx[i][j][k]*mx[i][j][k]+my[i][j][k]+my[i][j][k]);//(/xr=butterfly curve)
          double rmy=seedx;//Math.sqrt(mx[i][j][k]*mx[i][j][k]+my[i][j][k]+my[i][j][k]);//(/xr=butterfly curve)
          //rm=Math.log(rm)/rm;
          //rm=(rm/Math.log(rm))*gd;

          double brx=(int)(mx[i][j][k]*rmx);
          double bry=(int)(my[i][j][k]*rmy);
          int arx=(int)(brx*mag/seedx);
          int ary=(int)(bry*mag/seedy);
          double vxs=vx*scale;
          double vys=vy*scale;
          //println(rx);
          int xv=(int)(graph.Width()>>1)+(int)(vx);
          int yv=(int)(graph.Height()>>1)+(int)(vy);
          int zk=(int)(555/((1+Math.sqrt(xv*xv+yv*yv)*age/1000000)));
          //int xi=(height>>1)+(int)(my[i][j][k]*sy*mag/seedy);
          //int yj=(width>>1)+(int)(mx[i][j][k]*sx*mag/seedx);
          double pia=Math.PI+age*0.001;
          int rd=abs((int)(Math.cos(xx[i][j][k]*pia)*zk));
          int gr=abs((int)(Math.sin(yy[i][j][k]*pia)*zk));
          int bl=abs((int)(Math.cos(zz[i][j][k]*pia)*zk));
          //if(test)
          /*while (xi<0) {
           xi+=graph.Width()-1;
           }
           while (xi>=graph.Width()-1) {
           xi-=graph.Width()-2;
           }
           while (yj<0) {
           yj+=graph.Height()-1;
           }
           while (yj>=graph.Height()-1) {
           yj-=graph.Height()-2;
           }*/
           int vax=(int)(vxs+arx);
           int vay=(int)(vys+ary);
           int vbx=(int)(mx[i][j][k]);
           int vby=(int)(my[i][j][k]);
          int xi=(int)(graph.Width()>>1)+vax;
          int yj=(int)(graph.Height()>>1)+vay;
          boolean OK=true;
          if(!active){if(vax==0 && vay==0){OK=false;}}
          if(OK)
          if (!(xi<0 || xi>=graph.Width()-1 || yj<0 || yj>=graph.Height()-1)) {
            graph.AddPixel((xi+1), (yj+1), 3, rd, gr, bl);
            
            if (lypp<=gtscale*GT) {
              double rv=(Math.sqrt(vbx*vbx+vby*vby));
              if(rv<1000){
              DrawCluster(xi+1, yj+1, i, j, k,(int)(rv*4.0/(1+lypp)),1.0/(1+gd),1.0/(1+va),1.0/(1+pa), rd, gr, bl);
              }
              //println((seedx+seedy+seedz)-lypp);
              //println(":"+gd+":"+va+":"+pa+":"+mag+":"+mx[i][j][k]+":"+my[i][j][k]);
              //test=false;
            }
          }
        }
      }
    }
    //test=true;
  }
  double f1(double x, double r, double n) {
    return n*r*x*(1.0-x);
  }
  void DrawCluster(int xs, int ys, int gi, int gj, int gk, int lyp,double ga,double va,double pa,int red,int gre,int blu) {

    int n=lyp>>1;//120;
    //println(n);
    float ly=4;
    float m=(float)(ly*ga);//1+(int)(random(3)+random(3)+random(3));
    double sx=1.0+ga-pa;
    float s1=(float)(1.0+ga-pa)*0.1;
    float s2=(float)(1.0-ga+pa)*0.5;
    float g1=(float)(m+va-pa)*2;
    float g2=(float)(m-va+pa)*3;
    float g3=(float)(m+ga-va)*5;
    float g4=(float)(m+ga-pa)*7;
    float scala=(float)(1.0/(3e8));
    double sr=1.8+ga;

    float a=0;
    //float rot=0;
    float sides=(float)Math.sqrt(ly+ga);
    //float sc=(float)(0.8+mx[gi][gj][gk]+my[gi][gj][gk]);
    //float r=512+(float)(512.0/mx[gi][gj][gk]);
    //float g=512+(float)(512.0/my[gi][gj][gk]);
    //float b=512+(float)(512.0/mm[gi][gj][gk]);
    //fill(0,0,0,16);
    //rect(0,0,width,height);
    //k+=((double)(n)*0.0001);
    float na=(PI*2.0)/(5*sides);//euclidian
    //rot+=na;
    //scale+=0.01;
    //ly-=0.01;
    //float sc=(float)(scale+k)*2;
    float sc1=(float)(scala*s1*scale);
    float sc2=(float)(scala*s2*scale);
    float sc3=(float)(scala*s1*sc2*scale);
    float sc4=(float)(scala*s2/sc1*scale);
    //sc=(float)f1(sc,sr,ly);
    //if (k>n) {
     double kn=2.0*g3;
      //background();
      //if(ly<0)start=false;
    //}


    //stroke(255,255,255,255);
    double lax=0;
    double ax=0;
    for (int j=0; j<n; j++) {
      double xx=sx+(sx*(kn-j))/(1+j);//+((1.0-sx)*j/n)/(1+j);
      double r1=sr+(sr*(kn-j))/(1+j);
      for (int i=0; i<n; i++) {
        a+=na;
        if (a>Math.PI*2) {
          a-=Math.PI*2;
        }
        double lx=xx;
        xx=f1(xx, r1, ly);
        lax=ax/xx;
        ax=(xx-lx);
        // float x1=((float)(i-400)/n*i)*0.5f;
        // float x2=((float)(j-400)/n*j)*0.5f;
        float ys1=((float)((ax*ax+lax))*2000);
        float ys2=((float)((lax*lax+ax)*2000));
        float r2=(float)(xx/(ys1*ys1+ys2*ys2+ax*ax+lax*lax+xx*xx+Math.PI));
        float r3=(sqrt(r2)*2);
        //float rd=(float)(sqrt(r2)*r*8)/255;
        //float gn=(float)(sqrt(r2)*g*8)/255;
        //float bl=(float)(sqrt(r2)*b*8)/255;
        float rr1=g1*r2;
        float rr2=g2*r2;
        float rr3=g3*r2;
        float rr4=g4*r2;
        //stroke((int)((i+j+k)*rd)%255,(int)((j+k)*gn)%255,(int)((i+k)*bl)%255,16);
        //point(400+(y2)*sin(a+rr1-rr3)*sc,400+(y1)*cos(a+rr2-rr4)*sc);//star
        //point(400+(y1-y2)*sin(a+rr1-rr3)*sc,400+(y1+y2)*cos(a+rr2-rr4)*sc);//star
        float yn1=(ys2+ys1)*sin(a+rr1-rr3);//-(y1-y2)*sin(a+rr2-rr4)*sc;
        float yn2=(ys1-ys2)*cos(a+rr2-rr4);//-(y1+y2)*cos(a+rr1-rr3)*sc;
        float yna=ys2*(cos(a+rr3)+sin(a+rr1));//(y1+y2)*sin(a+rr1-rr3)*sc;
        float ynb=ys1*(cos(a+rr2)+sin(a+rr4));//(y1-y2)*cos(a+rr2-rr4)*sc;

        float nua=ys1-rr1;//parallel view
        float nub=ys2-rr2;//parallel view
        float nuc=ys1-rr3;//parallel view
        float nud=ys2-rr4;//parallel view

        nua=nua/(float)((nua/ax-ax*r2)*r3);
        nub=nub/(float)((nub/ax-ax*r2)*r3);
        nuc=nuc/(float)((nuc/ax-ax*r2)*r3);
        nud=nud/(float)((nud/ax-ax*r2)*r3);
        //
        nua=(float)(Math.sin(nua+lax))*a;
        nub=(float)(Math.sin(nub+lax))*a;
        nuc=(float)(Math.sin(nuc+lax))*a;
        nud=(float)(Math.sin(nud+lax))*a;
        float ynd=yn1*cos(nua)-yn2*sin(nub);
        float yne=yn2*cos(nub)+yn1*sin(nuc);
        float yn3=yna*cos(nuc)-ynb*sin(nud);
        float yn4=ynb*cos(nud)+yna*sin(nua);
        //int red=(int)((i+j+k)*rd)%255;
        //int gre=(int)((j+k)*gn)%255;
       // int blu=(int)((i+k)*bl)%255;
       //println(x+(yn1+yna)*sc1+":"+y+(yn2+ynb)*sc2);
       int ax1=(int)((yn1+yna)*sc1);int ay1=(int)((yn2+ynb)*sc2);
       int ax2=(int)((yn3+ynd)*sc3);int ay2=(int)((yn4+yne)*sc4);
       int ax3=(int)((yn1-yna)*sc4);int ay3=(int)((yn2-ynb)*sc3);
       int ax4=(int)((yn3-ynd)*sc2);int ay4=(int)((yn4-yne)*sc1);
       int x1=(int)(xs+ax1);int y1=(int)(ys+ay1);
        int x2=(int)(xs+ax2);int y2=(int)(ys+ay2);
        int x3=(int)(xs+ax3);int y3=(int)(ys+ay3);
        int x4=(int)(xs+ax4);int y4=(int)(ys+ay4);
        if (!(x1<0 || x1>=graph.Width()-1 || y1<0 || y1>=graph.Height()-1)) {
        graph.AddPixel(x1,y1 , 3, red, gre, blu);
        }
        if (!(x2<0 || x2>=graph.Width()-1 || y2<0 || y2>=graph.Height()-1)) {
        graph.AddPixel(x2, y2, 3, red, gre, blu);}
        if ( !(x3<0 || x3>=graph.Width()-1 || y3<0 || y3>=graph.Height()-1)) {
        graph.AddPixel(x3, y3, 3, red, gre, blu);}
        if ( !(x4<0 || x4>=graph.Width()-1 || y4<0 || y4>=graph.Height()-1)) {
        graph.AddPixel(x4, y4, 3, red, gre, blu);}
        }
        //point(400+x2*sin(a)*scale,400+y2*cos(a)*scale);
        //point(400+y1*cos(a)*scale,400+x1*sin(a)*scale);
        //point(400+x1*cos(a)*scale,400+y1*sin(a)*scale);
        //point(400+x2*cos(a)*scale,400+y2*sin(a)*scale);
        //line(400+x1*cos(a)*scale,400+y1*sin(a)*scale,400+x1*sin(a)*scale,400+y2*cos(a)*scale);
      
      //start=false;
    }
  }
}
