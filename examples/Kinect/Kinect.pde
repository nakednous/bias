/**
 * Tersehandling - https://github.com/remixlab/tersehandling
 * National University of Colombia - Remixlab
 * @author Jean Pierre Charalambos
 * Class to manage the Kinect functions and the Kinect Agent with Tersehandling
 * Example by Miguel Alejandro Parra [maparrar(at)gmail(dot)com]
 * */
 
import remixlab.bias.core.*;
import remixlab.bias.agent.*;
import remixlab.bias.event.*;
import remixlab.bias.agent.profile.*;

int w = 600;
int h = 600;

//Kinect kinect;
MouseAgent agent;
KINECTAgent kinectAgent;
InputHandler inputHandler;
Ellipse [] ellipses;

PVector kinectPos; // Positions
PVector kinectRot; // Rotations

void setup() {
  size(w, h);
  inputHandler = new InputHandler();
  agent = new MouseAgent(inputHandler, "my_mouse");
  registerMethod("mouseEvent", agent);
  kinectAgent = new KINECTAgent(this, inputHandler, "Kinect");
  ellipses = new Ellipse[50];
  for (int i = 0; i < ellipses.length; i++)
    ellipses[i] = new Ellipse(agent);
  for (int i = 0; i < ellipses.length; i++)
    kinectAgent.addInPool(ellipses[i]);
}

void draw() {
  background(255);
  //Update the Kinect data
  kinectAgent.update();
  
  //Get the translation and rotation vectors from Kinect
  kinectPos=kinectAgent.positionVector();
  kinectRot=kinectAgent.rotationVector();
  
  for (int i = 0; i < ellipses.length; i++) {
    if ( ellipses[i].grabsInput(agent) )
      ellipses[i].draw(color(255, 0, 0));
    else
      ellipses[i].draw();
  }
  inputHandler.handle();
  //DRaw the hands position
  kinectAgent.draw();
}

void keyPressed() {
  println("mouse: " + mouseX + " " + mouseY);
  println("kinect: " + kinectPos.x + " " + kinectPos.y + " " + kinectPos.z);
}

/****************************************************************************/
/******************************* KINECT EVENTS ******************************/
/****************************************************************************/
// SimpleOpenNI events
void onNewUser(SimpleOpenNI curContext, int userId){
  kinectAgent.onNewUser(curContext,userId);
}
