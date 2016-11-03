class BumperLEFT {
  int x1;
  int y1;
  int x2;
  int y2;
  int offset = 40;
  int shift = 129;

  BumperLEFT(int x1in, int y1in, int x2in, int y2in) {
    x1 = x1in;
    y1 = y1in;
    x2 = x2in;
    y2 = y2in;
  }

  void display() {
    bumpershift.play();

    stroke(hue, 100, 100);
    strokeWeight(1.5);
    noFill();

    strokeCap(SQUARE);
    beginShape();
    vertex(x1 - offset - shift, y1 - offset);
    vertex(x1 - shift, y1);
    vertex(x2 - shift, y2);
    vertex(x2 - offset - shift, y2 + offset);
    endShape(CLOSE);

    if (shift > 0) {
      shift--;
    }

    if (shift == 0) {
      bumpershift.mute();
    }
  }

  void bump() {
    stroke(0, 0, 100);    
    strokeWeight(1.5);
    fill(0, 0, 100);

    beginShape();
    vertex(x1 - offset - shift, y1 - offset);
    vertex(x1 - shift, y1);
    vertex(x2 - shift, y2);
    vertex(x2 - offset - shift, y2 + offset);
    endShape(CLOSE);
  }
}

class BumperRIGHT {
  int x1;
  int y1;
  int x2;
  int y2;
  int offset = 40;
  int shift = 129;

  BumperRIGHT(int x1in, int y1in, int x2in, int y2in) {
    x1 = x1in;
    y1 = y1in;
    x2 = x2in;
    y2 = y2in;
  }

  void display() {
    stroke(hue, 100, 100);
    strokeWeight(1.5);
    noFill();

    strokeCap(SQUARE);
    beginShape();
    vertex(x1 + offset + shift, y1 - offset);
    vertex(x1 + shift, y1);
    vertex(x2 + shift, y2);
    vertex(x2 + offset + shift, y2 + offset);
    endShape(CLOSE);

    if (shift > 0) {
      shift--;
    }
  }

  void bump() {
    stroke(0, 0, 100);   
    strokeWeight(1.5);
    fill(0, 0, 100);

    beginShape();
    vertex(x1 + offset + shift, y1 - offset);
    vertex(x1 + shift, y1);
    vertex(x2 + shift, y2);
    vertex(x2 + offset + shift, y2 + offset);
    endShape(CLOSE);
  }
}

class BumperTOP {
  int x1;
  int y1;
  int x2;
  int y2;
  int offset = 40;
  int shift = 129;

  BumperTOP(int x1in, int y1in, int x2in, int y2in) {
    x1 = x1in;
    y1 = y1in;
    x2 = x2in;
    y2 = y2in;
  }

  void display() {
    stroke(hue, 100, 100);
    strokeWeight(1.5);
    noFill();

    strokeCap(SQUARE);
    beginShape();
    vertex(x1 - offset, y1 - offset - shift);
    vertex(x1, y1 - shift);
    vertex(x2, y2 - shift);
    vertex(x2 + offset, y2 - offset - shift);
    endShape(CLOSE);

    if (shift > 0) {
      shift--;
    }
  }

  void bump() {
    stroke(0, 0, 100);    
    strokeWeight(1.5);
    fill(0, 0, 100);

    beginShape();
    vertex(x1 - offset, y1 - offset - shift);
    vertex(x1, y1 - shift);
    vertex(x2, y2 - shift);
    vertex(x2 + offset, y2 - offset - shift);
    endShape(CLOSE);
  }
}

class BumperBOTTOM {
  int x1;
  int y1;
  int x2;
  int y2;
  int offset = 40;
  int shift = 129;

  BumperBOTTOM(int x1in, int y1in, int x2in, int y2in) {
    x1 = x1in;
    y1 = y1in;
    x2 = x2in;
    y2 = y2in;
  }

  void display() {
    stroke(hue, 100, 100);
    strokeWeight(1.5);
    noFill();

    strokeCap(SQUARE);
    beginShape();
    vertex(x1 - offset, y1 + offset + shift);
    vertex(x1, y1 + shift);
    vertex(x2, y2 + shift);
    vertex(x2 + offset, y2 + offset + shift);
    endShape(CLOSE);

    if (shift > 0) {
      shift--;
    }
  }

  void bump() {
    noStroke();
    strokeWeight(1.5);
    fill(0, 0, 100);

    beginShape();
    vertex(x1 - offset, y1 + offset + shift);
    vertex(x1, y1 + shift);
    vertex(x2, y2 + shift);
    vertex(x2 + offset, y2 + offset + shift);
    endShape(CLOSE);
  }
}