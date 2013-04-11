// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2012
// PBox2D example

// A fixed boundary class

class Sensor {

  // A boundary is a simple rectangle with x,y,width,and height
  float x;
  float y;
  float w;
  float h;
  
  // But we also have to make a body for box2d to know about it
  Body b;

  Sensor(float x_,float y_, float w_, float h_) {
    x = x_;
    y = y_;
    w = w_;
    h = h_;

    // Define the polygon
    PolygonShape ps = new PolygonShape();
    // Figure out the box2d coordinates
    float box2dW = box2d.scalarPixelsToWorld(w/2);
    float box2dH = box2d.scalarPixelsToWorld(h/2);
    // We're just a box
    ps.setAsBox(box2dW, box2dH);


    // Create the body

    // Attached the shape to the body using a Fixture
    
    //b.createFixture(ps,1);
    FixtureDef fd = new FixtureDef();
    fd.density = 1;
    fd.friction = 0.5;
    fd.restitution = 0.5;

    fd.shape = ps;
    fd.isSensor=true;
    
    BodyDef bd = new BodyDef();
    bd.type = BodyType.STATIC;
    bd.position.set(box2d.coordPixelsToWorld(x,y));
    b = box2d.createBody(bd);
    b.createFixture(fd); 
   
    b.setUserData(this);
  }

  // Draw the boundary, if it were at an angle we'd have to do something fancier
  void display() {
    fill(0,0,200);
    stroke(127);
    rectMode(CENTER);
    rect(x,y,w,h);
  }

}


