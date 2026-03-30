<cfsetting requesttimeout="8600">
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke key="LB_RecursosHumanos" default="Recursos Humanos" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<cfinvoke key="LB_RecursosHumanos" default="Recursos Humanos" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<cfinvoke key="LB_Resumen_Pagos" default="Resumen de Pagos" returnvariable="LB_Resumen_Pagos" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="BTN_Consultar" default="Consultar" returnvariable="BTN_Consultar" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<cfinvoke key="BTN_Limpiar" default="Limpiar" returnvariable="BTN_Limpiar" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<cfinvoke Key="MSG_SePpresentaronLosSiguientesErrores" Default="Se presentaron los siguientes errores" returnvariable="MSG_SePpresentaronLosSiguientesErrores" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_ElCampoCalendarioDePagoEsRequerido" Default="El Campo Calendario de Pago es requerido" returnvariable="MSG_ElCampoCalendarioDePagoEsRequerido" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_ElCampoCentroFuncional" Default="El Campo Centro Funcional es requerido" returnvariable="MSG_ElCampoCentroFuncional" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_DebeSeleccionarAlMenosUnEmpleado" Default="Debe seleccionar al menos un empleado" returnvariable="MSG_DebeSeleccionarAlMenosUnEmpleado" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="BTN_Imprimir" default="Imprimir" returnvariable="BTN_Imprimir" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
<cfinvoke key="BTN_Imprimir" default="Imprimir" returnvariable="BTN_Imprimir" component="sif.Componentes.Translate" method="Translate" xmlfile="/rh/generales.xml"/>
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
<cfquery name="rsFormato" datasource="#session.DSN#">
	select coalesce(Pvalor,'10') as formato
	from RHParametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and Pcodigo = 720
</cfquery>
<!--- el query regresa el registro patronal de las oficias --->
<cfquery name="rsRegistro" datasource="#session.dsn#">
	select o.Ocodigo, o.Onumpatronal, o.Odescripcion from oficinas o where o.Ecodigo = #session.Ecodigo# and o.Onumpatronal is not null
</cfquery>
<cfparam name="ordenamiento" default="1">
<cfinclude template="/rh/Utiles/params.cfm">
<cfset Session.Params.ModoDespliegue = 1>
<cfset Session.cache_empresarial = 0>
<cf_web_portlet_start titulo="#LB_Resumen_Pagos#" >
<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td>
			&nbsp;
		</td>
	</tr>
	<tr>
		<td valign="top">
			<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ayuda" Default="Ayuda" 	returnvariable="LB_ayuda"/>
			<cf_web_portlet_start tipo="mini" titulo="#LB_ayuda#" tituloalign="left" wifth="100" height="300">
			<p>
				<cf_translate  key="LB_texto_de_ayuda">
					Este reporte muestra un resumen general de los salarios pagados para una nomina en espec&iacute;fico.
				</cf_translate>
			</p>
			<cf_web_portlet_end>
		</td>
		<td>
			&nbsp;
		</td>
		<td valign="top" width="50%">
			<!---<cf_web_portlet_start titulo="#LB_Resumen_Pagos#" >--->
			<cfinclude template="/rh/portlets/pNavegacionPago.cfm">
			<form style="margin:0 " name="filtro" method="post" action="ResumenPagosNomina-form.cfm" onsubmit="return validar();" >
				<table width="100%" cellpadding="0" cellspacing="0" border="0">
					<tr>
						<td colspan="2">
							&nbsp;
						</td>
					</tr>
					<tr>
						<td align="right" width="25%" nowrap valign="top">
							<strong>
								<cf_translate  key="LB_CalendarioDePago">
									Calendario de Pago
								</cf_translate>
								:&nbsp;
							</strong>
						</td>
						<td>
							<cfif isdefined("form.CPid") and len(trim(form.CPid))>
								<cfquery name="rsCalendario" datasource="#session.DSN#">
												select CPid, CPcodigo,CPdescripcion, b.Tcodigo, b.Tdescripcion
												from CalendarioPagos a
													inner join TiposNomina b
														on a.Tcodigo = b.Tcodigo
												where a.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">
													and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
											</cfquery>
								<cf_rhcalendariopagos form="filtro" MostrarTodos="true" tcodigo="true" query="#rsCalendario#" orientacion="2">
							<cfelse>
								<cf_rhcalendariopagos form="filtro" MostrarTodos="true" tcodigo="true" orientacion="2">
							</cfif>
						</td>
					</tr>
					<tr>
						<td colspan="2">
							&nbsp;
						</td>
					</tr>
					<tr>
						<td align="right">
							<strong>
								<cf_translate key="LB_Formato">
									Formato
								</cf_translate>
								:&nbsp;
							</strong>
						</td>
						<td>
							<cfif isdefined("rsFormato") and rsFormato.formato EQ '20'>
								<!---Formato 1/3 CEFA---->
								<select name="formato" tabindex="1">
									<option value="pdf"
									<cfif isdefined('formato') and formato EQ 'pdf'>
										selected
									</cfif>
									>Adobe PDF</option>
									<!---<option value="FlashPaper" <cfif isdefined('formato') and formato EQ 'FlashPaper'>selected</cfif>>FlashPaper</option>---->
								</select>
							<cfelseif isdefined("rsFormato") and rsFormato.formato EQ '30'>
								<!---Formato 1/2 Coopelesca--->
								<input type="text" name="formato" value="Html" class="cajasinborde"/>
							<cfelse>
								<select name="formato" tabindex="1">
									<option value="pdf"
									<cfif isdefined('formato') and formato EQ 'pdf'>
										selected
									</cfif>
									>Adobe PDF</option> <option value="html"
									<cfif isdefined('formato') and formato EQ 'html'>
										selected
									</cfif>
									>HTML</option>
								</select>
							</cfif>
						</td>
					</tr>
					<tr>
						<td colspan="2">
							&nbsp;
						</td>
					</tr>
					<tr>

						<td nowrap align="right">
							<strong>
								Oficina:&nbsp;
							</strong>
						</td>
						<td>
							<cfoutput>
								<select name="codOficina" onchange="Archivo();">
									<option value="0" >
										-- Seleccione una opci&oacute;n --
									</option>
									<cfloop query="rsRegistro">
										<option value="#Ocodigo#" >
											<cf_translate key="CMB_RegistrPatronalOficina">
												#Odescripcion#
											</cf_translate>
										</option>
									</cfloop>
								</select>
							</cfoutput>
						</td>
					</tr>
					<tr>
						<td colspan="2">
							&nbsp;
						</td>
					</tr>
					<tr>
						<td colspan="2" align="center">
							<cfoutput>
								<input type="submit" name="Consultar" class="BtnFiltrar" value="#BTN_Consultar#">
								<input type="reset"  name="Limpiar"   class="BtnLimpiar" value="#BTN_Limpiar#">
							</cfoutput>
						</td>
					</tr>
					<tr>
						<td colspan="2">
							&nbsp;
						</td>
					</tr>
				</table>
			</form>
			<script type="text/javascript" language="javascript1.2">
							function validar(){

								<cfoutput>
								var error = false;
								var mensaje = '#MSG_SePpresentaronLosSiguientesErrores#:\n';

								//Calendario de pagos obligatorio
								if ( document.filtro.CPid.value == ''){
									error = true;
									mensaje  = mensaje + '#MSG_ElCampoCalendarioDePagoEsRequerido#\n';
								}
								if (error){
									alert(mensaje);
									return false;
								}
								</cfoutput>
								return true;
							}
						</script>
			<!---<cf_web_portlet_end>--->
		</td>
	</tr>
</table>
<cf_web_portlet_end>
<cf_templatefooter>
