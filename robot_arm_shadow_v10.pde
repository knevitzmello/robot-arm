// Daniel Shiffman
// http://codingtra.in
// http://patreon.com/codingtrain
// Video: https://youtu.be/RTc6i-7N3ms
import processing.serial.*; //import the Serial library
Serial myPort;  //the Serial port object
String val;
// since we're doing serial handshaking, 
// we need to check if we've heard from the microcontroller
boolean firstContact = false;

String dataSended_ = null;
String[] data = new String[5];
String dataReceived_ = null;

Segment end;

Segment mao_;
Segment ombro_;
Segment cotovelo_;
Segment cintura_;
Segment garraLeft_;
Segment garraRight_;

Segment ombro;
Segment cotovelo;
Segment mao;
Segment cintura;
Segment garraLeft;
Segment garraRight;

PVector base;
PVector eixo;
PVector garraL;
PVector garraR;

float theta = 0;
float psi = 0;
float alpha = 0;

float cotoveloAngle = 0;
float maoAngle = 0;
float ombroAngle = 0;

float cinturaAngle = 0;
float garraAngle = 0;

float posX = 0;
float posY = 0;

float posX_ = 0;
float posY_ = 0;
float mouse_X = 0;
float mouse_Y = 0;

float alturaR = width/2 - 20;
float alturaL = width/2 + 20;

float garraLenght = 75;
float robotHeight = 0;
float limitMaior = 178;
float limitMenor = 2;

boolean lockOmbro = false;
boolean lockCotoveloMaior = false;
boolean lockCotoveloMenor = false;
boolean lockMaoMaior = false;
boolean lockMaoMenor = false;
boolean sendData = false;

void setup() 
{
  connect();

  size(700, 400);
  ombro = new Segment(0, 200, 75);
  cotovelo = new Segment(ombro, 75);
  ombro.child = cotovelo;
  mao = new Segment(cotovelo, 75);
  cotovelo.child = mao;
  cintura = new Segment(0, 200, 75);
  garraRight = new Segment(width - 200, 100, garraLenght);
  garraLeft = new Segment(width - 200, 150, garraLenght);

  end = mao;
  mao_ = mao;
  ombro_ = ombro;
  cotovelo_ = cotovelo;
  cintura_ = cintura;

  garraLeft_ = garraLeft;
  garraRight_ = garraRight;

  eixo = new PVector(0, height/2);
  base = new PVector(width/2, height - robotHeight);
  garraL = new PVector(width - garraLenght, alturaL);
  garraR = new PVector(width - garraLenght, alturaR);
}

void draw() 
{
  background(51);
  if (keyPressed) 
  {
    verificaKey();
  }

  calculateAngles();////////////////////////
  cinematics(posX, posY);//////////////////
  checkAngles();////////////////////////////

  checkLimitsOmbro();
  checkLimitsCotovelo();
  checkLimitsMao();

  ombro_.show();
  mao_.show();
  cotovelo_.show();
  cintura_.show();
  garraRight_.show();
  garraLeft_.show();

  if (sendData)
  {
    data[0] = "a"+String.format("%.2f", ombroAngle);
    data[1] = "b"+String.format("%.2f", cotoveloAngle);
    data[2] = "c"+String.format("%.2f", maoAngle);
    data[3] = "d"+String.format("%.2f", cinturaAngle);
    data[4] = "e"+String.format("%.2f", garraAngle);
    dataSended_ = join(data, ":");
    try {
      myPort.write(dataSended_+"\n");
    }
    catch (NullPointerException n) {
      println("nenhuma porta conectada, conexão não estabelecida");
      sendData = !sendData;
    }
  }
}

void cinematics(float posX, float posY)
{

  positionGarra();
  positionCintura();

  mao_.follow(posX, posY);
  mao_.calculateB();

  cotovelo_.follow();
  cotovelo_.calculateB();

  ombro_.follow();
  if (!lockOmbro)//funciona
    ombro_.calculateB();

  ombro_.setA(base);
  if (!lockOmbro)//funciona
    ombro_.calculateB();

  cotovelo_.attachA();
  if ((!lockCotoveloMaior) && (!lockCotoveloMenor))
  {
    cotovelo_.calculateB();
  } else if (lockCotoveloMaior)
  {
    cotovelo_.calculateB(radians(-(limitMaior - 90 + alpha)));
  } else if (lockCotoveloMenor)
  {
    cotovelo_.calculateB(radians(-(limitMenor - 90 + alpha)));
  }

  mao_.attachA();
  if ((!lockMaoMaior) && (!lockMaoMenor))
  {
    mao_.calculateB();
  } else if (lockMaoMaior)
  {
    mao_.calculateB(radians(-(limitMaior - 90 + theta)));
  } else if (lockMaoMenor)
  {
    mao_.calculateB(radians(-(360 - 90 + theta)));
  }
}
void keyReleased()
{
  if (key == 'z' || key == 'Z')
  {
    sendData = !sendData;
  }
}
void verificaKey()
{
  if (key == 'd' || key == 'D')
    posX+= 3;
  if (key == 'a' || key == 'A')
    posX -= 3;

  if (key == 's' || key == 'S')
    posY += 3;

  if (key == 'w' || key == 'W')
    posY -= 3;

  if (key == 'm' || key == 'M')
  {
    posX = mouseX;
    posY = mouseY;
  }
  if (key == 'g' || key == 'G')
  {
    mouse_X = mouseX;
    mouse_Y = mouseY;
  }
  if (key == 'o' || key == 'O')
  {
    if (alturaR <= 0)
      alturaR = 0;
    if (alturaL >= 100)
      alturaL = 100;
    garraR.set(width - garraLenght, alturaR--);
    garraL.set(width - garraLenght, alturaL++);
  }
  if (key == 'c' || key == 'C')
  {
    if (alturaR >= 46)
      alturaR = 46;
    if (alturaL <= 51)
      alturaL = 51;
    garraR.set(width - garraLenght, alturaR++);
    garraL.set(width - garraLenght, alturaL--);
  }
}
void positionGarra()
{
  garraRight_.setA(garraL);
  garraRight_.calculateB();
  garraLeft_.setA(garraR);
  garraLeft.calculateB();
}
void positionCintura()
{
  cintura_.follow(mouse_X, mouse_Y);
  cintura_.calculateB();
  cintura_.setA(eixo);
  cintura_.calculateB();
}
void calculateAngles()
{
  alpha = -degrees(ombro_.angle);
  theta = -degrees(cotovelo_.angle);
  psi = -degrees(mao_.angle);
  cinturaAngle = map(90 -degrees(cintura_.angle), 0, 180, limitMenor, limitMaior);
  garraAngle = 100 - garraL.dist(garraR);


  ombroAngle = alpha;
  cotoveloAngle = (90 + theta - alpha);
  maoAngle = (90 + psi - theta);
}

void checkAngles()
{
  if (ombroAngle < 0)
    ombroAngle = 360 + ombroAngle;

  if (cotoveloAngle < 0)
    cotoveloAngle = 360 + cotoveloAngle;

  if (maoAngle < 0)
    maoAngle = 360 + maoAngle;
}

void checkLimitsOmbro()
{
  if ((ombroAngle > limitMaior) || (ombroAngle < limitMenor))
  {
    if (ombroAngle > limitMaior)
      ombroAngle = limitMaior;
    if (ombroAngle < limitMenor)
      ombroAngle = limitMenor;
    lockOmbro = true;
  } else
  {
    lockOmbro = false;
  }
}

void checkLimitsCotovelo()
{
  if ((cotoveloAngle > 270) && (cotoveloAngle <= 360))
  {
    cotoveloAngle = limitMenor;
    lockCotoveloMenor = true;
  } else if ((cotoveloAngle > limitMaior) && (cotoveloAngle < 270))
  {
    cotoveloAngle = limitMaior;
    lockCotoveloMaior = true;
  } else
  {
    lockCotoveloMaior = false;
    lockCotoveloMenor = false;
  }
}

void checkLimitsMao()
{
  if ((maoAngle > 270) && (maoAngle <= 360))
  {
    maoAngle = limitMenor;
    lockMaoMenor = true;
  } else if ((maoAngle > limitMaior) && (maoAngle < 270))
  {
    maoAngle = limitMaior;
    lockMaoMaior = true;
  } else
  {
    lockMaoMaior = false;
    lockMaoMenor = false;
  }
}


void serialEvent( Serial myPort) {
  //put the incoming data into a String - 
  //the '\n' is our end delimiter indicating the end of a complete packet
  val = myPort.readStringUntil('\n');
  //make sure our data isn't empty before continuing
  if (val != null) {
    //trim whitespace and formatting characters (like carriage return)
    val = trim(val);
    println(val);

    //look for our 'A' string to start the handshake
    //if it's there, clear the buffer, and send a request for data
    if (firstContact == false) {
      if (val.equals("A")) {
        myPort.clear();
        firstContact = true;
        myPort.write("A");
        println("contact");
      }
    } else { //if we've already established contact, keep getting and parsing data
      println(val);
      // when you've parsed the data you have, ask for more:
      myPort.write("A");
    }
  }
}
static final int findPort() {
  String[] ports = Serial.list();
  //printArray(Serial.list());
  return ports.length;
}
void connect()
{
  int i = 0;
  int erro = 0;
  while (i < findPort())
  {
    try {
      println("tentativa: " + i+1 + " conectando...");
      myPort = new Serial(this, Serial.list()[i], 57600);
    }
    catch (Exception e) {
      erro++;
      println("porta nao conectada");
    } 
    i++;
  }
  if (erro == i)
  {
    println("nenhuma porta conectada");
  } else {
    println("porta" + i + "conectada");
  }
}