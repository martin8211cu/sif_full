<cfsavecontent variable="pNavegacion">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cf_templateheader title="#nav__SPdescripcion#">
		<cfoutput>#pNavegacion#</cfoutput>
        <cfinclude template="/rh/Utiles/params.cfm">
        <cfset Session.Params.ModoDespliegue = 1>
        <cfset Session.cache_empresarial = 0>
        <cfset Regresar="javascript: document.formRegresar.submit();">
      	<cf_web_portlet_start titulo="Aplicación de Relación de Cálculo Especial de Nómina" >
			<form action="ResultadoCalculoEsp-lista.cfm" method="post" name="formRegresar">
				<input name="RCNid" type="hidden" value="<cfoutput>#Form.RCNid#</cfoutput>">
			</form>
            <cfinclude template="/rh/portlets/pRelacionCalculo.cfm">
            <cfinclude template="ResultadoCalculoEsp-aplicarForm.cfm">	  
		<cf_web_portlet_end>
<cf_templatefooter>