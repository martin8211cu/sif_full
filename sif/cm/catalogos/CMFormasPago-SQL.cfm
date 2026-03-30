<cfset modo = "ALTA">
<cfif not isdefined("Form.Nuevo")>

	<cfif isdefined("Form.Alta") or isdefined("Form.Cambio")>
		<cfquery name="rs" datasource="#session.DSN#">
			select 1 
			from CMFormasPago 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and CMFPcodigo = <cfqueryparam value="#trim(Form.CMFPcodigo)#" cfsqltype="cf_sql_char">
		</cfquery>
		<cfif rs.RecordCount gt 0>
			<cfif isdefined("Form.Alta")>
				<cf_errorCode	code = "50247" msg = "El registro que desea agregar ya existe.">
			<cfelseif CompareNoCase(trim(form._CMFPcodigo),trim(form.CMFPcodigo)) NEQ 0>
				<cf_errorCode	code = "50247" msg = "El registro que desea agregar ya existe.">
			</cfif>
		</cfif>	
	</cfif>

	<cfif isdefined("Form.Alta")>
		<cfquery name="insert" datasource="#Session.DSN#">
			insert into CMFormasPago( Ecodigo , CMFPcodigo,  CMFPdescripcion ,CMFPplazo ,Usucodigo  ,fechaalta  )
				values ( <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">,
						 <cfqueryparam value="#trim(Form.CMFPcodigo)#" cfsqltype="cf_sql_char">,
						 <cfqueryparam value="#Form.CMFPdescripcion#" cfsqltype="cf_sql_varchar">,
						 <cfqueryparam value="#Form.CMFPplazo#" cfsqltype="cf_sql_integer">,
						 <cfqueryparam value="#Session.Usucodigo#" cfsqltype="cf_sql_numeric">,
						 <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp"> )
		</cfquery>
		<cfset modo="ALTA">
	
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="delete" datasource="#Session.DSN#">
			delete from CMFormasPago
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and CMFPcodigo = <cfqueryparam value="#trim(Form._CMFPcodigo)#" cfsqltype="cf_sql_char">
		</cfquery>  
		<cfset modo="ALTA">

	<cfelseif isdefined("Form.Cambio")>
		<cf_dbtimestamp datasource="#session.dsn#"
			 			table="CMFormasPago"
			 			redirect="CMFormasPago.cfm"
			 			timestamp="#form.ts_rversion#"				
						field1="Ecodigo" 
						type1="integer" 
						value1="#session.Ecodigo#"
						field2="CMFPcodigo" 
						type2="char" 
						value2="#trim(form._CMFPcodigo)#">

		<cfquery name="update" datasource="#Session.DSN#">
			update CMFormasPago 
			set CMFPcodigo = <cfif CompareNoCase(trim(form._CMFPcodigo),trim(form.CMFPcodigo)) NEQ 0><cfqueryparam value="#form.CMFPcodigo#" cfsqltype="cf_sql_char"><cfelse><cfqueryparam value="#form._CMFPcodigo#" cfsqltype="cf_sql_char"></cfif>,
				CMFPdescripcion = <cfqueryparam value="#Form.CMFPdescripcion#" cfsqltype="cf_sql_varchar">,
				CMFPplazo = <cfqueryparam value="#Form.CMFPplazo#" cfsqltype="cf_sql_integer">
			where Ecodigo  = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and CMFPcodigo = <cfqueryparam value="#trim(Form._CMFPcodigo)#" cfsqltype="cf_sql_char">
		</cfquery> 
		<cfset modo="CAMBIO">
	</cfif>
</cfif>

<cfoutput>
<form action="CMFormasPago.cfm" method="post" name="sql">
	<cfif isdefined("form.Cambio")>
		<input name="CMFPcodigo" type="hidden" value="#Form.CMFPcodigo#">
	</cfif>
</form>
</cfoutput>	

<HTML><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></HTML>

