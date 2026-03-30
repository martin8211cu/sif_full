<cfif not isdefined("Form.Nuevo")>
		 <cfif isdefined("Form.Alta") or isdefined("Form.Cambio")>
			<cfquery name="rs_concepto" datasource="#session.DSN#">
				select coalesce(CInegativo, 1) as CInegativo
				from CIncidentes
				where CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid#">
			</cfquery>
			<cfset valor = form.Ivalor >
			<cfif rs_concepto.CInegativo lt 0>
				<cfset valor = valor*-1>
			</cfif>	
		 </cfif>

		 <cfif isdefined("Form.Alta")>
		 	<cftransaction>
				<cfquery name="RHLiqIngresos" datasource="#session.DSN#">
					insert into RHLiqIngresosPrev (RHPLPid, DEid, CIid, Ecodigo, RHLPdescripcion, importe, BMUsucodigo, fechaalta, RHLIFiniquito)
					select 
						RHPLPid,
						DEid,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid#">,
						Ecodigo,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CIdescripcion#">,
						<cfqueryparam cfsqltype="cf_sql_money" value="#valor#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						<cfif isdefined('form.esFiniquito')>1<cfelse>0</cfif>
					from RHPreLiquidacionPersonal
					where RHPLPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPLPid#">
					 <cf_dbidentity1 datasource="#session.DSN#">
				</cfquery>
				<cf_dbidentity2 datasource="#session.DSN#" name="RHLiqIngresos">
				<cfinvoke component="rh.Componentes.RHLiquidacionMXPrev" method="fnCalculaEG">
					<cfinvokeargument name="RHLPPid" value="#RHLiqIngresos.identity#">
				</cfinvoke>
			</cftransaction>		

		<cfelseif isdefined("Form.Baja")> 
        	<!---<cf_dump var = "#form#">--->
			<cfquery name="delRHLiqIngresos" datasource="#Session.DSN#">
				delete RHLiqIngresosPrev
				where RHLPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHLPPid#">
				and RHPLPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPLPid#">
			</cfquery>
			<!---<cfset Form.Nuevo = "1">--->
			
		<cfelseif isdefined("Form.Cambio")>
 			<cftransaction>
				<cfquery datasource="#Session.DSN#">
					update RHLiqIngresosPrev set
						importe = <cfqueryparam cfsqltype="cf_sql_money" value="#valor#">,
						RHLIFiniquito = <cfif isdefined('form.esFiniquito')>1<cfelse>0</cfif>
					where RHLPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHLPPid#">
					and RHPLPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHPLPid#">
				</cfquery>
				<cfinvoke component="rh.Componentes.RHLiquidacionMX" method="fnCalculaEG">
					<cfinvokeargument name="RHLPid" value="#Form.RHLPPid#">
				</cfinvoke>
			</cftransaction>
		<cfelseif isdefined("Form.Guardar")>
			<cftransaction >
				<cfquery datasource="#Session.DSN#">
					delete RHLiqIngresosPrev
					where RHPLPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHPLPid#">
					  and cesantia = 1
				</cfquery>
				
				<cfquery name="rs_incidencia" datasource="#session.DSN#">
					select CIcodigo, CIdescripcion
					from CIncidentes
					where CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid#">
				</cfquery>
				
				<cfquery name="insert" datasource="#session.DSN#">
					insert into RHLiqIngresosPrev (RHPLPid, DEid, CIid, Ecodigo, RHLPdescripcion, importe, BMUsucodigo, fechaalta, cesantia, motivoliq, RHLIFiniquito)
					select RHPLPid, DEid,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid#">,
						Ecodigo,
						'#rs_incidencia.CIcodigo# ( Pago de intereses para cesantia acumulada )',
						0,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						1,
						<cfqueryparam cfsqltype="cf_sql_char" value="#form.motivo#">,
						<cfif isdefined('form.esFiniquito')>1<cfelse>0</cfif>
					from RHPreLiquidacionPersonal
					where RHPLPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPLPid#">
				</cfquery>
			</cftransaction>
			
			<cftransaction>
				<cfinvoke component="rh.Componentes.RH_Cesantia" method="liquidacion" returnvariable="rs_calculado">
					<cfinvokeargument name="DEid" value="#form.DEid#">
					<cfinvokeargument name="tipo" value="#form.motivo#">
				</cfinvoke>
				<cftransaction action="rollback" />
			</cftransaction>
			
            
            
			<cfquery datasource="#session.DSN#">
				update RHLiqIngresosPrev
				set importe = <cfif len(trim(rs_calculado.monto_total))><cfqueryparam cfsqltype="cf_sql_money" value="#rs_calculado.intereses#"><cfelse>0</cfif>
				where RHPLPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPLPid#">
				and cesantia = 1
			</cfquery>
			<cfquery name="rsLiqIng"datasource="#session.DSN#">
				select RHLPPid
				from RHLiqIngresosPrev
				where RHPLPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPLPid#">
				and cesantia = 1
			</cfquery>
			<cfloop query="rsLiqIng">
				<cfinvoke component="rh.Componentes.RHLiquidacionMXPrev" method="fnCalculaEG">
					<cfinvokeargument name="RHLPid" value="#rsLiqIng.RHLPid#">
				</cfinvoke>
			</cfloop>
            		
		<cfelseif isdefined("form.btnRecalcular")>
<!---        ljimenez quitar el boton de recalcular--->
	
			<!--- 	Lee tabla de recalculo, si hay registros los recalcula.
					Los conceptos en esta tabla deben estar en la liquidacion, 
					si no no se toman en cuenta
			--->
			<cfquery name="rs_recalcular" datasource="#session.DSN#">
				select CIidrecalculo, CIidresultado
				from RHLiqRecalcular
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and CIidrecalculo in (  select CIid
										from RHLiqIngresosPrev
										where RHPLPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPLPid#">
										  and RHLPautomatico = 1 )
				<!---- 	se ordena por el concepto donde se guarda el resultado, 
						para poder acumular si los conceptos de recalculo tienen 
						el mismo concepto destino --->
				order by CIidresultado		
			</cfquery>
            
			<!--- si hay datos para recalcular recupera informacion de la liquidacion y empleado --->
			<cfif rs_recalcular.recordcount gt 0 >
				<!--- recupera datos de la accion de personal aplicada--->
				<cfquery name="rs_vigencia" datasource="#session.DSN#">
					select DLfvigencia, RHTid,<cf_dbfunction name="dateadd"	args="-1, DLfvigencia,DD"> as fecha
					from DLaboralesEmpleado
					where DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DLlinea#">
				</cfquery>
				
				<!--- fecha de vigencia de la accion de cese --->
				<cfset vigencia = rs_vigencia.DLfvigencia >
				<!--- para consultar dato sde la linea del tiempo, debe restarse un dia a la vigencia, pues la LT corta en un dia antes a la vigencia --->
				<cfset vigencia_lt = dateadd('d', -1, vigencia) >
				<!--- la calculadora debe invocarse con las fechas en formato dd/mm/yyyy --->
				<cfset FVigencia = LSdateFormat(vigencia, 'dd/mm/yyyy')>
				<!---<cfset FFin = '01/01/6100'>--->
				<cfset FFin= LSdateFormat(rs_vigencia.fecha,'dd/mm/yyyy')>
				
				<!--- Jornada del empleado cesado. Debe consultar con fecha de vigencia menos un dia, por corte en la lt --->
				<cfquery name="rs_empleadolt" datasource="#session.DSN#">
					select RHJid
					from LineaTiempo
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#" >
					and <cfqueryparam cfsqltype="cf_sql_date" value="#vigencia_lt#"> between LTdesde and LThasta
				</cfquery>
				<cfset RH_Calculadora = createobject("component","rh.Componentes.RH_Calculadora")>
			</cfif>

			<!--- procesa cada concepto de recalculo --->
			<cfset vresultado = '' >
			<cfset vresultado_anterior = '' >
			<cfset vCIid_insertado = '' >
			<cfloop query="rs_recalcular">
 					<cfset vresultado = rs_recalcular.CIidresultado >
					<!--- validacion: el concepto definido en el parametro 1040, debe ser parte de la liquidacion --->
					<cfquery name="rs_calculado" datasource="#session.DSN#">
						select coalesce(importe, 0) as importe
						from RHLiqIngresos
						where DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DLlinea#">
						  and RHLPautomatico = 1
						  and CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_recalcular.CIidrecalculo#">
					</cfquery>
				
					<!--- si hay n conceptos por recalcular y los resultados de cada uno se guardan en el mismo concepto de pago 
						  (que sera insertado en la liquidacion o ya se inserto) debe ir acumulando los montos.
						  Si no es el caso, borra el recalculo hecho, para volverlo a hacer --->
					<cfif vresultado neq vresultado_anterior>
						<!---- 	elimina recalculo si ya antes se habia realizado, esto evita que por cada recalculo se genere un registro y empieze
								a llenarse la liquidacion de informacion inconsistente--->
						<cfquery datasource="#session.DSN#">
							delete RHLiqIngresos
							where DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DLlinea#">
							  and CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_recalcular.CIidresultado#">
						</cfquery>
					</cfif>
					
					<!--- datos del concepto --->
					<cfquery name="rsConceptos" datasource="#session.DSN#">
						select CIcalculo, CIcantidad, CIrango, b.CItipo, CIdia, CImes
						from CIncidentes a, CIncidentesD b
						where b.CIid=a.CIid
						  and a.CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_recalcular.CIidrecalculo#">
						  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					</cfquery>
					
					<!--- hace recalculo del cese --->
					<cfset current_formulas = rsConceptos.CIcalculo>
					<cfset presets_text = RH_Calculadora.get_presets(CreateDate(ListGetAt(FVigencia,3,'/'), ListGetAt(FVigencia,2,'/'), ListGetAt(FVigencia,1,'/')),
												   CreateDate(ListGetAt(FFin,3,'/'), ListGetAt(FFin,2,'/'), ListGetAt(FFin,1,'/')),
												   rsConceptos.CIcantidad,
												   rsConceptos.CIrango,
												   rsConceptos.CItipo,
												   form.DEid,
												   rs_empleadolt.RHJid,
												   session.Ecodigo,
												   rs_vigencia.RHTid,
												   form.DLlinea,
												   rsConceptos.CIdia,
												   rsConceptos.CImes,
												   "", <!--- Tcodigo solo se requiere si no va RHAlinea--->
												   FindNoCase('SalarioPromedio', current_formulas), <!--- optimizacion - SalarioPromedio es el calculo más pesado--->
												   'false',
												   '',
												   FindNoCase('DiasRealesCalculoNomina', current_formulas), <!--- optimizacion - DiasRealesCalculoNomina es el segundo calculo mas pesado--->
												   0,
												   'DLaboralesEmpleado'
												   )>
					<cfset values = RH_Calculadora.calculate( presets_text & ";" & current_formulas )>
					<cfset calc_error = RH_Calculadora.getCalc_error()>
					<cfif Not IsDefined("values")>
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="LB_NoEsPosibleRealizarElCalculo"
						Default="No Es Posible Realizar El C&aacute;lculo"
						returnvariable="LB_NoEsPosibleRealizarElCalculo"/> 
						
						<cfif isdefined("presets_text")>
							<cf_throw message="#LB_NoEsPosibleRealizarElCalculo#<br>#presets_text# &nbsp;----&nbsp;#current_formulas#&nbsp;-----&nbsp;#calc_error#" errorCode="1000">
						<cfelse>
							<cf_throw message="#LB_NoEsPosibleRealizarElCalculo#<br>#calc_error#" errorCode="1000">
						</cfif>
					</cfif>
					 
					 <!---Calcula Excento y Grabados--->
					 <cfif rsConceptos.CIlimitesConcepto eq 1 and rsConceptos.CItipometodo eq 4>
						<!--- MEX - Salario minimo general zona A (SMGA) (mexico) --->
					 	<cfinvoke component="rh.Componentes.RHLiquidacionMX" method="getDato" returnvariable="rsSMGA">
							<cfinvokeargument name="Pcodigo" value="2024">
						</cfinvoke>
						<cfif rsSMGA.recordcount eq 0 or len(trim(rsSMGA.Pvalor)) eq 0>
							<cfthrow message="No se ha definido el parametro 2024, MEX - Salario minimo general zona A (SMGA) (mexico). Proceso Cancelado!!!">
						</cfif>
						<cfset lvarMontoLimite = rsConceptos.CImontolimite * rsSMGA.Pvalor>
					</cfif>
					 
					<!--- recupera el monto calculado, cuando se aplico la accion de cese --->
					<cfset vmonto_origen = rs_calculado.importe >
					<cfset vdiferencia = values.get('resultado').toString() - vmonto_origen>
				
					<!--- inserta concepto de pago con diferencia que debe agregada a la liquidacion --->
					<cfinvoke component="sif.Componentes.Translate"
							  method="Translate"
							  Key="LB_RecalculoEnLiquidacion"
							  Default="Recalculo de liquidación"
							  XmlFile="/rh/generales.xml"
							  returnvariable="vrecalculo"/>
				
					<!--- si hay n conceptos por recalcular y los resultados de cada uno se guardan en el mismo concepto de pago 
						  debe ir acumulando los montos. Si no es el caso, inserta el recalculo realizado --->
					<cfif vresultado neq vresultado_anterior>
						<cftransaction>
						<cfquery name="insertar" datasource="#session.DSN#" >
							insert into RHLiqIngresos( 	DLlinea, 
														DEid, 
														CIid, 
														Ecodigo, 
														RHLPdescripcion, 
														importe, 
														fechaalta, 
														RHLPautomatico, 
														BMUsucodigo,
														RHLIFiniquito
							values( <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DLlinea#">,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_recalcular.CIidresultado#">,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#vrecalculo#">,
									<cfqueryparam cfsqltype="cf_sql_money" value="#vdiferencia#">,
									<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
									0,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">,
									<cfif isdefined('form.esFiniquito')>1<cfelse>0</cfif>)	
							  <cf_dbidentity1 datasource="#session.DSN#">
						</cfquery>
						<cf_dbidentity2 datasource="#session.DSN#" name="insertar">
						<cfset vCIid_insertado = insertar.identity >
						<cfinvoke component="rh.Componentes.RHLiquidacionMX" method="fnCalculaEG">
							<cfinvokeargument name="RHLPid" value="#vCIid_insertado#">
						</cfinvoke>
						</cftransaction>
					<cfelse>
						<cfif len(trim(vCIid_insertado))>
							<cftransaction>
								<cfquery datasource="#session.DSN#">
									update RHLiqIngresos
									set importe = importe + <cfqueryparam cfsqltype="cf_sql_money" value="#vdiferencia#">
									where RHLPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vCIid_insertado#">
								</cfquery>
								<cfinvoke component="rh.Componentes.RHLiquidacionMX" method="fnCalculaEG">
									<cfinvokeargument name="RHLPid" value="#vCIid_insertado#">
								</cfinvoke>
							</cftransaction>
						</cfif>
					</cfif>	
 					<cfset vresultado_anterior = rs_recalcular.CIidresultado >
			</cfloop>        
	</cfif>        
	</cfif>