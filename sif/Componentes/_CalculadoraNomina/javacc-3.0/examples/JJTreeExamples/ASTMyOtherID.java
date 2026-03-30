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

public class ASTMyOtherID extends SimpleNode {
  private String name;

  ASTMyOtherID(int id) {
    super(id);
  }

  /** Accept the visitor. **/
  public Object jjtAccept(eg4Visitor visitor, Object data) {
    return visitor.visit(this, data);
  }

  public void setName(String n) {
    name = n;
  }

  public String toString() {
    return "Identifier: " + name;
  }

}
