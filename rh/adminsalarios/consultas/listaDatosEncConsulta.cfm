<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
<cf_templatecss>
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_reloadPage(init) {  //reloads the window if Nav4 resized
  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
    document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
}
MM_reloadPage(true);
//-->

function Regresa() {
		location.href = '/cfmx/home/menu/modulo.cfm?s=RH&m=ADMINSAL';
	}
</script>
<cfinclude template="/rh/Utiles/params.cfm">
<cfset Session.Params.ModoDespliegue = 1>
<cfset Session.cache_empresarial = 0>
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td valign="top">
				<cf_web_portlet_start titulo="Consulta de Encuestas Salariales">
					<cfset filtro = "">
			  		<cfset navegacion = "&btnFiltrar=Filtrar" >
					<script language="JavaScript1.2" type="text/javascript">
						function filtrar( form ){
							form.action = '';
							form.submit();
						}
						
						function limpiar(){
							document.filtro.fEdescripcion.value = '';
							document.filtro.fEfecha.value		 = '';
							<cfset navegacion = '' >
						}
					</script>
					<!--- Guardan los valores que se filtraron con el fin de mostrarlos en los filtros --->
					<cfset fEdescripcion = "">
					<cfset fEfecha = "">			
								
					<cfif isdefined("url.btnFiltrar") and not isdefined("form.btnFiltrar") >
						<cfset form.btnFiltrar = url.btnFiltrar >
					</cfif>
					<cfif isdefined("url.fEdescripcion") and not isdefined("form.fEdescripcion") >
						<cfset form.fEdescripcion = url.fEdescripcion >
					</cfif>
					<cfif isdefined("form.fEdescripcion") AND Len(Trim(form.fEdescripcion)) GT 0 and isdefined("form.btnFiltrar")>
						<cfset filtro = filtro & " upper(Edescripcion) like upper('%" & Trim(form.fEdescripcion) & "%')" >
						<cfset fEdescripcion = Trim(form.fEdescripcion)>
						<cfset navegacion = navegacion & "&fEdescripcion=#form.fEdescripcion#" >
					</cfif>
			
					<cfif isdefined("url.fEfecha") and not isdefined("form.fEfecha") ><cfset form.fEfecha = url.fEfecha ></cfif>
					<cfif isdefined("form.fEfecha") AND Len(Trim(form.fEfecha)) GT 0 and isdefined("form.btnFiltrar") >
						<cfif isdefined("form.fEdescripcion") AND Len(Trim(form.fEdescripcion)) GT 0>
							<cfset filtro = filtro & " and Efecha = "& #LSPARSEDATETIME(LSDateFormat(Form.fEfecha,"DD/MM/YYY"))# &"" >
						<cfelse>
							<cfset filtro = filtro & " Efecha = "& #LSPARSEDATETIME(LSDateFormat(Form.fEfecha,"DD/MM/YYY"))# &"" >
						</cfif>
						<cfset fEfecha = Trim(form.fEfecha)>
						<cfset navegacion = navegacion & "&fECfecha=#form.fEfecha#" >
					</cfif>
					<table width="100%" cellpadding="0" cellspacing="0">
						<tr> 
							<cfset regresar = "/cfmx/rh/indexAdm.cfm">
							<cfset navBarItems = ArrayNew(1)>
							<cfset navBarLinks = ArrayNew(1)>
							<cfset navBarStatusText = ArrayNew(1)>			 
							<cfset navBarItems[1] = "Administraci&oacute;n de Salarios">
							<cfset navBarLinks[1] = "/cfmx/rh/indexAdm.cfm">
							<cfset navBarStatusText[1] = "/cfmx/rh/indexAdm.cfm">
							<td colspan="5" ><cfinclude template="/rh/portlets/pNavegacion.cfm"></td>
						</tr>
						<tr>
							<td colspan="5">
								<form style="margin: 0; " name="filtro" method="post" action="listaEncConsulta.cfm">
									<table width="100%" cellpadding="0" cellspacing="0" class="areaFiltro">
										<cfoutput> 
											<tr> 
												<td align="right" width="11%">Descripci&oacute;n:&nbsp;</td>
												<td width="24%">
													<input type="text" name="fEdescripcion" value="#fEdescripcion#" 
														   size="35" maxlength="35" onFocus="this.select();">
												</td>
												<td width="10%" align="right">Fecha:&nbsp;</td>
												<td width="14%"><cf_sifcalendario form="filtro" name="fEfecha" value="#fEfecha#"></td>
												<td width="41%">
													<div align="right"> 
														<input type="submit" name="btnFiltrar" value="Filtrar"  
															   onClick="javascript:filtrar(this.form)">
														<input type="button" name="btnLimpiar" value="Limpiar"
															   onClick="javascript:limpiar()">
													</div>
												</td>
											</tr>
										</cfoutput> 
									</table>
								</form>
							</td>
						</tr>
						<tr>
							<td>
								<cfinvoke 
								 component="rh.Componentes.pListas"
								 method="pListaRH"
								 returnvariable="pListaRet">
									<cfinvokeargument name="tabla" value="Encuesta"/>
									<cfinvokeargument name="columnas" value="Eid, Edescripcion, Efecha, Efechaanterior"/>
									<cfinvokeargument name="desplegar" value="Edescripcion, Efecha, Efechaanterior"/>
									<cfinvokeargument name="etiquetas" value="Descripci&oacute;n, Fecha, Fecha de Encuesta anterior"/>
									<cfinvokeargument name="formatos" value="V,D,D"/>
									<cfinvokeargument name="filtro" value="#filtro#"/>
									<cfinvokeargument name="align" value="left,left,left"/>
									<cfinvokeargument name="ajustar" value="N"/>
									<cfinvokeargument name="checkboxes" value="N"/>
									<cfinvokeargument name="irA" value="DatosEncConsulta.cfm"/>
									<cfinvokeargument name="keys" value="Eid"/>
									<cfinvokeargument name="showEmptyListMsg" value="true"/>
									<cfinvokeargument name="conexion" value="sifpublica"/>
									<cfinvokeargument name="navegacion" value="#navegacion#"/>
								</cfinvoke>
							</td>
						</tr>
						<tr>
							<td align="center">
								<input type="button"  name="Regresar" value="Regresar" onClick="javascript: Regresa();" tabindex="1">
							</td>
						</tr>
						<tr><td>&nbsp;</td></tr>
					</table>
				<cf_web_portlet_end> 
			</td>	
		</tr>
	</table>	
<cf_templatefooter>	