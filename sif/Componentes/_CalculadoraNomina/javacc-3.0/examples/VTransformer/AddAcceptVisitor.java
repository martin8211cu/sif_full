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

package VTransformer;

import java.io.PrintStream;

public class AddAcceptVisitor extends UnparseVisitor
{

  public AddAcceptVisitor(PrintStream o)
  {
    super(o);
  }


  public Object visit(ASTClassBodyDeclaration node, Object data)
  {
    /* Are we the first child of our parent? */
    if (node == node.jjtGetParent().jjtGetChild(0)) {

      /** Attempt to make the new code match the indentation of the
          node. */
      StringBuffer pre = new StringBuffer("");
      for (int i = 1; i < node.getFirstToken().beginColumn; ++i) {
	pre.append(" ");
      }

      out.println(pre + "");
      out.println(pre + "/** Accept the visitor. **/");
      out.println(pre + "public Object jjtAccept(JavaParserVisitor visitor, Object data) {");
      out.println(pre + "  return visitor.visit(this, data);");
      out.println(pre + "}");
    }
    return super.visit(node, data);
  }

}
