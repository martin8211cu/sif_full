<!---
	solamente para invocarse desde el tag cfsifimportar
--->


<cfoutput>
	<form action="/cfmx/sif/importar/exportSeatsAccounts-action.cfm" target="_blank" name="#Attributes.form#">
	<cfloop index="i" from="1" to="#ArrayLen(ThisTag.parameters)#">
		<input type="hidden" name="#ThisTag.parameters[i].name#"
			value="#HTMLEditFormat( ThisTag.parameters[i].value )#">
	</cfloop>
	
	<cfquery name="rsCodigoEmpresa" datasource="#session.DSN#">
	select Enumero
	from Empresa
	where Ereferencia =<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>		
	<cfset codigo=#rsCodigoEmpresa.Enumero#>	
	<input type="hidden" name="codigo" id="codigo" value="#codigo#" />
	
	<cfquery name="rsTipoNomina" datasource="#session.DSN#">
	select Tcodigo
	from CalendarioPagos
	where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">
	and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>
	<cfset Tcodigo=#rsTipoNomina.Tcodigo#>
	<input type="hidden" name="Tcodigo" id="Tcodigo" value="#Tcodigo#" />
	
	<cfquery name="rsFechaRige" datasource="#session.DSN#">
	select CPdesde
	from CalendarioPagos
	where CPid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">
	and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>
	
	<cfset CPdesde=#rsFechaRige.CPdesde#>
	<input type="hidden" name="CPdesde" id="CPdesde" value="#CPdesde#" />
	
	<table width="100%%" border="0" cellspacing="0" cellpadding="2">
<tr>
	<td colspan="2">#formatos.EIdescripcion# </td>
	</tr>
<tr>
	<td>&nbsp;</td>
	<td>&nbsp;</td>
	</tr>
<tr>
	<td><input type="checkbox" name="html" id="html" value="1">
		<label for="html"><cf_translate key="LB_Generar_HTML">Generar HTML</cf_translate></label></td>
	<td>&nbsp;</td>
</tr>

<tr>
	<td><input type="checkbox" name="encabezar" id="encabezar" value="1">
		<label for="encabezar"><cf_translate key="LB_Generar_linea_de_encabezados" XmlFile="/sif/generales.xml">Generar l&iacute;nea de encabezados</cf_translate></label></td>
	<td>&nbsp;</td>
</tr>
<tr align="center">
	<td colspan="2"><input type="hidden" name="fmt" value="#formatos.EIid#">
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="BTN_Generar"
			XmlFile="/sif/generales.xml"
			Default="Generar"
			returnvariable="BTN_Generar"/>
		<input name="g" type="submit" value="#BTN_Generar#"></td>
	</tr>
</table>
	</form>
</cfoutput>
