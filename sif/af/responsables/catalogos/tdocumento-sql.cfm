<!---  --->
<cfset params = "">
<cfset modo = "ALTA">

<cftry>
	<cfif isdefined("form.Alta")>
		<!--- Si ya existe un registro con CRTDcodigo no permite insertarlo --->
		<cfquery name="rsVerifica" datasource="#session.DSN#">
			select CRTDcodigo
			from CRTipoDocumento
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">			
			  and upper(CRTDcodigo) = <cfqueryparam cfsqltype="cf_sql_char" value="#UCase(Trim(form.CRTDcodigo))#"> 
		</cfquery>	
		<cfif #rsVerifica.recordCount# eq 0>
			<cftransaction>
				<cfif isdefined("form.CRTDdefault")>
					<cfquery name="rsActualizaDefault" datasource="#session.DSN#">
						update CRTipoDocumento set CRTDdefault = 0
					</cfquery>
				</cfif>
				<cfquery name="rsTipoDocumento" datasource="#session.DSN#">
					insert into CRTipoDocumento (Ecodigo,CRTDcodigo,CRTDdescripcion,BMUsucodigo,CRTDfalta,CRTDdefault)
					values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
							 <cfqueryparam cfsqltype="cf_sql_char" value="#Trim(form.CRTDcodigo)#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(form.CRTDdescripcion)#">,
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">, 
							 <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
							 <cfif isdefined("form.CRTDdefault")>1<cfelse>0</cfif>
							) 
					<cf_dbidentity1 datasource="#Session.DSN#">					
				</cfquery>
				<cf_dbidentity2 datasource="#Session.DSN#" name="rsTipoDocumento">
			</cftransaction>
			
			<cfset modo = "CAMBIO">
			<cfset params="?CRTDid="&rsTipoDocumento.identity>
			<cfset params=params&"&CRTDcodigo="&Form.CRTDcodigo>
			<cfset params=params&"&CRTDdescripcion="&Form.CRTDdescripcion>
			<cfif isdefined("form.CRTDdefault")>
				<cfset params=params&"&CRTDdefault="&Form.CRTDdefault>
			</cfif>
			<cfset params=params&"&modo="&#modo#>			
		<cfelse>
			<cf_errorCode	code = "50120" msg = "No se puede agregar. Ya existe un tipo de documento asignado.">		
		</cfif>
		
	<cfelseif isdefined("form.Cambio")>
		<!--- Si ya existe o soy yo mismo entonces permite modificarlo --->
		<cfquery name="rsVerifica" datasource="#session.DSN#">
			select CRTDcodigo
			from CRTipoDocumento
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">			
			  and upper(CRTDcodigo) = <cfqueryparam cfsqltype="cf_sql_char" value="#UCase(Trim(form.CRTDcodigo))#">
			  and upper(CRTDcodigo) <> <cfqueryparam cfsqltype="cf_sql_char" value="#UCase(Trim(form.CRTDcodigoL))#">
		</cfquery>	
		<cfif #rsVerifica.recordCount# eq 0>
			<cf_dbtimestamp datasource="#session.dsn#"
							table="CRTipoDocumento"
							redirect="tdocumento-form.cfm"
							timestamp="#form.ts_rversion#"
							field1="CRTDid" 
							type1="numeric" 
							value1="#form.CRTDid#"
							>
			<cfif isdefined("form.CRTDdefault")>
				<cfquery name="rsActualizaDefault" datasource="#session.DSN#">
					update CRTipoDocumento set CRTDdefault = 0
				</cfquery>
			</cfif>
 
			<cfquery name="rsTipoDocumento" datasource="#session.DSN#">
				update CRTipoDocumento
				set CRTDcodigo      = <cfqueryparam cfsqltype="cf_sql_char" value="#Trim(form.CRTDcodigo)#">,
					CRTDdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(form.CRTDdescripcion)#">,
					CRTDdefault     = <cfif isdefined("form.CRTDdefault")>1<cfelse>0</cfif>
				where CRTDid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CRTDid#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			</cfquery>	
			
			<cfset modo = "CAMBIO">
			<cfset params="?CRTDid="&Form.CRTDid>
			<cfset params=params&"&CRTDcodigo="&Form.CRTDcodigo>
			<cfset params=params&"&CRTDdescripcion="&Form.CRTDdescripcion>
			<cfif isdefined("form.CRTDdefault")>
				<cfset params=params&"&CRTDdefault="&Form.CRTDdefault>
			</cfif>
			<cfset params=params&"&modo="&#modo#>
		<cfelse>
			<cf_errorCode	code = "50121" msg = "No se puede modificar. Ya existe un tipo de documento asignado.">
		</cfif>

	<cfelseif isdefined("form.Baja")>
		<cfquery name="rsTipoDocumento" datasource="#session.DSN#">
			delete from CRTipoDocumento
			where CRTDid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CRTDid#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">			
		</cfquery>	

		<cfset modo = "CAMBIO">
		<cfset params="?modo="&#modo#>
	</cfif>

	<cfcatch type="any">
		<cfinclude template="/sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
</cftry>

<cflocation url="tdocumento.cfm#params#">

