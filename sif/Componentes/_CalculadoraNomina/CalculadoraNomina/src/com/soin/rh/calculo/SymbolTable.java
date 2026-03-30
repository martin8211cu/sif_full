package com.soin.rh.calculo;

import java.util.*;

public class SymbolTable {
  public SymbolTable() {
  }

  public Variant get(String name) throws ParseException {
    Variant value = (Variant) values.get(name.toLowerCase());
    if (value == null) {
      throw new ParseException("No se ha definido la variable '" + name + "'");
    }
    return value;
  }

  public void put(String name, Variant value) throws ParseException {
    if (name == null || name.length() == 0) {
      throw new ParseException("No se indicó el nombre de la variable");
    }
    values.put(name.toLowerCase(), value);
  }

  public boolean isDefined(String name) {
    return values.containsKey(name.toLowerCase());
  }

  public Set getKeySet() {
    values.values();
    return values.keySet();
  }

  public Map getKeyMap() {
    return values;
  }

  private Map values = new TreeMap();

}
