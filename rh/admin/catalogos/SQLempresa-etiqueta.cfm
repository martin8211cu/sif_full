<cfif Form.modo EQ "CAMBIO">
	<cfset modo="CAMBIO">				
<cfelse>
	<cfset modo="ALTA">
</cfif>

<cftransaction>
	<cftry>
			<cfif not isdefined('form.btnCambiar') and modo EQ "ALTA">
				<!--- Datos Variables del Empleado --->
				<cfloop index = "LoopCount" from = "1" to = "7">
					<cfquery name="ABC_DocumInsert1" datasource="#Session.DSN#">
						insert into RHEtiquetasEmpresa 
						(Ecodigo, RHEcol, RHEtiqueta, RHdisplay, RHrequerido, RHEdesp)
						values (	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
									'DEdato<cfoutput>#LoopCount#</cfoutput>',
									'Dato variable <cfoutput>#LoopCount#</cfoutput> del empleado ',		
									1,
									0,
									'Dato variable <cfoutput>#LoopCount#</cfoutput> del empleado') 
					</cfquery>
				</cfloop>
				<cfloop index = "LoopCount" from = "1" to = "5">
					<cfquery name="ABC_DocumInsert2" datasource="#Session.DSN#">					
						insert into RHEtiquetasEmpresa 
						(Ecodigo, RHEcol, RHEtiqueta, RHdisplay, RHrequerido, RHEdesp)
						values (	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
									'DEobs<cfoutput>#LoopCount#</cfoutput>',
									'Observacion variable <cfoutput>#LoopCount#</cfoutput> del empleado',		
									1,
									0,
									'Observacion variable <cfoutput>#LoopCount#</cfoutput> del empleado') 
					</cfquery>
				</cfloop>				
				<cfloop index = "LoopCount" from = "1" to = "5">
					<cfquery name="ABC_DocumInsert3" datasource="#Session.DSN#">				
						insert into RHEtiquetasEmpresa 
						(Ecodigo, RHEcol, RHEtiqueta, RHdisplay, RHrequerido, RHEdesp)
						values (	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
									'DEinfo<cfoutput>#LoopCount#</cfoutput>',
									'Informacion variable <cfoutput>#LoopCount#</cfoutput> del empleado',		
									1,
									0,
									'Informacion variable <cfoutput>#LoopCount#</cfoutput> del empleado') 
					</cfquery>
				</cfloop>
				
				<!--- Datos Variables de Familiares --->	
				<cfloop index = "LoopCount" from = "1" to = "3">
					<cfquery name="ABC_DocumInsert4" datasource="#Session.DSN#">				
						insert into RHEtiquetasEmpresa 
						(Ecodigo, RHEcol, RHEtiqueta, RHdisplay, RHrequerido, RHEdesp)
						values (	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
									'FEdatos<cfoutput>#LoopCount#</cfoutput>',
									'Dato variable <cfoutput>#LoopCount#</cfoutput> de familiares',		
									1,
									0,
									'Dato variable <cfoutput>#LoopCount#</cfoutput> de familiares') 
					</cfquery>
				</cfloop>
				<cfloop index = "LoopCount" from = "1" to = "2">
					<cfquery name="ABC_DocumInsert5" datasource="#Session.DSN#">				
						insert into RHEtiquetasEmpresa 
						(Ecodigo, RHEcol, RHEtiqueta, RHdisplay, RHrequerido, RHEdesp)
						values (	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
									'FEobs<cfoutput>#LoopCount#</cfoutput>',
									'Observacion variable <cfoutput>#LoopCount#</cfoutput> de familiares',		
									1,
									0,
									'Observacion variable <cfoutput>#LoopCount#</cfoutput> de familiares') 
					</cfquery>
				</cfloop>				
				<cfloop index = "LoopCount" from = "1" to = "2">
					<cfquery name="ABC_DocumInsert6" datasource="#Session.DSN#">				
						insert into RHEtiquetasEmpresa 
						(Ecodigo, RHEcol, RHEtiqueta, RHdisplay, RHrequerido, RHEdesp)
						values (	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
									'FEinfo<cfoutput>#LoopCount#</cfoutput>',
									'Informacion variable <cfoutput>#LoopCount#</cfoutput> de familiares',		
									1,
									0,
									'Informacion variable <cfoutput>#LoopCount#</cfoutput> de familiares') 
					</cfquery>
				</cfloop>									
				<cfset modo="CAMBIO">
				
			<cfelseif isdefined('form.btnCambiar') and modo EQ "CAMBIO">
				<cfloop index = "LoopCount" from = "1" to = "7">	<!--- Para los datos variables del empleado --->				
					<cfset nombreDEdato = "DEdato" & #LoopCount#>
					<cfset nombreColEtiq = Evaluate("form.RHdato_#LoopCount#_RHEtiq")>
					<cfquery name="ABC_DocumUpdate1" datasource="#Session.DSN#">
						update RHEtiquetasEmpresa set
							RHEtiqueta 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#nombreColEtiq#">,						
							<cfif isdefined('form.RHdato_#LoopCount#_ckRHdisplay')>
								RHdisplay 	= 1,						
							<cfelse>
								RHdisplay 	= 0,						
							</cfif>
							<cfif isdefined('form.RHdato_#LoopCount#_ckRHreq')>
								RHrequerido	= 1											
							<cfelse>
								RHrequerido	= 0						
							</cfif>						
							
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and RHEcol= <cfqueryparam cfsqltype="cf_sql_varchar" value="#nombreDEdato#">
					</cfquery>
				</cfloop>
				
				<cfloop index = "LoopCount" from = "1" to = "5">	<!--- Para la informacion variable del empleado --->				
					<cfset nombreDEinfo = "DEinfo" & #LoopCount#>
					<cfset nombreColEtiq = Evaluate("form.RHinfo_#LoopCount#_RHEtiq")>
					<cfquery name="ABC_DocumUpdate2" datasource="#Session.DSN#">
						update RHEtiquetasEmpresa set
							RHEtiqueta 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#nombreColEtiq#">,						
							<cfif isdefined('form.RHinfo_#LoopCount#_ckRHdisplay')>
								RHdisplay 	= 1,						
							<cfelse>
								RHdisplay 	= 0,						
							</cfif>
							<cfif isdefined('form.RHinfo_#LoopCount#_ckRHreq')>
								RHrequerido	= 1											
							<cfelse>
								RHrequerido	= 0						
							</cfif>						
							
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and RHEcol= <cfqueryparam cfsqltype="cf_sql_varchar" value="#nombreDEinfo#">
					</cfquery>
				</cfloop>
				
				<cfloop index = "LoopCount" from = "1" to = "5">	<!--- Para las observaciones variables del empleado --->				
					<cfset nombreDEobs = "DEobs" & #LoopCount#>
					<cfset nombreColEtiq = Evaluate("form.RHobs_#LoopCount#_RHEtiq")>
					<cfquery name="ABC_DocumUpdate3" datasource="#Session.DSN#">
						update RHEtiquetasEmpresa set
							RHEtiqueta 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#nombreColEtiq#">,						
							<cfif isdefined('form.RHobs_#LoopCount#_ckRHdisplay')>
								RHdisplay 	= 1,						
							<cfelse>
								RHdisplay 	= 0,						
							</cfif>
							<cfif isdefined('form.RHobs_#LoopCount#_ckRHreq')>
								RHrequerido	= 1											
							<cfelse>
								RHrequerido	= 0						
							</cfif>						
							
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and RHEcol= <cfqueryparam cfsqltype="cf_sql_varchar" value="#nombreDEobs#">
					</cfquery>
				</cfloop>		
				
				<cfloop index = "LoopCount" from = "1" to = "3">	<!--- Para los datos variables del familiar --->				
					<cfset nombreFEdato = "FEdatos" & #LoopCount#>
					<cfset nombreColEtiq = Evaluate("form.FEdatos_#LoopCount#_RHEtiq")>
					<cfquery name="ABC_DocumUpdate3" datasource="#Session.DSN#">
						update RHEtiquetasEmpresa set
							RHEtiqueta 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#nombreColEtiq#">,						
							<cfif isdefined('form.FEdatos_#LoopCount#_ckRHdisplay')>
								RHdisplay 	= 1,						
							<cfelse>
								RHdisplay 	= 0,						
							</cfif>
							<cfif isdefined('form.FEdatos_#LoopCount#_ckRHreq')>
								RHrequerido	= 1											
							<cfelse>
								RHrequerido	= 0						
							</cfif>						
							
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and RHEcol= <cfqueryparam cfsqltype="cf_sql_varchar" value="#nombreFEdato#">
					</cfquery>
				</cfloop>										

				<cfloop index = "LoopCount" from = "1" to = "2">	<!--- Para la informacion variable del familiar --->				
					<cfset nombreFEinfo = "FEinfo" & #LoopCount#>
					<cfset nombreColEtiq = Evaluate("form.FEinfo_#LoopCount#_RHEtiq")>
					<cfquery name="ABC_DocumUpdate4" datasource="#Session.DSN#">
						update RHEtiquetasEmpresa set
							RHEtiqueta 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#nombreColEtiq#">,						
							<cfif isdefined('form.FEinfo_#LoopCount#_ckRHdisplay')>
								RHdisplay 	= 1,						
							<cfelse>
								RHdisplay 	= 0,						
							</cfif>
							<cfif isdefined('form.FEinfo_#LoopCount#_ckRHreq')>
								RHrequerido	= 1											
							<cfelse>
								RHrequerido	= 0						
							</cfif>						
							
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and RHEcol= <cfqueryparam cfsqltype="cf_sql_varchar" value="#nombreFEinfo#">
					</cfquery>
				</cfloop>										

				<cfloop index = "LoopCount" from = "1" to = "2">	<!--- Para las observaciones variables del familiar --->				
					<cfset nombreFEobs = "FEobs" & #LoopCount#>
					<cfset nombreColEtiq = Evaluate("form.FEobs_#LoopCount#_RHEtiq")>
					<cfquery name="ABC_DocumUpdate5" datasource="#Session.DSN#">
						update RHEtiquetasEmpresa set
							RHEtiqueta 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#nombreColEtiq#">,						
							<cfif isdefined('form.FEobs_#LoopCount#_ckRHdisplay')>
								RHdisplay 	= 1,						
							<cfelse>
								RHdisplay 	= 0,						
							</cfif>
							<cfif isdefined('form.FEobs_#LoopCount#_ckRHreq')>
								RHrequerido	= 1											
							<cfelse>
								RHrequerido	= 0						
							</cfif>						
							
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and RHEcol= <cfqueryparam cfsqltype="cf_sql_varchar" value="#nombreFEobs#">
					</cfquery>
				</cfloop>
				
				<cfset modo="CAMBIO">
			</cfif>
	<cfcatch type="any">
		<cfinclude template="/cfmx/sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cftransaction>	

<form action="empresa-etiqueta.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
