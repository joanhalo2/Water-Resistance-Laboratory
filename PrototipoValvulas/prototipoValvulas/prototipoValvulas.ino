int const delayValue=500;
int const cant_valvulas = 30;
int const pin_inicial = 22;
int salidas[cant_valvulas];

void setup() {
  Serial.begin(9600);
  for(int i=pin_inicial; i<(pin_inicial+cant_valvulas);i++){
    pinMode(i, OUTPUT);
    salidas[i-pin_inicial] = i;
  }  
  randomSeed(analogRead(0));
}

void loop() {
  
  for(int i=0; i<cant_valvulas; i++){
    
    int valorSalida = random(0,100);
    int result;
    
    if(valorSalida>50){
      result = HIGH;
    }else{
      result = LOW;
    }
      digitalWrite(salidas[i], result);
//    
     if(i==cant_valvulas-1){
       Serial.println(result);
//     Serial.println(salidas[i]);
      }else{
       Serial.print(result);
//    Serial.print(salidas[i]);
      }

  }
  delay(delayValue);
}
