// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2010
// PBox2D example

// ContactListener to listen for collisions!

import org.jbox2d.callbacks.ContactImpulse;
import org.jbox2d.callbacks.ContactListener;
import org.jbox2d.collision.Manifold;
import org.jbox2d.dynamics.contacts.Contact;

 class CustomListener implements ContactListener {
  CustomListener() {
  }

  // Collision event functions!
void beginContact(Contact cp) {
  
//  if(cp.isTouching())
//  { println("touch me!");
//  
//  }
  // Get both shapes
  Fixture f1 = cp.getFixtureA();
  Fixture f2 = cp.getFixtureB();
  // Get both bodies
  Body b1 = f1.getBody();
  Body b2 = f2.getBody();

  // Get our objects that reference these bodies
  Object o1 = b1.getUserData();
  Object o2 = b2.getUserData();
  
  // Collisions between boids
  if (o1.getClass() == Boid.class && o2.getClass() == Boid.class) {
    Boid p1 = (Boid) o1;
   // p1.reduceHealth(5);
    Boid p2 = (Boid) o2;
   // p2.reduceHealth(5);
  }

  // Collisions with wall
  if (o1.getClass() == Boundary.class && o2.getClass() == Boid.class) {
    Boid p = (Boid) o2;
    p.note();
    p.wall();
  }
  if (o2.getClass() == Boundary.class && o1.getClass() == Boid.class) {
    Boid p = (Boid) o1;
    p.note();
    p.wall();
  }
  
  if (o1.getClass() == Hell.class && o2.getClass() == Boid.class) {
    Boid p = (Boid) o2;
    //p.reduceHealth(5);
    p.hellBegin();
  }
  
  if (o2.getClass() == Hell.class && o1.getClass() == Boid.class) {
    Boid p = (Boid) o1;
    //p.reduceHealth(5);
    p.hellBegin();
  }  

    if (o1.getClass() == Fluid.class && o2.getClass() == Boid.class) {
    Boid p = (Boid) o2;
    p.fluidBegin();
    
  }
  
  if (o2.getClass() == Fluid.class && o1.getClass() == Boid.class) {
    Boid p = (Boid) o1;
    p.fluidBegin();
    
  }  
  
   if (o1.getClass() == Food.class && o2.getClass() == Boid.class) {
    Boid p = (Boid) o2;
    p.food();
    Food f = (Food) o1;
    f.delete();
  }
  
  if (o2.getClass() == Food.class && o1.getClass() == Boid.class) {
    Boid p = (Boid) o1;
    p.food();
    Food f = (Food) o2;
    f.delete();  
}

// Obstacle collisions not defined

// Food and every other object

 if (o2.getClass() == Food.class && o1.getClass() == Hell.class) {
    Food f = (Food) o2;
    f.delete();  
}

 if (o1.getClass() == Food.class && o2.getClass() == Hell.class) {
    Food f = (Food) o1;
    f.delete();  
}

 if (o2.getClass() == Food.class && o1.getClass() == Boundary.class) {
    Food f = (Food) o2;
    f.delete();  
}

 if (o1.getClass() == Food.class && o2.getClass() == Boundary.class) {
    Food f = (Food) o1;
    f.delete();  
}

 if (o2.getClass() == Food.class && o1.getClass() == Obstacle.class) {
    Food f = (Food) o2;
    f.delete();  
}

 if (o1.getClass() == Food.class && o2.getClass() == Obstacle.class) {
    Food f = (Food) o1;
    f.delete();  
}


}

// Objects stop touching each other
void endContact(Contact cp) {
  
  Fixture f1 = cp.getFixtureA();
  Fixture f2 = cp.getFixtureB();
  // Get both bodies
  Body b1 = f1.getBody();
  Body b2 = f2.getBody();

  // Get our objects that reference these bodies
  Object o1 = b1.getUserData();
  Object o2 = b2.getUserData();
  
    if (o1.getClass() == Hell.class && o2.getClass() == Boid.class) {
    Boid p = (Boid) o2;
    p.hellEnd();
  }
  
  if (o2.getClass() == Hell.class && o1.getClass() == Boid.class) {
    Boid p = (Boid) o1;
    p.hellEnd();
  }  
  
  
    if (o1.getClass() == Fluid.class && o2.getClass() == Boid.class) {
    Boid p = (Boid) o2;
    p.fluidEnd();
  }
  
  if (o2.getClass() == Fluid.class && o1.getClass() == Boid.class) {
    Boid p = (Boid) o1;
    p.fluidEnd();
  }  



}

   void preSolve(Contact contact, Manifold oldManifold) {
    // TODO Auto-generated method stub
  }

   void postSolve(Contact contact, ContactImpulse impulse) {
    // TODO Auto-generated method stub
  }
}




