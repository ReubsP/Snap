/* Snap Audio Test Visualiser
 * Author: Reuben Poharama
 * Displays Cycle count, connection status and force
 */


import processing.serial.*;
import java.util.*;
import java.text.*;
import static javax.swing.JOptionPane.*;
import java.io.BufferedWriter;
import java.io.FileWriter;

String outFilename = System.getProperty("user.home") + "/Desktop/table.csv";

static String TeensyName = "modem";

Serial serialPort;  // Create object from Serial class
SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");

Table table;       // For CSV data

PFont cycleFont, connectFont, forceFont;
int cycleNum, successes;
Cycle[] cycles;
boolean con1, con2, con3;  // Connections
float pullForce, pushForce, pullPeak, pushPeak;
int pullPeakTime, pushPeakTime;
int maxPush = 300;
int ackTime, serTime;
boolean dirIn, prevDir;
boolean autoAdd;
int autoAddTime;

int serialCount = 0;                 // A count of how many bytes we receive

void setup(){
  size(1200,700);
  cycleFont = createFont("Lato-Medium.ttf", 130);     // Font for number of cycles
  connectFont = createFont("Lato-Medium.ttf", 90);   // Font for connected status
  forceFont = createFont("Lato-Medium.ttf", 50);     // Font for forces
    // Print a list of the serial ports, for debugging purposes:
  printArray(Serial.list());
  //String portName = Serial.list()[4];
  while(teensyPort().equals("")){
    showMessageDialog(null, "Port not found!\nPlease plug in device", "Alert", ERROR_MESSAGE);
    printArray(Serial.list());
  }
  serialPort = new Serial(this, teensyPort(), 9600);
  serialPort.write("A\n");
  cycleNum = 1;
  
  sdf.setTimeZone(TimeZone.getTimeZone("GMT+12"));
  println("loading from " + outFilename);
  loadData();
  cycleNum = cycles.length-1;
  newCycle();
}

void draw(){
  if(millis() > ackTime + 100){
    serialPort.write("A\n");
    ackTime = millis();
  }
  if(millis() > serTime + 500){
    while(teensyPort().equals("")){
      showMessageDialog(null, "Not receiving data!\nPlease plug in device", "Alert", ERROR_MESSAGE);
      printArray(Serial.list());
    }
    serialPort = new Serial(this, teensyPort(), 9600);
  }
  
  
  if(pushForce > pushPeak){
    pushPeak = pushForce;
    pushPeakTime = millis();
  }
  if(pullForce > pullPeak){
    pullPeak = pullForce;
    pullPeakTime = millis();
  }

  
  Cycle thisCycle =  cycles[cycleNum];
  
  //If it was going in but isn't now, save push and connection status
  if(prevDir && !dirIn){
    thisCycle.push = pushPeak;
    thisCycle.left = con1;
    thisCycle.right = con2;
    thisCycle.ground = con3;
    pullPeak = 0;
  }
  
  // if it wasn't going in before but is now, new cycle
  if(!prevDir && dirIn){
    thisCycle.pull = pullPeak;
    saveData();
    newCycle();
    pushPeak = 0;
  }
  prevDir = dirIn;
  
  if(autoAdd){
    pushForce = noise(millis()/1000.1) * 250;
    pullForce = noise(millis()/1000.1 + 1000) *250;
    if(millis() > autoAddTime + 200){
      autoAddTime = millis();
      Cycle c =  cycles[cycleNum];

      c.push = pushPeak;
      c.pull = pullPeak;
      c.left = con1;
      c.right = con2;
      c.ground = con3;
  
      saveData();
      newCycle();
      
      pushPeak = 0;
      pullPeak = 0;
    }
  }
  
  background(0);
  textAlign(LEFT);
  
  // Draw Cycles at the top
  textFont(cycleFont);
  fill(255);
  String cycleText = "Cycles: " + nfc(cycleNum);
  text(cycleText, 100, 180);
  
  textFont(forceFont);
  fill(255);
  float successRate = float(successes)/float(cycleNum)* 100;
  String successText = "Success rate: " + nfc(successRate, 2) + " %";
  text(successText, 50, 300);
  
  // Draw connection status in middle
  
  // Circles
  ellipseMode(CENTER);
  noFill();
  strokeWeight(6);
  if(con1) stroke(0,200,0);
  else stroke(200,0,0);
  ellipse(100, 370, 30, 30);
  if(con2) stroke(0,200,0);
  else stroke(200,0,0);
  ellipse(100, 370, 60, 60);
  if(con3) stroke(0,200,0);
  else stroke(200,0,0);
  ellipse(100, 370, 90, 90);
  
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
  text(connectText, 200, 400);
  
  
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
  if(key == 'n'){
    Cycle thisCycle =  cycles[cycleNum];

    thisCycle.push = pushPeak;
    thisCycle.pull = pullPeak;
    thisCycle.left = con1;
    thisCycle.right = con2;
    thisCycle.ground = con3;

    saveData();
    newCycle();
  }
  else if(key == 'r'){
    pushPeak = random(30,200);
    pullPeak = random(30,200);
  }
  else if(key == '1'){
    con1 = !con1;
  }
  else if(key == '2'){
    con2 = !con2;
  }
  else if(key == '3'){
    con3 = !con3;
  }
  
  else if(key == 'a'){
    autoAdd = !autoAdd;
  }
}


boolean intToBool(int in){
  boolean result = false;
  if(in > 0) result = true;
  return result;
}

//void readCycle(){
//  int c = serialInArray[5];
//  c <<= 8;
//  c |= serialInArray[6];
//  c <<= 8;
//  c |= serialInArray[7];
//  c <<= 8;
//  c |= serialInArray[8];
//  cycleNum = c;
//}