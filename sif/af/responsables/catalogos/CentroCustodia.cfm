<!---  --->
<cf_templateheader title="Centro de Custodia">
		<cf_templatecss>

		<cfif isdefined("url.CRCCid") and not isdefined("form.CRCCid")>
			<cfset form.CRCCid = url.CRCCid >
		</cfif>
		<cfif isdefined("url.tab") and not isdefined("form.tab")>
			<cfset form.tab = url.tab >
		</cfif>
		<cfif not ( isdefined("form.tab") and ListContains('1,2,3,4', form.tab) )>
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
		<script language="javascript" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>		
		
		<table width="100%" cellpadding="0" cellspacing="0" style="vertical-align:top; ">
			<TR><TD valign="top">
				<cf_web_portlet_start border="true" titulo="Centro de Custodia" skin="#Session.Preferences.Skin#">
				<cfinclude template="/home/menu/pNavegacion.cfm">
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<cfif isdefined("form.CRCCid") and len(trim(form.CRCCid))>
						<cfquery name="RSCustodia" datasource="#session.DSN#">
							select CRCCcodigo,CRCCdescripcion 
							from CRCentroCustodia
							where  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
							and CRCCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CRCCid#">							
						</cfquery>
						<cfoutput>
							<tr><td>
							<table width="100%" cellpadding="5" cellspacing="0" bgcolor="##CCCCCC" border="0" style="border:1px solid black">
								<tr><td align="center" valign="middle">
									<font size="3" color="##003399">
									<strong>Centro de Custodia :&nbsp;#trim(RSCustodia.CRCCcodigo)# - #RSCustodia.CRCCdescripcion#</strong></font></td></tr>
							</table>
							</td></tr>
						</cfoutput>
					</cfif>
					<tr><td>&nbsp;</td></tr>
					<tr><td align="center">
						<cf_tabs width="100%" onclick="tab_set_current_inst">
							<cf_tab text="Centro de Custodia" id="1" selected="#form.tab eq 1#">
								<cfif form.tab eq 1 >
									<cfinclude template="CentroCustodia-form.cfm">
								</cfif>
							</cf_tab>
							<cfif isdefined("form.CRCCid") and len(trim(form.CRCCid))>
								<cf_tab text="Centros Funcionales" id="2" selected="#form.tab eq 2#">
									<cfif form.tab eq 2 >
									<cfinclude template="CentrosF-Custodia.cfm">
									</cfif>
								</cf_tab>
								<cf_tab text="Usuarios" id="3" selected="#form.tab eq 3#">
									<cfif form.tab eq 3 >
										<cfinclude template="Usuarios-Custodia.cfm">
									</cfif>
								</cf_tab>
								<cf_tab text="Clasificación" id="4" selected="#form.tab eq 4#">
									<cfif form.tab eq 4 >
										<cfinclude template="Clasificacion-Custodia.cfm">
									</cfif>
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

		<script type="text/javascript">
			<!--
			function tab_set_current_inst (n){
				<cfif isdefined("form.CRCCid") and len(trim(form.CRCCid))>
					location.href='CentroCustodia.cfm?CRCCid=<cfoutput>#JSStringFormat(form.CRCCid)#</cfoutput>&tab='+escape(n);
				</cfif>
			}
			//-->
		</script>
	<cf_templatefooter>