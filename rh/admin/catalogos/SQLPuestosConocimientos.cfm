<cfparam name="action" default="PuestosConocimientos.cfm">
<cfparam name="modo" default="ALTA">
<cfset param = "">
<!--- VARIABLES DE TRADUCCION --->

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
key="MSG_ElCodigoDeConocimientoYaExisteDefinaUnoDistinto" 
default="El Código de Conocimiento ya existe, defina uno distinto"
returnvariable="MSG_ElCodigoDeConocimientoYaExisteDefinaUnoDistinto"/>				

<!--- FIN VARIABLES DE TRADUCCION --->
<cfif not isdefined("form.btnNuevo")>
	<cftry>
		<cfif isdefined("form.Alta")>
			<cfquery name="ValidaCodigo" datasource="#session.DSN#">
				select RHCcodigo from RHConocimientos
				where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				and RHCcodigo = <cfqueryparam value="#ucase(trim(form.RHCcodigo))#" cfsqltype="cf_sql_char">
			</cfquery>
			<cfif ValidaCodigo.recordCount GT 0>
				
				<cf_throw message= '#MSG_ElCodigoDeConocimientoYaExisteDefinaUnoDistinto#' errorcode="2155">

			</cfif>			
			<cfquery name="ABC_Puestos_insert" datasource="#session.DSN#">
				insert into RHConocimientos ( Ecodigo, RHCcodigo, RHCdescripcion, RHCinactivo,PCid, BMusuario, BMfecha)
							 values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
									  <cfqueryparam cfsqltype="cf_sql_char" value="#ucase(trim(form.RHCcodigo))#">,
									  <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHCdescripcion#">,
									  
									  <cfif isdefined("Form.RHCinactivo")>
									  	1,
									  <cfelse>
										0,
									  </cfif>
									  <cfif isdefined('form.PCid') and LEN(TRIM(form.PCid))>
									 	 <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">,
									  <cfelse>
									  	 null,
									  </cfif>
									  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
									  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
									)
			</cfquery>
			<cfset param = "modo=" & modo>
		<cfelseif isdefined("form.Cambio")>
			<cfquery name="ValidaCodigo" datasource="#session.DSN#">
				select RHCcodigo from RHConocimientos
				where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and RHCcodigo  = <cfqueryparam cfsqltype="cf_sql_char" value="#ucase(trim(form.RHCcodigo))#">
				and RHCid     !=  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid#">
			</cfquery>
			<cfif ValidaCodigo.recordCount GT 0><cf_throw message= '#MSG_ElCodigoDeConocimientoYaExisteDefinaUnoDistinto#' errorcode="2155"></cfif>					
			
			
			<cf_dbtimestamp
					 datasource="#session.dsn#"
					 table="RHConocimientos"
					 redirect="PuestosConocimientos.cfm"
					 timestamp="#form.ts_rversion#"
					 field1="RHCid" type1 = "numeric" value1="#form.RHCid#" 
					 field2="Ecodigo" type2="numeric" value2="#session.Ecodigo#">
					 
			<cfquery name="ABC_Puestos_update" datasource="#session.DSN#">
				 

				update RHConocimientos
				set RHCcodigo 	= <cfqueryparam cfsqltype="cf_sql_char" value="#ucase(trim(form.RHCcodigo))#">,
				RHCdescripcion 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHCdescripcion#">,
				RHCinactivo 	= <cfif isdefined("Form.RHCinactivo")> 1<cfelse>0</cfif>,
				PCid			= <cfif isdefined('form.PCid') and LEN(TRIM(form.PCid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#"><cfelse>null</cfif>,
				BMusumod = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				BMfechamod = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
				where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and RHCid =  <cfqueryparam value="#form.RHCid#" cfsqltype="cf_sql_numeric">
			</cfquery>
			<cfset modo = 'CAMBIO'>
			<cfset param = "modo=" & modo>
		<cfelseif isdefined("form.Baja")>
			<cfquery name="ABC_Puestos_deleteA" datasource="#session.DSN#">
				delete 
				from RHIConocimiento 
				where RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid#">
			</cfquery>
			
			<cfquery name="ABC_Puestos_deleteB" datasource="#session.DSN#">
				delete from RHConocimientos
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and RHCid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid#">
			</cfquery>			
			<cfset param = "modo=" & modo>
		<cfelseif isdefined("form.btnDetalleUpd") and len(trim(RHICid)) eq 0><!--- Alta Detalle--->
			 <cf_dbtimestamp
						 datasource="#session.dsn#"
						 table="RHConocimientos"
						 redirect="PuestosConocimientos.cfm"
						 timestamp="#form.ts_rversion#"
						 field1="RHCid" type1 = "numeric" value1="#form.RHCid#" 
						 field2="Ecodigo" type2="numeric" value2="#session.Ecodigo#">
			<cfquery name="ABC_Puestos_update0" datasource="#session.DSN#">
					
				update RHConocimientos
				set RHCcodigo 	= <cfqueryparam cfsqltype="cf_sql_char" value="#ucase(trim(form.RHCcodigo))#">,
				RHCdescripcion 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHCdescripcion#">,
				PCid			= <cfif isdefined('form.PCid') and LEN(TRIM(form.PCid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#"><cfelse>null</cfif>,
				BMusumod 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				BMfechamod 		= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and RHCid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid#">
			</cfquery>	
			<cfquery name="rsCuenta1" datasource="#session.DSN#">
				select RHCcodigo, RHCdescripcion, BMusumod, BMfechamod
				from RHConocimientos
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and RHCid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid#">
			</cfquery>
			<cfset param = "modo=" & modo>
		<cfif rsCuenta1.RecordCount gt 0>
			<cfquery name="ABC_Puestos_insert0" datasource="#session.DSN#">					  
				insert into RHIConocimiento (RHCid, RHICdescripcion, RHICorden)
				values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHICdescripcion#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHICorden#">)
			</cfquery>
			</cfif>
			<cfset modo = 'CAMBIO'>
			<cfset param = "modo=" & modo>
		<cfelseif isdefined("form.btnDetalleUpd") and len(trim(RHICid)) gt 0><!--- Cambio Detalle--->
		
		 <cf_dbtimestamp
						 datasource="#session.dsn#"
						 table="RHConocimientos"
						 redirect="PuestosConocimientos.cfm"
						 timestamp="#form.ts_rversion#"
						 field1="RHCid" type1 = "numeric" value1="#form.RHCid#" 
						 field2="Ecodigo" type2="numeric" value2="#session.Ecodigo#">
			<cfquery name="ABC_Puestos_update01" datasource="#session.DSN#">
						
					update RHConocimientos
					set RHCcodigo 	= <cfqueryparam cfsqltype="cf_sql_char" value="#ucase(trim(form.RHCcodigo))#">,
					RHCdescripcion 	= <cfqueryparam    cfsqltype="cf_sql_varchar" value="#form.RHCdescripcion#">,
					PCid			= <cfif isdefined('form.PCid') and LEN(TRIM(form.PCid))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#"><cfelse>null</cfif>,
					BMusumod 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					BMfechamod 		= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and RHCid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid#">
				</cfquery>
				
				<cfquery name="rsCuenta2" datasource="#session.DSN#">
					select RHCcodigo, RHCdescripcion, BMusumod, BMfechamod
					from RHConocimientos
					where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
					 and RHCid =  <cfqueryparam value="#form.RHCid#" cfsqltype="cf_sql_numeric">
				</cfquery>
				
			<cfif rsCuenta2.RecordCount gt 0>
				<cfquery name="ABC_Puestos_update02" datasource="#session.DSN#">
						update RHIConocimiento 
						set RHICdescripcion=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHICdescripcion#">, 
						RHICorden=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHICorden#">
						where RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid#">
						and RHICid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHICid#">
				</cfquery>
			</cfif> 
			<cfset modo = 'CAMBIO'>
			<cfset param = "modo=" & modo>
		<cfelseif isdefined("form.borrarDetalle") and len(trim(borrarDetalle)) gt 0><!--- Baja Detalle--->
			<cfquery name="ABC_Puestos_deleteBD" datasource="#session.DSN#">
				delete 
				from RHIConocimiento 
				where RHICid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHICid#">
			</cfquery>
		<cfset modo = 'CAMBIO'>
		<cfset param = "modo=" & modo>

	</cfif>
	<cfcatch type="any">
		<cfinclude template="/sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>	
<cfif modo EQ 'CAMBIO'><cfset param = param & "&RHCid=" & form.RHCid></cfif>
<cflocation url="PuestosConocimientos.cfm?#param#">