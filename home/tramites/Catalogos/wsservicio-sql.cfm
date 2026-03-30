<cfif isdefined("Form.Alta")>
	<cfquery name="chkExists" datasource="#session.tramites.dsn#">
		select 1
		from TPRequisitoWSMetodo
		where id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_requisito#">
		and id_metodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_metodo#">
	</cfquery>
</cfif>

<cfif isdefined("Form.Alta") and not (isdefined("chkExists") and chkExists.recordCount)>
	<cfquery name="nextReg" datasource="#session.tramites.dsn#">
		select coalesce(max(secuencia), 0) + 10 as next
		from TPRequisitoWSMetodo
		where id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_requisito#">
	</cfquery>
	<cfif Len(Trim(Form.secuencia)) EQ 0>
		<cfset Form.secuencia = nextReg.next>
	</cfif>

	<cfquery name="insReqMetodo" datasource="#session.tramites.dsn#">
		insert into TPRequisitoWSMetodo (id_requisito, id_metodo, secuencia, tipo_proceso, BMUsucodigo, BMfechamod)
		values (
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_requisito#">, 
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_metodo#">, 
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.secuencia#">, 
			<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.tipo_proceso#">, 
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
		)
	</cfquery>

<cfelseif isdefined("Form.id_metodo_del") and Len(Trim(Form.id_metodo_del))>
	<cfif mid(form.id_metodo_del,1,1) EQ "-">
		<cfset LvarIdMetodo = mid(Form.id_metodo_del,2,30)>
		<cfquery name="modReqMetodo" datasource="#session.tramites.dsn#">
			select id_metodo, tipo_proceso, secuencia
			  from TPRequisitoWSMetodo
			where id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_requisito#">
			and id_metodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarIdMetodo#">
		</cfquery>
		<cfset LvarModificarMetodo = "&MODMET=1&IDM=#modReqMetodo.id_metodo#&TP=#modReqMetodo.tipo_proceso#&S=#modReqMetodo.secuencia#">
	<cfelse>
		<cfset LvarIdMetodo = Form.id_metodo_del>
	</cfif>
	<cfquery name="delReqMetodo" datasource="#session.tramites.dsn#">
		delete TPRequisitoWSMetodo
		where id_requisito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_requisito#">
		and id_metodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarIdMetodo#">
	</cfquery>
</cfif>

<cfparam name="LvarModificarMetodo" default="">
<cflocation url="wsservicio.cfm?id_documento=#Form.id_documento#&id_requisito=#Form.id_requisito##LvarModificarMetodo#">