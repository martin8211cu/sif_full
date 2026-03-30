<cfset consulta="">
<cfset consulta2="">
<cfinclude template="../expediente/info-empleado.cfm">
<cfif isdefined("url.tab") and not isdefined("form.tab")>
	<cfset form.tab = url.tab >
</cfif>
<cfif not ( isdefined("form.tab") and ListContains('1,2', form.tab) )>
	<cfset form.tab = 1 >
</cfif>
<cfif isdefined('url.Filtro_DEidentificacion') and not isdefined('form.Filtro_DEidentificacion')>
	<cfset form.Filtro_DEidentificacion = url.Filtro_DEidentificacion>
</cfif>
<cfif isdefined('url.Filtro_DEnombreCompleto') and not isdefined('form.Filtro_DEnombreCompleto')>
	<cfset form.Filtro_DEnombreCompleto = url.Filtro_DEnombreCompleto>
</cfif>
<cfif isdefined('url.Filtro_Estado') and not isdefined('form.Filtro_Estado')>
	<cfset form.Filtro_Estado = url.Filtro_Estado>
</cfif>
<cf_tabs width="100%">
	<cf_tab text="Competencias" selected="#form.tab eq 1#">
		<cfif form.tab eq 1>
			<cfinclude template="evaluacion-formcompetencias.cfm">
		</cfif>
	</cf_tab>
	<cf_tab text="Plan Sucesi&oacute;n" selected="#form.tab eq 2#">
		<cfif form.tab eq 2>
			<cfinclude template="evaluacion-formplansucesion.cfm">
		</cfif>
	</cf_tab>
</cf_tabs>
<script type="text/javascript">
	<!--
	function tab_set_current (n){
		var params = '<cfif isdefined('form.Filtro_DEidentificacion') and LEN(TRIM(form.Filtro_DEidentificacion))>&Filtro_DEidentificacion=<cfoutput>#form.Filtro_DEidentificacion#</cfoutput></cfif><cfif isdefined('form.Filtro_DEnombreCompleto') and LEN(TRIM(form.Filtro_DEnombreCompleto))>&Filtro_DEnombreCompleto=<cfoutput>#Form.Filtro_DEnombreCompleto#</cfoutput></cfif><cfif isdefined('form.Filtro_Estado') and LEN(TRIM(form.Filtro_Estado))>&Filtro_Estado=<cfoutput>#Form.Filtro_Estado#</cfoutput></cfif>';
		location.href='evaluacion.cfm?RHRCid=<cfoutput>#JSStringFormat(form.RHRCid)#</cfoutput>&DEid=<cfoutput>#JSStringFormat(form.DEid)#</cfoutput>&tab='+escape(n)+params;
	}
	//-->
</script>