// Flocking
// Daniel Shiffman <http://www.shiffman.net>
// The Nature of Code

// Boid class
// Methods for Separation, Cohesion, Alignment added

class Boid {

  // We need to keep track of a Body and a width and height
  Body body;
  float r; // Length of the triangle
    
  boolean delete = false;
  color col;
  
  float health;
  float densityBody;
  
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed
  int note=0;
  
  //Force weights
  float separationWeight=1;
  float cohesionWeight=0;
  float allignmentWeight=0;
  float seekFoodWeight=0.8;
  float seekMouseWeight=0;
  
  Vec2 point;
  Boid(PVector loc) {
    r=100;
    health = 100;
    r = box2d.scalarPixelsToWorld(r);
    col = color(175);
   
    densityBody = random(0.5,1.5);
    maxspeed = 10;
    maxforce = 10; 
    
    makeBody(new Vec2(loc.x,loc.y));
    body.setUserData(this);
    point = body.getPosition();
    note = (int) random(2);
    

  }
  
void note()
{ OscMessage myMessage = new OscMessage("/test");
  if(note==1)
  note=5;
  myMessage.add(note);
  oscP5.send(myMessage, myRemoteLocation); 
  
}

  // This function removes the particle from the box2d world
  void killBody() {
    box2d.destroyBody(body);
  }

    void delete() {
    delete = true;
  }

  // Change color when hit
  void wall() {
    //println("wall!");
  //  body.linearDamping = 100;
  }
  
  void hellBegin() { 
    println("Hell begin");
    reduceHealth(40);
    body.setLinearDamping(0.5);
    body.setAngularDamping(3);
}

void hellEnd() {
  
    Vec2 vel=body.getLinearVelocity();
    vel.mulLocal(-2);
    Vec2 loc = body.getWorldCenter();
    body.applyForce(vel,loc);   
   //body.applyAngularImpulse(50);
  
}

void fluidBegin()
{ //println("begin");
  body.setLinearDamping(1);
  body.setAngularDamping(4);
 }

void fluidEnd()
{ //println("end");
  body.setAngularDamping(2);
  body.setLinearDamping(0.01);
}

void food()
{
 health+=20; 
 //println("Health!");
} 

  // Is the particle ready for deletion?
  
 boolean done() {
    // Let's find the screen position of the particle
    
   if (delete) {
      killBody();
      return true;
    }
    return false;
  }
  void run(ArrayList<Boid> boids) {
    flock(boids);
    seekFood();
    seekMouse();
    //borders();
    display();
    checkHealth();
  }
  
void checkHealth()
  {
    health-=0.05;
    if(health<=0)
    delete=true;
  }
  
  void reduceHealth(float f)
  {
    health-=f;
  }
  
  // We accumulate a new acceleration each time based on three rules
 void seekMouse()
{
  Vec2 mouse = box2d.coordPixelsToWorld(mouseX,mouseY);
  Vec2 seekMouse = seek(mouse);
  seekMouse.mulLocal(seekMouseWeight);
  point = body.getWorldPoint(new Vec2(0,-0.4));
  body.applyForce(seekMouse,point);
} 

void seekFood()
{  int count = foods.size();
  // println(count);
   if (count > 0)
   { 
   float[] distances = new float[count];
   for (int i = 0; i<count; i++) {
    Food f = foods.get(i);
    //Vec2 loc = body.getPosition();
    Vec2 loc = body.getWorldCenter();
    Vec2 dist = loc.sub(f.getPos());
    distances[i]=dist.length();
    
   }
   float min;
   int index;
   min = distances[0];
   index = 0;
   for (int i = 0; i<count; i++) {
      if(distances[i] < min)
     index = i; 
   }
   Food f=foods.get(index);
   Vec2 desired = seek(f.getPos());
   desired.mulLocal(seekFoodWeight);
   body.applyForce(desired,body.getWorldPoint(new Vec2(0,-0.4)));
   }
  } 

  
  void flock(ArrayList<Boid> boids) {
    Vec2 sep = separate(boids);   // Separation
    Vec2 ali = align(boids);      // Alignment
    Vec2 coh = cohesion(boids);   // Cohesion
    
    // Arbitrarily weight these forces
    sep.mulLocal(separationWeight);
    ali.mulLocal(allignmentWeight);
    coh.mulLocal(cohesionWeight);
    
    // Add the force vectors to acceleration
    Vec2 loc = body.getWorldCenter();
    body.applyForce(sep,loc);
    body.applyForce(ali,loc);
    body.applyForce(coh,loc);
  }

  // A method that calculates and applies a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  Vec2 seek(Vec2 target) {
    Vec2 loc = body.getWorldCenter();
    Vec2 desired = target.sub(loc);  // A vector pointing from the location to the target
    
    // If the magnitude of desired equals 0, skip out of here
    // (We could optimize this to check if x and y are 0 to avoid mag() square root
    if (desired.length() == 0) return new Vec2(0,0);

    // Arrive Behavior
    float d = desired.length();
    desired.normalize();
    
    float arriveRadius = 120;
    arriveRadius = box2d.scalarPixelsToWorld(arriveRadius);
    if ( d < arriveRadius) {
      float m = map(d,0,arriveRadius,0,maxspeed);
    desired.mulLocal(m);
    } 
    else {
      desired.mulLocal(maxspeed);
    }
    
    // Steering = Desired minus Velocity
    
    Vec2 vel = body.getLinearVelocity();
    Vec2 steer = desired.sub(vel);
    
    float len = steer.length();
    if (len > maxforce) {
      steer.normalize();
      steer.mulLocal(maxforce);
    }
    return steer;
  }
  


  
  void display() {
    fill(256,0,0);
    ellipse(mouseX,mouseY,20,20);
    Vec2 pos = box2d.getBodyPixelCoord(body);
    float a = body.getAngle();
    
    Fixture f = body.getFixtureList();
    PolygonShape ps = (PolygonShape) f.getShape();
    
    rectMode(CENTER);
    fill(256-127*densityBody);
    stroke(0);
    strokeWeight(1);
    pushMatrix();
    translate(pos.x,pos.y);
    rotate(-a);
    beginShape();
    for (int i =0; i< ps.getVertexCount(); i++) {
      Vec2 v = box2d.vectorWorldToPixels(ps.getVertex(i));
      vertex(v.x,v.y);
    }
    endShape(CLOSE);
    popMatrix();

    fill(256,0,0);
    Vec2 pixelPos = box2d.coordWorldToPixels(point);
    ellipse(pixelPos.x, pixelPos.y,8,8);  
    //println(health);
    
}

  // Separation
  // Method checks for nearby boids and steers away
  Vec2 separate (ArrayList<Boid> boids) {
    float desiredseparation = box2d.scalarPixelsToWorld(100);
    
    Vec2 steer = new Vec2(0,0);
    int count = 0;
    // For every boid in the system, check if it's too close
    Vec2 locA = body.getWorldCenter();
    for (Boid other : boids) {
      Vec2 locB = other.body.getWorldCenter();
      float d = dist(locA.x,locA.y,locB.x,locB.y);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        Vec2 diff = locA.sub(locB);
        diff.normalize();
        diff.mulLocal(1.0/d);        // Weight by distance
        steer.addLocal(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      steer.mulLocal(1.0/count);
    }

    // As long as the vector is greater than 0
    if (steer.length() > 0) {
      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mulLocal(maxspeed);
      Vec2 vel = body.getLinearVelocity();
      steer.subLocal(vel);
      float len = steer.length();
      if (len > maxforce) {
        steer.normalize();
        steer.mulLocal(maxforce);
      }
    }
    return steer;
  }

  // Alignment
  // For every nearby boid in the system, calculate the average velocity
  Vec2 align (ArrayList<Boid> boids) {
    float neighbordist = box2d.scalarPixelsToWorld(50);
    Vec2 steer = new Vec2(0,0);
    int count = 0;
    Vec2 locA = body.getWorldCenter();
    for (Boid other : boids) {
      Vec2 locB = other.body.getWorldCenter();
      float d = dist(locA.x,locA.y,locB.x,locB.y);
      if ((d > 0) && (d < neighbordist)) {
        Vec2 vel = other.body.getLinearVelocity();
        steer.addLocal(vel);
        count++;
      }
    }
    if (count > 0) {
      steer.mulLocal(1.0/count);
    }

    // As long as the vector is greater than 0
    if (steer.length() > 0) {
      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mulLocal(maxspeed);
      Vec2 vel = body.getLinearVelocity();
      steer.subLocal(vel);
      float len = steer.length();
      if (len > maxforce) {
        steer.normalize();
        steer.mulLocal(maxforce);
      }
    }
    return steer;
  }

  // Cohesion
  // For the average location (i.e. center) of all nearby boids, calculate steering vector towards that location
  Vec2 cohesion (ArrayList<Boid> boids) {
    float neighbordist = box2d.scalarPixelsToWorld(50);
    Vec2 sum = new Vec2(0,0);   // Start with empty vector to accumulate all locations
    int count = 0;
    Vec2 locA = body.getWorldCenter();
    for (Boid other : boids) {
      Vec2 locB = other.body.getWorldCenter();
      
      float d = dist(locA.x,locA.y,locB.x,locB.y);
      if ((d > 0) && (d < neighbordist)) {
        sum.addLocal(locB); // Add location
        count++;
      }
    }
    if (count > 0) {
      sum.mulLocal(1.0/count);
      return seek(sum);  // Steer towards the location
    }
    return sum;
  }
  
  
  void makeBody(Vec2 center) {

    // Define a polygon (this is what we use for a rectangle)
       
    Vec2[] vertices = new Vec2[3];
    vertices[0] = box2d.vectorPixelsToWorld(new Vec2(0,2*r));
    vertices[1] = box2d.vectorPixelsToWorld(new Vec2(-r,-2*r));
    vertices[2] = box2d.vectorPixelsToWorld(new Vec2(r,-2*r));
    
    PolygonShape ps = new PolygonShape();
    ps.set(vertices, vertices.length);
    
    FixtureDef fd = new FixtureDef();
    fd.shape = ps;
    // Parameters that affect physics
    fd.density=densityBody;
    fd.friction = 0.5;
    fd.restitution = 0.5;

    // Define the body and make it from the shape
    BodyDef bd = new BodyDef();
    bd.type = BodyType.DYNAMIC;
    bd.position.set(box2d.coordPixelsToWorld(center));
    bd.angularDamping = 2;
    bd.linearDamping = 0.01;
    bd.bullet = true;
    
    body = box2d.createBody(bd);
    body.createFixture(fd);
    //bd.setDensity(1);
    // body.getFixtureList().setDensity(2);
    //body.setLinearVelocity(vel);
   // body.setAngularVelocity(avel);

  }
  
  
}

