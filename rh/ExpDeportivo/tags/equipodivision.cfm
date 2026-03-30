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
select a.Edescripcion, b.EDvid, c.TEdescripcion 
from EquipoDivision b
inner join Equipo a on
b.EDid = a.EDid
inner join DivisionEquipo c on
b.TEid = c.TEid

</cfquery>

<script>            
	        var popUpWin=0;
            function popUpWindow(URLStr, left, top, width, height){
              if(popUpWin) {
                       if(!popUpWin.closed) popUpWin.close();
              }
              popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
            }
            function doConlis4() {
                       popUpWindow("../catalogo/AgregarED.cfm?popup=s" ,250,200,650,350);
            }

</script>	
<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="CMB_Seleccionar"
Default="Seleccionar"
XmlFile="/rh/ExpDeportivo/generales.xml"
returnvariable="CMB_Seleccionar"/>	
	
	<select name="EDvid" id="EDvid" onFocus="javascript:this.select();">
		<option value=""><cfoutput>#CMB_Seleccionar#</cfoutput></option>
<cfloop query ="rs">
	<cfoutput>
	 <option value="#rs.EDvid#"<cfif Modo eq 'CAMBIO' and form.EDvid eq rs.EDvid>selected</cfif>>#rs.TEdescripcion# - #rs.Edescripcion#</option> 
    </cfoutput>
</cfloop>
</select>

<img src="/cfmx/rh/imagenes/plus.gif" border="0" align="absmiddle" hspace="2" onclick="javascript:doConlis4();">