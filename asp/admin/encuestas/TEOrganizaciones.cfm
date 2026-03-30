<cf_template template="#session.sitio.template#">
	<script  language="JavaScript" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>

	<cf_templatearea name="title">
		Tipo de Organizaciones de Empresas
	</cf_templatearea>
	
	<cf_templatearea name="body">

<cf_templatecss>
<link href="../../css/rh.css" rel="stylesheet" type="text/css">
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
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td valign="top">
	        	<cfif isdefined("Url.ETid") and not isdefined("Form.ETid")>
					<cfparam name="Form.ETid" default="#Url.ETid#">
					<cfset form.modo = 'CAMBIO'>
	            </cfif>
                <cf_web_portlet titulo="Tipo de Organización de Empresa">
					<cfinclude template="/home/menu/pNavegacion.cfm">
						<table width="100%" border="0">
							<tr>
								<td valign="top" width="40%">
									<cfinvoke 
										 component="sif.Componentes.pListas"	
										 method="pListaRH"
										 returnvariable="pListaRet">
											<cfinvokeargument name="tabla" value="EmpresaOrganizacion a, EncuestaEmpresa b"/>
											<cfinvokeargument name="columnas" value="ETid,a.EEid,ETdescripcion, EEnombre"/>
											<cfinvokeargument name="desplegar" value="ETid, ETdescripcion"/>
											<cfinvokeargument name="etiquetas" value="Código, Descripción"/>
											<cfinvokeargument name="formatos" value=""/>
											<cfinvokeargument name="filtro" value=" a.EEid = b.EEid"/>
											<cfinvokeargument name="align" value="center, left"/>
											<cfinvokeargument name="ajustar" value="N"/>
											<cfinvokeargument name="checkboxes" value="N"/>
											<cfinvokeargument name="Cortes" value="EEnombre"/>
											<cfinvokeargument name="irA" value="TEOrganizaciones.cfm"/>
											<cfinvokeargument name="Conexion" value="sifpublica"/>
										</cfinvoke>
								  </td>
								  <td valign="top" width="60%"><cfinclude template="formTEOrganizaciones.cfm"></td>
							</tr>
							<tr>
								<td>&nbsp;</td>
							  	<td>&nbsp;</td>
							</tr>
						</table> 
	                </cf_web_portlet>
				</td>	
			</tr>
		</table>	
	</cf_templatearea>
</cf_template>