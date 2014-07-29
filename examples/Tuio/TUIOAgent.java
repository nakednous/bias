import java.util.HashMap;
import java.util.Map;

import processing.core.*;
import TUIO.TuioCursor;

import remixlab.bias.core.*;
import remixlab.bias.event.*;
import remixlab.bias.agent.*;
import remixlab.bias.agent.profile.*;

public class TUIOAgent extends ActionMotionAgent<MotionProfile<MotionAction>, ClickProfile<ClickAction>> {	
  PGraphics canvas;
  DOF2Event event, prevEvent;
  Map<Integer, Grabber> grabMap = new HashMap<Integer, Grabber>();

  public TUIOAgent(InputHandler scn, String n, PGraphics canvas) {
    super(new MotionProfile<MotionAction>(), new ClickProfile<ClickAction>(), scn, n);
    this.canvas = canvas;
    // default bindings
    clickProfile().setBinding(PApplet.LEFT, 1, ClickAction.CHANGE_COLOR);
    profile().setBinding(PApplet.LEFT, MotionAction.CHANGE_POSITION);
  }

  public void addTuioCursor(TuioCursor tcur) {
    event = new DOF2Event(prevEvent, tcur.getScreenX(canvas.width), tcur.getScreenY(canvas.height), 0, 0);
    Grabber grabbable = updateTrackedGrabber(event);
    if (grabbable != null)
      grabMap.put(tcur.getCursorID(), grabbable);
  }

  // called when a cursor is moved
  public void updateTuioCursor(TuioCursor tcur) {
    Grabber trackedGrabber = grabMap.get(tcur.getCursorID());
    if (trackedGrabber != null) {
      event = new DOF2Event(prevEvent, tcur.getScreenX(canvas.width), tcur.getScreenY(canvas.height), 0, PApplet.LEFT);
      disableTracking();
      setDefaultGrabber(trackedGrabber);
      handle(event);
      enableTracking();
    } 
    prevEvent = event.get();
  }

  // called when a cursor is removed from the scene
  public void removeTuioCursor(TuioCursor tcur) {
    event = new DOF2Event(prevEvent, -1000, -1000, 0, 0);
    grabMap.remove(tcur.getCursorID());
    disableTracking();
    enableTracking();
  }
}

