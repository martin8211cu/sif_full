<cf_templateheader title="SIF - Producción">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Registro Produccion'>
    <cfinclude template="../../../sif/portlets/pNavegacion.cfm">

<cfif isdefined('url.OT')>
	<cfset Form.OTcodigo = #url.OT#>
<!---    <cfdump var="Entre a url.OT">
    <cfdump var="#url.OT#">  --->  
</cfif>

<cfif isdefined('Form.OT')>
	<cfset Form.OTcodigo = #Form.OT#>
<!---    <cfdump var="Entre a Form.OT">
    <cfdump var="#Form.OT#"> --->
</cfif>

<!--- <cf_dump var="#Form#">  --->

<!---El query que trae los datos---->
<cfset ValuesArrayOT=ArrayNew(1)>
<cfquery name="rsProdOTDatos" datasource="#Session.DSN#">
   	select OTcodigo, OTdescripcion
    from Prod_OT
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
<cfif isdefined("form.OTcodigo") AND Len(Trim(form.OTcodigo)) GT 0>
		and OTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.OTcodigo#">
</cfif>order by OTcodigo
</cfquery>
<cfif rsProdOTDatos.recordcount gt 0>
    <cfset ArrayAppend(valuesArrayOT,'#rsProdOTDatos.OTcodigo#')>
    <cfset ArrayAppend(valuesArrayOT,'#rsProdOTDatos.OTdescripcion#')>
</cfif>

<cfoutput>

<form action="BuscaOTprod.cfm" method="post" name="form">
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
    	<tr> 
			<td><strong>Orden de Trabajo :</strong></td>
            <td>
             <cf_conlis
					Campos="OTcodigo,OTdescripcion"
					Desplegables="S,S"
					Modificables="S,S"
					Size="15,50"
					ValuesArray="#ValuesArrayOT#"
					Title="Orden de Trabajo"
					Tabla="Prod_OT"
                    Form = "form"
					Columnas="OTcodigo,OTdescripcion"
					Filtro="Prod_OT.Ecodigo = #Session.Ecodigo# order by OTcodigo"
					Desplegar="OTcodigo,OTdescripcion"
					Etiquetas="Codigo,Descripcion"
					filtrar_por="OTcodigo,OTdescripcion"
					Formatos="S,S"
					Align="left,left"
					Asignar="OTcodigo,OTdescripcion"
					Asignarformatos="S,S"
					tabindex="1" />
            </td>
			<td align="left" colspan="3">  
            	<input type="submit" name="Buscar" value="Ver Registro de Produccion">
          	</td>
        </tr>
	</table>           
</form>
</cfoutput>

<cfif isdefined('Form.OTcodigo')>
	<cfinclude template="RegistroProduccion.cfm">
</cfif>

	<cf_web_portlet_end>	
<cf_templatefooter>