<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RegistroDeLasAreasDeEvaluacion"
	Default="Registro de las Áreas de Evaluación"
	returnvariable="LB_RegistroDeLasAreasDeEvaluacion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Codigo"
	Default="C&oacute;digo"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_Codigo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Descripcion"
	Default="Descripci&oacute;n"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Peso"
	Default="Peso"
	returnvariable="LB_Peso"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Grupos"
	Default="Grupos"
	returnvariable="LB_Grupos"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Filtrar"
	Default="Filtrar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Filtrar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Limpiar"
	Default="Limpiar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Limpiar"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
<cf_templatecss>
<link href="../css/rh.css" rel="stylesheet" type="text/css">
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
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_RegistroDeLasAreasDeEvaluacion#'>
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td valign="top">
				<cfinclude template="/rh/portlets/pNavegacion.cfm">				
				<table width="100%" cellspacing="0" cellpadding="0">
					<tr>
						<td>
							<table align="center" width="98%" cellpadding="0" cellspacing="0" >
								<tr>
									<td valign="top" width="50%">
                                    	<cf_translatedata name="get" tabla="RHEAreasEvaluacion" col="RHEAdescripcion" returnvariable="LvarRHEAdescripcion">
                                    	<cf_translatedata name="get" tabla="RHGruposAreasEval"  col="rhg.RHGdescripcion" returnvariable="LvarRHGdescripcion">
                                    	<cf_dbfunction name="spart" args="#LvarRHEAdescripcion#°1°35" delimiters="°" returnvariable="LvarRHEAdescripcion">
										<cfinvoke component="rh.Componentes.pListas" method="pListaRH" returnvariable="pListaDed">
											<cfinvokeargument name="tabla" value="RHEAreasEvaluacion rhe inner join RHGruposAreasEval rhg on rhg.Ecodigo = rhe.Ecodigo and rhg.RHGcodigo = rhe.RHGcodigo"/>
											<cfinvokeargument name="columnas" value="rhe.RHEAid,
																					RHEAcodigo, 
																					substring(rhe.RHEAdescripcion,1,35) as RHEAdescripcion,  
																					rhe.RHEApeso, 
																					rhe.RHGcodigo, 
																					{fn concat(rhg.RHGcodigo, {fn concat(' ', rhg.RHGdescripcion)})} as RHGgrupo, 7 as o, 1 as sel"/>
											<cfinvokeargument name="desplegar" value="RHEAcodigo,RHEAdescripcion, RHEApeso"/>
											<cfinvokeargument name="etiquetas" value="#LB_Codigo#, #LB_Descripcion#, #LB_Peso#"/>
											<cfinvokeargument name="Cortes" value="RHGgrupo"/>
											<cfinvokeargument name="formatos" value="S, S, M"/>
											<cfinvokeargument name="filtro" value="rhe.Ecodigo=#session.Ecodigo# order by 6, 2, 3"/>
											<cfinvokeargument name="align" value="left,left,right"/>
											<cfinvokeargument name="ajustar" value="N"/>
											<cfinvokeargument name="debug" value="N"/>
											<cfinvokeargument name="irA" value="AreasEvaluacion.cfm"/>			
											<cfinvokeargument name="keys" value="RHEAid"/>
											<cfinvokeargument name="maxrows" value="15"/>
											<cfinvokeargument name="mostrar_filtro" value="true"/>
											<cfinvokeargument name="filtrar_automatico" value="true"/>
										</cfinvoke>		
									</td>
									<cfset action = "AreasEvaluacion-SQL.cfm"> 
									<td width="1%">&nbsp;</td>
									<td width="50%" valign="top">
										<cfinclude template="AreasEvaluacion-form.cfm"> 
									</td>
								</tr>				
								<tr><td>&nbsp;</td></tr>
								</table>
						</td>																									  
					</tr>  		
				</table>
			</td>	
		</tr>
	</table>	
<cf_web_portlet_end>
<cf_templatefooter>	