class Ball {

  float x;
  float y;
  float diameter = 20;
  float radius = diameter/2;
  float magnitude = 3;
  float angle;
  float speedX;        
  float speedY;
  float minSpeed = -radius;
  float maxSpeed = radius;
  int hue = int(random(360));

  Ball () {
    x = width/2;
    y = height/2;
    float angle = random(0, 360);
    if ((345 < angle) && (angle < 360)) {
      angle -= 15;  
    }
    else if ((0 <= angle) && (angle < 15)) {
      angle += 15;  
    }
    else if ((75 < angle) && (angle <= 90)) {
      angle -= 15;  
    }
    else if ((90 < angle) && (angle < 105)) {
      angle += 15;  
    }
    else if ((165 < angle) && (angle <= 180)) {
      angle -= 15;  
    }
    else if ((180 < angle) && (angle < 195)) {
      angle += 15;  
    }
    else if ((255 < angle) && (angle <= 270)) {
      angle -= 15;  
    }
    else if ((270 < angle) && (angle < 285)) {
      angle += 5;  
    }
    speedX = magnitude*cos(radians(angle));
    speedY = magnitude*sin(radians(angle));
  }

  void update() {
    // Draw ball
    fill(0, 0, 100);
    noStroke();
    ellipse(x, y, diameter, diameter);

    // Update location
    x += speedX;
    y += speedY;

    // Resets things if the ball leaves the screen
    if ((x > width + diameter) || (x < -diameter) || (y > height + diameter) || (y < -diameter)) {
      miss.trigger();
      numBalls++;
      life--;
    }

    // If LEFT/RIGHT Bumpers activated, change direction of X

    if ((x < 128 + radius) && (x > 128) && (y >= 128) && (y <= 640) && (keyleft)) {
      collide.trigger();
      x = 128 + radius;
      speedX = speedX * -1.2;
      if (speedX < minSpeed) {
        speedX = minSpeed;  
      }
      else if (speedX > maxSpeed) {
        speedX = maxSpeed;  
      }
      x = x + speedX;
      score++;
    }
    
    else if ((x > 896 - radius) && (x < 896) && (y >= 128) && (y <= 640) && (keyright)) {
      collide.trigger();
      x = 896 - radius;
      speedX = speedX * -1.2;
      if (speedX < minSpeed) {
        speedX = minSpeed;  
      }
      else if (speedX > maxSpeed) {
        speedX = maxSpeed;  
      }
      x = x + speedX;
      score++;
    }

    // If TOP/BOTTOM Bumpers activated, change direction of Y  
    if ((y < 128 + radius) && (y > 128) && (x >= 128) && (x <= 896) && (keyup)) {
      collide.trigger();
      y = 128 + radius;
      speedY = speedY * -1.2;
      if (speedY < minSpeed) {
        speedY = minSpeed;  
      }
      else if (speedY > maxSpeed) {
        speedY = maxSpeed;  
      }
      y = y + speedY;
      score++;
    } 
    
    else if ((y > 640 - radius) && (y < 640) && (x >= 128) && (x <= 896) && (keydown)) {
      collide.trigger();
      y = 640 - radius;
      speedY = speedY * -1.2;
      if (speedY < minSpeed) {
        speedY = minSpeed;  
      }
      else if (speedY > maxSpeed) {
        speedY = maxSpeed;  
      }
      y = y + speedY;
      score++;
    }

    // Changing hue
    if (hue > 360) {
      hue = 0;
    }
    else {
      hue = hue + 10;
    }
  }
}
