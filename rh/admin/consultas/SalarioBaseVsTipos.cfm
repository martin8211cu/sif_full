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
	<cfinclude template="/rh/Utiles/params.cfm">
	<cfset Session.Params.ModoDespliegue = 1>
	<cfset Session.cache_empresarial = 0>	
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td valign="top">		                    
				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_DiagramaDeDispersionDeSalariosBasePorTipoDePuestos"
				Default="Diagrama de Dispersión de Salarios Base por Tipo de Puestos"
				returnvariable="LB_DiagramaDeDispersionDeSalariosBasePorTipoDePuestos"/>
				<cf_web_portlet_start border="true" titulo="#LB_DiagramaDeDispersionDeSalariosBasePorTipoDePuestos#" skin="#Session.Preferences.Skin#">	              
					<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_AdministracionDePuestos"
					Default="Administración de Puestos"
					returnvariable="LB_AdministracionDePuestos"/>
			
					<cfset regresar = "/cfmx/rh/indexPuestos.cfm">	              
					<cfset navBarItems = ArrayNew(1)>	              
					<cfset navBarLinks = ArrayNew(1)>	              
					<cfset navBarStatusText = ArrayNew(1)>	              
					<cfset navBarItems[1] = LB_AdministracionDePuestos>	              
					<cfset navBarLinks[1] = "/cfmx/rh/indexPuestos.cfm">	              
					<cfset navBarStatusText[1] = "/cfmx/rh/indexPuestos.cfm">
					<cfinclude template="/rh/portlets/pNavegacion.cfm">	              
					<center><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">
					<cf_translate key="LB_DiagramaDeDispersionDeSalariosBasePorTipoDePuestos">Diagrama de Dispersión de Salarios Base por Tipo de Puestos</cf_translate>
					</strong></center>	              
					<cfinclude template="RelacionPuestos-lista.cfm"> 
				<cf_web_portlet_end>
				<script type="text/javascript">
					<!--
					function selectvalues(HYERVid,HYERVdescripcion){
					location.href='SalarioBaseVsTipos-graph.cfm?HYERVid='+escape(HYERVid);
					}
					//-->
				</script>
			</td>	
		</tr>
	</table>	
<cf_templatefooter>	