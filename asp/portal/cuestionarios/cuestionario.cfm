<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RegistrodeCuestionarios"
	Default="Registro de Cuestionarios"
	returnvariable="LB_RegistrodeCuestionarios"/>
<cf_templateheader title="#LB_RegistrodeCuestionarios#">
<cf_web_portlet_start titulo="#LB_RegistrodeCuestionarios#">
	<cfif isdefined("url.PCid") and not isdefined("form.PCid")>
		<cfset form.PCid = url.PCid >
	</cfif>
	<cfif isdefined("url.PPparte") and not isdefined("form.PPparte")>
		<cfset form.PPparte = url.PPparte >
	</cfif>
	<cfif isdefined("url.PPid") and not isdefined("form.PPid")>
		<cfset form.PPid = url.PPid >
	</cfif>
	<cfhtmlhead text="<link type='text/css' rel='stylesheet' href='/cfmx/asp/css/asp.css'>">
 <cfif not isdefined("form.tab") and isdefined("url.tab") >
	 <cfset form.tab = url.tab >
  </cfif>
 <cfif not ( isdefined("form.tab") and ListContains('1,2,3', form.tab) )>
	 <cfset form.tab = 1 >
  </cfif>
  <script language="javascript1.2" type="text/javascript" src="utilesMonto.js"></script>
  <table width="100%" cellpadding="0" cellspacing="0" border="0">
	<tr>
		<td colspan="2">
			<cf_tabs width="100%">
				<cf_tab text="Cuestionario" selected="#form.tab eq 1#">
					<cf_web_portlet_start border="true" titulo="Cuestionario" >
						<cfinclude template="cuestionario-form.cfm">
					<cf_web_portlet_end>   
				</cf_tab>
		   
				<cf_tab text="Partes" selected="#form.tab eq 2#">
					<cf_web_portlet_start border="true" titulo="Partes">
					  <cfinclude template="cuestionarios-partes.cfm">
					<cf_web_portlet_end>   
				</cf_tab>
		   
				<cf_tab text="Preguntas" selected="#form.tab eq 3#">
					<cf_web_portlet_start border="true" titulo="Preguntas">
						<cfinclude template="cuestionarios-preguntas.cfm">
					<cf_web_portlet_end>   
				</cf_tab>
			</cf_tabs>
		</td>
	</tr>
	</table>
<script language="javascript">
	function ver(llave){
		var PARAM  = "previo.cfm?PCid="+ llave
		open(PARAM,'','left=100,top=150,scrollbars=yes,resizable=yes,width=800,height=400')
	}
</script>
<cf_web_portlet_end>
<cf_templatefooter>