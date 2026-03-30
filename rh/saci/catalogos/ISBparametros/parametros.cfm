<cfif IsDefined('url.tab') and url.tab eq 'export'>
<cfinclude template="parametros-export.cfm">
<cfabort>
</cfif>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>

<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>

	<br />
	<cfinclude template="parametros-params.cfm">
	<cfinclude template="parametros-config.cfm">
		<cf_tabs width="100%">
			<cf_tab text="Generales" selected="#form.tab eq 1#" id="1">
				<div style="vertical-align:top;">
					<cfif form.tab eq 1>
						<cfinclude template="parametros-generales.cfm">
					</cfif>
				</div>
			</cf_tab>
			<cf_tab text="Web Services" selected="#form.tab eq 2#" id="2">
				<div style="vertical-align:top;">
					<cfif form.tab eq 2>
						<cfinclude template="parametros-ws.cfm">
					</cfif>
				</div>
			</cf_tab>
			<cf_tab text="Medios" selected="#form.tab eq 3#" id="3">
				<div style="vertical-align:top;">
					<cfif form.tab eq 3>
						<cfinclude template="parametros-medios.cfm">
					</cfif>
				</div>
			</cf_tab>
			<cf_tab text="Interfaces" selected="#form.tab eq 4#" id="4">
				<div style="vertical-align:top;">
					<cfif form.tab eq 4>
						<cfinclude template="parametros-interfaz.cfm">
					</cfif>
				</div>
			</cf_tab>
			<cf_tab text="LDAP" id="ldap" selected="#form.tab eq 'ldap'#">
				<div style="vertical-align:top;">
					<cfif form.tab eq 'ldap'>
						<cfinclude template="parametros-ldap.cfm">
					</cfif>
				</div>
			</cf_tab>
			<cf_tab text="Exportar" id="export" selected="#form.tab eq 'export'#">
				<div style="vertical-align:top;">
					ooops!
				</div>
			</cf_tab>
			
		</cf_tabs>	
	<br/>

	<script type="text/javascript" language="javascript">
		function tab_set_current (n) {
			var params = '';
			
			<cfoutput>
			location.href = '#CurrentPage#?tab='+escape(n)+params;
			</cfoutput>										
		}
	</script>

<cf_templatefooter>

