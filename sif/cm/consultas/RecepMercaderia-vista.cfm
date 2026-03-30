<cf_templateheader title="Consulta de Recepción de Mercaderia">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Recepcion de Mercadería'>
		<cfinclude template="../../portlets/pNavegacionCM.cfm">
		<cf_rhimprime datos="/sif/cm/consultas/RecepcionMercaderia-reporte.cfm" paramsuri="&fEDRnumeroD=#form.fEDRnumeroD#&fEDRnumeroH=#form.fEDRnumeroH#&EOnumero1=#form.EOnumero1#&EOnumero2=#form.EOnumero2#&fechaD=#form.fechaD#&fechaH=#form.fechaH#&fTDRtipo=#form.fTDRtipo#&fEDRestado=#form.fEDRestado#&Mcodigo=#form.Mcodigo#&Usucodigo=#form.Usucodigo#">
		<cfset title = "Recepci&oacute;n de Mercader&iacute;a">
		<form name="form1" method="post">
			<cfinclude template="RecepcionMercaderia-reporte.cfm">
		</form>
		<cfset title = "Compras">
	<cf_web_portlet_end>
<cf_templatefooter>
