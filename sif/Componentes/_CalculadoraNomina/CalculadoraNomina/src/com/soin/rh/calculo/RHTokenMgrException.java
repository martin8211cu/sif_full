package com.soin.rh.calculo;

import java.io.*;

/**
 * <p>Title: </p>
 * <p>Description: </p>
 * <p>Copyright: Copyright (c) 2002</p>
 * <p>Company: </p>
 * @author unascribed
 * @version 1.0
 */

public class RHTokenMgrException
    extends Exception {

  private String innerStackTrace = null;

  public RHTokenMgrException(Error inner) {
    this(inner.getMessage(), inner);
  }

  private RHTokenMgrException(String s, Throwable inner) {
    super(s);
    StringWriter w = new StringWriter();
    inner.printStackTrace(new PrintWriter(w));
    innerStackTrace = w.toString();
  }

  public void printStackTrace(PrintStream s) {
    super.printStackTrace(s);
    if (innerStackTrace != null) {
      s.println("Inner exception: " + innerStackTrace);
    }
  }

  public void printStackTrace(PrintWriter s) {
    super.printStackTrace(s);
    if (innerStackTrace != null) {
      s.println("Inner exception: " + innerStackTrace);
    }
  }

  public void printStackTrace() {
    super.printStackTrace();
    if (innerStackTrace != null) {
      System.out.println("Inner exception: " + innerStackTrace);
    }
  }

}
