<style type="text/css">
<!--
.style1 {
	color: #FFFFFF;
	font-weight: bold;
}
-->
</style>

<cfif isdefined("url.EDRid") and not isdefined("Form.EDRid")>
	<cfset Form.EDRid = url.EDRid>
</cfif>

<cf_templateheader title="	Documentos de Reclamos">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Registro de Documentos de Reclamo'>
			<cf_rhimprime datos="/sif/cm/consultas/repDocumReclamos-imprV2.cfm" paramsuri="&EDRid=#form.EDRid#">
			<form name="form1" method="post" action="documentos.cfm">
				<cfoutput>
					<cfif isdefined("url.EDRid") and not isdefined("Form.EDRid")>
						<input name="EDRid" type="hidden" value="#url.EDRid#">
					<cfelse>
						<input name="EDRid" type="hidden" value="#form.EDRid#">
					</cfif>
				</cfoutput>
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td><cfinclude template="repDocumReclamos-imprV2.cfm"></td>
				  </tr>
				  <tr>
					<td align="center">
						<cfif isdefined("url.LvarHisto") and LvarHisto eq 1>
							<cfset navegacion = "">
							<cfoutput>
								<cfif isdefined("form.SNcodigoI") and len(trim(form.SNcodigoI)) >
									<input name="SNcodigoI" type="hidden" value="#url.SNcodigoI#" />
								</cfif>
								<cfif isdefined("url.SNcodigoF") and len(trim(url.SNcodigoF)) >
									<input name="SNcodigoF" type="hidden" value="#url.SNcodigoF#" />
								</cfif>
								<cfif isdefined("url.EDRfecharecI") and len(trim(url.EDRfecharecI)) >
									<input name="EDRfecharecI" type="hidden" value="#url.EDRfecharecI#" />
								</cfif>
								<cfif isdefined("url.EDRfecharecF") and len(trim(url.EDRfecharecF)) >
									<input name="EDRfecharecF" type="hidden" value="#url.EDRfecharecF#" />
								</cfif>
								<cfif isdefined("url.EDRnumeroD") and len(trim(url.EDRnumeroD)) >
									<input name="EDRnumeroD" type="hidden" value="#url.EDRnumeroD#" />
								</cfif>
								<cfif isdefined("url.EDRnumeroH") and len(trim(url.EDRnumeroH)) >
									<input name="EDRnumeroH" type="hidden" value="#url.EDRnumeroH#" />
								</cfif>
								<cfif isdefined("url.EOnumeroDesde") and len(trim(url.EOnumeroDesde)) >
									<input name="EOnumeroDesde" type="hidden" value="#url.EOnumeroDesde#" />
								</cfif>
								<cfif isdefined("url.EOnumeroHasta") and len(trim(url.EOnumeroHasta)) >
									<input name="EOnumeroHasta" type="hidden" value="#url.EOnumeroHasta#" />
								</cfif>
							
								<script language="javascript" type="text/javascript">
									document.form1.action= '../consultas/ReclamosHist-formV2.cfm';
								</script>
							</cfoutput>
						</cfif>
						
						<input name="Regresar" type="submit" value="Regresar">					
						
					</td>
				  </tr>			  
				</table>
			</form>		
		<cf_web_portlet_end>
	<cf_templatefooter>