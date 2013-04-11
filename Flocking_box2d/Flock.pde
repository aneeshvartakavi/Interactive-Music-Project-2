// Flocking
// Daniel Shiffman <http://www.shiffman.net>
// The Nature of Code

// Flock class
// Does very little, simply manages the ArrayList of all the boids

class Flock {
  ArrayList<Boid> boids; // An arraylist for all the boids

  Flock() {
    boids = new ArrayList<Boid>(); // Initialize the arraylist
  }

  void run() {
    for (int i = boids.size()-1; i >= 0; i--) {
    Boid b = boids.get(i);
    b.run(boids);
    b.display();
    // Particles that leave the screen, we delete them
    // (note they have to be deleted from both the box2d world and our list
    if (b.done()) {
      boids.remove(i);
    }
  }
}
  void addBoid(Boid b) {
    boids.add(b);
  }

}


