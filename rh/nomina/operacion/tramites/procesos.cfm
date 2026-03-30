<cfset session.WfPackageBaseName = 'RH'>
<cflocation url="/cfmx/sif/tr/catalogo/process_list.cfm">

<cfabort>

<cf_template template="#session.sitio.template#">
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
                  <cf_web_portlet_start titulo="Tr&aacute;mites" >
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<cfset regresar = "/cfmx/rh/indexEstructura.cfm" >
				<cfset navBarItems = ArrayNew(1)>
				<cfset navBarLinks = ArrayNew(1)>
				<cfset navBarStatusText = ArrayNew(1)>			 
				<cfset navBarItems[1] = "Estructura Organizacional">
				<cfset navBarLinks[1] = "/cfmx/rh/indexEstructura.cfm">
				<cfset navBarStatusText[1] = "/cfmx/rh/indexEstructura.cfm">			
				<td colspan="2" valign="top"><cfinclude template="/rh/portlets/pNavegacion.cfm"></td>
			  </tr>			
			  <tr>
				<td valign="top">
					<cfquery name="rsPaqueteIDLista" datasource="#Session.DSN#">
						select convert(varchar,PackageId) as PackageId
						from WfPackage 
						where Name = 'Recursos Humanos' and Ecodigo=#session.Ecodigo#
					</cfquery>	

					<cfif isdefined('rsPaqueteIDLista') and rsPaqueteIDLista.recordCount GT 0>
						<cfinvoke 
						 component="rh.Componentes.pListas"
						 method="pListaRH"
						 returnvariable="pListaEduRet">
							<cfinvokeargument name="tabla" value="WfProcess a, TramitesEmpresa b"/>
							<cfinvokeargument name="columnas" value="a.ProcessId, a.Name"/>
							<cfinvokeargument name="desplegar" value="Name"/>
							<cfinvokeargument name="etiquetas" value="Tr&aacute;mite"/>
							<cfinvokeargument name="formatos" value=""/>
							<cfinvokeargument name="filtro" value="a.PackageId=#rsPaqueteIDLista.PackageId# and b.Ecodigo=#session.Ecodigo# and a.ProcessId=b.RHTidtramite order by a.Name"/>
							<cfinvokeargument name="align" value="left"/>
							<cfinvokeargument name="ajustar" value=""/>
							<cfinvokeargument name="Conexion" value="#Session.DSN#"/>
							<cfinvokeargument name="irA" value="procesos.cfm"/>
							<cfinvokeargument name="MaxRows" value="15"/>
							<cfinvokeargument name="keys" value="ProcessId"/>
							<cfinvokeargument name="debug" value="N"/>
						</cfinvoke>				
					</cfif>
				</td>
				<td valign="top"><cfinclude template="procesos-form.cfm"> </td>
			  </tr>
			</table>
	                <cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
	</cf_templatearea>
</cf_template>