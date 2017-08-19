/* Snap Audio Test Visualiser
 * Author: Reuben Poharama
 * Displays Cycle count, connection status and force
 */


import processing.serial.*;
import java.util.*;
import java.text.*;

Serial serialPort;  // Create object from Serial class
SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");

Table table;       // For CSV data

PFont cycleFont, connectFont, forceFont;
int cycleNum;
Cycle[] cycles;
boolean con1, con2, con3;  // Connections
float pullForce, pushForce, pullPeak, pushPeak;
int pullPeakTime, pushPeakTime;
float noisePos;

int[] serialInArray = new int[9];    // Where we'll put what we receive
int serialCount = 0;                 // A count of how many bytes we receive

void setup(){
  size(1200,700);
  cycleFont = createFont("Lato-Medium.ttf", 130);     // Font for number of cycles
  connectFont = createFont("Lato-Medium.ttf", 90);   // Font for connected status
  forceFont = createFont("Lato-Medium.ttf", 50);     // Font for forces
    // Print a list of the serial ports, for debugging purposes:
  printArray(Serial.list());
  //String portName = Serial.list()[4];
  serialPort = new Serial(this, teensyPort(), 9600);
  serialPort.write("A\n");
  cycleNum = 1;
  
  sdf.setTimeZone(TimeZone.getTimeZone("GMT+12"));
  
  loadData();
}

void draw(){
  noisePos += 0.01;
  pullForce = serialInArray[3];
  pushForce = serialInArray[4];
  
  if(pushForce > pushPeak){
    pushPeak = pushForce;
    pushPeakTime = millis();
  }
  if(pullForce > pullPeak){
    pullPeak = pullForce;
    pullPeakTime = millis();
  }
  
  if(millis() > pushPeakTime+700) pushPeak -= 0.3;
  if(millis() > pullPeakTime+700) pullPeak -= 0.3;
  
  con1 = intToBool(serialInArray[0]);
  con2 = intToBool(serialInArray[1]);
  con3 = intToBool(serialInArray[2]);
  
  readCycle();
  
  background(0);
  textAlign(LEFT);
  
  // Draw Cycles at the top
  textFont(cycleFont);
  fill(255);
  String cycleText = "Cycle: " + nfc(cycleNum);
  text(cycleText, 100, 180);
  
  // Draw connection status in middle
  
  // Circles
  ellipseMode(CENTER);
  noFill();
  strokeWeight(6);
  if(con1) stroke(0,200,0);
  else stroke(200,0,0);
  ellipse(100, 270, 30, 30);
  if(con2) stroke(0,200,0);
  else stroke(200,0,0);
  ellipse(100, 270, 60, 60);
  if(con3) stroke(0,200,0);
  else stroke(200,0,0);
  ellipse(100, 270, 90, 90);
  
  //Text
  textFont(connectFont);
  String connectText;
  if(con1 && con2 && con3){
    connectText = "Connected";
    fill(0,200,0);
  }
  else{
    connectText = "Not Connected";
    fill(200,0,0);
  }
  text(connectText, 200, 300);
  
  
  // Draw Forces
  textFont(forceFont);
  fill(255);
  String forceText = "Force in: " + nfc(pushForce, 1) + " N";
  text(forceText, 50, 500);
  forceText = "Force out: " + nfc(pullForce, 1) + " N";
  text(forceText, 50, 600);
  
  // Draw bars
  noStroke();
  fill(40);
  rect(443,458,660,43);
  rect(443,558,660,43);
  fill(0,200,0);
  int fWidth = int(map(pushForce,0,255,0,660));  //force width (mapped)
  rect(443,458,fWidth,43);
  fWidth = int(map(pullForce,0,255,0,660));
  rect(443,558,fWidth,43);
  fill(200,200,0);
  int pWidth = int(map(pushPeak,0,255,0,660));  // peak width (mapped)
  rect(443+pWidth,458,8,43);
  pWidth = int(map(pullPeak,0,255,0,660));  // peak width (mapped)
  rect(443+pWidth,558,8,43);
}



void keyPressed() {
  if(key == 'r') serialPort.write("r\n");
}


boolean intToBool(int in){
  boolean result = false;
  if(in > 0) result = true;
  return result;
}

void readCycle(){
  int c = serialInArray[5];
  c <<= 8;
  c |= serialInArray[6];
  c <<= 8;
  c |= serialInArray[7];
  c <<= 8;
  c |= serialInArray[8];
  cycleNum = c;
}