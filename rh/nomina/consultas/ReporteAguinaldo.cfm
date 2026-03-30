<!---modifica para subir nuevamente y agregar en parche--->
<cfquery name="rsVerificaConfigRep" datasource="#session.DSN#">
	select rptid
	from RHErpt 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	  and rptcodigo = 'RHAGUIN01'
</cfquery>

<cfquery name="rsTiposNomina" datasource="#Session.DSN#">
	select rtrim(a.Tcodigo) as Tcodigo, a.Tdescripcion
	from TiposNomina a
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	order by a.Tdescripcion
</cfquery>
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ReporteDeAguinaldo"
	Default="Reporte de Aguinaldo"
	returnvariable="LB_ReporteDeAguinaldo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_FechaDesde"
	Default="Fecha Desde"
	returnvariable="LB_FechaDesde"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_FechaHasta"
	Default="Fecha Hasta"
	returnvariable="LB_FechaHasta"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_CortePor"
	Default="Corte por"
	returnvariable="LB_CortePor"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Empleado"
	Default="Empleado"
	returnvariable="LB_Empleado"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_CentroFuncionalYEmpleado"
	Default="Centro Funcional y Empleado"
	returnvariable="LB_CentroFuncionalYEmpleado"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_CentroFuncional"
	Default="Centro Funcional"
	returnvariable="LB_CentroFuncional"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_EmpleadosVigentes"
	Default="Empleados Vigentes"
	returnvariable="LB_EmpleadosVigentes"/>	
	
	
<!--- FIN VARIABLES DE TRADUCCION --->
<cf_templateheader title="#LB_ReporteDeAguinaldo#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>
	<cf_templatecss>
	<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
	<cf_web_portlet_start titulo="#LB_ReporteDeAguinaldo#">
		<cfif rsVerificaConfigRep.RecordCount GT 0>
			<form name="form1" method="get" action="ReporteAguinaldo_Res.cfm">
					<input name="rptid" type="hidden" value="<cfoutput>#rsVerificaConfigRep.rptid#</cfoutput>">
				<table width="85%" cellpadding="1" cellspacing="0" align="center">
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr>
					    <td align="right" nowrap> <strong><cf_translate  key="LB_TipoDeNomina">Tipo de N&oacute;mina</cf_translate>&nbsp;:&nbsp;</strong></td>
					    <td>
						    <cfoutput>
							<cf_rhtiponominaCombo index="0">
							</cfoutput>
							<!---<cfoutput>
							<select tabindex="1" name="Tcodigo">
					            <cfloop query="rsTiposNomina">
					              <option value="#rsTiposNomina.Tcodigo#">#rsTiposNomina.Tdescripcion#</option>
					            </cfloop>
					          </select>
					          </cfoutput>--->
						</td>
					</tr>
					<tr>
						<td align="right"><cfoutput><strong>#LB_FechaDesde#&nbsp;:&nbsp;</strong></cfoutput></td>
						<td><cf_sifcalendario name="Fdesde" tabindex="1"></td>
					</tr>
					<tr>
						<td align="right"><cfoutput><strong>#LB_FechaHasta#&nbsp;:&nbsp;</strong></cfoutput></td>&nbsp; 
						<td><cf_sifcalendario name="Fhasta" tabindex="1"></td>
					</tr>
					<tr>
						<td align="right"><cfoutput><strong>#LB_CortePor#&nbsp;:&nbsp;</strong></cfoutput></td>
						<td>
							<select name="Corte" tabindex="1">
								<option value="0"><cfoutput>#LB_Empleado#</cfoutput></option>
								<option value="1"><cfoutput>#LB_CentroFuncionalYEmpleado#</cfoutput></option>
								<option value="2"><cfoutput>#LB_CentroFuncional#</cfoutput></option>
							</select>
						</td>
					</tr>
					<tr>
						<td align="right">
							<input type="checkbox" name="vigente" tabindex="1" checked>
						</td>
						<td><cfoutput><strong>#LB_EmpleadosVigentes#</strong></cfoutput></td>
					</tr>
					<tr><td colspan="2"><cf_botones values="Consultar,Limpiar" tabindex="1"></td></tr>
				</table>
			</form>
		<cfelse>
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_NoSeHaConfiguradoElReporteDeAguinaldo"
				Default="No se ha configurado el Reporte de Aguinaldo"
				returnvariable="LB_NoSeHaConfiguradoElReporteDeAg"/>
			<table width="100%" cellpadding="1" cellspacing="0" align="center">
				<tr><td>&nbsp;</td></tr>
				<tr><td align="center"><cfoutput>#LB_NoSeHaConfiguradoElReporteDeAg#</cfoutput></td></tr>
				<tr><td>&nbsp;</td></tr>
			</table>
		</cfif>
	<cf_web_portlet_end>
<cf_templatefooter>
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_TipoDeNomina"
	Default="Tipo de N&oacute;mina"
	returnvariable="MSG_TipoDeNomina"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_FechaDesde"
	Default="Fecha Desde"
	returnvariable="MSG_FechaDesde"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_FechaHasta"
	Default="Fecha Hasta"
	returnvariable="MSG_FechaHasta"/>
<!--- FIN VARIABLES DE TRADUCCION --->

<cfif isdefined("rsVerificaConfigRep") and rsVerificaConfigRep.RecordCount GT 0><!---correccion para el BN, cuando el reporte aun no se ha configurado presentaba error--->
<cf_qforms form="form1">
	<cf_qformsRequiredField args="Tcodigo,#MSG_TipoDeNomina#">
	<cf_qformsRequiredField args="Fdesde,#MSG_FechaDesde#">
	<cf_qformsRequiredField args="Fhasta,#MSG_FechaHasta#">
</cf_qforms>
</cfif>
