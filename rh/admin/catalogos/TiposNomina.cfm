<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>

	<cf_templateheader title="#LB_RecursosHumanos#">
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
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_TiposDeNomina"
		Default="Tipos de N&oacute;mina"
		returnvariable="LB_TiposDeNomina"/>

		<cfset filtro = '' >
		<cfset navegacion = '' >
		<cfset adicionales = '' >
		<cfif isdefined("url.f_codigo") and not isdefined("form.f_codigo")>
			<cfset form.f_codigo = url.f_codigo >
		</cfif>
		<cfif isdefined("url.f_descripcion") and not isdefined("form.f_descripcion")>
			<cfset form.f_descripcion = url.f_descripcion >
		</cfif>
		<cfif isdefined("url.f_tipopago") and not isdefined("form.f_tipopago")>
			<cfset form.f_tipopago = url.f_tipopago >
		</cfif>
		<cfif isdefined("url.pageNum_lista") and not isdefined("form.pageNum_lista")>
			<cfset form.pageNum_lista = url.pageNum_lista >
		</cfif>
		<cfif not isdefined("form.pageNum_lista")>
			<cfif isdefined("form.pageNum") and len(trim(form.pageNum))>
				<cfset form.pageNum_lista = form.pageNum >
			</cfif>
		</cfif>

		<cfif isdefined("form.f_codigo") and len(trim(form.f_codigo)) >
			<cfset filtro = filtro & " and upper(Tcodigo) like '%#ucase(form.f_codigo)#%' " >
			<cfset navegacion = navegacion & "&f_codigo=#form.f_codigo#" >
			<cfset adicionales = adicionales & ", '#form.f_codigo#' as f_codigo" >
		</cfif>
		<cfif isdefined("form.f_descripcion") and len(trim(form.f_descripcion))>
			<cfset filtro = filtro & " and upper(Tdescripcion) like '%#ucase(form.f_descripcion)#%' " >
			<cfset navegacion = navegacion & "&f_descripcion=#form.f_descripcion#" >
			<cfset adicionales = adicionales & ", '#form.f_descripcion#' as f_descripcion" >
		</cfif>
		<cfif isdefined("form.f_tipopago") and len(trim(form.f_tipopago))>
			<cfset filtro = filtro & " and Ttipopago = #form.f_tipopago# " >
			<cfset navegacion = navegacion & "&f_tipopago=#form.f_tipopago#" >
			<cfset adicionales = adicionales & ", '#form.f_tipopago#' as f_tipopago" >
		</cfif>

		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
	            	<cfif isdefined("Url.Tcodigo") and not isdefined("Form.Tcodigo")>
						<cfparam name="Form.Tcodigo" default="#Url.Tcodigo#">
						<cfset form.modo = 'CAMBIO'>
		           	</cfif>

					<cf_web_portlet_start titulo="#LB_TiposDeNomina#">
			  			<cfset regresar = "/cfmx/rh/indexAdm.cfm">
						<cfset navBarItems = ArrayNew(1)>
						<cfset navBarLinks = ArrayNew(1)>
						<cfset navBarStatusText = ArrayNew(1)>
						<cfset navBarItems[1] = "Administraci&oacute;n de N&oacute;mina">
						<cfset navBarLinks[1] = "/cfmx/rh/indexAdm.cfm">
						<cfset navBarStatusText[1] = "/cfmx/rh/indexAdm.cfm">
			  			<cfinclude template="/rh/portlets/pNavegacion.cfm">

			  			<table width="100%" border="0">
	            			<tr>
	              				<td valign="top" width="40%">

									<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="LB_CODIGO"
										Default="C&oacute;digo"
										XmlFile="/rh/generales.xml"
										returnvariable="LB_CODIGO"/>

									<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="LB_DESCRIPCION"
										Default="Descripci&oacute;n"
										XmlFile="/rh/generales.xml"
										returnvariable="LB_DESCRIPCION"/>

									<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="LB_TipoDePago"
										Default="Tipo de Pago"
										returnvariable="LB_TipoDePago"/>

									<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="CMB_Semanal"
										Default="Semanal"
										returnvariable="CMB_Semanal"/>

									<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="CMB_Bisemanal"
										Default="Bisemanal"
										returnvariable="CMB_Bisemanal"/>

									<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="CMB_Quincenal"
										Default="Quincenal"
										returnvariable="CMB_Quincenal"/>

									<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="CMB_Mensual"
										Default="Mensual"
										returnvariable="CMB_Mensual"/>

									<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="BTN_Filtrar"
										Default="Filtrar"
										XmlFile="/rh/generales.xml"
										returnvariable="BTN_Filtrar"/>

									<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="LB_Todos"
										Default="Todos"
										XmlFile="/rh/generales.xml"
										returnvariable="LB_Todos"/>

									<!--- Oparrales cambios para integrar informacion en XML Boletas de Pago --->
									<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="CMB_NominaOrdinaria"
										Default="N&oacute;mina Ordinaria"
										XmlFile="/rh/generales.xml"
										returnvariable="CMB_NominaOrdinaria"/>

									<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="CMB_NominaExtraordinaria"
										Default="N&oacute;mina Extraordinaria"
										XmlFile="/rh/generales.xml"
										returnvariable="CMB_NominaExtraordinaria"/>

									<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="LB_TipoNomina"
										Default="Tipo de N&oacute;mina"
										XmlFile="/rh/generales.xml"
										returnvariable="LB_TipoNomina"/>

									<table>
										<tr><td>
											<cfoutput>
											<form method="post" action="TiposNomina.cfm" style="margin:0;">
												<table class="areaFiltro">
													<tr>
														<td><strong>#LB_CODIGO#</strong></td>
														<td><strong>#LB_DESCRIPCION#</strong></td>
														<td><strong>#LB_TipoDePago#</strong></td>
														<td rowspan="2"><input type="submit" name="btnFiltrar" class="btnFiltrar" value="#btn_filtrar#" /></td>
													</tr>
													<tr>
														<td><input type="text" name="f_codigo" size="7" maxlength="5" value="<cfif isdefined('form.f_codigo') and len(trim(form.f_codigo)) >#trim(form.f_codigo)#</cfif>" /></td>
														<td><input type="text" name="f_descripcion" size="30" maxlength="60" value="<cfif isdefined('form.f_descripcion') and len(trim(form.f_descripcion)) >#trim(form.f_descripcion)#</cfif>" /></td>
														<td>
															<select name="f_tipopago">
																<option value="">-#LB_Todos#-</option>
																<option value="0" <cfif isdefined("form.f_tipopago") and form.f_tipopago eq 0 >selected</cfif> >#CMB_Semanal#</option>
																<option value="1" <cfif isdefined("form.f_tipopago") and form.f_tipopago eq 1 >selected</cfif> >#CMB_Bisemanal#</option>
																<option value="2" <cfif isdefined("form.f_tipopago") and form.f_tipopago eq 2 >selected</cfif> >#CMB_Quincenal#</option>
																<option value="3" <cfif isdefined("form.f_tipopago") and form.f_tipopago eq 3 >selected</cfif> >#CMB_Mensual#</option>
															</select>
														</td>
													</tr>
												</table>
											</form>
											</cfoutput>
										</td></tr>

										<tr>
											<td>
												<cfinvoke
												 component="rh.Componentes.pListas"
												 method="pListaRH"
												 returnvariable="pListaRet">
													<cfinvokeargument name="tabla" value="TiposNomina"/>
													<cfinvokeargument name="columnas" value="Tcodigo, Tdescripcion,
																			case when Ttipopago = 0 then '#CMB_Semanal#'
																				 when Ttipopago = 1 then '#CMB_Bisemanal#'
																				 when Ttipopago = 2 then '#CMB_Quincenal#'
																				 when Ttipopago = 3 then '#CMB_Mensual#' end as Ttipopago #preservesinglequotes(adicionales)#"/>
													<cfinvokeargument name="desplegar" value="Tcodigo, Tdescripcion, Ttipopago"/>
													<cfinvokeargument name="etiquetas" value="#LB_CODIGO#,#LB_DESCRIPCION#,#LB_TipoDePago#"/>
													<cfinvokeargument name="formatos" value="S,S,S"/>
													<cfinvokeargument name="filtro" value="Ecodigo = #Session.Ecodigo# #preservesinglequotes(filtro)#"/>
													<cfinvokeargument name="align" value="left, left, left"/>
													<cfinvokeargument name="ajustar" value="N"/>
													<cfinvokeargument name="checkboxes" value="N"/>
													<cfinvokeargument name="keys" value="Tcodigo"/>
													<cfinvokeargument name="irA" value="TiposNomina.cfm"/>
													<cfinvokeargument name="navegacion" value="#navegacion#"/>
												</cfinvoke>
											</td>
										</tr>
									</table>

				  				</td>
	              				<td valign="top" width="60%">
									<cfinclude template="formTiposNomina.cfm">
								</td>
	            			</tr>
	            			<tr>
	              				<td>&nbsp;</td>
	              				<td>&nbsp;</td>
	            			</tr>
	          			</table>
	                <cf_web_portlet_end>
				</td>
			</tr>
		</table>
<cf_templatefooter>