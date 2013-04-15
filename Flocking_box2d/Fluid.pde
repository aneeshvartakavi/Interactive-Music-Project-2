class Fluid extends Sensor
{
    
  Fluid(float x_,float y_, float w_, float h_){
    
    super(x_,y_,w_,h_);
   }
  
 void display() {
    fill(0,0,128);
    stroke(127);
    rectMode(CENTER);
    rect(x,y,w,h);
   // rect(x,y,w+70,h+70);
   
  }
  
}

  
 
