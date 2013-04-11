class Food 
{
  
  Vec2 location;
   Body body;
   float r;
   boolean delete = false;
    
  Food()
  { location = new Vec2(random(width),random(height));
    r=10;
  makeBody(location.x,location.y,r);
  body.setUserData(this);

}

  
  void display()
  {
    fill (255,255,0);
    ellipse(location.x, location.y,r,r);
  }
  
    void delete() {
     delete = true;
        }
  
    void killBody() {
    box2d.destroyBody(body);
    }
  
  boolean done() {
    
    //Vec2 pos = box2d.getBodyPixelCoord(body);
    // Is it off the bottom of the screen?
    if (delete == true) {
      killBody();
      return true;
    }
    return false;
  }
  
  
   void makeBody(float x, float y, float r) {
    // Define a body
    BodyDef bd = new BodyDef();
    // Set its position
    bd.position = box2d.coordPixelsToWorld(x, y);
    bd.type = BodyType.STATIC;
    body = box2d.createBody(bd);

    // Make the body's shape a circle
    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(r);

    FixtureDef fd = new FixtureDef();
    fd.shape = cs;
    fd.isSensor=true;
    // Parameters that affect physics
    fd.density = 1;
    fd.friction = 0.01;
    fd.restitution = 0.3;

    // Attach fixture to body
    body.createFixture(fd);

   // body.setAngularVelocity(random(-10, 10));
  }
}
