/**************************************************************************************
 * bias_tree
 * Copyright (c) 2014-2017 National University of Colombia, https://github.com/remixlab
 * @author Jean Pierre Charalambos, http://otrolado.info/
 *
 * All rights reserved. Library that eases the creation of interactive
 * scenes, released under the terms of the GNU Public License v3.0
 * which is available at http://www.gnu.org/licenses/gpl.html
 **************************************************************************************/

package remixlab.bias.event;

import remixlab.bias.Shortcut;

import java.util.ArrayList;
import java.util.HashMap;

/**
 * This class represents {@link remixlab.bias.event.MotionEvent} shortcuts.
 * <p>
 * Motion shortcuts can be of one of two forms: 1. A gesture-id (e.g., 'LEFT_ID' , or even
 * 'NO_ID') or, ; 2. A gesture-id + modifier key combinations (e.g., 'RIGHT_ID' + 'CTRL').
 * <p>
 * Note that the shortcut may be empty: the no-id (NO_ID) and no-modifier-mask
 * (NO_MODIFIER_MASK) combo may also defined a shortcut. Empty shortcuts may bind
 * gesture-less motion interactions (e.g., mouse move without any button pressed).
 */
public final class MotionShortcut extends Shortcut {
  /**
   * Constructs an "empty" shortcut by conveniently calling
   * {@code this(NO_MODIFIER_MASK, NO_ID);}
   */
  public MotionShortcut() {
    super();
  }

  /**
   * Defines a shortcut from the given gesture-id.
   *
   * @param id gesture-id
   */
  public MotionShortcut(int id) {
    super(id);
  }

  /**
   * Defines a shortcut from the given modifier mask and gesture-id combination.
   *
   * @param m  the mask
   * @param id gesture-id
   */
  public MotionShortcut(int m, int id) {
    super(m, id);
  }
}
