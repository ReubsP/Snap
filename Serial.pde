void serialEvent(Serial serialPort) {
  // read a byte from the serial port:
  int inByte = serialPort.read();
  // if this is the first byte received, and it's an A,
  // clear the serial buffer and note that you've
  // had first contact from the microcontroller. 
  // Otherwise, add the incoming byte to the array:

  if (inByte == 'I') { 
    serialPort.clear();          // clear the serial port buffer
    serialCount = 0;
  } 

  else if (serialCount < 9){
    // Add the latest byte from the serial port to array:
    serialInArray[serialCount] = inByte;
    serialCount++;
  }
  //else if (serialCount == 5){
  //  serialPort.write("A\n");
  //}
}

String teensyPort(){
  String result = "";
  String[] s = Serial.list();
  for(byte i=0; i<s.length; i++){
    if(s[i].contains("teensy")){
      result = s[i];
      break;
    }
  }
  println("selected port:",result);
  return result;
}