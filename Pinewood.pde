import processing.serial.*;

String portName = "/dev/ttyUSB0";
Serial port = null;

PFont titleFont = createFont("RazerRegular", 100);

boolean debug = true;

void setup(){
  if(!debug){
    port = new Serial(this, portName, 9600);
    println("Connected to " + portName);
  }
  size(1000, 500);
  frame.setResizable(true);
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
              color textColor,
              color backgroundColor){
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
  text(name, 0, yCoordinate);
  text(Double.toString(time) + " s", width/2, yCoordinate);
};

void drawBackground(){
  fill(255);
  rect(0, 0, width, height);
}

void draw(){
  String message = readMessage(port);
  double[] times = getTimes(message);
  if (times != null){
    for (int i = 0; i < times.length; i++)
      println(times[i]);
    drawBackground();
    drawLane(0, "White", times[0], color(0), color(255));
    drawLane(1, "Black", times[1], color(255), color(0));
    drawLane(2, "Yellow", times[2], color(122, 41, 107), color(255, 255, 0));
    drawLane(3, "Blue", times[3], color(255, 246, 170), color(0, 0, 255));
  }
}
