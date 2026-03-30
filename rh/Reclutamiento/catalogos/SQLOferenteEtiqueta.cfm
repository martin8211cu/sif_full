
<cfif Form.modo EQ "CAMBIO">
	<cfset modo="CAMBIO">				
<cfelse>
	<cfset modo="ALTA">
</cfif>

<cftransaction>
	<cftry>
			<cfif not isdefined('form.btnCambiar') and modo EQ "ALTA">
				<!--- Datos Variables del oferente --->
				<cfloop index = "LoopCount" from = "1" to = "5">
					<cfquery name="ABC_DocumInsert1" datasource="#Session.DSN#">
						insert into RHEtiquetasOferente
						(Ecodigo, RHEcol, RHEtiqueta, RHdisplay, RHrequerido, RHcorporativo,RHEdesp)
						values (	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
									'RHOdato<cfoutput>#LoopCount#</cfoutput>',
									'Dato variable <cfoutput>#LoopCount#</cfoutput> del oferente ',		
									1,
									0,
                                    0,
									'Dato variable <cfoutput>#LoopCount#</cfoutput> del oferente') 
					</cfquery>
				</cfloop>
				<cfloop index = "LoopCount" from = "1" to = "3">
					<cfquery name="ABC_DocumInsert2" datasource="#Session.DSN#">					
						insert into RHEtiquetasOferente
						(Ecodigo, RHEcol, RHEtiqueta, RHdisplay, RHrequerido, RHcorporativo,RHEdesp)
						values (	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
									'RHOobs<cfoutput>#LoopCount#</cfoutput>',
									'Observacion variable <cfoutput>#LoopCount#</cfoutput> del oferente',		
									1,
									0,
                                    0,
									'Observacion variable <cfoutput>#LoopCount#</cfoutput> del oferente') 
					</cfquery>
				</cfloop>				
				<cfloop index = "LoopCount" from = "1" to = "3">
					<cfquery name="ABC_DocumInsert3" datasource="#Session.DSN#">				
						insert into RHEtiquetasOferente
						(Ecodigo, RHEcol, RHEtiqueta, RHdisplay, RHrequerido,RHcorporativo, RHEdesp)
						values (	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
									'RHOinfo<cfoutput>#LoopCount#</cfoutput>',
									'Informacion variable <cfoutput>#LoopCount#</cfoutput> del oferente',		
									1,
									0,
                                    0,
									'Informacion variable <cfoutput>#LoopCount#</cfoutput> del oferente') 
					</cfquery>
				</cfloop>
				<cfset modo="CAMBIO">
			<cfelseif isdefined('form.btnCambiar') and modo EQ "CAMBIO">
				<cfloop index = "LoopCount" from = "1" to = "5">	<!--- Para los datos variables del oferente --->				
					<cfset nombreRHOdato = "RHOdato" & #LoopCount#>
					<cfset nombreColEtiq = Evaluate("form.RHdato_#LoopCount#_RHEtiq")>
					<cfquery name="ABC_DocumUpdate1" datasource="#Session.DSN#">
						update RHEtiquetasOferente set
							RHEtiqueta 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#nombreColEtiq#">,						
							<cfif isdefined('form.RHdato_#LoopCount#_ckRHdisplay')>
								RHdisplay 	= 1,						
							<cfelse>
								RHdisplay 	= 0,						
							</cfif>
							<cfif isdefined('form.RHdato_#LoopCount#_ckRHreq')>
								RHrequerido	= 1,											
							<cfelse>
								RHrequerido	= 0	,					
							</cfif>	
                            
                            <cfif isdefined('form.RHdato_#LoopCount#_ckRHcp')>
								RHcorporativo	= 1											
							<cfelse>
								RHcorporativo	= 0						
							</cfif>						
							
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and RHEcol= <cfqueryparam cfsqltype="cf_sql_varchar" value="#nombreRHOdato#">
					</cfquery>
                    
                     <cf_translatedata name="set" tabla="RHEtiquetasOferente" col="RHEtiqueta" valor="#nombreColEtiq#" 
                     filtro=" Ecodigo= #session.Ecodigo# and RHEcol ='#trim(nombreRHOdato)#' ">
				</cfloop>
				
				<cfloop index = "LoopCount" from = "1" to = "3">	<!--- Para la informacion variable del oferente --->				
					<cfset nombreRHOinfo = "RHOinfo" & #LoopCount#>
					<cfset nombreColEtiq = Evaluate("form.RHinfo_#LoopCount#_RHEtiq")>
					<cfquery name="ABC_DocumUpdate2" datasource="#Session.DSN#">
						update RHEtiquetasOferente set
							RHEtiqueta 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#nombreColEtiq#">,						
							<cfif isdefined('form.RHinfo_#LoopCount#_ckRHdisplay')>
								RHdisplay 	= 1,						
							<cfelse>
								RHdisplay 	= 0,						
							</cfif>
							<cfif isdefined('form.RHinfo_#LoopCount#_ckRHreq')>
								RHrequerido	= 1,									
							<cfelse>
								RHrequerido	= 0	,					
							</cfif>
                            
                            <cfif isdefined('form.RHinfo_#LoopCount#_ckRHcp')>
								RHcorporativo	= 1											
							<cfelse>
								RHcorporativo	= 0						
							</cfif>						
							
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and RHEcol= <cfqueryparam cfsqltype="cf_sql_varchar" value="#nombreRHOinfo#">
					</cfquery>
                      <cf_translatedata name="set" tabla="RHEtiquetasOferente" col="RHEtiqueta" valor="#nombreColEtiq#" 
                     filtro=" Ecodigo= #session.Ecodigo# and RHEcol ='#trim(nombreRHOinfo)#' ">
				</cfloop>
				
				<cfloop index = "LoopCount" from = "1" to = "3">	<!--- Para las observaciones variables del oferente --->				
					<cfset nombreRHOobs = "RHOobs" & #LoopCount#>
					<cfset nombreColEtiq = Evaluate("form.RHobs_#LoopCount#_RHEtiq")>
					<cfquery name="ABC_DocumUpdate3" datasource="#Session.DSN#">
						update RHEtiquetasOferente set
							RHEtiqueta 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#nombreColEtiq#">,						
							<cfif isdefined('form.RHobs_#LoopCount#_ckRHdisplay')>
								RHdisplay 	= 1,						
							<cfelse>
								RHdisplay 	= 0,						
							</cfif>
							<cfif isdefined('form.RHobs_#LoopCount#_ckRHreq')>
								RHrequerido	= 1,											
							<cfelse>
								RHrequerido	= 0,						
							</cfif>						
							<cfif isdefined('form.RHobs_#LoopCount#_ckRHcp')>
								RHcorporativo	= 1											
							<cfelse>
								RHcorporativo	= 0						
							</cfif>						
                            
                            
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and RHEcol= <cfqueryparam cfsqltype="cf_sql_varchar" value="#nombreRHOobs#">
					</cfquery>
                      <cf_translatedata name="set" tabla="RHEtiquetasOferente" col="RHEtiqueta" valor="#nombreColEtiq#" 
                     filtro=" Ecodigo= #session.Ecodigo# and RHEcol ='#trim(nombreRHOobs)#' ">
				</cfloop>		
				
				<cfset modo="CAMBIO">
                

				<!---se actaulizan todas las empressas con los valores que esten marcados como corporativos--->
                <cfquery name="ABC_DocumUpdate3" datasource="#Session.DSN#">
                    update RHEtiquetasOferente set RHcorporativo = 
                                                    (select coalesce(RHcorporativo,0)
                                                    from RHEtiquetasOferente a
                                                    where Ecodigo = #session.Ecodigo#
                                                        and a.RHEcol = RHEtiquetasOferente.RHEcol)
                                                        
                                                   , RHEtiqueta = 
                                                    (select RHEtiqueta
                                                    from RHEtiquetasOferente a
                                                    where Ecodigo = #session.Ecodigo#
                                                        and a.RHEcol = RHEtiquetasOferente.RHEcol)
                                                        
                                                    , RHrequerido = 
                                                    (select RHrequerido
                                                    from RHEtiquetasOferente a
                                                    where Ecodigo = #session.Ecodigo#
                                                        and a.RHEcol = RHEtiquetasOferente.RHEcol)         
                                                        
                    where Ecodigo in ( select Ereferencia
                                        from Empresa
                                        where CEcodigo = #session.CEcodigo#
                                        )
              	</cfquery>
    
                    
                
                
			</cfif>
	<cfcatch type="any">
		<cfinclude template="/errorPages/Bderror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cftransaction>	

<form action="OferenteEtiqueta.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
