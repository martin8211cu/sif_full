<!--- VARIABLES DE TRADUCCION --->
<cfinvoke Key="LB_RecursosHumanos" Default="Recursos Humanos" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke key="LB_EscalasSalariales" default="Escalas Salariales" returnvariable="LB_EscalasSalariales" component="sif.Componentes.Translate" method="Translate"/>	 
<!--- FIN VARIABLES DE TRADUCCION --->
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
<cfset filtro = ''>
		<cfset navegacion = ''>
	<cf_web_portlet_start titulo="#LB_EscalasSalariales#">
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td valign="top">
				<cfinclude template="/rh/portlets/pNavegacion.cfm">		
				<cf_translatedata name="get" tabla="RHTTablaSalarial" col="RHTTdescripcion" returnvariable="LvarRHTTdescripcion">		  
				<cfinvoke 
				 component="rh.Componentes.pListas"
				 method="pListaRH"
				 returnvariable="pListaRHRet">
					<cfinvokeargument name="tabla" value="RHTTablaSalarial"/>
					<cfinvokeargument name="columnas" value="RHTTid,RHTTcodigo,case when datalength(#LvarRHTTdescripcion#) > 30 then substring(#LvarRHTTdescripcion#,1,30) + '...' else #LvarRHTTdescripcion# end as RHTTdescripcion "/>
					<cfinvokeargument name="desplegar" value="RHTTcodigo,RHTTdescripcion"/>
					<cfinvokeargument name="etiquetas" value="Código,Descripción"/>
					<cfinvokeargument name="formatos" value="S,S"/>
					<cfinvokeargument name="filtro" value="Ecodigo = #Session.Ecodigo# #filtro# order by RHTTcodigo, RHTTdescripcion"/>
					<cfinvokeargument name="align" value="left,left"/>
					<cfinvokeargument name="ajustar" value="S"/>
					<cfinvokeargument name="irA" value="tipoTablasSal-form.cfm"/>
					<cfinvokeargument name="maxRows" value="10"/>
					<cfinvokeargument name="keys" value="RHTTid"/>
					<cfinvokeargument name="navegacion" value="#navegacion#"/>
					<cfinvokeargument name="botones" value="Nuevo"/>
					<cfinvokeargument name="filtrar_automatico" value="true"/>
					<cfinvokeargument name="mostrar_filtro" value="true"/>
				</cfinvoke>
			</td>	
		</tr>
	</table>	
	<cf_web_portlet_end>
<cf_templatefooter>	