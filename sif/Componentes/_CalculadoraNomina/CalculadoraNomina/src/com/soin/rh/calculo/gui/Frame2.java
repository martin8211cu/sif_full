package com.soin.rh.calculo.gui;

import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
import com.borland.jbcl.layout.*;

import com.soin.rh.calculo.*;
import java.util.*;
import java.io.*;

public class Frame2 extends JFrame {
  JPanel contentPane;
  PaneLayout paneLayout1 = new PaneLayout();
  JButton enter = new JButton();
  JTextArea history = new JTextArea();
  JTextArea symbols = new JTextArea();
  JTextPane input = new JTextPane();
  JLabel filler = new JLabel();

  //Construct the frame
  public Frame2() {
    enableEvents(AWTEvent.WINDOW_EVENT_MASK);
    try {
      jbInit();
    }
    catch(Exception e) {
      e.printStackTrace();
    }
  }
  //Component initialization
  private void jbInit() throws Exception  {
    contentPane = (JPanel) this.getContentPane();
    contentPane.setLayout(paneLayout1);
    this.setSize(new Dimension(520, 362));
    this.setTitle("Frame Title");
    enter.setBorder(BorderFactory.createEtchedBorder());
    enter.setToolTipText("");
    enter.setMnemonic(10);
    enter.setText("Exec");
    enter.addActionListener(new Frame2_enter_actionAdapter(this));
    history.setBorder(BorderFactory.createEtchedBorder());
    history.setText("");
    symbols.setBorder(BorderFactory.createEtchedBorder());
    input.setBorder(BorderFactory.createEtchedBorder());
    input.setToolTipText("");
    input.setText("dias = 30; salario = round ( 4421.32 , - 2 ); extras = min ( 6 , " +
    "8 ); bruto = dias * salario + salario / 8 * 1.5 * extras; hoy = getdate " +
    "( ); inicio = #18/7/2003#; dias = hoy - inicio; ");
    filler.setText("");
    contentPane.add(history, new PaneConstraints("jTextArea1", "jTextArea1", PaneConstraints.ROOT, 0.5f));
    contentPane.add(symbols, new PaneConstraints("jTextArea2", "jTextArea1", PaneConstraints.RIGHT, 0.28666663f));
    contentPane.add(input, new PaneConstraints("jTextPane1", "jTextArea1", PaneConstraints.BOTTOM, 0.45580113f));
    contentPane.add(filler, new PaneConstraints("jLabel1", "jTextPane1", PaneConstraints.BOTTOM, 0.18124998f));
    contentPane.add(enter, new PaneConstraints("jButton1", "jLabel1", PaneConstraints.RIGHT, 0.20810813f));
  }
  //Overridden so we can exit when window is closed
  protected void processWindowEvent(WindowEvent e) {
    super.processWindowEvent(e);
    if (e.getID() == WindowEvent.WINDOW_CLOSING) {
      System.exit(0);
    }
  }


private SymbolTable symtable = new SymbolTable();

  void enter_actionPerformed(ActionEvent e) {
    try {
      String text = input.getText().trim();
      Reader reader = new StringReader(text);
      Calculator parser = new Calculator(reader);
      parser.setSymbolTable(symtable);
      parser.parse();
      /*
      Variant ret = null;
      for(;;){
        Variant m = parser.parseOneLine();
        if (m==null) break;
        ret = m;
      }*/
      history.setText(history.getText()+"\r\n"+text/* + "\t" + ret*/);
      {
        String symContents = "";
        for (Iterator keys = symtable.getKeySet().iterator();keys.hasNext();) {
          String key = (String)keys.next();
          symContents += key + "=" + symtable.get(key)+"\r\n";
        }
        symbols.setText(symContents);
      }
      input.setText(parser.token_source.formatted());
    } catch (ParseException ex){
      history.setText(history.getText() + "\r\n" + ex.getMessage());
      ex.printStackTrace();
    } catch (Throwable ex){
      history.setText(history.getText() + "\r\n" + ex.getMessage());
      ex.printStackTrace();
    }
  }
}

class Frame2_enter_actionAdapter implements java.awt.event.ActionListener {
  Frame2 adaptee;

  Frame2_enter_actionAdapter(Frame2 adaptee) {
    this.adaptee = adaptee;
  }
  public void actionPerformed(ActionEvent e) {
    adaptee.enter_actionPerformed(e);
  }
}