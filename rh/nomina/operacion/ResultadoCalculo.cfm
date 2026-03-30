<cfinvoke component="sif.Componentes.TranslateDB"
	method="Translate"
	VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
	Default="Relaci&oacute;n de C&aacute;lculo de N&oacute;mina"
	VSgrupo="103"
	returnvariable="nombre_proceso"/>
	
<cf_templateheader title="#nombre_proceso#">
	<cfinclude template="/rh/Utiles/params.cfm">
	<cfset Session.Params.ModoDespliegue = 1>
	<cfset Session.cache_empresarial = 0>
    <cfset MostrarSelecionEmpleado = true>
	<cf_web_portlet_start titulo="#nombre_proceso#" >
		<cfinclude template="/rh/portlets/pRelacionCalculo.cfm">
		<cfinclude template="/rh/portlets/pEmpleado.cfm">
		<cfinclude template="ResultadoCalculo-form.cfm">
	<cf_web_portlet_end>
<cf_templatefooter>
<script language="javascript" type="text/javascript">
	function ElegirEmpleado() 
	{
		document.form1.action='ResultadoCalculo-lista.cfm';
		document.form1.submit();
	}
</script>