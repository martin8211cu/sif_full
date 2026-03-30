<cf_templateHeader title ="Distribuciones">
	<cfinclude template="/home/menu/pNavegacion.cfm">
	<cf_web_portlet_start titulo="Distribuciones">
		<cf_templatecss>
		<link href="../../css/rh.css" rel="stylesheet" type="text/css">
		<script  language="JavaScript" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>
		<script language="JavaScript" type="text/JavaScript">
		<!--
		function MM_reloadPage(init) {  //reloads the window if Nav4 resized
		  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
			document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
		  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
		}
		MM_reloadPage(true);
		//-->
		</script>
		<script language="JavaScript1.2" src="../../js/utilesMonto.js"></script>
		
		<cfinclude template="../../Utiles/params.cfm">
		
		
			<table width="100%" cellpadding="2" cellspacing="0">
			  <tr>
				<td valign="top">
				
				  
					  <!--- variables para el portlet de navegación 
					  <cfset regresar = "/cfmx/rh/indexEstructura.cfm">
					  <cfset navBarItems = ArrayNew(1)>
					  <cfset navBarLinks = ArrayNew(1)>
					  <cfset navBarStatusText = ArrayNew(1)>
					  <cfset navBarItems[1] = "Estructura Organizacional">
					  <cfset navBarLinks[1] = "/cfmx/rh/indexEstructura.cfm">
					  <cfset navBarStatusText[1] = "/cfmx/rh/indexEstructura.cfm">
					  <cfinclude template="../../portlets/pNavegacion.cfm">--->
					  
						<!--- ******************************************************************** --->
					  <cfif isdefined("url.tab") and not isdefined("form.tab")>
						<cfset form.tab = url.tab>
					  </cfif>
					  <cfif not ( isdefined("form.tab") and ListContains('1,2,3', form.tab) )>
						<cfset form.tab = 1>
					  </cfif>
					  <cfif  isdefined("url.IDdistribucion") and len(trim(url.IDdistribucion))NEQ 0>
						<cfset form.IDdistribucion = url.IDdistribucion>
					  </cfif>
					  
					  <cfif not isdefined("form.nuevo") and not isdefined("form.BTNNUEVO")>
		
							<cfif  isdefined("form.IDdistribucion") and len(trim(form.IDdistribucion))NEQ 0>
								<cfset modo = "Cambio">
							</cfif>
					   <cfelse>
							<cfset modo = "Alta">     
					  </cfif>
					  
					<cfquery name="rsOficinas" datasource="#session.DSN#">
						select Ocodigo, Oficodigo, Odescripcion
						  from Oficinas
						 where Ecodigo = #session.Ecodigo#
						 order by Oficodigo
					</cfquery>		
					
					<cfif isdefined("Url.IDgd") and Url.IDgd neq "" and not isdefined("form.IDgd")>
						<cfset form.IDgd = Url.IDgd>
					</cfif>
		
					<cfquery name="rsGrupo" datasource="#session.DSN#">
						select DCdescripcion
						from DCGDistribucion
						where IDgd = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDgd#">
					</cfquery>
					
					<cfset G_Dist = rsGrupo.DCdescripcion>				  
		 
					<table align="center" width="100%" cellpadding="0" cellspacing="0">
					<tr>
						<td class="tituloListas">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<strong>Distribuciones dentro del Grupo:</strong> <cfoutput>#G_Dist#</cfoutput>
						</td>
					</tr>
					<tr><td class="tituloListas">&nbsp;</td></tr>			 
					</table>
		
					<cf_tabs width="99%">
						<cf_tab text="Distribuciones" selected="#form.tab eq 1#">
		
								<cfinclude template="formDistribuciones.cfm">
		
						</cf_tab>
						
						<cfif modo NEQ "Alta">
							
							
							<!--- Verifica el Tipo de Distribucion --->
							<cfquery name="rsTipo" datasource="#session.DSN#">
								select Tipo
								from DCDistribucion
								where IDgd = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDgd#">
								  and IDdistribucion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDdistribucion#">
							</cfquery>							

							<cfif rsTipo.Recordcount gt 0 and rsTipo.Tipo eq 5>

								<cf_tab text="Cuentas Origen" selected="#form.tab eq 2#">
								
										<cfset usaConductor = 1>
										<cfinclude template="formCtasOriginales.cfm">
								
								</cf_tab>

							
							<cfelse>
							
								<cf_tab text="Cuentas Origen" selected="#form.tab eq 2#">
								
										<cfinclude template="formCtasOriginales.cfm">
								
								</cf_tab>
								
								<cf_tab text="Cuentas Destino" selected="#form.tab eq 3#">
								
										  <cfinclude template="formCtasDestino.cfm">
								
								</cf_tab>
								
							</cfif>		
						</cfif>
					</cf_tabs>
					
					  <!--- ******************************************************************** --->
					  
				  
				</td>
			  </tr>
			</table>
		<script language="JavaScript1.2">
		
			function fnRight(LprmHilera, LprmLong)
			{
				var LvarTot = LprmHilera.length;
				return LprmHilera.substring(LvarTot-LprmLong,LvarTot);
			}
		</script>
	<cf_web_portlet_end>
<cf_templatefooter>