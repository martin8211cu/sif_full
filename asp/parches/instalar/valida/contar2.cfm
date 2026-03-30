<cf_templateheader title="Validación del conteo de datos">
<cfinclude template="../mapa.cfm">
<cf_web_portlet_start titulo="Validación del conteo de datos" width="700">

<cfquery datasource="asp" name="APConteo">
	select tabla, datasource, antes, despues
	from APConteo
	where instalacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.instala.instalacion#">
	order by tabla, datasource
</cfquery>

<table width="600" cellpadding="2" cellspacing="0" align="center">

<cfset hay_datos = false>
<cfif  APConteo.RecordCount>
<tr class="tituloListas"><td>Tabla</td><td>Datasource</td>
<td>Registros antes </td>
<td>Después</td>
</tr>
<cfoutput query="APConteo">
	<cfif CurrentRow MOD 2><cfset cls = 'listaNon'><cfelse><cfset cls = 'listaPar'></cfif>
			<tr class="#cls#" style="cursor:default;" onmouseover="this.className='#cls#Sel';" onmouseout="this.className='#cls#';">
			<td> #tabla #</td><td>#datasource# </td>
			<td <cfif Len(despues) and (despues neq antes)> style="border-width:2 0 2 2; border-color:##660000; border-style:solid; background-color:##ffcccc;color:##cc0000" </cfif> align="center"> #antes#&nbsp;</td>
			<td <cfif Len(despues) and (despues neq antes)> style="border-width:2 2 2 0; border-color:##660000; border-style:solid; background-color:##ffcccc;color:##cc0000" </cfif> align="center">#despues#&nbsp;</td>
			</tr>
	<cfif Len(despues) and (despues NEQ 0)>
		<cfset hay_datos = true>
	</cfif>
</cfoutput>
<cfif not hay_datos>
<tr class="tituloListas"><td colspan="4">Sin validar</td></tr>
<tr><td colspan="4">No ha validado el conteo de datos en <a href="../ejecuta/ejecuta.cfm" style="text-decoration:underline">Ejecutar parche</a></td></tr>
</cfif>
<cfelse>
<tr class="tituloListas"><td colspan="4">Sin datos</td></tr>
<tr><td colspan="4">Debe haber realizado el conteo de datos en <a href="../ejecuta/ejecuta.cfm" style="text-decoration:underline">Ejecutar parche</a></td></tr>
</cfif>
</table>

<cf_web_portlet_end><cf_templatefooter>
