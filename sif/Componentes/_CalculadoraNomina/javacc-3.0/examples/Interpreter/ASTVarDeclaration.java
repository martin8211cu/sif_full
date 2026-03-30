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




public class ASTVarDeclaration extends SimpleNode
                               implements SPLParserConstants {

  int type;
  String name;

  ASTVarDeclaration(int id) {
    super(id);
  }


  public void interpret()
  {
     if (type == BOOL)
        symtab.put(name, new Boolean(false));
     else
        symtab.put(name, new Integer(0));
  }
}
