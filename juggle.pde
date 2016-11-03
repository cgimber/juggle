import processing.serial.*;
import ddf.minim.*;

/////  EACH COLLISION INCREASES BALL SPEED by MULTIPLIER  (mult = 1.2)
/////  ARROW KEYS OR LIVECADE* MODES
/////  *Using CapSense Arduino and Serial Comm

String VERSION = "v2.0";

// Configure input here (keyboard is the default):
Boolean sensorInput = false;

// Sounds
Minim minim;
AudioPlayer intro;
AudioPlayer bgmusic;
AudioPlayer bumpershift;
AudioSample collide;
AudioSample spawn;
AudioSample miss;
int soundcount1 = 30;
AudioPlayer lose;
int soundcount2 = 4;
AudioSample countdown;

// Array of ball objects
int totalBalls = 100000;
Ball[] balls = new Ball[totalBalls];
int numBalls = 0;

// Set game mode, life, score, etc
String gameMode = "start";
int score = 0;
int life = 3;
int begintime1 = 6;
int start1;
int timer1;
StopWatchTimer sw;
int inactivity = 300;  //seconds

// Highscores
boolean highscore = false;
String[] scores = new String[5];
String scoreString = "";
int currentLetter1 = 65;
int currentLetter2 = 65;
int currentLetter3 = 65;
int letterActive = 1;
int scoreIndex = -1;

// Bumper objects
int hue = int(random(360));
BumperLEFT bumpLEFT;
BumperRIGHT bumpRIGHT;
BumperTOP bumpTOP;
BumperBOTTOM bumpBOTTOM;

// Inputs
boolean keyup = false;
boolean keyright = false;
boolean keyleft = false;
boolean keydown = false;
boolean spacebar = false;

int touch1Value = 0;        // sensor 1 value
int touch2Value = 0;        // sensor 2 value
int touch3Value = 0;        // sensor 3 value
int touch4Value = 0;        // sensor 4 value

// 10k R --> 10
// 1M R --> 100
// 1M fullscale --> 750
int threshold1 = 800;
int threshold2 = 1100;
int keyPress = 0;

Serial myPort;

// Fonts
PFont OutageReg;
PFont OutageOutline;

void setup() {
  noCursor();
  colorMode(HSB, 360, 100, 100);
  size(1024, 768);
  background(0, 0, 50);

  println(Serial.list());

  if (sensorInput) {
    // Configure Serial Com
    myPort = new Serial(this, Serial.list()[5], 9600);
    // don't generate a serialEvent() unless you get a newline character:
    myPort.bufferUntil('\n');
  }

  setInterfaceStrings(sensorInput);

  minim = new Minim(this);

  // load wavs from the data folder
  intro = minim.loadFile("bassfreak-8-bit-groove-loop.mp3");
  intro.loop();
  bgmusic = minim.loadFile("looperman-l-1195218-0071492-decus-nutty-computer.wav");
  bumpershift = minim.loadFile("bumpershift_02.wav");
  collide = minim.loadSample( "collide_01.wav", 512);
  spawn = minim.loadSample( "spawn_01.wav", 512);
  miss = minim.loadSample( "miss_01.wav", 512);
  lose = minim.loadFile("lose_01.wav");
  countdown = minim.loadSample( "countdown_03.wav", 512);

  OutageReg = createFont("Outage.ttf", 20);
  textFont(OutageReg);
  OutageOutline = createFont("Outage_Outline-Outline.otf", 20);

  bumpLEFT = new BumperLEFT(128, 128, 128, 640);
  bumpRIGHT = new BumperRIGHT(896, 128, 896, 640);
  bumpTOP = new BumperTOP(128, 128, 896, 128);
  bumpBOTTOM = new BumperBOTTOM(128, 640, 896, 640);

  // fill ball array
  for (int i = 0; i < balls.length; i++) {
    balls[i] = new Ball();
  }

  //  // fill highscore array with defaults
  //  for (int i=0; i<scores.length; i++) {
  //    scores[i] = "CSG10";
  //  }

  // load saved highscores from txt file
  for (int i=0; i<scores.length; i++) {
    scores[i] = loadStrings("highscores.txt")[i];
  }

  // Initialize Timer
  sw = new StopWatchTimer();
}

void draw() {
  // println(frameRate);

  fill(hue + 180, 50, 100, 100);
  noStroke();
  rect(0, 0, width, height);

  // Changing hue
  if (hue > 360) {
    hue = 0;
  } else {
    hue = hue + 10;
  }

  // Input mode
  if (sensorInput) {
    serialInput();
  }
  // Bumpers are not active in highscore screens
  if ((gameMode == "intro") || ((gameMode == "play") && (life > 0))) {
    input();
  }

  if (gameMode == "start") {
    beginGame();
  }

  if (sensorInput) {
    if ((gameMode == "start") && ((keyup)||(keydown)||(keyleft)||(keyright)) && (keyPress <= 1)) {
      gameMode = "intro";
      intro.pause();
      start1 = millis();
    }
  } else {
    if ((gameMode == "start") && spacebar && keyPress <= 1) {
      gameMode = "intro";
      intro.pause();
      start1 = millis();
    }
  }

  if (gameMode == "intro") {

    // Draw game elements
    bumpLEFT.display();
    bumpRIGHT.display();
    bumpTOP.display();
    bumpBOTTOM.display();

    // TIMER1 FOR BALL START
    // Record millis
    int ms1 = millis()-start1;

    // Convert millis to secs
    int sec1 = ms1/1000;

    // Start timer1 in secs
    timer1 = begintime1 - sec1;

    if (timer1 <= 3) {
      HUD();
    }

    countDown();
  }

  if ((gameMode == "intro") && (life > 0) && (timer1 <= 0)) {
    lose.rewind();
    gameMode = "play";
    bgmusic.loop();
  }

  if (gameMode == "play") {
    // Draw game elements
    bumpLEFT.display();
    bumpRIGHT.display();
    bumpTOP.display();
    bumpBOTTOM.display();

    HUD();

    if (life > 0) {
      // Ball behavior
      balls[numBalls].update();
    }
  }

  if ((life == 0) && (gameMode == "play")) {
    endGame();
    bgmusic.pause();
    sw.start();

    if (score>=(Integer.parseInt(scores[4].substring(3, scores[4].length())))) {
      highscore = true;
      if (((keyup)||(keydown)||(keyleft)||(keyright)) && (keyPress <= 1)) {
        gameMode = "name enter screen";
        //      letterActive = 1;
      }
    } else if (score<=(Integer.parseInt(scores[4].substring(3, scores[4].length())))) {
      highscore = false;
      if (sensorInput) {
        if (((keyup)||(keydown)||(keyleft)||(keyright)) && (keyPress <= 1))
          gameMode = "highscores";
      } else {
        if (spacebar && (keyPress <= 1)) {
          println("gameover keyPress: " + keyPress);
          gameMode = "highscores";
        }
      }
    }
  }

  if (gameMode == "name enter screen") {

    // Display enter name enter screen

    textAlign(CENTER);

    textSize(100);
    fill(hue, 100, 100, 75);
    text("New Record!", width/2+3, 128+75+5);
    fill(0, 0, 100);
    text("New Record!", width/2, 128+75);

    textSize(50);
    text("Enter your name", width/2, 256+75);

    textSize(150);

    if (letterActive == 1) {
      textAlign(CENTER, CENTER);

      // blinking arrows
      if ((frameCount%60 >= 30) && (frameCount%60 <= 60)) {
        if (currentLetter1 < 90) { 
          text("ˆ", 256+22, height/2-25+100);
        }
        if (currentLetter1 > 65) { 
          text("ˇ", 256+22, height/2+175+100);
        }
        pushMatrix();
        translate(256+55, height/2+100);
        rotate(PI/2);
        text("ˆ", 0, 0);
        popMatrix();
      }
      text(char(currentLetter1), 256+22, height/2+100);
      text(char(currentLetter2), width/2, height/2+100);
      text(char(currentLetter3), width-256-22, height/2+100);

      // name input controls
      if ((keydown == true) && (keyPress <= 1)) {
        if (currentLetter1 > 65) { 
          currentLetter1--;
        }
      }
      if ((keyup == true) && (keyPress <= 1)) {
        if (currentLetter1 < 90) { 
          currentLetter1++;
        }
      }
      if ((keyright == true) && (keyPress <= 1)) {
        letterActive++;
      }
    } else if (letterActive == 2) {
      textAlign(CENTER, CENTER);

      text(char(currentLetter1), 256+22, height/2+100);

      // blinking arrows
      if ((frameCount%60 >= 30) && (frameCount%60 <= 60)) {
        if (currentLetter2 < 90) { 
          text("ˆ", width/2, height/2-25+100);
        }
        if (currentLetter2 > 65) { 
          text("ˇ", width/2, height/2+175+100);
        }
        pushMatrix();
        translate(width/2-35, height/2+100);
        rotate(-PI/2);
        text("ˆ", 0, 0);
        popMatrix();
        pushMatrix();
        translate(width/2+35, height/2+100);
        rotate(PI/2);
        text("ˆ", 0, 0);
        popMatrix();
      }
      text(char(currentLetter2), width/2, height/2+100);
      text(char(currentLetter3), width-256-22, height/2+100);

      // name input controls
      if ((keydown == true) && (keyPress <= 1)) {
        if (currentLetter2 > 65) { 
          currentLetter2--;
        }
      }
      if ((keyup == true) && (keyPress <= 1)) {
        if (currentLetter2 < 90) { 
          currentLetter2++;
        }
      }
      if ((keyleft == true) && (keyPress <= 1)) {
        letterActive--;
      }
      if ((keyright == true) && (keyPress <= 1)) {
        letterActive++;
      }
    } else if (letterActive == 3) {
      textAlign(CENTER, CENTER);

      text(char(currentLetter1), 256+22, height/2+100);
      text(char(currentLetter2), width/2, height/2+100);

      // blinking arrows
      if ((frameCount%60 >= 30) && (frameCount%60 <= 60)) {
        if (currentLetter3 < 90) { 
          text("ˆ", width-256-22, height/2-25+100);
        }
        if (currentLetter3 > 65) { 
          text("ˇ", width-256-22, height/2+175+100);
        }
        pushMatrix();
        translate(width-256-22-35, height/2+100);
        rotate(-PI/2);
        text("ˆ", 0, 0);
        popMatrix();
        pushMatrix();
        translate(width-256-22+35, height/2+100);
        rotate(PI/2);
        text("ˆ", 0, 0);
        popMatrix();
      }
      text(char(currentLetter3), width-256-22, height/2+100);

      // name input controls
      if ((keydown == true) && (keyPress <= 1)) {
        if (currentLetter3 > 65) { 
          currentLetter3--;
        }
      }
      if ((keyup == true) && (keyPress <= 1)) {
        if (currentLetter3 < 90) { 
          currentLetter3++;
        }
      }
      if ((keyleft == true) && (keyPress <= 1)) {
        letterActive--;
      }
      if ((keyright == true) && (keyPress <= 1)) {
        letterActive++;
      }
    } else if (letterActive == 4) {
      textAlign(CENTER, CENTER);

      text(char(currentLetter1), 256+22, height/2+100);
      text(char(currentLetter2), width/2, height/2+100);
      text(char(currentLetter3), width-256-22, height/2+100);

      // continue prompt
      if ((frameCount%60 >= 30) && (frameCount%60 <= 60)) {
        textSize(30);
        text (CONTINUE, width/2, height/2 + 170+100);
      }  

      // name input controls
      if ((keyleft == true) && (keyPress <= 1)) {
        letterActive--;
      }
      if ((keyright == true) && (keyPress <= 1)) {
        scoreString = str(char(currentLetter1))+str(char(currentLetter2))+str(char(currentLetter3))+score;
        scoreIndex = addNewScore(scoreString);

        // Save highscores
        saveStrings("highscores.txt", scores);

        // reset input screen
        currentLetter1 = 65;
        currentLetter2 = 65;
        currentLetter3 = 65;
        letterActive = 1;

        gameMode = "updated highscores";
      }
    }

    //    resetKeys();

    // reset if inactive for x mins
    if (sw.second() >= inactivity) {
      // Reset game
      gameMode = "start";
      score = 0;
      life = 3;
      numBalls++;
      start1 = millis();
      begintime1 = 3;
      soundcount1 = 100;
      lose.unmute();
      soundcount2 = 4;
      intro.loop();

      highscore = false;
      currentLetter1 = 65;
      currentLetter2 = 65;
      currentLetter3 = 65;
      letterActive = 1;
    }
  }

  if (gameMode == "updated highscores") {

    // Display updated highscore screen with flashing score
    textSize(30);
    textAlign(LEFT);

    pushMatrix();
    translate(110, 0);

    // latest score highlight
    fill(hue, 100, 100, 75);
    text(scoreIndex+1, 128+1, 208+80*scoreIndex+3);
    text(scores[scoreIndex].substring(0, 3), 348+1, 208+80*scoreIndex+3);
    text(scores[scoreIndex].substring(3, scores[scoreIndex].length()), 568+1, 208+80*scoreIndex+3);

    fill(0, 0, 100);

    text("Rank ", 128, 128);
    for (int i=0; i<scores.length; i++) {
      text(i+1, 128, 208+80*i);
    }

    text("Name ", 348, 128);
    for (int i=0; i<scores.length; i++) {
      text(scores[i].substring(0, 3), 348, 208+80*i);
    }

    text("Score ", 568, 128);
    for (int i=0; i<scores.length; i++) {
      text(scores[i].substring(3, scores[i].length()), 568, 208+80*i);
    }

    // Replay prompt
    if ((frameCount%60 >= 30) && (frameCount%60 <= 60)) {
      textAlign(CENTER);
      textSize(30);
      text (REPLAY, width/2-110, 660);
    }
    popMatrix();

    // If key pressed, reset and play again
    if (sensorInput) {
      if (((keyup)||(keydown)||(keyleft)||(keyright)) && (keyPress % 10 == 0)) {
        // Reset game
        gameMode = "intro";
        score = 0;
        life = 3;
        numBalls++;
        start1 = millis();
        begintime1 = 3;
        soundcount1 = 100;
        lose.unmute();
        soundcount2 = 4;

        highscore = false;
        currentLetter1 = 65;
        currentLetter2 = 65;
        currentLetter3 = 65;
        letterActive = 1;
      }
    } else {
      if (spacebar && (keyPress % 10 == 0)) {
        // Reset game
        gameMode = "intro";
        score = 0;
        life = 3;
        numBalls++;
        start1 = millis();
        begintime1 = 3;
        soundcount1 = 100;
        lose.unmute();
        soundcount2 = 4;

        highscore = false;
        currentLetter1 = 65;
        currentLetter2 = 65;
        currentLetter3 = 65;
        letterActive = 1;
      }
    }
  }

  if (gameMode == "highscores") {

    fill(0, 0, 100);
    textSize(30);
    textAlign(LEFT);

    pushMatrix();
    translate(110, 0);

    text("Rank ", 128, 128);
    for (int i=0; i<scores.length; i++) {
      text(i+1, 128, 208+80*i);
    }

    text("Name ", 348, 128);
    for (int i=0; i<scores.length; i++) {
      text(scores[i].substring(0, 3), 348, 208+80*i);
    }

    text("Score ", 568, 128);
    for (int i=0; i<scores.length; i++) {
      text(scores[i].substring(3, scores[i].length()), 568, 208+80*i);
    }

    // "yourscore="
    textAlign(CENTER);
    fill(hue, 100, 100, 75);
    text("Your score: "+score, width/2-110+1, 610+3);
    fill(0, 0, 100);
    text("Your score: "+score, width/2-110, 610);

    // Replay prompt
    if ((frameCount%60 >= 30) && (frameCount%60 <= 60)) {
      textAlign(CENTER);
      textSize(30);
      text (REPLAY, width/2-110, 610+80);
    }
    popMatrix();

    // If key pressed, reset and play again
    if (sensorInput) {
      if (((keyup)||(keydown)||(keyleft)||(keyright)) && (keyPress % 10 == 0)) {
        // Reset game
        gameMode = "intro";
        score = 0;
        life = 3;
        numBalls++;
        start1 = millis();
        begintime1 = 3;
        soundcount1 = 100;
        lose.unmute();
        soundcount2 = 4;

        highscore = false;
        currentLetter1 = 65;
        currentLetter2 = 65;
        currentLetter3 = 65;
        letterActive = 1;
      }
    } else {
      if (spacebar && (keyPress % 10 == 0)) {
        println("highscore keyPress: " + keyPress);
        // Reset game
        gameMode = "intro";
        score = 0;
        life = 3;
        numBalls++;
        start1 = millis();
        begintime1 = 3;
        soundcount1 = 100;
        lose.unmute();
        soundcount2 = 4;

        highscore = false;
        currentLetter1 = 65;
        currentLetter2 = 65;
        currentLetter3 = 65;
        letterActive = 1;
      }
    }

    // reset if inactive for x mins
    if (sw.second() >= inactivity) {
      // Reset game
      gameMode = "start";
      score = 0;
      life = 3;
      numBalls++;
      start1 = millis();
      begintime1 = 3;
      soundcount1 = 100;
      lose.unmute();
      soundcount2 = 4;
      intro.loop();

      highscore = false;
      currentLetter1 = 65;
      currentLetter2 = 65;
      currentLetter3 = 65;
      letterActive = 1;
    }
  }
}