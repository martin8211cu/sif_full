<cfinvoke component ="sif.Componentes.Translate" method = "Translate" key = "LB_TituloCambioResponsableCajaChica" default = "Cambio de Responsable a Caja Chica" returnvariable="LB_TituloCambioResponsableCajaChica" xmlfile = "CambioResponsable.xml">

<cf_templateheader title="#LB_TituloCambioResponsableCajaChica#"> 
	<cf_navegacion name="Config" navegacion="">
	<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="verificacion">
	</cfinvoke>
		<script language="javascript" type="text/javascript" src="../../js/utilesMonto.js"></script>		  
			<cfset titulo = '#LB_TituloCambioResponsableCajaChica#'>			
		<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
			<cfif isdefined ('form.CCHid') or isdefined ('url.CCHid')>
				 <cfinclude template="CambioResponsable_form.cfm">
			<cfelse>
				<cfinclude template="CambioResponsable_lista.cfm">
			</cfif>			
	  	<cf_web_portlet_end>
<cf_templatefooter>
