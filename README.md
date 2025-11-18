# Lorenz Attractor Visualization (Processing)
![ Lorenz Attractor](lorenz.gif)
This project visualizes two Lorenz attractors with slightly different parameter values, rendered in 3D using **Processing** and **PeasyCam**. It includes smooth trajectories, fading trails.
---

## 📌 Features
- Real-time 3D rendering of the Lorenz system  
- Two attractors with different parameters for comparison  
- RK4 numerical integration for smooth and accurate motion  
- Fade-trail drawing for visual clarity  
- Fully rotatable camera (PeasyCam)  

---

## 🧠 About the Lorenz System
The Lorenz equations are:
dx/dt = a(y - x)
dy/dt = x(b - z) - y
dz/dt = xy - cz

They produce chaotic behavior and the iconic “butterfly” attractor.

---

## 📦 Requirements
Install these Processing libraries:

- **PeasyCam** (for 3D camera control)  

Install via:  
`Sketch → Import Library → Add Library…`

---

## ▶️ Running the Sketch
1. Open the `.pde` file in Processing  
2. Install the required libraries  
3. Click **Run**  

### Camera Controls (PeasyCam)
- Drag → rotate  
- Scroll → zoom  
- Right-click drag → pan  

---


---

## 🧩 How It Works
- Uses **Runge–Kutta 4 (RK4)** integration  
- Trails drawn using fading alpha  
- Two attractors use slightly different parameters to show chaotic divergence  

---

## 📜 License
Feel free to modify or use this project for personal, academic, or creative work.


