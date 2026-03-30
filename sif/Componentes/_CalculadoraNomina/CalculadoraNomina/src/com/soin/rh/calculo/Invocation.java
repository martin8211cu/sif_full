package com.soin.rh.calculo;

import java.util.*;

public class Invocation {

  public class InvocationException extends Error {
    public InvocationException(String msg) {
      super(msg);
    }
  }

  private String _functionName;
  private Vector _arguments = new Vector();
  public Invocation(String functionName) {
    this._functionName = functionName;
  }

  public void addArgument(Variant value) {
    this._arguments.add(value);
  }

  private void checkArgs(int min, int max, Variant args[], int types[]) throws
      InvocationException {
    if (min == max && args.length != min) {
      throw new InvocationException("Se requiere " + min +
                                    " argumentos para la función " +
                                    _functionName);
    }
    else if (args.length < min || args.length > max) {
      throw new InvocationException("Se requiere de " + min + " a " + max +
                                    " argumentos para la función " +
                                    _functionName);
    }
    if (types != null && args != null) {
      for (int i = 0; i < args.length; i++) {
        if (types.length > i && args[i].type != types[i]) {
          throw new InvocationException("El argumento en la posición " + (i + 1) +
                                        " para la función " + _functionName +
                                        " debe ser de tipo " +
                                        Variant.getTypeName(types[i]));
        }
      }
    }
  }

  public Variant invoke() throws InvocationException {
    if (_functionName == null) {
      throw new InvocationException("Funcion no definida: " + _functionName);
    }
    Variant[] args = (Variant[]) _arguments.toArray(new Variant[0]);
    if (_functionName.equalsIgnoreCase("round")) {
      checkArgs(1, 2, args, new int[] {Variant.TYPE_DOUBLE, Variant.TYPE_DOUBLE});
      if (args.length == 1) {
        return new Variant(Math.round(args[0].dbl));
      }
      else {
        double pow = Math.pow(10,args[1].dbl);
        return new Variant(Math.round(args[0].dbl * pow) / pow);
      }
    }
    else if (_functionName.equalsIgnoreCase("ceiling")) {
      checkArgs(1, 2, args, new int[] {Variant.TYPE_DOUBLE, Variant.TYPE_DOUBLE});
      if (args.length == 1) {
        return new Variant(Math.ceil(args[0].dbl));
      }
      else {
        double pow = Math.pow(10,args[1].dbl);
        return new Variant(Math.ceil(args[0].dbl * pow) / pow);
      }
    }
    else if (_functionName.equalsIgnoreCase("floor")) {
      checkArgs(1, 2, args, new int[] {Variant.TYPE_DOUBLE, Variant.TYPE_DOUBLE});
      if (args.length == 1) {
        return new Variant(Math.floor(args[0].dbl));
      }
      else {
        double pow = Math.pow(10,args[1].dbl);
        return new Variant(Math.floor(args[0].dbl * pow) / pow);
      }
    }
    else if (_functionName.equalsIgnoreCase("max")) {
      checkArgs(1, 100, args, null);
      double ret = args[0].dbl;
      for (int i = 1; i < args.length; i++) {
        if (ret < args[i].dbl) {
          ret = args[i].dbl;
        }
      }
      return new Variant(ret);
    }
    else if (_functionName.equalsIgnoreCase("min")) {
      checkArgs(1, 100, args, null);
      double ret = args[0].dbl;
      for (int i = 1; i < args.length; i++) {
        if (ret > args[i].dbl) {
          ret = args[i].dbl;
        }
      }
      return new Variant(ret);
    }
    else if (_functionName.equalsIgnoreCase("iif")) {
      checkArgs(3, 3, args, new int[] {Variant.TYPE_BOOL});
      return args[0].bool ? args[1] : args[2];
    }
    else if (_functionName.equalsIgnoreCase("getdate")) {
      checkArgs(0, 0, args, null);
      return new Variant(new Date());
    }
    throw new InvocationException("Funcion no definida: " + _functionName);
  }

}