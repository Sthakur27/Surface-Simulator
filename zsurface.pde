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
double volume=0;
boolean paused=false;
//String exp=("4.64-(x^2^(1/3))");
//x  y z expressions
String exp="x+(cosx+siny)";
String tempexp="";
void setup(){
      size(500, 450,P3D);
      //parse.test();
      calculate();
      //surface.setResizable(true);
}

void draw(){
    background(255,255,255);
    fill(0);
    text("z=("+exp+")",10,20,0);
    if(rchoose==3){
      text("Scroll Mode Y axis stretch",10,40,0);
    }
    else if(rchoose==4){
      text("Scroll Mode X axis stretch",10,40,0);
    }
    else if(rchoose==2){
      text("Scroll Mode Z axis stretch",10,40,0);
    }
    else{
      text(" X-Y axis Tilt",10,40,0);
    }
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
        line(-150,0,0,150,0,0);
        //line(-width/2,0,0,width/2,0,0);
        text("X",105,0,0);
        
        //y
        line(0,-150,0,0,150,0);
        //line(0,-height/2,0,0,height/2,0);        
        text("Z",0,-105,0);
        
        //z
        line(0,0,-150,0,0,150);
        //line(0,0,-height/2,0,0,height/2); 
        
        text("Y",0,0,105);
    }
    
    stroke(#aa03eb);
    //stroke(#eb03b8);
    
    //draw function
    for (int i=0;i<xvals.size()-1;i++){
        drawSurface(i);
        if((i)%81==0){
          drawBundles(i);
          drawBundles(i+20);
          drawBundles(i+40);
          drawBundles(i+60);
          drawBundles(i+80);
        }
    }
    if(timer<360){timer+=3;}
}

void calculate(){
  xvals.clear(); yvals.clear(); zvals.clear();
  parse.zinterp(exp,-10,10,0.25);
  for (int i=0;i<parse.xreturnlist.size();i++){
       //print(parse.thetaorx.get(i).floatValue()); print("    "); println(parse.rory.get(i).floatValue());
       xvals.append(10*parse.xreturnlist.get(i).floatValue());
       yvals.append(10*parse.yreturnlist.get(i).floatValue());
       zvals.append(-10*parse.zreturnlist.get(i).floatValue());
   }
  rescale(xvals); rescale(yvals); rescale(zvals);
  //volume=abs((float)integrate(-10,10));
}

void rescale(FloatList list){
  maxval=0;
  autoscale=1;
  for (int i=0;i<list.size();i++){
         if (abs(list.get(i))>maxval){
            maxval=abs(list.get(i));
         }
  }
  if(maxval==0){autoscale=1;}
  else{
    autoscale=100/maxval;}
  if (autoscale==0){autoscale=200; }
  for (int i=0;i<list.size();i++){
     list.mult(i,autoscale);
  }
}




void drawSurface(int i){
  if(xvals.get(i)!=100){
  line(xscale*xvals.get(i),zscale*zvals.get(i),yscale*yvals.get(i),xscale*xvals.get(i+1),zscale*zvals.get(i+1),yscale*yvals.get(i+1));  }
  //else{println(i);}
}

//draws bundles to form net
//80 +81t
void drawBundles(int i){
  if(xvals.size()-81>i){
  line(xscale*xvals.get(i),zscale*zvals.get(i),yscale*yvals.get(i),xscale*xvals.get(i+81),zscale*zvals.get(i+81),yscale*yvals.get(i+81)); }
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

   if(key=='r'||key=='R'){
      rx=0; rz=0;  timer2=0; 
   }
   if(key=='p'||key=='P'){
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
      rx=0; rz=0; timer2=0; calculate();} 
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
  if(rchoose==2){
    if(e>0){ zscale=zscale/1.1;}
    else{zscale=zscale*1.1;}   
  }
  if(rchoose==1){
    rz-=5*e*PI/180;    
  }
  if(rchoose==3){
    if(e>0){ yscale=yscale/1.1;}
    else{yscale=yscale*1.1;} 
  }
  if(rchoose==4){
    if(e>0){ xscale=xscale/1.1;}
    else{xscale=xscale*1.1;} 
  }
}