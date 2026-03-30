
<cf_templateheader title="Conceptos">

		<script language="JavaScript1.2" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>

		<cfif isdefined("url.DGCid") and not isdefined("form.DGCid")>
			<cfset form.DGCid = url.DGCid >
		</cfif>

		<cfif isdefined("url.tab") and not isdefined("form.tab")>
			<cfset form.tab = url.tab >
		</cfif>
		<cfif not ( isdefined("form.tab") and ListContains('1,2', form.tab) )>
			<cfset form.tab = 1 >
		</cfif> 
		
		
		<cfif isdefined("url.pagenum_lista")>
			<cfset form.pagenum_lista = url.pagenum_lista >
		<cfelse>
			<cfset form.pagenum_lista = 1 >
		</cfif>
		<cfif isdefined("url.filtro_DGCcodigo")	and not isdefined("form.filtro_DGCcodigo")>
			<cfset form.filtro_DGCcodigo = url.filtro_DGCcodigo >
		</cfif>
		<cfif isdefined("url.filtro_DGdescripcion")	and not isdefined("form.filtro_DGdescripcion")>
			<cfset form.filtro_DGdescripcion = url.filtro_DGdescripcion >
		</cfif>
		<cfset params2 = ''>
		<cfif isdefined("form.pagenum_lista")>
			<cfset params2 = params2 & '&pagenum_lista=#form.pagenum_lista#' >
		</cfif>
		<cfif isdefined("form.filtro_DGCcodigo")>
			<cfset params2 = params2 & '&filtro_DGCcodigo=#form.filtro_DGCcodigo#' >
		</cfif>
		<cfif isdefined("form.filtro_DGdescripcion")>
			<cfset params2 = params2 & '&filtro_DGdescripcion=#form.filtro_DGdescripcion#' >
		</cfif>
		<cfif isdefined("form.filtro_DGtipo")>
			<cfset params2 = params2 & '&filtro_DGtipo=#form.filtro_DGtipo#' >
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
				<cf_web_portlet_start border="true" titulo="Conceptos de Estado de Resultados" >
				<cfinclude template="/sif/portlets/pNavegacion.cfm">
				
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr><td align="center" valign="top" >
						<cf_tabs width="99%" >
							<cf_tab text="Conceptos" selected="#form.tab eq 1#">
								<cf_web_portlet_start border="true" titulo="Conceptos de Estado de Resultados" >
									<cfif form.tab eq 1>
										<cfinclude template="conceptos.cfm">
									</cfif>
								<cf_web_portlet_end>
							</cf_tab>

							<cfif isdefined("form.DGCid") and len(trim(form.DGCid))>
								<cf_tab text="Cuentas" selected="#form.tab eq 2#">
									<cf_web_portlet_start border="true" titulo="Cuentas por Concepto" >
										<cfif form.tab eq 2>
											<cfinclude template="conceptoCuentas.cfm">
										</cfif>	
									<cf_web_portlet_end>
								</cf_tab>
							</cfif>
						</cf_tabs>

					</td>
					</tr>
					<TR><td>&nbsp;</td></TR>
				</table>
				
				<cf_web_portlet_end>
			</TD></TR>
		</table>
		
		<cfset params = '' >
		<cfif isdefined("form.DGCid") and len(trim(form.DGCid))>
			<cfset params = '&DGCid=#form.DGCid#'	>
		</cfif>
		
		<script type="text/javascript">
			<!--
			function tab_set_current (n){
				location.href='conceptos-tabs.cfm?tab='+escape(n) + '<cfoutput>#params##params2#</cfoutput>';
			}
			//-->
		</script>
		
		
		
	<cf_templatefooter>