FloatList xvals=new FloatList();
FloatList yvals=new FloatList();
FloatList zvals=new FloatList();
boolean line=true;
boolean axis=true;
int rchoose=1;
boolean scaleon=true;
int timer=1;
int timer2=1;
float xscale=1;
float yscale=1;
float zscale=1;
float autoscale=1;
boolean typing=false;
float maxval=0;
float ry=0;
float rx=0;
float rz=0;
int numofxs=80;
double volume=0;
float dheight;
boolean paused=false;
boolean halfinterval=false;
boolean zsquared=false;
//x  y z expressions
String exp=
//"x^3+y^3";//windows
//"x+(cosx+siny)";
//"y*2^cosx";
//"y*cos(x*p/10)";
//"(x^2+y^2)*cos(y*p/5)";
//"(x^2+y^2)*cos(x*p/10)*sin(y*p/10)";
//"x*y+30*cosx";
//"y/(x^2+1)";
//"1/(x^2+y^2+1)";
//"x^3/(x^2+y^2+1)";
//"cosx/(y^2+1)";
//(x+y)*sin(y*p/10)";
//"x*y*cos(x*p/10)*sin(y*p/10)";
//"sin((x/4)^2+(y/4)^2)";
"x^2-y^2";
//"log((((x/3)^2-(y/3)^2)^2^0.5)+1)";
//"sin((x/4)^2-(y/4)^2)";
//"cos((x/4)^2+(y/4)^2)+sin((x/4)^2-(y/4)^2)";
//sin(x*y/9);
//sin(x*y^2/27);
//"sin((x/3)^2-(y/3)^2)";
//"(sin((x/4)^2+(y/4)^2))^2";
//"cos((x/3)^2+y/3)";
String tempexp="";
void setup(){
      size(500, 450,P3D);
      //parse.test();
      calculate();
      dheight=height;
      surface.setResizable(true);
}

void draw(){
    background(255,255,255);
    fill(0);
    if(rchoose==2){
      text("Scroll Mode Y axis stretch",10,40,0);
    }
    else if(rchoose==3){
      text("Scroll Mode X axis stretch",10,40,0);
    }
    else if(rchoose==4){
      text("Scroll Mode Z axis stretch",10,40,0);
    }
    else{
      text(" X-Y axis Tilt",10,40,0);
    }
    if (typing){fill(#f42121);}
    if(zsquared){
    text("z^2= "+exp,10,20,0);}
    else{text("z= "+exp,10,20,0);}
    translate(width/2,height/2,0);
    rotateY(timer2*PI/180);
    rotateY(ry);
    if(!paused){
       timer2++;}
    if(timer2>360){timer2=0;}
    rotate();
    stroke(0,0,0);   
    
    //draw axis    
    if(axis){
        textSize(15); fill(0);
        
        //x axis
        line(-150*xscale,0,0,150*xscale,0,0);
        text("X",105*xscale,0,0);
        
        //z
        line(0,-150*zscale,0,0,150*zscale,0);        
        text("Z",0,-105*zscale,0);
        
        //y
        line(0,0,-150*yscale,0,0,150*yscale);        
        text("Y",0,0,105*yscale);
        /*//x axis
        line(-150*xscale*height/450,0,0,150*xscale*height/450,0,0);
        text("X",105*xscale*height/450,0,0);
        
        //z
        line(0,-150*zscale*height/450,0,0,150*zscale*height/450,0);        
        text("Z",0,-105*zscale*height/450,0);
        
        //y
        line(0,0,-150*yscale*height/450,0,0,150*yscale*height/450);        
        text("Y",0,0,105*yscale*height/450);*/
    }
    
    stroke(#aa03eb);
    //stroke(#eb03b8);
    
    //draw function
    for (int i=0;i<xvals.size()-1;i++){
        drawSurface(i,1);
        drawBundles(i,1);        
    }
    if(zsquared){
      for (int i=0;i<xvals.size()-1;i++){
        drawSurface(i,-1);
        drawBundles(i,-1);        
      }
    }
    if(timer<360){timer+=3;}
    dheight=height;
}

void calculate(){
  xvals.clear(); yvals.clear(); zvals.clear();
  if(zsquared && halfinterval){
  parse.zinterp(exp,-10,10,0.5,zsquared);}
  else{parse.zinterp(exp,-10,10,0.25,zsquared);}
  for (int i=0;i<parse.xreturnlist.size();i++){
       //print(parse.thetaorx.get(i).floatValue()); print("    "); println(parse.rory.get(i).floatValue());
       xvals.append(10*parse.xreturnlist.get(i).floatValue());
       yvals.append(10*parse.yreturnlist.get(i).floatValue());
       zvals.append(-10*parse.zreturnlist.get(i).floatValue());
   }
  rescale(xvals); rescale(yvals); rescale(zvals);
  //xscale=1;yscale=1;zscale=1;
  //volume=abs((float)integrate(-10,10));
}

void rescale(FloatList list){
  maxval=0;
  autoscale=1;
  for (int i=0;i<list.size();i++){
         if (abs(list.get(i))>maxval){
            maxval=abs(list.get(i));
            if(100/maxval==0){
                maxval=abs(list.get(i-1));
                break;
            }
         }
  }
  if(maxval==0){autoscale=1;}
  else{
    autoscale=100/maxval;}
  if (autoscale==0){autoscale=5; }
  for (int i=0;i<list.size();i++){
     list.mult(i,autoscale);
  }
}




void drawSurface(int i,int sign){
  if(xvals.get(i)!=100){
  line(xscale*xvals.get(i),sign*zscale*zvals.get(i),yscale*yvals.get(i),xscale*xvals.get(i+1),sign*zscale*zvals.get(i+1),yscale*yvals.get(i+1));  }
  //else{println(i);}
}

//draws bundles to form net
//80 +81t
void drawBundles(int i,int sign){
  if(xvals.size()-(numofxs+1)>i){
  line(xscale*xvals.get(i),sign*zscale*zvals.get(i),yscale*yvals.get(i),xscale*xvals.get(i+numofxs+1),sign*zscale*zvals.get(i+numofxs+1),yscale*yvals.get(i+numofxs+1)); }
}

void rotate(){
  rotateX(rx);
  rotateZ(rz);
}


void keyPressed(){
   if(key=='f'||key=='F'){
     rchoose++;
     if(rchoose>4){rchoose=1;}
   }
   
   if((key=='a'||key=='A')&& !typing){   if(axis){axis=false;} else{axis=true;}   }
   if((key=='z'||key=='Z')&& !typing){   
       if(zsquared){zsquared=false; 
         if(halfinterval){numofxs=80;} calculate(); } 
       else{zsquared=true; if(halfinterval){numofxs=40;} calculate();}   }
   if(key=='s'||key=='S'){
       xscale=dheight/450;
       yscale=dheight/450;
       zscale=dheight/450;
   }

   if(key=='r'||key=='R'){
      rx=0; rz=0;  timer2=0; 
       xscale=dheight/450;
       yscale=dheight/450;
       zscale=dheight/450;
   }
   if((key=='p'||key=='P')&&!typing){
     if(!paused){paused=true;}else{   paused=false;}
   }
   if(keyCode==LEFT){
      ry-=5*PI/180;
   }
   if(keyCode==RIGHT){
      ry+=5*PI/180;
   }
   if(keyCode==ENTER){
       if(typing){typing=false; 
       //println("");println("processing "+exp); 
       rx=0; rz=0;
       timer2=0; calculate();} 
       else{typing=true;exp=new String("");
       //println("");println("--Start typing expression: y=");
       }
   }
   if(typing){
      if(keyCode!=SHIFT && keyCode!=ENTER && keyCode!=BACKSPACE && keyCode!=DELETE){
      exp=exp+Character.toString(key);
      //print(key);
      }
   }
   if(typing && (keyCode==DELETE||keyCode==BACKSPACE)){
      if(exp.length()>0){
      exp=exp.substring(0,exp.length()-1);}
   }
}
void mouseClicked(){
  if(!paused){paused=true;}else{   paused=false;}
}
void mouseWheel(MouseEvent event) {
  int e = event.getCount();
  if(rchoose==1){
    rz-=5*e*PI/180;    
  }
  if(rchoose==2){
    if(e>0){ yscale=yscale/1.1;}
    else{yscale=yscale*1.1;} 
  }
  if(rchoose==3){
    if(e>0){ xscale=xscale/1.1;}
    else{xscale=xscale*1.1;} 
  }
  if(rchoose==4){
    if(e>0){ zscale=zscale/1.1;}
    else{zscale=zscale*1.1;}   
  }
}