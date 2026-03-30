<cfinvoke component="sif.Componentes.TranslateDB"
	method="Translate"
	VSvalor="#session.monitoreo.SScodigo#"
	Default="Recursos Humanos"
	VSgrupo="103"
	returnvariable="nombre_sistema"/>
<cfinvoke component="sif.Componentes.TranslateDB"
	method="Translate"
	VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#"
	Default="Capacitaci&oacute;n y Desarrollo"
	VSgrupo="103"
	returnvariable="nombre_modulo"/>
<cfinvoke component="sif.Componentes.TranslateDB"
	method="Translate"
	VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
	Default="Horas de Capacitaci&oacute;n por Centro Funcional"
	VSgrupo="103"
	returnvariable="nombre_proceso"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Consultar"
	Default="Consultar"	
	xmlfile="/rh/generales.xml"
	returnvariable="BTN_Consultar"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>

<cf_templateheader title="#LB_RecursosHumanos#">
		<cf_templatecss>>

<cf_web_portlet_start titulo="#nombre_proceso#">
	<cfinclude template="/home/menu/pNavegacion.cfm">
	<!---<cf_rhimprime datos="/rh/capacitacion/consultas/BaseEntrenamiento/baseEntrenam-form.cfm" paramsuri="?DEid=#DEid#">--->
	<form name="form1" method="post" action="horascap.cfm">
		<table width="100%" align="center" cellpadding="4">
			<tr>
				<td valign="top">
					<cf_web_portlet_start border="true" titulo="#nombre_proceso#" skin="info1">
						<table width="100%" align="center">
							<tr><td><p>
							<cf_translate  key="AYUDA_Reporte_Horas_Capacitacion">
								Este reporte detalla la cantidad de horas invertidas por centro funcional en capacitaciones a sus empleados.
								Adem&aacute;s se puede llegar a consultar a un nivel detallado, en cuales empleados y cursos se invirtieron las horas de capacitaci&oacute;n.<br>
								El reporte puede generarse de las siguientes formas (excluyentes):<br>
									<li><strong>Periodo/Mes:</strong>&nbsp;realiza la consulta para un per&iacute;odo(a&ntilde;o) y mes espec&iacute;ficos</li>
									<li><strong>Rango de Fechas:</strong>&nbsp;realiza la consulta para un rango de fechas definido por el usuario</li>
							</cf_translate>
							</p></td></tr>
						</table>
					<cf_web_portlet_end>
				</td>
				<td valign="top">
					<table width="50%" align="center" cellpadding="2" cellspacing="0">
						<tr>
							<td nowrap="nowrap" align="right"><strong><cf_translate key="LB_Centro_Funcional" xmlfile="/rh/generales.xml">Centro Funcional</cf_translate>:</strong></td>
							<td><cf_rhcfuncional tabindex="1"></td>
						</tr>
						<tr>
							<td align="right" ><input type="checkbox" id="dependencias" name="dependencias" tabindex="1"></td>
							<td nowrap="nowrap"><label for="dependencias"><cf_translate key="LB_Incluir_Dependencias" xmlfile="/rh/generales.xml">Incluir dependencias</cf_translate></label></td>
						</tr>
			
						<tr>
							<td colspan="2">
								<table width="100%" bgcolor="#f5f5f5">
									<tr>
										<td valign="middle" width="1%"><input type="radio" name="usar" value="PM" checked></td>
										<td nowrap="nowrap" valign="middle"><strong><cf_translate key="LB_Periodo" xmlfile="/rh/generales.xml">Per&iacute;odo</cf_translate>/<cf_translate key="LB_Mes" xmlfile="/rh/generales.xml">Mes</cf_translate></strong></td>
									</tr>
								</table>
							</td>
						</tr>
			
						<tr>
							<td nowrap="nowrap" align="right"><strong><cf_translate key="LB_Periodo" xmlfile="/rh/generales.xml">Per&iacute;odo</cf_translate>:</strong></td>
							<td>
								<table width="1%" border="0" cellpadding="2" cellspacing="0">
									<tr>
										<td>
											<cfoutput>
											<select id="periodo" name="periodo" tabindex="1">
												<cfloop from="#year(now())-3#" to="#year(now())+1#" index="i" >
													<option value="#i#" <cfif i eq year(now())>selected</cfif> >#i#</option>
												</cfloop>
											</select>
											</cfoutput>
										</td>
			
										<td nowrap="nowrap" align="right"><strong><cf_translate key="LB_Mes" xmlfile="/rh/generales.xml">Mes</cf_translate>:</strong></td>
										<td><cf_meses name="mes" tabindex="1"></td>
									</tr>	
								</table>
							</td>
						</tr>
						
						<tr>
							<td colspan="2">
								<table width="100%" bgcolor="#f5f5f5">
									<tr>
										<td valign="middle" width="1%"><input type="radio" name="usar" value="RF"></td>
										<td nowrap="nowrap" valign="middle"><strong><cf_translate key="LB_Rango_de_Fechas">Rango de Fechas</cf_translate></strong></td>
									</tr>
								</table>
							</td>
						</tr>
			
						<tr>
							<td nowrap="nowrap" align="right"><strong><cf_translate key="LB_Fecha_Inicial" xmlfile="/rh/generales.xml">Fecha Inicial</cf_translate>:</strong></td>
							<td>
								<table width="1%" border="0" cellpadding="2" cellspacing="0">
									<cfset fecha_inicio = lsdateformat(dateadd('d',-30, now()), 'dd/mm/yyyy') >
									<cfset fecha_final = lsdateformat(now(), 'dd/mm/yyyy') >
									<tr>
										<td><cf_sifcalendario name="inicio" tabindex="1" value="#fecha_inicio#"></td>
										<td nowrap="nowrap" align="right"><strong><cf_translate key="LB_Fecha_Final" xmlfile="/rh/generales.xml">Fecha Final</cf_translate>:</strong></td>
										<td><cf_sifcalendario name="final" tabindex="1" value="#fecha_final#"></td>
									</tr>	
								</table>
							</td>
						</tr>
						<tr><td colspan="2" align="center"><input class="btnNormal" type="submit" name="Consultar" value="<cfoutput>#BTN_Consultar#</cfoutput>" ></td></tr>
					</table>
				</td>
			</tr>
		</table>
	</form>
<cf_web_portlet_end>
<cf_templatefooter>