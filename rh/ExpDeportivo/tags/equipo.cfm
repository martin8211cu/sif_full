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
select * from Equipo
</cfquery>
<cfif isdefined('form.EDPid')>
<cfquery datasource="#Session.DSN#" name="rsForm">
select Ecodigo from EquipoDivPersona
where EDPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EDPid#">
</cfquery>

</cfif>
<script>            
	        var popUpWin=0;
            function popUpWindow(URLStr, left, top, width, height){
              if(popUpWin) {
                       if(!popUpWin.closed) popUpWin.close();
              }
              popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
            }
            function doConlis3() {
                       popUpWindow("../catalogo/AgregarE.cfm?popup=s" ,250,200,650,350);
            }

</script>	
<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="CMB_Seleccionar"
Default="Seleccionar"
XmlFile="/rh/ExpDeportivo/generales.xml"
returnvariable="CMB_Seleccionar"/>	
	
	<select name="Ecodigo" id="Ecodigo" onFocus="javascript:this.select();">
		<option value=""><cfoutput>#CMB_Seleccionar#</cfoutput></option>
<cfloop query ="rs">
	<cfoutput>
	 <option value="#rs.EDid#"<cfif Modo eq 'CAMBIO' and isdefined('rsForm.Ecodigo') and rsForm.Ecodigo eq rs.EDid>selected</cfif>>#rs.Ecodigo# - #rs.Edescripcion#</option> 
    </cfoutput>
</cfloop>
</select>

<img src="/cfmx/rh/imagenes/plus.gif" border="0" align="absmiddle" hspace="2" onclick="javascript:doConlis3();">