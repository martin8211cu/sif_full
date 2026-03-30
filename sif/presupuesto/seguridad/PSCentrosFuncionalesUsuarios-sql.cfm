<cfparam name="Action" default="PSCentrosFuncionales.cfm"/>
<cfparam name="Form.CFpk" type="numeric">
<cfif isdefined("form.btnAddUsuarios")>
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select count(1) as cantidad
		  from CPSeguridadUsuario 
		 where Ecodigo 	= #Session.Ecodigo#
		   and CFid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFpk#">
		   and Usucodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Usucodigo#">
	</cfquery>
	<cfif rsSQL.cantidad EQ 0>
		<cfquery datasource="#session.dsn#">
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
		</cfquery>
	</cfif>
<cfelseif isdefined("form.btnUpdUsuarios")>
	<cf_dbtimestamp 
		datasource = "#session.dsn#"
		table = "CPSeguridadUsuario"
		redirect = "#Action#"
		timestamp = "#form.ts_rversion#"
		field1 = "Ecodigo"
		type1 = "integer"
		value1 = "#Session.Ecodigo#"
		field2 = "CFid"
		type2 = "numeric"
		value2 = "#form.CFpk#"
		field3 = "CPSUid"
		type3 = "numeric"
		value3 = "#form.CPSUid#">
	<cfquery datasource="#session.dsn#">
		update CPSeguridadUsuario
		set Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Usucodigo#">, 
			CPSUconsultar = <cfif isdefined("Form.CPSUconsultar")>1<cfelse>0</cfif>, 
			CPSUtraslados = <cfif isdefined("Form.CPSUtraslados")>1<cfelse>0</cfif>, 
			CPSUreservas = <cfif isdefined("Form.CPSUreservas")>1<cfelse>0</cfif>, 
			CPSUformulacion = <cfif isdefined("Form.CPSUformulacion")>1<cfelse>0</cfif>,
			CPSUaprobacion = <cfif isdefined("Form.CPSUaprobacion")>1<cfelse>0</cfif>
		where Ecodigo = #Session.Ecodigo#
		and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFpk#">
		and CPSUid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPSUid#">
	</cfquery>
<cfelseif isdefined("form.CPSUdelete") and isNumeric(form.CPSUdelete) and form.CPSUdelete GT 0>
	<cfquery datasource="#session.dsn#">
		delete from CPSeguridadUsuario
		where Ecodigo = #Session.Ecodigo#
		and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFpk#">
		and CPSUid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPSUdelete#">
	</cfquery>
</cfif>
<cflocation url="#Action#?CFpk=#Form.CFpk#">