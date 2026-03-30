<!-- InstanceBegin template="/Templates/LMenuRH1.dwt.cfm" codeOutsideHTMLIsLocked="false" --><cf_template template="#session.sitio.template#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>

	<cf_templatearea name="title">
		Recursos Humanos
	</cf_templatearea>
	
	<cf_templatearea name="body">

<cf_templatecss>
<link href="../../../css/rh.css" rel="stylesheet" type="text/css">
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_reloadPage(init) {  //reloads the window if Nav4 resized
  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
    document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
}
MM_reloadPage(true);
//-->
</script>

	  <cfinclude template="/rh/Utiles/params.cfm">
	  <cfset Session.Params.ModoDespliegue = 1>
	  <cfset Session.cache_empresarial = 0>

		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
					<!-- InstanceBeginEditable name="head" -->
<!-- InstanceEndEditable -->	
                    <!-- InstanceBeginEditable name="MenuJS" --> 
		  <!-- InstanceEndEditable -->					
					<!-- InstanceBeginEditable name="Mantenimiento" --> 	  
	  <cf_web_portlet_start titulo="Definici&oacute;n de Actividades por Tr&aacute;mite">
			<cfif isdefined('form.ProcessId') and form.ProcessId NEQ "">
				<cfset Regresar="/cfmx/rh/nomina/operacion/tramites/procesos.cfm?ProcessId=" & form.ProcessId>
			</cfif>
			<cfinclude template="/rh/portlets/pNavegacion.cfm"> 
		   <table width="100%" border="0" cellspacing="0" cellpadding="0">
              <tr>
                <td width="31%" valign="top">
				<cfparam name="form.ProcessId" default="0" type="numeric">
					<cfinvoke 
					 component="rh.Componentes.pListas"
					 method="pListaRH"
					 returnvariable="pListaPasos">
						<cfinvokeargument name="tabla" value="WfActivity"/>
						<cfif isdefined('form.rsRO')>
							<cfinvokeargument name="columnas" value="convert(varchar,ProcessId) as ProcessId,convert(varchar,ActivityId) as ActivityId,Name,'#form.rsRO#' as rsRO"/>
						<cfelse>
							<cfinvokeargument name="columnas" value="convert(varchar,ProcessId) as ProcessId,convert(varchar,ActivityId) as ActivityId,Name"/>
						</cfif>
						<cfinvokeargument name="desplegar" value="Name"/>
						<cfinvokeargument name="etiquetas" value="Actividades"/>
						<cfinvokeargument name="formatos" value=""/>
						<cfinvokeargument name="filtro" value="ProcessId = #form.ProcessId# and Name not in ('Paso - RECHAZADO','Paso - COMPLETADO') order by Ordering, Name"/>
						<cfinvokeargument name="align" value="left"/>
						<cfinvokeargument name="ajustar" value=""/>
						<cfinvokeargument name="Conexion" value="#Session.DSN#"/>
						<cfinvokeargument name="irA" value="definicion.cfm"/>
						<cfinvokeargument name="MaxRows" value="15"/>
					</cfinvoke>				
				</td>
				<td width="4%" valign="top">&nbsp;</td> 				
                <td width="65%" valign="top"> <cfinclude template="definicion-form.cfm"> </td>
              </tr>
            </table>	  
	  <cf_web_portlet_end>
      <!-- InstanceEndEditable -->
				</td>	
			</tr>
		</table>	
	</cf_templatearea>
</cf_template><!-- InstanceEnd -->