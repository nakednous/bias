/**
 * Event Grabber Tuples.
 * by Jean Pierre Charalambos.
 * 
 * Documentation found on the online tutorial: https://github.com/nakednous/bias/wiki/1.3.-EventGrabberTuples
 */

import remixlab.bias.core.*;
import remixlab.bias.agent.*;
import remixlab.bias.event.*;
import remixlab.bias.agent.profile.*;

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
