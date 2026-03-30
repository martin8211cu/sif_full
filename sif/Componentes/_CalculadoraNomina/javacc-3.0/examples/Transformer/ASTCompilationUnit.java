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

public class ASTCompilationUnit extends SimpleNode {
  ASTCompilationUnit(int id) {
    super(id);
  }


// Manually inserted code begins here

  public void process (PrintWriter ostr) {
    Token t = begin;
    ASTSpecialBlock bnode;
    for (int i = 0; i < jjtGetNumChildren(); i++) {
      bnode = (ASTSpecialBlock)jjtGetChild(i);
      do {
        print(t, ostr);
        t = t.next;
      } while (t != bnode.begin);
      bnode.process(ostr);
      t = bnode.end.next;
    }
    while (t != null) {
      print(t, ostr);
      t = t.next;
    }
  }

}
