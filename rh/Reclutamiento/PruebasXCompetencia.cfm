<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RegistroDeLasPruebasPorCompetencia"
	Default="Registro de las Pruebas por Competencia"
	returnvariable="LB_RegistroDeLasPruebasPorCompetencia"/>
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
	Key="MSG_EsteValorYaFueAgregado"
	Default="Este valor ya fue agregado."
	returnvariable="MSG_EsteValorYaFueAgregado"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Habilidad"
	Default="Habilidad"
	returnvariable="LB_Habilidad"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Conocimiento"
	Default="Conocimiento"
	returnvariable="LB_Conocimiento"/>	
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
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_RegistroDeLasPruebasPorCompetencia#'>
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td valign="top">
				<cfinclude template="/rh/portlets/pNavegacion.cfm">				
				<script language="JavaScript1.2" type="text/javascript">
					function limpiar(){
						document.filtro.fdescripcion.value = '';
						document.filtro.fcodigo.value = '';
					}
				</script>
				<table width="100%" cellspacing="0" cellpadding="0">
					<!-----<tr><td>&nbsp;</td></tr>
					<tr class="tituloProceso"> 
						<td colspan="4" align="center">
							<font size="2"><strong>Registro de las Pruebas por Competencia</strong></font>
						</td>
					</tr>	 
					<tr><td>&nbsp;</td></tr>------>     
					<tr>
						<td>
							<table align="center" width="100%" cellpadding="0" cellspacing="0">
								<tr>
									<td valign="top" width="50%">
										<form style="margin:0" name="filtro" method="post">
											<cfoutput>
											<table width="100%" cellpadding="2" cellspacing="0" class="areaFiltro">
												<tr>
													<td><strong>#LB_Codigo#</strong></td>
													<td><strong>#LB_Descripcion#</strong></td>
												</tr>
												<tr> <!--- Competencias en la lista --->
													<td>
														<input name="fcodigo" type="text" size="10" maxlength="5"  
														onFocus="this.select();" 
														value="<cfif isdefined("form.fcodigo")>#form.fcodigo#</cfif>">
													</td>
													<td>
														<input name="fdescripcion" type="text" size="50" maxlength="80" 
														onFocus="this.select();" 
														value="<cfif isdefined("form.fdescripcion")>#form.fdescripcion#</cfif>">
													</td>
													<td align="center" nowrap>
														<input name="btnFiltrar" type="submit" value="#BTN_Filtrar#">
														<input name="btnLimpiar" type="button" value="#BTN_Limpiar#" 
														onClick="javascript:limpiar();">
													</td>
												</tr>
											</table>
											</cfoutput>
										</form>
										
										<cfset filtro = "Ecodigo=#session.Ecodigo# and activo=1" >
										<cfset navegacion = "">
										<cfif isdefined("form.fcodigo") and len(trim(form.fcodigo)) gt 0>
											<cfset filtro = filtro & " and upper (codigo) like '%" & Ucase(trim(form.fcodigo)) &"%'">
											<cfset navegacion = navegacion & "&fcodigo=#form.fcodigo#">
										</cfif>
										<cfif isdefined("form.fdescripcion") and len(trim(form.fdescripcion)) gt 0>
											<cfset filtro = filtro & " and  upper(descripcion) like '%" & Ucase(trim(form.fdescripcion)) & "%'">
											<cfset navegacion = navegacion & "&fdescripcion=#form.fdescripcion#">
										</cfif>
										<cfset filtro = filtro & " order by Tipo, descripcion, codigo">
										
										<cf_dbfunction name="string_part" args="descripcion,1,80" returnvariable="cSubcadena">
										<cf_dbfunction name="concat" args="len(descripcion) > 80 then #cSubcadena#|'...'" returnvariable="cInstruccion" delimiters="|">
										
										<!---<cf_dump var="#cInstruccion#">--->
										
										<!---#PreserveSingleQuotes(cInstruccion)#--->
										<!---{fn LENGTH(descripcion)} > 80 then {fn concat(substring(descripcion,1,80),'...')} --->
										<cf_translatedata name="get" tabla="RHCompetencias" col="descripcion" returnvariable="Lvardescripcion">
										<cfinvoke component="rh.Componentes.pListas" method="pListaRH" returnvariable="pListaDed">
											<cfinvokeargument name="tabla" value="RHCompetencias"/>
											<cfinvokeargument name="columnas" 
											value=" codigo, 
													case when #PreserveSingleQuotes(cInstruccion)#
													else #Lvardescripcion# end as descripcion,  
													case Tipo when 'H' then '#LB_Habilidad#' 
													else '#LB_Conocimiento#' end as Tipo"/>
											<cfinvokeargument name="desplegar" value="codigo, descripcion"/>
											<cfinvokeargument name="etiquetas" value="#LB_Codigo#, #LB_Descripcion#"/>
											<cfinvokeargument name="formatos" value="V, V"/>
											<cfinvokeargument name="filtro" value="#filtro#" />
											<cfinvokeargument name="align" value="left,left"/>
											<cfinvokeargument name="ajustar" value="S"/>
											<cfinvokeargument name="debug" value="N"/>
											<cfinvokeargument name="irA" value="PruebasXCompetencia.cfm"/>			
											<cfinvokeargument name="navegacion" value="#navegacion#"/>
											<cfinvokeargument name="keys" value="codigo"/>
											<cfinvokeargument name="Cortes" value="Tipo"/>
											<cfinvokeargument name="MaxRows" value="15"/>
										</cfinvoke>		
									</td>
									<cfset action = "PruebasXCompetencia-SQL.cfm"> 
									<td width="1%">&nbsp;</td>
									<td width="50%" valign="top">
										<cfinclude template="PruebasXCompetencia-form.cfm"> 
									</td>
								</tr>																									  							</table>
						</td>																									  
					</tr>  		
				</table>
			</td>	
		</tr>
	</table>	
<cf_web_portlet_end>
<cf_templatefooter>	