import processing.serial.*;

Serial myPort;        // Create object from Serial class
char Newline = '\n';    // character to identify the start of a message
short LF = 10;        // ASCII linefeed
short portIndex = 0;  // select the com port, 0 is the first port

boolean isNewDataAvailable = false;
int accelerationX;
int accelerationY;
int accelerationZ;

int posX = 250;
int posY = 250;

int kleur = color(0, 255, 0);
boolean rood = false;
int x;
int y;

PImage img;
PImage irene;


void setup() {
  size(2000, 1000);

  printArray(Serial.list());
  println(" Connecting to -> " + Serial.list()[portIndex]);
  myPort = new Serial(this, "COM5", 57600);

  //fill(255,0,0);
  //ellipse(posX + accelerationX, posY + accelerationY, 20,20);
 img = loadImage("EllenG2.png");
 irene = loadImage("Irene.png");

}

void draw() {

  background(#BFE4E2);
  pushMatrix();
  textSize(100);
 fill(#1C317C);
  text("inMotion", 1350,150);
  popMatrix();

   
   strokeWeight(40);
   stroke(#58176D);
  line(width/2+140, 650,width/2+340, 650 + accelerationY);
   
   image(img, 50, 275, 657, 726);
   image(irene, 900, 420); 
  
  if (rood) {
    textSize(50);
    fill(255, 0, 0);
    text("Beweeg je arm langzamer", 50, 100);
  } else {
    textSize(50);
    fill(0, 200, 200);
    text("Je beweegt je arm op de goede snelheid", 30, 100);
  }


  if (accelerationY > 50 || accelerationY <-50) {
    rood = true;
    kleur = color(255, 0, 0);
  } else {
    kleur = color(0, 255, 0);
    rood = false;
  }



  if ( isNewDataAvailable ) {

    println( "(" + accelerationX + "," + accelerationY + "," + accelerationZ + ")" );
    accelerationX = values[0] - oldValues[0];
    accelerationY = values[1] - oldValues[1];
    accelerationZ = values[2] - oldValues[2];
    oldValues[0] = values[0];
    oldValues[1] = values[1];
    oldValues[2] = values[2];
    isNewDataAvailable = false;
  }
}

int values [] = new int[3];
int oldValues [] = new int [3];

void serialEvent(Serial p)
{
  String message = myPort.readStringUntil(Newline); // read serial data

  if (message != null)
  {
    print(message);
    String [] data  = trim(message).split("\t"); // Split the comma-separated message
    println( "data[] = " + data.length );

    for ( int i = 0; i < data.length; i++) // skip the header and terminating cr and lf
    {
      println( "data["+ i + "] = '" + data[i] + "'" );
      values[i] = Integer.parseInt( data[i] );
      println("Value" +  i + " = " + values[i]);  //Print the value for each field
    }
    println( "scanned ");
    //}
    isNewDataAvailable = true;
  }
}