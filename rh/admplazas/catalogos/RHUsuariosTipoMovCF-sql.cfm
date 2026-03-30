<cfset modo = "ALTA">

<!-----Modo alta---->
<cfif isdefined("Form.Alta")>	
	<cftransaction>				
		<cfquery name="ALTAusuTipoMov" datasource="#session.dsn#">
			insert RHUsuariosTipoMovCF 
				(RHTMid, Ecodigo, Usucodigo, BMfecha, BMUsucodigo)
			values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHTMid#">
					, <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					, <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.usucodigo#">
					, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
					, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
		  <cf_dbidentity1 datasource="#Session.DSN#">
		</cfquery>					
		<cf_dbidentity2 datasource="#Session.DSN#" name="ALTAusuTipoMov">
	</cftransaction>
	
	<cfset form.RHUTMlinea = ALTAusuTipoMov.identity>
<!----Modo BAJA---->
<cfelseif IsDefined("form.Baja")>
	<cfquery datasource="#session.dsn#">
		delete from RHUsuariosTipoMovCF 
		where RHUTMlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHUTMlinea#">
	</cfquery>		
</cfif>

<cfoutput>
<form action="RHtabsTipoMov.cfm" method="post" name="sql">
	<input name="RHTMid" type="hidden" value="#form.RHTMid#"> 
	<input name="tab" type="hidden" value="2"> 	
	<cfif isdefined("form.Alta") or isdefined("form.Cambio")>
		<cfif not isdefined('form.Baja') and (isdefined('form.RHUTMlinea') and form.RHUTMlinea NEQ '')>
			<input name="RHUTMlinea" type="hidden" value="#form.RHUTMlinea#"> 
		</cfif>
	<cfelseif isdefined('form.Nuevo')>
		<input name="btnNuevo" type="hidden" value="btnNuevo"> 
	</cfif>
</form>
</cfoutput>
<HTML><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></HTML>



