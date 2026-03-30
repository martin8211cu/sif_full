<!--SCRIPT GeneracionMenuTop.ssc created on Thu, 07 Feb 2002 14:17:47
    import "~/Menues/ManejaInterfaz.ssc" useContext;
    import "~/Menues/sexecsql.ssc" useContext;
    
    var style = document.value.style; // "horizontal" | "vertical";
    
    if (style != "horizontal" && style != "vertical") {
        style = "vertical";
    }

    var vSQL= " Select MSMpadre,MSMmenu,MSMtexto,MSMlink,MSMhijos, "
            + " ( select max (MSPGcodigo) "
            + "   from MSPaginaGenerada "
            + "   where MSPaginaGenerada.Scodigo = MSMenu.Scodigo "
            + "     and MSPaginaGenerada.Scodigo = " + document.value.Scodigo
            + "     and MSPaginaGenerada.MSPcodigo = MSMenu.MSPcodigo) as MSPGcodigo"
            + " from MSMenu "
            + " where Scodigo = " + document.value.Scodigo 
            + " order by MSMprofundidad desc, MSMpadre, MSMorden"
    
    var rs = EjecutaQuery(vSQL, 0)
    
    var menuPadre='';
    var menuBarType = style == "vertical" ? "WebFXMenu" : "WebFXMenuBar";
    var menuButtonType = style == "vertical" ? "WebFXMenuItem" : "WebFXMenuButton"
    
    document.writeln ("var myBar = new " + menuBarType + ";");
    while (rs.next()) {
        var MSMpadre   = rs.getString("MSMpadre");
        var MSMmenu    = rs.getString("MSMmenu");
        var MSMtexto   = rs.getString("MSMtexto");
        var MSMlink    = rs.getString("MSMlink");
        var MSMhijos   = rs.getInt   ("MSMhijos");
        var MSPGcodigo = rs.getString("MSPGcodigo");
        
        if (MSPGcodigo != null) {
            MSMlink = "p" + MSPGcodigo + ".html";
        } else if (MSMlink == null) {
            MSMlink = "";
        }
        
        
        if (MSMpadre != null) {
            // es un submenu o un item
            if (menuPadre != MSMpadre ){
                // estamos cambiando al siguiente padre
                menuPadre = MSMpadre;
                document.writeln ("myMenu" + menuPadre + " = new WebFXMenu;");
            }
            if (MSMhijos == 0) { // no tiene hijos
                document.writeln ("myMenu" + menuPadre + ".add(new WebFXMenuItem('"
                    + MSMtexto + "' , " + "'" + MSMlink + "'" + "));" );
            } else {
                document.writeln ("myMenu" + menuPadre + ".add(new WebFXMenuItem('"
                    + MSMtexto
                    + "', null, '', myMenu" + MSMmenu + "));");
            }
        } else {
            // boton en barra de menú principal
            if (MSMhijos == 0) {
                document.writeln ("myBar.add(new " + menuButtonType + "('"  + MSMtexto
                    + "', '" + MSMlink + "', ''));");
            } else {
                document.writeln ("myBar.add(new " + menuButtonType + "('"
                    + MSMtexto
                    + "', null, '', myMenu" + MSMmenu + "));");
            }
        }
    }
    
    document.writeln("    document.write(myBar);");
    
    if (style == "vertical") {
        document.writeln("    myBar.show();");
    }

-->