<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="CMB_Seleccionar"
Default="Seleccionar"
XmlFile="/rh/ExpDeportivo/generales.xml"
returnvariable="CMB_Seleccionar"/>

<cfquery datasource="#Session.DSN#" name="rs">
select * from EDTiposPersona
</cfquery>

<script>            
	        var popUpWin=0;
            function popUpWindow(URLStr, left, top, width, height){
              if(popUpWin) {
                       if(!popUpWin.closed) popUpWin.close();
              }
              popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
            }
            function doConlis() {
                       popUpWindow("../catalogo/AgregarTP.cfm?popup=s" ,250,200,650,350);
            }

</script>

<select name="TiposPersona" id="TiposPersona">
<option value=""><cfoutput>#CMB_Seleccionar#</cfoutput></option>
<cfloop query ="rs">
	<cfoutput>
		<option value="#rs.TPid#">#rs.TPcodigo# - #rs.TPdescripcion#</option>
    </cfoutput>
</cfloop>
</select>
	<img src="/cfmx/rh/imagenes/plus.gif" border="0" align="middle" hspace="2" onclick="javascript:doConlis();">

