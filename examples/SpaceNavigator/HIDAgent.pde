public class HIDAgent extends ActionMotionAgent<MotionProfile<SpaceAction>, ClickProfile<ClickAction>> {
  public HIDAgent(InputHandler h, String n) {
    super(new MotionProfile<SpaceAction>(), new ClickProfile<ClickAction>(), h, n);
    //default bindings
    profile().setBinding(SpaceAction.CHANGE_POS_SHAPE);
    disableTracking();
    setSensitivities(0.01, 0.01, 0.01, 0.0001, 0.0001, 0.0001);
  }

  @Override
  public DOF6Event feed() {
    return new DOF6Event(sliderXpos.getValue(), sliderYpos.getValue(), sliderZpos.getValue(),
                         sliderXrot.getValue(), sliderYrot.getValue(), sliderZrot.getValue());
  }
}