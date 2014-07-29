public class KINECTEvent extends DOF3Event {
  Hand left, right;
  
  public KINECTEvent(KINECTEvent prevEvent, Hand l, Hand r) { 
    super(prevEvent, ((l.position().x+r.position().x)/2), ((l.position().y+r.position().y)/2), 1300-((l.position().z+r.position().z)/2));
    left = new Hand(l.position());
    right = new Hand(r.position());
  }
  
  protected KINECTEvent(KINECTEvent other) {
    super(other);
    left = new Hand(other.leftHand().position());
    right = new Hand(other.rightHand().position());
  }
  
  @Override
  public KINECTEvent get() {
    return new KINECTEvent(this);
  }
  
  public Hand leftHand() {
    return left;
  }
  
  public Hand rightHand() {
    return right;
  }
}
