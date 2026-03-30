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


class SPL {

  public static void main(String args[]) {
    SPLParser parser;
    if (args.length == 1) {
      System.out.println("Stupid Programming Language Interpreter Version 0.1:  Reading from file " + args[0] + " . . .");
      try {
        parser = new SPLParser(new java.io.FileInputStream(args[0]));
      } catch (java.io.FileNotFoundException e) {
        System.out.println("Stupid Programming Language Interpreter Version 0.1:  File " + args[0] + " not found.");
        return;
      }
    } else {
      System.out.println("Stupid Programming Language Interpreter Version 0.1:  Usage :");
      System.out.println("         java SPL inputfile");
      return;
    }
    try {
      parser.CompilationUnit();
      parser.jjtree.rootNode().interpret();
    } catch (ParseException e) {
      System.out.println("Stupid Programming Language Interpreter Version 0.1:  Encountered errors during parse.");
      e.printStackTrace();
    } catch (Exception e1) {
      System.out.println("Stupid Programming Language Interpreter Version 0.1:  Encountered errors during interpretation/tree building.");
      e1.printStackTrace();
    }
  }
}
