// The logic used in this code is based on a Daniel Shiffman video (his youtube channel is awesome)  
// This is the header he used in the code provided in the class:
// http://codingtra.in
// http://patreon.com/codingtrain
// Video: https://youtu.be/RTc6i-7N3ms
/////////////////////////////////////////////////////////////////////////////
class Segment 
{
  PVector a;
  float angle = 0;
  float len;
  PVector b = new PVector();
  Segment parent = null;
  Segment child = null;
  boolean flag = true;
  float posB = 0;
  float posA = 0;
  float dx = 0;
  float dy = 0;



  Segment(float x, float y, float len_) 
  {
    a = new PVector(x, y);
    len = len_;
    calculateB();
  }

  Segment(Segment parent_, float len_) 
  {
    parent = parent_;
    a = parent.b.copy();
    len = len_;
    calculateB();
  }


  void setA(PVector pos) 
  {
    a = pos.copy();
  }

  void attachA() 
  {
    setA(parent.b);
  }


  void follow() 
  {
    float targetX = child.a.x;
    float targetY = child.a.y;
    follow(targetX, targetY);
  }

  void follow(float tx, float ty) 
  {
    PVector target = new PVector(tx, ty);
    PVector dir = PVector.sub(target, a);
    angle = dir.heading();
    dir.setMag(len);
    dir.mult(-1);
    a = PVector.add(target, dir);
  }

  void calculateB() 
  {
    dx = len * cos(angle);
    dy = len * sin(angle);
    b.set(a.x+dx, a.y+dy);
  }
  void calculateB(float lockedAngle) 
  {
    dx = len * cos(lockedAngle);
    dy = len * sin(lockedAngle);
    b.set(a.x+dx, a.y+dy);
  }



  void show() 
  {
    stroke(255);
    strokeWeight(4);
    line(a.x, a.y, b.x, b.y);
  }
}
