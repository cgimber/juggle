String TITLE = "Juggle";
String BY = "by Christian Gimber";
String INSTRUCTIONS;
String START;
String GAMEOVER = "GAME\nOVER";
String REPLAY;
String CONTINUE;
String CONTINUE2;

void setInterfaceStrings(Boolean touchSensor) {
  if (touchSensor) {
    INSTRUCTIONS = "Juggle to survive\nWall sensors activate bumpers";
    START = "-Touch any wall to begin-";
    REPLAY = "-Touch any wall to play again-";
    CONTINUE = "-Touch right wall to continue-";
    CONTINUE2 = "-Touch any wall to continue-";
  } else {
    INSTRUCTIONS = "Juggle to survive\nArrow keys activate bumpers";
    START = "-Press space to begin-";
    REPLAY = "-Press space to play again-";
    CONTINUE = "-Press space to continue-";
    CONTINUE2 = "-Press space to continue-";
  }
}

void beginGame() {
  textAlign(CENTER);
  textSize(150);
  fill(hue, 100, 100, 75);
  text (TITLE, width/2 - 27, height/2 - 95);
  fill(0, 0, 100);
  text (TITLE, width/2 - 30, height/2 - 100);
  textSize(20);
  text (VERSION, width/2 + 320, height/2 - 100);
  textSize(30);
  text (BY, width/2 + 90, height/2 - 50);
  textLeading(50);
  textAlign(LEFT);
  text (INSTRUCTIONS, width/2 - 280, height/2 + 50);
  if ((frameCount%60 >= 30) && (frameCount%60 <= 60)) {
    textAlign(CENTER);
    text (START, width/2, height/2 + 200);
  }
}

void countDown() {
  if ((timer1 == 3) && (soundcount2 == 4)) {
    soundcount2--;
    if (soundcount2 == 3) {
      countdown.trigger();
      textSize(120);  
      textAlign(CENTER);
      fill(0, 0, 100);  
      text(3, width/2, height/2 + 30);
    }
  }

  if ((timer1 == 2) && (soundcount2 == 3)) {
    soundcount2--;
    if (soundcount2 == 2) {
      countdown.trigger();
      textSize(120);  
      textAlign(CENTER);
      fill(0, 0, 100);  
      text(2, width/2, height/2 + 30);
    }
  }

  if ((timer1 == 1) && (soundcount2 == 2)) {
    soundcount2--;
    if (soundcount2 == 1) {
      countdown.trigger();
      textSize(120);  
      textAlign(CENTER);
      fill(0, 0, 100);  
      text(1, width/2, height/2 + 30);
    }
  }
}

void endGame() {
  soundcount1--;
  lose.play();

  textAlign(CENTER);
  textSize(150);
  textLeading(150);
  fill(hue, 100, 100, 75);
  text (GAMEOVER, width/2+3, height/2 - 50+5);
  fill(0, 0, 100);
  text (GAMEOVER, width/2, height/2 - 50);
  if ((frameCount%60 >= 30) && (frameCount%60 <= 60)) {
    textSize(30);
    text (CONTINUE2, width/2, height/2 + 170);
  }
  if (soundcount1 == 0) {
    lose.mute();
  }
}

void HUD() {
  int x0 = 98; 

  if ((score >= 1) && (life > 0)) {
    textFont(OutageOutline);
    fill(0, 0, 100, 200);
    textAlign(CENTER);
    textSize(300);
    text(score, width/2, height/2 + 100);
  } else if (life < 1) {
    textFont(OutageReg);
    fill(0, 0, 100, 200);
    textAlign(RIGHT);
    textSize(30);
    text("Final Score: " + score, 935, 60);
  }

  if (life == 3) {
    // Ball 1
    fill(0, 0, 100, 200);
    noStroke();
    ellipse(x0, 48, 20, 20);

    // Ball 2
    fill(0, 0, 100, 200);
    noStroke();
    ellipse(x0 + 40, 48, 20, 20);

    // Ball 3
    fill(0, 0, 100, 200);
    noStroke();
    ellipse(x0 + 80, 48, 20, 20);
  }

  if (life == 2) {
    // Ball 1
    fill(0, 0, 100, 200);
    noStroke();
    ellipse(x0, 48, 20, 20);

    // Ball 2
    fill(0, 0, 100, 200);
    noStroke();
    ellipse(x0 + 40, 48, 20, 20);

    // Ball 3
    noFill();
    strokeWeight(2);
    stroke(0, 0, 100, 200);
    ellipse(x0 + 80, 48, 18, 18);
  }

  if (life == 1) {
    // Ball 1
    fill(0, 0, 100, 200);
    noStroke();
    ellipse(x0, 48, 20, 20);

    // Ball 2
    noFill();
    strokeWeight(2);
    stroke(0, 0, 100, 200);
    ellipse(x0 + 40, 48, 18, 18);

    // Ball 3
    noFill();
    strokeWeight(2);
    stroke(0, 0, 100, 200);
    ellipse(x0 + 80, 48, 18, 18);
  }

  if (life == 0) {
    // Ball 1
    noFill();
    strokeWeight(2);
    stroke(0, 0, 100, 200);
    ellipse(x0, 48, 18, 18);

    // Ball 2
    noFill();
    strokeWeight(2);
    stroke(0, 0, 100, 200);
    ellipse(x0 + 40, 48, 18, 18);

    // Ball 3
    noFill();
    strokeWeight(2);
    stroke(0, 0, 100, 200);
    ellipse(x0 + 80, 48, 18, 18);
  }
}

void input() {
  // Bumper Controls
  if (keyleft) {
    bumpLEFT.bump();
  } else if (keyright) {
    bumpRIGHT.bump();
  }  

  if (keyup) {
    bumpTOP.bump();
  } else if (keydown) {
    bumpBOTTOM.bump();
  }
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) keyup = true; 
    if (keyCode == DOWN) keydown = true; 
    if (keyCode == LEFT) keyleft = true; 
    if (keyCode == RIGHT) keyright = true;
  } else {
    if (key == 'a') keyleft = true; 
    if (key == 'd') keyright = true;
    if (key == 's') keydown = true;
    if (key == 'w') keyup = true;
    if (key == 32) {
      spacebar = true;
      keyPress++;
    }
  }
}

void keyReleased() {
  if (key == CODED) {
    if (keyCode == UP) keyup = false; 
    if (keyCode == DOWN) keydown = false; 
    if (keyCode == LEFT) keyleft = false; 
    if (keyCode == RIGHT) keyright = false;
  } else {
    if (key == 'a') keyleft = false; 
    if (key == 'd') keyright = false;
    if (key == 's') keydown = false;
    if (key == 'w') keyup = false;
    if (key == 32) {
      spacebar = false;
      keyPress = 0;
    }
  }
}

void serialEvent(Serial myPort) { 
  // get the ASCII string:
  String inString = myPort.readStringUntil('\n');

  if (inString != null) 
  {
    // trim off any whitespace:
    inString = trim(inString);
    // split the string on the commas and convert the 
    // resulting substrings into an integer array:
    float[] touches = float(split(inString, ","));
    // if the array has at least three elements, you know
    // you got the whole thing.  Put the numbers in the
    // touchX variables:
    if (touches.length >=4) 
    {
      //       println("sensor1Value:"+touches[0]+" sensor2Value:"+touches[1]+" sensor3Value:"+touches[2]+" sensor4Value:"+touches[3]);
      touch1Value = touches[0] >= threshold1 ? 1: 0;
      touch2Value = touches[1] >= threshold1 ? 1: 0;
      touch3Value = touches[2] >= threshold2 ? 1: 0;
      touch4Value = touches[3] >= threshold2 ? 1: 0;
    }
  }
}

void serialInput() {

  //Mapping touchVals to keys
  if (touch4Value == 1) {
    keyup = true;
  } else {
    keyup = false;
  }
  if (touch1Value == 1) {
    keydown = true;
  } else {
    keydown = false;
  }
  if (touch2Value == 1) {
    keyleft = true;
  } else {
    keyleft = false;
  }
  if (touch3Value == 1) {
    keyright = true;
  } else {
    keyright = false;
  }

  //Restrict sensor combos
  if ((keyup == true) && (keydown == true)) {
    keydown = false;
  }  
  if ((keyleft == true) && (keyright == true)) {
    keyright = false;
  }  

  // Track keyPress
  if ((keyup)||(keydown)||(keyleft)||(keyright)) {
    keyPress++;
  } else {
    keyPress = 0;
  }

  //  println("keyup: "+keyup+"  keydown: "+keydown+"  keyleft: "+keyleft+"  keyright: "+keyright);
  //println(keyPress);
}

void resetKeys() {
  keyup = false;
  keyright = false;
  keyleft = false;
  keydown = false;
}