import processing.core.*;

import remixlab.bias.core.*;
import remixlab.bias.event.*;
import remixlab.bias.agent.*;
import remixlab.bias.agent.profile.*;

public class Ellipse extends GrabberObject {
  public float radiusX, radiusY;
  public PVector center;
  public int colour;
  public int contourColour;
  public int sWeight;

  public Ellipse(InputHandler handler) {
    super(handler);
    sWeight = 4;
    contourColour = color(255, 255, 255);
    setColor();
    setPosition();
  }

  public Ellipse(InputHandler handler, PVector c, float r) {
    super(handler);
    radiusX = r;
    radiusY = r;
    center = c;
    setColor();
    sWeight = 4;
  }
  
  public void setColor() {
    setColor(color(random(0, 255), random(0, 255), random(0, 255)));
  }

  public void setColor(int myC) {
    colour = myC;
  }

  public void setPosition(float x, float y) {
    setPositionAndRadii(new PVector(x, y), radiusX, radiusY);
  }

  public void setPositionAndRadii(PVector p, float rx, float ry) {
    center = p;
    radiusX = rx;
    radiusY = ry;
  }

  public void setPosition() {
    float maxRadius = 50;
    float low = maxRadius;
    float highX = width - maxRadius;
    float highY = height - maxRadius;
    float r = random(20, maxRadius);
    setPositionAndRadii(new PVector(random(low, highX), random(low, highY)), r, r);
  }

  public void draw() {
    draw(colour);
  }

  public void draw(int c) {
    pushStyle();
    stroke(contourColour);
    strokeWeight(sWeight);
    fill(c);
    ellipse(center.x, center.y, 2 * radiusX, 2 * radiusY);
    popStyle();
  }
  
  @Override
  public boolean checkIfGrabsInput(BogusEvent event) {
    if (event instanceof DOF2Event) {
      float x = ((DOF2Event)event).x();
      float y = ((DOF2Event)event).y();
      return(pow((x - center.x), 2)/pow(radiusX, 2) + pow((y - center.y), 2)/pow(radiusY, 2) <= 1);
    }      
    return false;
  }

  @Override
  public void performInteraction(BogusEvent event) {
    if (((BogusEvent)event).action() != null) {
      switch ((GlobalAction) ((BogusEvent)event).action().referenceAction()) {
        case CHANGE_COLOR:
        contourColour = color(random(100, 255), random(100, 255), random(100, 255));
        break;
      case CHANGE_STROKE_WEIGHT:
        if (event.isShiftDown()) {          
          if (sWeight > 1)
            sWeight--;
        }
        else      
          sWeight++;    
        break;
      case CHANGE_POSITION:
        setPosition( ((DOF2Event)event).x(), ((DOF2Event)event).y() );
        break;
        case CHANGE_SHAPE:
        radiusX += ((DOF2Event)event).dx();
        radiusY += ((DOF2Event)event).dy();
        break;
      }
    }
  } 
}
