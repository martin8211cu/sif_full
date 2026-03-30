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




public class ASTWriteStatement extends SimpleNode {
  String name;

  ASTWriteStatement(int id) {
    super(id);
  }


  public void interpret()
  {
     Object o;
     byte[] b = new byte[64];

     if ((o = symtab.get(name)) == null)
        System.err.println("Undefined variable : " + name);

     System.out.println("Value of " + name + " : " + symtab.get(name));
  }

}
