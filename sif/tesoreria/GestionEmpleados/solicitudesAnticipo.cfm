<!------>
<!---<cfset LvarSAporEmpleado=true>--->

<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Titulo" default = "Preparaci&oacute;n de Solicitudes de Anticipo" 
returnvariable="LB_Titulo" xmlfile = "solicitudesAnticipo.xml"/>
<cfset LvarSAporEmpleadoCFM = "solicitudesAnticipo.cfm">
<cfset LvarSAporEmpleadoSQL = "Anticipo">

<cf_templateheader title="#LB_Titulo#"> 
<script language="javascript" type="text/javascript" src="../../js/utilesMonto.js"></script>

	<cfset Session.Tesoreria.ordenesPagoIrLista = "">
	<cfset Session.Tesoreria.solicitudesCFM = GetFileFromPath(GetCurrentTemplatePath())>
                        
	<cfset titulo = '#LB_Titulo#'>
 <cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
	<cfinclude template="TESid_Ecodigo.cfm">
	<cfif isdefined ('url.regresar')>
		<cfset form.GEAid=''>
		<cfset form.DEid=''>
		<cfinclude template="solicitudesAnticipo_lista.cfm">
	<cfelse>
  		<cfif (isdefined('form.GEAid') and len(trim(form.GEAid))) OR (isdefined('form.btnNuevo')) OR (isdefined('url.Nuevo'))or (isdefined('form.Nuevo')or isdefined('url.GEAid'))>
	 		 <cfinclude template="solicitudesAnticipo_form.cfm">			
		<cfelse>
			<cfinclude template="solicitudesAnticipo_lista.cfm">
		</cfif>
	</cfif>
  <cf_web_portlet_end>
<cf_templatefooter>
	


