/**
 * Space Navigator.
 * by Jean Pierre Charalambos.
 * 
 * Documentation found on the online tutorial: https://github.com/nakednous/bias/wiki/1.4.-SpaceNavigator
 */

import remixlab.bias.core.*;
import remixlab.bias.agent.*;
import remixlab.bias.event.*;
import remixlab.bias.agent.profile.*;

import procontroll.*;
import net.java.games.input.*;

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