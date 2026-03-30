<cfif isdefined("url.id_tramite") and not isdefined("form.id_tramite")>
	<cfparam name="form.id_tramite" default="#url.id_tramite#">
</cfif>
<cfif isdefined("url.id_persona") and not isdefined("form.id_persona")>
	<cfparam name="form.id_persona" default="#url.id_persona#">
</cfif>

<cfif not isdefined("form.id_tramite")>
<cfthrow message="Error. No se ha definido el tramite.">
</cfif>
<cfif not isdefined("form.id_persona")>
<cfthrow message="Error. No se ha definido la persona.">
</cfif>

<cf_template>
<cf_templatearea name=title>Tr&aacute;mite</cf_templatearea>
<cf_templatearea name=body>
<cfinclude template="/home/menu/pNavegacion.cfm">

<cf_web_portlet_start titulo="Iniciar Trámite" >
	<table width="700" align="center" cellpadding="0" cellspacing="0">
		<tr><td><cfinclude template="hdr_persona.cfm"></td></tr>
		<tr><td><cfinclude template="hdr_tramite.cfm"></td></tr>
	</table>
	<form name="form1" method="post" action="nvo_tramite-sql.cfm">
		<cfoutput>
		<input type="hidden" name="id_tramite" value="#form.id_tramite#">
		<input type="hidden" name="id_persona" value="#form.id_persona#">
		</cfoutput>
	
		<cfquery name="reqdata" datasource="#session.tramites.dsn#">
			select rt.numero_paso, r.codigo_requisito, r.nombre_requisito 
			from TPRReqTramite rt
			
			inner join TPRequisito r
			on r.id_requisito=rt.id_requisito
			
			where rt.id_tramite=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_tramite#">
			order by 1
		</cfquery>
	
		<table width="700" align="center" border="0" cellpadding="2" cellspacing="0">
			<tr>
				<td colspan="2" class="subTitulo">Requisitos</td>
			</tr>
	
			<cfoutput query="reqdata">
			<tr>
				<td width="1%" align="right">#reqdata.numero_paso#.</td>
				<td width="99%" >#reqdata.nombre_requisito#</td>
			</tr>
			</cfoutput>
	
			<tr><td>&nbsp;</td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td align="right"><input type="submit" name="Iniciar" value="Iniciar Tr&aacute;mite"></td></tr>
		</table>
	</form>

<cf_web_portlet_end>
</cf_templatearea>
</cf_template>