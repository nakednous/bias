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
      event = new DOF2Event(prevEvent, e.getX(), e.getY(), e.getModifiers(), e.getButton());
      updateTrackedGrabber(event);
      prevEvent = event.get();
    }
    if ( e.getAction() == processing.event.MouseEvent.DRAG ) {
      event = new DOF2Event(prevEvent, e.getX(), e.getY(), e.getModifiers(), e.getButton());
      if(event.isControlDown())
        inputHandler().enqueueEventTuple(new EventGrabberTuple(event, MotionAction.CHANGE_POSITION, ellipses[20]));
      else
        handle(event);
      prevEvent = event.get();
    }
    if ( e.getAction() == processing.event.MouseEvent.CLICK ) {
      handle(new ClickEvent(e.getX(), e.getY(), e.getModifiers(), e.getButton(), e.getCount()));
    }
  }
}