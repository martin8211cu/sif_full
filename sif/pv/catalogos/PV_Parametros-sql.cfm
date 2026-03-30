 <cfif IsDefined("form.Cambio")>
 
	<cf_dbtimestamp datasource="#session.dsn#"
				table="FAP000"
				redirect="Parametros.cfm"
				timestamp="#form.ts_rversion#"
				field1="Ecodigo"
				type1="integer"
				value1="#Session.Ecodigo#">
				
	<cfset m_MONMPRIM = #replace(form.MONMPRIM,",","","all")#>
	<cfset m_FAUNIRED = #replace(form.FAUNIRED,",","","all")#>
	<cfset m_MONMINADE = #replace(form.MONMINADE,",","","all")#>
	<cfset m_MONMINCR = #replace(form.MONMINCR,",","","all")#>
	<cfset m_FAPMONCHK = #replace(form.FAPMONCHK,",","","all")#>
	
	<cfquery name="update" datasource="#session.DSN#">
	
		update FAP000 
		set			
			cfmCotizacion = <cfqueryparam value="#form.cfmCotizacion#" cfsqltype="cf_sql_varchar">,
			cfmPrefactura = <cfqueryparam value="#form.cfmPrefactura#" cfsqltype="cf_sql_varchar">,
			FAPTRANS  = <cfqueryparam value="#form.FAPTRANS#" cfsqltype = "cf_sql_tinyint">,
			FAAUTOR   = <cfqueryparam value="#form.FAAUTOR#" cfsqltype = "cf_sql_tinyint">,
			PORMPRIM  = <cfqueryparam value="#form.PORMPRIM#" cfsqltype="cf_sql_float">,
			MONMPRIM  = <cfqueryparam value="#m_MONMPRIM#" cfsqltype="cf_sql_money">,
			MAXDESCP  = <cfqueryparam value="#form.MAXDESCP#" cfsqltype="cf_sql_float">,
			LBLIMP    = <cfqueryparam value="#form.LBLIMP#" cfsqltype="cf_sql_varchar">, 
			FATIPORED = <cfqueryparam value="#form.FATIPORED#" cfsqltype="cf_sql_tinyint">, 
			FACALIMP  = <cfqueryparam value="#form.FACALIMP#" cfsqltype="cf_sql_tinyint">, 
			FAUNIRED  = <cfqueryparam value="#m_FAUNIRED#" cfsqltype="cf_sql_money">, 
			MONMINADE = <cfqueryparam value="#m_MONMINADE#" cfsqltype="cf_sql_money">, 
			MONMINCR  = <cfqueryparam value="#m_MONMINCR#" cfsqltype="cf_sql_money">,
			FAPMONCHK = <cfqueryparam value="#m_FAPMONCHK#" cfsqltype="cf_sql_money">,
            FAPMSG = <cfqueryparam value="#form.FAPMSG#" cfsqltype="cf_sql_varchar">,
			BMUsucodigo= <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
		where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer"> 
				
	</cfquery> 

	<cflocation url="Parametros.cfm?o=1">

</cfif>