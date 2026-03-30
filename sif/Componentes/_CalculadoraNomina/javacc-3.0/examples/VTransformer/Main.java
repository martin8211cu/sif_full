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

import java.io.*;

public class Main
{
  public static void main(String args[]) {
    System.err.println("Reading from standard input...");
    JavaParser p = new JavaParser(System.in);
    try {
      ASTCompilationUnit cu = p.CompilationUnit();
      JavaParserVisitor visitor = new AddAcceptVisitor(System.out);
      cu.jjtAccept(visitor, null);
      System.err.println("Thank you.");
    } catch (Exception e) {
      System.err.println("Oops.");
      System.err.println(e.getMessage());
      e.printStackTrace();
    }
  }
}
