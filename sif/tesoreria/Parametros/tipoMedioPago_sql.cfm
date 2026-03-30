<!---<cf_dump var="#form#">--->
<cfif IsDefined("form.Cambio")>
	<cf_dbtimestamp datasource="#session.dsn#"
			table="TESmedioPago"
			redirect="tipoMedioPago.cfm"
			timestamp="#form.ts_rversion#"

			field1="TESid"
			type1="numeric"
			value1="#session.Tesoreria.TESid#"

			field2="CBid"
			type2="numeric"
			value2="#form.CBid#"

			field3="TESMPcodigo"
			type3="varchar"
			value3="#form.TESMPcodigo#"
	>
	<cfset LvarTipo = listToArray(form.TESTMPtipo)>
	<!---
		[1]: Tipo:				1=CHK,	2=TRI, 	3=TRE, 	4=TRM
		[2]: Formato Impreso	1		1		0		0
		[3]: Generación Archivo	0		0		1		0		
		[4]: Control Formulario	1		0		0		0
	--->
	<cfquery datasource="#session.dsn#">
		update TESmedioPago
			set TESTMPtipo			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarTipo[1]#">
			<cfif LvarTipo[2] EQ "1">
			  , FMT01COD			= <cfqueryparam cfsqltype="cf_sql_char"    value="#form.FMT01COD#">
			<cfelse>
			  , FMT01COD			= null
			</cfif>
            <!---Se comenta el FMT01CODemail para en lugar de eligir que tipo, lo que se indique es si envia correo o no con el TESenviaCorreo--->
			 <!--- , FMT01CODemail		= <cfqueryparam cfsqltype="cf_sql_char"    value="#form.FMT01CODemail#" null="#form.FMT01CODemail EQ ""#">--->
			<cfif isdefined("form.TESenviaCorreo")>
			 	,TESenviaCorreo=1
            <cfelse>
            	,TESenviaCorreo=0
            </cfif>
			<cfif LvarTipo[1] EQ "3">
			  , TESTGid				= <cfqueryparam cfsqltype="cf_sql_numeric"    value="#listGetAt(form.TESTGid,1)#"> 
			  , TESTGcodigoTipo		= <cfqueryparam cfsqltype="cf_sql_numeric"    value="#listGetAt(form.TESTGid,2)#"> 
			  , TESTGtipoCtas		= <cfqueryparam cfsqltype="cf_sql_numeric"    value="#listGetAt(form.TESTGid,3)#"> 
			  , TESTGtipoConfirma	= <cfqueryparam cfsqltype="cf_sql_numeric"    value="#listGetAt(form.TESTGid,4)#"> 
			<cfelseif LvarTipo[1] EQ "2">
			  , TESTGid				= null
			  , TESTGcodigoTipo		= <cfqueryparam cfsqltype="cf_sql_numeric"    value="#form.TESTGcodigoTipo#">
			  <cfparam name="form.TESTGtipoCtas" default="0">
			  , TESTGtipoCtas		= <cfqueryparam cfsqltype="cf_sql_numeric"    value="#form.TESTGtipoCtas#"> 
			  , TESTGtipoConfirma	= <cfqueryparam cfsqltype="cf_sql_numeric"    value="#form.TESTGtipoConfirma#"> 
			<cfelse>
			  , TESTGid				= null 
			  , TESTGcodigoTipo		= 10
			  , TESTGtipoCtas		= 0
			  , TESTGtipoConfirma	= 1
			</cfif>

			  , TESMPdescripcion	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESMPdescripcion#">
			  <cfif isdefined("form.TESMPsoloManual")>
			  	, TESMPsoloManual = 1
			  <cfelse>
			  	, TESMPsoloManual = 0
			  </cfif>
				, TESMPcodigoDisp = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESMPcodigoDisp#">
		 where 	TESid				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
			and CBid				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
			and TESMPcodigo			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESMPcodigo#">
	</cfquery>
	<cflocation url="tipoMedioPago.cfm?CBid=#form.CBid#&TESMPcodigo=#form.TESMPcodigo#">
<cfelseif IsDefined("form.Baja")>
	<cfquery datasource="#session.dsn#">
		delete from TESmedioPago
		 where 	TESid				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
			and CBid				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
			and TESMPcodigo			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESMPcodigo#">
	</cfquery>
<cfelseif IsDefined("form.Alta")>
	<cfset LvarTipo = listToArray(form.TESTMPtipo)>
	<cfquery datasource="#session.dsn#">
		insert into TESmedioPago
			(TESid, CBid, TESMPcodigo, TESTMPtipo, FMT01COD, <!---FMT01CODemail,--->TESenviaCorreo, TESMPdescripcion,TESMPsoloManual
			  , TESTGid, TESTGcodigoTipo, TESTGtipoCtas, TESTGtipoConfirma,TESMPcodigoDisp
			)
		values
			(
				 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
				,<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
				,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESMPcodigo#">
				,<cfqueryparam cfsqltype="cf_sql_numeric" value="#listFirst(form.TESTMPtipo)#">
				,<cfqueryparam cfsqltype="cf_sql_char" 	  value="#form.FMT01COD#" null="#LvarTipo[2] NEQ "1"#">
                <!---Se comenta el FMT01CODemail para en lugar de eligir que tipo, lo que se indique es si envia correo o no con el TESenviaCorreo--->
			    <!---, <cfqueryparam cfsqltype="cf_sql_char"   value="#form.FMT01CODemail#" null="#form.FMT01CODemail EQ ""#">--->
			  <cfif isdefined("form.TESenviaCorreo")>
                ,1
              <cfelse>
                ,0
              </cfif>    
				,<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESMPdescripcion#">
			  <cfif isdefined("form.TESMPsoloManual")>
			  	, 1
			  <cfelse>
			  	, 0
			  </cfif>

			<cfif LvarTipo[1] EQ "3">
			  , <cfqueryparam cfsqltype="cf_sql_numeric"    value="#listGetAt(form.TESTGid,1)#"> 
			  , <cfqueryparam cfsqltype="cf_sql_numeric"    value="#listGetAt(form.TESTGid,2)#"> 
			  , <cfqueryparam cfsqltype="cf_sql_numeric"    value="#listGetAt(form.TESTGid,3)#"> 
			  , <cfqueryparam cfsqltype="cf_sql_numeric"    value="#listGetAt(form.TESTGid,4)#"> 
			<cfelseif LvarTipo[1] EQ "2">
			  , null
			  , <cfqueryparam cfsqltype="cf_sql_numeric"    value="#form.TESTGcodigoTipo#">
			  <cfparam name="form.TESTGtipoCtas" default="0">
			  , <cfqueryparam cfsqltype="cf_sql_numeric"    value="#form.TESTGtipoCtas#"> 
			  , <cfqueryparam cfsqltype="cf_sql_numeric"    value="#form.TESTGtipoConfirma#"> 
			<cfelse>
			  , null, 10, 0, 1
			</cfif>
				, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TESMPcodigoDisp#">
			)
	</cfquery>
<cfelseif IsDefined("form.Nuevo")>
<cfelse>
</cfif>

<cflocation url="tipoMedioPago.cfm">
