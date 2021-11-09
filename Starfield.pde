//Hyperion is the ship the player is in

double sizeX = 800.0;
double sizeY = 600.0;
Particle [] bob = new Particle [100];
int speedRate = 1;
int hits = 2;
int postExplosionTimer = 0;
int frameDistance = 30;
int time = 0;
int timeScale = 101;
double aim = 0;
int postHitTimer = 0;
int destroyedShips = 0;
int numPinks = 3;
int [] hyperionHits = new int [(numPinks-1)*3];

void setup() {
  size(800, 600);
  for (int i = 0; i<1; i++) {
    bob[i] = new Spaceship((int)(Math.random()*(sizeX-500))+100, (int)(Math.random()*(sizeY-600))+100);
  }
  for (int i = 1; i<2; i++) {
    bob[i] = new Pink();
  }
  for (int i = 2; i< numPinks; i++) {
    bob[i] = new Particle(0);
  }
  for (int i = numPinks; i<bob.length; i++) {
    bob[i] = new Particle();
  }
}
void draw() {
  background(0);
  fill(255);
  textSize(30);
  text("Ships Destroyed: " + destroyedShips, 5, 30);
  for (int j = 0; j<10; j++) {
    for (int i = numPinks; i<bob.length; i++) {//Particles 
      bob[i].move();
      bob[i].show();
      time ++;
      if (bob[i].myX > sizeX + frameDistance ||bob[i].myX < - frameDistance) {
        bob[i] = new Particle((int)sizeX/2, (int)sizeY/2);
      }
      if (bob[i].myY > sizeY + frameDistance ||bob[i].myY < - frameDistance) {
        bob[i] = new Particle((int)sizeX/2, (int)sizeY/2);
      }
    }

    for (int i = 1; i<numPinks; i++) {//Pinks
      if (bob[i].mySize > 50) {
        hyperionHits[(i-1)+2*(i-1)] = 11;
        hyperionHits[(i)+2*(i-1)] = (int) bob[i].myX;
        hyperionHits[(i+1)+2*(i-1)] = (int) bob[i].myY;
        bob[i].myX = -1000;
        bob[i].myY = -1000;
      }
      bob[i].move();
      bob[i].show();
      time ++;
      if (bob[i].myX > sizeX + frameDistance ||bob[i].myX < - frameDistance) {
        bob[i] = new Pink();
      }
      if (bob[i].myY > sizeY + frameDistance ||bob[i].myY < - frameDistance) {
        bob[i] = new Pink();
      }
    }
  }

  bob[0].move();// Ship
  bob[0].show();

  time ++;
  crosshair();
  hyperionHit();
}


class Particle {
  double myX, myY;
  int myColor;
  double myAngle, mySpeed, mySpeedO;
  float mySize;
  int hyperionHitTimer, hyperionHitX, hyperionHitY;
  Particle() {
    myColor = color(255);
    myAngle = Math.random()*2*PI;
    mySpeed = Math.random()*speedRate*7;
    mySpeedO=mySpeed;
    mySize = 1;
    myX=sizeX/2;
    myY=sizeY/2;
    for (int i = 0; i<500; i++) {
      myX=myX+mySpeed*cos((float)myAngle);
      myY=myY+mySpeed*sin((float)myAngle);
    }
  }
  Particle(int x, int y) {
    myColor = color(255);
    myAngle = Math.random()*2*PI;
    mySpeed = Math.random()*speedRate*5;
    mySpeedO=mySpeed;
    myX=x;
    myY=y;
    mySize = 1;
    for (int i = 0; i<400; i++) {
      myX=myX+mySpeed*cos((float)myAngle);
      myY=myY+mySpeed*sin((float)myAngle);
    }
  }
  Particle(int z) {
    myColor = z;
    myAngle = Math.random()*2*PI;
    mySpeed = Math.random()*speedRate*7;
    mySpeedO=mySpeed;
    mySize = 1;
    myX=sizeX/2;
    myY=sizeY/2;
    for (int i = 0; i<500; i++) {
      myX=myX+mySpeed*cos((float)myAngle);
      myY=myY+mySpeed*sin((float)myAngle);
    }
  }
  void move() {
    myX=myX+mySpeed*cos((float)myAngle);
    myY=myY+mySpeed*sin((float)myAngle);
    mySize = 1 + (dist((float)sizeX/2, (float)sizeY/2, (float)myX, (float)myY))/100;
  }
  void show() {
    stroke(myColor);
    fill(myColor);
    ellipse((float)myX, (float)myY, mySize, mySize);
  }
}

class Pink extends Particle {
  double myStartX, myStartY, forwardSpeed;
  Pink() {
    myColor = color(255, 150, 200);
    myAngle = Math.random()*PI/2 + PI/4;
    mySpeed = Math.random()*speedRate*2+2;
    mySpeedO=mySpeed;
    forwardSpeed = (float)(Math.random()*5+5);
    mySize = 1;
    myStartX = bob[0].myX;
    myStartY = bob[0].myY;
    myX = myStartX;
    myY = myStartY;
    hyperionHitTimer = 0;
    hyperionHitX = 1010;
    hyperionHitY = 1010;
  }
  void move() {
    myX=myX+mySpeed*cos((float)myAngle);
    myY=myY+mySpeed*sin((float)myAngle);
    mySize = 1 + (dist((float)myStartX, (float)myStartY, (float)myX, (float)myY))/10;//forwardSpeed;
  }
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      for (int i = 0; i<bob.length; i++) {
        bob[i].mySpeed = bob[i].mySpeedO +1;
      }
    } else if (keyCode == DOWN) {
      for (int i = 0; i<bob.length; i++) {
        bob[i].mySpeed =  Math.random();
      }
    }
  }
}

void crosshair() {
  int crosshairLength = 15;
  stroke(255);
  line(mouseX-crosshairLength, mouseY, mouseX-1, mouseY);//horizontal left
  line(mouseX+1, mouseY, mouseX+crosshairLength, mouseY);
  line(mouseX, mouseY-crosshairLength, mouseX, mouseY-1);//vertical
  line(mouseX, mouseY+1, mouseX, mouseY+crosshairLength);
  if (postExplosionTimer > 0) {
    noStroke();
    fill(254, 222, 23, postExplosionTimer*50);
    ellipse(mouseX, mouseY, 50, 50);
    postExplosionTimer --;
  }
  if (postHitTimer > 0) {
    noStroke();
    fill(255, 75, 43, postHitTimer * 50);
    ellipse(mouseX, mouseY, 12, 12);
    postHitTimer --;
  }
}

void hyperionHit() {
  for (int i = 0; i<hyperionHits.length-2; i+=3) {
    noStroke();
    fill(255, 75, 43, hyperionHits[i] * 25);
    ellipse(hyperionHits[i+1], hyperionHits[i+2], 200, 200);
    hyperionHits[i]=hyperionHits[i]-1; 
  }
}

void mousePressed() {
  color c = get(mouseX, mouseY);
  //fill(c);  Testing 
  //stroke(255);
  //rect(1500, 1100, 100, 100);
  if (c == color(130, 143, 114)) {//bob[0].myColor){
    //dist(mouseX, mouseY, (float)(bob[0].myX), (float)(bob[0].myY))<bob[0].mySize*.5 || dist(mouseX, mouseY, (float)bob[0].myX-bob[0].mySize*1.5, (float)bob[0].myY-bob[0].mySize*.75)<bob[0].mySize*.5 || dist(mouseX, mouseY, (float)bob[0].myX+bob[0].mySize*1.5, (float)bob[0].myY-bob[0].mySize*.75)<bob[0].mySize*.5) {
    hits = hits + 1;
    noStroke();
    if (hits>4) {
      fill(254, 222, 23, 200);
      ellipse(mouseX, mouseY, 100, 100);
      bob[0].myX = (int)(Math.random()*(sizeX-200))+100;
      bob[0].myY = (int)(Math.random()*(sizeY-200))+100;
      hits = 0;
      postExplosionTimer = 10;
      destroyedShips ++;
    } else {
      postHitTimer = 5;
    }
  }
}

class Spaceship extends Particle {
  Spaceship(int x, int y) {
    myColor = color(130, 143, 114);
    myAngle = Math.random()*2*PI;
    mySpeed = 10;
    mySpeedO = mySpeed;
    myX = x;
    myY = y;
    mySize = 25;
  }
  void move() {
    double k = 1.07;
    if (myX<25) {//Boarders
      myX = myX + mySpeed;
      myY = myY + Math.random()*mySpeed*2 - mySpeed;
    } else if (myX>sizeX-25) {
      myX = myX - mySpeed;
      myY = myY + Math.random()*mySpeed*2 - mySpeed;
    } else if (myY<25) {
      myX = myX + Math.random()*mySpeed*2 - mySpeed;
      myY = myY + mySpeed;
    } else if (myY>sizeY-25) {
      myX = myX + Math.random()*mySpeed*2 - mySpeed;
      myY = myY - mySpeed;
    } else {
      if (dist((float)myX, (float)myY, mouseX, mouseY)<150) {//Dodging
        if (myX > mouseX) {
          myX = myX + Math.random()*mySpeed*2 - mySpeed/k;
        } else {
          myX = myX - Math.random()*mySpeed*2 + mySpeed/k;
        }
        if (myY > mouseY) {
          myY = myY + Math.random()*mySpeed*2 - mySpeed/k;
        } else {
          myY = myY - Math.random()*mySpeed*2 + mySpeed/k;
        }
      } else {//Neutral
        myX = myX + Math.random()*mySpeed*2 - mySpeed;
        myY = myY + Math.random()*mySpeed*2 - mySpeed;
      }
    }
  }
  void show() {
    stroke(myColor);
    fill(myColor);
    ellipse((float)myX, (float)myY, mySize, mySize);
    quad((float)myX-mySize*1/4, (float)myY, (float)myX-mySize*3, (float)myY-mySize*.75, (float)myX-mySize*3.25, (float)myY-mySize*1, (float)myX, (float)myY-mySize*1/2);//left wing
    quad((float)myX+mySize*1/4, (float)myY, (float)myX+mySize*3, (float)myY-mySize*.75, (float)myX+mySize*3.25, (float)myY-mySize*1, (float)myX, (float)myY-mySize*1/2);//right wing
  }
}
