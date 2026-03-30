
<cfinvoke component="sif.Componentes.TranslateDB"
method="Translate"
VSvalor="#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#"
Default="Consulta de Cesant&iacute;a Acumulada"
VSgrupo="103"
returnvariable="LB_nav__SPdescripcion"/>
			
<cf_templateheader title="#LB_nav__SPdescripcion#">
	<cf_web_portlet_start border="true" titulo="#LB_nav__SPdescripcion#" skin="#Session.Preferences.Skin#">
		<div align="center">
			<cfoutput>
			<form name="form1" method="get" action="cesantia.cfm" style="margin:0;">
				<table border="0" width="550" cellspacing="0" cellpadding="3">
					
					<tr>
						<td nowrap="nowrap"><strong><cf_translate key="LB_CentroFuncional" xmlfile="/rh/generales.xml">Centro Funcional</cf_translate>:</strong></td>
						<td><cf_rhcfuncional id="CFid"></td>
					</tr>

				<cfinvoke component="sif.Componentes.Translate" 
					method="Translate" 
					Key="LB_Empleado" 
					Default="Empleado"
					xml="/rh/generales.xml" 
					returnvariable="LB_Empleado"/>
					<tr>
						<td nowrap="nowrap"><strong>#LB_Empleado#:</strong></td>
						<td><cf_rhempleados></td>
					</tr>
					
					<cfquery datasource="#session.DSN#" name="periodo">
						select distinct RHCSperiodo, RHCSmes 
						from RHCesantiaSaldos cs
						where exists ( select 1
									  from DatosEmpleado de
									  where de.DEid=cs.DEid
									  and de.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> )
						and cs.RHCScerrado = 1
						order by RHCSperiodo desc, RHCSmes desc
					</cfquery>

				<cfinvoke component="sif.Componentes.Translate" 
					method="Translate" 
					Key="LB_Periodo" 
					Default="Per&iacute;odo"
					xml="/rh/generales.xml" 
					returnvariable="LB_Periodo"/>
					<cfquery name="rs_periodos" datasource="#session.DSN#">
						select distinct RHCSperiodo as periodo
						from RHCesantiaSaldos a, DatosEmpleado b
						where b.DEid=a.DEid
						and b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						order by RHCSperiodo
					</cfquery>
					<tr>
						<td nowrap="nowrap"><strong>#LB_Periodo#:</strong></td>
						<td>
							<select name="periodo" >
								<cfloop query="rs_periodos">
									<option value="#rs_periodos.periodo#" >#rs_periodos.periodo#</option>
								</cfloop>
							</select>
						</td>
					</tr>

				<cfinvoke component="sif.Componentes.Translate" 
					method="Translate" 
					Key="LB_Mes" 
					Default="Mes"
					xml="/rh/generales.xml" 
					returnvariable="LB_Mes"/>
					<tr>
						<td nowrap="nowrap"><strong>#LB_Mes#:</strong></td>
						<td>
							<select name="mes" >
								<option value="1">Enero</option>
								<option value="2">Febrero</option>
								<option value="3">Marzo</option>
								<option value="4">Abril</option>
								<option value="5">Mayo</option>
								<option value="6">Junio</option>
								<option value="7">Julio</option>
								<option value="8">Agosto</option>
								<option value="9">Setiembre</option>
								<option value="10">Octubre</option>
								<option value="11">Noviembre</option>
								<option value="12">Diciembre</option>
							</select>
						</td>
					</tr>

					<!---
					<tr>
						<td width="1%" valign="middle" align="right"><input type="checkbox" checked="checked" id="mostrar_foto_resp" name="mostrar_foto_resp" value="true" /></td>
						<td><label for="mostrar_foto_resp"><cf_translate key="LB_Mostrar_foto_del_responsable_del_Centro_Funcional">Mostrar foto del responsable del Centro Funcional</cf_translate></label></td>
					</tr>
					--->
	
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Filtrar"
						Default="Filtrar"	
						xmlfile="/rh/generales.xml"
						returnvariable="vFiltrar"/>
					<tr><td colspan="2" align="center"><input type="submit" class="btnFiltrar" id="Filtrar" name="Filtrar" value="#vFiltrar#" /></td></tr>

				</table>
					<!---
					<input type="hidden" name="periodo" value="2007">
					<input type="hidden" name="mes" value="9">
					--->
			</form>
			</cfoutput>
		</div>
	<cf_web_portlet_end>
<cf_templatefooter>


