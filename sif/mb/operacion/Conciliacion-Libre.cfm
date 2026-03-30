<cfset LvarIrAformConciLibre="formConciliacion-Libre.cfm">
<cfset LvarIrAframeConf="frame-config.cfm">
<cfset LvarIrAframeProgreso="frame-Progreso.cfm">
 <cfif isdefined("LvarTCEConciliacionLibre")>
 	<cfset LvarIrAformConciLibre="../../tce/operaciones/TCEformConciliacion-Libre.cfm">
	<cfset LvarIrAframeConf="../../tce/operaciones/TCEframe-config.cfm">
	<cfset LvarIrAframeProgreso="../../tce/operaciones/TCEframe-Progreso.cfm">
</cfif>

<cf_templateheader title="Conciliación">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo=''>
	<!---redireccion frame-config.cfm o TCEframe-config.cfm (TCE)--->
 	<cfinclude template="#LvarIrAframeConf#">
	
	<style type="text/css">
		input {background-color: #FAFAFA; font-family: Tahoma, sans-serif; font-size: 8pt; border:1px solid gray}
		<!---Estilos para scroll en las tablas add JCRUZ--->
		.fixedHeader{float:left;}
		.fixedtbody{float:left; max-height:500px; _height:450px; height:450px; overflow:auto;width:100%;}
		.fixedtbody tr{height:22px;}/*IE*/
	</style>
	<cfif isdefined('url.ECid') and LEN(TRIM(url.ECid))><cfset form.ECid = url.ECid></cfif>
	<cfif isdefined('url.BTid') and LEN(TRIM(url.BTid))><cfset form.BTid = url.BTid></cfif>
	<cfif isdefined('url.BTEcodigo') and LEN(TRIM(url.BTEcodigo))><cfset form.BTEcodigo = url.BTEcodigo></cfif>
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td width="85%" valign="top">
				<!--- <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Conciliaci&oacute;n Bancaria'> --->
				  <cfinclude template="../../portlets/pNavegacion.cfm">
				  
				  <!---Redireccion formConciliacion-Libre.cfm o TCEformConciliacion-Libre.cfm (TCE)--->
				  <cfinclude template="#LvarIrAformConciLibre#">
				
				<!--- <cf_web_portlet_end> --->
			</td>
			<td width="15%" valign="top">
				<cfinclude template="#LvarIrAframeProgreso#">
				<br>
				<div class="ayuda">
					<strong>Indicaciones:</strong><br><br>
					Seleccione los documentos que desea conciliar y Presione el botón de <font color="#003399"><strong>Asignar</strong></font>.<br><br>
					Una vez que haya terminado presione <font color="#003399"><strong>Siguiente >></strong></font> para ver todos los documentos conciliados y preconciliados.<br><br>
					<strong>Nota:</strong> los debitos - cr&eacute;ditos de los documentos seleccionados de ambas listas deben ser iguales para conciliar.<br>
				</div>
			</td>
		</tr>
	</table>
	<cf_web_portlet_end>
<cf_templatefooter>