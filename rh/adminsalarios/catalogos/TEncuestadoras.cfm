<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
<cf_templatecss>
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">

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

<style type="text/css">
	<!--
	.style1 {
		font-weight: bold;
		font-size: 18px;
	}
	-->
</style>
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td valign="top">
				<cfif isdefined("Url.EEid") and not isdefined("Form.EEid")>
					<cfparam name="Form.EEid" default="#Url.EEid#">
				</cfif>
	        	<cfif isdefined("Url.EEcodigo") and not isdefined("Form.EEcodigo")>
					<cfparam name="Form.EEcodigo" default="#Url.EEcodigo#">
					<cfset form.modo = 'CAMBIO'>
	            </cfif>
                <cf_web_portlet_start titulo="Empresas Encuestadoras">
					<cfinclude template="/home/menu/pNavegacion.cfm">
						<table width="100%" border="0">							
							<tr bgcolor="#CCCCCC">
								<td colspan="2" align="center"><span class="style1">
							  <strong>EMPRESAS ENCUESTADORAS</strong></span></td>
						  </tr>															
							<tr>
								<td valign="top" width="60%">
									<cfinvoke 
										 component="rh.Componentes.pListas"
										 method="pListaRH"
										 returnvariable="pListaRet">
											<cfinvokeargument name="tabla" value="EncuestaEmpresa"/>
											<cfinvokeargument name="columnas" value="EEid,EEcodigo, EEnombre, Ppais"/>
											<cfinvokeargument name="desplegar" value="EEcodigo, EEnombre, Ppais"/>
											<cfinvokeargument name="etiquetas" value="Código, Descripción, País"/>
											<cfinvokeargument name="formatos" value=""/>
											<cfinvokeargument name="filtro" value=""/>
											<cfinvokeargument name="align" value="left, left, left"/>
											<cfinvokeargument name="ajustar" value="N,N,N"/>
											<cfinvokeargument name="checkboxes" value="N"/>
											<cfinvokeargument name="irA" value="TEncuestadoras.cfm"/>
											<cfinvokeargument name="keys" value="EEid"/>
											<cfinvokeargument name="PageIndex" value="1"/>
											<cfinvokeargument name="formName" value="formListaEnc"/>											
											<cfinvokeargument name="Conexion" value="sifpublica"/>
									</cfinvoke>
							  </td>
								  <td valign="top" align="center" width="40%">
								  	<cfinclude template="formTEncuestadoras.cfm">
								  </td>
							</tr>
							<tr>
								<td>&nbsp;</td>
							  	<td>&nbsp;</td>
							</tr>
							<tr>
								<td colspan="2">
									<cfif modoEnc neq "ALTA">
										<cfif isdefined("url.tab") and not isdefined("form.tab")>
											<cfset form.tab = url.tab >
										</cfif>
										<cfif not ( isdefined("form.tab") and ListContains('1,2,3,4,5', form.tab) )>
											<cfset form.tab = 1 >
										</cfif>							
															
										<cf_tabs width="100%">
											<cf_tab text="Tipos de Organizaci&oacute;n" selected="#form.tab eq 1#">
												<cfif form.tab eq 1>
													<cfinclude template="TEOrganizaciones.cfm">
												</cfif>
											</cf_tab>
											<cf_tab text="&Aacute;reas" selected="#form.tab eq 2#">
												<cfif form.tab eq 2>
													<cfinclude template="TEArea.cfm">
												</cfif>
											</cf_tab>
											<cf_tab text="Puestos" selected="#form.tab eq 3#">
												<cfif form.tab eq 3>
													<cfinclude template="TEPuesto.cfm">
												</cfif>
											</cf_tab>			
											<cf_tab text="Encuestas" selected="#form.tab eq 4#">
												<cfif form.tab eq 4>
													<cfinclude template="datosEncuestas-proceso.cfm">
												</cfif>
											</cf_tab>		
											<cf_tab text="Relaci&oacute;n de Puestos" selected="#form.tab eq 5#">
												<cfif form.tab eq 5>
													<cfinclude template="relacionPuestos.cfm">
												</cfif>
											</cf_tab>																																
										</cf_tabs>				
										
										<script type="text/javascript">
											<!--
												function tab_set_current (n){
													location.href='TEncuestadoras.cfm?EEid=<cfoutput>#JSStringFormat(form.EEid)#</cfoutput>&tab='+escape(n);
												}
											//-->
										</script>												
									</cfif>
								</td>
							</tr>							

						</table> 
              <cf_web_portlet_end>
		  </td>	
	  </tr>
	</table>	
<cf_templatefooter>	