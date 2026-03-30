<cfset id_vista = "">
<cfif Len(inst.id_vista)>
	<!--- verificar que la vista corresponde al tipo del documento --->
	<cfset id_vista = inst.id_vista>
	<cfquery datasource="#session.tramites.dsn#" name="ver_si_la_vista_vale">
		select v.id_tipo, dc.id_tipo as ss
		from TPRequisito rq
			join TPDocumento dc
				on dc.id_documento = rq.id_documento
			join DDVista v
				on v.id_vista = rq.id_vista
		where rq.id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_requisito#">
		  and v.id_vista = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_vista#">
		  <!--- esto es una validacion, no es parte del join --->
		  and v.id_tipo = dc.id_tipo
	</cfquery>
	<cfif ver_si_la_vista_vale.RecordCount EQ 0>
		<cfset id_vista = "">
	</cfif>
</cfif>
<cfif len(id_vista) EQ 0>
	<cftransaction>
	<cfquery datasource="#session.tramites.dsn#" name="insvista">
		insert into DDVista	(
			id_tipo, nombre_vista, titulo_vista, 
			BMUsucodigo, BMfechamod, vigente_hasta, vigente_desde)
		select
			id_tipo, ' REG-' || codigo_documento, 'Registrar ' || nombre_documento,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(6100,1,1)#">
		from TPDocumento
		where id_documento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#inst.id_documento#">
		<cf_dbidentity1 name="insvista" datasource="#session.tramites.dsn#">
	</cfquery>
	<cf_dbidentity2 name="insvista" datasource="#session.tramites.dsn#">
	<cfset id_vista = insvista.identity>
	<cfquery datasource="#session.tramites.dsn#">
		update TPRequisito
		set id_vista = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_vista#">
		where id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_requisito#">
	</cfquery>
	</cftransaction>
</cfif>

<cfset widthLeftIframe = "950">
<cfquery name="req" datasource="#session.tramites.dsn#">
	select es_conexion
	  from TPRequisito r
		inner join WSServicio s
			inner join WSMetodo m
				 on m.id_servicio = s.id_servicio
				and m.activo = 1
			 on s.id_documento = r.id_documento
	 where r.id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_requisito#">
</cfquery>
<cfif req.es_conexion EQ 1>
	<cfset widthLeftIframe = "550">
</cfif>


<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td valign="top" width="1%">
			<iframe width="#widthLeftIframe#" height="1000" src="vista/vistaDetalle_form2.cfm?id_vista=#URLEncodedFormat(id_vista)#&amp;es_requisito=1" frameborder="0">
			</iframe>
		</td>
		<cfif req.es_conexion EQ 1>
		<td valign="top">
			<iframe width="100%" height="1000" src="wsservicio.cfm?id_documento=#inst.id_documento#&id_requisito=#form.id_requisito#" frameborder="0">
			</iframe>
		</td>
		</cfif>
	  </tr>
	</table>
</cfoutput>
