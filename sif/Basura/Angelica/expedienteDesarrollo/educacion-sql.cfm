<cfset modo = "ALTA">
<cfif not isdefined("Form.Nuevo")>

	<!----
	<cfif isdefined("Form.Alta") or isdefined("Form.Cambio")>
		<cfquery name="rs" datasource="#session.DSN#">
			select 1 
			from TipoDocumentoR 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and TDRcodigo = <cfqueryparam value="#trim(Form.TDRcodigo)#" cfsqltype="cf_sql_char">
		</cfquery>
		<cfif rs.RecordCount gt 0>
			<cfif isdefined("Form.Alta")>
				<cfthrow message="El registro que desea agregar ya existe.">
			<cfelseif CompareNoCase(trim(form._TDRcodigo),trim(form.TDRcodigo)) NEQ 0>
				<cfthrow message="El registro que desea agregar ya existe.">
			</cfif>
		</cfif>	
	</cfif>
	----->
	<cfif isdefined("Form.Alta")>
		<cfquery name="insert" datasource="#Session.DSN#">
			insert into RHGrupoMaterias(RHGMcodigo, Descripcion, Ecodigo, BMfecha, BMUsucodigo)
				values(	<cfqueryparam cfsqltype="cf_sql_char" value="#form.RHGMcodigo#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Descripcion#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
					  )
		</cfquery>
		<cfset modo="ALTA">
	
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="delete" datasource="#Session.DSN#">
			delete RHGrupoMaterias
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and RHGMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHGMid#">
		</cfquery>  
		<cfset modo="ALTA">

	<cfelseif isdefined("Form.Cambio")>
		<cf_dbtimestamp datasource="#session.dsn#"
			 			table="RHGrupoMaterias"
			 			redirect="grupoMaterias.cfm"
			 			timestamp="#form.ts_rversion#"				
						field1="Ecodigo" 
						type1="integer" 
						value1="#session.Ecodigo#"
						field2="RHGMid" 
						type2="numeric" 
						value2="#form.RHGMid#">

		<cfquery name="update" datasource="#Session.DSN#">
			update RHGrupoMaterias
			set RHGMcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHGMcodigo#">,
				Descripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Descripcion#">
			where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >
			  and RHGMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHGMid#" >
		</cfquery> 
		<cfset modo="CAMBIO">
	</cfif>
</cfif>

<cfoutput>
<form action="educacion.cfm" method="post" name="sqlEducacion">
	<input name="DEid" type="hidden" value="#form.DEid#">
	<cfif isdefined("form.Cambio")>
		<input name="RHGMid" type="hidden" value="#form.RHGMid#">
	</cfif>
</form>
</cfoutput>	

<HTML><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></HTML>
