import remixlab.bias.core.*;
import remixlab.bias.agent.*;
import remixlab.bias.event.*;
import remixlab.bias.agent.profile.*;

import procontroll.*;
import net.java.games.input.*;

public class HIDAgent extends ActionMotionAgent<MotionProfile<SpaceAction>, ClickProfile<ClickAction>> {
  public HIDAgent(InputHandler h, String n) {
    super(new MotionProfile<SpaceAction>(), new ClickProfile<ClickAction>(), h, n);
    //default bindings
    profile().setBinding(SpaceAction.CHANGE_POS_SHAPE);
    disableTracking();
    setSensitivities(0.01, 0.01, 0.01, 0.0001, 0.0001, 0.0001);
  }

  @Override
  public DOF6Event feed() {
    return new DOF6Event(sliderXpos.getValue(), sliderYpos.getValue(), sliderZpos.getValue(),
                         sliderXrot.getValue(), sliderYrot.getValue(), sliderZrot.getValue(), 0, 0);
  }
}

public class MouseAgent extends ActionMotionAgent<MotionProfile<MotionAction>, ClickProfile<ClickAction>> {
  DOF2Event event, prevEvent;
  public MouseAgent(InputHandler scn, String n) {
    super(new MotionProfile<MotionAction>(), 
          new ClickProfile<ClickAction>(), scn, n);
    //default bindings
    clickProfile().setBinding(LEFT, 1, ClickAction.CHANGE_COLOR);
    clickProfile().setBinding(DOF2Event.META, RIGHT, 1, ClickAction.CHANGE_STROKE_WEIGHT);
    clickProfile().setBinding((DOF2Event.META | DOF2Event.SHIFT), RIGHT, 1, ClickAction.CHANGE_STROKE_WEIGHT);
    profile().setBinding(LEFT, MotionAction.CHANGE_POSITION);
    profile().setBinding(DOF2Event.SHIFT, LEFT, MotionAction.CHANGE_SHAPE);
    profile().setBinding(DOF2Event.META, RIGHT, MotionAction.CHANGE_SHAPE);
  }
  
  public void mouseEvent(processing.event.MouseEvent e) {      
    if ( e.getAction() == processing.event.MouseEvent.MOVE ) {
      event = new DOF2Event(prevEvent, e.getX(), e.getY(),e.getModifiers(), e.getButton());
      updateTrackedGrabber(event);
      prevEvent = event.get();
    }
    if ( e.getAction() == processing.event.MouseEvent.DRAG ) {
      event = new DOF2Event(prevEvent, e.getX(), e.getY(), e.getModifiers(), e.getButton());
      handle(event);
      prevEvent = event.get();
    }
    if ( e.getAction() == processing.event.MouseEvent.CLICK ) {
      handle(new ClickEvent(e.getX(), e.getY(), e.getModifiers(), e.getButton(), e.getCount()));
    }
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

int w = 600;
int h = 600;
MouseAgent agent;
HIDAgent hidAgent;
InputHandler inputHandler;
Ellipse [] ellipses;

ControllIO controll;
ControllDevice device; // my SpaceNavigator
ControllSlider sliderXpos; // Positions
ControllSlider sliderYpos;
ControllSlider sliderZpos;
ControllSlider sliderXrot; // Rotations
ControllSlider sliderYrot;
ControllSlider sliderZrot;
ControllButton button1; // Buttons
ControllButton button2;

void setup() {
  size(w, h);
  openSpaceNavigator();
  inputHandler = new InputHandler();
  agent = new MouseAgent(inputHandler, "my_mouse");
  registerMethod("mouseEvent", agent);
  hidAgent = new HIDAgent(inputHandler, "SpaceNavigator");
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

void openSpaceNavigator() {
  println(System.getProperty("os.name"));
  controll = ControllIO.getInstance(this);  
  String os = System.getProperty("os.name").toLowerCase();  
  if (os.indexOf( "nix") >=0 || os.indexOf( "nux") >=0)
    device = controll.getDevice("3Dconnexion SpaceNavigator");// magic name for linux    
  else
    device = controll.getDevice("SpaceNavigator");//magic name, for windows
  device.setTolerance(5.00f);
  sliderXpos = device.getSlider(2);
  sliderYpos = device.getSlider(1);
  sliderZpos = device.getSlider(0);
  sliderXrot = device.getSlider(5);
  sliderYrot = device.getSlider(4);
  sliderZrot = device.getSlider(3);
  button1 = device.getButton(0);
  button2 = device.getButton(1);
}
