<cfset modo = "ALTA">
<cfif not isdefined("Form.Nuevo")>

	<cfif isdefined("Form.Alta") or isdefined("Form.Cambio")>
		<cfquery name="rs" datasource="#session.DSN#">
			select 1 
			from TipoDocumentoR 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and TDRcodigo = <cfqueryparam value="#trim(Form.TDRcodigo)#" cfsqltype="cf_sql_char">
		</cfquery>
		<cfif rs.RecordCount gt 0>
			<cfif isdefined("Form.Alta")>
				<cf_errorCode	code = "50247" msg = "El registro que desea agregar ya existe.">
			<cfelseif CompareNoCase(trim(form._TDRcodigo),trim(form.TDRcodigo)) NEQ 0>
				<cf_errorCode	code = "50247" msg = "El registro que desea agregar ya existe.">
			</cfif>
		</cfif>	
	</cfif>

	<cfif isdefined("Form.Alta")>
		<cfquery name="insert" datasource="#Session.DSN#">
			insert into TipoDocumentoR( Ecodigo, TDRcodigo, TDRdescripcion, TDRtipo, TDRgeneranc ,Usucodigo, fechaalta, Usucodigomod, fechamod)
				values ( <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">,
						 <cfqueryparam value="#trim(Form.TDRcodigo)#" cfsqltype="cf_sql_char">,
						 <cfqueryparam value="#Form.TDRdescripcion#" cfsqltype="cf_sql_varchar">,
						 <cfqueryparam value="#Form.TDRtipo#" cfsqltype="cf_sql_char">,
						 <cfif isdefined("form.TDRgeneranc")>1<cfelse>0</cfif>,
						 <cfqueryparam value="#Session.Usucodigo#" cfsqltype="cf_sql_numeric">,
						 <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
						 <cfqueryparam value="#Session.Usucodigo#" cfsqltype="cf_sql_numeric">,
						 <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp"> )
		</cfquery>
		<cfset modo="ALTA">
	
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="delete" datasource="#Session.DSN#">
			delete from TipoDocumentoR
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and TDRcodigo = <cfqueryparam value="#trim(Form._TDRcodigo)#" cfsqltype="cf_sql_char">
		</cfquery>  
		<cfset modo="ALTA">

	<cfelseif isdefined("Form.Cambio")>
		<cf_dbtimestamp datasource="#session.dsn#"
			 			table="TipoDocumentoR"
			 			redirect="tipoDocumento.cfm"
			 			timestamp="#form.ts_rversion#"				
						field1="Ecodigo" 
						type1="integer" 
						value1="#session.Ecodigo#"
						field2="TDRcodigo" 
						type2="char" 
						value2="#trim(form._TDRcodigo)#">

		<cfquery name="update" datasource="#Session.DSN#">
			update TipoDocumentoR 
			set TDRcodigo = <cfif CompareNoCase(trim(form._TDRcodigo),trim(form.TDRcodigo)) NEQ 0><cfqueryparam value="#form.TDRcodigo#" cfsqltype="cf_sql_char"><cfelse><cfqueryparam value="#form._TDRcodigo#" cfsqltype="cf_sql_char"></cfif>,
				TDRdescripcion = <cfqueryparam value="#Form.TDRdescripcion#" cfsqltype="cf_sql_varchar">,
				TDRtipo = <cfqueryparam value="#Form.TDRtipo#" cfsqltype="cf_sql_char">,
				TDRgeneranc = <cfif isdefined("form.TDRgeneranc")>1<cfelse>0</cfif>
			where Ecodigo  = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and TDRcodigo = <cfqueryparam value="#trim(Form._TDRcodigo)#" cfsqltype="cf_sql_char">
		</cfquery> 
		<cfset modo="CAMBIO">
	</cfif>
</cfif>

<cfoutput>
<form action="tipoDocumento.cfm" method="post" name="sql">
	<cfif isdefined("form.Cambio")>
		<input name="TDRcodigo" type="hidden" value="#Form.TDRcodigo#">
	</cfif>
</form>
</cfoutput>	

<HTML><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></HTML>

