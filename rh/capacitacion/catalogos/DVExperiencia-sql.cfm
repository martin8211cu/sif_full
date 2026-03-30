<!--- <cf_dump var="#form#"> --->
<cftransaction>
		<cfif not isdefined('form.btnCambiar') and modo EQ "ALTA">
			<!--- Datos Variables del Empleado --->
			<cfloop index = "LoopCount" from = "1" to = "10">
				<cfquery name="ABC_DocumInsert1" datasource="#Session.DSN#">
					insert into RHDVExperiencia 
					(Ecodigo, RHDVEcol, RHDVEDatoV, RHDVEdisplay, RHDVErequerido, RHDVEdesp,RHDVEorden,BMUsucodigo,BMfecha)
					values (	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
								'RHEEDV<cfoutput>#LoopCount#</cfoutput>',
								'Dato variable <cfoutput>#LoopCount#</cfoutput> del empleado ',		
								1,
								0,
								'Dato variable <cfoutput>#LoopCount#</cfoutput> del empleado',
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#LoopCount#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">) 
				</cfquery>
			</cfloop>
			<cfset modo="CAMBIO">
			
		<cfelseif isdefined('form.btnCambiar') and modo EQ "CAMBIO">
			<cfloop index = "LoopCount" from = "1" to = "10">	<!--- Para los datos variables del empleado --->				
				<cfset nombreDEdato = "RHEEDV" & #LoopCount#>
				<cfset nombreColEtiq = Evaluate("form.RHdato_#LoopCount#_RHEtiq")>
				<cfquery name="ABC_DocumUpdate1" datasource="#Session.DSN#">
					update RHDVExperiencia set
							RHDVEDatoV 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#nombreColEtiq#">,						
							RHDVEdisplay =	 <cfif isdefined('form.RHdato_#LoopCount#_ckRHdisplay')>1<cfelse>0</cfif>,						
							RHDVErequerido	= <cfif isdefined('form.RHdato_#LoopCount#_ckRHreq')>1<cfelse>0	</cfif>,													
							BMUsucodigo		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
							BMfecha			= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and RHDVEcol= <cfqueryparam cfsqltype="cf_sql_varchar" value="#nombreDEdato#">
				</cfquery>
			</cfloop>
			
			<cfset modo="CAMBIO">
		</cfif>
</cftransaction>	
<cflocation url="DVExperiencia.cfm?modo=#modo#">