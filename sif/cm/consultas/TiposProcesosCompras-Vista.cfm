<cf_templateheader title="Compras-Reporte de Publicaciónes de Compra">
	<cfinclude template="../../portlets/pNavegacion.cfm">
    <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Reporte de Publicaciónes de Compra'>
		<cf_rhimprime datos="/sif/cm/consultas/TiposProcesosCompras-form.cfm" paramsuri="&CMPid=#form.CMPid#"> 
		<cfinclude template="TiposProcesosCompras-form.cfm">
		<br><DIV align="center">
        	<input name="btnRegresar" type="button" class="btnAnterior" value="Regresar" onClick="javascript:location.href='TiposProcesosCompras-lista.cfm'" >
         </DIV><br>
	<cf_web_portlet_end>
<cf_templatefooter>