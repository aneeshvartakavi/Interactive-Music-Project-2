// Flocking based on Daniel Shiffman's code <http://www.shiffman.net>
// Uses the PBox2D library by Daniel Shiffman, and the OSCP5 library by Andreas Schlegel


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


ArrayList<Hell> hells;
ArrayList<Boundary> boundaries;
ArrayList<Obstacle> obstacles;
ArrayList<Fluid> fluids;
ArrayList<Food> foods;
ArrayList<Boid> boids;


float locationX,locationY;

void setup() {
  size(800,800);
  
  // OSC Stuff
  
  oscP5 = new OscP5(this,13000);
  myRemoteLocation = new NetAddress("127.0.0.1",12000);
  //oscP5.plug(this,"test","/updateLocation");
  oscP5.plug(this,"makeBoid","/makeBoid");
  oscP5.plug(this,"makeFood","/makeFood");
  oscP5.plug(this,"updateLocation","/updateLocation");
  oscP5.plug(this,"triggerNotes","/triggerNotes");

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
   // First boid in the list is an alpha boid. This should not change
   boids.add(new Boid(new PVector(width/4,height/2),true,300)); 
   boids.add(new Boid(new PVector(width/2,height/2),5));
    
//}
 
  smooth();
} 
  // OSC routing


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
  
//  randomBoid(0.001);
//  randomFood(0.002);
//  triggerNotes();
  display();
}

public void test(int theA, int theB) {
  println("### plug event method. received a message /test.");
  println(" 2 ints received: "+theA+", "+theB);  
}

void mousePressed() {
   boids.add(new Boid(new PVector(mouseX,mouseY),7));
   //makeFood();
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
    boids.add(new Boid(new PVector(random(width),random(height)),(int)random(7)));
}

//void makeFood() {
//  foods.add(new Food(mouseX, mouseY));
//}

void makeBoid(int a)
{ boids.add(new Boid(new PVector(random(width),random(height)),a));
}

void makeFood()
{ 
  foods.add(new Food(locationX,locationY));
}

void updateLocation(int a,int b) 
{ println("updating!");
  locationX=a;
  locationY=b;
  // update location in the boid code... a mouse circle is drawn for every boid. Correct that. Put that code in this script
 }
 
 void triggerNotes() {
   Boid alpha = boids.get(0);
//   println(alpha.isAlpha);
   Vec2 pos = alpha.getPosition();
   int count = boids.size();
//   println(count);
   float[] distances = new float[count];
   int[] indices = new int[count];
   int[] notes = new int[count];
   if (count > 0)
   { int counter=0;
     
   for (int i = 1; i<count; i++) {
    Boid b = boids.get(i);
//    println(b.isAlpha);
    //Fixture abc = body.getShapeList();
    Vec2 loc = b.getPosition();
    Vec2 dist = loc.sub(pos);
    distances[i]=dist.length();
    counter++;
    indices[i]=counter;
    notes[i]=b.note;
   // println(indices[i]); 
  }
    
  quicksort(distances,indices);
  for (int i = 1; i<indices.length; i++) {
//println(indices.length);
  //Boid b = boids.get(indices[i]);
  int note = notes[indices[i]];
  int dist = (int) (distances[indices[i]]*10);
  OscMessage myMessage = new OscMessage("/dist");
  
  myMessage.add(note); /* add an int to the osc message */
  myMessage.add(dist); /* add a second int to the osc message */

  /* send the message */
  oscP5.send(myMessage, myRemoteLocation);
    
//   print(indices[i]);
//   print("-");
  }
//  println("");
}
  
   
 }
 
 void oscEvent(OscMessage theOscMessage) {
  
  if(theOscMessage.isPlugged()==false) {
  
  println("### received an unhandled osc message.");
  println("### addrpattern\t"+theOscMessage.addrPattern());
  println("### typetag\t"+theOscMessage.typetag());
  }
}

void display() {
  fill(256,0,0);
    ellipse(locationX,locationY,20,20);
}


// Quicksort code from stackoverflow

public static void quicksort(float[] main, int[] index) {
    quicksort(main, index, 0, index.length - 1);
}

// quicksort a[left] to a[right]
public static void quicksort(float[] a, int[] index, int left, int right) {
    if (right <= left) return;
    int i = partition(a, index, left, right);
    quicksort(a, index, left, i-1);
    quicksort(a, index, i+1, right);
}

// partition a[left] to a[right], assumes left < right
private static int partition(float[] a, int[] index, 
int left, int right) {
    int i = left - 1;
    int j = right;
    while (true) {
        while (less(a[++i], a[right]))      // find item on left to swap
            ;                               // a[right] acts as sentinel
        while (less(a[right], a[--j]))      // find item on right to swap
            if (j == left) break;           // don't go out-of-bounds
        if (i >= j) break;                  // check if pointers cross
        exch(a, index, i, j);               // swap two elements into place
    }
    exch(a, index, i, right);               // swap with partition element
    return i;
}

// is x < y ?
private static boolean less(float x, float y) {
    return (x < y);
}

// exchange a[i] and a[j]
private static void exch(float[] a, int[] index, int i, int j) {
    float swap = a[i];
    a[i] = a[j];
    a[j] = swap;
    int b = index[i];
    index[i] = index[j];
    index[j] = b;
}
