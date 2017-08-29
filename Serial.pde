void serialEvent(Serial serialPort) {
  serTime = millis();
  // read a byte from the serial port:
  int inByte = serialPort.read();
  // if this is the first byte received, and it's an A,
  // clear the serial buffer and note that you've
  // had first contact from the microcontroller. 
  // Otherwise, add the incoming byte to the array:

  if (inByte == 'S') { 
    serialPort.clear();          // clear the serial port buffer
    serialCount = 0;
  } 
  

  else if (serialCount < 6){
    // Add the latest byte from the serial port to array:
    switch(serialCount){
      case 0:
        con1 = intToBool(inByte);
        break;
      case 1:
        con2 = intToBool(inByte);
        break;
      case 2:
        con3 = intToBool(inByte);
        break;
      case 3:
        pullForce = inByte;
        break;
      case 4:
        pushForce = inByte;
        break;
      case 5:
        dirIn = intToBool(inByte);
        break;
    }
    serialCount++;
  }
  // Order of serial input: left, right, centre, push, pull, direction
}

String teensyPort(){
  String result = "";
  String[] s = Serial.list();
  for(byte i=0; i<s.length; i++){
    if(s[i].contains(TeensyName)){
      result = s[i];
      println("selected port:",result);
      break;
    }
  }
  return result;
}