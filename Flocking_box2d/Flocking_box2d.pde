// Flocking based on Daniel Shiffman's code <http://www.shiffman.net>

import pbox2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;

//import org.jbox2d.callbacks.DebugDraw;
//import org.jbox2d.callbacks.TreeCallback;
//import org.jbox2d.callbacks.TreeRayCastCallback;
//import org.jbox2d.collision.AABB;
//import org.jbox2d.collision.RayCastInput;
//import org.jbox2d.common.Vec2;


//import org.jbox2d.collision.Distance.SimplexCache;
//import org.jbox2d.collision.DistanceInput;
//import org.jbox2d.collision.DistanceOutput;
//import org.jbox2d.collision.shapes.PolygonShape;
//
//DistanceInput input = new DistanceInput();
//SimplexCache cache = new SimplexCache();
//DistanceOutput output = new DistanceOutput();
import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

// A reference to our box2d world
PBox2D box2d;


ArrayList<Hell> hells;
ArrayList<Boundary> boundaries;
ArrayList<Obstacle> obstacles;
ArrayList<Fluid> fluids;
ArrayList<Food> foods;
ArrayList<Boid> boids;
//ArrayList<AlphaBoid> alphaBoids;


void setup() {
  size(800,800);
  
  // OSC Stuff
  
  oscP5 = new OscP5(this,13000);
  myRemoteLocation = new NetAddress("127.0.0.1",12000);
  
  
  // Initialize box2d and create the world
  box2d = new PBox2D(this);
  box2d.createWorld();
  
  box2d.world.setContactListener(new CustomListener());
  
  //box2d.listenForCollisions();
  box2d.setGravity(0,0);
  
  boundaries = new ArrayList<Boundary>();
  
  boundaries.add(new Boundary(0,0,2*width,20));
  boundaries.add(new Boundary(0,0,20,2*height));
  boundaries.add(new Boundary(width,height-20,20,2*height));
  boundaries.add(new Boundary(0,height,2*width,20));
  //boundaries.add(new Boundary(width/2,200,width/2-50,200));
  
  hells = new ArrayList<Hell>();
  hells.add(new Hell(width/2,200,200,100));
  
  obstacles = new ArrayList<Obstacle>();
  obstacles.add(new Obstacle(200,600, 100, 100));
  
  fluids = new ArrayList<Fluid>();
  fluids.add(new Fluid(400,400,100,100));
  
  foods = new ArrayList<Food>();
  foods.add(new Food());
  foods.add(new Food());
  
  boids = new ArrayList<Boid>();
 
 //for (int i = 0; i < 1; i++) {
    boids.add(new Boid(new PVector(width/2,height/2)));
    boids.add(new Boid(new PVector(width/4,height/2),true,300));
//}
  
//  alphaBoids = new ArrayList<AlphaBoid>();
//  alphaBoids.add(new AlphaBoid(new PVector(width/4,height/2)));
  
  smooth();
}

void draw() {

  
  // We must always step through time!
  box2d.step();
  background(255);
  for (Hell h: hells) {
    h.display();  
  }

  for (Obstacle o: obstacles) {
    o.display();  
  }   
  
  for (Boundary wall: boundaries) {
    wall.display();
  }
  
  for (Fluid f: fluids) {
    f.display();
  }
  
  for (int i = foods.size()-1; i>=0; i--) {
    Food f = foods.get(i);
    //f.checkBodies();
    f.display();
    if (f.done()) {
      foods.remove(i);
    }
  }
  
  for (int i = boids.size()-1; i >= 0; i--) {
    Boid b = boids.get(i);
    b.run(boids);
    if (b.done()) {
      boids.remove(i);
    }
  }
  
//    for (int i = alphaBoids.size()-1; i >= 0; i--) {
//      AlphaBoid b = alphaBoids.get(i);
//      b.run1(alphaBoids);
//      if (b.done()) {
//        alphaBoids.remove(i);
//      }
//    }
  
  
  randomBoid(0.001);
  randomFood(0.002);
}

void mousePressed() {
   //flock.addBoid(new Boid(new PVector(mouseX,mouseY)));
   makeFood();
}

void mouseDragged() {
   //flock.addBoid(new Boid(new PVector(mouseX,mouseY)));
}

void randomFood(float f) 
{ 
  if(random(1)<f)
 foods.add(new Food()); 
  }


void randomBoid(float f)
{  if(random(1)<f)
    boids.add(new Boid(new PVector(random(width),random(height))));
}

void makeFood() {
  foods.add(new Food(mouseX, mouseY));
}







