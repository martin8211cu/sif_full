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




public class ASTOrNode extends SimpleNode {
  ASTOrNode(int id) {
    super(id);
  }


  public void interpret()
  {
     jjtGetChild(0).interpret();

     if (((Boolean)stack[top]).booleanValue())
     {
        stack[top] = new Boolean(true);
        return;
     }

     jjtGetChild(1).interpret();
     stack[--top] = new Boolean(((Boolean)stack[top]).booleanValue() ||
                                ((Boolean)stack[top + 1]).booleanValue());
  }

}
