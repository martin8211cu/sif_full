
<cf_templateheader title="Comportamiento de Acci&oacute;n Masiva">

<cfinclude template="/rh/portlets/pNavegacion.cfm">

<cf_web_portlet_start titulo="Asociar Importadores">
	
	<cfif isdefined("form.BTNAsociar")>
		
		<cfquery name="rsScripts" datasource="asp">
			select Count(1) as exist from CDPImportador 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and CDPItablaCarga = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.tabla#">
			and CDPIEIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EIid#">
		</cfquery>
	
		<cfif rsScripts.exist EQ 0>
			<cfquery  datasource="asp">
				Insert into CDPImportador (Ecodigo,CDPItablaCarga,CDPIEIid,BMUsucodigo,BMFecha)
				values(
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.tabla#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EIid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				)
			</cfquery>
		</cfif>
		
		<cflocation url="asociaImportador.cfm">
	</cfif>
	
	<cfif isdefined("form.BTNBorrar") and form.BTNBorrar EQ 1>
		<cfquery name="rsScripts" datasource="asp">
			Delete CDPImportador 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and CDPItablaCarga = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.tabla#">
			and CDPIEIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EIid#">
		</cfquery>
		
		<cflocation url="asociaImportador.cfm">
	</cfif>

		
	<cfquery name="rsScripts" datasource="sifcontrol">
		select EIid, EIcodigo, EImodulo, EIdescripcion
		from EImportador
		where not EIcodigo like '%.[0-9][0-9][0-9]'
		order by upper(EIcodigo)
	</cfquery>
	
	<cfquery name="rsImportadorAsociado" datasource="asp">
		select a.CDPIid,a.CDPItablaCarga,a.CDPIEIid,
						case when a.CDPItablaCarga = 'CDRHHOficinas' then 'Oficinas'
						when a.CDPItablaCarga = 'CDRHHDepartamentos' then 'Departamentos'
						when a.CDPItablaCarga = 'CDRHHCFuncional' then 'Centro Funcional'
						when a.CDPItablaCarga = 'CDRHHTiposPuesto' then 'Tipos de Puestos'
						when a.CDPItablaCarga = 'CDRHHPuestos' then 'Puestos'
						when a.CDPItablaCarga = 'CDRHHPlazas' then 'Plazas'
						when a.CDPItablaCarga = 'CDRHDatosEmpleado' then 'Datos Empleado'
						when a.CDPItablaCarga = 'CDRHHFEmpleado' then 'Familiares Empleado'
						when a.CDPItablaCarga = 'CDRHHAcciones' then 'Acciones de Personal'
						when a.CDPItablaCarga = 'CDRHHRCalculoNomina' then 'Calculo Nomina'
						when a.CDPItablaCarga = 'CDRHHSalarioEmpleado' then 'Salario Empleado'
						when a.CDPItablaCarga = 'CDRHHPagosEmpleado' then 'Pagos Empleado'
						when a.CDPItablaCarga = 'CDRHHDeduccionesEmpleado' then 'Desducciones Empleado'
						when a.CDPItablaCarga = 'CDRHHDeduccionesCalculo' then 'Desducciones Calculo'
						when a.CDPItablaCarga = 'CDRHHIncidenciasCalculo' then 'Incidencias Calculo'
						when a.CDPItablaCarga = 'CDRHHCargasCalculo' then 'Cargas Calculo' 
						else 'indefinido' end as TablaDescripcion
		from CDPImportador a
		where a.Ecodigo = #session.Ecodigo#
	</cfquery>
	
	<cfset listaTablas = ''>
	<cfif rsImportadorAsociado.RecordCount GT 0>
		<cfset listaTablas = valueList(rsImportadorAsociado.CDPItablaCarga,',')>
	</cfif>
	
	<cfoutput>	
		<form name="form1" action="asociaImportador.cfm" enctype="multipart/form-data" method="post">
			<table cellpadding="2" cellspacing="2" align="center" border="0">
				<tr><td>Datos a Importar</td><td>Importador</td></tr>
				<tr><td>
					<select name="tabla" id="tabla">
						<cfif ListFindNoCase(listaTablas,'CDRHHOficinas',',') EQ 0>
						<option value="CDRHHOficinas">Oficinas</option></cfif> 
						<cfif ListFindNoCase(listaTablas,'CDRHHDepartamentos',',') EQ 0>
						<option value="CDRHHDepartamentos">Departamentos</option></cfif> 
						<cfif ListFindNoCase(listaTablas,'CDRHHCFuncional',',') EQ 0>
						<option value="CDRHHCFuncional">Centro Funcional</option></cfif> 
						<cfif ListFindNoCase(listaTablas,'CDRHHTiposPuesto',',') EQ 0>
						<option value="CDRHHTiposPuesto">Tipos de Puestos</option></cfif> 
						<cfif ListFindNoCase(listaTablas,'CDRHHPuestos',',') EQ 0>
						<option value="CDRHHPuestos">Puestos</option></cfif> 
						<cfif ListFindNoCase(listaTablas,'CDRHHPlazas',',') EQ 0>
						<option value="CDRHHPlazas">Plazas</option></cfif> 
						<cfif ListFindNoCase(listaTablas,'CDRHDatosEmpleado',',') EQ 0>
						<option value="CDRHDatosEmpleado">Datos Empleado</option></cfif> 
						<cfif ListFindNoCase(listaTablas,'CDRHHFEmpleado',',') EQ 0>
						<option value="CDRHHFEmpleado">Familiares Empleado</option></cfif> 
						<cfif ListFindNoCase(listaTablas,'CDRHHAcciones',',') EQ 0>
						<option value="CDRHHAcciones">Acciones de Personal</option></cfif> 
						<cfif ListFindNoCase(listaTablas,'CDRHHRCalculoNomina',',') EQ 0>
						<option value="CDRHHRCalculoNomina">Calculo Nomina</option></cfif> 
						<cfif ListFindNoCase(listaTablas,'CDRHHSalarioEmpleado',',') EQ 0>
						<option value="CDRHHSalarioEmpleado">Salario Empleado</option></cfif> 
						<cfif ListFindNoCase(listaTablas,'CDRHHPagosEmpleado',',') EQ 0>
						<option value="CDRHHPagosEmpleado">Pagos Empleado</option></cfif> 
						<cfif ListFindNoCase(listaTablas,'CDRHHDeduccionesEmpleado',',') EQ 0>
						<option value="CDRHHDeduccionesEmpleado">Desducciones Empleado</option></cfif> 
						<cfif ListFindNoCase(listaTablas,'CDRHHDeduccionesCalculo',',') EQ 0>
						<option value="CDRHHDeduccionesCalculo">Desducciones Calculo</option></cfif> 
						<cfif ListFindNoCase(listaTablas,'CDRHHIncidenciasCalculo',',') EQ 0>
						<option value="CDRHHIncidenciasCalculo">Incidencias Calculo</option></cfif> 
						<cfif ListFindNoCase(listaTablas,'CDRHHCargasCalculo',',') EQ 0>
						<option value="CDRHHCargasCalculo">Cargas Calculo</option></cfif> 
					</select>	
				</td><td>
					<select name="EIid">
						<cfloop query="rsScripts">
							<option value="#EIid#">#EIcodigo# - #EIdescripcion#</option>
						</cfloop>
					</select>
				</td>
				<td>
					<input name="BTNAsociar" type="submit" value="Asociar" />
				</td></tr>
			</table>
		</form>
		
		
		<form name="form2" action="asociaImportador.cfm" enctype="multipart/form-data" method="post">
			<input name="EIid" id="EIid" type="hidden" value=""/>
			<input name="tabla" id="tabla" type="hidden" value=""/>
			<input name="BTNBorrar" type="hidden" value="0" />
			<table cellpadding="1" cellspacing="1" align="center" border="0" width="70%">
				<tr style="background-color:##CCCCCC"><td nowrap><strong><cf_translate key="LB_Tabla">Tabla</cf_translate></strong></td>
				<td nowrap><strong><cf_translate key="LB_Importador">Importador</cf_translate></strong></td>
				<td nowrap><strong>&nbsp;</strong></td>
				</tr>
				
				<cfloop query="rsImportadorAsociado">
					<cfquery name="rsImporName" dbtype="query">
						select EIid, EIcodigo, EImodulo, EIdescripcion
						from rsScripts
						where EIid = #rsImportadorAsociado.CDPIEIid#
					</cfquery>
					
					<tr>
						<td>
						#rsImportadorAsociado.TablaDescripcion#
						</td><td>
							#rsImporName.EIcodigo# #rsImporName.EIdescripcion#
						</td>
						<td>
							<img src="/cfmx/sif/imagenes/Borrar01_S.gif" style="cursor:pointer" onclick="javascript: functionBorrar(#rsImporName.EIid#,'#rsImportadorAsociado.CDPItablaCarga#')" title="Borrar"/>
						</td>
					</tr>
				</cfloop>
			</table>
		</form>
		
		
		<script language="javascript">
			function functionBorrar(EIid,tabla){
				
				if(confirm('Esta seguro que desea borrar la asociacion?')){
					document.form2.EIid.value=EIid;
					document.form2.tabla.value=tabla;
					document.form2.BTNBorrar.value=1;
					document.form2.submit(0);
				}
				
			}
		</script>
		
	</cfoutput>
<cf_web_portlet_end>

<cf_templatefooter>
