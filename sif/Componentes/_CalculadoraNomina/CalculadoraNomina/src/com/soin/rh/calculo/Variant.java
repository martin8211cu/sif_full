package com.soin.rh.calculo;

import java.util.*;
import java.text.*;

public class Variant {

  /**
   * Construye un variant de un tipo determinado pero sin valor
   * @param type
   */
  private Variant(int type) {
    this.type = type;
  }

  /**
   * Construye un variant de tipo fecha
   * @param date
   */
  public Variant(Date date) {
    this(TYPE_DATE);
    this.date = date;
  }

  /**
   * Construye un variant numérico
   * @param number
   */
  public Variant(double number) {
    this(TYPE_DOUBLE);
    this.dbl = number;
  }

  /**
   * Construye un variant booleano
   * @param bool
   */
  public Variant(boolean bool) {
    this(TYPE_BOOL);
    this.bool = bool;
  }

  /**
   * Construye un variant de tipo fecha usando el formato en dateParser
   * @param value
   * @return
   * @throws ParseException
   */
  public static Variant parseDate(String value) throws ParseException {
    Variant v = new Variant(TYPE_DATE);
    try {
      v.date = dateParser.parse(value);
      return v;
    }
    catch (java.text.ParseException ex) {
      throw new ParseException("Fecha inválida: " + value);
    }
  }

  public static Variant parseBoolean(String value) throws ParseException {
    Variant v = new Variant(TYPE_BOOL);
    v.bool = new Boolean(value).booleanValue();
    return v;
  }

  public static Variant parseDouble(String value) throws ParseException {
    Variant v = new Variant(TYPE_DOUBLE);
    v.dbl = Double.parseDouble(value);
    return v;
  }

  public String toString() {
    switch (type) {
      case TYPE_VOID:
        return "void";
      case TYPE_BOOL:
        return new Boolean(bool).toString();
      case TYPE_DATE:
        return dateParser.format(date);
      case TYPE_DOUBLE:
        return "" + dbl;
    }
    return super.toString();
  }

  public static String getTypeName(int type) {
    switch (type) {
      case TYPE_VOID:
        return "void";
      case TYPE_BOOL:
        return "booleano";
      case TYPE_DATE:
        return "fecha";
      case TYPE_DOUBLE:
        return "numerico";
      default:
        return "(tipo" + type + ")";
    }
  }

  public boolean equals(Variant x) {
    return toString().equals(x.toString());
  }

  public int hashCode() {
    return toString().hashCode();
  }

  public int type;
  public boolean bool;
  public Date date;
  public double dbl;

  public final static Variant VOID = null;
  public final static Variant ZERO = new Variant(0d);

  public final static int TYPE_VOID = 0;
  public final static int TYPE_BOOL = 1;
  public final static int TYPE_DATE = 2;
  public final static int TYPE_DOUBLE = 3;

  public final static SimpleDateFormat dateParser = new SimpleDateFormat(
      "#dd/MM/yyyy#");

}