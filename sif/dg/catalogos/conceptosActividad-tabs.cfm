


		<script language="JavaScript1.2" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>

		<cfif isdefined("url.DGAid") and not isdefined("form.DGAid")>
			<cfset form.DGAid = url.DGAid >
		</cfif>
		<cfif isdefined("url.DGCid") and not isdefined("form.DGCid")>
			<cfset form.DGCid = url.DGCid >
		</cfif>
		<cfif isdefined("url.DGCADid") and not isdefined("form.DGCADid")>
			<cfset form.DGCADid = url.DGCADid >
		</cfif>

		<cfif isdefined("url.tab") and not isdefined("form.tab")>
			<cfset form.tab = url.tab >
		</cfif>
		<cfif not ( isdefined("form.tab") and ListContains('1,2', form.tab) )>
			<cfset form.tab = 1 >
		</cfif> 
		
		<cfif isdefined("url.pagenum_lista")>
			<cfset form.pagenum_lista = url.pagenum_lista >
		</cfif>
		<cfif not isdefined("form.pagenum_lista")>
			<cfset form.pagenum_lista = 1 >
		</cfif>
		<cfif isdefined("url.filtro_DGAcodigo")	and not isdefined("form.filtro_DGAcodigo")>
			<cfset form.filtro_DGAcodigo = url.filtro_DGAcodigo >
		</cfif>
		<cfif isdefined("url.filtro_DGAdescripcion")	and not isdefined("form.filtro_DGAdescripcion")>
			<cfset form.filtro_DGAdescripcion = url.filtro_DGAdescripcion >
		</cfif>

		<script language="JavaScript" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>
		<script language="JavaScript" type="text/JavaScript">
		<!--//
			// specify the path where the "/qforms/" subfolder is located
			qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
			// loads all default libraries
			qFormAPI.include("*");
		//-->
		</script>
		
		<table width="100%" cellpadding="0" cellspacing="0" style="vertical-align:bottom; ">
			<TR><TD valign="top">
				<cfinclude template="/sif/portlets/pNavegacion.cfm">
				
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr><td align="center" valign="top" >
						<cf_tabs width="99%" >
							<cf_tab text="Conceptos por Actividad" selected="#form.tab eq 1#">
								<cf_web_portlet_start border="true" titulo="Conceptos por Actividad" >
									<cfif form.tab eq 1>
										<cfinclude template="conceptosActividad-sql.cfm">
									</cfif>
								<cf_web_portlet_end>
							</cf_tab>

							<cfif isdefined("form.DGAid") and len(trim(form.DGAid)) and isdefined("form.DGCADid") and len(trim(form.DGCADid))>
								<cf_tab text="Conceptos" selected="#form.tab eq 2#">
									<cf_web_portlet_start border="true" titulo="Conceptos" >
										<cfif form.tab eq 2>
												HOLA
										</cfif>	
									<cf_web_portlet_end>
								</cf_tab>
							</cfif>
						</cf_tabs>

					</td>
					</tr>
					<TR><td>&nbsp;</td></TR>
				</table>
			</TD></TR>
		</table>
		
		<cfset params = '' >
		<cfif isdefined("form.DGAid") and len(trim(form.DGAid))>
			<cfset params = '&DGAid=#form.DGAid#'	>
		</cfif>
		<cfif isdefined("form.pagenum_lista")>
			<cfset params = params & '&pagenum_lista=#form.pagenum_lista#' >
		</cfif>
		<cfif isdefined("form.filtro_DGAcodigo")>
			<cfset params = params & '&filtro_DGAcodigo=#form.filtro_DGAcodigo#' >
		</cfif>
		<cfif isdefined("form.filtro_DGAdescripcion")>
			<cfset params = params & '&filtro_DGAdescripcion=#form.filtro_DGAdescripcion#' >
		</cfif>