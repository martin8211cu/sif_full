<cfif isdefined("form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<cfquery datasource="#Session.DSN#" name="rs">
select * from DivisionEquipo
</cfquery>

<script>            
	        var popUpWin=0;
            function popUpWindow(URLStr, left, top, width, height){
              if(popUpWin) {
                       if(!popUpWin.closed) popUpWin.close();
              }
              popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
            }
            function doConlis5() {
                       popUpWindow("../catalogo/AgregarDE.cfm?popup=s" ,250,200,650,350);
            }

</script>	
<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="CMB_Seleccionar"
Default="Seleccionar"
XmlFile="/rh/ExpDeportivo/generales.xml"
returnvariable="CMB_Seleccionar"/>	
	
	<select name="TEid" id="TEid">
		<option value=""><cfoutput>#CMB_Seleccionar#</cfoutput></option>
<cfloop query ="rs">
	<cfoutput>
	 <option value="#rs.TEid#">#rs.TEcodigo# - #rs.TEdescripcion#</option> 
    </cfoutput>
</cfloop>
</select>

<img src="/cfmx/rh/imagenes/plus.gif" border="0" align="absmiddle" hspace="2" onclick="javascript:doConlis5();">