
<cfif isdefined("url.id_tramite") and not isdefined("form.id_tramite")>
	<cfparam name="form.id_tramite" default="#url.id_tramite#">
</cfif>

<cfif isdefined('url.id_persona') and not isdefined('form.id_persona')>
	<cfparam name="form.id_persona" default="#url.id_persona#">
</cfif>

<cfquery name="trdata" datasource="#session.tramites.dsn#">
	select codigo_tramite, nombre_tramite, nombre_inst, descripcion_tramite, nombre_tipotramite
	from TPTramite t 
	
	left outer join TPInstitucion i
	  on t.id_inst = i.id_inst
	
	left outer join TPTipoTramite tt
	  on t.id_tipotramite = tt.id_tipotramite
	
	where id_tramite = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tramite#">
</cfquery>

<cfoutput>
<table width="260" cellpadding="0" cellspacing="0" border="0">
	<tr><td colspan="2" bgcolor="##ECE9D8" style="padding:3px; border-bottom:1px solid black; border-top:1px solid black; "><strong>Datos del Trámite</strong></td></tr>
	<cfif LEN(TRIM(trdata.descripcion_tramite))>
	<tr>
		<td colspan="2">#trdata.descripcion_tramite#</td>
	</tr>
	</cfif>
	<tr>
		<td><strong>Instituci&oacute;n:</strong>&nbsp;</td>
	  <td>#trdata.nombre_inst#</td>
	</tr>
	<tr>
		<td><strong>Tipo de Tr&aacute;mite:</strong>&nbsp;</td>
		<td>#trdata.nombre_tipotramite#</td>
	</tr>

</table>
</cfoutput>