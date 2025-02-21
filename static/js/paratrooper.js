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

function setup() {
  let canvas = createCanvas(320, 200);
  canvas.parent("game-container");
  resetGame(); // Initialize game state
}

function draw() {
  background(0, 128, 0);
  fill(139, 69, 19);
  rect(0, 190, 320, 10);

  if (keyIsDown(LEFT_ARROW)) gun.rotateLeft();
  if (keyIsDown(RIGHT_ARROW)) gun.rotateRight();
  gun.draw();

  for (let i = shots.length - 1; i >= 0; i--) {
    shots[i].update();
    shots[i].draw();
    if (shots[i].isOffScreen()) shots.splice(i, 1);
  }

  if (millis() - lastHelicopterSpawnTime > 5000) {
    let startLeft = random() < 0.5;
    helicopters.push(new Helicopter(startLeft));
    lastHelicopterSpawnTime = millis();
  }

  for (let i = helicopters.length - 1; i >= 0; i--) {
    helicopters[i].update();
    helicopters[i].draw();
    if (helicopters[i].isOffScreen()) helicopters.splice(i, 1);
  }

  for (let i = paratroopers.length - 1; i >= 0; i--) {
    paratroopers[i].update();
    paratroopers[i].draw();
  }

  if (helicoptersDestroyed >= 5) {
    let startLeft = random() < 0.5;
    jets.push(new Jet(startLeft));
    helicoptersDestroyed = 0;
  }

  for (let i = jets.length - 1; i >= 0; i--) {
    jets[i].update();
    jets[i].draw();
    if (jets[i].isOffScreen()) jets.splice(i, 1);
  }

  for (let i = bombs.length - 1; i >= 0; i--) {
    bombs[i].update();
    bombs[i].draw();
    if (bombs[i].y > 200) bombs.splice(i, 1);
  }

  fill(0, 0, 255);
  for (let x of landedParatroopers) rect(x - 2.5, 185, 5, 10);

  if (landedParatroopers.length >= 4 || gameOver) {
    textSize(32);
    fill(255, 0, 0);
    text("Game Over", 80, 100);
    textSize(16);
    fill(255);
    text("Press R to Restart", 100, 140);
    noLoop(); // Stop the game loop
  }

  fill(255);
  textSize(16);
  text("Score: " + score, 10, 20);

  // Collision detection (unchanged)
  for (let s = shots.length - 1; s >= 0; s--) {
    let shot = shots[s];
    for (let h = helicopters.length - 1; h >= 0; h--) {
      if (dist(shot.x, shot.y, helicopters[h].x, helicopters[h].y) < 10) {
        helicopters.splice(h, 1);
        shots.splice(s, 1);
        score += 20;
        helicoptersDestroyed++;
        break;
      }
    }
    for (let p = paratroopers.length - 1; p >= 0; p--) {
      let paratrooper = paratroopers[p];
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
    for (let j = jets.length - 1; j >= 0; j--) {
      if (dist(shot.x, shot.y, jets[j].x, jets[j].y) < 10) {
        jets.splice(j, 1);
        shots.splice(s, 1);
        score += 30;
        break;
      }
    }
    for (let b = bombs.length - 1; b >= 0; b--) {
      if (dist(shot.x, shot.y, bombs[b].x, bombs[b].y) < 5) {
        bombs.splice(b, 1);
        shots.splice(s, 1);
        score += 50;
        break;
      }
    }
  }
}

function keyPressed() {
  if (key === "z") gun.fire();
  if (key === "r") resetGame(); // Restart on "R" or "r"
}

function resetGame() {
  gun = new Gun();
  shots = [];
  helicopters = [];
  paratroopers = [];
  jets = [];
  bombs = [];
  landedParatroopers = [];
  score = 0;
  gameOver = false;
  lastHelicopterSpawnTime = millis(); // Reset spawn timer
  helicoptersDestroyed = 0;
  loop(); // Restart the game loop
}

// Classes (unchanged)
class Gun {
  constructor() {
    this.x = 160;
    this.y = 190;
    this.angle = 0;
  }
  rotateLeft() {
    this.angle -= 0.05;
    if (this.angle < -HALF_PI) this.angle = -HALF_PI;
  }
  rotateRight() {
    this.angle += 0.05;
    if (this.angle > HALF_PI) this.angle = HALF_PI;
  }
  fire() {
    let velocity = createVector(10 * sin(this.angle), -10 * cos(this.angle));
    shots.push(new Shot(this.x, this.y, velocity));
    score -= 1;
  }
  draw() {
    push();
    translate(this.x, this.y);
    rotate(this.angle);
    fill(255);
    rect(-10, -5, 20, 10);
    line(0, 0, 0, -20);
    pop();
  }
}

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
    fill(255);
    ellipse(this.x, this.y, 5, 5);
  }
  isOffScreen() {
    return this.x < 0 || this.x > 320 || this.y < 0 || this.y > 200;
  }
}

class Helicopter {
  constructor(startLeft) {
    if (startLeft) {
      this.x = 0;
      this.velocity = 1;
    } else {
      this.x = 320;
      this.velocity = -1;
    }
    this.y = random(20, 100);
    this.lastDropTime = millis();
  }
  update() {
    this.x += this.velocity;
    if (millis() - this.lastDropTime > 2000) {
      paratroopers.push(new Paratrooper(this.x, this.y));
      this.lastDropTime = millis();
    }
  }
  draw() {
    fill(255, 0, 0);
    rect(this.x - 10, this.y - 5, 20, 10);
    stroke(255, 0, 0);
    line(this.x - 10, this.y, this.x + 10, this.y);
    line(this.x, this.y - 5, this.x, this.y + 5);
    noStroke();
  }
  isOffScreen() {
    return this.x < 0 || this.x > 320;
  }
}

class Paratrooper {
  constructor(x, y) {
    this.x = x;
    this.y = y;
    this.hasParachute = true;
    this.velocity = 2;
  }
  update() {
    this.y += this.velocity;
    if (!this.hasParachute) this.velocity = 10;
    if (this.y >= 190) {
      if (this.hasParachute) {
        landedParatroopers.push(this.x);
        paratroopers.splice(paratroopers.indexOf(this), 1);
      } else {
        paratroopers.splice(paratroopers.indexOf(this), 1);
        if (landedParatroopers.length > 0) landedParatroopers.pop();
      }
    }
  }
  draw() {
    fill(0, 0, 255);
    rect(this.x - 2.5, this.y - 5, 5, 10);
    if (this.hasParachute) {
      fill(255);
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

class Jet {
  constructor(startLeft) {
    if (startLeft) {
      this.x = 0;
      this.velocity = 2;
    } else {
      this.x = 320;
      this.velocity = -2;
    }
    this.y = random(20, 50);
    this.hasDroppedBomb = false;
  }
  update() {
    this.x += this.velocity;
    if (!this.hasDroppedBomb && abs(this.x - 160) < 10) {
      bombs.push(new Bomb(this.x, this.y));
      this.hasDroppedBomb = true;
    }
  }
  draw() {
    fill(255, 255, 0);
    rect(this.x - 10, this.y - 2.5, 20, 5);
  }
  isOffScreen() {
    return this.x < 0 || this.x > 320;
  }
}

class Bomb {
  constructor(x, y) {
    this.x = x;
    this.y = y;
    this.velocity = 5;
  }
  update() {
    this.y += this.velocity;
    if (this.y >= 190 && abs(this.x - 160) < 10) gameOver = true;
  }
  draw() {
    fill(0);
    ellipse(this.x, this.y, 5, 5);
  }
}
