// Global variables
let gun;
let shots = [];
let helicopters = [];
let paratroopers = [];
let jets = [];
let bombs = [];
let landedParatroopers = [];
let score = 0;
let gameOver = false;
let lastHelicopterSpawnTime = 0;
let helicoptersDestroyed = 0;

// Setup function to initialize the canvas and gun
function setup() {
  createCanvas(320, 200); // Canvas size matching original resolution
  //canvas.parent("game-container"); //attach canvas to game-container div
  gun = new Gun();
}

// Draw function to handle game loop
function draw() {
  background(0, 128, 0); // Green background
  fill(139, 69, 19); // Brown ground
  rect(0, 190, 320, 10);

  // Gun control
  if (keyIsDown(LEFT_ARROW)) {
    gun.rotateLeft();
  }
  if (keyIsDown(RIGHT_ARROW)) {
    gun.rotateRight();
  }
  gun.draw();

  // Update and draw shots
  for (let i = shots.length - 1; i >= 0; i--) {
    shots[i].update();
    shots[i].draw();
    if (shots[i].isOffScreen()) {
      shots.splice(i, 1);
    }
  }

  // Spawn helicopters every 5 seconds
  if (millis() - lastHelicopterSpawnTime > 5000) {
    let startLeft = random() < 0.5;
    let helicopter = new Helicopter(startLeft);
    helicopters.push(helicopter);
    lastHelicopterSpawnTime = millis();
  }

  // Update and draw helicopters
  for (let i = helicopters.length - 1; i >= 0; i--) {
    helicopters[i].update();
    helicopters[i].draw();
    if (helicopters[i].isOffScreen()) {
      helicopters.splice(i, 1);
    }
  }

  // Update and draw paratroopers
  for (let i = paratroopers.length - 1; i >= 0; i--) {
    paratroopers[i].update();
    paratroopers[i].draw();
  }

  // Spawn jets after every 5 helicopters destroyed
  if (helicoptersDestroyed >= 5) {
    let startLeft = random() < 0.5;
    let jet = new Jet(startLeft);
    jets.push(jet);
    helicoptersDestroyed = 0;
  }

  // Update and draw jets
  for (let i = jets.length - 1; i >= 0; i--) {
    jets[i].update();
    jets[i].draw();
    if (jets[i].isOffScreen()) {
      jets.splice(i, 1);
    }
  }

  // Update and draw bombs
  for (let i = bombs.length - 1; i >= 0; i--) {
    bombs[i].update();
    bombs[i].draw();
    if (bombs[i].y > 200) {
      bombs.splice(i, 1);
    }
  }

  // Draw landed paratroopers
  fill(0, 0, 255);
  for (let x of landedParatroopers) {
    rect(x - 2.5, 185, 5, 10);
  }

  // Check for game over conditions
  if (landedParatroopers.length >= 4 || gameOver) {
    textSize(32);
    fill(255, 0, 0);
    text("Game Over", 80, 100);
    noLoop();
  }

  // Display score
  fill(255);
  textSize(16);
  text("Score: " + score, 10, 20);

  // Collision detection
  for (let s = shots.length - 1; s >= 0; s--) {
    let shot = shots[s];
    // Check against helicopters
    for (let h = helicopters.length - 1; h >= 0; h--) {
      let helicopter = helicopters[h];
      if (dist(shot.x, shot.y, helicopter.x, helicopter.y) < 10) {
        helicopters.splice(h, 1);
        shots.splice(s, 1);
        score += 20;
        helicoptersDestroyed++;
        break;
      }
    }
    // Check against paratroopers
    for (let p = paratroopers.length - 1; p >= 0; p--) {
      let paratrooper = paratroopers[p];
      // Hit body
      if (
        shot.x > paratrooper.x - 2.5 &&
        shot.x < paratrooper.x + 2.5 &&
        shot.y > paratrooper.y - 5 &&
        shot.y < paratrooper.y + 5
      ) {
        paratroopers.splice(p, 1);
        shots.splice(s, 1);
        score += 10;
        break;
      }
      // Hit parachute
      if (
        paratrooper.hasParachute &&
        shot.x > paratrooper.x - 5 &&
        shot.x < paratrooper.x + 5 &&
        shot.y > paratrooper.y - 15 &&
        shot.y < paratrooper.y - 10
      ) {
        paratrooper.hasParachute = false;
        shots.splice(s, 1);
        break;
      }
    }
    // Check against jets
    for (let j = jets.length - 1; j >= 0; j--) {
      let jet = jets[j];
      if (dist(shot.x, shot.y, jet.x, jet.y) < 10) {
        jets.splice(j, 1);
        shots.splice(s, 1);
        score += 30;
        break;
      }
    }
    // Check against bombs
    for (let b = bombs.length - 1; b >= 0; b--) {
      let bomb = bombs[b];
      if (dist(shot.x, shot.y, bomb.x, bomb.y) < 5) {
        bombs.splice(b, 1);
        shots.splice(s, 1);
        score += 50;
        break;
      }
    }
  }
}

// Handle key presses for firing
function keyPressed() {
  if (key === "z") {
    gun.fire();
  }
}

// Gun class
class Gun {
  constructor() {
    this.x = 160; // Center of canvas
    this.y = 190; // Near bottom
    this.angle = 0; // Straight up initially
  }
  rotateLeft() {
    this.angle -= 0.05;
    if (this.angle < -HALF_PI) this.angle = -HALF_PI; // Limit to -90 degrees
  }
  rotateRight() {
    this.angle += 0.05;
    if (this.angle > HALF_PI) this.angle = HALF_PI; // Limit to 90 degrees
  }
  fire() {
    let velocity = createVector(10 * sin(this.angle), -10 * cos(this.angle));
    let shot = new Shot(this.x, this.y, velocity);
    shots.push(shot);
    score -= 1; // Decrease score per shot
  }
  draw() {
    push();
    translate(this.x, this.y);
    rotate(this.angle);
    fill(255); // White gun
    rect(-10, -5, 20, 10); // Base
    line(0, 0, 0, -20); // Barrel
    pop();
  }
}

// Shot class
class Shot {
  constructor(x, y, velocity) {
    this.x = x;
    this.y = y;
    this.velocity = velocity;
  }
  update() {
    this.x += this.velocity.x;
    this.y += this.velocity.y;
  }
  draw() {
    fill(255); // White shot
    ellipse(this.x, this.y, 5, 5);
  }
  isOffScreen() {
    return this.x < 0 || this.x > 320 || this.y < 0 || this.y > 200;
  }
}

// Helicopter class
class Helicopter {
  constructor(startLeft) {
    if (startLeft) {
      this.x = 0;
      this.velocity = 1; // Move right
    } else {
      this.x = 320;
      this.velocity = -1; // Move left
    }
    this.y = random(20, 100); // Random height
    this.lastDropTime = millis();
  }
  update() {
    this.x += this.velocity;
    if (millis() - this.lastDropTime > 2000) {
      let paratrooper = new Paratrooper(this.x, this.y);
      paratroopers.push(paratrooper);
      this.lastDropTime = millis();
    }
  }
  draw() {
    fill(255, 0, 0); // Red body
    rect(this.x - 10, this.y - 5, 20, 10);
    stroke(255, 0, 0); // Red rotor
    line(this.x - 10, this.y, this.x + 10, this.y);
    line(this.x, this.y - 5, this.x, this.y + 5);
    noStroke();
  }
  isOffScreen() {
    return this.x < 0 || this.x > 320;
  }
}

// Paratrooper class
class Paratrooper {
  constructor(x, y) {
    this.x = x;
    this.y = y;
    this.hasParachute = true;
    this.velocity = 2; // Slow fall with parachute
  }
  update() {
    this.y += this.velocity;
    if (!this.hasParachute) {
      this.velocity = 10; // Fast fall without parachute
    }
    if (this.y >= 190) {
      if (this.hasParachute) {
        landedParatroopers.push(this.x);
        paratroopers.splice(paratroopers.indexOf(this), 1);
      } else {
        paratroopers.splice(paratroopers.indexOf(this), 1);
        if (landedParatroopers.length > 0) {
          landedParatroopers.pop(); // Remove one landed paratrooper
        }
      }
    }
  }
  draw() {
    fill(0, 0, 255); // Blue body
    rect(this.x - 2.5, this.y - 5, 5, 10);
    if (this.hasParachute) {
      fill(255); // White parachute
      triangle(
        this.x - 5,
        this.y - 10,
        this.x,
        this.y - 15,
        this.x + 5,
        this.y - 10,
      );
    }
  }
}

// Jet class
class Jet {
  constructor(startLeft) {
    if (startLeft) {
      this.x = 0;
      this.velocity = 2; // Move right, faster than helicopter
    } else {
      this.x = 320;
      this.velocity = -2; // Move left
    }
    this.y = random(20, 50); // Higher altitude
    this.hasDroppedBomb = false;
  }
  update() {
    this.x += this.velocity;
    if (!this.hasDroppedBomb && abs(this.x - 160) < 10) {
      let bomb = new Bomb(this.x, this.y);
      bombs.push(bomb);
      this.hasDroppedBomb = true;
    }
  }
  draw() {
    fill(255, 255, 0); // Yellow jet
    rect(this.x - 10, this.y - 2.5, 20, 5);
  }
  isOffScreen() {
    return this.x < 0 || this.x > 320;
  }
}

// Bomb class
class Bomb {
  constructor(x, y) {
    this.x = x;
    this.y = y;
    this.velocity = 5; // Falls straight down
  }
  update() {
    this.y += this.velocity;
    if (this.y >= 190 && abs(this.x - 160) < 10) {
      gameOver = true; // Hits gun
    }
  }
  draw() {
    fill(0); // Black bomb
    ellipse(this.x, this.y, 5, 5);
  }
}
