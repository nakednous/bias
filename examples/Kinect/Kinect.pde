/**
 * Kinect.
 * by Miguel Parra and Jean Pierre Charalambos.
 * 
 * Documentation found on the online tutorial: https://github.com/nakednous/bias/wiki/1.6.-Kinect
 */
 
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
  kinectAgent = new KINECTAgent(inputHandler, "Kinect");
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
