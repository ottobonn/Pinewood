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
    parent.text(Double.toString(time) + " s (" + finishingPosition + ")", parent.width/2, yCoordinate);
  }
  
  public int compareTo(Lane other) {
    return this.getTime() < other.getTime() ? -1 : 1;
  }
}