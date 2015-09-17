import processing.serial.*;
import java.util.Arrays;

Serial port = null;

PFont titleFont;

boolean debug = false;

int PADDING_LEFT = 10;

Lane lanes[];


void setup(){
  if(!debug){
    String ports[] = Serial.list();
    printArray(ports);
    port = new Serial(this, ports[ports.length-1], 9600);
    println("Connected to " + ports[ports.length-1]);
  }
  size(1000, 500);
  frame.setResizable(true);
  titleFont = loadFont("Carlito-Bold-48.vlw");
  
  lanes = new Lane[4];
  lanes[0] = new Lane("Lane 1", 0, color(255, 24, 0), color(255), this);
  lanes[1] = new Lane("Lane 2", 1, color(255, 171, 0), color(0), this);
  lanes[2] = new Lane("Lane 3", 2, color(0, 200, 49), color(0), this);
  lanes[3] = new Lane("Lane 4", 3, color(10, 67, 208), color(255), this);
}

String readMessage(Serial port){
  if (debug) 
    return "@A=0.244! B=0.407  C=0.491  D=0.609  E=0.000  F=0.000";
  String message = null;
  while (port.available() > 0) {
    message = port.readStringUntil('\n');
    if (message != null)
      println(message);
  }
  return message;
}

double[] getTimes(String message){
  if (message == null)
    return null;
  message = message.substring(1, message.length());
  // The raw message from the track looks like this:
  // @A=0.244! B=0.407  C=0.491  D=0.609  E=0.000  F=0.000
  String[][] matches = matchAll(message, "A=(\\d*\\.?\\d*)!?\\s+B=(\\d*\\.?\\d*)!?\\s+C=(\\d*\\.?\\d*)!?\\s+D=(\\d*\\.?\\d*)!?\\s+");
  if (matches == null) return null;
  
  String[] timeStrings = matches[0];
  double[] times = new double[timeStrings.length - 1];
  for (int i = 0; i < times.length; i++)
    times[i] = Double.parseDouble(timeStrings[i+1]);
  return times;
}

void drawLane(int index, 
              String name,
              double time,
              color backgroundColor,
              color textColor){
  textFont(titleFont);
  textAlign(LEFT, CENTER);
  
  name += " ";
  float yCoordinate = height/4*index + height/8;
  float nameWidth = textWidth(name);
  
  fill(backgroundColor);
  noStroke();
  rect(0, height/4*index, width, height/4);
  
  fill(textColor);
  noStroke();
  text(name, PADDING_LEFT, yCoordinate);
  text(Double.toString(time) + " s", width/2, yCoordinate);
};

void drawBackground(){
  fill(255);
  rect(0, 0, width, height);
}

void draw(){
  String message = readMessage(port);
  double[] times = getTimes(message);
  // Remember that the lanes might not be in track-order.
  if (times != null){
    for (int i = 0; i < lanes.length; i++) {
      println(times[i]);
      lanes[i].setTime(times[lanes[i].getIndex()]);
    }
    Arrays.sort(lanes);
  }
  drawBackground();
  for (int i = 0; i < lanes.length; i++) {
    lanes[i].draw(titleFont, i);
  }
}