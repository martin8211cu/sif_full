<!--- PRE CARGA DE FILTROS --->

<cfinclude template="procesos.cfm">

<cfif isdefined("url.RHOsexo") and len(trim(url.RHOsexo)) gt 0 and not isdefined("form.RHOsexo")  >
	<cfset form.RHOsexo = url.RHOsexo>
</cfif>

<cfif isdefined("url.Ppais") and len(trim(url.Ppais)) gt 0 and not isdefined("form.Ppais")  >
	<cfset form.Ppais = url.Ppais>
</cfif>

<cfif isdefined("url.TPOPRETEN") and len(trim(url.TPOPRETEN)) gt 0 and not isdefined("form.TPOPRETEN")  >
	<cfset form.TPOPRETEN = url.TPOPRETEN>
</cfif>

<cfif isdefined("url.TPOPRETEN") and len(trim(url.TPOPRETEN)) gt 0 and not isdefined("form.TPOPRETEN")  >
	<cfset form.TPOPRETEN = url.TPOPRETEN>
</cfif>

<cfif isdefined("url.RHOPrenteInf") and len(trim(url.RHOPrenteInf)) gt 0 and not isdefined("form.RHOPrenteInf")  >
	<cfset form.RHOPrenteInf = url.RHOPrenteInf>
</cfif>

<cfif isdefined("url.RHOPrenteSup") and len(trim(url.RHOPrenteSup)) gt 0 and not isdefined("form.RHOPrenteSup")  >
	<cfset form.RHOPrenteSup = url.RHOPrenteSup>
</cfif>

<cfif isdefined("url.TPOEXPE") and len(trim(url.TPOEXPE)) gt 0 and not isdefined("form.TPOEXPE")  >
	<cfset form.TPOEXPE = url.TPOEXPE>
</cfif>

<cfif isdefined("url.ExperienciaInf") and len(trim(url.ExperienciaInf)) gt 0 and not isdefined("form.ExperienciaInf")  >
	<cfset form.ExperienciaInf = url.ExperienciaInf>
</cfif>

<cfif isdefined("url.ExperienciaSup") and len(trim(url.ExperienciaSup)) gt 0 and not isdefined("form.ExperienciaSup")  >
	<cfset form.ExperienciaSup = url.ExperienciaSup>
</cfif>

<cfif isdefined("url.RHPcodigo") and len(trim(url.RHPcodigo)) gt 0 and not isdefined("form.RHPcodigo")  >
	<cfset form.RHPcodigo = url.RHPcodigo>
</cfif>

<cfif isdefined("url.RHORefValida") and len(trim(url.RHORefValida)) gt 0 and not isdefined("form.RHORefValida")  >
	<cfset form.RHORefValida = url.RHORefValida>
</cfif>

<cfif isdefined("url.RHOPosViajar") and len(trim(url.RHOPosViajar)) gt 0 and not isdefined("form.RHOPosViajar")  >
	<cfset form.RHOPosViajar = url.RHOPosViajar>
</cfif>

<cfif isdefined("url.RHOPosTralado") and len(trim(url.RHOPosTralado)) gt 0 and not isdefined("form.RHOPosTralado")  >
	<cfset form.RHOPosTralado = url.RHOPosTralado>
</cfif>

<cfif isdefined("url.RHOEntrevistado") and len(trim(url.RHOEntrevistado)) gt 0 and not isdefined("form.RHOEntrevistado")  >
	<cfset form.RHOEntrevistado = url.RHOEntrevistado>
</cfif>

<cfif isdefined("url.RHOPDescripcion") and len(trim(url.RHOPDescripcion)) gt 0 and not isdefined("form.RHOPDescripcion")  >
	<cfset form.RHOPDescripcion = url.RHOPDescripcion>
</cfif>

<cfif isdefined("url.Zona1") and len(trim(url.Zona1)) gt 0 and not isdefined("form.Zona1")  >
	<cfset form.Zona1 = url.Zona1>
</cfif>

<cfif isdefined("url.Zona2") and len(trim(url.Zona2)) gt 0 and not isdefined("form.Zona2")  >
	<cfset form.Zona2 = url.Zona2>
</cfif>

<cfif isdefined("url.Zona3") and len(trim(url.Zona3)) gt 0 and not isdefined("form.Zona3")  >
	<cfset form.Zona3 = url.Zona3>
</cfif>

<cfif isdefined("url.RHOIdioma") and len(trim(url.RHOIdioma)) gt 0 and not isdefined("form.RHOIdioma")  >
	<cfset form.RHOIdioma = url.RHOIdioma>
</cfif>

<cfif isdefined("url.CapNoFormal") and len(trim(url.CapNoFormal)) gt 0 and not isdefined("form.CapNoFormal")  >
	<cfset form.CapNoFormal = url.CapNoFormal>
</cfif>

<cfif isdefined("url.GAcodigo") and len(trim(url.GAcodigo)) gt 0 and not isdefined("form.GAcodigo")  >
	<cfset form.GAcodigo = url.GAcodigo>
</cfif>

<cfif isdefined("url.RHOTid") and len(trim(url.RHOTid)) gt 0 and not isdefined("form.RHOTid")  >
	<cfset form.RHOTid = url.RHOTid>
</cfif>

<cfif isdefined("url.RHCGIDLIST") and len(trim(url.RHCGIDLIST)) gt 0 and not isdefined("form.RHCGIDLIST")  >
	<cfset form.RHCGIDLIST = url.RHCGIDLIST>
</cfif>

<cfif isdefined("url.RHOMonedaPrt") and len(trim(url.RHOMonedaPrt)) gt 0 and not isdefined("form.RHOMonedaPrt")  >
	<cfset form.RHOMonedaPrt = url.RHOMonedaPrt>
</cfif>


<!---
<cfdump var="#form.RHCGIDLIST#">
 <CFDUMP var="#form#"> --->
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Busqueda_de_Candidatos"
	Default="B&uacute;squeda de Candidatos"
	returnvariable="LB_Busqueda_de_Candidatos"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_area_de_busqueda"
	Default="&Aacute;rea de b&uacute;squeda"
	returnvariable="LB_area_de_busqueda"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Posibles_Candidatos"
	Default="Posibles Candidatos"
	returnvariable="LB_Posibles_Candidatos"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Condicion"
	Default="Condici&oacute;n"
	returnvariable="LB_Condicion"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Criterios_de_Busqueda"
	Default="Criterios de B&uacute;squeda"
	returnvariable="LB_Criterios_de_Busqueda"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_PuestoExterno"
	Default="Puesto Externo"
	returnvariable="LB_PuestoExterno"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_TituloObtenido"
	Default="T&iacute;tulo obtenido"
	returnvariable="LB_TituloObtenido"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Eliminar_el_niviel_y_el_titulo"
	Default="Eliminar el niviel y el titulo"
	returnvariable="MSG_Eliminar_el_niviel_y_el_titulo"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ListaDeLugares"
	Default="Lista de Lugares"
	returnvariable="LB_ListaDeLugares"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Codigo"
	Default="Código"
	xmlFile="/rh/generales.xml"
	returnvariable="LB_Codigo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Descripcion"
	Default="Descripción"
	xmlFile="/rh/generales.xml"
	returnvariable="LB_Descripcion"/>


<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Lugar" Default="Lugar" xmlFile="/rh/generales.xml" returnvariable="LB_Lugar"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Tipo" Default="Tipo" xmlFile="/rh/generales.xml" returnvariable="LB_Tipo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Pertenece_A" Default="Pertenece a" xmlFile="/rh/generales.xml" returnvariable="LB_Pertenece_A"/>

<!--- ********************************************************************************* --->
<cfset geo = createObject("component","asp.Geografica.componentes.AreaGeografica")>
<cfquery name="rsPais" datasource="asp">
	select Ppais, Pnombre
	from Pais
</cfquery>

<cfquery name="rsMonedaPRT" datasource="#Session.DSN#">
	select Miso4217,Miso4217 as Mnombre  from Moneda
</cfquery>

<!--- OPARRALES 2018-11-06 Modificacion para tomar la Moneda de la empresa de la tabla Moneda --->
<cfquery name="rsMonedaLOC" datasource="#Session.DSN#">
	select
		a.Miso4217
	from
		Monedas a
	inner join Moneda m
		on m.Miso4217 = a.Miso4217
	inner join Empresa b
		on b.Mcodigo = m.Mcodigo
		and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.ecodigosdc#">
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>
<cfquery name="rsNacLOC" datasource="#Session.DSN#">
	select a.Ppais from Direcciones a
 	inner join Empresa b
		on a.id_direccion = b.id_direccion
	where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.ecodigosdc#">
</cfquery>

<cf_translatedata name="get" tabla="RHIdiomas" col="RHDescripcion" returnvariable="LvarRHDescripcion">
<cfquery name="rsIdiomas" datasource="#session.DSN#">
	select RHIid, RHIcodigo, #LvarRHDescripcion# as RHDescripcion
	from RHIdiomas
	order by #LvarRHDescripcion# asc
</cfquery>

<!--- ********************************************************************************* --->
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
		<script language="JavaScript1.2" src="/cfmx/rh/js/utilesMonto.js"></script>

		<cfinclude template="/rh/Utiles/params.cfm">
		<cfset Session.Params.ModoDespliegue = 1>
		<cfset Session.cache_empresarial = 0>
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Busqueda_de_Candidatos#'>
			<cfoutput>
			<form style="margin:0" name="form1" method="post">
				<table width="100%" cellpadding="0" cellspacing="0">
					<tr><td colspan="2"><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
					<tr>
						<td valign="top" bgcolor="##A0BAD3" colspan="2">
							<cfinclude template="frame-botones.cfm">
						</td>
					</tr>
					<tr>
						<td valign="top" width="43%" id="TDAREABUSQUEDA">
							<fieldset><legend>#LB_area_de_busqueda#</legend>
								<table width="100%" border="0" cellpadding="0" cellspacing="0">
									<tr>
										<td valign="top" class="areaFiltro" colspan="2" align="center">
											<font  style="font-size:10px"><b>#LB_Criterios_de_Busqueda#</b></font>
										</td>
									</tr>
									<!--- **************************************************************************************************** --->
									<!--- SEXO --->
									<tr>
										<td  valign="middle" width="15%">
											<font  style="font-size:10px"><cf_translate key="LB_Sexo">Sexo</cf_translate></font>
										 </td>
										<td  valign="bottom">
											<select name="RHOsexo" id="RHOsexo" style="font-size:10px" tabindex="1">
												<option value="">(<cf_translate key="CMB_Ambos">Ambos</cf_translate>)</option>
												<option value="M" <cfif isdefined("form.RHOsexo") and form.RHOsexo EQ 'M'> selected</cfif>><cf_translate key="CMB_Masculino">Masculino</cf_translate></option>
												<option value="F" <cfif isdefined("form.RHOsexo") and form.RHOsexo EQ 'F'> selected</cfif>><cf_translate key="CMB_Femenino">Femenino</cf_translate></option>
											</select>
										</td>
									</tr>
									<!--- **************************************************************************************************** --->
									<!--- NACIONALIDAD --->
									<tr>
										<td  valign="middle">
											<font  style="font-size:10px"><cf_translate key="LB_Nacionalidad">Nacionalidad</cf_translate></font>
										</td>
										<td  valign="bottom">
											<select name="Ppais" style="font-size:10px" tabindex="1">
												<option value="">(<cf_translate key="CMB_SeleccioneUnPais">Seleccione un Pa&iacute;s</cf_translate>)</option>
												<cfloop query="rsPais">
												<option value="#Ppais#"<cfif isdefined("form.Ppais") and rsPais.Ppais EQ form.Ppais> selected <cfelseif not  isdefined("form.Ppais")  and rsPais.Ppais EQ rsNacLOC.Ppais >selected</cfif>>
													#Pnombre#</option>
												</cfloop>
											</select>
										</td>
									</tr>
									<!--- **************************************************************************************************** --->
									<!---  PRETENCION SALARIAL --->
									<tr>
										<td  valign="middle"  width="15%">
											<font  style="font-size:10px"><cf_translate key="LB_Pretencion_salarial">Pretenci&oacute;n salarial</cf_translate></font>
										 </td>
										<td  valign="bottom" colspan="4">
											<table cellpadding="0" cellspacing="2">
												<tr>
													<td valign="middle">
														<select name="TPOPRETEN" style="font-size:10px" id="TPOPRETEN" onchange="javascript:CambiaPretencion()" tabindex="1">
															<option value="1" <cfif isdefined("form.TPOPRETEN") and form.TPOPRETEN EQ '1'> selected</cfif>><cf_translate key="CMB_Entre">Entre</cf_translate></option>
															<option value="2" <cfif isdefined("form.TPOPRETEN") and form.TPOPRETEN EQ '2'> selected</cfif>><cf_translate key="CMB_Mas_de">M&aacute;s de </cf_translate></option>
															<option value="3" <cfif isdefined("form.TPOPRETEN") and form.TPOPRETEN EQ '3'> selected</cfif>><cf_translate key="CMB_Menos_de">Menos de</cf_translate></option>
														</select>
													</td>
													<td>
														<select name="RHOMonedaPrt" style="font-size:10px" >
															<cfloop query="rsMonedaPRT">
															<option value="<cfoutput>#rsMonedaPRT.Miso4217#</cfoutput>"
																<cfif   isdefined("form.RHOMonedaPrt") and form.RHOMonedaPrt EQ rsMonedaPRT.Miso4217> selected
																<cfelseif  rsMonedaPRT.Miso4217 EQ rsMonedaLOC.Miso4217 > selected
																</cfif>>
																<cfoutput>#rsMonedaPRT.Mnombre#</cfoutput></option>
															</cfloop>
														</select>
													</td>
													<td  id="td_RHOPrenteInf">
														<input
															name="RHOPrenteInf"
															type="text"
															id="RHOPrenteInf"
															tabindex="1"
															size="15"
															style="text-align: right; font-size:10px"
															onBlur="javascript: fm(this,2);"
															onFocus="javascript:this.value=qf(this); this.select();"
															onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
															value="<cfif isdefined("form.RHOPrenteInf") and len(trim(form.RHOPrenteInf))>#form.RHOPrenteInf#</cfif>">
													</td>
													<td  valign="middle" id="td_Y">
														<font  style="font-size:10px"><cf_translate key="LB_Y">Y</cf_translate></font>
													 </td>
													<td id="td_RHOPrenteSup">
														<input
															name="RHOPrenteSup"
															type="text"
															tabindex="1"
															id="RHOPrenteSup"
															size="15"
															style="text-align: right; font-size:10px"
															onBlur="javascript: fm(this,2);"
															onFocus="javascript:this.value=qf(this); this.select();"
															onKeyUp="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
															value="<cfif isdefined("form.RHOPrenteSup") and len(trim(form.RHOPrenteSup))>#form.RHOPrenteSup#</cfif>">
													</td>
												</tr>
											</table>
										</td>
									</tr>

									<!--- **************************************************************************************************** --->
									<!--- PUESTOS --->
									<tr>
										<td colspan="2">
											<fieldset><legend><cf_translate key="LB_Puestos">Puestos</cf_translate></legend>
											<table width="100%" border="0" cellpadding="0" cellspacing="0">
												<!--- **************************************************************************************************** --->
												<!---  EXPERIENCIA  --->
												<tr>
													<td  valign="middle">
														<font  style="font-size:10px"><cf_translate key="LB_Experiencia">Experiencia</cf_translate></font>
													 </td>
													<td  valign="bottom" colspan="4">
														<table cellpadding="0" cellspacing="2">
															<tr>
																<td valign="middle">
																	<select name="TPOEXPE" id="TPOEXPE" onchange="javascript:CambiaExperiencia()" style="font-size:10px" tabindex="1">
																		<option value="1" <cfif isdefined("form.TPOEXPE") and form.TPOEXPE EQ '1'> selected</cfif>><cf_translate key="CMB_Mas_de">M&aacute;s de </cf_translate></option>
																		<option value="2" <cfif isdefined("form.TPOEXPE") and form.TPOEXPE EQ '2'> selected</cfif>><cf_translate key="CMB_Menos_de">Menos de</cf_translate></option>
																	</select>
																</td>
																<td  id="td_ExperienciaInf">
																	<input
																		name="ExperienciaInf"
																		type="text"
																		id="ExperienciaInf"
																		tabindex="1"
																		style="text-align: right; font-size:10px"
																		onBlur="javascript: fm(this,0);"
																		onFocus="javascript:this.value=qf(this); this.select();"
																		onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}"
																		value="<cfif isdefined("form.ExperienciaInf") and len(trim(form.ExperienciaInf))>#form.ExperienciaInf#</cfif>">
																</td>
																<td id="td_ExperienciaSup">
																	<input
																		name="ExperienciaSup"
																		type="text"
																		id="ExperienciaSup"
																		tabindex="1"
																		style="text-align: right; font-size:10px"
																		onBlur="javascript: fm(this,0);"
																		onFocus="javascript:this.value=qf(this); this.select();"
																		onKeyUp="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}"
																		value="<cfif isdefined("form.ExperienciaSup") and len(trim(form.ExperienciaSup))>#form.ExperienciaSup#</cfif>">
																</td>
																<td valign="middle"><font  style="font-size:10px"><cf_translate key="Lb_Annos">A&ntilde;os</cf_translate></font></td>
															</tr>
														</table>
													</td>
												</tr>

												<tr>
													<td  valign="middle" width="15%">
														<font  style="font-size:10px"><cf_translate key="LB_Interno">Interno</cf_translate></font>
													 </td>
													<td  valign="bottom">
														<cfif isdefined("form.RHPcodigo") and len(trim(form.RHPcodigo)) gt 0>
															<cfquery name="rsForm" datasource="#session.DSN#">
																select
																	RHPcodigo as RHPcodigo,
																	coalesce(ltrim(rtrim(RHPcodigoext)),rtrim(ltrim(RHPcodigo))) as RHPcodigoext,
																	RHPdescpuesto
																from RHPuestos
																where  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
																and RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">
															</cfquery>

															<cf_rhpuesto tabindex="1"  value="#form.RHPcodigo#" query="#rsForm#">
														<cfelse>
															<cf_rhpuesto tabindex="1" >
														</cfif>
													</td>
												</tr>
												<tr>
													<td  valign="middle" width="15%">
														 <font  style="font-size:10px"><cf_translate key="LB_Externo">Externo</cf_translate></font>
													 </td>
													<td  valign="bottom">
														<!---
														<cfset ArrayPUESTOEXT=ArrayNew(1)>
														<cfif isdefined("form.RHOPDescripcion") and len(trim(form.RHOPDescripcion))>
															<cfquery name="rsPUESTOEXT" datasource="#session.DSN#">
																select
																	RHOPDescripcion,
																	RHOPDescripcion
																from RHOPuesto
																where  CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
																and RHOPDescripcion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHOPDescripcion#">
															</cfquery>
															<cfset ArrayAppend(ArrayPUESTOEXT,rsPUESTOEXT.RHOPDescripcion)>
															<cfset ArrayAppend(ArrayPUESTOEXT,rsPUESTOEXT.RHOPDescripcion)>
														</cfif>
														<cf_conlis
														Campos="RHOPDescripcion,RHOPDescripcion"
														Desplegables="N,S"
														Modificables="N,S"
														Size="0,43"
														tabindex="1"
														ValuesArray="#ArrayPUESTOEXT#"
														Title="Lista de #LB_PuestoExterno#"
														Tabla="RHOPuesto"
														Columnas="RHOPDescripcion,RHOPDescripcion"
														Filtro=" CEcodigo = #Session.CEcodigo#"
														Desplegar="RHOPDescripcion"
														Etiquetas="#LB_PuestoExterno#"
														filtrar_por="RHOPDescripcion"
														Formatos="S"
														Align="left"
														Asignar="RHOPDescripcion,RHOPDescripcion"
														Asignarformatos="S,S"/>
														 --->
														<cfinvoke component="sif.Componentes.Translate"
															method="Translate"
															Key="MSG_Lista_de_Puestos_Externos"
															Default="Lista de Puestos Externos"
															returnvariable="MSG_Lista_de_Puestos_Externos"/>

														<input
															name="RHOPDescripcion"
															type="text"
															id="RHOPDescripcion"
															tabindex="1"
															style="font-size:10px"
															maxlength="100"
															size="52"
															value="<cfif isdefined("form.RHOPDescripcion") and len(trim(form.RHOPDescripcion))>#form.RHOPDescripcion#</cfif>">

														<a href="##" tabindex="-1">
														<img src="/cfmx/rh/imagenes/Description.gif"
																alt="#MSG_Lista_de_Puestos_Externos#"
																name="imagen"
																width="18"
																height="14"
																border="0"
																align="absmiddle"
																onClick='javascript: doConlisPexternos();'>
														</a>


													</td>
												</tr>
											</table>
											</fieldset>
										</td>
									</tr>
									<!--- **************************************************************************************************** --->
									<!--- otros --->
									<tr>
										<td colspan="2">
											<fieldset><legend><cf_translate key="LB_Otros">Otros</cf_translate></legend>
											<table width="100%" border="0" cellpadding="0" cellspacing="0">
												<tr>
													<td colspan="1">&nbsp;</td>
													<td colspan="2"><input type="checkbox" <cfif isdefined("form.RHORefValida")>checked</cfif> name="RHORefValida" tabindex="1" value="1"><font style="font-size:10px"><cf_translate key="CHK_ReferenciaVerificadas">Referencias verificadas</cf_translate></font></td>
												<tr>
												<tr>
													<td colspan="1">&nbsp;</td>
													<td colspan="2"><input type="checkbox" <cfif isdefined("form.RHOPosViajar")>checked</cfif> name="RHOPosViajar" tabindex="1" value="1"><font style="font-size:10px"><cf_translate key="CHK_Posibilidad_de_viajar ">Posibilidad de viajar</cf_translate></font></td>
												<tr>
												<tr>
													<td colspan="1">&nbsp;</td>
													<td colspan="2"><input type="checkbox" <cfif isdefined("form.RHOPosTralado")>checked</cfif> name="RHOPosTralado" tabindex="1" value="1"><font style="font-size:10px"><cf_translate key="CHK_Posibilidad_de_trasladarse_a_otra_ciudad_y/o_pais">Posibilidad de trasladarse a otra ciudad y/o pa&iacute;s</cf_translate></font></td>
												<tr>
												<tr>
													<td colspan="1">&nbsp;</td>
													<td colspan="2"><input type="checkbox" <cfif isdefined("form.RHOEntrevistado")>checked</cfif> name="RHOEntrevistado" tabindex="1" value="1"><font style="font-size:10px"><cf_translate key="CHK_Entrevistado">Entrevistado(a)</cf_translate></font></td>
												<tr>
												<tr id="divPosibilidadViajar">
													<td>&nbsp;</td>
													<td><font  style="font-size:10px"><cf_translate key="LB_ZonasDePreferencia">Zonas de preferencia</cf_translate></font>
														<cfset listaIDs1=''>
														<cfif isDefined("form.ListaUGid") and len(trim(form.ListaUGid))>
															<cfset listaIDs1=form.ListaUGid>
														</cfif>
														<cf_translatedata name="get" tabla="UnidadGeografica" conexion="asp" col="UGdescripcion" returnvariable="LvarUGdescripcion">
															<cf_translatedata name="get" tabla="UnidadGeografica" conexion="asp" col="x.UGdescripcion" returnvariable="LvarUGdescripcionX">
														<cf_translatedata name="get" tabla="AreaGeografica" conexion="asp" col="b.AGdescripcion" returnvariable="LvarAGdescripcion">

														<cf_conlis
														Campos="UGid,AGdescripcion,pertenece,UGdescripcion"
														Desplegables="N,N,N,S"
														Modificables="N,S,S,S"
														Size="0,25,20,20"
														tabindex="1"
														Title="#LB_ListaDeLugares#"
														Tabla="UnidadGeografica a
																inner join AreaGeografica b
																	on a.AGid=b.AGid
																	and b.AGesconsultable = 1"
														Columnas="a.UGid,UGcodigo,#LvarAGdescripcion# as AGdescripcion,a.UGid as UGid2,UGcodigo,#LvarUGdescripcion# as UGdescripcion, (select x.UGdescripcion from UnidadGeografica x where x.UGid = a.UGidpadre) as pertenece"
														Desplegar="AGdescripcion,pertenece,UGdescripcion"
														Etiquetas="#LB_Tipo#,#LB_Pertenece_A#,#LB_Lugar#"
														filtro=" 1=1 order by 7,3,6"
														filtrar_por="#LvarAGdescripcion#|(select #LvarUGdescripcionX# from UnidadGeografica x where x.UGid = a.UGidpadre)|#LvarUGdescripcion#"
														filtrar_por_delimiters="|"
														conexion="asp"
														Formatos="S,S,S,S"
														Align="left,left,left,left"
														Asignar="UGid,UGid,UGid,UGdescripcion"
														agregarEnLista="true"
														ListaIdDefault="#listaIDs1#"
														Asignarformatos="X,S,S,S"
														/>
													</td>
												</tr>


											</table>
											</fieldset>
										</td>
									</tr>

									<!--- **************************************************************************************************** --->
									<!--- DOMICILIO --->
									<tr>
										<td colspan="2">
											<table width="100%" border="0" cellpadding="0" cellspacing="0">
											<tr>
												<td valign="top">
													<fieldset><legend><cf_translate key="LB_Domicilio">Domicilio</cf_translate></legend>
														<table width="100%" border="0" cellpadding="0" cellspacing="0"  style="height:80px;">
															<tr>
																<td width="15%"><font style="font-size:10px"><cf_translate key="LB_Zona1">Zona1</cf_translate></font></td>
																<td>
																	<input
																		name="Zona1"
																		type="text"
																		id="Zona1"
																		maxlength="50"
																		size="30"
																		tabindex="1"
																		style="font-size:10px"
																		value="<cfif isdefined("form.Zona1") and len(trim(form.Zona1))>#form.Zona1#</cfif>">
																</td>
															</tr>
															<tr>
																<td><font style="font-size:10px"><cf_translate key="LB_Zona2">Zona2</cf_translate></font></td>
																<td>
																	<input
																		name="Zona2"
																		type="text"
																		id="Zona2"
																		maxlength="50"
																		size="30"
																		tabindex="1"
																		style="font-size:10px"
																		value="<cfif isdefined("form.Zona2") and len(trim(form.Zona2))>#form.Zona2#</cfif>">
																</td>
															</tr>
															<tr>
																<td><font style="font-size:10px"><cf_translate key="LB_Zona3">Zona3</cf_translate></font></td>
																<td>
																	<input
																		name="Zona3"
																		type="text"
																		id="Zona3"
																		maxlength="50"
																		size="30"
																		tabindex="1"
																		style="font-size:10px"
																		value="<cfif isdefined("form.Zona3") and len(trim(form.Zona3))>#form.Zona3#</cfif>">
																</td>
															</tr>
														</table>
													</fieldset>
												</td>
												<td width="50%" valign="top">
													<fieldset><legend><cf_translate key="LB_Idioma">Idioma</cf_translate></legend>
														<table width="100%" border="0" cellpadding="0" cellspacing="0" style="height:80px;">
															<tr>
																<td><input type="checkbox" <cfif isdefined("form.RHOIdioma") and  ListContains(form.RHOIdioma,1) NEQ 0>checked</cfif> name="RHOIdioma" tabindex="1" value="1"><font style="font-size:10px"><cf_translate key="LB_ALEMAN">ALEMAN</cf_translate></font></td>
																<td><input type="checkbox" <cfif isdefined("form.RHOIdioma") and  ListContains(form.RHOIdioma,2) NEQ 0>checked</cfif> name="RHOIdioma" tabindex="1" value="2"><font style="font-size:10px"><cf_translate key="LB_ESPANOL">ESPA&Ntilde;OL</cf_translate></font></td>										</tr>
															<tr>
																<td><input type="checkbox" <cfif isdefined("form.RHOIdioma") and  ListContains(form.RHOIdioma,3) NEQ 0>checked</cfif> name="RHOIdioma" tabindex="1" value="3"><font style="font-size:10px"><cf_translate key="LB_FRANCES">FRANCES</cf_translate></font></td>
																<td><input type="checkbox" <cfif isdefined("form.RHOIdioma") and  ListContains(form.RHOIdioma,4) NEQ 0>checked</cfif> name="RHOIdioma" tabindex="1" value="4"><font style="font-size:10px"><cf_translate key="LB_INGLES">INGLES</cf_translate></font></td>
															</tr>
															<tr>
																<td><input type="checkbox" <cfif isdefined("form.RHOIdioma") and  ListContains(form.RHOIdioma,5) NEQ 0>checked</cfif> name="RHOIdioma" tabindex="1" value="5"><font style="font-size:10px"><cf_translate key="LB_ITALIANO">ITALIANO</cf_translate></font></td>
																<td><input type="checkbox" <cfif isdefined("form.RHOIdioma") and  ListContains(form.RHOIdioma,6) NEQ 0>checked</cfif> name="RHOIdioma" tabindex="1" value="6"><font style="font-size:10px"><cf_translate key="LB_JAPONES">JAPONES</cf_translate></font></td>
															</tr>
															<tr>
																<td><input type="checkbox" <cfif isdefined("form.RHOIdioma") and  ListContains(form.RHOIdioma,7) NEQ 0>checked</cfif> name="RHOIdioma" tabindex="1" value="7"><font style="font-size:10px"><cf_translate key="LB_PORTUGUES">PORTUGUES</cf_translate></font></td>
																<td><input type="checkbox" <cfif isdefined("form.RHOIdioma") and  ListContains(form.RHOIdioma,8) NEQ 0>checked</cfif> name="RHOIdioma" tabindex="1" value="8"><font style="font-size:10px"><cf_translate key="LB_MANDARIN">MANDARIN</cf_translate></font></td>

															</tr>


														</table>
													</fieldset>
												</td>
											</tr>
										</table>
									</tr>
									<!--- **************************************************************************************************** --->
									<!--- Estudios --->
									<tr>
										<td colspan="2">
											<fieldset><legend><cf_translate key="LB_Estudios">Estudios</cf_translate></legend>
												<table id="tbldynamic" align="center" width="100%" border="0" cellspacing="0" cellpadding="0">
													<tr>
														<td  valign="middle" width="15%" nowrap="nowrap">
															<font style="font-size:10px"><cf_translate key="LB_no_formal">No formal</cf_translate></font>
														 </td>
														<td  valign="bottom" colspan="4">
															<input
																name="CapNoFormal"
																type="text"
																id="CapNoFormal"
																tabindex="1"
																style="font-size:10px"
																maxlength="1024"
																size="60"
																value="<cfif isdefined("form.CapNoFormal") and len(trim(form.CapNoFormal))>#form.CapNoFormal#</cfif>">
														</td>
													</tr>
													<tr>
														<td  colspan="6">
															<HR>
														 </td>
													</tr>
													<tr>
														<td  valign="middle" width="15%">
															<font style="font-size:10px"><cf_translate key="LB_Nivel">Nivel</cf_translate></font>
														 </td>
														<td  valign="bottom" colspan="4" nowrap="nowrap">
															<cfinvoke component="sif.Componentes.Translate"
															method="Translate"
															Key="MSG_Lista_de_Niveles"
															Default="Lista de Niveles"
															returnvariable="MSG_Lista_de_Niveles"/>

															<input
																name="GAnombre"
																type="text"
																id="GAnombre"
																tabindex="1"
																style="font-size:10px"
																maxlength="100"
																size="60"
																value="<cfif isdefined("form.GAnombre") and len(trim(form.GAnombre))>#form.GAnombre#</cfif>">

															<a href="##" tabindex="-1">
															<img src="/cfmx/rh/imagenes/Description.gif"
																	alt="#MSG_Lista_de_Niveles#"
																	name="imagen"
																	width="18"
																	height="14"
																	border="0"
																	align="absmiddle"
																	onClick='javascript: doConlisNivel();'>
															</a>
														</td>
													</tr>
													<tr>
														<td  colspan="6">
															<HR>
														 </td>
													</tr>

													<tr>
														<td  valign="middle" width="15%">
															<font style="font-size:10px"><cf_translate key="LB_Titulo">Titulo</cf_translate></font>
														 </td>
														<td  valign="bottom" colspan="4" nowrap="nowrap">
															<input
																name="RHOTDescripcion"
																type="text"
																id="RHOTDescripcion"
																tabindex="1"
																style="font-size:10px"
																maxlength="100"
																size="60"
																value="<cfif isdefined("form.RHOTDescripcion") and len(trim(form.RHOTDescripcion))>#form.RHOTDescripcion#</cfif>">

															<cfinvoke component="sif.Componentes.Translate"
															method="Translate"
															Key="MSG_Lista_de_titulos"
															Default="Lista de titulos"
															returnvariable="MSG_Lista_de_titulos"/>

															<a href="##" tabindex="-1">
															<img src="/cfmx/rh/imagenes/Description.gif"
																	alt="#MSG_Lista_de_titulos#"
																	name="imagen"
																	width="18"
																	height="14"
																	border="0"
																	align="absmiddle"
																	onClick='javascript: doConlisTitulos();'>
															</a>

														</td>
														<cfinvoke component="sif.Componentes.Translate"
															method="Translate"
															Key="LB_Agregar"
															Default="Agregar"
															returnvariable="LB_Agregar"/>

														<td   width="5%"  >
														<input type="button" name="Agregar" value="+" onClick="javascript: return fnNuevoTR();" />
														</td>
													</tr>
													<tr>
														<td  colspan="6">
															<HR>
														 </td>
													</tr>

													<tr>
														<td  valign="middle" width="15%" nowrap="nowrap">
															<font style="font-size:10px"><cf_translate key="LB_no_formal">No formal</cf_translate></font>
														 </td>
														<td  valign="bottom" colspan="4">
															<input
																name="CapNoFormal"
																type="text"
																id="CapNoFormal"
																tabindex="1"
																style="font-size:10px"
																maxlength="1024"
																size="60"
																value="<cfif isdefined("form.CapNoFormal") and len(trim(form.CapNoFormal))>#form.CapNoFormal#</cfif>">
														</td>
													</tr>

													<input type="hidden" name="LastOne" id="LastOne" value="ListaNon">
													<input type="hidden" name="CorreoDe"   		id="CorreoDe"       value="">
													<input type="hidden" name="CorreoPAra" 		id="CorreoPAra"      value="">
													<input type="hidden" name="AccionAEjecutar" id="AccionAEjecutar" value="">
													<input type="hidden" name="CONDICIONES"     id="CONDICIONES"     value="">

												</table>
											</fieldset>
										</td>
									</tr>
								</table>
							</fieldset>
						</td>
						<td valign="top">
							<fieldset><legend>#LB_Posibles_Candidatos#</legend>
							<cfset navegacion = "">
							<cfset Algunfiltro = false>
							<cfif isdefined("form.RHOsexo") and len(trim(form.RHOsexo)) gt 0>
								<cfset navegacion = navegacion & "&RHOsexo=#form.RHOsexo#">
								<cfset Algunfiltro = true>
							</cfif>
							<cfif isdefined("form.Ppais") and len(trim(form.Ppais)) gt 0>
								<cfset navegacion = navegacion & "&Ppais=#form.Ppais#">
								<cfset Algunfiltro = true>
							</cfif>
							<cfif isdefined("form.TPOPRETEN") and len(trim(form.TPOPRETEN)) gt 0>
								<cfset navegacion = navegacion & "&TPOPRETEN=#form.TPOPRETEN#">
							</cfif>

							<cfif isdefined("form.RHOMonedaPrt") and len(trim(form.RHOMonedaPrt)) gt 0>
								<cfset navegacion = navegacion & "&RHOMonedaPrt=#form.RHOMonedaPrt#">
							</cfif>

							<cfif isdefined("form.RHOPrenteInf") and len(trim(form.RHOPrenteInf)) gt 0>
								<cfset navegacion = navegacion & "&RHOPrenteInf=#form.RHOPrenteInf#">
								<cfset Algunfiltro = true>
							</cfif>

							<cfif isdefined("form.RHOPrenteSup") and len(trim(form.RHOPrenteSup)) gt 0>
								<cfset navegacion = navegacion & "&RHOPrenteSup=#form.RHOPrenteSup#">
								<cfset Algunfiltro = true>
							</cfif>

							<cfif isdefined("form.TPOEXPE") and len(trim(form.TPOEXPE)) gt 0>
								<cfset navegacion = navegacion & "&TPOEXPE=#form.TPOEXPE#">
							</cfif>

							<cfif isdefined("form.ExperienciaSup") and len(trim(form.ExperienciaSup)) gt 0>
								<cfset navegacion = navegacion & "&ExperienciaSup=#form.ExperienciaSup#">
								<cfset Algunfiltro = true>
							</cfif>

							<cfif isdefined("form.ExperienciaInf") and len(trim(form.ExperienciaInf)) gt 0>
								<cfset navegacion = navegacion & "&ExperienciaInf=#form.ExperienciaInf#">
								<cfset Algunfiltro = true>
							</cfif>

							<cfif isdefined("form.RHPcodigo") and len(trim(form.RHPcodigo)) gt 0>
								<cfset navegacion = navegacion & "&RHPcodigo=#form.RHPcodigo#">
								<cfset Algunfiltro = true>
							</cfif>

							<cfif isdefined("form.RHOPDescripcion") and len(trim(form.RHOPDescripcion)) gt 0>
								<cfset navegacion = navegacion & "&RHOPDescripcion=#form.RHOPDescripcion#">
								<cfset Algunfiltro = true>
							</cfif>

							<cfif isdefined("form.CapNoFormal") and len(trim(form.CapNoFormal)) gt 0>
								<cfset navegacion = navegacion & "&CapNoFormal=#form.CapNoFormal#">
								<cfset Algunfiltro = true>
							</cfif>


							<cfif isdefined("form.Zona1") and len(trim(form.Zona1)) gt 0>
								<cfset navegacion = navegacion & "&Zona1=#form.Zona1#">
								<cfset Algunfiltro = true>
							</cfif>

							<cfif isdefined("form.Zona2") and len(trim(form.Zona2)) gt 0>
								<cfset navegacion = navegacion & "&Zona2=#form.Zona2#">
								<cfset Algunfiltro = true>
							</cfif>
							<cfif isdefined("form.Zona3") and len(trim(form.Zona3)) gt 0>
								<cfset navegacion = navegacion & "&Zona3=#form.Zona3#">
								<cfset Algunfiltro = true>
							</cfif>

							<cfif isdefined("form.RHOIdioma") and len(trim(form.RHOIdioma)) gt 0>
								<cfset navegacion = navegacion & "&RHOIdioma=#form.RHOIdioma#">
								<cfset Algunfiltro = true>
							</cfif>

							<cfif isdefined("form.RHCGIDLIST") and len(trim(form.RHCGIDLIST)) gt 0>
								<cfset navegacion = navegacion & "&RHCGIDLIST=#form.RHCGIDLIST#">
								<cfset Algunfiltro = true>
							</cfif>

							<cfif isdefined("form.RHORefValida") and len(trim(form.RHORefValida)) gt 0>
								<cfset navegacion = navegacion & "&RHORefValida=#form.RHORefValida#">
								<cfset Algunfiltro = true>
							</cfif>

							<cfif isdefined("form.RHOPosViajar") and len(trim(form.RHOPosViajar)) gt 0>
								<cfset navegacion = navegacion & "&RHOPosViajar=#form.RHOPosViajar#">
								<cfset Algunfiltro = true>
							</cfif>

							<cfif isdefined("form.RHOPosTralado") and len(trim(form.RHOPosTralado)) gt 0>
								<cfset navegacion = navegacion & "&RHOPosTralado=#form.RHOPosTralado#">
								<cfset Algunfiltro = true>
							</cfif>

							<cfif isdefined("form.RHOEntrevistado") and len(trim(form.RHOEntrevistado)) gt 0>
								<cfset navegacion = navegacion & "&RHOEntrevistado=#form.RHOEntrevistado#">
								<cfset Algunfiltro = true>
							</cfif>

							<cf_dbfunction name="to_char" args="a.RHOid" returnvariable="Lvar_to_char_RHOid">

							<cfif isdefined("form.AccionAEjecutar") and trim(form.AccionAEjecutar) EQ 'BUSCAR'>
								<cfset Algunfiltro = true>
							</cfif>

							<cfset vIdiomas = '' >
							<cfif isdefined("form.RHOIdioma") and len(trim(form.RHOIdioma)) gt 0 >
								<cfset vIdiomas = form.RHOIdioma >
							</cfif>

							<!---- filtro de lugares donde podria viajar--->
							<cfset LvarfiltroLugares=''>
					 		<cfif isdefined("form.ListaUGid") and len(trim(form.ListaUGid))>
					 			<cfset LvarListLugares=geo.getHijos(form.ListaUGid)>
					 			<cfset LvarfiltroLugares = '(select count(1) from RHOferentesLugares where RHOid = a.RHOid and RHOLtipo = 0 and UGid in (#LvarListLugares#)) > 0'>
					 		</cfif>

							<cfquery name="rsLista" datasource="#session.DSN#">
								select
									<cfif (isdefined("form.RHPcodigo") and len(trim(form.RHPcodigo)) gt 0 ) or (isdefined("form.RHOPDescripcion") and len(trim(form.RHOPDescripcion)) gt 0)
									or (isdefined("form.RHCGIDLIST") and len(trim(form.RHCGIDLIST)) gt 0) or (isdefined("form.CapNoFormal") and len(trim(form.CapNoFormal)) gt 0)>
										distinct
									</cfif>

									a.RHOid,
									{fn concat({fn concat({fn concat({fn concat(RHOapellido1 , ' ' )},RHOapellido2 )}, ',' )}, RHOnombre )} as nombre,
									ltrim(rtrim(a.RHOtelefono1))  as RHOtelefono1,
									ltrim(rtrim(a.RHOtelefono2)) as RHOtelefono2,
									a.RHOsexo,
									{fn concat('<a href="javascript: vercurriculum(1,',{fn concat(#Lvar_to_char_RHOid#,');"><img src=''/cfmx/rh/imagenes/findsmall.gif'' border=''0''></a>')})} as VC,
									{fn concat('<a href="javascript: vercurriculum(2,',{fn concat(#Lvar_to_char_RHOid#,');"><img src=''/cfmx/rh/imagenes/impresora.gif'' border=''0''></a>')})} as IC,
									(	select coalesce(sum(RHEEAnnosLab),0)
											from RHExperienciaEmpleado b
											where b.RHOid = a.RHOid
											<cfif isdefined("form.RHOPDescripcion") and len(trim(form.RHOPDescripcion)) gt 0>
												and b.RHOPid	 in ( select RHOPid from RHOPuesto where CEcodigo =#Session.CEcodigo#
																and upper(RHOPDescripcion) like  '%#Ucase(form.RHOPDescripcion)#%')
											</cfif>
									) as experiencia,
									RHOPrenteInf,
									RHOPrenteSup
									<cfif isdefined("form.RHPcodigo") and len(trim(form.RHPcodigo)) gt 0>
										,b.RHOPid
										,e.RHOPDescripcion
										,coalesce(d.RHPcodigoext,d.RHPcodigo) as RHPcodigoext
										,RHPdescpuesto
									<cfelseif isdefined("form.RHOPDescripcion") and len(trim(form.RHOPDescripcion)) gt 0>
										,b.RHOPid
										,e.RHOPDescripcion
									</cfif>
								from DatosOferentes a
								<cfif (isdefined("form.RHPcodigo") and len(trim(form.RHPcodigo)) gt 0) and (isdefined("form.RHOPDescripcion") and len(trim(form.RHOPDescripcion)) gt 0)>
									inner join RHExperienciaEmpleado  b
										on b.RHOid  = a.RHOid
										and b.Ecodigo = a.Ecodigo
										and b.RHOPid	 in ( select RHOPid from RHOPuesto where CEcodigo =#Session.CEcodigo#
																and upper(RHOPDescripcion) like  '%#Ucase(form.RHOPDescripcion)#%')
									inner join RHOPuestoEquival  c
										on c.RHOPid  = b.RHOPid
										and c.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">
									inner join RHPuestos d
										on 	d.RHPcodigo = c.RHPcodigo
									inner join RHOPuesto e
										on 	e.RHOPid = b.RHOPid
								<cfelseif isdefined("form.RHPcodigo") and len(trim(form.RHPcodigo)) gt 0>
									inner join RHExperienciaEmpleado  b
										on b.RHOid  = a.RHOid
										and b.Ecodigo = a.Ecodigo
									inner join RHOPuestoEquival  c
										on c.RHOPid  = b.RHOPid
										and c.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">
									inner join RHPuestos d
										on 	d.RHPcodigo = c.RHPcodigo
									inner join RHOPuesto e
										on 	e.RHOPid = b.RHOPid
								<cfelseif isdefined("form.RHOPDescripcion") and len(trim(form.RHOPDescripcion)) gt 0>
									inner join RHExperienciaEmpleado  b
										on b.RHOid  = a.RHOid
										and b.Ecodigo = a.Ecodigo
										and b.RHOPid	 in ( select RHOPid from RHOPuesto where CEcodigo =#Session.CEcodigo#
											and upper(RHOPDescripcion) like  '%#Ucase(form.RHOPDescripcion)#%')
									inner join RHOPuesto e
										on 	e.RHOPid = b.RHOPid
								</cfif>
								<cfif  (isdefined("form.Zona1") and len(trim(form.Zona1)) gt 0)
									or (isdefined("form.Zona2") and len(trim(form.Zona2)) gt 0)
									or (isdefined("form.Zona3") and len(trim(form.Zona3)) gt 0)>
									inner join Direcciones  g
										on 	 a.id_direccion =  g.id_direccion
										<cfif  (isdefined("form.Zona1") and len(trim(form.Zona1)) gt 0)>
											and upper(g.ciudad) like '%#Ucase(form.Zona1)#%'
										</cfif>
										<cfif  (isdefined("form.Zona2") and len(trim(form.Zona2)) gt 0)>
											and upper(g.estado) like '%#Ucase(form.Zona2)#%'
										</cfif>
										<cfif  (isdefined("form.Zona3") and len(trim(form.Zona3)) gt 0)>
											and upper(g.estado) like '%#Ucase(form.Zona3)#%'
										</cfif>

								</cfif>
								<cfif (isdefined("form.CapNoFormal") and len(trim(form.CapNoFormal)) gt 0) or isdefined("form.RHCGIDLIST") and len(trim(form.RHCGIDLIST)) >
									inner join RHEducacionEmpleado  f
										on a.RHOid  = f.RHOid
										and a.Ecodigo = f.Ecodigo
										<cfif  (isdefined("form.CapNoFormal") and len(trim(form.CapNoFormal)) gt 0)>
										and upper(f.RHECapNoFormal) like '%#Ucase(form.CapNoFormal)#%'
										</cfif>
										<cfif isdefined("form.RHCGIDLIST") and len(trim(form.RHCGIDLIST))>
											 and (
											<cfset arreglo = listtoarray(form.RHCGIDLIST)>
											<cfset condicion = "">
											<cfloop from="1" to ="#arraylen(arreglo)#" index="i">
												<cfif i gt 1>
													<cfset condicion = " or ">
												</cfif>
												<cfset arreglo2 = listtoarray(arreglo[i],'|')>
													<cfif arreglo2[1] eq '-1'>
														#condicion#(  f.RHOTid   in (select RHOTid from RHOTitulo where  CEcodigo =#Session.CEcodigo# and upper(RHOTDescripcion) like  '%#Ucase(arreglo2[2])#%') )
													<cfelse>
														#condicion#(  f.GAcodigo   in (select GAcodigo from GradoAcademico where  Ecodigo =#Session.Ecodigo# and upper(GAnombre) like  '%#Ucase(arreglo2[1])#%')
														 and    f.RHOTid   in (select RHOTid from RHOTitulo where  CEcodigo =#Session.CEcodigo# and upper(RHOTDescripcion) like  '%#Ucase(arreglo2[2])#%') )
													</cfif>
											</cfloop>
											)
										</cfif>
								</cfif>

								where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								and coalesce(a.RHAprobado,0) = 1

								<cfif isdefined("form.RHOIdioma") and len(trim(form.RHOIdioma)) gt 0>
									and (a.RHOIdioma1   in (#form.RHOIdioma#)
									or a.RHOIdioma2     in (#form.RHOIdioma#)
									or a.RHOIdioma3     in (#form.RHOIdioma#) )
								</cfif>
								<cfif isdefined("form.RHORefValida")>
									and coalesce(RHORefValida,0)  = 1
								</cfif>
								<cfif isdefined("form.RHOPosViajar")>
									and coalesce(RHOPosViajar,0)  = 1
								</cfif>
								<cfif isdefined("form.RHOPosTralado")>
									and coalesce(RHOPosTralado,0)  = 1
								</cfif>

								<cfif len(trim(LvarfiltroLugares))><!---- si se indican los lugares, se filtra por Zonas de preferencia---->
									and #preserveSingleQuotes(LvarfiltroLugares)#
								</cfif>

								<cfif isdefined("form.RHOEntrevistado")>
									and coalesce(RHOEntrevistado,0)  = 1
								</cfif>
								<cfif Algunfiltro eq false>
										and 1 = 2
								</cfif>

								<cfif isdefined("form.RHOsexo") and len(trim(form.RHOsexo)) gt 0>
									 and  upper(rtrim(RHOsexo)) = <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(trim(form.RHOsexo))#">
								</cfif>

								<cfif isdefined("form.s") and len(trim(form.Ppais)) gt 0>
									 and  upper(rtrim(a.Ppais)) = <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(trim(form.Ppais))#">
								</cfif>

								 <cfif isdefined("form.TPOPRETEN") and len(trim(form.TPOPRETEN)) gt 0>
									<cfswitch expression="#form.TPOPRETEN#">
										<cfcase value="1">
											<cfif isdefined("form.RHOPrenteInf") and len(trim(form.RHOPrenteInf)) gt 0>
												and upper(rtrim(RHOMonedaPrt)) = <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(trim(form.RHOMonedaPrt))#">
												and  RHOPrenteInf >= <cfqueryparam cfsqltype="cf_sql_float" value="#replace(form.RHOPrenteInf, ',','','all')#">
											</cfif>
											<cfif isdefined("form.RHOPrenteSup") and len(trim(form.RHOPrenteSup)) gt 0>
												and upper(rtrim(RHOMonedaPrt)) = <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(trim(form.RHOMonedaPrt))#">
												and  RHOPrenteSup <= <cfqueryparam cfsqltype="cf_sql_float" value="#replace(form.RHOPrenteSup, ',','','all')#">
											</cfif>
										</cfcase>
										<cfcase value="2">
											<cfif isdefined("form.RHOPrenteInf") and len(trim(form.RHOPrenteInf)) gt 0>
												and upper(rtrim(RHOMonedaPrt)) = <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(trim(form.RHOMonedaPrt))#">
												and  RHOPrenteInf >= <cfqueryparam cfsqltype="cf_sql_float" value="#replace(form.RHOPrenteInf, ',','','all')#">
											</cfif>
										</cfcase>
										<cfcase value="3">
											<cfif isdefined("form.RHOPrenteSup") and len(trim(form.RHOPrenteSup)) gt 0>
												and upper(rtrim(RHOMonedaPrt)) = <cfqueryparam cfsqltype="cf_sql_char" value="#Ucase(trim(form.RHOMonedaPrt))#">
												and  RHOPrenteInf <= <cfqueryparam cfsqltype="cf_sql_float" value="#replace(form.RHOPrenteSup, ',','','all')#">
											</cfif>
										</cfcase>
									</cfswitch>
								</cfif>
								<cfif isdefined("form.TPOEXPE") and len(trim(form.TPOEXPE)) gt 0>
									<cfswitch expression="#form.TPOEXPE#">
										<cfcase value="1">
											<cfif isdefined("form.ExperienciaSup") and len(trim(form.ExperienciaSup)) gt 0>
												and  (select coalesce(sum(RHEEAnnosLab),0) from RHExperienciaEmpleado b
													  where b.RHOid = a.RHOid
													  <cfif isdefined("form.RHOPDescripcion") and len(trim(form.RHOPDescripcion)) gt 0>
														and b.RHOPid	 in ( select RHOPid from RHOPuesto where CEcodigo =#Session.CEcodigo#
																and upper(RHOPDescripcion) like  '%#Ucase(form.RHOPDescripcion)#%')
													  </cfif>
													  )
												>= <cfqueryparam cfsqltype="cf_sql_float" value="#replace(form.ExperienciaSup, ',','','all')#">

											</cfif>
										</cfcase>
										<cfcase value="2">
											<cfif isdefined("form.ExperienciaInf") and len(trim(form.ExperienciaInf)) gt 0>
												and (select coalesce(sum(RHEEAnnosLab),0) from RHExperienciaEmpleado b
												where b.RHOid = a.RHOid
													  <cfif isdefined("form.RHOPDescripcion") and len(trim(form.RHOPDescripcion)) gt 0>
														and b.RHOPid	 in ( select RHOPid from RHOPuesto where CEcodigo =#Session.CEcodigo#
															and upper(RHOPDescripcion) like  '%#Ucase(form.RHOPDescripcion)#%')

													  </cfif>
												)
												<=  <cfqueryparam cfsqltype="cf_sql_float" value="#replace(form.ExperienciaInf, ',','','all')#">
											</cfif>
										</cfcase>
									</cfswitch>
								</cfif>
								<cfif (isdefined("form.RHPcodigo") and len(trim(form.RHPcodigo)) gt 0 ) or (isdefined("form.RHOPDescripcion") and len(trim(form.RHOPDescripcion)) gt 0)>
									order by RHOPDescripcion,{fn concat({fn concat({fn concat({fn concat(RHOapellido1 , ' ' )},RHOapellido2 )}, ',' )}, RHOnombre )}
								<cfelse>
										order by {fn concat({fn concat({fn concat({fn concat(RHOapellido1 , ' ' )},RHOapellido2 )}, ',' )}, RHOnombre )}

								</cfif>

							</cfquery>


								<table width="100%" border="0" >
									<cfif rsLista.recordCount GT 0>
									<tr>
										<td valign="top" bgcolor="##A0BAD3">
											<cfinclude template="frame-botones2.cfm">
										</td>
									</tr>
									</cfif>
									<tr >
										<td valign="top">

												<cfinvoke component="sif.Componentes.Translate"
													method="Translate"
													Key="LB_Nombre"
													Default="Nombre"
													returnvariable="LB_Nombre"/>

												<cfinvoke component="sif.Componentes.Translate"
													method="Translate"
													Key="LB_TelCasa"
													Default="Tel. Casa"
													returnvariable="LB_TelCasa"/>

												<cfinvoke component="sif.Componentes.Translate"
													method="Translate"
													Key="LB_Celular"
													Default="Celular"
													returnvariable="LB_Celular"/>

												<cfinvoke component="sif.Componentes.Translate"
													method="Translate"
													Key="LB_Sexo"
													Default="Sexo"
													returnvariable="LB_Sexo"/>

												<cfinvoke component="sif.Componentes.Translate"
													method="Translate"
													Key="LB_ExperienciaAnnos"
													Default="Experiencia (A&ntilde;os)"
													returnvariable="LB_ExperienciaAnnos"/>

												<cfinvoke component="sif.Componentes.Translate"
													method="Translate"
													Key="LB_PuestoExterno"
													Default="Puesto Externo"
													returnvariable="LB_PuestoExterno"/>

												<cfinvoke component="sif.Componentes.Translate"
													method="Translate"
													Key="LB_ParaSeleccionarCandidatosNecesarioFiltrarAlgunCriterio"
													Default="Para seleccionar los candidatos es necesario filtrar por algún criterio"
													returnvariable="LB_ParaSeleccionarCandidatosNecesarioFiltrarAlgunCriterio"/>

												<cfinvoke
													component="rh.Componentes.pListas"
													method="pListaQuery"
													returnvariable="pListaEmpl">
													<cfinvokeargument name="query" value="#rsLista#"/>
													<cfif (isdefined("form.RHPcodigo") and len(trim(form.RHPcodigo)) gt 0 ) or (isdefined("form.RHOPDescripcion") and len(trim(form.RHOPDescripcion)) gt 0)>
														<cfinvokeargument name="Cortes" value="RHOPDescripcion">
													</cfif>
													<cfinvokeargument name="desplegar" value="nombre,RHOtelefono1, RHOtelefono2,RHOsexo,experiencia,VC,IC"/>
													<cfinvokeargument name="etiquetas" value="#LB_Nombre#,#LB_TelCasa#,#LB_Celular#,#LB_Sexo#,#LB_ExperienciaAnnos#,&nbsp;,&nbsp;"/>
													<cfinvokeargument name="formatos" value="S,S,S,S,S,V,V"/>
													<cfinvokeargument name="align" value="left,right,right,center,right,center,center"/>
													<cfinvokeargument name="ajustar" value="N"/>
													<cfinvokeargument name="debug" value="N"/>
													<cfinvokeargument name="navegacion" value="#navegacion#"/>
													<cfinvokeargument name="keys" value="RHOid"/>
													<cfinvokeargument name="Maxrows" value="25"/>
													<cfinvokeargument name="showLink" value="FALSE"/>
													<cfinvokeargument name="showEmptyListMsg" value="true"/>
													<cfinvokeargument name="EmptyListMsg" value="#LB_ParaSeleccionarCandidatosNecesarioFiltrarAlgunCriterio#"/>
													<cfinvokeargument name="incluyeForm" value="true"/>
													<cfinvokeargument name="checkboxes" value="S"/>
												</cfinvoke>

										</td>
									</tr>
								</table>
							</fieldset>
						</td>
					</tr>
				</table>

				<input type="image" id="imgDel" src="/cfmx/rh/imagenes/Borrar01_S.gif" title="#MSG_Eliminar_el_niviel_y_el_titulo#" style="display:none;">

			</form>
			</cfoutput>
		<cf_web_portlet_end>
	<cf_templatefooter>


<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_EsteValorYaFueAgregado"
	Default="Este valor ya fue agregado"
	returnvariable="MSG_EsteValorYaFueAgregado"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Debe_seleccionar_al_menos_un_titulo"
	Default="Debe seleccionar al menos un titulo"
	returnvariable="MSG_Debe_indicar_el_nivel_y_el_titulo"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Cualquier_nivel"
	Default="Cualquier nivel"
	returnvariable="MSG_Cualquier_nivel"/>

<script language="javascript" type="text/javascript">
	document.form1.RHOsexo.focus();

	function CambiaPretencion(){
		var td_RHOPrenteInf    = document.getElementById("td_RHOPrenteInf");
		var td_Y 			   = document.getElementById("td_Y");
		var td_RHOPrenteSup    = document.getElementById("td_RHOPrenteSup");

		if(document.form1.TPOPRETEN.value == '1'){
			td_RHOPrenteInf.style.display 	= "";
			td_Y.style.display 				= "";
			td_RHOPrenteSup.style.display 	= "";
		}
		else if (document.form1.TPOPRETEN.value == '2'){
			td_RHOPrenteInf.style.display 	= "" ;
			td_Y.style.display 				= "none";
			td_RHOPrenteSup.style.display 	= "none";

		}
		else if (document.form1.TPOPRETEN.value == '3'){
			td_RHOPrenteInf.style.display	= "none";
			td_Y.style.display 				= "none";
			td_RHOPrenteSup.style.display 	= "";
		}

	}

	function CambiaExperiencia(){
		var ExperienciaSup = document.getElementById("ExperienciaSup");
		var ExperienciaInf    = document.getElementById("ExperienciaInf");

		if(document.form1.TPOEXPE.value == '1'){
			ExperienciaSup.style.display 	= "" ;
			ExperienciaInf.style.display 	= "none";

		}
		else if (document.form1.TPOEXPE.value == '2'){
			ExperienciaSup.style.display	= "none";
			ExperienciaInf.style.display 	= "";
		}

	}

	CambiaPretencion();
	CambiaExperiencia();

	<!--- AREA DE LOS TD DE ESTUDIOS  --->



	var GvarNewTD;

	<cfif isdefined("form.RHCGIDLIST") and len(trim(form.RHCGIDLIST))>
		<cfset arreglo = listtoarray(form.RHCGIDLIST)>
		<cfloop from="1" to ="#arraylen(arreglo)#" index="i">
			<cfset arreglo2 = listtoarray(arreglo[i],'|')>
					<!--- <cfquery name="rsNivel" datasource="#session.DSN#">
						select
							GAnombre
						from GradoAcademico
						where  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and    GAcodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arreglo2[1]#">
					</cfquery>
					<cfquery name="rsTitulo" datasource="#session.DSN#">
						select
							RHOTDescripcion
						from RHOTitulo
						where  CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
						and    RHOTid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arreglo2[2]#">
					</cfquery> --->

					<cfif arreglo2[1] eq '-1'>
						<cfset descripcion = '( '& MSG_Cualquier_nivel & ' )' & arreglo2[2]>
					<cfelse>
						<cfset descripcion = '( '& arreglo2[1] & ' )' & arreglo2[2]>
					</cfif>

					fnNuevoTRSP('<cfoutput>#arreglo2[1]#</cfoutput>','<cfoutput>#arreglo2[2]#</cfoutput>','<cfoutput>#descripcion#</cfoutput>');

		</cfloop>
	</cfif>


	function fnNuevoTRSP(p1,p2,p3){
	  var LvarTable = document.getElementById("tbldynamic");
	  var LvarTbody = LvarTable.tBodies[0];
	  var LvarTR    = document.createElement("TR");

	  var Lclass 	= document.form1.LastOne;


	  // Valida no agregar vacíos

	  if (p1=="" || p2=="") {
	  alert('<cfoutput>#MSG_Debe_indicar_el_nivel_y_el_titulo#</cfoutput>')
	  return;
	  }

	  if (existeCodigo(p1+'|'+p2)) {alert('<cfoutput>#MSG_EsteValorYaFueAgregado#</cfoutput>');return;}


	  // Agrega Columna 1
	  sbAgregaTdInput (LvarTR, Lclass.value, p1+'|'+p2, "hidden", "RHCGidList");

	  // Agrega Columna 2
	  sbAgregaTdText  (LvarTR, Lclass.value, p3 );

	  // Agrega Evento de borrado
	  sbAgregaTdImage (LvarTR, Lclass.value, "imgDel");
	  if (document.all)
		GvarNewTD.attachEvent ("onclick", sbEliminarTR);
	  else
		GvarNewTD.addEventListener ("click", sbEliminarTR, false);

	  // Nombra el TR
	  LvarTR.name = "XXXXX";
	  // Agrega el TR al Tbody
	  LvarTbody.appendChild(LvarTR);

	  if (Lclass.value=="ListaNon")
		Lclass.value="ListaPar";
	  else
		Lclass.value="ListaNon";

	}


	function fnNuevoTR(){
	  var LvarTable = document.getElementById("tbldynamic");
	  var LvarTbody = LvarTable.tBodies[0];
	  var LvarTR    = document.createElement("TR");

	  var Lclass 	= document.form1.LastOne;

	  var p1 		= document.form1.GAnombre.value;//id
	  if (p1==""){
	  	p1="-1";
	  }
	  var p2 		= document.form1.RHOTDescripcion.value;//cod
	  if ( p1=="-1")
	 	  var p3 		= '( <cfoutput># MSG_Cualquier_nivel#</cfoutput> ) '+ document.form1.RHOTDescripcion.value;//descripcion
	  else
	 	  var p3 		= '( ' +document.form1.GAnombre.value +' ) '+ document.form1.RHOTDescripcion.value;//descripcion
	  // Valida no agregar vacíos
	  if (p1=="" || p2=="") {
	  alert('<cfoutput>#MSG_Debe_indicar_el_nivel_y_el_titulo#</cfoutput>')
	  return;
	  }

	  // Valida no agregar repetidos


	  if (existeCodigo(p1+'|'+p2)) {alert('<cfoutput>#MSG_EsteValorYaFueAgregado#</cfoutput>');return;}


	  // Agrega Columna 1
	  sbAgregaTdInput (LvarTR, Lclass.value, p1+'|'+p2, "hidden", "RHCGidList");

	  // Agrega Columna 2
	  sbAgregaTdText  (LvarTR, Lclass.value, p3 );

	  // Agrega Evento de borrado
	  sbAgregaTdImage (LvarTR, Lclass.value, "imgDel");
	  if (document.all)
		GvarNewTD.attachEvent ("onclick", sbEliminarTR);
	  else
		GvarNewTD.addEventListener ("click", sbEliminarTR, false);

	  // Nombra el TR
	  LvarTR.name = "XXXXX";
	  // Agrega el TR al Tbody
	  LvarTbody.appendChild(LvarTR);

	  if (Lclass.value=="ListaNon")
		Lclass.value="ListaPar";
	  else
		Lclass.value="ListaNon";
	}
//Función para eliminar TRs
		function sbEliminarTR(e)
		{
		  var LvarTR;

		  if (document.all)
			LvarTR = e.srcElement;
		  else
			LvarTR = e.currentTarget;

		  while (LvarTR.name != "XXXXX")
			LvarTR = LvarTR.parentNode;

		  LvarTR.parentNode.removeChild(LvarTR);
		}

		//Función para agregar Imagenes
		function sbAgregaTdImage (LprmTR, LprmClass, LprmNombre)
		{
		  // Copia una imagen existente
		  var LvarTDimg    = document.createElement("TD");
		  var LvarImg = document.getElementById(LprmNombre).cloneNode(true);
		  LvarImg.style.display="";
		  LvarTDimg.appendChild(LvarImg);
		  if (LprmClass != "") LvarTDimg.className = LprmClass;

		  GvarNewTD = LvarTDimg;
		  LprmTR.appendChild(LvarTDimg);
		}

		//Función para agregar TDs con texto
		function sbAgregaTdText (LprmTR, LprmClass, LprmValue)
		{
		  var LvarTD    = document.createElement("TD");

		  var LvarTxt   = document.createTextNode(LprmValue);
		  LvarTD.appendChild(LvarTxt);
		  if (LprmClass!="") LvarTD.className = LprmClass;
		  GvarNewTD = LvarTD;
		  LprmTR.appendChild(LvarTD);
		}

		//Función para agregar TDs con Objetos
		function sbAgregaTdInput (LprmTR, LprmClass, LprmValue, LprmType, LprmName)
		{
		  var LvarTD    = document.createElement("TD");

		  var LvarInp   = document.createElement("INPUT");
		  LvarInp.type = LprmType;
		  if (LprmName!="") LvarInp.name = LprmName;
		  if (LprmValue!="") LvarInp.value = LprmValue;
		  LvarTD.appendChild(LvarInp);
		  if (LprmClass!="") LvarTD.className = LprmClass;
		  GvarNewTD = LvarTD;
		  LprmTR.appendChild(LvarTD);
		}

		function existeCodigo(v){
			var LvarTable = document.getElementById("tbldynamic");
			for (var i=0; i<LvarTable.rows.length; i++)
			{
				var  valor = fnTdValue(LvarTable.rows[i]);

				if (valor==v){
					return true;
				}
			}
			return false;
		}

		function fnTdValue(LprmNode)
		{
		  var LvarNode = LprmNode;

		  while (LvarNode.hasChildNodes())
		  {
			LvarNode = LvarNode.firstChild;
			if (document.all == null)
			{
			  if (!LvarNode.firstChild && LvarNode.nextSibling != null &&
				LvarNode.nextSibling.hasChildNodes())
				LvarNode = LvarNode.nextSibling;
			}
		  }
		  if (LvarNode.value)
			return LvarNode.value;
		  else
			return LvarNode.nodeValue;
		}

		function  vercurriculum (modo,key){
			var PARAM  = "Curriculum.cfm?RHOid="+ key + "&modo=" + modo
			open(PARAM,'Curriculum','left=100,top=150,scrollbars=yes,resizable=yes,width=900,height=450')
		}

		function  doConlisNivel (){
			var params ="";
			params = "ConlisNivel.cfm?form=form1&name=GAnombre";
			open(params,'ConlisNivel','left=200,top=150,scrollbars=yes,resizable=yes,width=650,height=400')
		}

		function  doConlisTitulos (){
			var params ="";
			params = "ConlisTitulos.cfm?form=form1&name=RHOTDescripcion";
			open(params,'ConlisTitulos','left=200,top=150,scrollbars=yes,resizable=yes,width=650,height=400')
		}

		function  doConlisPexternos (){
			var params ="";
			params = "ConlisPexternos.cfm?form=form1&name=RHOPDescripcion";
			open(params,'ConlisPexternos','left=200,top=150,scrollbars=yes,resizable=yes,width=650,height=400')
		}


</script>