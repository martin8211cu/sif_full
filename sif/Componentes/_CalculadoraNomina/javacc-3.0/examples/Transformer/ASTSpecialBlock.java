/*
 *                 Sun Public License Notice
 * 
 * The contents of this file are subject to the Sun Public License
 * Version 1.0 (the "License"). You may not use this file except in
 * compliance with the License. A copy of the License is available at
 * http://www.sun.com/
 * 
 * The Original Code is JavaCC. The Initial Developer of the Original
 * Code is Sun Microsystems, Inc. Portions Copyright 1996-2002 Sun
 * Microsystems, Inc. All Rights Reserved.
 */

/* JJT: 0.2.2 */

import java.io.*;

public class ASTSpecialBlock extends SimpleNode {
  ASTSpecialBlock(int id) {
    super(id);
  }


// Manually inserted code begins here

  public void process (PrintWriter ostr) {
    Token t = begin; // t corresponds to the "{" of the special block.
    t.image = "{ try {";
    while (t != end) {
      print(t, ostr);
      t = t.next;
    }
    // t now corresponds to the last "}" of the special block.
    t.image = "} }";
    print(t, ostr);
  }

}
