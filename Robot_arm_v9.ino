#include <Servo.h>


#define SERVO_GARRA 3 // Porta Digital 2 PWM
#define SERVO_MAO 11// Porta Digital 3 PWM
#define SERVO_COTOVELO 9// Porta Digital 4 PWM
#define SERVO_OMBRO 6// Porta Digital 5 PWM
#define SERVO_CINTURA 12// Porta Digital 6 PWM
int printer = 13;

Servo servoGarra;
Servo servoMao;
Servo servoCotovelo;
Servo servoOmbro;
Servo servoCintura;

float garraAngle = 30;
float maoAngle = 178;
float cotoveloAngle = 2;
float ombroAngle = 126;
float cinturaAngle = 45;

float garraAngle_ = 30;
float maoAngle_ = 178;
float cotoveloAngle_ = 2;
float ombroAngle_ = 126;
float cinturaAngle_ = 45;

String garra;
String mao;
String cotovelo;
String ombro;
String cintura;

String data = "null";
char val; // Data received from the serial port


void setup()
{
  servoGarra.attach(SERVO_GARRA);
  servoMao.attach(SERVO_MAO);
  servoCotovelo.attach(SERVO_COTOVELO);
  servoOmbro.attach(SERVO_OMBRO);
  servoCintura.attach(SERVO_CINTURA);

  servoGarra.write(garraAngle);
  servoMao.write(maoAngle);
  servoCotovelo.write(cotoveloAngle);
  servoOmbro.write(ombroAngle);
  servoCintura.write(cinturaAngle);


  pinMode(printer, OUTPUT); // Set pin as OUTPUT
  digitalWrite(printer, LOW);
  Serial.begin(57600);
  delay(300);
  establishContact();  // send a byte to establish contact until receiver responds


}
void loop()
{
  digitalWrite(printer, LOW);
  if (Serial.available() > 0)// If data is available to read,
  { 
    data = Serial.readStringUntil('\n'); // read it and store it in val
    ombro = data.substring(data.indexOf('a'), data.indexOf(":b"));
    cotovelo = data.substring(data.indexOf('b'), data.indexOf(":c"));
    mao = data.substring(data.indexOf('c'), data.indexOf(":d"));
    cintura = data.substring(data.indexOf('d'), data.indexOf(":e"));
    garra = data.substring(data.indexOf('e'), data.indexOf('\n'));

    Serial.print(ombro);
    Serial.print(":");
    Serial.print(cotovelo);
    Serial.print(":");
    Serial.print(mao);
    Serial.print(":");
    Serial.print(cintura);
    Serial.print(":");
    Serial.println(garra);

    ombro.remove(0, 1);
    cotovelo.remove(0, 1);
    mao.remove(0, 1);
    cintura.remove(0, 1);
    garra.remove(0, 1);

    ombroAngle = ombro.toInt();
    cotoveloAngle = cotovelo.toInt();
    maoAngle = mao.toInt();
    cinturaAngle = cintura.toInt();
    garraAngle = garra.toInt();

    if (abs(cinturaAngle - cinturaAngle_) < 30)
      cinturaAngle_ = cinturaAngle;
    if (abs(ombroAngle - ombroAngle_) < 30)
      ombroAngle_ = ombroAngle;
    if (abs(cotoveloAngle - cotoveloAngle_) > 30)
      cotoveloAngle_ = cotoveloAngle;
    if (abs(maoAngle - maoAngle_) < 30)
      maoAngle_ = maoAngle;
    if (abs(garraAngle - garraAngle_) < 70)
      garraAngle_ = garraAngle;

    movimenta(cinturaAngle_, ombroAngle_, cotoveloAngle_, maoAngle_, garraAngle_);
    delay(10);

  }
  else {
    Serial.println("dados do processing indisponiveis"); //send back a hello world
    movimenta();
    delay(10);
  }
}
void movimenta()
{
  if ((garraAngle > 2) && (garraAngle < 100))
    servoGarra.write(garraAngle);
  if ((ombroAngle > 2) && (ombroAngle < 178))
    servoOmbro.write(ombroAngle);
  if ((maoAngle > 2) && (maoAngle < 178))
    servoMao.write(maoAngle);
  if ((cotoveloAngle > 2) && (cotoveloAngle < 178))
    servoCotovelo.write(cotoveloAngle);
  if ((cinturaAngle > 2) && (cinturaAngle < 178))
    servoCintura.write(cinturaAngle);
}
void movimenta(float cintura_, float ombro_, float cotovelo_, float mao_, float garra_)
{

  if ((garra_ > 2) && (garra_ < 80))
    servoGarra.write(garra_);
  if ((ombro_ > 2) && (ombro_ < 178))
    servoOmbro.write(ombro_);
  if ((mao_ > 2) && (mao_ < 178))
    servoMao.write(mao_);
  if ((cotovelo_ > 2) && (cotovelo_ < 178))
    servoCotovelo.write(cotovelo_);
  if ((cintura_ > 2) && (cintura_ < 178))
    servoCintura.write(cintura_);
}

void establishContact()
{
  digitalWrite(printer, LOW);
  while (Serial.available() <= 0)
  {
    Serial.println("A");   // send a capital A
    delay(200);
  }
}
