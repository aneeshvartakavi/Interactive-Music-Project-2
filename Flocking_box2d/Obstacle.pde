class Obstacle
{
    // A boundary is a simple rectangle with x,y,width,and height
  float x;
  float y;
  float w;
  float h;
  
  // But we also have to make a body for box2d to know about it
  Body b;
  
  Obstacle(float x_,float y_, float w_, float h_){
    
    x = x_;
    y = y_;
    w = w_;
    h = h_;

    // Define the polygon
    PolygonShape ps = new PolygonShape();
    
    float box2dW = box2d.scalarPixelsToWorld(w/2);
    float box2dH = box2d.scalarPixelsToWorld(h/2);
    
    ps.setAsBox(box2dW, box2dH);

  
    //b.createFixture(ps,1);
    FixtureDef fd = new FixtureDef();
    fd.density = 1;
    fd.friction = 0.5;
    fd.restitution = 0.5;

    fd.shape = ps;
      
    BodyDef bd = new BodyDef();
    bd.type = BodyType.STATIC;
    bd.position.set(box2d.coordPixelsToWorld(x,y));
    b = box2d.createBody(bd);
    b.createFixture(fd); 
   
    b.setUserData(this);
  }
    
 
  
 void display() {
    fill(127);
    stroke(127);
    rectMode(CENTER);
    rect(x,y,w,h);
   // rect(x,y,w+70,h+70);
   
  }
  
}

  
 
