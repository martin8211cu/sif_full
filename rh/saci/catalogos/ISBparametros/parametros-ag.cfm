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
	<cfinclude template="parametros-ag-params.cfm">
	<cfinclude template="parametros-config.cfm">
		<cf_tabs width="100%">
			<cf_tab text="Agentes" selected="#form.tab eq 1#" id="1">
				<div style="vertical-align:top;">
					<cfif form.tab eq 1>
						<cfinclude template="parametros-agentes.cfm">
					</cfif>
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

