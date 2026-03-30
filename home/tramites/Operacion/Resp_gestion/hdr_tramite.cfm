
<cfif isdefined("url.id_tramite") and not isdefined("form.id_tramite")>
	<cfparam name="form.id_tramite" default="#url.id_tramite#">
</cfif>

<cfquery name="trdata" datasource="#session.tramites.dsn#">
	select id_tramite, codigo_tramite, nombre_tramite
	from TPTramite
	where id_tramite = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tramite#">
</cfquery>

<cfoutput>
<table width="100%" border="0">
<tr><td class="subTitulo" colspan="2">&nbsp;</td></tr>
<tr><td class="subTitulo" colspan="2">Datos del Trámite</td></tr>
  <tr>
    <td width="1%"><strong>Tr&aacute;mite:&nbsp;</strong></td>
    <td width="80%">#trim(trdata.codigo_tramite)# - #trim(trdata.nombre_tramite)#</td>
  </tr>
  <tr>
    <td width="1%" nowrap><strong>Fecha Solicitud:&nbsp;</strong></td>
    <td>#LSDateFormat(now(),'dd/mm/yyyy')#</td>
  </tr>
</table>
</cfoutput>