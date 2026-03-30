<cfcomponent>
	<cffunction name="CargaPatronOficina" access="public" output="true" >
		<cfargument name="conexion" type="string" 	required="no" default="#Session.DSN#">
		<cfargument name="Ecodigo" 	type="numeric" 	required="yes">
		<cfargument name="RCNid"   	type="numeric" 	required="yes">
		<cfargument name="RCdesde" 	type="date" 	required="yes">
		<cfargument name="RChasta" 	type="date" 	required="yes">
		<cfargument name="Prioridad"	type="numeric" 	required="yes">
        <cfargument name="vSMGA" 	type="numeric" 	required="yes">
    	<cfargument name="pDEid" 	type="numeric"	required="no" 	hint="Id Interno del Empleado">
		<cfargument name="vUMA" 	type="numeric"	required="yes">
		<cfargument name="rsPagos"  type="query"    required="yes">
		<cfargument name="FactorDiasIMSS"  type="numeric"    required="yes">

		<cfinvoke component="RHParametros" method="get" datasource="#session.dsn#"
				ecodigo="#session.Ecodigo#" pvalor="80" default="0" returnvariable="vMensual"/>

		<cfloop query="rsPagos">

			<!--- Obtenemos la ultima fecha de nombramiento para calcular antiguedad--->
			<cfquery name="rsFechaAlta" datasource="#session.dsn#">
				select top 1 dle.DLfvigencia,Tcodigo from DLaboralesEmpleado dle inner join RHTipoAccion ta
				on ta.RHTid = dle.RHTid and RHTcomportam = 1
				and dle.DEid = #DEid#
				order by dle.DLfvigencia desc
			</cfquery>

			<!---SML. Modificacion para que se tengan los anios correctos para el calculo del SDI de acuerdo a la fecha de Alta--->
			<cfset anno = DateDiff('yyyy', rsFechaAlta.DLfvigencia, now())>

			<!--- Inicia proceso de calculo de SDI por sueldo para cada pago --->
			<cfquery datasource="#session.dsn#" name="rsDias">
				select coalesce(dv.DRVdiasgratifica,0) as DRVdiasgratifica, coalesce(dv.DRVdiasprima,0) as DRVdiasprima, dv.DRVdias
				from RegimenVacaciones r
					inner join 	DRegimenVacaciones dv
						on r.RVid = dv.RVid
						and dv.DRVcant = <!---SML. Inicio Modificacion para que se tengan los anios correctos para el calculo del SDI de acuerdo a la fecha de Alta--->
						(select coalesce(max(DRVcant),1)
	                                      from DRegimenVacaciones rv2
	                                      where rv2.RVid = dv.RVid
	                                      	and rv2.DRVcant <= <cfqueryparam cfsqltype="cf_sql_integer" value="#anno+1#"> )
	                                    <!---SML. Fin Modificacion para que se tengan los anios correctos para el calculo del SDI de acuerdo a la fecha de Alta---> <!---(select min(DRVcant) from DRegimenVacaciones a where a.RVid =  dv.RVid)--->
				where r.Ecodigo = #session.Ecodigo#
					and r.RVid = #RVid#
			</cfquery>
			<cfif not len(trim(rsDias.DRVdiasgratifica)) or not len(trim(rsDias.DRVdiasprima))>
	        	<cfthrow message="No existe los detalles de regimen definidos">
	        </cfif>

			<cfset SDItmp = 0>
			<cfinvoke component="RHParametros" method="get" datasource="#session.dsn#"
				ecodigo="#Arguments.Ecodigo#" pvalor="2052" default="0" returnvariable="varDiasAguinaldo"/>


			<cfset DRVdiasgratifica = rsDias.DRVdiasgratifica>
			<cfset DRVdiasprima 	= rsDias.DRVdiasprima>
			<cfset Salario		 	= #Salario#>

			<!---SML. Inicio Modificacion para que realice correctamente el calculo de SDI--->
			<cfset pVacacional		= rsDias.DRVdias * (rsDias.DRVdiasprima/100)>
	        <cfset factorDias = ((365 + #varDiasAguinaldo# + #pVacacional#)/365)><!--- Factor de Integracion --->
	        <cfset salarioDiario = (#Salario# / #vMensual#)>
			<cfset unSDI = (#salarioDiario# * #factorDias#)>


			<cfinvoke component="RHParametros" method="get" datasource="#session.dsn#"
			ecodigo="#session.Ecodigo#" pvalor="2051" default="0" returnvariable="varUMA"/>

			<cfset topeUMA = varUMA * 25>

			<cfif unSDI GT  topeUMA>
				<cfset SDItmp = topeUMA>
			<cfelse>
				<cfset SDItmp = unSDI>
			</cfif>

			<cfquery name="rsSDIH" datasource="#session.dsn#">
				select top 1
					RHHmonto
				from RHHistoricoSDI
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
				order by RHHperiodo desc,RHHmes desc
			</cfquery>
			<cfif rsSDIH.RecordCount gt 0 and rsSDIH.RHHmonto gt 0>
				<cfset SDItmp = rsSDIH.RHHmonto>
			</cfif>

			<cfset dbc = DateDiff("d",(DateCompare(LTdesde,Arguments.RCdesde,'d') eq -1 ? Arguments.RCdesde : LTdesde),
				(((DateCompare(LThasta,'6100-01-01 00:00:00.000','d') eq 0) or (DateCompare(LThasta,Arguments.RChasta,'d') eq 1)) ? Arguments.RChasta : LThasta))>
			<cfset dbc += 1>
			
			<cfset diasIncap = 0>
			<cfquery name="rsPagoEmpleado" datasource="#session.dsn#">
				SELECT 
					coalesce(sum(PEcantdias),0) PEcantdias 
				FROM 
					PagosEmpleado pe
				inner join RHTipoAccion ta
					on ta.RHTid = pe.RHTid
					and ta.RHTcomportam = 5 <!--- INCAPACIDADES --->
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
				and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
			</cfquery>
			<cfif rsPagoEmpleado.RecordCount gt 0>
				<cfset diasIncap = rsPagoEmpleado.PEcantdias>
			</cfif>

			<!--- OPARRALES 2019-01-08 Modificacion para reasignar los Dias Base de Cotizacion por Parametro 14600704 --->

			<cfquery name="rsCargasSemXMes" datasource="#session.dsn#">
				select
					Pvalor
				from
					RHParametros
				where
					Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="14600704">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			</cfquery>

			<cfset totDiasFalta = 0>
			<cfquery name="rsAusentismosEmpleado" datasource="#session.dsn#">
				SELECT 
					case
						when Coalesce(ta.RHTIncluirFactorNomina,0) = 1
							then (coalesce(ta.RHTfactorfalta,1) * coalesce(sum(PEcantdias),0))  
						else coalesce(sum(PEcantdias),0)
					end AS PEcantdias 
				FROM 
					PagosEmpleado pe
				inner join RHTipoAccion ta
					on ta.RHTid = pe.RHTid
					and ta.RHTcomportam = 13 <!--- AUSENTISMOS --->
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
				and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
				group by ta.RHTIncluirFactorNomina,ta.RHTfactorfalta
			</cfquery>
			<cfif rsAusentismosEmpleado.RecordCount gt 0>
				<cfset totDiasFalta = rsAusentismosEmpleado.PEcantdias>
			</cfif>

			<!--- OPARRALES 2018-01-13
				- Se agrega validacion para buscar empleados dados de alta despues de la fecha inicio del calendario de pago
				- Si existen empleados se saca los dias trabajados de fecha de alta vs Fecha fin de pago
			 --->
			<cfquery name="rsLTAlta" datasource="#session.dsn#">
				select top 1 lt.LTdesde from LineaTiempo lt
				inner join RHTipoAccion ta
					on ta.RHTid = lt.RHTid
					and ta.Ecodigo = lt.Ecodigo
				where
					lt.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
				and lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				and ta.RHTcomportam = 1 <!--- Accion de Tipo Nombramiento --->
				and lt.LTdesde
					between <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.RCdesde#">
					and <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.RChasta#">
				AND lt.BMUsucodigo is not null
				order by lt.LTdesde desc
			</cfquery>

			<cfset varDiasTemp = 7>
			<cfif rsLTAlta.RecordCount gt 0>
				<cfset dbc = (DateDiff("d",rsLTAlta.LTdesde,Arguments.RChasta) + 1)>
				<cfset varDiasTemp = dbc>
			</cfif>
			
			<cfif rsCargasSemXMes.RecordCount gt 0 and rsCargasSemXMes.Pvalor eq 1 and varDiasTemp lte 7>
				<cfquery name="rsCP" datasource="#session.dsn#">
					select Tcodigo, CPmes , CPperiodo
					from CalendarioPagos
					where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				</cfquery>

				<cfquery name="rsPeriodos" datasource="#session.dsn#">
					select Count(CPid) as NumPeriodos
					from CalendarioPagos
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					and CPmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCP.CPmes#">
					and Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCP.Tcodigo#">
					and CPperiodo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCP.CPperiodo#">
					and CPtipo = 0
				</cfquery>
				
				<!--- Obtenemos semanas por Mes --->
				<cfset diasMes = DaysInMonth(Arguments.RChasta)>
				<cfset varDBC = (diasMes / rsPeriodos.NumPeriodos) - (7 - varDiasTemp)>
				<cfset dbc = varDBC>
			<cfelse>
				<cfset varDiasP = 0>
				<cfif rsLTAlta.RecordCount gt 0>
					<cfset varDiasP = (DateDiff("d",Arguments.RCdesde,Arguments.RChasta) + 1) - (DateDiff("d",rsLTAlta.LTdesde,Arguments.RChasta) + 1)>
				</cfif>
				<cfset dbc = Arguments.FactorDiasIMSS - varDiasP>
			</cfif>

			<!--- OPARRALES Modificacion para empleados cesados dentro del periodo de calculo --->
			<cfquery name="rsDiasLab" datasource="#session.dsn#">
				select top 1
					ta.RHTcomportam,
					ta.RHTdesc,
					DATEDIFf(DAY,dle.DLfvigencia,'#LSDateFormat(Arguments.RChasta,"YYYY-MM-dd")#') diasSinTrabajar
				from DLaboralesEmpleado dle
				inner join RHTipoAccion ta
					on ta.RHTid = dle.RHTid
					and ta.RHTcomportam = 2 <!--- Bajas/Finiquitos --->
					and ta.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				Where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPagos.DEid#">
				AND dle.DLfvigencia between '#LSDateFormat(Arguments.RCdesde,"YYYY-MM-dd")#' and '#LSDateFormat(Arguments.RChasta,"YYYY-MM-dd")#'
				order by DLfvigencia desc
			</cfquery>

			<cfif rsDiasLab.RecordCount gt 0 and rsDiasLab.diasSinTrabajar gt 0>
				<cfset dbc -= rsDiasLab.diasSinTrabajar>
			</cfif>
			
			<cfquery name="rsTipoPago" datasource="#session.dsn#">
				select 
					Ttipopago
				from 
					TiposNomina 
				where 
					Tcodigo = '#Trim(rsFechaAlta.Tcodigo)#'
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			</cfquery>

			<cfif rsTipoPago.Ttipopago eq 2 and dbc lt Arguments.FactorDiasIMSS><!--- quincenal --->
				<cfset dbc += 0>
			</cfif>

			<!--- Buscamos las Incidencias de Faltas con el codigo 04 --->
			<cfquery name="rsFaltas" datasource="#session.dsn#">
				select
					CIid
				from
					CIncidentes
				where CIcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="04">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			</cfquery>

			<cfset varDiasFalta = 0>
			<cfif rsFaltas.RecordCount gt 0>
				<cfset varIdsC = Valuelist(rsFaltas.CIId,",") >

				<cfquery name="rsHrsD" datasource="#session.dsn#">
					select
						RHJhoradiaria
					from
						RHJornadas
					where RHJId =
								(
									select top 1 RHJid from LineaTiempo
									where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
									order by LThasta desc
								)
				</cfquery>

				<cfset varHrsDia = rsHrsD.RHJhoradiaria>

				<cfquery name="rsIncCalc" datasource="#session.dsn#">
					select
						ICvalor
					from
						IncidenciasCalculo
					where
						RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
					and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
					and CIId in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#varIdsC#" list="true">)
				</cfquery>
				
				<cfset tmpDias = 0>

				<cfloop query="rsIncCalc">
					<cfset tmpDias += (ICvalor / varHrsDia)>
				</cfloop>
				<cfset dbc -= tmpDias>
			</cfif>

			<!--- <cfif DEid eq 68>
				<cfdump  var="((#SDItmp#) * (#dbc# - #totDiasFalta# - #diasIncap#))" abort>
			</cfif> --->
	        <cfquery datasource="#Arguments.conexion#">
	           update CargasCalculo
	            set	CCvalorpat +=
	            coalesce((select
	                case
	                    when DCmetodo = 0
	                        then coalesce(co.CEvalorpat,coalesce(b.CEvalorpat, c.DCvalorpat))

	                    when DCmetodo = 1 and coalesce(ECSalarioBaseC,0) = 0 and coalesce(DCdisminuyeSBC,0) = 0
	                        then round((CargasCalculo.CCSalarioBase) * ((coalesce(co.CEvalorpat,coalesce(b.CEvalorpat, c.DCvalorpat)))/100), 2)

	                    when DCmetodo = 1
	                            and coalesce(ECSalarioBaseC,0) = 1
	                            and coalesce(DCdisminuyeSBC,0) = 0
	                            and coalesce(DCusaSMGA,0) = 0
	                        then<!--- Cambios OPARALES Inicio 16/05/2017 --->
								case
									when coalesce(DCUsaUMA,0) = 1 and coalesce(DCEsExcedente,0) = 1 AND Coalesce(DCConsideraFaltas,0) = 1
										then
											case when #SDItmp# > (#vUMA# * 3)
												then
												<!--- EXCEDENTES --->
													round(((#SDItmp# - (#vUMA# * 3))*(#dbc# - #diasIncap# - #totDiasFalta# ))* (coalesce(b.CEvalorpat, c.DCvalorpat)/100),2)
												<!--- round(((CargasCalculo.CCSalarioBaseCotizacion) * CargasCalculo.CCdbc) * ((coalesce(b.CEvaloremp, c.DCvaloremp))/100), 2) --->
												else
													0
											end
									when coalesce(DCUsaUMA,0) = 1 and coalesce(DCEsExcedente,0) = 1
										then
											case when #SDItmp# > (#vUMA# * 3)
												then
												<!--- EXCEDENTES --->
													round(((#SDItmp# - (#vUMA# * 3))*(#dbc# - #diasIncap# ))* (coalesce(b.CEvalorpat, c.DCvalorpat)/100),2)
												<!--- round(((CargasCalculo.CCSalarioBaseCotizacion) * CargasCalculo.CCdbc) * ((coalesce(b.CEvaloremp, c.DCvaloremp))/100), 2) --->
												else
													0
											end
										else
											<!--- 2019-01-08 OPARRALES
												  Aqui entra:
													- 04 invalidez y vida solo para empleado
													- 06 Riesgo de Trabajo
													- 08 Cesantia y vejez solo empleado
													- 09 Retiro
													- 10 Infonavit
											 --->
											<!--- Aqui realiza los demas calculos. --->
											case
												when DCdbc = 1
													then
														round(((#SDItmp#) * (#dbc# - #totDiasFalta# - #diasIncap#)) * ((coalesce(co.CEvalorpat,coalesce(b.CEvalorpat, c.DCvalorpat)))/100), 2)
												when DCdbc = 2
													then
														round(((#SDItmp#) * (#dbc# - #diasIncap#)) * ((coalesce(co.CEvalorpat,coalesce(b.CEvalorpat, c.DCvalorpat)))/100), 2)
												else <!--- DCdbc = 3 --->
													round(((#SDItmp#) * (#dbc# - #totDiasFalta#)) * ((coalesce(co.CEvalorpat,coalesce(b.CEvalorpat, c.DCvalorpat)))/100), 2)
											end
									end
							<!--- Cambios OPARRALES Fin --->

	                    when DCmetodo = 1
	                            and coalesce(ECSalarioBaseC,0) = 1
	                            and coalesce(DCdisminuyeSBC,0) = 0
	                            and coalesce(DCusaSMGA,0) = 1
	                        then round(((#Arguments.vSMGA#) * #dbc#) * ((coalesce(co.CEvalorpat,coalesce(b.CEvalorpat, c.DCvalorpat)))/100), 2)

	                    when DCmetodo = 1
	                                and coalesce(ECSalarioBaseC,0) = 1
	                                and coalesce(DCdisminuyeSBC,0) = 1
	                                and coalesce(DCusaSMGA,0) = 1
	                            then
	                                case
	                                    when (round(((#SDItmp# - (#Arguments.vSMGA# * 3)) * #dbc#) * ((coalesce(co.CEvalorpat,coalesce(b.CEvalorpat, c.DCvalorpat)))/100), 2) < 0)
	                                    then 0
	                                else round(((#SDItmp# - (#Arguments.vSMGA# * 3)) * #dbc#) * ((coalesce(co.CEvalorpat,coalesce(b.CEvalorpat, c.DCvalorpat)))/100), 2)
	                            end
	                     when DCmetodo = 2
	                                and coalesce(ECSalarioBaseC,0) = 1
	                                and coalesce(DCdisminuyeSBC,0) = 0
	                                and coalesce(DCusaSMGA,0) = 1
									<!--- oparrales se cambio vSMGA por UMA 16/05/2017 --->
	                            then round(((#Arguments.vUMA#) * (#dbc# - #diasIncap# - case when Coalesce(DCConsideraFaltas,0) = 1 then #totDiasFalta# else 0 end)) * ((coalesce(co.CEvalorpat,coalesce(b.CEvalorpat, c.DCvalorpat)))/100), 2)
	                end
	            from CargasEmpleado b
	            inner join DCargas c
	            	on c.DClinea = b.DClinea
	            	and b.DEid = #DEid#
					and CargasCalculo.DEid = #DEid#
					<!--- and b.DEid = CargasCalculo.DEid --->
					and c.DClinea = CargasCalculo.DClinea
					and coalesce(b.CEhasta,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(6100,01,01)#">) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.RCdesde#">
	            inner join ECargas d
	            	on d.ECid = c.ECid
	            inner join LineaTiempo l
	            	on l.DEid=b.DEid
	            left join CargasOficina co
	                on l.Ocodigo = co.Ocodigo
	                and l.Ecodigo=co.Ecodigo
	                and b.DClinea=co.DClinea

	            where b.DEid = #DEid#
					and CargasCalculo.DEid = #DEid#
	            	<!--- b.DEid = CargasCalculo.DEid --->
	              and b.DClinea = CargasCalculo.DClinea
	              and b.CEdesde <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.RChasta#">
	              and coalesce(b.CEhasta,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(6100,01,01)#">) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.RCdesde#">
	              and c.DClinea = CargasCalculo.DClinea
				  and l.LThasta = <!--- <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(6100,01,01)#"> --->
				  	(case when l.LThasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(6100,01,01)#"> then
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(6100,01,01)#">
					else
				  		<!--- OPARRALES Modificacion para contemple las cargas patronales de empleados finiquitados --->
						(select top 1 LThasta from LineaTiempo where DEid = CargasCalculo.DEid order by LThasta desc)
					end)
	            ), 0)
	            where CargasCalculo.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
				  <cfif IsDefined('Arguments.pDEid')>
	                and CargasCalculo.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#">
	              </cfif>
	              <cfif Arguments.Prioridad GT 0>
	                  and exists(
	                    select 1
	                    from DCargas a
	                        inner join ECargas b
	                             on b.ECid = a.ECid
	                            and b.ECprioridad = #Arguments.Prioridad#
	                    where a.DClinea = CargasCalculo.DClinea
	                    )
	              </cfif>
	              and exists(
	              select 1
	              from CargasEmpleado b, DCargas c, ECargas d
	                where b.DEid = #DEid#
					and CargasCalculo.DEid = #DEid#
	              and b.DClinea = CargasCalculo.DClinea
	              and b.CEdesde <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.RChasta#">
	              and c.DClinea = CargasCalculo.DClinea
	              and coalesce(b.CEhasta,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(6100,01,01)#">) >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.RCdesde#">
	              and d.ECid = c.ECid)
	              and (CargasCalculo.CCSalarioBase > 0.00 or (CargasCalculo.CCsalarioBase = 0.00 and CargasCalculo.CCdbc >0))
				<!--- OPARRALES modificacion para que calcule Infonavit y Retiro cuando es por incapacidad --->
	        </cfquery>
		</cfloop>
		<cfreturn>
	</cffunction>
</cfcomponent>