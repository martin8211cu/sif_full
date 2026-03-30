<!--- Inicializa la cantidad de registros insertados (cantidad de ordenes de compra consolidadas) --->
<cfset registros = 0>

<!--- Obtiene los caches --->
<cfquery name="rsCaches" datasource="asp">
	select  distinct c.Ccache
	from	Empresa emp,
			ModulosCuentaE mce,
			Caches c,
			SModulos sm
	where emp.CEcodigo = mce.CEcodigo
		and c.Cid = emp.Cid
		and mce.SScodigo = 'SIF'
		and sm.SScodigo = mce.SScodigo
		and sm.SMcodigo = mce.SMcodigo
		and sm.SMcodigo = 'CM'
		and emp.Ereferencia is not null
</cfquery>

<!--- En cada cache: --->
<cfloop query="rsCaches">

	<cfset vsCache = trim(rsCaches.Ccache)>	<!---Variable con el cache que se esta procesando --->

	<cfset continuar = true>

	<cftry>
	
		<cfif continuar>
		
			<!--- Obtener todas las empresas del cache actual --->
			<cfquery name="rsEmpresas" datasource="#vsCache#">
				select Ecodigo
				from Empresas
			</cfquery>
			
			<cftransaction>
			
				<!--- Para cada empresa, realiza el proceso de consolidación, verificando si el parámetro
					  que habilita la funcionalidad de las consolidaciones está activo, y verificando
					  que los parámetros de la frecuencia de ejecución del proceso indican
					  que se debe ejecutar --->

				<cfloop query="rsEmpresas">
				
					<cfset vnEmpresa = rsEmpresas.Ecodigo>	<!--- Variable con la empresa a procesar --->

					<!--- Verifica que el parámetro que habilita la funcionalidad de la consolidación de órdenes de compra esté activo --->
					<cfquery name="rsParametroConsolidacionOC" datasource="#vsCache#">
						select Pvalor
						from Parametros
						where Pcodigo = 770
							and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#vnEmpresa#">
					</cfquery>
					
					<!--- Si el parámetro no está activo, no realiza la consolidación --->
					<cfif rsParametroConsolidacionOC.RecordCount gt 0 and rsParametroConsolidacionOC.Pvalor eq '1'>

						<!--- Obtiene el parámetro de frecuencia de ejecución del proceso de agrupación --->
						<cfquery name="rsParametroFrecuencia" datasource="#vsCache#">
							select Pvalor
							from Parametros
							where Pcodigo = 780
								and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#vnEmpresa#">
						</cfquery>
						
						<cfset realizarConsolidacion = false>	<!--- Variable que indica si se va a realizar la consolidación --->
						
						<cfif rsParametroFrecuencia.RecordCount gt 0>
						
							<!--- Si la frecuencia es diariamente, realiza la consolidación --->
							<cfif rsParametroFrecuencia.Pvalor eq 'D'>
								<cfset realizarConsolidacion = true>
								
							<!--- Si la frecuencia es semanalmente y el día de la semana en que se corre el proceso
								  está habilitado en el parámetro de días de la semana, se realiza la consolidación --->
							<cfelseif rsParametroFrecuencia.Pvalor eq 'S'>
								<cfquery name="rsParametroDiasSemana" datasource="#vsCache#">
									select Pvalor
									from Parametros
									where Pcodigo = 790
										and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#vnEmpresa#">
								</cfquery>
								
								<cfset DiaSemana = DayOfWeek(Now())>
								
								<cfif rsParametroDiasSemana.RecordCount gt 0 and Mid(rsParametroDiasSemana.Pvalor, DiaSemana, 1) eq '1'>
									<cfset realizarConsolidacion = true>
								</cfif>
								
							<!--- Si la frecuencia es mensualmente y el día del mes en que se corre el proceso
								  es igual al día indicado en el parámetro de día del mes, se realiza la consolidación --->
							<cfelseif rsParametroFrecuencia.Pvalor eq 'M'>
								<cfquery name="rsParametroDiaMes" datasource="#vsCache#">
									select Pvalor
									from Parametros
									where Pcodigo = 800
										and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#vnEmpresa#">
								</cfquery>
								
								<cfset DiaMes = Day(Now())>
								<cfset CantidadDiasMes = DaysInMonth(Now())>
								
								<cfif rsParametroDiaMes.RecordCount gt 0 and (rsParametroDiaMes.Pvalor eq DiaMes or (CantidadDiasMes eq DiaMes and rsParametroDiaMes.Pvalor + 0 gt DiaMes))>
									<cfset realizarConsolidacion = true>
								</cfif>
							</cfif>
						</cfif>
						
						<cfif realizarConsolidacion>
				
							<!--- Obtiene el número de consolidación mayor --->
							<cfquery name="rsMaxNumero" datasource="#vsCache#">
								select coalesce(max(ecoc.ECOCnumero), 0) as ECOCnumero
								from EConsolidadoOrdenCM ecoc
								where ecoc.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#vnEmpresa#">
							</cfquery>
							
							<!--- Verifica que existan detalles a insertar, si no hay, no realiza la consolidación --->
							<cfquery name="rsHayDetalles" datasource="#vsCache#">
								select count(1) as TotalDetalles
								from EOrdenCM eo
									inner join CMTipoOrden cmto
										on cmto.CMTOcodigo = eo.CMTOcodigo
										and cmto.Ecodigo = eo.Ecodigo
								where eo.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#vnEmpresa#">
									and eo.EOestado = 10
									and (cmto.CMTOimportacion = 0
										or cmto.CMTgeneratracking = 0)
									and exists (
										select 1
										from CMOCContrato cmoc
										where cmoc.EOidorden = eo.EOidorden
									)
									and exists (
										select 1
										from DOrdenCM docm
										where docm.DOcantsurtida < docm.DOcantidad
											and docm.EOidorden = eo.EOidorden
											and docm.Ecodigo = eo.Ecodigo
									)
									and not exists (
										select 1
										from DConsolidadoOrdenCM ecoc
										where ecoc.EOidorden = eo.EOidorden
									)
							</cfquery>
							
							<cfif rsHayDetalles.TotalDetalles gt 0>
							
								<!--- Inserta el encabezado del consolidado --->
								<cfquery name="rsInsertEncabezado" datasource="#vsCache#">
									insert into EConsolidadoOrdenCM (ECOCnumero, Ecodigo, ECOCfechaalta, ECOCfechaconsolida, BMUsucodigo)
									values (
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsMaxNumero.ECOCnumero + 1#">,
										<cfqueryparam cfsqltype="cf_sql_integer" value="#vnEmpresa#">,
										<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
										<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
										0
									)
									<cf_dbidentity1 datasource="#vsCache#">
								</cfquery>
								<cf_dbidentity2 datasource="#vsCache#" name="rsInsertEncabezado">
								
								<!--- Inserta las órdenes que se van a consolidar en el detalle del consolidado --->
								<cfquery name="rsInsertDetalle" datasource="#vsCache#">
									insert into DConsolidadoOrdenCM (ECOCid, EOidorden, Ecodigo, DCOCrdenviado, DCOCrrenviado, BMUsucodigo)
									select  <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsInsertEncabezado.identity#">,
											eo.EOidorden,
											<cfqueryparam cfsqltype="cf_sql_integer" value="#vnEmpresa#">,
											0,
											0,
											0
									from EOrdenCM eo
										inner join CMTipoOrden cmto
											on cmto.CMTOcodigo = eo.CMTOcodigo
											and cmto.Ecodigo = eo.Ecodigo
									where eo.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#vnEmpresa#">
										and eo.EOestado = 10
										and (cmto.CMTOimportacion = 0
											or cmto.CMTgeneratracking = 0)
										and exists (
											select 1
											from CMOCContrato cmoc
											where cmoc.EOidorden = eo.EOidorden
										)
										and exists (
											select 1
											from DOrdenCM docm
											where docm.DOcantsurtida < docm.DOcantidad
												and docm.EOidorden = eo.EOidorden
												and docm.Ecodigo = eo.Ecodigo
										)
										and not exists (
											select 1
											from DConsolidadoOrdenCM ecoc
											where ecoc.EOidorden = eo.EOidorden
										)
								</cfquery>
								
								<!--- Incrementa la cantidad de registros --->
								<cfset registros = registros + rsHayDetalles.TotalDetalles>
								
							</cfif>
						</cfif>
						
					</cfif>
	
				</cfloop>
			</cftransaction>
		</cfif>
	
	<cfcatch type="any">
		<cfset continuar = false >
	</cfcatch>
	
	</cftry>
	
</cfloop>
