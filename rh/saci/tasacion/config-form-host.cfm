<cfif not IsDefined('included')>
<html><head></head><body>
</cfif>
<cfif Len(url.hostname)>
	<cfquery datasource="#session.dsn#" name="ISBtasarConfig">
		select c.hostname, c.procesos, c.maxFilas, c.httpHost, c.httpPort, c.ts_rversion
		from ISBtasarConfig c
		where c.hostname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.hostname#">
		AT ISOLATION READ UNCOMMITTED
	</cfquery>
<cfelse>
	<cfquery datasource="#session.dsn#" name="ISBtasarConfig">
		select '' as hostname, 3 as procesos, 100 as maxFilas, '' as httpHost, 80 as httpPort, null as ts_rversion
	</cfquery>
</cfif>

<div id="contenedor">
<cf_web_portlet_start titulo="Configuración del servidor" tipo="mini" width="380" >
	
<cfoutput>
<form id="host_form" name="host_form" target="proceso" method="post" onSubmit="return validar_host(this);">
<cfif Len(url.hostname)>
	<input type="hidden" name="action" value="updatehost"/>
	<cfset ts = "">
	<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
			artimestamp="#ISBtasarConfig.ts_rversion#" returnvariable="ts">
	</cfinvoke>
	<input type="hidden" name="ts_rversion" value="#ts#">
<cfelse>
<input type="hidden" name="action" value="inserthost"/>
</cfif>
<table width="380" border="0" cellspacing="0" cellpadding="2">
<tr>
<td>Hostname</td>
<td>
<cfif Len(url.hostname)>
<input type="hidden" name="hostname" value="#HTMLEditFormat(Trim(ISBtasarConfig.hostname))#" />
#HTMLEditFormat(ISBtasarConfig.hostname)#
<cfelse>
<input type="text" name="hostname" value="#HTMLEditFormat(Trim(ISBtasarConfig.hostname))#" />
</cfif>
</td>
</tr>
<tr>
<td>Procesos</td>
<td><input type="text" name="procesos" value="#HTMLEditFormat(ISBtasarConfig.procesos)#"  /></td>
</tr>
<tr>
<td>Filas por proceso </td>
<td><input type="text"id="maxFilas" name="maxFilas" value="#HTMLEditFormat(ISBtasarConfig.maxFilas)#"  /></td>
</tr>
<tr>
<td>HTTP host </td>
<td><input type="text" name="httpHost" value="#HTMLEditFormat(Trim(ISBtasarConfig.httpHost))#"  /></td>
</tr>
<tr>
<td>HTTP port </td>
<td><input type="text" name="httpPort" value="#HTMLEditFormat(ISBtasarConfig.httpPort)#"  /></td>
</tr>
<tr>
<td><input name="btnGuardar" type="submit" id="btnGuardar" value="Guardar" class="btnGuardar" /></td>
<td>&nbsp;</td>
</tr>
</table>

</form>
</cfoutput>
<cf_web_portlet_end> 
</div>
<cfif not IsDefined('included')>
<script type="text/javascript">
	window.parent.cp(window.parent.o(document, 'contenedor'));
</script>
</body></html>
</cfif>