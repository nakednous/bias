import remixlab.bias.core.*;
import remixlab.bias.event.*;

public class MouseAgent extends Agent {
  DOF2Event event;

  public MouseAgent(InputHandler scn, String n) {
    super(scn, n);
  }

  public void mouseEvent(processing.event.MouseEvent e) {
    event = new DOF2Event(e.getX(), e.getY());
    if ( e.getAction() == processing.event.MouseEvent.MOVE )
      updateTrackedGrabber(event);
    if ( e.getAction() == processing.event.MouseEvent.DRAG )
      handle(event);
  }
}

public class Ellipse extends GrabberObject {
  public float radiusX, radiusY;
  public PVector center;
  public color colour;
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
    setColor(color(random(0, 255), random(0, 255), random(0, 255), random(100, 200)));
  }

  public void setColor(color myC) {
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
    if (event instanceof DOF2Event) {
      float x = ((DOF2Event)event).x();
      float y = ((DOF2Event)event).y();
      return(pow((x - center.x), 2)/pow(radiusX, 2) + pow((y - center.y), 2)/pow(radiusY, 2) <= 1);
    }      
    return false;
  }

  @Override
  public void performInteraction(BogusEvent event) {
    setColor();
    setPosition();
  }
}

int w = 600;
int h = 600;
MouseAgent agent;
InputHandler inputHandler;
Ellipse [] ellipses;

void setup() {
  size(w, h);
  inputHandler = new InputHandler();
  agent = new MouseAgent(inputHandler, "my_mouse");
  registerMethod("mouseEvent", agent);
  ellipses = new Ellipse[50];
  for (int i = 0; i < ellipses.length; i++)
    ellipses[i] = new Ellipse(agent);
}

void draw() {
  background(255);
  for (int i = 0; i < ellipses.length; i++) {
    if ( ellipses[i].grabsInput(agent) )
      ellipses[i].draw(color(255, 0, 0));
    else
      ellipses[i].draw();
  }
  inputHandler.handle();
}
