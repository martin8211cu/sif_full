<!--- 
	Modificado por: Ana Villavicencio
	Fecha: 16 de enero del 2006
	Motivo: Cambio en la verificación de igualdad de las de sumas entre debitos y creditos en libros y bancos. Se paso en la parte del sql.
			Se abregaron verificaciones de variables url y el mensaje de error en caso de que no cumpla con la condición.
 --->

<!----
		Modificado por Hector Garcia Beita
		Motivo: validador para la redirección en caso de ser invocada desde la 
		opcion de conciliacion bancaria de el modulo de tarjetas de
		credito empresariales mediante un include
--->
<cfset LvarIrAformCon="formConciliacion.cfm">
<cfset LvarIrAframeConf="frame-config.cfm">
<cfset LvarIrAframeProgreso="frame-Progreso.cfm">
 <cfif isdefined("LvarTCEConciliacion")>
  	<cfset LvarIrAformCon="../../tce/operaciones/TCEformConciliacion.cfm">
	<cfset LvarIrAframeConf="../../tce/operaciones/TCEframe-config.cfm">
	<cfset LvarIrAframeProgreso="../../tce/operaciones/TCEframe-Progreso.cfm">
</cfif>
 
	<!---redireccion frame-config.cfm o TCEframe-config.cfm (TCE)--->
		<cfinclude template="#LvarIrAframeConf#">
	
	<!---<style type="text/css">
		input {background-color: #FAFAFA; font-family: Tahoma, sans-serif; font-size: 8pt; border:1px solid gray}
		<!---
		Estilos para scroll en las tablas add JCRUZ		
		--->
		.fixedHeader{float:left;}
		.fixedtbody{float:left; max-height:500px; _height:450px; height:450px; overflow:auto;width:100%;}
		.fixedtbody tr{height:22px;}/*IE*/
	</style>--->
	<cfif isdefined('url.ECid') and LEN(TRIM(url.ECid))><cfset form.ECid = url.ECid></cfif>
	<cfif isdefined('url.BTid') and LEN(TRIM(url.BTid))><cfset form.BTid = url.BTid></cfif>
	<cf_templateheader title="Conciliación">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Conciliaci&oacute;n Bancaria'>
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td width="85%" valign="top">
				  <cfinclude template="../../portlets/pNavegacion.cfm">
				  <!---Redireccion formConciliacion.cfm o TCEformConciliacion.cfm (TCE)--->
				  <cfinclude template="#LvarIrAformCon#">
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