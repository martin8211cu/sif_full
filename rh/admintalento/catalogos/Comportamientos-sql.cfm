<cfinvoke key="MSG_LosPesosDeLosComponentesDeLaHabilidadNoPuedenSerMayoresACien" default="Los pesos de los componentes de la habilidad no pueden ser mayores a cien"  
returnvariable="MSG_ValidacionPesos" component="sif.Componentes.Translate"  method="Translate" />
<!----Verificar la sumatoria de los pesos de los comportamientos por habilidad---->
<cfquery name="rsPesos" datasource="#session.DSN#">
	select coalesce(sum(RHCOpeso), 0) as peso
	from RHComportamiento
	where RHHid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHHid#">	
		<cfif not isdefined("Form.Alta")>
			and RHCOid != <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCOid#">
		</cfif>	
</cfquery>
<cfset vn_pesos = rsPesos.peso  + form.RHCOpeso>
<cfset params = ''>

<cfif not isdefined("Form.Nuevo")>
	<cftransaction>
	<cftry>
		<cfif isdefined("Form.Alta")>
			<cfif vn_pesos LTE 100>
				<cfquery datasource="#Session.DSN#">			
					insert into RHComportamiento (Ecodigo, RHCOcodigo, 
												RHCOdescripcion, RHHid, RHGNid, 
												RHCOpeso, BMUsucodigo, BMfechaalta)
					values(	<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
							<cfqueryparam cfsqltype="cf_sql_char" value="#Form.RHCOcodigo#">, 
							<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#Form.RHCOdescripcion#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHHid#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHGNid#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCOpeso#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
						)
				</cfquery>
				<cfset params = '?modo=CAMBIO'>				
			<cfelse>
				<cfthrow message="#MSG_ValidacionPesos#">
			</cfif>
		<cfelseif isdefined("Form.Baja")>						
			<cfquery datasource="#session.DSN#">
				delete from RHComportamiento 
				where RHCOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCOid#">
			</cfquery>
			<cfset modo="BAJA">
			<cfset params = '?modo='& modo>
		<cfelseif isdefined("Form.Cambio")>
			<cf_dbtimestamp
				datasource="#Session.DSN#"
				table="RHComportamiento"
				redirect="Comportamientos-form.cfm"
				timestamp="#form.ts_rversion#"
				field1="RHCOid,numeric,#Form.RHCOid#">
			<cfif vn_pesos LTE 100>
				<cfquery datasource="#session.DSN#">
					update RHComportamiento
						set RHCOcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHCOcodigo#">,
							RHGNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHGNid#">,
							RHCOpeso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCOpeso#">,
							<cfif isdefined("form.RHCOdescripcion") and len(trim(form.RHCOdescripcion))>
								RHCOdescripcion = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.RHCOdescripcion#">
							<cfelse>
								RHCOdescripcion = ' '
							</cfif>
					where RHCOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCOid#">
				</cfquery>
	 		<cfelse>
				<cfthrow message="#MSG_ValidacionPesos#">
			</cfif>	
			<cfset modo="CAMBIO">	
			<cfset params = '?RHCOid=#form.RHCOid#&modo='& modo> 			  				  
		</cfif>			
	<cfcatch type="any">
		<cfinclude template="/sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
	</cftransaction>
</cfif>
<cfoutput>	
	<cflocation url="Comportamientos.cfm?#params#">
</cfoutput>
