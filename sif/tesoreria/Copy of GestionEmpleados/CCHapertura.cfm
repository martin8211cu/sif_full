<cf_templateheader title="Apertura de Caja Chica"> 
	<cf_navegacion name="Config" navegacion="">
	<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="verificacion">
	</cfinvoke>
		<script language="javascript" type="text/javascript" src="../../js/utilesMonto.js"></script>		  
			<cfset titulo = 'Configuraci&oacute;n de Parametros de Caja Chica'>			
		<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
			<cfif isdefined ('form.CCHid') or isdefined ('url.CCHid') or isdefined ('form.Nuevo') or isdefined ('form.btnNuevo') or isdefined ('url.Nuevo') or isdefined ('url.Transac')>
				 <cfinclude template="CCHapertura_form.cfm">
			<cfelse>
				<cfinclude template="CCHapertura_lista.cfm">
			</cfif>			
	  	<cf_web_portlet_end>
<cf_templatefooter>
