<cfcomponent>
	<!--- FUNCION QUE BUSCA LOS CONCEPTOS DE PAGO Y DA COMO RESULTADO EL TOTAL DE PUNTOS A PAGAR POR UN CONCEPTO DE PAGO --->
	<cffunction name="AcumulaConceptos" access="public" output="true" returntype="query">
		<cfargument name="conexion" type="string" required="no" default="#Session.DSN#">
		<cfargument name="Ecodigo" 	type="numeric" 	required="yes">
		<cfargument name="CCPid" 	type="numeric" 	required="yes">
		<cfargument name="TCCPid" 	type="numeric" 	required="yes">
		<cfargument name="Prioridad"type="numeric" 	required="yes">
		<cfargument name="Acumula" 	type="numeric" 	required="yes">
		<cfargument name="RCdesde" 	type="date" 	required="yes">
		<cfargument name="RChasta" 	type="date" 	required="yes">
		<cfargument name="DEid" 	type="numeric" 	required="no" default="false">
		
		<cfquery name="rsPrioridades" datasource="#arguments.conexion#">
			select max(CCPprioridad) as MaxPrior
			from LineaTiempoCP a
			inner join ConceptosCarreraP b
				on b.CCPid = a.CCPid
			where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
			  and TCCPid = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.TCCPid#">
			  and LTdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.RChasta#">
		</cfquery>
		<cfif arguments.Acumula>
			<!--- SI ACUMULA DEBE DE SUMAR LOS VALORES DE CADA UNO DEL LOS CONCEPTOS DE PAGO --->
			<cfquery name="rsIncidencia" datasource="#arguments.conexion#">
				select (
						select round(sum(a.valor*b.CCPequivalenciapunto),2)
						from LineaTiempoCP a
						inner join ConceptosCarreraP b
							on b.CCPid = a.CCPid
						where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
						  and a.CCPid = e.CCPid
						  and a.DEid = e.DEid
						  and a.LTdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.RChasta#">
						 ) as valor, e.LTdesde,e.CCPid
				from LineaTiempoCP e
				where e.LTdesde = (select max(c.LTdesde) 
							from LineaTiempoCP c 
							where e.CCPid = c.CCPid
							  and e.DEid = c.DEid 
							  and c.LTdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.RChasta#">)
				  and e.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
				  and e.CCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CCPid#">
				  and e.LTdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.RChasta#">
			</cfquery>
		<cfelse>
			<!--- SI NO ACUMULA DEBE DE DEVOLVER EL VALOR DEL ULTIMO CONCEPTO DE PAGO REGISTRADO --->
			<cfquery name="rsIncidencia" datasource="#arguments.conexion#">
				select <cfif arguments.Prioridad GTE rsPrioridades.MaxPrior>coalesce(valor*CCPequivalenciapunto,0) <cfelse>0</cfif>as valor, a.LTdesde,a.CCPid
				from LineaTiempoCP a
				inner join ConceptosCarreraP b
					on b.CCPid = a.CCPid
				where a.DEid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
				  and a.CCPid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CCPid#">
				  and a.LTdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.RChasta#">
				  and a.LTdesde = (select max(c.LTdesde) from LineaTiempoCP c where c.DEid = a.DEid and c.CCPid = a.CCPid)
			</cfquery>
		</cfif>
		<cfreturn rsIncidencia>
	</cffunction>
	<!--- FUNCION PARA EL CALCULO DE LOS CONCEPTOS DE TIPO CALCULO --->
	<cffunction name="ConceptoPCalculo" access="public" output="true">
		<cfargument name="conexion" 	type="string" required="no" default="#Session.DSN#">
		<cfargument name="Ecodigo" 		type="numeric" required="yes">
		<cfargument name="CIid" 		type="numeric" 	required="yes">
		<cfargument name="RCNid"   type="numeric" required="yes">
		<cfargument name="CFid"   type="numeric" required="yes">
		<cfargument name="pDEid" 		type="numeric" required="no">
		<cfargument name="RCdesde" 		type="date" required="no">
		<cfargument name="RChasta" 		type="date" required="no">
		<cfargument name="Usucodigo" 	type="string" required="no" default="#Session.Usucodigo#">
		<cfargument name="Ulocalizacion" type="string" required="no" default="00">
		<cfargument name="debug" 		type="boolean" required="no" default="false">
		
		<!--- FECHA DE CORTE --->	
		<cfset fecha_corte = LSDateFormat(now(), 'dd/mm/yyyy') >
		<!--- DATOS DEL CONCEPTO DE PAGO A CALCULAR --->
		<cfquery name="data_concepto" datasource="#Session.DSN#">
			select c.CIid, c.CIcantidad, c.CIrango, c.CItipo, c.CIcalculo, c.CIdia, c.CImes
				,c.CIspcantidad, c.CIsprango,
			from CIncidentesD c
			where c.CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CIid#">
		</cfquery>

		<!--- INCLUYE LA CALCULADORA --->
		<cfset RH_Calculadora = createobject("component","rh.Componentes.RH_Calculadora")>
		
		<!--- NOMINA DEL EMPLEADO --->
		<cfquery name="data_nomina" datasource="#session.DSN#">
			select Tcodigo
			from LineaTiempo
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.pDEid#">
			and <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> between LTdesde and LThasta
		</cfquery>
		<cfset Tcodigo = data_nomina.Tcodigo >
		
		<!--- INVOCACION DE LA CALCULADORA --->
		<cfset FVigencia = fecha_corte >
		<cfset FFin = fecha_corte >
		<cfset current_formulas = data_concepto.CIcalculo>
        <cfset presets_text = RH_Calculadora.get_presets(CreateDate(ListGetAt(FVigencia,3,'/'), ListGetAt(FVigencia,2,'/'), ListGetAt(FVigencia,1,'/')),
                                   CreateDate(ListGetAt(FFin,3,'/'), ListGetAt(FFin,2,'/'), ListGetAt(FFin,1,'/')),
                                   data_concepto.CIcantidad,
                                   data_concepto.CIrango,
                                   data_concepto.CItipo,
                                   arguments.pDEid,
                                   1,
                                   session.Ecodigo,
                                   0,
                                   0,
                                   data_concepto.CIdia,
                                   data_concepto.CImes,
                                   Tcodigo, <!--- Tcodigo solo se requiere si no va RHAlinea--->
                                   FindNoCase('SalarioPromedio', current_formulas), <!--- optimizacion - SalarioPromedio es el calculo más pesado--->
                                   'false',
                                   '',
                                   'false'   
                                   , 0
                                   , '' 
                                   ,data_concepto.CIsprango
                                   ,data_concepto.CIspcantidad)>
		<cfset values = RH_Calculadora.calculate( presets_text & ";" & current_formulas )>
        <cfset calc_error = RH_Calculadora.getCalc_error()>
		<cfif Not IsDefined("values")>
			<cfif isdefined("presets_text")>
				<cfthrow detail="#presets_text# & '----' & #current_formulas# & '-----' & #calc_error#">
			<cfelse>
				<cfthrow detail="#calc_error#" >
			</cfif>
		</cfif>
		<cfset Lvar_resultado	= iif( len(trim(values.get('resultado').toString())), values.get('resultado').toString(), '0') >
		<cfset Lvar_cantidad 	= iif( len(trim(values.get('cantidad').toString())), values.get('cantidad').toString(), '0') >
		<cfset Lvar_importe		= iif( len(trim(values.get('importe').toString())), values.get('importe').toString(), '0') >
		<!--- INSERTA LA INCIDENCIA CORRESPONDIENTE --->
		<cfquery name="IncidenciasCP" datasource="#session.DSN#">
			insert into IncidenciasCalculo 
				(RCNid, DEid, CIid, ICfecha, ICvalor, ICfechasis, Usucodigo, Ulocalizacion, ICcalculo, ICbatch, ICmontoant, ICmontores, CFid)
			values(
					<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.RCNid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.pDEid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.CIid#">,
					<cfqueryparam cfsqltype="cf_sql_date" 	 	value="#arguments.RCdesde#">,
					<cfqueryparam cfsqltype="cf_sql_money"	 	value="#Lvar_importe#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" 	value="#now()#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_char" 	   	value="#session.Ulocalizacion#">,
					0, null, 0.00,
					<cfqueryparam cfsqltype="cf_sql_money"	  	value="#Lvar_resultado#">,
					<cfqueryparam cfsqltype="cf_sql_numeric"  	value="#arguments.CFid#">
			)
		</cfquery>
	</cffunction>
	
	<!--- FUNCION QUE HACE EL CALCULO DEL MONTO A PAGAR DEPENDIENDO DE LOS DIAS TRABAJADOS --->
	<cffunction name="CalculaMonto" access="public" output="true" returntype="numeric">
		<cfargument name="conexion" type="string" required="no" default="#Session.DSN#">
		<cfargument name="Ecodigo" type="numeric" required="yes">
		<cfargument name="RCNid"   type="numeric" required="yes">
		<cfargument name="RCdesde" type="date" required="no">
		<cfargument name="RChasta" type="date" required="no">
		<cfargument name="Fdesde" type="date" required="no">
		<cfargument name="DEid" type="numeric" required="no">
		<cfargument name="MontoDiario" type="numeric" required="no">
		<cfset Lvar_FInicio = arguments.Fdesde>
		<cfset Lvar_CantDias = 0>
		<!--- VERIFICA CUANTOS DÍAS HAR A PARTIR DE EL PRIMER CORTE > A LA FECHA DE INICIO DEL CONCEPTO --->
		<cfquery name="rsCantDias" datasource="#session.DSN#">
			select coalesce(sum(PEcantdias),0) as CantDias
			from PagosEmpleado
			where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
			  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
			  and PEdesde > <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FInicio#"> 
			  and PEsalario > 0
		</cfquery>
		<cfset Lvar_CantDias = rsCantDias.CantDias>
		<!--- VERIFICA CUANTOS DIAS HAY EN EL CORTE DONDE ESTA LA FECHA DE INICIO DEL CONCEPTO --->
		<cfquery name="rsCantDias" datasource="#session.DSN#">
			select coalesce(PEcantdias - datediff(dd,PEdesde,<cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FInicio#">),0) as CantDias
			from PagosEmpleado
			where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
			  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
			  and <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FInicio#">  between PEdesde and PEhasta
			  and PEsalario > 0
		</cfquery>
		<cfif rsCantDias.REcordCount><cfset Lvar_CantDias = Lvar_CantDias + rsCantDias.CantDias></cfif>
		<cfset Lvar_monto = arguments.MontoDiario * Lvar_CantDias>
		<cfreturn Lvar_monto>
	</cffunction>
	
	<!--- FUNCION QUE HACE EL CALCULO DE LOS CONCEPTOS DE PAGO PARA LA NOMINA --->
	<cffunction name="CalculoCP" access="public" output="true" >
		<cfargument name="conexion" type="string" required="no" default="#Session.DSN#">
		<cfargument name="Ecodigo" type="numeric" required="yes">
		<cfargument name="RCNid"   type="numeric" required="yes">
		<cfargument name="RCdesde" type="date" required="no">
		<cfargument name="RChasta" type="date" required="no">
		<cfargument name="CantDiasMensual" type="numeric" required="yes">
		<cfargument name="pDEid" type="numeric" required="no">
		<cfargument name="Usucodigo" type="string" required="no" default="#Session.Usucodigo#">
		<cfargument name="Ulocalizacion" type="string" required="no" default="00">
		<cfargument name="debug" type="boolean" required="no" default="false">
		<!--- TRAER LOS EMPLEADOS DE ESTA NÓMINA Y QUE TIENEN INCENTIVO DE CARRERA PROFESIONAL --->
		<cfquery name="rsEmpleados" datasource="#arguments.conexion#">
			select distinct DEid,case when b.CFidconta is null then b.CFid else b.CFidconta end as CFid, a.RHPcodigo
			from PagosEmpleado a
			inner join RHPlazas b
				on b.RHPid = a.RHPid
			where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
			  and exists (select 1 
			  				from LineaTiempoCP lt 
							where lt.DEid = a.DEid
							  and lt.LTdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.RChasta#">)
		   	<cfif IsDefined('Arguments.pDEid') and len(trim(Arguments.pDEid)) and Arguments.pDEid GT 0> 
			  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#">
		  	</cfif>
		</cfquery>
		<!--- 1. PARA CADA UNO DE LOS EMPLEADOS QUE TIENEN INCENTIVO SE BUSCAN LOS CONCEPTOS DE PAGO QUE TIENE ASIGNADOS 
			SE VERIFICA SI EL CONCEPTO DE PAGO SE PAGA PARA EL PUESTO QUE TIENE ASIGNADO A LA PERSONA
		--->
		<cfloop query="rsEmpleados">
			<cfset Lvar_DEid = rsEmpleados.DEid>
			<cfquery name="rsConceptoPCP" datasource="#arguments.conexion#">
				select distinct a.CCPid, b.CCPacumulable, b.CCPplazofijo, b.CCPporcsueldo,b.TCCPid,b.CCPprioridad
				from LineaTiempoCP a
				inner join ConceptosCarreraP b
					on b.CCPid = a.CCPid
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_DEid#">
				  and a.LTdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.RChasta#">
				 and (CCPpuestosEspecificos = 1 
													and exists(select 1 
															from PuestosxConceptoCP p 
															where p.CCPid = a.CCPid 
															  and p.RHPcodigo = '#rsEmpleados.RHPcodigo#') 
													 or CCPpuestosEspecificos = 0)
			</cfquery>
			<!--- 1.2 SE APLICA LA FUNCION PARA ACUMULAR LOS PUNTOS --->
			<cfloop query="rsConceptoPCP">
				<cfset Lvar_CCPid = rsConceptoPCP.CCPid>
				<cfset Lvar_Valor = 0>
				<!--- PARA CADA UNO DE LOS CONCEPTOS SE BUSCAN LOS VALORES A PAGAR --->
				<cfinvoke component="rh.Componentes.RH_CalculoCP" method="AcumulaConceptos" returnvariable="Conceptos" conexion="#arguments.conexion#"
					ecodigo = "#arguments.Ecodigo#" ccpid = "#Lvar_CCPid#" acumula = "#rsConceptoPCP.CCPacumulable#" tccpid="#rsConceptoPCP.TCCPid#"
					prioridad="#rsConceptoPCP.CCPprioridad#" rcdesde="#arguments.RCdesde#" rchasta="#arguments.RChasta#" deid = "#Lvar_DEid#"/>
				<cfif isdefined('Conceptos') and Conceptos.valor GT 0>
					<cfloop query="Conceptos">
						<cfset Lvar_CCPid = Conceptos.CCPid>
						<cfset Lvar_Fdesde = Conceptos.LTdesde>
						<cfset Lvar_Valor = Conceptos.valor>
						<cfset Lvar_Puntos = Conceptos.valor>
						<!--- DATOS DEL CONCEPTO QUE SE ESTA PROCESANDO --->
						<cfquery name="rsIncidencias" datasource="#session.DSN#">
							select a.CCPid,a.CIid,CCPplazofijo,CCPporcsueldo,CCPfactorpunto,CCPacumulable,CCPmaxpuntos,
									CCPpuntofraccionable,UECPid,coalesce(CCPequivalenciapunto,1) as CCPequivalenciapunto,CCPpagoCada, 
									CItipo,CCPpagoXdia
							from ConceptosCarreraP a
							inner join CIncidentes b
								on b.CIid = a.CIid
							where CCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_CCPid#">
						</cfquery>
						<cfquery name="acumulado" datasource="#session.DSN#">
						  select coalesce(sum(valor),0) as acum 
						  from LineaTiempoCP 
						  where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_DEid#">
							and LTdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.RChasta#">
							and CCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_CCPid#">
						</cfquery>
						<cfif rsIncidencias.CItipo NEQ 3> <!--- SI NO ES UN CONCEPTO DE PAGO DE CALCULO --->
							<cfif rsIncidencias.CCPporcsueldo>
								<!--- SI ES UN CONCEPTO QUE APLICA UN PORCENTAJE SOBRE EL SUELDO --->
								<cfquery name="rsMonto" datasource="#arguments.conexion#">
									select b.DLTmonto as Salario
									from LineaTiempo a
									inner join DLineaTiempo b
										on b.LTid = a.LTid
									inner join ComponentesSalariales c
										on c.CSid = b.CSid
									where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_DEid#">
									  and <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> between LTdesde and LThasta
									  and c.CSsalariobase = 1
								</cfquery>
								<cfset Lvar_Valor = rsMonto.Salario*Lvar_Valor/100>
							<cfelse>
								<cfset acum=Lvar_Valor/rsIncidencias.CCPequivalenciapunto>
	
								<!--- OTROS CONCEPTOS DE PAGO --->
								<cfif rsIncidencias.CCPpuntofraccionable and (acum LT rsIncidencias.CCPmaxpuntos)>
									<cfset Lvar_Valor = Lvar_Valor * rsIncidencias.CCPfactorpunto>
								<cfelseif not rsIncidencias.CCPpuntofraccionable and acum LT rsIncidencias.CCPmaxpuntos>
									<cfset ParteEntera = Lvar_Valor / rsIncidencias.CCPpagoCada>
									<cfset Lvar_Valor = ParteEntera * rsIncidencias.CCPfactorpunto>
								<cfelse>
									<cfset Lvar_Valor = rsIncidencias.CCPmaxpuntos *  rsIncidencias.CCPequivalenciapunto * rsIncidencias.CCPfactorpunto>
								</cfif>
							</cfif>
							<!--- SI SE TIENE QUE PAGAR POR DÍA DESDE EL DÍA QUE SE OBTIENE EL CONCEPTO, O SE PAGA TODO EL MES --->
							<cfif rsIncidencias.CCPpagoXdia>
								<cfinvoke component="rh.Componentes.RH_CalculoCP" 
											method="CalculaMonto" 
											returnvariable="Lvar_Valor" 
											conexion="#arguments.conexion#"
											ecodigo = "#arguments.Ecodigo#" 
											rcnid = "#arguments.RCNid#" 
											rcdesde = "#arguments.RCdesde#" 
											rchasta = "#arguments.RChasta#" 
											fdesde = "#Lvar_Fdesde#"
											deid ="#Lvar_DEid#"
											montodiario= "#Lvar_Valor/arguments.CantDiasMensual#"/>
							</cfif>
							<!--- INSERTA LA INCIDENCIA CORRESPONDIENTE --->
							<cfquery name="IncidenciasCP" datasource="#session.DSN#">
								insert into IncidenciasCalculo 
									(RCNid, DEid, CIid, ICfecha, ICvalor, ICfechasis, Usucodigo, Ulocalizacion, ICcalculo, ICbatch, ICmontoant, ICmontores, CFid)
								values(
										<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#arguments.RCNid#">,
										<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Lvar_DEid#">,
										<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#rsIncidencias.CIid#">,
										<cfqueryparam cfsqltype="cf_sql_date" 	 	value="#Lvar_Fdesde#">,
										<cfqueryparam cfsqltype="cf_sql_money"	 	value="#Lvar_Valor#">,
										<cfqueryparam cfsqltype="cf_sql_timestamp" 	value="#now()#">,
										<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#session.Usucodigo#">,
										<cfqueryparam cfsqltype="cf_sql_char" 	   	value="#session.Ulocalizacion#">,
										0, null, 0.00,
										<cfqueryparam cfsqltype="cf_sql_money"	  	value="#Lvar_Valor#">,
										<cfqueryparam cfsqltype="cf_sql_numeric"  	value="#rsEmpleados.CFid#">
								)
							</cfquery>
						<cfelse>
							<!--- SI ES UN CONCEPTO DE PAGO DE METODO CALCULO LLAMA A LA CALCULADORA Y DEVUELVE LA CANTIDAD DE PUNTOS A PAGAR--->
							<cfinvoke component="rh.Componentes.RH_CalculoCP" method="ConceptoPCalculo" returnvariable="Lvar_Valor" conexion="#arguments.conexion#"
								ecodigo = "#arguments.Ecodigo#" ciid = "#rsIncidencias.CIid#" pdeid = "#rsEmpleados.DEid#" RCNid="#arguments.RCNid#" CFid="#rsEmpleados.CFid#"
								rcdesde="#arguments.RCdesde#"/>
							
						</cfif>
					</cfloop>
				</cfif>
			</cfloop>
		</cfloop>
	</cffunction>
</cfcomponent>