
<!--- Parámetros Requeridos --->
<cfif isdefined("Form.Cambio") or isdefined("Form.Baja")><cfparam name="Form.RHTTid" type="numeric"></cfif>
<cfparam name="Form.RHTTcodigo" type="string">
<cfparam name="Form.RHTTdescripcion" type="string">
<cfparam name="form.sel" default="1" type="numeric">
<!--- Parámetros Locales --->
<cfparam name="DEBUG" type="boolean" default="false">
<!--- Parámetros que realizan una Acción, cuando viene alguno de estos parámetros se realiza una acción exclusiva 
	en el orden en que se encuentre, es decir, si viene uno los otros, no se toma en cuenta.
	Parámetros que realizan una Acción: 
		Alta	: Alta de un Registro.
		Cambio	: Cambio de un Registro.
		Baja	: Baja de un Registro.
 --->
<!--- Consulta que realiza las Acciones --->
<cfif isdefined("Form.Alta")>
	<cfquery name="InsertaRHTTablaSalarial" datasource="#Session.DSN#">
		insert RHTTablaSalarial
		(RHTTcodigo,RHTTdescripcion,Ecodigo,BMUsucodigo,BMfalta,BMfmod)
		values(
		<cfqueryparam cfsqltype="cf_sql_char" value="#Form.RHTTcodigo#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHTTdescripcion#">,
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">,
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
		<cf_dbfunction name="today">,<cf_dbfunction name="today">)
		<cf_dbidentity1 datasource="#session.DSN#">
	</cfquery>
	<cf_dbidentity2 datasource="#session.DSN#" name="InsertaRHTTablaSalarial">
	<cfset form.RHTTid = InsertaRHTTablaSalarial.identity>
	<cf_translatedata name="set" tabla="RHTTablaSalarial" col="RHTTdescripcion" valor="#Form.RHTTdescripcion#" filtro="RHTTid = #form.RHTTid#">
<cfelseif isdefined("Form.Cambio")>
	<cfquery name="UpdateRHTTablaSalarial" datasource="#session.DSN#">
		update RHTTablaSalarial
		set RHTTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.RHTTcodigo#">,
			RHTTdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHTTdescripcion#">,
			BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
			BMfmod = <cf_dbfunction name="today">
		where RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTTid#">
		and ts_rversion = convert(varbinary(max),isnull(#lcase(Form.ts_rversion)#))
		
	</cfquery>
	<cf_translatedata name="set" tabla="RHTTablaSalarial" col="RHTTdescripcion" valor="#Form.RHTTdescripcion#" filtro="RHTTid = #form.RHTTid#">
<cfelseif isdefined("Form.Baja")>
	<cftransaction>
	<cftry>
	        <cfquery datasource="#session.dsn#" name="rsValidaVigencia">
	        	select count(1) as valor
	        	from RHVigenciasTabla 
	        	where RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTTid#">
	        		and RHVTestado='A'
	        </cfquery>
	        <cfif rsValidaVigencia.valor>
	        	<cf_errorCode	code="52145" msg="El registro de la tabla salarial ya se encuentra asociado.">
	        </cfif>
    	<cfquery datasource="#session.DSN#">
        	delete RHMontosCategoria
            from RHVigenciasTabla a
            inner join RHMontosCategoria b
            	on b.RHVTid = a.RHVTid
            where a.RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTTid#">    
        </cfquery>
    	<cfquery datasource="#session.DSN#">
        	delete RHVigenciasTabla
            where RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTTid#">
        </cfquery>
        <cfquery datasource="#session.DSN#">
            delete from RHTTablaSalarial
            where RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHTTid#">
        </cfquery>
    	<cfcatch type="any">
        	<cf_errorCode	code="52145" msg="El registro de la tabla salarial ya se encuentra asociado.">
        </cfcatch>
    </cftry>
    </cftransaction>
</cfif>
<!--- Consulta para debuguear --->
<cfif DEBUG>
	<cfif not isdefined("ABC_RHTTablaSalarial")>
		No se realizó ninguna acción.
	<cfelse>
		<cfquery name="rs" datasource="#Session.DSN#">
			select *
			from RHTTablaSalarial
			where RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ABC_RHTTablaSalarial.RHTTid#">
		</cfquery>
		<cfdump var="#rs#">
	</cfif>
	<cfabort>
</cfif>
<!--- Envia a la pantalla --->
<cfif isdefined("Form.Cambio")>
	<cflocation url="tipoTablasSal.cfm?RHTTid=#Form.RHTTid#&sel=#Form.sel#">
<cfelse>
	<cflocation url="tipoTablasSal.cfm">
</cfif>