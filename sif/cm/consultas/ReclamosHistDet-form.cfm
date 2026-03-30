<cf_templateheader title="Compras - Compradores ">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Consulta Hist&oacute;rica de Reclamos de Compras'>
			<cfinclude template="../../portlets/pNavegacion.cfm">
			<cfif isdefined("url.ERid") and not isdefined("form.ERid")>
				<cfset form.ERid = Url.ERid>
			</cfif>
			<cf_rhimprime datos="/sif/cm/consultas/ReclamosHistDet-imprime.cfm" paramsuri="&ERid=#form.ERid#"> 
			<cfinclude template="ReclamosHistDet-imprime.cfm">
			<!---<DIV align="center"><input name="btnRegresar" type="button" value="Regresar" onClick="javascript:location.href='ReclamosHist-form.cfm'" ></DIV>--->
			<input type="hidden" name="ERid" value="<cfif isdefined("form.ERid") and len(trim(form.ERid))>#form.ERid#</cfif>">
		<cf_web_portlet_end>
	<cf_templatefooter>
