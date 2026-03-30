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


/**
 * A subclass of CalcInputTokenManager so that we can do better error reporting
 * via the GUI object.
 */
class MyLexer extends CalcInputParserTokenManager {

   /**
    * We redefined the lexical error reporting function so that it beeps
    * and displays a messgae thru the GUI.
    */
   protected void LexicalError() {
     CalcGUI.Error("ERROR (click 0)");
     ReInit(gui.getCollector(), OPERAND);
     result = 0.0;
   }

   public MyLexer(CalcGUI guiObj)
   {
      super(guiObj.getCollector(), OPERAND);
      gui = guiObj;
   }
}
