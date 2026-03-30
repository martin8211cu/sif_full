<!---  --->
<cfset params = "">
<cfset modo = "ALTA">

<cftry>
	<cfif isdefined("form.Alta")>
		<!--- Si ya existe un registro con CRTCcodigo no permite insertarlo --->
		<cfquery name="rsVerifica" datasource="#session.DSN#">
			select CRTCcodigo
			from CRTipoCompra
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">			
			  and upper(CRTCcodigo) = <cfqueryparam cfsqltype="cf_sql_char" value="#UCase(Trim(form.CRTCcodigo))#">
		</cfquery>	
		<cfif #rsVerifica.recordCount# eq 0>
			<cftransaction>
				<cfquery name="rsTipoCompra" datasource="#session.DSN#">
					insert into CRTipoCompra (Ecodigo,CRTCcodigo,CRTCdescripcion,BMUsucodigo,CRTCfalta)
					values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
							 <cfqueryparam cfsqltype="cf_sql_char" value="#Trim(form.CRTCcodigo)#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(form.CRTCdescripcion)#">,
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">, 
							 <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">
							) 
					<cf_dbidentity1 datasource="#Session.DSN#">					
				</cfquery>
				<cf_dbidentity2 datasource="#Session.DSN#" name="rsTipoCompra">
			</cftransaction>
	
			<cfset modo = "CAMBIO">
			<cfset params="?CRTCid="&rsTipoCompra.identity>
			<cfset params=params&"&CRTCcodigo="&Form.CRTCcodigo>
			<cfset params=params&"&CRTCdescripcion="&Form.CRTCdescripcion>
			<cfset params=params&"&modo="&#modo#>
		<cfelse>
			<cf_errorCode	code = "50118" msg = "No se puede agregar. Ya existe un tipo de compra asignado.">		
		</cfif>
		
	<cfelseif isdefined("form.Cambio")>
		<!--- Si ya existe o soy yo mismo entonces permite modificarlo --->
		<cfquery name="rsVerifica" datasource="#session.DSN#">
			select CRTCcodigo
			from CRTipoCompra
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">			
			  and upper(CRTCcodigo) = <cfqueryparam cfsqltype="cf_sql_char" value="#UCase(Trim(form.CRTCcodigo))#">
			  and upper(CRTCcodigo) <> <cfqueryparam cfsqltype="cf_sql_char" value="#UCase(Trim(form.CRTCcodigoL))#">
		</cfquery>	
		<cfif #rsVerifica.recordCount# eq 0>

			<cf_dbtimestamp datasource="#session.dsn#"
							table="CRTipoCompra"
							redirect="tcompra-form.cfm"
							timestamp="#form.ts_rversion#"
							field1="CRTCid" 
							type1="numeric" 
							value1="#form.CRTCid#"
							>
	
			<cfquery name="rsTipoCompra" datasource="#session.DSN#">
				update CRTipoCompra
				set CRTCcodigo      = <cfqueryparam cfsqltype="cf_sql_char" value="#Trim(form.CRTCcodigo)#">,
					CRTCdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(form.CRTCdescripcion)#">
				where CRTCid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CRTCid#">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">			
			</cfquery>	
			
			<cfset modo = "CAMBIO">
			<cfset params="?CRTCid="&Form.CRTCid>
			<cfset params=params&"&CRTCcodigo="&Form.CRTCcodigo>
			<cfset params=params&"&CRTCdescripcion="&Form.CRTCdescripcion>
			<cfset params=params&"&modo="&#modo#>
		<cfelse>
			<cf_errorCode	code = "50119" msg = "No se puede modificar. Ya existe un tipo de compra asignado.">
		</cfif>
							
	<cfelseif isdefined("form.Baja")>
		<cfquery name="rsTipoCompra" datasource="#session.DSN#">
			delete from CRTipoCompra
			where CRTCid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CRTCid#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">			
		</cfquery>	

		<cfset modo = "CAMBIO">
		<cfset params="?modo="&#modo#>
	</cfif>

	<cfcatch type="any">
		<cfinclude template="/sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
</cftry>

<cflocation url="tcompra.cfm#params#">

