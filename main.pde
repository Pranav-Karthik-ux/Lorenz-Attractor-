import peasy.*;
import oscP5.*;
import netP5.*;

PeasyCam cam;
OscP5 oscP5;

// Initial conditions for system 1
float x1 = 0.01, y1 = 0, z1 = 0;
float a1 = 10, b1 = 27.5, c1 = 8.0 / 3.0;

// Initial conditions for system 2
float x2 = 0.02, y2 = 0, z2 = 0;
float a2 = 10, b2 = 27.6, c2 = 8.0 / 3.0;

// Store points for plotting
ArrayList<PVector> points1 = new ArrayList<PVector>();
ArrayList<PVector> points2 = new ArrayList<PVector>();

int maxPoints = 800;  // Limit points for performance
boolean paused = false;  // Pause/Resume system
float speedMultiplier = 1.0;

// Camera rotation variables
float rotateX = 0, rotateY = 0;
float rotationSpeed = 0.05;

void setup() {
  size(1200, 600, P3D);
  cam = new PeasyCam(this, 1000);

  // Start OSC listener on port 12000
  oscP5 = new OscP5(this, 12000);
}

void draw() {
  background(0);
  
  // Apply rotation to the camera
  rotateX(rotateX);
  rotateY(rotateY);
  
  if (!paused) {
    float dt = 0.01 * speedMultiplier;

    // Update both systems using RK4
    rk4Step1(dt);
    rk4Step2(dt);

    // Store new points
    points1.add(new PVector(x1, y1, z1));
    points2.add(new PVector(x2, y2, z2));

    // Limit points to avoid memory overflow
    if (points1.size() > maxPoints) points1.remove(0);
    if (points2.size() > maxPoints) points2.remove(0);
  }

  // --- Draw System 1 ---
  pushMatrix();
  translate(0, 0, 0);
  drawPlot(points1, color(100, 255, 255));  // Blue-green color
  popMatrix();

  // --- Draw System 2 ---
  pushMatrix();
  translate(0, 0, 0);
  drawPlot(points2, color(255, 100, 200));  // Pinkish color
  popMatrix();
}

// --- Handle OSC Messages ---
void oscEvent(OscMessage msg) {
  String gesture = msg.get(0).stringValue();

  if (gesture.equals("pause")) {
    paused = !paused;
  } else if (gesture.equals("speed_up")) {
    speedMultiplier = min(speedMultiplier + 0.2, 5.0);  // Cap speed
  } else if (gesture.equals("slow_down")) {
    speedMultiplier = max(speedMultiplier - 0.2, 0.1);
  } else if (gesture.equals("reset")) {
    resetSystems();
  } else if (gesture.equals("rotate_left")) {
    rotateY -= rotationSpeed;
  } else if (gesture.equals("rotate_right")) {
    rotateY += rotationSpeed;
  }
}

// --- Reset System ---
void resetSystems() {
  x1 = 0.01; y1 = 0; z1 = 0;
  x2 = 0.02; y2 = 0; z2 = 0;
  points1.clear();
  points2.clear();
  speedMultiplier = 1.0;
  rotateX = 0;
  rotateY = 0;
}

// --- RK4 Step for System 1 ---
void rk4Step1(float dt) {
  float k1x = dt * dx(x1, y1, z1, a1, b1, c1);
  float k1y = dt * dy(x1, y1, z1, a1, b1, c1);
  float k1z = dt * dz(x1, y1, z1, a1, b1, c1);

  float k2x = dt * dx(x1 + k1x / 2, y1 + k1y / 2, z1 + k1z / 2, a1, b1, c1);
  float k2y = dt * dy(x1 + k1x / 2, y1 + k1y / 2, z1 + k1z / 2, a1, b1, c1);
  float k2z = dt * dz(x1 + k1x / 2, y1 + k1y / 2, z1 + k1z / 2, a1, b1, c1);

  float k3x = dt * dx(x1 + k2x / 2, y1 + k2y / 2, z1 + k2z / 2, a1, b1, c1);
  float k3y = dt * dy(x1 + k2x / 2, y1 + k2y / 2, z1 + k2z / 2, a1, b1, c1);
  float k3z = dt * dz(x1 + k2x / 2, y1 + k2y / 2, z1 + k2z / 2, a1, b1, c1);

  float k4x = dt * dx(x1 + k3x, y1 + k3y, z1 + k3z, a1, b1, c1);
  float k4y = dt * dy(x1 + k3x, y1 + k3y, z1 + k3z, a1, b1, c1);
  float k4z = dt * dz(x1 + k3x, y1 + k3y, z1 + k3z, a1, b1, c1);

  x1 += (k1x + 2 * k2x + 2 * k3x + k4x) / 6;
  y1 += (k1y + 2 * k2y + 2 * k3y + k4y) / 6;
  z1 += (k1z + 2 * k2z + 2 * k3z + k4z) / 6;
}

// --- RK4 Step for System 2 ---
void rk4Step2(float dt) {
  float k1x = dt * dx(x2, y2, z2, a2, b2, c2);
  float k1y = dt * dy(x2, y2, z2, a2, b2, c2);
  float k1z = dt * dz(x2, y2, z2, a2, b2, c2);

  float k2x = dt * dx(x2 + k1x / 2, y2 + k1y / 2, z2 + k1z / 2, a2, b2, c2);
  float k2y = dt * dy(x2 + k1x / 2, y2 + k1y / 2, z2 + k1z / 2, a2, b2, c2);
  float k2z = dt * dz(x2 + k1x / 2, y2 + k1y / 2, z2 + k1z / 2, a2, b2, c2);

  float k3x = dt * dx(x2 + k2x / 2, y2 + k2y / 2, z2 + k2z / 2, a2, b2, c2);
  float k3y = dt * dy(x2 + k2x / 2, y2 + k2y / 2, z2 + k2z / 2, a2, b2, c2);
  float k3z = dt * dz(x2 + k2x / 2, y2 + k2y / 2, z2 + k2z / 2, a2, b2, c2);

  float k4x = dt * dx(x2 + k3x, y2 + k3y, z2 + k3z, a2, b2, c2);
  float k4y = dt * dy(x2 + k3x, y2 + k3y, z2 + k3z, a2, b2, c2);
  float k4z = dt * dz(x2 + k3x, y2 + k3y, z2 + k3z, a2, b2, c2);

  x2 += (k1x + 2 * k2x + 2 * k3x + k4x) / 6;
  y2 += (k1y + 2 * k2y + 2 * k3y + k4y) / 6;
  z2 += (k1z + 2 * k2z + 2 * k3z + k4z) / 6;
}

// --- Lorenz System Equations ---
float dx(float x, float y, float z, float a, float b, float c) {
  return a * (y - x);
}

float dy(float x, float y, float z, float a, float b, float c) {
  return x * (b - z) - y;
}

float dz(float x, float y, float z, float a, float b, float c) {
  return x * y - c * z;
}

// --- Draw Plot with Fade Effect ---
void drawPlot(ArrayList<PVector> points, color plotColor) {
  scale(10);
  noFill();
  beginShape();
  for (int i = 0; i < points.size(); i++) {
    PVector v = points.get(i);
    float alpha = map(i, 0, points.size(), 50, 255);
    stroke(plotColor, alpha);
    vertex(v.x, v.y, v.z);
  }
  endShape();
}
