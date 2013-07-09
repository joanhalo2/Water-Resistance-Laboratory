import de.bezier.data.*;
import processing.serial.*;
import cc.arduino.*;
Arduino arduino;
XlsReader reader;
float[] preciMeses = new float[12];
int[] pinStates = new int[12];
int[] pinNumbers = new int[12];
int[] previousMillis = new int[12];
float minTime = 5;
float maxTime = 40;
float minValueMeses;
float maxValueMeses;

int pinInicial=22;
int totalPines = 12;
int fila = 0;
void setup ()
{
  reader = new XlsReader( this, "precipitaciones.xls" );    // assumes file to be in the data folder
  reader.firstRow();
  println(Arduino.list());
  arduino = new Arduino(this, Arduino.list()[0], 57600);

  for (int i = pinInicial; i < (pinInicial+totalPines); i++) {
    arduino.pinMode(i, Arduino.OUTPUT);
    pinNumbers[i-pinInicial]=i;
  }

  for (int i=1;i<=12;i++) {
    preciMeses[i-1] = reader.getFloat(fila, i);
    pinStates[i-1] = 1;
    previousMillis[i-1] = 0;
  }
  minValueMeses = min(preciMeses);
  maxValueMeses = max(preciMeses);
}

void draw () {
  int currentMillis = millis();

  for (int i=0;i<12;i++) {

    if (pinStates[i]==1) {
      arduino.digitalWrite(pinNumbers[i], Arduino.HIGH);
    }
    else {
      arduino.digitalWrite(pinNumbers[i], Arduino.LOW);
    }

    float valorMapeado = map(preciMeses[i], minValueMeses, maxValueMeses, minTime, maxTime);

    if (currentMillis - previousMillis[i] > valorMapeado*1000) {
      previousMillis[i] = currentMillis;
      pinStates[i]=0;
    }
  }

  boolean cambiarAnio = true;
  for (int i=0;i<12;i++) {
    if (pinStates[i]==1) {
      cambiarAnio = false;
    }
  }

  if (cambiarAnio) {
    if (reader.hasMoreRows()) {
      reader.nextRow();
      fila++;
    }
    else {
      fila = 0;
      reader.firstRow();
    } 


    minValueMeses = min(preciMeses);
    maxValueMeses = max(preciMeses);

    for (int i=1;i<=12;i++) {
      preciMeses[i-1] = reader.getFloat(fila, i);
      pinStates[i-1] = 1;
    }
  }
}

