class Hell extends Sensor
{
    
  Hell(float x_,float y_, float w_, float h_){
    
    super(x_,y_,w_,h_);
    
  }
  
 void display() {
    fill(128,0,0);
    stroke(127);
    rectMode(CENTER);
    rect(x,y,w,h);
   // rect(x,y,w+70,h+70);
   
  }
  
}

  
 
