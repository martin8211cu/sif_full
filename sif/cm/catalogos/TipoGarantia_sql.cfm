<!---Nuevo--->
<cfif IsDefined("form.Nuevo")>
	<cflocation url="TipoGarantia.cfm?Nuevo=1">

<cfelseif isdefined('ALTA')>
	<cfquery datasource="#session.dsn#" name="rsInsertaTipo">
		insert into TiposGarantia (
			Ecodigo,TGcodigo,TGdescripcion,TGtipo,BMUsucodigo,BMfecha,TGmanejaMonto, TGporcentaje, TGmonto, Mcodigo )
		values(
			#session.Ecodigo#,
			<cf_jdbcquery_param cfsqltype="cf_sql_char" 		  value="#TRIM(form.TGcodigo)#">,
			<cf_jdbcquery_param cfsqltype="cf_sql_varchar" 	  value="#TRIM(form.TGdescripcion)#">,
			<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	  value="#form.TGtipo#">,			
			 #session.usucodigo#,
			 <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#now()#">,
			 <cf_jdbcquery_param cfsqltype="cf_sql_bit" 	  value="#form.TGmanejaMonto#">,
			 <cfif #form.TGmanejaMonto# eq 1>
			    0,
				<cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	  value="#form.TGmonto#">,
			 <cfelse>
			     <cf_jdbcquery_param cfsqltype="cf_sql_float" 	  value="#form.TGporcentaje1#">,
				0,
			 </cfif>
			  <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	  value="#form.Mcodigo#">
			)
			<cf_dbidentity1>
	</cfquery>
		<cf_dbidentity2 name="rsInsertaTipo">
<cflocation url="TipoGarantia.cfm?TGid=#rsInsertaTipo.identity#" addtoken="no">

<cfelseif isdefined('CAMBIO')>
		<cfquery name="ActualizaTipo" datasource="#session.dsn#">
			update TiposGarantia 
				set TGcodigo= <cf_jdbcquery_param cfsqltype="cf_sql_char" value="#TRIM(form.TGcodigo)#">,
				TGdescripcion = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#TRIM(form.TGdescripcion)#">,
				TGtipo= #form.TGtipo#,
				<cfif #form.TGmanejaMonto# eq 1>
			      TGmanejaMonto= <cf_jdbcquery_param cfsqltype="cf_sql_bit" value="#form.TGmanejaMonto#">,
				  TGporcentaje = 0,
				  TGmonto=  <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	  value="#form.TGmonto#">,
			    <cfelse>
				  TGmanejaMonto= <cf_jdbcquery_param cfsqltype="cf_sql_bit" value="#form.TGmanejaMonto#">,
			      TGporcentaje = <cf_jdbcquery_param cfsqltype="cf_sql_float" 	  value="#form.TGporcentaje1#">,
				  TGmonto=  0,
			    </cfif>				
				BMUsucodigo = #session.usucodigo#,
				BMfecha = <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#now()#">,
				Mcodigo = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	  value="#form.Mcodigo#">
			where TGid  =<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.TGid#">
		</cfquery>
<cflocation url="TipoGarantia.cfm?TGid=#TGid#">

<cfelseif isdefined('BAJA')>
	<cfquery name="EliminaTipo" datasource="#session.DSN#">
		delete from TiposGarantia
		where TGid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.TGid#">
	</cfquery>
<cflocation url="TipoGarantia.cfm">
</cfif>