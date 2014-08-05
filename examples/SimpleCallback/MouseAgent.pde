public class MouseAgent extends Agent {
  DOF2Event event;

  public MouseAgent(InputHandler scn, String n) {
    super(scn, n);
  }

  public void mouseEvent(processing.event.MouseEvent e) {
    event = new DOF2Event(e.getX(), e.getY());
    if ( e.getAction() == processing.event.MouseEvent.MOVE )
      updateTrackedGrabber(event);
    if ( e.getAction() == processing.event.MouseEvent.DRAG )
      handle(event);
  }
}