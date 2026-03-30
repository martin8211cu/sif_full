
<cfif not isdefined("Form.Nuevo")>

	<cfif isdefined("Form.Alta") and (not isdefined("form.ADSPid") or form.ADSPid EQ "")> 
    			<cfquery name="valida" datasource="#session.DSN#">
					select 1 from ADSEPerfil
					where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and ADSPcodigo      = <cfqueryparam cfsqltype="cf_sql_char" value="#form.ADSPcodigo#">
				</cfquery>
				<cfif valida.RecordCount gt 0>
					<cf_errorCode	code = "80009" msg = "El Código del Perfil ya existe, por favor intente de nuevo.">
				</cfif>
                
		<cftransaction>
			<cfquery name="InsertPerfiles" datasource="#Session.DSN#">
				insert INTO ADSEPerfil (Ecodigo, ADSPcodigo, ADSPdescripcion)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ADSPcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ADSPdescripcion#">
				)
				<cf_dbidentity1 datasource="#Session.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#Session.DSN#" name="InsertPerfiles">
		</cftransaction>		

		<cfset modo="ALTADET">
    <cfelseif isdefined("Form.Alta") and (isdefined("form.PerfilProceso") and form.PerfilProceso NEQ "")>
    	<cfquery name="InsertPerfilesDet" datasource="#Session.DSN#">
				insert INTO ADSDPerfil(Ecodigo, ADSPid,ADSPPid)
				values(
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ADSPid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PerfilProceso#">)
				<cf_dbidentity1 datasource="#Session.DSN#">
		</cfquery>
				<cf_dbidentity2 datasource="#Session.DSN#" name="InsertPerfilesDet">		
    	<cfset modo="CAMBIO">

   <cfelseif isdefined("Form.Alta") and (not isdefined("form.PerfilProceso") or form.PerfilProceso EQ "")>
   		<cf_errorCode	code = "80013" msg = "Debe seleccionar alguna opción de seguridad.">
        
	<cfelseif isdefined("url.BorraD") and url.BorraD EQ 1>
		<cfquery name="ABC_Formatos" datasource="#Session.DSN#">
			delete from ADSDPerfil
			where ADSPDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ADSPDid#"> 
				and ADSPDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ADSPDid#">
                and ADSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ADSPid#">
		</cfquery>
		<cfset modo="CAMBIO">
        
   <cfelseif isdefined("form.Baja")>
   		<cfquery name="Baja_PerfilD" datasource="#Session.DSN#">
			delete from ADSDPerfil
			where ADSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ADSPid#"> 
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		</cfquery>
        
		<cfquery name="Baja_PerfilE" datasource="#Session.DSN#">
			delete from ADSEPerfil
			where ADSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ADSPid#"> 
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		</cfquery>
		<cfset modo="CAMBIODET">
        
	<cfelseif isdefined("Form.Cambio")>
		<cfquery datasource="#Session.DSN#">
			update ADSEPerfil
			   set ADSPdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ADSPdescripcion#">
			where ADSPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ADSPid#">			
		</cfquery>
        		
		<cfset modo="CAMBIO">
	</cfif>			
</cfif>

<cfoutput>

<cfset param = ''>

<cfif isdefined("form.Cambio") and isdefined("form.ADSPid") and len(trim(form.ADSPid))>
	<cfset param = param & "?ADSPid=#form.ADSPid#"&"&modo=#modo#">
<cfelseif isdefined("Form.Alta") and Form.Alta EQ "Agregar" and not isdefined("InsertPerfiles.identity")>
	 <cfset param = param & "?ADSPid=#form.ADSPid#"&"&modo=#modo#">
<cfelseif isdefined("Form.Alta") and isdefined("InsertPerfiles.identity") and len(trim(InsertPerfiles.identity))>
	 <cfset param = param & "?ADSPid=#InsertPerfiles.identity#"&"&modo=#modo#">
</cfif>

<cflocation url="Perfiles.cfm#param#">
</cfoutput>
