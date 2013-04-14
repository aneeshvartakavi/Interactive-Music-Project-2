// Flocking
// Daniel Shiffman <http://www.shiffman.net>
// The Nature of Code

// Demonstration of Craig Reynolds' "Flocking" behavior
// See: http://www.red3d.com/cwr/
// Rules: Cohesion, Separation, Alignment

// Click mouse to add boids into the system

import pbox2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;

import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

// A reference to our box2d world
PBox2D box2d;

Flock flock;


ArrayList<Hell> hells;
ArrayList<Boundary> boundaries;
ArrayList<Obstacle> obstacles;
ArrayList<Fluid> fluids;
ArrayList<Food> foods;

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
  
  flock = new Flock();
  // Add an initial set of boids into the system
  for (int i = 0; i < 1; i++) {
    flock.addBoid(new Boid(new PVector(width/2,height/2)));
  }
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
  flock.run();
  randomBoid(0.001);
  randomFood(0.002);
}

void mousePressed() {
   //flock.addBoid(new Boid(new PVector(mouseX,mouseY)));
   makeFood();
}

void mouseDragged() {
   flock.addBoid(new Boid(new PVector(mouseX,mouseY)));
}

void randomFood(float f) 
{ 
  if(random(1)<f)
 foods.add(new Food()); 
  }


void randomBoid(float f)
{  if(random(1)<f)
   flock.addBoid(new Boid(new PVector(random(width),random(height))));
}

void makeFood() {
  foods.add(new Food(mouseX, mouseY));
}







