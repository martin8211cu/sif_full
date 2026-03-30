<!--- 
	Modificado por:Ana Villavicencio
	Fecha: 23 de agosto del 2005
	Motivo: Correccion del titulo de la forma, cuando entraba por CxP dejaba el titulo "Cuentas por Cobrar".
			Esto porque solo existen un proceso de neteo de documentos y este se encuentra dentro de la carpeta 
			de CxC. Creando un archivo dentro de CxP y haciendo la llamada del proceso, hace la corrección. Además 
			cambios en la seguridad de CxP.
			Se hace la inclusion del nuevo archivo Neteo1-form.cfm.
 --->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset TIT_Neteo = t.Translate('TIT_Neteo','Neteo de Documentos de CXP y CXC')>

<cf_templateheader title="#TIT_Neteo#">
		<cfinclude template="../../portlets/pNavegacion.cfm">
		<cf_web_portlet_start titulo="#TIT_Neteo#">
			<cfinclude template="Neteo1-form.cfm">
		<cf_web_portlet_end> 
	<cf_templatefooter>