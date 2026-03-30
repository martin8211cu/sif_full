<cfset modo = "ALTA">
<cfif not isdefined("Form.Nuevo")>

	<cfif isdefined("Form.Alta") or isdefined("Form.Cambio")>
		<cfquery name="rs" datasource="#session.DSN#">
			select 1 
			from CMIncoterm 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and CMIcodigo = <cfqueryparam value="#trim(Form.CMIcodigo)#" cfsqltype="cf_sql_char">
		</cfquery>
		<cfif rs.RecordCount gt 0>
			<cfif isdefined("Form.Alta")>
				<cf_errorCode	code = "50247" msg = "El registro que desea agregar ya existe.">
			<cfelseif CompareNoCase(trim(form.CMIcodigo),trim(form.CMIcodigo)) NEQ 0>
				<cf_errorCode	code = "50247" msg = "El registro que desea agregar ya existe.">
			</cfif>
		</cfif>	
	</cfif>

	<cfif isdefined("Form.Alta")>
		<cfquery name="insert" datasource="#Session.DSN#">
			insert into CMIncoterm( Ecodigo ,CMIcodigo ,CMIdescripcion ,CMIpeso  ,Usucodigo ,fechaalta   )
				values ( <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">,
						 <cfqueryparam value="#trim(Form.CMIcodigo)#" cfsqltype="cf_sql_char">,
						 <cfqueryparam value="#Form.CMIdescripcion#" cfsqltype="cf_sql_varchar">,
						 <cfqueryparam value="#Form.CMIpeso#" cfsqltype="cf_sql_integer">,
						 <cfqueryparam value="#Session.Usucodigo#" cfsqltype="cf_sql_numeric">,
						 <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp"> )
		</cfquery>
		<cfset modo="ALTA">
	
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="delete" datasource="#Session.DSN#">
			delete from CMIncoterm
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and CMIid = <cfqueryparam value="#Form.CMIid#" cfsqltype="cf_sql_numeric">			  
		</cfquery>  
		<cfset modo="ALTA">

	<cfelseif isdefined("Form.Cambio")>
		<cf_dbtimestamp datasource="#session.dsn#"
			 			table="CMIncoterm"
			 			redirect="CMIncoterm.cfm"
			 			timestamp="#form.ts_rversion#"				
						field1="Ecodigo" 
						type1="integer" 
						value1="#session.Ecodigo#"
						field2="CMIcodigo" 
						type2="char" 
						value2="#trim(form.CMIcodigo)#"
						field3="CMIid" 
						type3="numeric" 
						value3="#form.CMIid#">

		<cfquery name="update" datasource="#Session.DSN#">
			update CMIncoterm 
			set CMIcodigo = <cfqueryparam value="#form.CMIcodigo#" cfsqltype="cf_sql_char">,
				CMIdescripcion = <cfqueryparam value="#Form.CMIdescripcion#" cfsqltype="cf_sql_varchar">,
				CMIpeso = <cfqueryparam value="#Form.CMIpeso#" cfsqltype="cf_sql_integer">
			where Ecodigo  = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		   	  and CMIid = <cfqueryparam value="#Form.CMIid#" cfsqltype="cf_sql_numeric">	
		</cfquery> 
		<cfset modo="CAMBIO">
	</cfif>
</cfif>

<cfoutput>
<form action="CMIncoterm.cfm" method="post" name="sql">
	<cfif isdefined("form.Cambio")>
		<input name="CMIcodigo" type="hidden" value="#Form.CMIcodigo#">
		<input name="CMIid" type="hidden" value="#Form.CMIid#">
	</cfif>
</form>
</cfoutput>	

<HTML><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></HTML>

