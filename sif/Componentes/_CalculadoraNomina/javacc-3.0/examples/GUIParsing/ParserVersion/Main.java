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

public class Main {

  public static void main(String[] args) {
    new CalcGUI();
    TokenManager tm = new TokenCollector();
    CalcInputParser cp = new CalcInputParser(tm);
    while (true) {
      try {
        cp.Input();
      } catch (ParseException e) {
        CalcGUI.print("ERROR (click 0)");
      }
    }
  }

}
