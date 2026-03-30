<cf_dbfunction name="now"  returnvariable="hoy">
<cfif isdefined("form.mantener") and form.mantener eq  0>
	<cfquery datasource="#session.DSN#">
		delete from RCBitacora
		where Ecodigo =  #session.Ecodigo# 
		  and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#" >
		  and RCBestado = 0
	</cfquery>
</cfif>

<cfquery name="rsData" datasource="#session.DSN#">
	insert into RCBitacora( Ecodigo, CCTcodigo, Ddocumento, SNcodigo, Cuenta_Anterior, Cuenta_Nueva, BMfecha, BMUsucodigo, RCBestado )
	select  d.Ecodigo,
		    d.CCTcodigo, 
		    d.Ddocumento, 
		    d.SNcodigo, 
		    d.Ccuenta, 
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ccuenta#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 			
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
			0

	from Documentos d

	where d.Ecodigo =  #session.Ecodigo# 
	  and d.Dsaldo <> 0.00	
	  and d.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">

	<cfif isdefined("form.Ccuenta2") and len(trim(form.Ccuenta2))>
		and d.Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ccuenta2#">
	</cfif>

	<cfif isdefined("form.filtrar_por") and form.filtrar_por eq "D" and isdefined("form.Documento") and len(trim(form.Documento))>
		and d.Ddocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Documento#">
		and d.CCTcodigo in (	select t.CCTcodigo
								from CCTransacciones t
								where t.Ecodigo =  #session.Ecodigo# 
								  and t.CCTtipo = 'D'
								  and coalesce(t.CCTpago,0) != 1
								  and NOT upper(t.CCTdescripcion) like '%TESORER_A%'											  
								  and t.CCTtranneteo = 0 )
	<cfelse >
		<cfif isdefined("form.id_direccionEnvio") and len(trim(form.id_direccionEnvio))>
			and d.id_direccionFact = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_direccionEnvio#">
		</cfif>
		
		<cfif isdefined("form.Ocodigo") and len(trim(form.Ocodigo))>
			and d.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ocodigo#">
		</cfif>
		
		<cfif isdefined("form.antiguedad") and len(trim(form.antiguedad))>
		<!--- quiero todos los registros que tengan 'X' o menos dias de vencidos --->
			and (<cf_dbfunction name="datediff"	args="d.Dvencimiento, #hoy#">) <= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.antiguedad#"> <!--- La antigÃ¼edad --->
		</cfif>
		
		<cfif isdefined("form.CCTcodigo") and len(trim(form.CCTcodigo))>
			and d.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CCTcodigo#">
		<cfelse>
			<!--- Procesa todas las transacciones que cumplan esta condicion --->
			and d.CCTcodigo in (	select t.CCTcodigo
									from CCTransacciones t
									where t.Ecodigo =  #session.Ecodigo# 
									  and t.CCTtipo = 'D'
									  and coalesce(t.CCTpago,0) != 1
									  and NOT upper(t.CCTdescripcion) like '%TESORER_A%'											  
									  and t.CCTtranneteo = 0 )

		</cfif>		
	</cfif>
	
	<!--- valida que no inserte los mismos documentos para el estado 0( en caso de que ya tenga docs en estado 0 ) --->
	and not exists (  select rcb.IDbitacora
					  from RCBitacora rcb
					  where rcb.Ecodigo = d.Ecodigo
					    and rcb.CCTcodigo = d.CCTcodigo
						and rcb.Ddocumento = d.Ddocumento
						and rcb.RCBestado = 0 )
</cfquery>

<cfset params = '?SNcodigo=#form.SNcodigo#&Ccuenta=#form.Ccuenta#' >
<cfif isdefined("form.Ccuenta2") and len(trim(form.Ccuenta2))>
	<cfset params = params & '&Ccuenta2=#form.ccuenta2#'>
</cfif>

<cfif isdefined("form.filtrar_por") and form.filtrar_por eq "D" and isdefined("form.Documento") and len(trim(form.Documento))>
	<cfset params = params & '&filtrar_por=D&Ddocumento=#form.Documento#'>
<cfelse>
	<cfset params = params & '&filtrar_por=T'>
	<cfif isdefined("form.id_direccionEnvio") and len(trim(form.id_direccionEnvio))>
		<cfset params = params & '&id_direccion=#form.id_direccionEnvio#'>
	</cfif>
	
	<cfif isdefined("form.Ocodigo") and len(trim(form.Ocodigo))>
		<cfset params = params & '&Ocodigo=#form.Ocodigo#'>
	</cfif>
	
	<cfif isdefined("form.antiguedad") and len(trim(form.antiguedad))>
		<cfset params = params & '&antiguedad=#form.antiguedad#'>
	</cfif>
	
	<cfif isdefined("form.CCTcodigo") and len(trim(form.CCTcodigo))>
		<cfset params = params & '&CCTcodigo=#form.CCTcodigo#'>
	</cfif>	
</cfif>

<cflocation url="reclasificacionCuentas-documentos.cfm#JSStringFormat(params)#">
