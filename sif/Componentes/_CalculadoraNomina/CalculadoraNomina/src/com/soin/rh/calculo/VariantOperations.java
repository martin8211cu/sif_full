package com.soin.rh.calculo;

import java.util.Date;

public class VariantOperations {
  private VariantOperations() {
  }

  public static Variant add(Variant x, Variant y) throws ParseException {
    if (x.type == x.TYPE_DOUBLE && y.type == y.TYPE_DOUBLE) {
      return new Variant(x.dbl + y.dbl);
    }
    else if (x.type == x.TYPE_DATE && y.type == y.TYPE_DOUBLE) {
      long time = x.date.getTime() + (long) (y.dbl * 86400000d);
      return new Variant(new Date(time));
    }
    throw new ParseException("La suma no es una operacion válida para " + x +
                             " y " + y);
  };

  public static Variant subtract(Variant x, Variant y) throws ParseException {
    if (x.type == x.TYPE_DOUBLE && y.type == y.TYPE_DOUBLE) {
      return new Variant(x.dbl - y.dbl);
    }
    else if (x.type == x.TYPE_DATE && y.type == y.TYPE_DOUBLE) {
      long time = x.date.getTime() - (long) (y.dbl * 86400000d);
      return new Variant(new Date(time));
    }
    else if (x.type == x.TYPE_DATE && y.type == y.TYPE_DATE) {
      long time = (x.date.getTime() - y.date.getTime ()) / 86400000L;
      return new Variant((double)time);
    }
    throw new ParseException("La resta no es una operacion válida para " + x +
                             " y " + y);
  };

  public static Variant negate(Variant x) throws ParseException {
    if (x.type == x.TYPE_DOUBLE) {
      return new Variant( -x.dbl);
    }
    throw new ParseException("La negación no es una operacion válida para " + x);
  };

  public static Variant multiply(Variant x, Variant y) throws ParseException {
    if (x.type == x.TYPE_DOUBLE && y.type == y.TYPE_DOUBLE) {
      return new Variant(x.dbl * y.dbl);
    }
    throw new ParseException(
        "La multiplicación no es una operacion válida para " + x + " y " + y);
  };

  public static Variant divide(Variant x, Variant y) throws ParseException {
    if (x.type == x.TYPE_DOUBLE && y.type == y.TYPE_DOUBLE) {
      return new Variant(y.dbl == 0d ? 0d : x.dbl / y.dbl);
    }
    throw new ParseException("La division no es una operacion válida para " + x +
                             " y " + y);
  };

  public static Variant modulus(Variant x, Variant y) throws ParseException {
    if (x.type == x.TYPE_DOUBLE && y.type == y.TYPE_DOUBLE) {
      return new Variant(y.dbl == 0d ? 0d : x.dbl % y.dbl);
    }
    throw new ParseException("El módulo no es una operacion válida para " + x +
                             " y " + y);
  };

  public static Variant or(Variant x, Variant y) throws ParseException {
    if (x.type == x.TYPE_BOOL && y.type == y.TYPE_BOOL) {
      return new Variant(x.bool || y.bool);
    }
    throw new ParseException("La operacion '|' no es válida para " + x + " y " +
                             y);
  };

  public static Variant and(Variant x, Variant y) throws ParseException {
    if (x.type == x.TYPE_BOOL && y.type == y.TYPE_BOOL) {
      return new Variant(x.bool && y.bool);
    }
    throw new ParseException("La operacion '&' no es válida para " + x + " y " +
                             y);
  };

  public static Variant lt(Variant x, Variant y) throws ParseException {
    if (x.type == x.TYPE_DOUBLE && y.type == y.TYPE_DOUBLE) {
      return new Variant(x.dbl < y.dbl);
    }
    else if (x.type == x.TYPE_DATE && y.type == y.TYPE_DATE) {
      return new Variant(x.date.before(y.date));
    }
    throw new ParseException("La operacion '<' no es válida para " + x + " y " +
                             y);
  };

  public static Variant le(Variant x, Variant y) throws ParseException {
    if (x.type == x.TYPE_DOUBLE && y.type == y.TYPE_DOUBLE) {
      return new Variant(x.dbl <= y.dbl);
    }
    else if (x.type == x.TYPE_DATE && y.type == y.TYPE_DATE) {
      return new Variant(!x.date.after(y.date));
    }
    throw new ParseException("La operacion '<=' no es válida para " + x + " y " +
                             y);
  };

  public static Variant gt(Variant x, Variant y) throws ParseException {
    if (x.type == x.TYPE_DOUBLE && y.type == y.TYPE_DOUBLE) {
      return new Variant(x.dbl > y.dbl);
    }
    else if (x.type == x.TYPE_DATE && y.type == y.TYPE_DATE) {
      return new Variant(x.date.after(y.date));
    }
    throw new ParseException("La operacion '>' no es válida para " + x + " y " +
                             y);
  };

  public static Variant ge(Variant x, Variant y) throws ParseException {
    if (x.type == x.TYPE_DOUBLE && y.type == y.TYPE_DOUBLE) {
      return new Variant(x.dbl >= y.dbl);
    }
    else if (x.type == x.TYPE_DATE && y.type == y.TYPE_DATE) {
      return new Variant(!x.date.before(y.date));
    }
    throw new ParseException("La operacion '>=' no es válida para " + x + " y " +
                             y);
  };

  public static Variant negateBoolean(Variant x) throws ParseException {
    if (x.type == x.TYPE_BOOL) {
      return new Variant(!x.bool);
    }
    throw new ParseException("La operacion '!' no es válida para " + x);
  }

  public static Variant equals(Variant x, Variant y) throws ParseException {
    return new Variant(x.equals(y));
  }

  public static Variant notequals(Variant x, Variant y) throws ParseException {
    return new Variant(!x.equals(y));
  }

}