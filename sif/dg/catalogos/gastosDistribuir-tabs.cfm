
<cf_templateheader title="Actividades">

		<script language="JavaScript1.2" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>

		<cfif isdefined("url.DGGDid") and not isdefined("form.DGGDid")>
			<cfset form.DGGDid = url.DGGDid >
		</cfif>
		
		<cfif isdefined("url.pagenum_lista")>
			<cfset form.pagenum_lista = url.pagenum_lista >
		<cfelse>
			<cfset form.pagenum_lista = 1 >
		</cfif>
		<cfif isdefined("url.filtro_DGGDcodigo")	and not isdefined("form.filtro_DGGDcodigo")>
			<cfset form.filtro_DGGDcodigo = url.filtro_DGGDcodigo >
		</cfif>
		<cfif isdefined("url.filtro_DGGDdescripcion")	and not isdefined("form.filtro_DGGDdescripcion")>
			<cfset form.filtro_DGGDdescripcion = url.filtro_DGGDdescripcion >
		</cfif>
		<cfif isdefined("url.filtro_DGCDcodigo")	and not isdefined("form.filtro_DGCDcodigo")>
			<cfset form.filtro_DGCDcodigo = url.filtro_DGCDcodigo >
		</cfif>
		<cfif isdefined("url.filtro_DGCDdescripcion")	and not isdefined("form.filtro_DGCDdescripcion")>
			<cfset form.filtro_DGCDdescripcion = url.filtro_DGCDdescripcion >
		</cfif>

		<cfif isdefined("url.tab") and not isdefined("form.tab")>
			<cfset form.tab = url.tab >
		</cfif>
		<cfif not ( isdefined("form.tab") and ListContains('1,2,3', form.tab) )>
			<cfset form.tab = 1 >
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
				<cf_web_portlet_start border="true" titulo="Gastos por Distribuir" >
				<cfinclude template="/sif/portlets/pNavegacion.cfm">
				
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr><td align="center" valign="top" >
						<cf_tabs width="99%">
							<cf_tab text="Gastos por Distribuir" selected="#form.tab eq 1#">
								<!---<cf_web_portlet border="true" titulo="Gastos por Distribuir" >--->
									<cfinclude template="gastosDistribuir.cfm">
								<!---</cf_web_portlet>--->
							</cf_tab>

							<cfif isdefined("form.DGGDid") and len(trim(form.DGGDid))>
								<cf_tab text="Departamentos" selected="#form.tab eq 2#">
									<!---<cf_web_portlet border="true" titulo="Departamentos" >--->
										<cfinclude template="DeptosGastosDistribuir.cfm">
									<!---</cf_web_portlet>--->
								</cf_tab>
								<cf_tab text="Actividades" selected="#form.tab eq 3#">
									<!---<cf_web_portlet border="true" titulo="Actividades" >--->
										<cfinclude template="gastosActividad.cfm">
									<!---</cf_web_portlet>--->
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
		
		<cfset params = '?tab=#form.tab#' >
		<cfif isdefined("form.pagenum_lista")>
			<cfset params = params & '&pagenum_lista=#form.pagenum_lista#' >
		</cfif>
		<cfif isdefined("form.filtro_DGGDcodigo")>
			<cfset params = params & '&filtro_DGGDcodigo=#form.filtro_DGGDcodigo#' >
		</cfif>
		<cfif isdefined("form.filtro_DGGDdescripcion")>
			<cfset params = params & '&filtro_DGGDdescripcion=#form.filtro_DGGDdescripcion#' >
		</cfif>
		
		<script type="text/javascript">
			<!--

			function tab_set_current2(n){
				location.href='gastosDistribuir-tabs.cfm?tab='+escape(n) + '<cfoutput>#params#</cfoutput>';
			}
			//-->
			
			function funcRegresar(){
				location.href = 'gastosDistribuir-lista.cfm';
				return false;
			}
		</script>
		
	<cf_templatefooter>