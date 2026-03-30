<cfquery name="rsAlmacen" datasource="#Session.DSN#">
	select convert(varchar,Aid) as Aid, Bdescripcion, Bdireccion
	from Almacen
	where Aid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">
</cfquery>

<cfoutput>
<table width="100%" border="0" cellspacing="6" cellpadding="6">
  <tr> 
	<td colspan="2" align="center" class="#Session.Preferences.Skin#_thcenter">Informaci&oacute;n del Almacén</td>
  </tr>
  <tr> 
	<td width="33%" class="fileLabel">Nombre del Almacén</td>
	<td width="67%">#rsAlmacen.Bdescripcion#</td>
  </tr>
  <tr> 
	<td class="fileLabel">Dirección del Almacén</td>
	<td>#rsAlmacen.Bdireccion#</td>
  </tr>
</table>
</cfoutput>