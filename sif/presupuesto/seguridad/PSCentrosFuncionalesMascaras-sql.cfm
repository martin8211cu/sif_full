<cfparam name="Action" default="PSCentrosFuncionales.cfm"/>
<cfparam name="Form.CFpk" type="numeric">
<cfif isdefined("Form.txtCPSMascaraP") and right(Form.txtCPSMascaraP,1) NEQ "%">
	<cfset Form.txtCPSMascaraP = Form.txtCPSMascaraP & "%">
</cfif>
<cfif isdefined("form.btnAddMascaras")>
	<cfquery datasource="#session.dsn#">
		insert into CPSeguridadMascarasCtasP 
		(Ecodigo, CFid, CPSMascaraP, CPSMdescripcion, CPSMconsultar, CPSMtraslados, CPSMreservas, CPSMformulacion, BMUsucodigo)
		values(
			#Session.Ecodigo#, 
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFpk#">, 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.txtCPSMascaraP#">, 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.txtCPSMdescripcion#">, 
			<cfif isdefined("Form.CPSMconsultar")>1<cfelse>0</cfif>, 
			<cfif isdefined("Form.CPSMtraslados")>1<cfelse>0</cfif>, 
			<cfif isdefined("Form.CPSMreservas")>1<cfelse>0</cfif>, 
			<cfif isdefined("Form.CPSMformulacion")>1<cfelse>0</cfif>, 
			#session.usucodigo# 
		)
	</cfquery>
<cfelseif isdefined("form.btnUpdMascaras")>
	<cf_dbtimestamp 
		datasource = "#session.dsn#"
		table = "CPSeguridadMascarasCtasP"
		redirect = "#Action#"
		timestamp = "#form.ts_rversion#"
		field1 = "Ecodigo"
		type1 = "integer"
		value1 = "#Session.Ecodigo#"
		field2 = "CFid"
		type2 = "numeric"
		value2 = "#form.CFpk#"
		field3 = "CPSMid"
		type3 = "numeric"
		value3 = "#form.CPSMid#">
	<cfquery datasource="#session.dsn#">
		update CPSeguridadMascarasCtasP
		set CPSMascaraP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.txtCPSMascaraP#">, 
			CPSMdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.txtCPSMdescripcion#">, 
			CPSMconsultar = <cfif isdefined("Form.CPSMconsultar")>1<cfelse>0</cfif>, 
			CPSMtraslados = <cfif isdefined("Form.CPSMtraslados")>1<cfelse>0</cfif>, 
			CPSMreservas = <cfif isdefined("Form.CPSMreservas")>1<cfelse>0</cfif>, 
			CPSMformulacion = <cfif isdefined("Form.CPSMformulacion")>1<cfelse>0</cfif>
		where Ecodigo = #Session.Ecodigo#
		and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFpk#">
		and CPSMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPSMid#">
	</cfquery>
<cfelseif isdefined("form.CPSMdelete") and isNumeric(form.CPSMdelete) and form.CPSMdelete GT 0>
	<cfquery datasource="#session.dsn#">
		delete from CPSeguridadMascarasCtasP
		where Ecodigo = #Session.Ecodigo#
		and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFpk#">
		and CPSMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CPSMdelete#">
	</cfquery>
</cfif>
<cflocation url="#Action#?CFpk=#Form.CFpk#">