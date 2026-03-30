<cfset params = "">

<cfif isdefined("Form.Alta")>
	<cfset varValida = ValidaAnos(form.PRAnoDesde, form.PRAnoHasta)>
    <cfif varValida>
    	<cfthrow message="Los valores del Año Desde o Año Hasta, se encuentran dentro de un rango existente">
    </cfif>
	<cftransaction>
		<cfquery name="rsInsert" datasource="#session.DSN#">
			insert into AFPorcentajeRetiroFiscal
				(Ecodigo, 
				ACcodigo, 
				ACid, 
				PRAnoDesde,
                PRAnoHasta,
                PRPorcentaje,
				BMUsucodigo)
			values (<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#form.ACcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#form.ACid#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#form.PRAnoDesde#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#form.PRAnoHasta#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#form.PRPorcentaje#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			)
			<cf_dbidentity1 datasource="#Session.DSN#">					
		</cfquery>
		<cf_dbidentity2 datasource="#Session.DSN#" name="rsInsert">
	</cftransaction>
 	<cfset params = params & iif(len(params),DE("&"),DE("?")) & "PRFid=" & rsInsert.identity>
	
<cfelseif isdefined("Form.Baja")>
	<cfquery name="rsDelete" datasource="#session.DSN#">
		delete from AFPorcentajeRetiroFiscal
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and PRFid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.PRFid#">
	</cfquery>	
	
<cfelseif isdefined("Form.Cambio")>
	<cf_dbtimestamp datasource="#session.dsn#"
					table="AFPorcentajeRetiroFiscal"
					redirect="PorcentajeRetiroFiscal.cfm"
					timestamp="#form.ts_rversion#"				
					field1="Ecodigo,integer,#session.Ecodigo#"
					field2="PRFid,numeric,#form.PRFid#">

	<cfquery name="rsUpdate" datasource="#session.DSN#">
		update 	AFPorcentajeRetiroFiscal
		set PRPorcentaje = <cfqueryparam cfsqltype="cf_sql_float" value="#form.PRPorcentaje#">
		where Ecodigo 		= 	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and PRFid 		= 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PRFid#">
	</cfquery>
 	<cfset params = params & iif(len(params),DE("&"),DE("?")) & "PRFid=" & form.PRFid>
</cfif>

<cfif isdefined("form.Padre_ACid") and len(trim(form.Padre_ACid))>
	<cfset params = params & iif(len(params),DE("&"),DE("?")) & "Padre_ACid=" & form.Padre_ACid>
</cfif>
<cfif isdefined("form.Padre_ACcodigo") and len(trim(form.Padre_ACcodigo))>
	<cfset params = params & iif(len(params),DE("&"),DE("?")) & "Padre_ACcodigo=" & form.Padre_ACcodigo>
</cfif>
<cfif isDefined("form.Pagina3") and len(trim(Form.Pagina3)) and not isDefined("form.Baja")>
	<cfset params = params & iif(len(params),DE("&"),DE("?")) & "PageNum_lista3=" & Form.Pagina3>
<cfelse>1
</cfif>

<cfoutput>
<form action="PorcentajeRetiroFiscal.cfm" method="get" name="sql">
	<cfif isdefined("form.Padre_ACid") and len(trim(form.Padre_ACid))>
		<input type="hidden" name="Padre_ACid" value="#form.Padre_ACid#">
	</cfif>
	<cfif isdefined("form.Padre_ACcodigo") and len(trim(form.Padre_ACcodigo))>
		<input type="hidden" name="Padre_ACcodigo" value="#form.Padre_ACcodigo#">
	</cfif>
	<cfif isDefined("form.Pagina3") and len(trim(Form.Pagina3)) and not isDefined("form.Baja")>
		<input type="hidden" name="PageNum_lista3" value="#form.Pagina3#">
	<cfelse>
		<input type="hidden" name="PageNum_lista3" value="1">
	</cfif>
	<cfif isdefined("Form.Alta")>
		<input type="hidden" name="PRFid" value="#rsInsert.identity#">
	<cfelseif isdefined("Form.Cambio")>
		<input type="hidden" name="PRFid" value="#form.PRFid#">
	</cfif>
    <cfif isdefined("form.VieneClas") and len(trim(form.VieneClas))>
	    <input type="hidden" name="VieneClas" id="VieneClas" value="#form.VieneClas#" />
    </cfif>
</form>
</cfoutput>

<cffunction name="ValidaAnos" returntype="boolean">
<cfargument name="AnoDesde" type="numeric" required="yes">
<cfargument name="AnoHasta" type="numeric" required="yes">
	<!--- Valida el año desde verificando que no se encuentre dentro de algun otro rango --->
    <cfquery name="rsValidaAno" datasource="#session.dsn#">
    	select 1 as Validacion
        from AFPorcentajeRetiroFiscal
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
        and ACid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ACid#">
        and ACcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ACcodigo#">
        and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.AnoDesde#"> between PRAnoDesde and PRAnoHasta
    </cfquery>
    
    <cfif rsValidaAno.recordcount GT 0>
    	<cfreturn true>
    </cfif>
    <!--- Valida el año Hasta verificando que no se encuentre dentro de algun otro rango --->
    <cfquery name="rsValidaAno" datasource="#session.dsn#">
    	select 1 as Validacion
        from AFPorcentajeRetiroFiscal
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
        and ACid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ACid#">
        and ACcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ACcodigo#">
        and <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.AnoHasta#"> between PRAnoDesde and PRAnoHasta
    </cfquery>
    
    <cfif rsValidaAno.recordcount GT 0>
    	<cfreturn true>
    </cfif>
    
    <cfreturn false>
</cffunction>
<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>