import processing.core.*;

class Lane implements Comparable<Lane> {
  protected PApplet parent;
  protected int backgroundColor, textColor;
  protected String name;
  protected double time;
  protected int index;
  
  public Lane(String name, int index, int backgroundColor, int textColor, PApplet parent){
    this.name = name;
    this.index = index;
    this.backgroundColor = backgroundColor;
    this.textColor = textColor;
    this.parent = parent;
  }
  
  public void setTime(double time){
    this.time = time;
  }
  
  public double getTime(){
    return time;
  }
  
  public int getIndex(){
    return index;
  }
  
  public void draw (PFont titleFont, int finishingPosition){
    parent.textFont(titleFont);
    parent.textAlign(PApplet.LEFT, PApplet.CENTER);
    
    name += " ";
    float yCoordinate = parent.height/4*index + parent.height/8;
    float nameWidth = parent.textWidth(name);
    
    parent.fill(backgroundColor);
    parent.noStroke();
    parent.rect(0, parent.height/4*index, parent.width, parent.height/4);
    
    parent.fill(textColor);
    parent.text(name, 20, yCoordinate);
    boolean didFinish = this.getTime() != 0;
    String positionString = didFinish ? positionToString(finishingPosition) : "No Finish";
    String timeString = didFinish ? Double.toString(time) + "s  -  " : "";
    parent.text(timeString + positionString, parent.width/2, yCoordinate);
  }
  
  public int compareTo(Lane other) {
    if (this.getTime() == 0) return 1;
    if (other.getTime() == 0) return -1;
    return this.getTime() < other.getTime() ? -1 : 1;
  }
  
  static String positionToString(int position) {
    switch(position) {
      case 0: return "Winner!";
      case 1: return "Second";
      case 2: return "Third";
      case 3: return "Fourth";
      default: return "Unknown";
    }
  }
}