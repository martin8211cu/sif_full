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

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="CMB_Seleccionar"
Default="Seleccionar"
XmlFile="/rh/ExpDeportivo/generales.xml"
returnvariable="CMB_Seleccionar"/>

<cfquery datasource="#Session.DSN#" name="rs">
select * from EDRolesPersonas
</cfquery>

<cfif isdefined('form.EDPid')>
<cfquery datasource="#Session.DSN#" name="rsForm">
select TPid from EquipoDivPersona
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
            function doConlis() {
                       popUpWindow("../catalogo/AgregarTP.cfm?popup=s" ,250,200,650,350);
            }

</script>

<select name="TPid" id="TPid" onFocus="javascript:this.select();">
<option value=""><cfoutput>#CMB_Seleccionar#</cfoutput></option>
<cfloop query ="rs">
	<cfoutput>
		<option value="#rs.TPid#"<cfif Modo eq 'CAMBIO' and rsForm.TPid eq rs.TPid>selected</cfif>>#rs.TPcodigo# - #rs.TPdescripcion#</option>
    </cfoutput>
</cfloop>
</select>
	<img src="/cfmx/rh/imagenes/plus.gif" border="0" align="absmiddle" hspace="5" onclick="javascript:doConlis();">

