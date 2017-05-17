/**
 * Simple Callback.
 * by Jean Pierre Charalambos.
 *
 * Documentation found on the online tutorial: https://github.com/nakednous/bias/wiki/1.1.-SimpleCallback
 */

import remixlab.bias.*;
import remixlab.bias.event.*;

MouseAgent agent;
InputHandler inputHandler;
Ellipse [] ellipses;

public static final int LEFT_ID = MotionShortcut.registerID(37, 2, "LEFT"), CENTER_ID = MotionShortcut
    .registerID(3, 2, "CENTER"), RIGHT_ID = MotionShortcut.registerID(39, 2, "RIGHT"), WHEEL_ID = MotionShortcut
    .registerID(8, 1, "WHEEL"), NO_BUTTON = MotionShortcut
    .registerID(remixlab.bias.Event.NO_ID, 2, "NO_BUTTON"), LEFT_CLICK_ID = ClickShortcut
    .registerID(LEFT_ID, "LEFT"), RIGHT_CLICK_ID = ClickShortcut
    .registerID(RIGHT_ID, "RIGHT"), CENTER_CLICK_ID = ClickShortcut.registerID(CENTER_ID, "CENTER");

void setup() {
  size(800, 800);
  inputHandler = new InputHandler();
  agent = new MouseAgent(inputHandler);
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