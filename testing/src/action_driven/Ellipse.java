package action_driven;

import remixlab.bias.*;
import remixlab.bias.event.*;
import processing.core.*;

/**
 * Created by pierre on 12/22/16.
 */
public class Ellipse extends GrabberObject {
  public PApplet parent;
  public float radiusX, radiusY;
  public PVector center;
  public int colour;
  public int contourColour;
  public int sWeight;
  protected Profile profile;

  public Ellipse(PApplet p, InputHandler handler) {
    super(handler);
    parent = p;
    setProfile(new Profile(this));
    setMouseDragBindings();
    setColor();
    setPosition();
    sWeight = 4;
    contourColour = parent.color(0, 0, 0);
  }

  public Ellipse(PApplet p, InputHandler handler, PVector c, float r) {
    super(handler);
    parent = p;
    setProfile(new Profile(this));
    setMouseDragBindings();
    radiusX = r;
    radiusY = r;
    center = c;
    setColor();
    sWeight = 4;
  }

  public void setMouseDragBindings() {
    profile().removeBindings();
    profile().setBinding(new MotionShortcut(ActionDrivenCallback.LEFT_ID), "setPosition");
    profile().setBinding(new MotionShortcut(ActionDrivenCallback.RIGHT_ID), "setShape");
    profile().setBinding(new ClickShortcut(ActionDrivenCallback.LEFT_CLICK_ID, 1), "setColor");
  }

  public void setMouseMoveBindings() {
    profile().removeBindings();
    profile().setBinding(new MotionShortcut(ActionDrivenCallback.NO_BUTTON), "setPosition");
    profile().setBinding(new MotionShortcut(ActionDrivenCallback.RIGHT_ID), "setShape");
  }

  public Profile profile() {
    return profile;
  }

  public void setProfile(Profile p) {
    if (p.grabber() == this)
      profile = p;
    else
      System.out.println("Nothing done, profile grabber is different than this grabber");
  }

  public void setColor(int myC) {
    colour = myC;
  }

  public void setColor() {
    setColor(parent.color(parent.random(0, 255), parent.random(0, 255), parent.random(0, 255), parent.random(100, 200)));
  }

  public void setPosition(DOF2Event event) {
    setPositionAndRadii(new PVector(event.x(), event.y()), radiusX, radiusY);
  }

  public void setShape(DOF2Event event) {
    radiusX += event.dx();
    radiusY += event.dy();
  }

  public void setPositionAndRadii(PVector p, float rx, float ry) {
    center = p;
    radiusX = rx;
    radiusY = ry;
  }

  public void setPosition() {
    float maxRadius = 50;
    float low = maxRadius;
    float highX = 800 - maxRadius;
    float highY = 800 - maxRadius;
    float r = parent.random(20, maxRadius);
    setPositionAndRadii(new PVector(parent.random(low, highX), parent.random(low, highY)), r, r);
  }

  public void draw() {
    draw(colour);
  }

  public void draw(int c) {
    parent.pushStyle();
    parent.stroke(contourColour);
    parent.strokeWeight(sWeight);
    parent.fill(c);
    parent.ellipse(center.x, center.y, 2*radiusX, 2*radiusY);
    parent.popStyle();
  }

  @Override
  public boolean checkIfGrabsInput(DOF2Event event) {
    return checkIfGrabsInput(event.x(), event.y());
  }

  @Override
  public boolean checkIfGrabsInput(ClickEvent event) {
    return checkIfGrabsInput(event.x(), event.y());
  }

  public boolean checkIfGrabsInput(float x, float y) {
    return(PApplet.pow((x - center.x), 2)/PApplet.pow(radiusX, 2) + PApplet.pow((y - center.y), 2)/PApplet.pow(radiusY, 2) <= 1);
  }

  @Override
  public void performInteraction(BogusEvent event) {
    profile().handle(event);
  }
}