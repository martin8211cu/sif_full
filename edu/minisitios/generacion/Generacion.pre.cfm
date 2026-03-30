<!--SCRIPT GeneracionABC.ssc created on Tue, 05 Feb 2002 17:41:57
/*  */
    function opcion(href, id, imgsrc, texto)
    {
        document.writeln("<td align='center' style='border:solid white' id='opc" + id + "'><a class='organizador' "
            + " href='" + href + "'>"
            + "<img border='0' src='" 
            + raizImages + "/Minisitios/" + imgsrc 
            + "' /><br/>" + texto + "</a></td>");
    }
    
    function seleccionSitio()
    {
        var g = new GUI();
        g.startForm("Opciones de generaci&oacute;n del sitio",
            tableAttrib=undefined,
            validar="validaGenSitio",
            action=pgSQL,
            formName="frmSitio",
            formAttrib=undefined);
        g.field(g.checkboxField("sobreescribir", "1", true) + " Sobreescribir páginas existentes");
        g.field(g.checkboxField("ver", "1", true) + " Visualizar el nuevo sitio");
        g.hiddenField("Scodigo", document.value.Scodigo);
        g.buttons("btnGenSitio", "Generar");
        g.endForm();
    }
    
    function seleccionPaginas()
    {
        var g = new GUI();
        g.startForm("Opciones de generaci&oacute;n de p&aacute;ginas",
            tableAttrib=undefined,
            validar="validaGenPaginas",
            action=pgSQL,
            formName="frmPaginas",
            formAttrib=undefined);
        var rs = EjecutaQuery
            ( " select MSPcodigo, MSPtitulo"
            + " from MSPagina"
            + " where Scodigo = " + document.value.Scodigo, 0);
        while (rs.next()) {
            g.field(g.checkboxField("pagina", rs.getString(1), true) + " " + rs.getString(2));
        }
        g.field(g.checkboxField("ver", "1", true) + " Visualizar el nuevo sitio");
        g.hiddenField("Scodigo", document.value.Scodigo);
        g.buttons("btnGenPaginas", "Generar");
        g.endForm();
    }
    
    function seleccionMenu()
    {
        var g = new GUI();
        g.startForm("Opciones de generaci&oacute;n del men&uacute;",
            tableAttrib=undefined,
            validar="validaGenMenu",
            action=pgSQL,
            formName="frmMenu",
            formAttrib=undefined);
        g.field(g.checkboxField("sobreescribir", "1", true) + " Sobreescribir páginas existentes");
        g.field(g.checkboxField("ver", "1", true) + " Visualizar el nuevo sitio");
        g.hiddenField("Scodigo", document.value.Scodigo);
        g.buttons("btnGenMenu", "Generar");
        g.endForm();
    }
    
    function seleccionVer()
    {
        var g = new GUI();
        g.startForm("Opciones de visualizaci&oacute;n del sitio",
            tableAttrib=undefined,
            validar="validaGenVer",
            action=pgSQL,
            formName="frmVer",
            formAttrib=undefined);
        g.field(g.checkboxField("newframe", "1", true) + " Abrir en ventana nueva");
        g.hiddenField("Scodigo", document.value.Scodigo);
        g.buttons("btnGenVer", "Abrir");
        g.endForm();
    }


    function Plantilla()
    {
        document.writeln("<table width='100%'><tr>");
        
        opcion('javascript:setOpt("gensitio")',   "gensitio",   "gensitio.gif",   "Generar sitio");
        opcion('javascript:setOpt("genpaginas")', "genpaginas", "genpaginas.gif", "Generar páginas");
        opcion('javascript:setOpt("genmenu")',    "genmenu",    "genmenu.gif",    "Generar el menú");
        opcion('javascript:setOpt("genver")',     "genver",     "genver.gif",     "Visualizar el sitio");
        document.writeln("</tr>");
        document.writeln("<tr><td colspan='4'>");
        function startSel(id) {
            return "<div id='" + id + "' style='display:none'>";
        }
        function endSel(id) {
            return "</div>";
        }
        document.writeln(startSel("gensitio"));
        seleccionSitio();
        document.writeln(endSel("gensitio"));
        document.writeln(startSel("genpaginas"));
        seleccionPaginas();
        document.writeln(endSel("genpaginas"));
        document.writeln(startSel("genmenu"));
        seleccionMenu();
        document.writeln(endSel("genmenu"));
        document.writeln(startSel("genver"));
        seleccionVer();
        document.writeln(endSel("genver"));
        
        document.writeln("</td></tr>");
        document.writeln("</table>");
    }
    
    function Lista() {
    }
    
    import "diseno.mantenimiento.ssc" useContext;
    
    
    
-->