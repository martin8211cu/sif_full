<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_RecursosHumanos"
Default="Recursos Humanos"
XmlFile="/rh/generales.xml"
returnvariable="LB_RecursosHumanos"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_ConsultaDeSaldoDeVacaciones"
Default="Consulta de Saldo de Vacaciones"
returnvariable="LB_ConsultaDeSaldoDeVacaciones"/> 

	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_RecursosHumanos"
		Default="Recursos Humanos"
		XmlFile="/rh/generales.xml"
		returnvariable="LB_RecursosHumanos"/>
	<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
		<cf_templatecss>
		<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
		<cfinclude template="/rh/Utiles/params.cfm">
		<cfset Session.Params.ModoDespliegue = 1>
		<cfset Session.cache_empresarial = 0>			
		<cf_web_portlet_start titulo="#LB_ConsultaDeSaldoDeVacaciones#">
			<cfinclude template="/rh/portlets/pNavegacion.cfm">
			<form name="form1" method="post" action="VacacionesRep.cfm">
				<table width="100%"  border="0" cellspacing="0" cellpadding="2" align="center">
					<tr>
						<td width="45%"  valign="top"rowspan="6" align="center">
							<cf_web_portlet_start border="true" titulo="#LB_ConsultaDeSaldoDeVacaciones#" skin="info1">
								<div align="justify">
								<p> 
								<cf_translate  key="LB_LeyendaQueExplicaElReporte">
								En este reporte se muestran el detalle del saldo de las vacaciones de los empleados hasta la fecha de corte seleccionada.<br>
								El reporte se va a mostrar agrupado por centro funcional y ordenado por centro funcional y nombre del empleado.
								</cf_translate>
								</p>
								</div>
							<cf_web_portlet_end> 
						</td>
						<td colspan="2" align="right" class="fileLabel">&nbsp;</td>
					</tr>
					<tr>
						<td class="fileLabel" align="right">
							<strong><cf_translate  key="LB_FechaCorte">Fecha Corte</cf_translate>:</strong>
						</td>
						<td>
							<cf_sifcalendario form="form1" tabindex="1" name="Fcorte" value="#LSDateFormat(Now(), 'dd/mm/yyyy')#">
						</td>
					</tr>
					<tr>
						<td class="fileLabel" align="right">
							<strong><cf_translate  key="LB_CentroFuncional">Centro Funcional</cf_translate>:</strong>
						</td>
						<td nowrap>
							<cf_rhcfuncional tabindex="2">
						</td>
						</tr>
					<tr>
						<td align="right">
							<input tabindex="3" type="checkbox" name="IncluirDependencias"/>
						</td>
						<td>
							<strong>
							<cf_translate  key="LB_TipoDeCumplimiento">Incluir Dependencias</cf_translate>
							</strong>
						</td>
					</tr>
					<tr>
						<td align="right">
							<input tabindex="4" type="checkbox" name="CorteCF"/>
						</td>
						<td>
							<strong>
							<cf_translate  key="LB_Mes">Corte por Centro Funcional</cf_translate>
							</strong>
						</td>
					</tr>	
					<tr>
						<td class="fileLabel" align="right">
							<strong><cf_translate  key="LB_Formato">Formato</cf_translate>:</strong>
						</td>
						<td>
							<select name="formato" tabindex="5">
							<option value="HTML" selected="selected"><cf_translate  key="CMB_HTML">HTML</cf_translate></option>
							<option value="Excel"><cf_translate  key="CMB_Excel">Excel tabulado </cf_translate></option>
							</select>
						</td>
					</tr>
					<tr>
						<td colspan="3" align="center">&nbsp;</td>
					</tr>					
					<tr>
						<td colspan="3" align="center" class="fileLabel">
							<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="BTN_Generar"
							Default="Generar"
							XmlFile="/rh/generales.xml"
							returnvariable="BTN_Generar"/>
							<input name="btnConsultar" type="submit" id="btnConsultar" value="<cfoutput>#BTN_Generar#</cfoutput>">
						</td>
					</tr>
					<tr>
						<td colspan="3" align="center" class="fileLabel">&nbsp;</td>
					</tr>
				</table>
			</form>
		<cf_web_portlet_end>
	<cf_templatefooter>	
