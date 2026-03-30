<cf_templateheader title="Hist&oacute;rico de Recepci&oacute;n y Reclamos">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Hist&oacute;rico de Recepci&oacute;n y Reclamos'>
			<cfinclude template="../../portlets/pNavegacion.cfm">
			
			<cf_rhimprime datos="/sif/cm/consultas/HRecepcionReclamos-lista.cfm"> 
			<cfinclude template="HRecepcionReclamos-lista.cfm">
			<DIV align="center">
				<input name="btnRegresar" type="button" value="Regresar" onClick="javascript:location.href='HRecepcionReclamos.cfm'" >
			</DIV>
			
		<cf_web_portlet_end>
	<cf_templatefooter>
