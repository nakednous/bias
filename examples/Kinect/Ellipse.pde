public class Ellipse extends GrabberObject {
  public float radiusX, radiusY;
  public PVector center;
  public int colour;
  public int contourColour;
  public int sWeight;

  public Ellipse(Agent agent) {
    agent.addInPool(this);
    setColor();
    setPosition();
    sWeight = 4;
    contourColour = color(0, 0, 0);
  }

  public Ellipse(Agent agent, PVector c, float r) {
    agent.addInPool(this);
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
    float highX = w - maxRadius;
    float highY = h - maxRadius;
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
    ellipse(center.x, center.y, 2*radiusX, 2*radiusY);
    popStyle();
  }

  @Override
  public boolean checkIfGrabsInput(BogusEvent event) {
    float threshold = 100;
    float x,y,z;
    if (event instanceof DOF2Event) {
      x = ((DOF2Event)event).x();
      y = ((DOF2Event)event).y();
      return(pow((x - center.x), 2)/pow(radiusX, 2) + pow((y - center.y), 2)/pow(radiusY, 2) <= 1);
    }
    // begin kinect
    if (event instanceof KINECTEvent) {
      x = ((KINECTEvent)event).x();
      y = ((KINECTEvent)event).y();
      z = ((KINECTEvent) event).leftHand().position().z - ((KINECTEvent) event).rightHand().position().z;
      if (z > threshold && (pow((x - center.x), 2)/pow(radiusX, 2) + pow((y - center.y), 2)/pow(radiusY, 2) <= 1))
        return true;
      else if (z < -threshold)
        return false;
    }
    // end kinect    
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
        case CHANGE_POS_SHAPE:
        radiusX = abs( ((KINECTEvent)event).rightHand().position().x- ((KINECTEvent)event).leftHand().position().x);
        radiusY = abs( ((KINECTEvent)event).rightHand().position().y- ((KINECTEvent)event).leftHand().position().y);        
        setPosition(((KINECTEvent)event).x(), ((KINECTEvent)event).y());           
        break;
      }
    }
  }
}
