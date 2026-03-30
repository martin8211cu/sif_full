<cfparam name="Action" default="PSUsuarios.cfm"/>
<cfparam name="Form.Usucodigo" type="numeric">

<cfif isdefined("form.btnAddUsuarios") or isdefined("form.btnAddUsuariosC")>
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select count(1) as cantidad
		  from CPSeguridadUsuario
		 where Ecodigo	= #Session.Ecodigo#
		   and CFid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFpk#">
		   and Usucodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Usucodigo#">
	</cfquery>
	<cfif rsSQL.cantidad GT 0>
		<cf_errorCode	code = "50541" msg = "Ya existe el registro">
	</cfif>
	<cftransaction>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			insert into CPSeguridadUsuario 
			(Ecodigo, CFid, Usucodigo, CPSUconsultar, CPSUtraslados, CPSUreservas, CPSUformulacion, CPSUaprobacion, BMUsucodigo)
			values(
				#Session.Ecodigo#, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFpk#">, 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Usucodigo#">, 
				<cfif isdefined("Form.CPSUconsultar")>1<cfelse>0</cfif>, 
				<cfif isdefined("Form.CPSUtraslados")>1<cfelse>0</cfif>, 
				<cfif isdefined("Form.CPSUreservas")>1<cfelse>0</cfif>, 
				<cfif isdefined("Form.CPSUformulacion")>1<cfelse>0</cfif>, 
				<cfif isdefined("Form.CPSUaprobacion")>1<cfelse>0</cfif>, 
				#Session.Usucodigo#
			)
			<cf_dbidentity1>
		</cfquery>
		<cf_dbidentity2 name="rsSQL">
	</cftransaction>
	<cfset LvarID = rsSQL.identity>
<cfelseif isdefined("form.btnUpdUsuarios") or isdefined("form.btnUpdUsuariosC")>
	<cf_dbtimestamp 
		datasource = "#session.dsn#"
		table = "CPSeguridadUsuario"
		redirect = "#Action#"
		timestamp = "#form.ts_rversion#"
		field1 = "Ecodigo"
		type1 = "integer"
		value1 = "#Session.Ecodigo#"
		field2 = "Usucodigo"
		type2 = "numeric"
		value2 = "#form.Usucodigo#"
		field3 = "CPSUid"
		type3 = "numeric"
		value3 = "#form.CPSUid#">
	<cfquery datasource="#session.dsn#">
		update CPSeguridadUsuario
		set CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFpk#">, 
			CPSUconsultar = <cfif isdefined("Form.CPSUconsultar")>1<cfelse>0</cfif>, 
			CPSUtraslados = <cfif isdefined("Form.CPSUtraslados")>1<cfelse>0</cfif>, 
			CPSUreservas = <cfif isdefined("Form.CPSUreservas")>1<cfelse>0</cfif>, 
			CPSUformulacion = <cfif isdefined("Form.CPSUformulacion")>1<cfelse>0</cfif>,
			CPSUaprobacion = <cfif isdefined("Form.CPSUaprobacion")>1<cfelse>0</cfif>
		where Ecodigo = #Session.Ecodigo#
		and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Usucodigo#">
		and CPSUid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPSUid#">
	</cfquery>
	<cfset LvarID = Form.CPSUid>
<cfelseif isdefined("form.CPSUdelete") and isNumeric(form.CPSUdelete) and form.CPSUdelete GT 0>
	<cfquery datasource="#session.dsn#">
		delete from CPSeguridadUsuario
		where CPSUidOrigen = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPSUdelete#">
	</cfquery>
	<cfquery datasource="#session.dsn#">
		delete from CPSeguridadUsuario
		where Ecodigo = #Session.Ecodigo#
		  and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Usucodigo#">
		  and CPSUid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPSUdelete#">
	</cfquery>
</cfif>

<cfif isdefined("form.btnUpdUsuariosC")>
	<cfquery datasource="#session.dsn#">
		update CPSeguridadUsuario
		set CPSUconsultar = <cfif isdefined("Form.CPSUconsultar")>1<cfelse>0</cfif>, 
			CPSUtraslados = <cfif isdefined("Form.CPSUtraslados")>1<cfelse>0</cfif>, 
			CPSUreservas = <cfif isdefined("Form.CPSUreservas")>1<cfelse>0</cfif>, 
			CPSUformulacion = <cfif isdefined("Form.CPSUformulacion")>1<cfelse>0</cfif>,
			CPSUaprobacion = <cfif isdefined("Form.CPSUaprobacion")>1<cfelse>0</cfif>
		where Ecodigo = #Session.Ecodigo#
		  and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Usucodigo#">
 		  and CPSUidOrigen = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPSUid#">
	</cfquery>
</cfif>

<cfif isdefined("form.btnAddUsuariosC") or isdefined("form.btnUpdUsuariosC")>
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select CFpath
		  from CFuncional
		 where Ecodigo	= #Session.Ecodigo#
		   and CFid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFpk#">
	</cfquery>
	<cfquery datasource="#session.dsn#">
		insert into CPSeguridadUsuario 
			  (Ecodigo, CFid, Usucodigo, CPSUconsultar, CPSUtraslados, CPSUreservas, CPSUformulacion, CPSUaprobacion, BMUsucodigo, CPSUidOrigen)
		select distinct s1.Ecodigo, f.CFid, s1.Usucodigo, s1.CPSUconsultar, s1.CPSUtraslados, s1.CPSUreservas, s1.CPSUformulacion, s1.CPSUaprobacion, s1.BMUsucodigo, s1.CPSUid
		  from CPSeguridadUsuario s1
		  	inner join CFuncional f
				 on f.CFid <> s1.CFid
				and f.Ecodigo = s1.Ecodigo
				<!--- and substring(f.CFpath,1,#len(trim(rsSQL.CFpath))#) = '#trim(rsSQL.CFpath)#' --->
                and <cf_dbfunction name='sPart' args='f.CFpath,1,#len(trim(rsSQL.CFpath))#'> = '#trim(rsSQL.CFpath)#'
		 where s1.Ecodigo = #Session.Ecodigo#
		   and s1.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Usucodigo#">
		   and s1.CPSUid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarID#">
		   and not exists
		   		(
					select 1
					  from CPSeguridadUsuario s2
					 where s2.Ecodigo 	= s1.Ecodigo
					   and s2.Usucodigo	= s1.Usucodigo
					   and s2.CFid		= f.CFid
				)
	</cfquery>
<cfelseif isdefined("form.btnExpUsuarios")>
	<!--- Copiar seguridad de centros funcionales al usuario --->
	<cfif isdefined("form.copiarSF")>
		<cfquery name="rsCPUUsuariosT" datasource="#Session.dsn#">
			select coalesce(a.CPSUidOrigen,null), a.CPSUid, a.Ecodigo, a.CFid as CFpk, a.Usucodigo, a.CPSUconsultar, a.CPSUtraslados, a.CPSUreservas, a.CPSUformulacion, a.CPSUaprobacion, a.CPSUidOrigen, 
				   b.CFcodigo, b.CFdescripcion
			from CPSeguridadUsuario a inner join CFuncional b on a.CFid = b.CFid and a.Ecodigo = b.Ecodigo
			where a.Ecodigo = #Session.Ecodigo#
			and a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Usucodigo#">
			order by a.Usucodigo
		</cfquery>
		<cfloop query="rsCPUUsuariosT">
			<cfquery name="rsCPUUsuariosS" datasource="#Session.dsn#">
				select CPSUid
				from CPSeguridadUsuario 
				where Ecodigo = #Session.Ecodigo#
				and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.UsucodigoE#">
				and CFid = #CFpk#
			</cfquery>	
			<cfif rsCPUUsuariosS.recordcount eq 0>
				<cfquery name="rsInCPUUsuarios" datasource="#Session.dsn#">
					insert into CPSeguridadUsuario 
					(Ecodigo,CFid,Usucodigo,
					CPSUconsultar,CPSUtraslados,CPSUreservas, 
					CPSUformulacion,CPSUaprobacion,CPSUidOrigen)
					values 
					(#rsCPUUsuariosT.Ecodigo#,#rsCPUUsuariosT.CFpk#,#form.UsucodigoE#,
					#rsCPUUsuariosT.CPSUconsultar#,#rsCPUUsuariosT.CPSUtraslados#,#rsCPUUsuariosT.CPSUreservas#,
					#rsCPUUsuariosT.CPSUformulacion#,#rsCPUUsuariosT.CPSUaprobacion#,<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCPUUsuariosT.CPSUidOrigen#" null="#Len(trim(rsCPUUsuariosT.CPSUidOrigen)) EQ 0#">)
				</cfquery>
			</cfif>
		</cfloop>
	</cfif>
	<!--- Copiar seguridad de cuentas (mascaras) --->
	<cfif isdefined("form.copiarSC")>
		<cfquery  datasource="#Session.dsn#">
			insert into CPSeguridadMascarasCtasP 
			(Ecodigo, Usucodigo, CPSMascaraP, CPSMdescripcion, CPSMconsultar, CPSMtraslados, CPSMreservas, CPSMformulacion, BMUsucodigo)
			
			select #Session.Ecodigo#, 
				#Form.UsucodigoE#, 
				CPSMascaraP, 
				CPSMdescripcion, 
				CPSMconsultar, 
				CPSMtraslados, 
				CPSMreservas, 
				CPSMformulacion,
				#session.usucodigo# 		
			from CPSeguridadMascarasCtasP
			where Ecodigo = #Session.Ecodigo#
				and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Usucodigo#">
		</cfquery>
	</cfif>
	
</cfif>

<cflocation url="#Action#?Usucodigo=#Form.Usucodigo#">

