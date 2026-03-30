<!--- Actualiza el Estado del Documentos Aplicados --->
<cfif isdefined("form.recuperar") or isdefined("form.btnrecuperar")>
	<cfif isdefined("form.chk")>
		<cfset lista = form.chk>
	<cfelseif isdefined("form.CRDRid")>
		<cfset lista = form.CRDRid>
	<cfelse>
		<cf_errorCode	code = "50132" msg = "No. de Documento no pudo ser determinado. Proceso Cancelado!">
	</cfif>
	
	<cfloop list="#lista#" index="item">
		<cfquery name="rs_consulta" datasource="#session.dsn#">
			select CRDRutilaux 
			from CRDocumentoResponsabilidad 
			where CRDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#item#">
		</cfquery>
		
		<cfif rs_consulta.CRDRutilaux EQ 0 >
			<cfquery name="rs_update" datasource="#session.dsn#">
				update CRDocumentoResponsabilidad
				set CRDRestado = 0,
					BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
				where CRDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#item#">
			</cfquery>
		<cfelse>
			<cf_errorCode	code = "50133" msg = "El documento no puede ser recuperado porque ya fue utilizado en un sistema auxiliar!">
		</cfif>		
	</cfloop>
	
</cfif>

<!--- variable para enviar parámetros por get a la pantalla--->
<cfset params = "">
<!--- envío de la llave --->
<cfif isdefined("form.recuperar")>
	<cfset params = params & iif(len(params),DE("&"),DE("?")) & "CRDRid=#form.CRDRid#">
</cfif>

<cflocation url="documento.cfm#params#">





