
<!---Por ahora se han definido 16 exportadores--->
<cfif getCargasIniciales.recordCount LT 16 >

	<cfoutput>
	<form name="CEfaltantes" action="index.cfm" method="post">
		<input type="hidden" name="CEcodigo" value="#form.CEcodigo#">
		<input type="hidden" name="Ecodigo" value="#form.Ecodigo#">
		<input type="hidden" name="SScodigo" value="#form.SScodigo#">
		<input type="hidden" name="CDPid" value="">
			<center>
				<label>Cargar Exportadores faltantes:</label>
				<input name="BTNCargarExportadores" type="submit" value="Cargar Exportadores"/>
			</center>
	</form>
	</cfoutput>

</cfif>

<cfif isdefined("form.BTNCargarExportadores")>
		
		<!---Oficinas--->
		<cfquery dbtype="query" name="rsgetExist">
			select count(1)as existe from getCargasIniciales where CDPTablaCarga = 'CDRHHOficinas'
		</cfquery>
		
		<cfif rsgetExist.RecordCount EQ 0> 
			<cfquery name="rsCargarExportador" datasource="asp">
				Insert into CDParametros (
							Ecodigo,
							SScodigo,
							CDPorden,
							CDPtabla,
							CDPtablaCarga,
							CDPrutaValida,
							CDPrutaProcesa,
							CDPdependencias,
							CDPbloqueado,
							CDPcontrolv,
							CDPcontrolg
							)
					values (
						#form.Ecodigo#,
						'#form.SScodigo#',
						10,
						'Oficinas',
						'CDRHHOficinas',
						'/rh/cargar/Oficinas_validar.cfm',
						'/rh/cargar/Oficinas_generar.cfm',
						null,
						0,
						0,
						0
					)
			</cfquery>
		</cfif>
			
		<!---Departamentos--->
		<cfquery dbtype="query" name="rsgetExist">
			select count(1)as existe from getCargasIniciales where CDPTablaCarga = 'CDRHHDepartamentos'
		</cfquery>
		
		<cfif rsgetExist.RecordCount EQ 0> 
			<cfquery name="rsCargarExportador" datasource="asp">
				Insert into CDParametros (
							Ecodigo,
							SScodigo,
							CDPorden,
							CDPtabla,
							CDPtablaCarga,
							CDPrutaValida,
							CDPrutaProcesa,
							CDPdependencias,
							CDPbloqueado,
							CDPcontrolv,
							CDPcontrolg
							)
					values (
						#form.Ecodigo#,
						'#form.SScodigo#',
						20,
						'Departamentos',
						'CDRHHDepartamentos',
						'/rh/cargar/Departamentos_validar.cfm',
						'/rh/cargar/Departamentos_generar.cfm',
						'10',
						0,
						0,
						0
					)
			</cfquery>
		</cfif>
		
		
		<!---CentrosFuncionales--->
		<cfquery dbtype="query" name="rsgetExist">
			select count(1)as existe from getCargasIniciales where CDPTablaCarga = 'CDRHHCFuncional'
		</cfquery>
		<cfif rsgetExist.RecordCount EQ 0> 
			<cfquery name="rsCargarExportador" datasource="asp">
				Insert into CDParametros (
							Ecodigo,
							SScodigo,
							CDPorden,
							CDPtabla,
							CDPtablaCarga,
							CDPrutaValida,
							CDPrutaProcesa,
							CDPdependencias,
							CDPbloqueado,
							CDPcontrolv,
							CDPcontrolg
							)
					values (
						#form.Ecodigo#,
						'#form.SScodigo#',
						30,
						'CFuncional',
						'CDRHHCFuncional',
						'/rh/cargar/CFuncional_validar.cfm',
						'/rh/cargar/CFuncional_generar.cfm',
						'20',
						0,
						0,
						0
					)
			</cfquery>
		</cfif>
		
		<!---Tipos Puesto--->
		<cfquery dbtype="query" name="rsgetExist">
			select count(1)as existe from getCargasIniciales where CDPTablaCarga = 'CDRHHTiposPuesto'
		</cfquery>
		<cfif rsgetExist.RecordCount EQ 0> 
			<cfquery name="rsCargarExportador" datasource="asp">
				Insert into CDParametros (
							Ecodigo,
							SScodigo,
							CDPorden,
							CDPtabla,
							CDPtablaCarga,
							CDPrutaValida,
							CDPrutaProcesa,
							CDPdependencias,
							CDPbloqueado,
							CDPcontrolv,
							CDPcontrolg
							)
					values (
						#form.Ecodigo#,
						'#form.SScodigo#',
						35,
						'RHTPuestos',
						'CDRHHTiposPuesto',
						'/rh/cargar/TiposPuesto_validar.cfm',
						'/rh/cargar/TiposPuesto_generar.cfm',
						'30',
						0,
						0,
						0
					)
			</cfquery>
		</cfif>
		
		<!---Puestos--->
		<cfquery dbtype="query" name="rsgetExist">
			select count(1)as existe from getCargasIniciales where CDPTablaCarga = 'CDRHHPuestos'
		</cfquery>
		<cfif rsgetExist.RecordCount EQ 0> 
			<cfquery name="rsCargarExportador" datasource="asp">
				Insert into CDParametros (
							Ecodigo,
							SScodigo,
							CDPorden,
							CDPtabla,
							CDPtablaCarga,
							CDPrutaValida,
							CDPrutaProcesa,
							CDPdependencias,
							CDPbloqueado,
							CDPcontrolv,
							CDPcontrolg
							)
					values (
						#form.Ecodigo#,
						'#form.SScodigo#',
						40,
						'RHPuestos',
						'CDRHHPuestos',
						'/rh/cargar/RHPuestos_validar.cfm',
						'/rh/cargar/RHPuestos_generar.cfm',
						'35',
						0,
						0,
						0
					)
			</cfquery>
		</cfif>
		
		<!---Plazas--->
		<cfquery dbtype="query" name="rsgetExist">
			select count(1)as existe from getCargasIniciales where CDPTablaCarga = 'CDRHHPlazas'
		</cfquery>
		
		<cfif rsgetExist.RecordCount EQ 0> 
			<cfquery name="rsCargarExportador" datasource="asp">
				Insert into CDParametros (
							Ecodigo,
							SScodigo,
							CDPorden,
							CDPtabla,
							CDPtablaCarga,
							CDPrutaValida,
							CDPrutaProcesa,
							CDPdependencias,
							CDPbloqueado,
							CDPcontrolv,
							CDPcontrolg
							)
					values (
						#form.Ecodigo#,
						'#form.SScodigo#',
						50,
						'RHPlazas',
						'CDRHHPlazas',
						'/rh/cargar/RHPlazas_validar.cfm',
						'/rh/cargar/RHPlazas_generar.cfm',
						'40',
						0,
						0,
						0
					)
			</cfquery>
		</cfif>
		
		<!---Datos Empleado--->
		<cfquery dbtype="query" name="rsgetExist">
			select count(1)as existe from getCargasIniciales where CDPTablaCarga = 'CDRHDatosEmpleado'
		</cfquery>
		<cfif rsgetExist.RecordCount EQ 0> 
			<cfquery name="rsCargarExportador" datasource="asp">
				Insert into CDParametros (
							Ecodigo,
							SScodigo,
							CDPorden,
							CDPtabla,
							CDPtablaCarga,
							CDPrutaValida,
							CDPrutaProcesa,
							CDPdependencias,
							CDPbloqueado,
							CDPcontrolv,
							CDPcontrolg
							)
					values (
						#form.Ecodigo#,
						'#form.SScodigo#',
						60,
						'DatosEmpleado',
						'CDRHDatosEmpleado',
						'/rh/cargar/DatosEmpleado_validar.cfm',
						'/rh/cargar/DatosEmpleado_generar.cfm',
						'50',
						0,
						0,
						0
					)
			</cfquery>
		</cfif>
		
		<!---Empleado--->
		<cfquery dbtype="query" name="rsgetExist">
			select count(1)as existe from getCargasIniciales where CDPTablaCarga = 'CDRHHFEmpleado'
		</cfquery>
		<cfif rsgetExist.RecordCount EQ 0> 
			<cfquery name="rsCargarExportador" datasource="asp">
				Insert into CDParametros (
							Ecodigo,
							SScodigo,
							CDPorden,
							CDPtabla,
							CDPtablaCarga,
							CDPrutaValida,
							CDPrutaProcesa,
							CDPdependencias,
							CDPbloqueado,
							CDPcontrolv,
							CDPcontrolg
							)
					values (
						#form.Ecodigo#,
						'#form.SScodigo#',
						65,
						'FEmpleado',
						'CDRHHFEmpleado',
						'/rh/cargar/HFEempleado_validar.cfm',
						'/rh/cargar/HFEempleado_generar.cfm',
						'60',
						0,
						0,
						0
					)
			</cfquery>
		</cfif>
		
		<!---Acciones--->
		<cfquery dbtype="query" name="rsgetExist">
			select count(1)as existe from getCargasIniciales where CDPTablaCarga = 'CDRHHAcciones'
		</cfquery>
		<cfif rsgetExist.RecordCount EQ 0> 
			<cfquery name="rsCargarExportador" datasource="asp">
				Insert into CDParametros (
							Ecodigo,
							SScodigo,
							CDPorden,
							CDPtabla,
							CDPtablaCarga,
							CDPrutaValida,
							CDPrutaProcesa,
							CDPdependencias,
							CDPbloqueado,
							CDPcontrolv,
							CDPcontrolg
							)
					values (
						#form.Ecodigo#,
						'#form.SScodigo#',
						70,
						'RHAcciones',
						'CDRHHAcciones',
						'/rh/cargar/RHAcciones_validar.cfm',
						'/rh/cargar/RHAcciones_generar.cfm',
						'60',
						0,
						0,
						0
					)
			</cfquery>
		</cfif>
		
		<!---Calculo Nomina--->
		<cfquery dbtype="query" name="rsgetExist">
			select count(1)as existe from getCargasIniciales where CDPTablaCarga = 'CDRHHRCalculoNomina'
		</cfquery>
		<cfif rsgetExist.RecordCount EQ 0> 
			<cfquery name="rsCargarExportador" datasource="asp">
				Insert into CDParametros (
							Ecodigo,
							SScodigo,
							CDPorden,
							CDPtabla,
							CDPtablaCarga,
							CDPrutaValida,
							CDPrutaProcesa,
							CDPdependencias,
							CDPbloqueado,
							CDPcontrolv,
							CDPcontrolg
							)
					values (
						#form.Ecodigo#,
						'#form.SScodigo#',
						80,
						'HRCalculoNomina',
						'CDRHHRCalculoNomina',
						'/rh/cargar/HRCalculoNomina_validar.cfm',
						'/rh/cargar/HRCalculoNomina_generar.cfm',
						'60,70',
						0,
						0,
						0
					)
			</cfquery>
		</cfif>
		
		<!---Salario Empleado--->
		<cfquery dbtype="query" name="rsgetExist">
			select count(1)as existe from getCargasIniciales where CDPTablaCarga = 'CDRHHSalarioEmpleado'
		</cfquery>
		<cfif rsgetExist.RecordCount EQ 0> 
			<cfquery name="rsCargarExportador" datasource="asp">
				Insert into CDParametros (
							Ecodigo,
							SScodigo,
							CDPorden,
							CDPtabla,
							CDPtablaCarga,
							CDPrutaValida,
							CDPrutaProcesa,
							CDPdependencias,
							CDPbloqueado,
							CDPcontrolv,
							CDPcontrolg
							)
					values (
						#form.Ecodigo#,
						'#form.SScodigo#',
						90,
						'HSalarioEmpleado',
						'CDRHHSalarioEmpleado',
						'/rh/cargar/HSalarioEmpleado_validar.cfm',
						'/rh/cargar/HSalarioEmpleado_generar.cfm',
						'60,70,80',
						0,
						0,
						0
					)
			</cfquery>
		</cfif>
		
		<!---Pagos Empleado--->
		<cfquery dbtype="query" name="rsgetExist">
			select count(1)as existe from getCargasIniciales where CDPTablaCarga = 'CDRHHPagosEmpleado'
		</cfquery>
		<cfif rsgetExist.RecordCount EQ 0> 
			<cfquery name="rsCargarExportador" datasource="asp">
				Insert into CDParametros (
							Ecodigo,
							SScodigo,
							CDPorden,
							CDPtabla,
							CDPtablaCarga,
							CDPrutaValida,
							CDPrutaProcesa,
							CDPdependencias,
							CDPbloqueado,
							CDPcontrolv,
							CDPcontrolg
							)
					values (
						#form.Ecodigo#,
						'#form.SScodigo#',
						100,
						'HPagosEmpleado',
						'CDRHHPagosEmpleado',
						'/rh/cargar/HPagosEmpleado_validar.cfm',
						'/rh/cargar/HPagosEmpleado_generar.cfm',
						'60,70,80,90',
						0,
						0,
						0
					)
			</cfquery>
		</cfif>
		
		<!---Deducciones Empleado--->
		<cfquery dbtype="query" name="rsgetExist">
			select count(1)as existe from getCargasIniciales where CDPTablaCarga = 'CDRHHDeduccionesEmpleado'
		</cfquery>
		<cfif rsgetExist.RecordCount EQ 0> 
			<cfquery name="rsCargarExportador" datasource="asp">
				Insert into CDParametros (
							Ecodigo,
							SScodigo,
							CDPorden,
							CDPtabla,
							CDPtablaCarga,
							CDPrutaValida,
							CDPrutaProcesa,
							CDPdependencias,
							CDPbloqueado,
							CDPcontrolv,
							CDPcontrolg
							)
					values (
						#form.Ecodigo#,
						'#form.SScodigo#',
						110,
						'DeduccionesEmpleado',
						'CDRHHDeduccionesEmpleado',
						'/rh/cargar/DeduccionesEmpleado_validar.cfm',
						'/rh/cargar/DeduccionesEmpleado_generar.cfm',
						'60,70,80,90',
						0,
						0,
						0
					)
			</cfquery>
		</cfif>
	
		<!---Deducciones Calculo--->
		<cfquery dbtype="query" name="rsgetExist">
			select count(1)as existe from getCargasIniciales where CDPTablaCarga = 'CDRHHDeduccionesCalculo'
		</cfquery>
		
		<cfif rsgetExist.RecordCount EQ 0> 
			<cfquery name="rsCargarExportador" datasource="asp">
				Insert into CDParametros (
							Ecodigo,
							SScodigo,
							CDPorden,
							CDPtabla,
							CDPtablaCarga,
							CDPrutaValida,
							CDPrutaProcesa,
							CDPdependencias,
							CDPbloqueado,
							CDPcontrolv,
							CDPcontrolg
							)
					values (
						#form.Ecodigo#,
						'#form.SScodigo#',
						120,
						'HDeduccionesCalculo',
						'CDRHHDeduccionesCalculo',
						'/rh/cargar/HDeduccionesCalculo_validar.cfm',
						'/rh/cargar/HDeduccionesCalculo_generar.cfm',
						'60,70,80,90',
						0,
						0,
						0
					)
			</cfquery>
		</cfif>
		
		<!---Incidencias Calculo--->
		<cfquery dbtype="query" name="rsgetExist">
			select count(1)as existe from getCargasIniciales where CDPTablaCarga = 'CDRHHIncidenciasCalculo'
		</cfquery>
		<cfif rsgetExist.RecordCount EQ 0> 
			<cfquery name="rsCargarExportador" datasource="asp">
				Insert into CDParametros (
							Ecodigo,
							SScodigo,
							CDPorden,
							CDPtabla,
							CDPtablaCarga,
							CDPrutaValida,
							CDPrutaProcesa,
							CDPdependencias,
							CDPbloqueado,
							CDPcontrolv,
							CDPcontrolg
							)
					values (
						#form.Ecodigo#,
						'#form.SScodigo#',
						130,
						'HIncidenciasCalculo',
						'CDRHHIncidenciasCalculo',
						'/rh/cargar/HIncidenciasCalculo_validar.cfm',
						'/rh/cargar/HIncidenciasCalculo_generar.cfm',
						'60,70,80,90',
						0,
						0,
						0
					)
			</cfquery>
		</cfif>
		
		<!---Cargas Calculo--->
		<cfquery dbtype="query" name="rsgetExist">
			select count(1)as existe from getCargasIniciales where CDPTablaCarga = 'CDRHHCargasCalculo'
		</cfquery>
		<cfif rsgetExist.RecordCount EQ 0> 
			<cfquery name="rsCargarExportador" datasource="asp">
				Insert into CDParametros (
							Ecodigo,
							SScodigo,
							CDPorden,
							CDPtabla,
							CDPtablaCarga,
							CDPrutaValida,
							CDPrutaProcesa,
							CDPdependencias,
							CDPbloqueado,
							CDPcontrolv,
							CDPcontrolg
							)
					values (
						#form.Ecodigo#,
						'#form.SScodigo#',
						140,
						'HCargasCalculo',
						'CDRHHCargasCalculo',
						'/rh/cargar/HCargasCalculo_validar.cfm',
						'/rh/cargar/HCargasCalculo_generar.cfm',
						'60,70,80,90',
						0,
						0,
						0
					)
			</cfquery>
		</cfif>
		
		<!---Refresca los exportadores existentes--->
		<cfquery name="getCargasIniciales" datasource="asp">
			select  CDPid, CDPorden, CDPtabla, case CDPcontrolv when 0 then '#unchecked#' else '#checked#' end as CDPvalidado, 
			case CDPcontrolg when 0 then '#unchecked#' else '#checked#' end  as CDPcargado, CDPtablaCarga, CDPrutaValida, 
			CDPrutaProcesa, CDPdependencias, CDPcontrolv, CDPcontrolg, CDPomitir
			from CDParametros
			where Ecodigo = #form.Ecodigo#
			and SScodigo = '#form.SScodigo#' 
			order by CDPorden
		</cfquery>
		
	</cfif>
