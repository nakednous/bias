/**
 * Space Navigator.
 * by Jean Pierre Charalambos.
 *
 * Notice that this example needs special requirements.
 *
 * Documentation (including requirements) found on the online
 * tutorial: https://github.com/nakednous/bias/wiki/1.4.-SpaceNavigator
 *
 * Use the mouse (move, drag or click it) to control the ellipses.
 * Use a SpaceNavigator to control the ellipses.
 */

import remixlab.bias.*;
import remixlab.bias.event.*;

import org.gamecontrolplus.*;
import net.java.games.input.*;

public static final int LEFT_ID = MotionShortcut.registerID(37, 2, "LEFT"), CENTER_ID = MotionShortcut
    .registerID(3, 2, "CENTER"), RIGHT_ID = MotionShortcut.registerID(39, 2, "RIGHT"), WHEEL_ID = MotionShortcut
    .registerID(8, 1, "WHEEL"), NO_BUTTON = MotionShortcut
    .registerID(BogusEvent.NO_ID, 2, "NO_BUTTON"), LEFT_CLICK_ID = ClickShortcut
    .registerID(LEFT_ID, "LEFT"), RIGHT_CLICK_ID = ClickShortcut
    .registerID(RIGHT_ID, "RIGHT"), CENTER_CLICK_ID = ClickShortcut.registerID(CENTER_ID, "CENTER");

// id of the SpaceNavigator gesture
public static final int SN_ID = MotionShortcut.registerID(6, "SN_SENSOR");

MouseAgent agent;
HIDAgent hidAgent;
InputHandler inputHandler;
Ellipse [] ellipses;

ControlIO control;
ControlDevice device; // my SpaceNavigator
ControlSlider sliderXpos; // Positions
ControlSlider sliderYpos;
ControlSlider sliderZpos;
ControlSlider sliderXrot; // Rotations
ControlSlider sliderYrot;
ControlSlider sliderZrot;
ControlButton button1; // Buttons
ControlButton button2;

void setup() {
  size(800, 800);
  openSpaceNavigator();
  inputHandler = new InputHandler();
  agent = new MouseAgent(inputHandler);
  registerMethod("mouseEvent", agent);
  hidAgent = new HIDAgent(inputHandler);
  ellipses = new Ellipse[50];
  for (int i = 0; i < ellipses.length; i++)
    ellipses[i] = new Ellipse(inputHandler);
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

void keyPressed() {
  if (key == ' ') {
    agent.click2Pick = !agent.click2Pick;
    agent.resetTrackedGrabber();
    for (int i = 0; i < ellipses.length; i++) {
      if (agent.click2Pick)
        ellipses[i].setMouseMoveBindings();
      else
        ellipses[i].setMouseDragBindings();
      ellipses[i].setSpaceNavigatorBindings();
    }
  }
}

void openSpaceNavigator() {
  println(System.getProperty("os.name"));
  control = ControlIO.getInstance(this);
  String os = System.getProperty("os.name").toLowerCase();
  if (os.indexOf( "nix") >=0 || os.indexOf( "nux") >=0)
    device = control.getDevice("3Dconnexion SpaceNavigator");// magic name for linux
  else
    device = control.getDevice("SpaceNavigator");//magic name, for windows
  if (device == null) {
    println("No suitable device configured");
    System.exit(-1); // End the program NOW!
  }
  //device.setTolerance(5.00f);
  sliderXpos = device.getSlider(0);
  sliderYpos = device.getSlider(1);
  sliderZpos = device.getSlider(2);
  sliderXrot = device.getSlider(3);
  sliderYrot = device.getSlider(4);
  sliderZrot = device.getSlider(5);
  //button1 = device.getButton(0);
  //button2 = device.getButton(1);
}
