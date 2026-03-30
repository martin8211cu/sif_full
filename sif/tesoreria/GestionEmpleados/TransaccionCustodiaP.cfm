<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_EntregaRecepcionDocumentosEfectivo" default = "Entrega y Recepci&oacute;n de Documentos y Efectivo" returnvariable="LB_EntregaRecepcionDocumentosEfectivo" xmlfile = "TransaccionCustodiaP.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "BTN_RecepcionEfectivo" default = "Recepci&oacute;n de Efectivo" returnvariable="BTN_RecepcionEfectivo" xmlfile = "TransaccionCustodiaP.xml">

<cf_templateheader title="#LB_EntregaRecepcionDocumentosEfectivo#">
	<cf_navegacion name="form.CCHTCid" navegacion="">
		<cfset titulo = '#LB_EntregaRecepcionDocumentosEfectivo#'>
	<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
		<table width="100%">
			 <tr>
			<cfif isdefined('form.btnRecepcion')>
				<cfinclude template="TransaccionCustodiaP_Recepcion.cfm">
			<cfelseif isdefined("form.btnAplicar")or isdefined ("form.btnConfirmar")>
				<cfinclude template="TransaccionCustodiaP_sql.cfm">
			<cfelseif isdefined('form.CCHTCid') and len(trim(form.CCHTCid)) or isdefined('form.GELid') or isdefined('url.GELid') or isdefined('form.GEAid')>
				<cfinclude template="TransaccionCustodiaP_form.cfm">
			<cfelse>
				<cfinclude template="TransaccionCustodiaP_lista.cfm">				
				<form action="TransaccionCustodiaP.cfm" method="post">
					<center><input name="btnRecepcion" type="submit" value="<cfoutput>#BTN_RecepcionEfectivo#</cfoutput>" /></center>
				</form>	
			</cfif>
				<td valign="top">
				</td>
			  </tr>
			</table>
	<cf_web_portlet_end>
<cf_templatefooter>
