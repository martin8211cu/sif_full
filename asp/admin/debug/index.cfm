<cfsetting showdebugoutput="no">
<cfset tab_ids = 'config,request,query,tmplsummary,exception'>
<cfset tab_text = 'Configuración,Peticiones,Consultas,Páginas,Excepciones'>
<cfparam name="url.tab" default="-default-">
<cfif Not ListFind(tab_ids, url.tab)>
	<cfset url.tab=ListFirst(tab_ids)>
</cfif>
<cf_templateheader title="Información de depuración">
	<cf_tabs width="900">
		<cfloop from="1" to="#ListLen(tab_ids)#" index="ntab">
			<cf_tab id='#ListGetAt(tab_ids, ntab)#' text='#ListGetAt(tab_text, ntab)#' selected="#url.tab is ListGetAt(tab_ids, ntab)#">
				<cfif url.tab is ListGetAt(tab_ids, ntab)>
					<cfinclude template="#ListGetAt(tab_ids, ntab)#-form.cfm">
				</cfif>
			</cf_tab>
		</cfloop>
	</cf_tabs>

	<script type="text/javascript">
	function tab_set_current (tabname){
		location.replace('index.cfm?tab=' + tabname);
	}
	</script>
	
<cf_templatefooter>