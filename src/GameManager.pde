Subject subject;
Platform pf;

PImage bg;
int bgx = 0;

PImage player;

boolean left, right, space;

boolean debug;

void setup() {
  String path = dataPath("").replace("\\src\\data","");
  fullScreen();
  left = false;
  right = false;
  space = false;
  println(path);
  subject = new Subject();
  pf = new Platform(300, 100, 200, 25, "safe");
  surface.setTitle("Jumjava");

  bg = loadImage(path + "/res/img/background.png");
  player = loadImage(path + "/res/img/cube.png");

  player.resize(subject.w, subject.h);
}

void draw() {
    background(#ff0000);
  
    image(bg, bgx, 0);
    image(bg, bgx+bg.width, 0);
    image(bg, bgx-bg.width, 0);
    
    if(subject.x <= 400){
      bgx = bgx + 3;
      subject.x = subject.x + 3;
      pf.x = pf.x + 3;
    }
    
    if(subject.x >= width - 800){
      bgx = bgx - 3;
      subject.x = subject.x - 3;
      pf.x = pf.x - 3;
    }
  
    if (bgx < -bg.width) {
      bgx = 0; // reset
    }
    
    if(bgx > bg.width){
      bgx = 0;
    }
  
    subject.collisionSide = rectangleCollision(subject, pf);
    subject.update();
    subject.display();
    displayPositionData();
    pf.display();
}

void keyPressed() {
  switch (keyCode) {
  case 65: // key left
    left = true;
    break;
  case 68: // key right
    right = true;
    break;
  case 32: // key space
    space = true;
    break;
  case 114:
    debug = !debug;
    break;
  }
}

void keyReleased() {
  switch (keyCode) {
  case 65: // key left
    left = false;
    break;
  case 68: // key rightd
    right = false;
    break;
  case 32: // key space
    space = false;
    break;
  }
}

void displayPositionData() {
  if(debug){
    fill(0);
    String s = "\nvx: "+subject.vx+" vy: "+subject.vy + "\ncollisionSide: "+subject.collisionSide;
    text(s, 10, 0);
  }
}

String rectangleCollision(Subject s, Platform p) {
  float dx = (s.x+s.halfWidth) - (p.x+p.halfWidth);
  float dy = (s.y+s.halfHeight) - (p.y+p.halfHeight);
  float combHalfWidths = s.halfWidth + p.halfWidth;
  float combHalfHeights = s.halfHeight + p.halfHeight;
  if (abs(dx) < combHalfWidths) {

    if (abs(dy) < combHalfHeights) {
      float overlapX = combHalfWidths - abs(dx);
      float overlapY = combHalfHeights - abs(dy);
      if (overlapX >= overlapY) {
        if (dy > 0) {
          s.y += overlapY;
          return "top";
        } else {
          s.y -= overlapY;
          return "bottom";
        }
      } else {
        if (dx > 0) {
          s.x += overlapX;
          return "left";
        } else {
          s.x -= overlapX;
          return "right";
        }
      }
    } else {
      return "none";
    }
  } else {
    return "none";
  }
}