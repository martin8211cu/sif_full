<cfcomponent>
	
	
	<!---Proceso consiste en:
		1.Proceso Base: que toma los datos de F_Datos como lo indican las metricas definidad en el sistema, y los coloca en F_Resultados con tipo 'N'
		2.Calculo Metrica: toma los datos de F_resultados en tipo 'N' si posee formula calcula la formula y si no posee le pone el valor que en encuentre 
			en F_resultados tipo 'N' para la metrica, e ingresa u actializa el valor en F_resultados, y lo pone en tipo 'S', genera una limpieza de para los tipo 'N' 
		3. Calculo Indicador: busca los indicadores definidos ordenandolos por secuencia de calculo, identifica los valores a usar en su formula por medio de los filtros 
			definidos en el tab de filtros metricas, de ahi se realizan los calculos, de las formulas.
	--->
	
	<cffunction name="getPorCalcular" access="remote" returntype="string">
		<cfargument name="MIGMID" 			type="numeric" required="no" default="0">
		<cfargument name="Periodo" 			type="string" required="no" default="">
		<cfargument name="Pinicio" 			type="string" required="no" default=""><!---fechas de periocidad inicio--->
		<cfargument name="Pfin" 			type="string" required="no" default=""><!---fechas de periocidad hasta--->
		<cfargument name="todos" 			type="boolean" required="no" default="false">
		<cfargument name="CEcodigo" 		type="numeric" default="#session.CEcodigo#">
		<cfargument name="Ecodigo" 			type="numeric" default="#session.Ecodigo#">
		<cfargument name="DSN" 				type="string"	default="#session.DSN#">
		<cfargument name="listaDetalleIds" 	type="string"	default="">
		<cfargument name="listPeriodos" 	type="string"	default="">
		<cfargument name="Tipo" 			type="string"	default="N">
		
			<cfset msj = ''>

			<cf_dbfunction2 name="OP_concat"	returnvariable="_Cat">
			
			<!---Metricas calculadas para el periodo actual--->
			<cfquery name="rsPorCalcular" datasource="#session.DSN#">
					select distinct a.MIGMid,a.periodo,a.resultado from F_Resultados a
					where a.TIPO = '#Arguments.Tipo#'
					<cfif not len(trim(Arguments.Periodo)) and not len(trim(Arguments.Pinicio)) and not todos><!---periodo actual--->
						and a.Periodo = (select case b.MIGMperiodicidad
											when 'D' then <cf_dbfunction2 name="date_format" args="#now()#,YYYYDY">
											when 'W' then <cf_dbfunction2 name="date_format" args="#now()#,YYYYWK">
											when 'M' then <cf_dbfunction2 name="date_format" args="#now()#,YYYYMM">
											when 'T' then <cf_dbfunction2 name="date_format" args="#now()#,YYYYQQ">
											when 'A' then <cf_dbfunction2 name="date_format" args="#now()#,YYYY">#_Cat#'00'
											when 'S' then 
												case when <cf_dbfunction2 name="date_part" args="QQ,#now()#"> < 2 then
														  <cf_dbfunction2 name="date_format" args="#now()#,YYYY">#_Cat#'01'
												else
														  <cf_dbfunction2 name="date_format" args="#now()#,YYYY">#_Cat#'02'
												end
										end as pPeriodo
										from MIGMetricas b
										where b.MIGMid=a.MIGMid)
						
					</cfif>
						
					<cfif len(trim(Arguments.Periodo))>		<!---periodo definido--->
					and a.Periodo = #Arguments.Periodo#
					</cfif>
					
					<cfif isdefined('listPeriodos') and len(trim(listPeriodos))><!---rango de periodos--->
						and a.Periodo in (<cfqueryparam  list="yes" cfsqltype="cf_sql_integer" value="#listPeriodos#">) 
					</cfif>
					
					and a.MIGMID not in 
						(select distinct a.MIGMid,a.periodo,a.resultado from F_Resultados a
							where a.MIGMid is not null 
							and a.TIPO = '#Arguments.Tipo#'
							<cfif not len(trim(Arguments.Periodo)) and not len(trim(Arguments.Pinicio)) and not todos><!---periodo actual--->
								and a.Periodo = (select case b.MIGMperiodicidad
													when 'D' then <cf_dbfunction2 name="date_format" args="#now()#,YYYYDY">
													when 'W' then <cf_dbfunction2 name="date_format" args="#now()#,YYYYWK">
													when 'M' then <cf_dbfunction2 name="date_format" args="#now()#,YYYYMM">
													when 'T' then <cf_dbfunction2 name="date_format" args="#now()#,YYYYQQ">
													when 'A' then <cf_dbfunction2 name="date_format" args="#now()#,YYYY">#_Cat#'00'
													when 'S' then 
														case when <cf_dbfunction2 name="date_part" args="QQ,#now()#"> < 2 then
																  <cf_dbfunction2 name="date_format" args="#now()#,YYYY">#_Cat#'01'
														else
																  <cf_dbfunction2 name="date_format" args="#now()#,YYYY">#_Cat#'02'
														end
												end as pPeriodo
												from MIGMetricas b
												where b.MIGMid=a.MIGMid)
								
							</cfif>
								
							<cfif len(trim(Arguments.Periodo))>		<!---periodo definido--->
							and a.Periodo = #Arguments.Periodo#
							</cfif>
							
							<cfif isdefined('Arguments.Ecodigo') and len(trim(Arguments.Ecodigo))>
							and a.Ecodigo = #Arguments.Ecodigo#
							</cfif>
							
							<cfif isdefined('listPeriodos') and len(trim(listPeriodos))><!---rango de periodos--->
								and a.Periodo in (<cfqueryparam  list="yes" cfsqltype="cf_sql_integer" value="#listPeriodos#">) 
							</cfif>
		
							<cfif isdefined('Arguments.MIGMID') and len(trim(Arguments.MIGMID)) and Arguments.MIGMID GT 0>
							and a.MIGMID = #Arguments.MIGMID#
							</cfif>)
					order by a.MIGMid
			</cfquery>
			
			<cfset porCalcular = "">				<!---Lista de Periodos Calculados--->
			<cfif rsPorCalcular.recordCount gt 0>								
				<cfset porCalcular = valueList(rsPorCalcular.MIGMid)>
			</cfif>
			
			<cfif isdefined('porCalcular') and len(trim(porCalcular))>	
				<cfset msj = porCalcular>
			</cfif>
			
			<cfreturn msj>
	</cffunction>
	
	<!------>
	<cffunction name="getCalculados" access="remote" returntype="string">
		<cfargument name="MIGMID" 			type="numeric" required="no" default="0">
		<cfargument name="Periodo" 			type="string" required="no" default="">
		<cfargument name="Pinicio" 			type="string" required="no" default=""><!---fechas de periocidad inicio--->
		<cfargument name="Pfin" 			type="string" required="no" default=""><!---fechas de periocidad hasta--->--->
		<cfargument name="todos" 			type="boolean" required="no" default="false">
		<cfargument name="CEcodigo" 		type="numeric" default="#session.CEcodigo#">
		<cfargument name="Ecodigo" 			type="numeric" default="#session.Ecodigo#">
		<cfargument name="DSN" 				type="string"	default="#session.DSN#">
		<cfargument name="listaDetalleIds" 	type="string"	default="">
		<cfargument name="listPeriodos" 	type="string"	default="">
		<cfargument name="Tipo" 			type="string"	default="N">
		
			<cfset msj = ''>

			<cf_dbfunction2 name="OP_concat"	returnvariable="_Cat">
			
			<!---Metricas calculadas para el periodo actual--->
			<cftry>	
				<cfquery name="rsCalculados" datasource="#session.DSN#">
						select distinct a.MIGMid,a.periodo,a.resultado from F_Resumen a
						where a.TIPO = '#trim(Arguments.Tipo)#'
						<cfif not len(trim(Arguments.Periodo)) and not len(trim(Arguments.Pinicio)) and not todos><!---periodo actual--->
							and a.Periodo = (select case b.MIGMperiodicidad
												when 'D' then <cf_dbfunction2 name="date_format" args="#now()#,YYYYDY">
												when 'W' then <cf_dbfunction2 name="date_format" args="#now()#,YYYYWK">
												when 'M' then <cf_dbfunction2 name="date_format" args="#now()#,YYYYMM">
												when 'T' then <cf_dbfunction2 name="date_format" args="#now()#,YYYYQQ">
												when 'A' then <cf_dbfunction2 name="date_format" args="#now()#,YYYY">#_Cat#'00'
												when 'S' then 
													case when <cf_dbfunction2 name="date_part" args="QQ,#now()#"> < 2 then
															  <cf_dbfunction2 name="date_format" args="#now()#,YYYY">#_Cat#'01'
													else
															  <cf_dbfunction2 name="date_format" args="#now()#,YYYY">#_Cat#'02'
													end
											end as pPeriodo
											from MIGMetricas b
											where b.MIGMid=a.MIGMid)
							
						</cfif>
						
						<cfif len(trim(Arguments.Periodo))>		<!---periodo definido--->
						and a.Periodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Periodo#">
						</cfif>

						
						<cfif isdefined('listPeriodos') and len(trim(listPeriodos))><!---rango de periodos--->
							and a.Periodo in (<cfqueryparam  list="yes" cfsqltype="cf_sql_numeric" value="#listPeriodos#">) 
						</cfif>	
						<cfif isdefined('Arguments.MIGMID') and len(trim(Arguments.MIGMID))>
						and a.MIGMID =#Arguments.MIGMID#
						</cfif>
						
						<cfif isdefined('Arguments.Ecodigo') and len(trim(Arguments.Ecodigo))>
							and a.Ecodigo = #Arguments.Ecodigo#
						</cfif>
						
						order by a.MIGMid
				</cfquery>
			<cfcatch type="any">
				<cfdump var="#cfcatch#"><cfabort>
			</cfcatch>
			</cftry>
			<cfset metCalculadasActual = "">				<!---Lista de Periodos Calculados--->
			<cfif rsCalculados.recordCount gt 0>								
				<cfset metCalculadasActual = valueList(rsCalculados.MIGMid)>
			</cfif>
			<!---<cf_dump var="#listLen(metCalculadasActual)#">--->

			<cfif isdefined('metCalculadasActual') and len(trim(metCalculadasActual))>	
				<cfset msj = metCalculadasActual>
			</cfif>
			
			<cfreturn msj>
	</cffunction>
	
	<!------>
	<cffunction name="getRangoPeriodos" access="remote" returntype="string">
		<cfargument name="MIGMID" 		type="numeric" required="no" default="0">
		<cfargument name="Pinicio" 		type="string" required="no" default=""><!---fechas de periocidad inicio--->
		<cfargument name="Pfin" 		type="string" required="no" default=""><!---fechas de periocidad hasta--->--->
		<cfargument name="CEcodigo" 	type="numeric" default="#session.CEcodigo#">
		<cfargument name="Ecodigo" 		type="numeric" default="#session.Ecodigo#">
		<cfargument name="DSN" 			type="string"	default="#session.DSN#">
		
			<cfset msj = ''>
			<cfset esMetrica = 'M'>
			<cfset tieneFormula = false>
			<cfif isdefined('Arguments.MIGMID') and len(trim(Arguments.MIGMID)) and Arguments.MIGMID GT 0>
				<cfquery name="rsTipo" datasource="#Arguments.DSN#">
					select MIGMesmetrica as esMetrica,MIGMcalculo as formula from MIGMetricas 
					where 1=1
					and MIGMid = #Arguments.MIGMID#
					<cfif isdefined('Arguments.Ecodigo') and len(trim(Arguments.Ecodigo))>
						and Ecodigo = #Arguments.Ecodigo#
					</cfif>
				</cfquery>
				<cfset esMetrica = rsTipo.esMetrica>
				<cfif isdefined('rsTipo.formula') and len(trim(rsTipo.formula)) >
					<cfset tieneFormula = true>
				</cfif>
			</cfif>
			<!---<cf_dump var="#tieneFormula#">--->
			<cfif isdefined('Arguments.Pinicio') and len(trim(Arguments.Pinicio))>	<!---Fecha Inicio--->
				<cfquery name="rsInicio" datasource="#Arguments.DSN#">
					select distinct pfecha from F_Datos 
					where Periodo >= #Arguments.Pinicio#
						<cfif isdefined('Arguments.MIGMID') and len(trim(Arguments.MIGMID)) and Arguments.MIGMID GT 0 and not tieneFormula>
							and MIGMID = #Arguments.MIGMID#
						</cfif>
						<cfif isdefined('Arguments.Ecodigo') and len(trim(Arguments.Ecodigo))>
							and Ecodigo = #Arguments.Ecodigo#
						</cfif>
					order by pfecha ASC
				</cfquery>
				<cfif isdefined('rsInicio.pfecha') and len(trim(rsInicio.pfecha))>
					<cfset finicio = rsInicio.pfecha>
				<cfelse>	
					<cfoutput><center><strong>Periodo de inicio seleccionado, no posee una fecha definida</strong></center></cfoutput>
					<cfabort>
				</cfif>
			</cfif>
			
			<cfif isdefined('Arguments.Pfin') and len(trim(Arguments.Pfin))>	<!---Fecha Fin--->
				<cfquery name="rsFin" datasource="#Arguments.DSN#">
					select distinct pfecha  from F_Datos 
					where Periodo <= #Arguments.Pfin#
					<cfif isdefined('Arguments.MIGMID') and len(trim(Arguments.MIGMID)) and Arguments.MIGMID GT 0 and not tieneFormula>
						and MIGMID = #Arguments.MIGMID#
					</cfif>
					<cfif isdefined('Arguments.Ecodigo') and len(trim(Arguments.Ecodigo))>
						and Ecodigo = #Arguments.Ecodigo#
					</cfif>
					order by pfecha DESC
				</cfquery>
				<cfif isdefined('rsFin.pfecha') and len(trim(rsFin.pfecha))>
					<cfset ffin = rsFin.pfecha>
				<cfelse>	
					<cfoutput><center><strong>Periodo de final seleccionado, no posee una fecha definida</strong></center></cfoutput>
					<cfabort>
				</cfif>
			</cfif>
			
			<!---<cfif isdefined('finicio') and len(trim(finicio))>					<!---Lista de periodos--->
				
				<cfquery name="rsPeriodos" datasource="#Arguments.DSN#">
					select distinct pfecha,periodo from F_Datos 
					where 
						pfecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(finicio,'yyyy-mm')#"/>
					<cfif isdefined('ffin') and len(trim(ffin))>
						and pfecha <=  <cfqueryparam cfsqltype="cf_sql_date" value="#ffin#"/>
					</cfif>
					<cfif isdefined('Arguments.MIGMID') and len(trim(Arguments.MIGMID)) and Arguments.MIGMID GT 0 and esMetrica EQ 'M'>
						and MIGMid = #Arguments.MIGMID#
					</cfif>
					order by pfecha DESC
				</cfquery>
			</cfif>--->
			
			<cfquery name="rsPeriodos" datasource="#Arguments.DSN#">
				select distinct periodo from F_Datos 
				where 1=1
				<cfif isdefined('Arguments.Pinicio') and len(trim(Arguments.Pinicio))>
					and periodo >= #Arguments.Pinicio#
				</cfif>
				<cfif isdefined('Arguments.Pfin') and len(trim(Arguments.Pfin))>
					and periodo <= #Arguments.Pfin#
				</cfif>
				<cfif isdefined('Arguments.MIGMID') and len(trim(Arguments.MIGMID)) and Arguments.MIGMID GT 0 and not tieneFormula> <!---I si es un indicador--->
					and MIGMid = #Arguments.MIGMID#
				</cfif>
				<cfif isdefined('Arguments.Ecodigo') and len(trim(Arguments.Ecodigo))>
					and Ecodigo = #Arguments.Ecodigo#
				</cfif>
				order by periodo DESC
			</cfquery>
			
			<cfif rsPeriodos.recordCount GT 0>	
				<cfset listPeriodos = valueList(rsPeriodos.periodo)>
			</cfif>	
		<!---<cf_dump var="#listPeriodos#">--->
			<cfif isdefined('listPeriodos') and len(trim(listPeriodos))>	
				<cfset msj = listPeriodos>
			</cfif>
			
			<cfreturn msj>
	</cffunction>
	
	<!---FILTROS PARA PARA F_DATOS PARA LAS METRICAS--->
	<cffunction name="getDetailsFiltros" access="remote" returntype="string">
		<cfargument name="MIGMID" 		type="numeric" required="yes">
		<cfargument name="CEcodigo" 	type="numeric" default="#session.CEcodigo#">
		<cfargument name="Ecodigo" 		type="numeric" default="#session.Ecodigo#">
		<cfargument name="DSN" 			type="string"	default="#session.DSN#">
		
			<cfset msj = ''>
			<cfif isdefined('Arguments.MIGMID') and len(trim(Arguments.MIGMID)) and Arguments.MIGMID GT 0><!---Tipo de Detalle por el cual se va a Filtrar--->
				<cfquery name="rsFiltros" datasource="#session.DSN#">
					select count(a.MIGFMid)as hay, b.MIGMtipodetalle as detalle
					from MIGFiltrosmetricas a  
						inner join MIGMetricas b
						on b.MIGMid = a.MIGMid
						and a.Ecodigo = b.Ecodigo
					where a.MIGMid = #Arguments.MIGMID#
					<cfif isdefined('Arguments.Ecodigo') and len(trim(Arguments.Ecodigo))>
					and a.Ecodigo = #Arguments.Ecodigo#
					</cfif>
					group by b.MIGMtipodetalle
				</cfquery>
				
				<cfif rsFiltros.hay GT 0>
					<cfif rsFiltros.detalle is 'D'>
						<cfquery datasource="#session.DSN#" name="rsDatosSelect">
							select a.MIGMdetalleid as id, b.DeptoCodigo as codigo,b.Ddescripcion as descripcion
							from MIGFiltrosmetricas a  
								inner join Departamentos b
								on b.Dcodigo = a.MIGMdetalleid
								and a.Ecodigo = b.Ecodigo
							where MIGMid = #Arguments.MIGMID#
							<cfif isdefined('Arguments.Ecodigo') and len(trim(Arguments.Ecodigo))>
							and a.Ecodigo = #Arguments.Ecodigo#
							</cfif>
						</cfquery>
						<cfset listaDetalleIds= valuelist(rsDatosSelect.id)>
					<cfelseif rsFiltros.detalle is 'C'>
						<cfquery datasource="#session.DSN#" name="rsDatosSelect">
							select a.MIGMdetalleid as id, b.MIGCuecodigo as codigo,b.MIGCuedescripcion as descripcion
							from MIGFiltrosmetricas a  
								inner join MIGCuentas b
								on b.MIGCueid = a.MIGMdetalleid
								and a.Ecodigo = b.Ecodigo
							where MIGMid = #Arguments.MIGMID#
							<cfif isdefined('Arguments.Ecodigo') and len(trim(Arguments.Ecodigo))>
							and a.Ecodigo = #Arguments.Ecodigo#
							</cfif>
						</cfquery>
						<cfset listaDetalleIds= valuelist(rsDatosSelect.id)>
					<cfelseif rsFiltros.detalle is 'P'>
						<cfquery datasource="#session.DSN#" name="rsDatosSelect">
							select a.MIGMdetalleid as id, b.MIGProcodigo as codigo,b.MIGPronombre as descripcion
							from MIGFiltrosmetricas a  
								inner join MIGProductos b
								on b.MIGProid = a.MIGMdetalleid
								and a.Ecodigo = b.Ecodigo
							where MIGMid = #Arguments.MIGMID#
							<cfif isdefined('Arguments.Ecodigo') and len(trim(Arguments.Ecodigo))>
							and a.Ecodigo = #Arguments.Ecodigo#
							</cfif>
						</cfquery>
						<cfset listaDetalleIds= valuelist(rsDatosSelect.id)>
					</cfif>

				</cfif>
			</cfif>
			<cfif isdefined('listaDetalleIds') and len(trim(listaDetalleIds))>	
				<cfset msj = listaDetalleIds>
			</cfif>
			<cfreturn msj>
	</cffunction>
	
	<cffunction name="getDetailsFiltrosIndicadoresDetalles" access="remote" returntype="string">
		<cfargument name="MIGMids" 			type="string" required="yes">
		<cfargument name="MIGMidindicador" 	type="numeric" required="yes">
		<cfargument name="CEcodigo" 		type="numeric" default="#session.CEcodigo#">
		<cfargument name="Ecodigo" 			type="numeric" default="#session.Ecodigo#">
		<cfargument name="DSN" 				type="string"	default="#session.DSN#">
		
		
		<cfloop list="#MIGMids#" index="id">
			<cfset MIGMid_actual = id>
			
			<cfif tipodetalle is 'D'>
				<cfquery datasource="#session.DSN#" name="rsDatosSelect">
					select a.MIGMdetalleid as id, b.DeptoCodigo as codigo,b.Ddescripcion as descripcion,c.MIGMnombre
					from MIGFiltrosindicadores a  
						
						inner join Departamentos b
						on b.Dcodigo = a.MIGMdetalleid
						and a.Ecodigo = b.Ecodigo
						
						inner join MIGMetricas c
						on c.MIGMid = a.MIGMid
						and c.Ecodigo = a.Ecodigo
						
					where MIGMidindicador = #Arguments.MIGMidindicador#
					and a.MIGMid = #MIGMid_actual#
					and a.Ecodigo = #Arguments.Ecodigo#
				</cfquery>
				<cfset listaDetalleIds= valuelist(rsDatosSelect.id)>
			<cfelseif tipodetalle is 'C'>
				<cfquery datasource="#session.DSN#" name="rsDatosSelect">
					select a.MIGMdetalleid as id, b.MIGCuecodigo as codigo,b.MIGCuedescripcion as descripcion,c.MIGMnombre
					from MIGFiltrosindicadores a  
						inner join MIGCuentas b
						on b.MIGCueid = a.MIGMdetalleid
						and a.Ecodigo = b.Ecodigo
						
						inner join MIGMetricas c
						on c.MIGMid = a.MIGMid
						and c.Ecodigo = a.Ecodigo
						
					where a.MIGMidindicador = #form.MIGMID#
					and a.MIGMid = #MIGMid_actual#
					and a.Ecodigo = #session.Ecodigo#
				</cfquery>
				<cfset listaDetalleIds= valuelist(rsDatosSelect.id)>
			<cfelseif tipodetalle is 'P'>
				<cfquery datasource="#session.DSN#" name="rsDatosSelect">
					select a.MIGMdetalleid as id, b.MIGProcodigo as codigo,b.MIGPronombre as descripcion,c.MIGMnombre
					from MIGFiltrosindicadores a  
						inner join MIGProductos b
						on b.MIGProid = a.MIGMdetalleid
						and a.Ecodigo = b.Ecodigo
					
					inner join MIGMetricas c
						on c.MIGMid = a.MIGMid
						and c.Ecodigo = a.Ecodigo
						
					where MIGMidindicador = #form.MIGMID#
					and a.MIGMid = #MIGMid_actual#
					and a.Ecodigo = #session.Ecodigo#
				</cfquery>
				<cfset listaDetalleIds= valuelist(rsDatosSelect.id)>
			</cfif>
			<cfloop query="rsDatosSelect">
				<tr><td>#rsDatosSelect.codigo#-#rsDatosSelect.descripcion#</td>
				<td><img src="../imagenes/Borrar01_S.gif" onclick="javascript: BorrarDetalle(#form.MIGMID#,#rsDatosSelect.id#,#MIGMid_actual#)"/></td>
				</tr>
			</cfloop>		
		</cfloop>	
	
	</cffunction>
	
	<cffunction name="getDetailsFiltrosIndicadoresMIGMid" access="remote" returntype="string">
		<cfargument name="MIGMidindicador" 	type="numeric" required="yes">
		<cfargument name="MIGMid" 			type="numeric" required="no" default="">
		<cfargument name="CEcodigo" 		type="numeric" default="#session.CEcodigo#">
		<cfargument name="Ecodigo" 			type="numeric" default="#session.Ecodigo#">
		<cfargument name="DSN" 				type="string"	default="#session.DSN#">
		
			<cfset msj = ''>
			
			<cfif isdefined('Arguments.MIGMidindicador') and len(trim(Arguments.MIGMidindicador)) and Arguments.MIGMidindicador GT 0><!---Tipo de Detalle por el cual se va a Filtrar--->
				
				<cfquery datasource="#session.DSN#" name="rsMetricas">
					select distinct c.MIGMid,c.MIGMnombre,a.MIGMtipodetalle
					from MIGFiltrosindicadores a  
						inner join MIGMetricas c
						on c.MIGMid = a.MIGMid
						and c.Ecodigo = a.Ecodigo
						
					where a.MIGMidindicador = #form.MIGMID#
					and a.Ecodigo = #session.Ecodigo#
				</cfquery>
				
				
				<cfquery name="rsFiltros" datasource="#session.DSN#">
					select count(a.MIGMidindicador)as hay, b.MIGMtipodetalle as detalle
					from MIGFiltrosindicadores a  
						inner join MIGMetricas b
						on b.MIGMid = a.MIGMid
						and a.Ecodigo = b.Ecodigo
					where a.Ecodigo = #Arguments.Ecodigo#
					and MIGMidindicador = #Arguments.MIGMidindicador# 
					<cfif isdefined('Arguments.MIGMid') and len(trim(Arguments.MIGMid))>
					and a.MIGMid = #Arguments.MIGMID#
					</cfif>
					group by b.MIGMtipodetalle
				</cfquery>
				
				<cfif rsFiltros.hay GT 0>
					<cfif rsFiltros.detalle is 'D'>
						<cfquery datasource="#session.DSN#" name="rsDatosSelect">
							select a.MIGMdetalleid as id, b.DeptoCodigo as codigo,b.Ddescripcion as descripcion
							from MIGFiltrosindicadores a  
								inner join Departamentos b
								on b.Dcodigo = a.MIGMdetalleid
								and a.Ecodigo = b.Ecodigo
							where MIGMid = #Arguments.MIGMID#
							<cfif isdefined('Arguments.Ecodigo') and len(trim(Arguments.Ecodigo))>
							and a.Ecodigo = #Arguments.Ecodigo#
							</cfif>
						</cfquery>
						<cfset listaDetalleIds= valuelist(rsDatosSelect.id)>
					<cfelseif rsFiltros.detalle is 'C'>
						<cfquery datasource="#session.DSN#" name="rsDatosSelect">
							select a.MIGMdetalleid as id, b.MIGCuecodigo as codigo,b.MIGCuedescripcion as descripcion
							from MIGFiltrosindicadores a  
								inner join MIGCuentas b
								on b.MIGCueid = a.MIGMdetalleid
								and a.Ecodigo = b.Ecodigo
							where MIGMid = #Arguments.MIGMID#
							<cfif isdefined('Arguments.Ecodigo') and len(trim(Arguments.Ecodigo))>
							and a.Ecodigo = #Arguments.Ecodigo#
							</cfif>
						</cfquery>
						<cfset listaDetalleIds= valuelist(rsDatosSelect.id)>
					<cfelseif rsFiltros.detalle is 'P'>
						<cfquery datasource="#session.DSN#" name="rsDatosSelect">
							select a.MIGMdetalleid as id, b.MIGProcodigo as codigo,b.MIGPronombre as descripcion
							from MIGFiltrosindicadores a  
								inner join MIGProductos b
								on b.MIGProid = a.MIGMdetalleid
								and a.Ecodigo = b.Ecodigo
							where MIGMid = #Arguments.MIGMID#
							<cfif isdefined('Arguments.Ecodigo') and len(trim(Arguments.Ecodigo))>
							and a.Ecodigo = #Arguments.Ecodigo#
							</cfif>
						</cfquery>
						<cfset listaDetalleIds= valuelist(rsDatosSelect.id)>
					</cfif>

				</cfif>
			</cfif>
			<cfif isdefined('listaDetalleIds') and len(trim(listaDetalleIds))>	
				<cfset msj = listaDetalleIds>
			</cfif>
			<cfreturn msj>
	</cffunction>
	
	<cffunction name="ProcesoBase" access="remote" returntype="string">
		<cfargument name="MIGMID" 		type="numeric" required="no" default="">
		<cfargument name="Periodo" 		type="string" required="no" default="">
		<cfargument name="Pinicio" 		type="string" required="no" default=""><!---fechas de periocidad inicio--->
		<cfargument name="Pfin" 		type="string" required="no" default=""><!---fechas de periocidad hasta--->--->
		<cfargument name="CEcodigo" 	type="numeric" default="#session.CEcodigo#">
		<cfargument name="Ecodigo" 		type="numeric" default="#session.Ecodigo#">
		<cfargument name="DSN" 			type="string"	default="#session.DSN#">
		<cfargument name="todos" 		type="boolean" 	required="no" default="false">
		<cfargument name="tipo" 		type="string" 	required="no" default="0"> <!---0=M y I, M=metricas, I=indicadores --->
		
			<cfset msj = ''>
		
			<cf_dbfunction2 name="OP_concat"	returnvariable="_Cat">
		
			<cfset listPeriodos = "">
			<cfif isdefined('Arguments.Pinicio') and len(trim(Arguments.Pinicio))>
				<cfset listPeriodos = getRangoPeriodos(MIGMID='#Arguments.MIGMID#',Pinicio='#Arguments.Pinicio#',Pfin='#Arguments.Pfin#',CEcodigo='#Arguments.CEcodigo#',Ecodigo='#Arguments.Ecodigo#',DSN='#Arguments.DSN#')>
			</cfif>
				
			
			<cfquery datasource="#session.DSN#" name="rsMetricIndic">
				select *
				from MIGMetricas a
				WHERE	a.dactiva = 1 
					and a.Ecodigo = #Arguments.Ecodigo#
					and a.CEcodigo = #Arguments.CEcodigo#
					<cfif isdefined('Arguments.MIGMID') and len(trim(Arguments.MIGMID)) and Arguments.MIGMID GT 0>
					and a.MIGMid = #Arguments.MIGMid#
					</cfif>
					<cfif isdefined('Arguments.MIGMID') and Arguments.MIGMID NEQ 0>
					and a.MIGMesmetrica = '#Arguments.tipo#'
					</cfif>
			</cfquery>	
			
			<cfif rsMetricIndic.recordCount gt 0>
				<cfset MIGMID_actual = rsMetricIndic.MIGMID>
				<cfset tipodetalle = rsMetricIndic.MIGMtipodetalle>
				
				<cfset listaDetalleIds = "">
				<cfset listaDetalleIds = getDetailsFiltros(MIGMID='#MIGMID_actual#',CEcodigo='#Arguments.CEcodigo#',Ecodigo='#Arguments.Ecodigo#',DSN='#Arguments.DSN#')>
				
				<cfset calculadosList = getCalculados(MIGMID='#MIGMID_actual#',Periodo='#Arguments.Periodo#',Pinicio='#Arguments.Pinicio#',Pfin='#Arguments.Pfin#',todos='#Arguments.todos#',CEcodigo='#Arguments.CEcodigo#',Ecodigo='#Arguments.Ecodigo#',DSN='#Arguments.DSN#',listaDetalleIds='#listaDetalleIds#',listPeriodos='#listPeriodos#')>		
				
				<!--- CALCULO DE DATOS--->
				<cfquery datasource="#session.DSN#" name="rsBaseCalc">
					select 
						a.MIGMid
						<cfif tipodetalle is 'D'>
						,a.Dcodigo
						</cfif>
						<cfif tipodetalle is 'P'>
						,a.MIGProid
						</cfif>
						<cfif tipodetalle is 'C'>
						,a.MIGCueid
						</cfif>
						,a.periodo
						,a.Pfecha
						,a.CEcodigo
						,a.Ecodigo
						,a.mes
						,SUM(a.valor) as resultado
						,SUM(a.cantidad) as cantidad
						
					from F_DATOS a
					WHERE 
						a.Ecodigo = #Arguments.Ecodigo#
						and a.CEcodigo = #Arguments.CEcodigo#
						and a.MIGMid is not null 
						and a.MIGMid = #MIGMID_actual#
						
						<cfif isdefined('calculadosList') and len(trim(calculadosList))>
						and a.MIGMid not in (<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#calculadosList#">)
						</cfif>
						
						<cfif not len(trim(Arguments.Periodo)) and not len(trim(Arguments.Pinicio))><!---periodo actual--->
							and a.Periodo = (select case b.MIGMperiodicidad
												when 'D' then <cf_dbfunction2 name="date_format" args="#now()#,YYYYDY">
												when 'W' then <cf_dbfunction2 name="date_format" args="#now()#,YYYYWK">
												when 'M' then <cf_dbfunction2 name="date_format" args="#now()#,YYYYMM">
												when 'T' then <cf_dbfunction2 name="date_format" args="#now()#,YYYYQQ">
												when 'A' then <cf_dbfunction2 name="date_format" args="#now()#,YYYY">#_Cat#'00'
												when 'S' then 
													case when <cf_dbfunction2 name="date_part" args="QQ,#now()#"> < 2 then
															  <cf_dbfunction2 name="date_format" args="#now()#,YYYY">#_Cat#'01'
													else
															  <cf_dbfunction2 name="date_format" args="#now()#,YYYY">#_Cat#'02'
													end
											end as pPeriodo
											from MIGMetricas b
											where b.MIGMid=a.MIGMid)
							
						</cfif>
							
						<cfif len(trim(Arguments.Periodo))>		<!---periodo definido--->
						and a.Periodo = #Arguments.Periodo#
						</cfif>
						
						<cfif isdefined('listPeriodos') and len(trim(listPeriodos))>
							and a.Periodo in (<cfqueryparam  list="yes" cfsqltype="cf_sql_integer" value="#listPeriodos#">) 
						</cfif>
						
						<cfif isdefined('listaDetalleIds') and len(trim(listaDetalleIds))>
							<cfif tipodetalle is 'D'>
							and a.Dcodigo in(<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#listaDetalleIds#">)
							</cfif>
							<cfif tipodetalle is 'P'>
							and a.MIGproid in(<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#listaDetalleIds#">)
							</cfif>
							<cfif tipodetalle is 'C'>
							and a.MIGcueid in(<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#listaDetalleIds#">)
							</cfif>
						</cfif>
						
						group by a.MIGMid
							<cfif tipodetalle is 'D'>
							,a.Dcodigo
							</cfif>
							<cfif tipodetalle is 'P'>
							,a.MIGProid
							</cfif>
							<cfif tipodetalle is 'C'>
							,a.MIGCueid
							</cfif>
							,a.PERIODO	
							,a.Pfecha
							,a.CECODIGO
							,a.ECODIGO
							,a.mes
						
						order by a.MIGMid
							<cfif tipodetalle is 'D'>
							,a.Dcodigo
							</cfif>
							<cfif tipodetalle is 'P'>
							,a.MIGProid
							</cfif>
							<cfif tipodetalle is 'C'>
							,a.MIGCueid
							</cfif>
							,a.PERIODO	
							,a.Pfecha
							,a.CECODIGO
							,a.ECODIGO 
							,a.mes
					
				</cfquery>
			<cfif rsBaseCalc.RecordCount EQ 0>
				<cfquery datasource="#session.DSN#" name="rsBaseCalc">
					select 
						a.MIGMid
						<cfif tipodetalle is 'D'>
						,a.Dcodigo
						</cfif>
						<cfif tipodetalle is 'P'>
						,a.MIGProid
						</cfif>
						<cfif tipodetalle is 'C'>
						,a.MIGCueid
						</cfif>
						,a.periodo
						,a.Pfecha
						,a.CEcodigo
						,a.Ecodigo
						,a.mes
						,SUM(a.valor) as resultado
						,SUM(a.cantidad) as cantidad
						
					from F_DATOS a
					WHERE 
						a.Ecodigo = #Arguments.Ecodigo#
						and a.CEcodigo = #Arguments.CEcodigo#
						and a.MIGMid is not null 
						
						<cfif isdefined('calculadosList') and len(trim(calculadosList))>
						and a.MIGMid not in (<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#calculadosList#">)
						</cfif>
						
						<cfif not len(trim(Arguments.Periodo)) and not len(trim(Arguments.Pinicio))><!---periodo actual--->
							and a.Periodo = (select case b.MIGMperiodicidad
												when 'D' then <cf_dbfunction2 name="date_format" args="#now()#,YYYYDY">
												when 'W' then <cf_dbfunction2 name="date_format" args="#now()#,YYYYWK">
												when 'M' then <cf_dbfunction2 name="date_format" args="#now()#,YYYYMM">
												when 'T' then <cf_dbfunction2 name="date_format" args="#now()#,YYYYQQ">
												when 'A' then <cf_dbfunction2 name="date_format" args="#now()#,YYYY">#_Cat#'00'
												when 'S' then 
													case when <cf_dbfunction2 name="date_part" args="QQ,#now()#"> < 2 then
															  <cf_dbfunction2 name="date_format" args="#now()#,YYYY">#_Cat#'01'
													else
															  <cf_dbfunction2 name="date_format" args="#now()#,YYYY">#_Cat#'02'
													end
											end as pPeriodo
											from MIGMetricas b
											where b.MIGMid=a.MIGMid)
							
						</cfif>
							
						<cfif len(trim(Arguments.Periodo))>		<!---periodo definido--->
						and a.Periodo = #Arguments.Periodo#
						</cfif>
						
						<cfif isdefined('listPeriodos') and len(trim(listPeriodos))>
							and a.Periodo in (<cfqueryparam  list="yes" cfsqltype="cf_sql_integer" value="#listPeriodos#">) 
						</cfif>
						
						<cfif isdefined('listaDetalleIds') and len(trim(listaDetalleIds))>
							<cfif tipodetalle is 'D'>
							and a.Dcodigo in(<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#listaDetalleIds#">)
							</cfif>
							<cfif tipodetalle is 'P'>
							and a.MIGproid in(<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#listaDetalleIds#">)
							</cfif>
							<cfif tipodetalle is 'C'>
							and a.MIGcueid in(<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#listaDetalleIds#">)
							</cfif>
						</cfif>
						
						group by a.MIGMid
							<cfif tipodetalle is 'D'>
							,a.Dcodigo
							</cfif>
							<cfif tipodetalle is 'P'>
							,a.MIGProid
							</cfif>
							<cfif tipodetalle is 'C'>
							,a.MIGCueid
							</cfif>
							,a.PERIODO	
							,a.Pfecha
							,a.CECODIGO
							,a.ECODIGO
							,a.mes
						
						order by a.MIGMid
							<cfif tipodetalle is 'D'>
							,a.Dcodigo
							</cfif>
							<cfif tipodetalle is 'P'>
							,a.MIGProid
							</cfif>
							<cfif tipodetalle is 'C'>
							,a.MIGCueid
							</cfif>
							,a.PERIODO	
							,a.Pfecha
							,a.CECODIGO
							,a.ECODIGO 
							,a.mes
					
				</cfquery>
			</cfif>
			
				<cftry>
	
					<cfloop query="rsBaseCalc">
							<cfquery datasource="#session.DSN#" name="rsTip"> 
								select MIGMesmetrica from MIGMetricas where MIGMid=#rsBaseCalc.MIGMid# 
							</cfquery>	
							<cfquery datasource="#session.DSN#"> <!---en caso de que haya algo de basura--->
								Delete F_Resultados 
								where MIGMid=#rsBaseCalc.MIGMid# 
								and periodo=#rsBaseCalc.periodo#
								and Ecodigo = #Arguments.Ecodigo#
								and CEcodigo = #Arguments.CEcodigo#
								<cfif tipoDetalle EQ 'P'>
									and MIGProid = #rsBaseCalc.MIGProid#
								<cfelse>
									and MIGProid is null
								</cfif>
								<cfif tipoDetalle EQ 'C'>
									and MIGCueid = #rsBaseCalc.MIGCueid#
								<cfelse>
									and MIGCueid is null
								</cfif>
								<cfif tipoDetalle EQ 'D'>
									and Dcodigo = #rsBaseCalc.Dcodigo#
								<cfelse>
									and Dcodigo is null
								</cfif>
							</cfquery>
								
							<cfquery datasource="#session.DSN#"><!---verificar que este sea por producto o depto o cuenta--->
								Insert into F_Resultados(CEcodigo,Ecodigo,cod_fuente,MIGMid,MIGMesmetrica,periodo,mes,PFecha,tipo,cantidad,resultado,importe,BMUsucodigo,fechaalta,Dcodigo,MIGProid,MIGCueid)
								VALUES(#Arguments.CEcodigo#,#Arguments.Ecodigo#,-1,#rsBaseCalc.MIGMid#,'#rsTip.MIGMesmetrica#',#rsBaseCalc.periodo#,-1
								,<cfqueryparam cfsqltype="cf_sql_date" value="#rsBaseCalc.pfecha#">
								,'N'
								<cfif len(trim(rsBaseCalc.cantidad))>
									,#rsBaseCalc.cantidad#
								<cfelse>
									,-1
								</cfif>
								,#rsBaseCalc.resultado#,-1,1
								,<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
								
								<cfif tipoDetalle EQ 'D'>
									,#rsBaseCalc.Dcodigo#
								<cfelse>
									,null
								</cfif>
								
								<cfif tipoDetalle EQ 'P'>
									,#rsBaseCalc.MIGProid#
								<cfelse>
									,null
								</cfif>
								
								<cfif tipoDetalle EQ 'C'>
									,#rsBaseCalc.MIGCueid#
								<cfelse>
									,null
								</cfif>
								)
							</cfquery>
						
					</cfloop>
					
					<cfreturn 'Proceso base listo'>
					
					<cfcatch type="any">
						<cfdump var="#cfcatch#">
						<cfabort>
					</cfcatch>
				</cftry>
				
			</cfif>
				
	</cffunction>
	
	<cffunction name="CalculoMetricas" access="remote" returntype="string">
		<cfargument name="MIGMID" 		type="numeric" required="no" default="">
		<cfargument name="Periodo" 		type="string" required="no" default="">
		<cfargument name="Pinicio" 		type="string" required="no" default=""><!---fechas de periocidad inicio--->
		<cfargument name="Pfin" 		type="string" required="no" default=""><!---fechas de periocidad hasta--->
		<cfargument name="CEcodigo" 	type="numeric" default="#session.CEcodigo#">
		<cfargument name="Ecodigo" 		type="numeric" default="#session.Ecodigo#">
		<cfargument name="DSN" 			type="string"	default="#session.DSN#">
		<cfargument name="todos" 		type="boolean" required="no" default="false">
		<cfset msj = ''>
		
		<cf_dbfunction2 name="OP_concat"	returnvariable="_Cat">
		
		
			<cfset listPeriodos = "">
			<cfif isdefined('Arguments.Pinicio') and len(trim(Arguments.Pinicio))>
				<cfset listPeriodos = getRangoPeriodos(MIGMID='#Arguments.MIGMID#',Pinicio='#Arguments.Pinicio#',Pfin='#Arguments.Pfin#',CEcodigo='#Arguments.CEcodigo#',Ecodigo='#Arguments.Ecodigo#',DSN='#Arguments.DSN#')>
			</cfif>
			
			<!--- Formulas de las de Metricas--->
			<cfquery datasource="#session.DSN#" name="rsFormulas">
				select *
				from MIGMetricas a
				WHERE  a.MIGMesmetrica = 'M'
					and  a.dactiva = 1
					<cfif isdefined('Arguments.MIGMID') and len(trim(Arguments.MIGMID)) and Arguments.MIGMID GT 0>
					and a.MIGMid = #Arguments.MIGMID#
					</cfif>
					<cfif isdefined('calculadosList') and len(trim(calculadosList))>
					and a.MIGMid not in (<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#calculadosList#">)
					</cfif>
					<cfif isdefined('Arguments.Ecodigo') and len(trim(Arguments.Ecodigo))>
					and a.Ecodigo = #Arguments.Ecodigo#
					</cfif>
					order by MIGMsequencia	
			</cfquery>
			
			
			<cfloop query="rsFormulas">
				
				<!---sacar la lista de las metricas y detalles para ese indicador--->
				<cfquery datasource="#Arguments.DSN#" name="rsEsDerivada">
					select * from MIGFiltrosderivadas where MIGMidderivada = #rsFormulas.MIGMid#
					order by MIGMidderivada, MIGMid 
				</cfquery>
				<cfif rsEsDerivada.recordCount EQ 0>	<!---Es simple--->
					<cfset msj = CalculoMetricaSimple(Pinicio='#Arguments.Pinicio#',Pfin='#Arguments.Pfin#',Periodo='#Arguments.Periodo#',MIGMID='#rsFormulas.MIGMid#',CEcodigo='#Arguments.CEcodigo#',Ecodigo='#Arguments.Ecodigo#',DSN='#Arguments.DSN#')>
				<cfelse>								<!---Es derivada--->
					<cfset msj = CalculoMetricasDerivadas(Pinicio='#Arguments.Pinicio#',Pfin='#Arguments.Pfin#',Periodo='#Arguments.Periodo#',MIGMID='#rsFormulas.MIGMid#',CEcodigo='#Arguments.CEcodigo#',Ecodigo='#Arguments.Ecodigo#',DSN='#Arguments.DSN#')>
				</cfif>
			</cfloop>
			
			<cfreturn #msj#>	
	</cffunction>
	
	<!---PROCESO DE CALCULO DE METRICAS SENCILLAS--->
	<cffunction name="CalculoMetricaSimple" access="remote" returntype="string">
		<cfargument name="MIGMID" 		type="numeric" required="no" default="">
		<cfargument name="Periodo" 		type="string" required="no" default="">
		<cfargument name="Pinicio" 		type="string" required="no" default=""><!---fechas de periocidad inicio--->
		<cfargument name="Pfin" 		type="string" required="no" default=""><!---fechas de periocidad hasta--->
		<cfargument name="CEcodigo" 	type="numeric" default="#session.CEcodigo#">
		<cfargument name="Ecodigo" 		type="numeric" default="#session.Ecodigo#">
		<cfargument name="DSN" 			type="string"	default="#session.DSN#">
		<cfargument name="todos" 		type="boolean" required="no" default="false">
		<cfset msj = ''>
		
		<cf_dbfunction2 name="OP_concat"	returnvariable="_Cat">
		
		
		<cfset listPeriodos = "">
		<cfif isdefined('Arguments.Pinicio') and len(trim(Arguments.Pinicio))>
			<cfset listPeriodos = getRangoPeriodos(MIGMID='#Arguments.MIGMID#',Pinicio='#Arguments.Pinicio#',Pfin='#Arguments.Pfin#',CEcodigo='#Arguments.CEcodigo#',Ecodigo='#Arguments.Ecodigo#',DSN='#Arguments.DSN#')>
		</cfif>
		
		
			
			<!--- Formulas de las de Metricas--->
			<cfquery datasource="#session.DSN#" name="rsFormulas">
				select *
				from MIGMetricas a
				WHERE  a.MIGMesmetrica = 'M'
					and  a.dactiva = 1
					<cfif isdefined('Arguments.MIGMID') and len(trim(Arguments.MIGMID)) and Arguments.MIGMID GT 0>
					and a.MIGMid = #Arguments.MIGMID#
					</cfif>
					<cfif isdefined('calculadosList') and len(trim(calculadosList))>
					and a.MIGMid not in (<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#calculadosList#">)
					</cfif>
					<cfif isdefined('Arguments.Ecodigo') and len(trim(Arguments.Ecodigo))>
					and a.Ecodigo = #Arguments.Ecodigo#
					</cfif>
					order by MIGMsequencia	
			</cfquery>
			
			
			<cfloop query="rsFormulas">
				<cfset MIGMid_actual = rsFormulas.MIGMid>
				<cfset tipoDetalle = rsFormulas.MIGMtipodetalle>
				<cfset formula_actual = rsFormulas.MIGMcalculo>
				<cfset periodoTipo_actual = rsFormulas.MIGMperiodicidad>
				
				<cfset listaDetalleIds = "">
				<cfif isdefined('MIGMid_actual') and len(trim(MIGMid_actual)) and MIGMid_actual GT 0><!---Tipo de Detalle por el cual se va a Filtrar--->
					<cfset listaDetalleIds = getDetailsFiltros(MIGMID='#MIGMid_actual#',CEcodigo='#Arguments.CEcodigo#',Ecodigo='#Arguments.Ecodigo#',DSN='#Arguments.DSN#')>
					<cfset calculadosList = getCalculados(MIGMID='#MIGMid_actual#',Periodo='#Arguments.Periodo#',Pinicio='#Arguments.Pinicio#',Pfin='#Arguments.Pfin#',todos='#Arguments.todos#',CEcodigo='#Arguments.CEcodigo#',Ecodigo='#Arguments.Ecodigo#',DSN='#Arguments.DSN#',listaDetalleIds='#listaDetalleIds#',listPeriodos='#listPeriodos#')>
				</cfif>
				
				<!---Datos que va a tomar en cuenta la metrica para la formula (variables)--->
				<cfquery datasource="#Arguments.DSN#" name="rsDatosVariables">
					select a.MIGMid
						,x.MIGMcodigo <!---si despues viene definido por depto producto o cuenta, se de be agregar--->
						,SUM(a.resultado) as resultado
						,a.Periodo
						,a.pfecha
						
						<cfif tipoDetalle EQ 'P'>
						,a.MIGProid
						<cfelseif tipoDetalle EQ 'C'>
						,a.MIGCueid
						<cfelse>
						,a.Dcodigo
						</cfif>
						
						,a.CEcodigo
						,a.Ecodigo
						
					from F_Resultados a
					inner join MIGMetricas x
					on x.MIGMid = a.MIGMid 
					where a.TIPO = 'N'
						and a.MIGMid is not null 
						and a.CEcodigo = #Arguments.CEcodigo#
						and a.Ecodigo = #Arguments.Ecodigo#
						<cfif not len(trim(Arguments.Periodo)) and not len(trim(Arguments.Pinicio)) and len(trim(Arguments.MIGMID)) and Arguments.MIGMID GT 0><!---periodo actual--->
							and a.Periodo = (select case b.MIGMperiodicidad
												when 'D' then <cf_dbfunction2 name="date_format" args="#now()#,YYYYDY">
												when 'W' then <cf_dbfunction2 name="date_format" args="#now()#,YYYYWK">
												when 'M' then <cf_dbfunction2 name="date_format" args="#now()#,YYYYMM">
												when 'T' then <cf_dbfunction2 name="date_format" args="#now()#,YYYYQQ">
												when 'A' then <cf_dbfunction2 name="date_format" args="#now()#,YYYY">#_Cat#'00'
												when 'S' then 
													case when <cf_dbfunction2 name="date_part" args="QQ,#now()#"> < 2 then
															  <cf_dbfunction2 name="date_format" args="#now()#,YYYY">#_Cat#'01'
													else
															  <cf_dbfunction2 name="date_format" args="#now()#,YYYY">#_Cat#'02'
													end
											end as pPeriodo
											from MIGMetricas b
											where b.MIGMid=a.MIGMid)
							
						</cfif>
							
						<cfif len(trim(Arguments.Periodo))>		<!---periodo definido--->
						and a.Periodo = #Arguments.Periodo#
						</cfif>
						
						<cfif isdefined('listPeriodos') and len(trim(listPeriodos))>
							and a.Periodo in (<cfqueryparam  list="yes" cfsqltype="cf_sql_integer" value="#listPeriodos#">) 
						</cfif>
						
						<cfif tipoDetalle EQ 'P'>
							and a.MIGProid in (<cfqueryparam  list="yes" cfsqltype="cf_sql_integer" value="#listaDetalleIds#">) 
						<cfelse>
							and a.MIGProid is null
						</cfif>
						<cfif tipoDetalle EQ 'C'>
							and a.MIGCueid in (<cfqueryparam  list="yes" cfsqltype="cf_sql_integer" value="#listaDetalleIds#">) 
						<cfelse>
							and a.MIGCueid is null
						</cfif>
						<cfif tipoDetalle EQ 'D'>
							and a.Dcodigo in (<cfqueryparam  list="yes" cfsqltype="cf_sql_integer" value="#listaDetalleIds#">)
						<cfelse>
							and a.Dcodigo is null
						</cfif>
						
						group by a.MIGMid, x.MIGMcodigo,a.Periodo,a.pfecha
						<cfif tipoDetalle EQ 'P'>
						,a.MIGProid
						<cfelseif tipoDetalle EQ 'C'>
						,a.MIGCueid
						<cfelse>
						,a.Dcodigo
						</cfif>
						,a.CEcodigo,a.Ecodigo
						
						order by a.MIGMid, x.MIGMcodigo,a.Periodo,a.pfecha
						<cfif tipoDetalle EQ 'P'>
						,a.MIGProid
						<cfelseif tipoDetalle EQ 'C'>
						,a.MIGCueid
						<cfelse>
						,a.Dcodigo
						</cfif>
						,a.CEcodigo,a.Ecodigo
				</cfquery>
				
				<cfif rsDatosVariables.recordCount EQ 0 or ( rsDatosVariables.recordCount EQ 0 and (isdefined('formula_actual') and len(trim(formula_actual))))>
					<!---para este caso busca para el mismo periodo pero en F_Resultados, se puede buscar tambien por el ultimo periodo calculado pero para este casa se hara para el periodo requerido--->
					<cfquery datasource="#Arguments.DSN#" name="rsDatosVariables"><!---Elimina el filtro por id de metrica, caso en que hay formulas y no hay datos en fdatos ni en fresultados --->
						select a.MIGMid
							,x.MIGMcodigo <!---si despues viene definido por depto producto o cuenta, se de be agregar--->
							,SUM(a.resultado) as resultado
							,a.Periodo
							,a.pfecha
							
							<cfif tipoDetalle EQ 'P'>
							,a.MIGProid
							<cfelseif tipoDetalle EQ 'C'>
							,a.MIGCueid
							<cfelse>
							,a.Dcodigo
							</cfif>
							
							,a.CEcodigo
							,a.Ecodigo
							
						from F_Resultados a
						inner join MIGMetricas x
						on x.MIGMid = a.MIGMid 
						where a.TIPO = 'S'
							and a.MIGMid is not null 
							and a.CEcodigo = #Arguments.CEcodigo#
							and a.Ecodigo = #Arguments.Ecodigo#
							<cfif not len(trim(Arguments.Periodo)) and not len(trim(Arguments.Pinicio))><!---periodo actual--->
								and a.Periodo = (select case b.MIGMperiodicidad
													when 'D' then <cf_dbfunction2 name="date_format" args="#now()#,YYYYDY">
													when 'W' then <cf_dbfunction2 name="date_format" args="#now()#,YYYYWK">
													when 'M' then <cf_dbfunction2 name="date_format" args="#now()#,YYYYMM">
													when 'T' then <cf_dbfunction2 name="date_format" args="#now()#,YYYYQQ">
													when 'A' then <cf_dbfunction2 name="date_format" args="#now()#,YYYY">#_Cat#'00'
													when 'S' then 
														case when <cf_dbfunction2 name="date_part" args="QQ,#now()#"> < 2 then
																  <cf_dbfunction2 name="date_format" args="#now()#,YYYY">#_Cat#'01'
														else
																  <cf_dbfunction2 name="date_format" args="#now()#,YYYY">#_Cat#'02'
														end
												end as pPeriodo
												from MIGMetricas b
												where b.MIGMid=a.MIGMid)
								
							</cfif>
								
							<cfif len(trim(Arguments.Periodo))>		<!---periodo definido--->
							and a.Periodo = #Arguments.Periodo#
							</cfif>
							
							<cfif isdefined('listPeriodos') and len(trim(listPeriodos))>
								and a.Periodo in (<cfqueryparam  list="yes" cfsqltype="cf_sql_integer" value="#listPeriodos#">) 
							</cfif>
							
							<cfif tipoDetalle EQ 'P'>
								and a.MIGProid in (<cfqueryparam  list="yes" cfsqltype="cf_sql_integer" value="#listaDetalleIds#">) 
							<cfelse>
								and a.MIGProid is null
							</cfif>
							<cfif tipoDetalle EQ 'C'>
								and a.MIGCueid in (<cfqueryparam  list="yes" cfsqltype="cf_sql_integer" value="#listaDetalleIds#">) 
							<cfelse>
								and a.MIGCueid is null
							</cfif>
							<cfif tipoDetalle EQ 'D'>
								and a.Dcodigo in (<cfqueryparam  list="yes" cfsqltype="cf_sql_integer" value="#listaDetalleIds#">)
							<cfelse>
								and a.Dcodigo is null
							</cfif>
							
							
							
							<!---elije el periodo maximo--->
							<!---	and a.Periodo = (select max(w.periodo)from F_Resultados w where w.MIGMid=a.MIGMid and w.CEcodigo=a.CEcodigo and w.Ecodigo=a.Ecodigo)--->
							
							group by a.MIGMid, x.MIGMcodigo,a.Periodo,a.pfecha
							<cfif tipoDetalle EQ 'P'>
							,a.MIGProid
							<cfelseif tipoDetalle EQ 'C'>
							,a.MIGCueid
							<cfelse>
							,a.Dcodigo
							</cfif>
							,a.CEcodigo,a.Ecodigo
							
							order by a.MIGMid, x.MIGMcodigo,a.Periodo,a.pfecha
							<cfif tipoDetalle EQ 'P'>
							,a.MIGProid
							<cfelseif tipoDetalle EQ 'C'>
							,a.MIGCueid
							<cfelse>
							,a.Dcodigo
							</cfif>
							,a.CEcodigo,a.Ecodigo
					</cfquery>
					
					<!---<cfif rsDatosVariables.recordCount EQ 0>
						<cfset hola =doMNS('No existen datos para el periodo calculado que respalden la f&oacute;rmula para este indicador, verfique que las m&eacute;tricas y valores utilizados coincidan en periodo y que existan valores')>
					</cfif>--->
					
				</cfif>
				
				<cfif rsDatosVariables.recordCount GT 0>
				
					<cfquery dbtype="query" name="rsPeriodos">	<!---Lista de diferentes periodos--->
						select distinct periodo
							<cfif tipoDetalle EQ 'P'>
							,MIGProid
							<cfelseif tipoDetalle EQ 'C'>
							,MIGCueid
							<cfelse>
							,Dcodigo
							</cfif>
							,CEcodigo,Ecodigo
						from rsDatosVariables
						order by periodo
							<cfif tipoDetalle EQ 'P'>
							,MIGProid
							<cfelseif tipoDetalle EQ 'C'>
							,MIGCueid
							<cfelse>
							,Dcodigo
							</cfif>
							,CEcodigo,Ecodigo
					</cfquery>
					
					<cfloop query="rsPeriodos">
						<cfset Dcod=''>
						<cfset proid= ''>
						<cfset cueid=''>
							
						<cfset  periodoCal=rsPeriodos.periodo>
						<cfset  Ecod=rsPeriodos.Ecodigo>
						<cfset  CEcod=rsPeriodos.CEcodigo>
						
						<cfif isdefined('rsPeriodos.Dcodigo') and len(trim(rsPeriodos.Dcodigo))>
							<cfset Dcod=rsPeriodos.Dcodigo>
						</cfif>
						<cfif isdefined('rsPeriodos.MIGProid') and len(trim(rsPeriodos.MIGProid))>
							<cfset  proid=rsPeriodos.MIGProid>
						</cfif>
						<cfif isdefined('rsPeriodos.MIGCueid') and len(trim(rsPeriodos.MIGCueid))>
							<cfset cueid=rsPeriodos.MIGCueid>
						</cfif>
						<!---obtine las fechas del periodo que estamos calculando para el indicador--->
						<cfinvoke component="utils" method="fnDSNdestino" returnvariable="dsnA"/>
						<cfinvoke component="utils" method="fnPeriodoToFecha" returnvariable="rsPfecha">
							<cfinvokeargument name="dsn" 		value="#dsnA#"/>
							<cfinvokeargument name="Valor_ORI" 	value="#trim(periodoCal)#"/>
							<cfinvokeargument name="Tipo_ORI" 	value="#periodoTipo_actual#"/>
						</cfinvoke>
						<cfset pfechaCal = rsPfecha.fin>
						
						<cfquery dbtype="query" name="rsVariablesxPeriodo">	<!---Lista de diferentes periodos--->
							select * from rsDatosVariables 
							where periodo = #periodoCal#
							<cfif isdefined('Dcod') and len(trim(Dcod))>
								and Dcodigo = #Dcod#
							</cfif>
							<cfif isdefined('proid') and len(trim(proid))>
								and MIGProid = #proid#
							</cfif>
							<cfif isdefined('cueid') and len(trim(cueid))>
								and MIGCueid = #cueid#
							</cfif>
							order by MIGMid,periodo
							<cfif isdefined('proid') and len(trim(proid))>
								,MIGProid
							</cfif>
							<cfif isdefined('cueid') and len(trim(cueid))>
								,MIGCueid
							</cfif>
							<cfif isdefined('Dcod') and len(trim(Dcod))>
								,Dcodigo
							</cfif>
							,Ecodigo,CEcodigo 
						</cfquery>
						
						
						<!---Datos variables utilizables en el calculo de metricas--->
						<cfset DatosVariables = "">
						<cfset listaBlancos = "">
						<cfloop query="rsVariablesxPeriodo">
							<cfset listaBlancos = listaBlancos & IIF(len(trim(listaBlancos)),DE(','),DE('')) & rsVariablesxPeriodo.MIGMid>
							<cfsavecontent variable="DatosVariables">
							<cfoutput>#DatosVariables##rsVariablesxPeriodo.MIGMcodigo#=#rsVariablesxPeriodo.resultado#;</cfoutput>
							</cfsavecontent>
						</cfloop>
						
						<!---Genera todas las variables que quedaron por fuera del periodo y los pone en 0--->
						<cfquery dbtype="query" name="rsVariablesxPeriodoWhite">	
							select MIGMid,MIGMcodigo from rsFormulas 
							where Ecodigo = #Arguments.Ecodigo#	
							and CEcodigo = #Arguments.CEcodigo#						
							<cfif len(trim(listaBlancos))>
							and MIGMid not in(<cfqueryparam list="yes" cfsqltype="cf_sql_numeric" value="#listaBlancos#">)
							</cfif>
							order by MIGMid
						</cfquery>
						
						<cfset DatosVariablesWhite = "">
						<cfloop query="rsVariablesxPeriodoWhite">
							<cfsavecontent variable="DatosVariablesWhite">
							<cfoutput>#DatosVariablesWhite##rsVariablesxPeriodoWhite.MIGMcodigo#=0;</cfoutput>
							</cfsavecontent>
						</cfloop>
						<cfsavecontent variable="DatosVariables">
						<cfoutput>#DatosVariables##DatosVariablesWhite#</cfoutput>
						</cfsavecontent>
						
						<!---VARIABLES--->
						<cfsavecontent variable="VariablesFormula">
						<cfoutput>#DatosVariables# resultado=<cfif len(trim(rsFormulas.MIGMcalculo))>#rsFormulas.MIGMcalculo#<cfelse>#rsFormulas.MIGMcodigo#</cfif>;</cfoutput>
						</cfsavecontent>
						<!---<cf_dump var="#VariablesFormula#">--->
						<!---CALCULADORA--->
						<cfset result = calculate(VariablesFormula)>
						<cfif isdefined('result')>
							<cfset rs = result.get('resultado').toString()>
							<cfquery datasource="#session.DSN#" name="rsResultados"><!--- Localiza si para F_resumen ya existia el resultado --->
								select MIGMid, periodo,pfecha,Dcodigo,MIGProid,MIGCueid from F_Resultados
								where 
									MIGMid = #MIGMid_actual#
									and periodo = #periodoCal#
									and Ecodigo = #Arguments.Ecodigo#
									and pfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#pfechaCal#">
									<cfif isdefined('Dcod') and len(trim(Dcod))>
										and Dcodigo = #Dcod#
									<cfelse>
										and Dcodigo is null
									</cfif>
									<cfif isdefined('proid') and len(trim(proid))>
										and MIGProid = #proid#
									<cfelse>
										and MIGProid is null
									</cfif>
									<cfif isdefined('cueid') and len(trim(cueid))>
										and MIGCueid = #cueid#
									<cfelse>
										and MIGCueid is null
									</cfif>
									group by MIGMid,Periodo,pfecha,Dcodigo,MIGProid,MIGCueid
								</cfquery>
								<cfif rsResultados.recordCount gt 0>
									
									<cfquery datasource="#session.DSN#"><!--- actualiza F_Resultados --->
										update F_Resultados 
										set  resultado = #LSNumberFormat(rs,'99.9999')#
											,tipo = 'S'
										where 	
											MIGMid = #MIGMid_actual#
											and periodo = #periodoCal#
											and Ecodigo = #rsFormulas.Ecodigo#
											and CEcodigo = #rsFormulas.CEcodigo#
											and pfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#pfechaCal#">
											<cfif isdefined('Dcod') and len(trim(Dcod))>
												and Dcodigo = #Dcod#
											<cfelse>
												and Dcodigo is null
											</cfif>
											<cfif isdefined('proid') and len(trim(proid))>
												and MIGProid = #proid#
											<cfelse>
												and MIGProid is null
											</cfif>
											<cfif isdefined('cueid') and len(trim(cueid))>
												and MIGCueid = #cueid#
											<cfelse>
												and MIGCueid is null
											</cfif>
									</cfquery>
									
									<cfquery datasource="#session.DSN#" name="rsResumens"><!--- Localiza si para F_resumen ya existia el resultado --->
										select MIGMid, periodo,pfecha,Dcodigo,MIGProid,MIGCueid from F_Resumen
										where 
											MIGMid = #MIGMid_actual#
											and periodo = #periodoCal#
											and Ecodigo = #Arguments.Ecodigo#
											and pfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#pfechaCal#">
											<cfif isdefined('Dcod') and len(trim(Dcod))>
												and Dcodigo = #Dcod#
											<cfelse>
												and Dcodigo is null
											</cfif>
											<cfif isdefined('proid') and len(trim(proid))>
												and MIGProid = #proid#
											<cfelse>
												and MIGProid is null
											</cfif>
											<cfif isdefined('cueid') and len(trim(cueid))>
												and MIGCueid = #cueid#
											<cfelse>
												and MIGCueid is null
											</cfif>
										group by MIGMid,Periodo,pfecha,Dcodigo,MIGProid,MIGCueid
									</cfquery>
									
									<cfif rsResumens.recordCount gt 0>
									
										<cfquery datasource="#session.DSN#"><!--- actualiza F_Resultados --->
											update F_Resumen
											set  resultado = #LSNumberFormat(rs,'99.9999')#
												,tipo = 'S'
												,control=3
											where 	
												MIGMid = #MIGMid_actual#
												and periodo = #periodoCal#
												and Ecodigo = #rsFormulas.Ecodigo#
												and CEcodigo = #rsFormulas.CEcodigo#
												and pfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#pfechaCal#">
												<cfif isdefined('Dcod') and len(trim(Dcod))>
													and Dcodigo = #Dcod#
												<cfelse>
													and Dcodigo is null
												</cfif>
												<cfif isdefined('proid') and len(trim(proid))>
													and MIGProid = #proid#
												<cfelse>
													and MIGProid is null
												</cfif>
												<cfif isdefined('cueid') and len(trim(cueid))>
													and MIGCueid = #cueid#
												<cfelse>
													and MIGCueid is null
												</cfif>
										</cfquery>
									<cfelse>	
										<cfquery datasource="#session.DSN#"><!--- verificar que este sea por producto o depto o cuenta --->
												Insert into F_Resumen(CEcodigo,Ecodigo,cod_fuente,MIGMid,periodo,mes,PFecha,tipo,cantidad,resultado,importe,BMUsucodigo,fechaalta,Dcodigo,MIGProid,MIGCueid,control,periodo_tipo)
												VALUES(#rsFormulas.CEcodigo#,#rsFormulas.Ecodigo#,-1,#MIGMid_actual#,#periodoCal#,-1,
												<cfqueryparam cfsqltype="cf_sql_date" value="#pfechaCal#">,
												'S',
													-1,
												#LSNumberFormat(rs,'99.9999')#,-1,1,#now()#,
												<cfif isdefined('Dcod') and len(trim(Dcod))><!---Dcodigo,MIGProid,MIGCueid--->
													#Dcod#
												<cfelse>
													null
												</cfif>
												,
												<cfif isdefined('proid') and len(trim(proid))>
													#proid#
												<cfelse>
													null
												</cfif>
												,
												<cfif isdefined('cueid') and len(trim(cueid))>
													#cueid#
												<cfelse>
													null
												</cfif>
												,3,'#periodoTipo_actual#')
											</cfquery>
									 </cfif>
									
									<cfelse>
									
										<cfquery datasource="#session.DSN#"><!--- verificar que este sea por producto o depto o cuenta --->
										Insert into F_Resultados(CEcodigo,Ecodigo,cod_fuente,MIGMid,periodo,mes,MIGMesmetrica,pfecha,tipo,cantidad,resultado,importe,BMUsucodigo,fechaalta,Dcodigo,MIGProid,MIGCueid,periodo_tipo)
										VALUES(#rsFormulas.CEcodigo#,#rsFormulas.Ecodigo#,-1,#rsFormulas.MIGMid#,#periodoCal#,-1,'M',
										<cfqueryparam cfsqltype="cf_sql_date" value="#pfechaCal#">,
										'S',
											-1,
										#LSNumberFormat(rs,'99.9999')#,-1,1,#now()#,
										<cfif isdefined('Dcod') and len(trim(Dcod))><!---Dcodigo,MIGProid,MIGCueid--->
											#Dcod#
										<cfelse>
											null
										</cfif>
										,
										<cfif isdefined('proid') and len(trim(proid))>
											#proid#
										<cfelse>
											null
										</cfif>
										,
										<cfif isdefined('cueid') and len(trim(cueid))>
											#cueid#
										<cfelse>
											null
										</cfif>
										,'#periodoTipo_actual#'
										)
									</cfquery>
									
									
									<cfquery datasource="#session.DSN#" name="rsResumens">	<!--- Localiza si para F_resumen ya existia el resultado --->
										select MIGMid, periodo,pfecha,Dcodigo,MIGProid,MIGCueid from F_Resumen
										where 
											MIGMid = #MIGMid_actual#
											and periodo = #periodoCal#
											and Ecodigo = #Arguments.Ecodigo#
											and pfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#pfechaCal#">
											<cfif isdefined('Dcod') and len(trim(Dcod))>
												and Dcodigo = #Dcod#
											<cfelse>
												and Dcodigo is null
											</cfif>
											<cfif isdefined('proid') and len(trim(proid))>
												and MIGProid = #proid#
											<cfelse>
												and MIGProid is null
											</cfif>
											<cfif isdefined('cueid') and len(trim(cueid))>
												and MIGCueid = #cueid#
											<cfelse>
												and MIGCueid is null
											</cfif>
										group by MIGMid,Periodo,pfecha,Dcodigo,MIGProid,MIGCueid
									</cfquery>
									
									<cfif rsResumens.recordCount gt 0>
									
										<cfquery datasource="#session.DSN#">	<!--- actualiza F_Resultados --->
											update F_Resumen
											set  resultado = #LSNumberFormat(rs,'99.9999')#
												,tipo = 'S'
												,control=3
											where 	
												MIGMid = #MIGMid_actual#
												and periodo = #periodoCal#
												and Ecodigo = #rsFormulas.Ecodigo#
												and CEcodigo = #rsFormulas.CEcodigo#
												and pfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#pfechaCal#">
												<cfif isdefined('Dcod') and len(trim(Dcod))>
													and Dcodigo = #Dcod#
												<cfelse>
													and and Dcodigo is null
												</cfif>
												<cfif isdefined('proid') and len(trim(proid))>
													and MIGProid = #proid#
												<cfelse>
													and MIGProid is null
												</cfif>
												<cfif isdefined('cueid') and len(trim(cueid))>
													and MIGCueid = #cueid#
												<cfelse>
													and MIGCueid is null
												</cfif>
										</cfquery>
									<cfelse>	
										<cfquery datasource="#session.DSN#"><!--- verificar que este sea por producto o depto o cuenta --->
												Insert into F_Resumen(CEcodigo,Ecodigo,cod_fuente,MIGMid,MIGMesmetrica,periodo,mes,PFecha,tipo,cantidad,resultado,importe,BMUsucodigo,fechaalta,Dcodigo,MIGProid,MIGCueid,control,periodo_tipo)
												VALUES(#rsFormulas.CEcodigo#,#rsFormulas.Ecodigo#,-1,#MIGMid_actual#,'M',#periodoCal#,-1,
												<cfqueryparam cfsqltype="cf_sql_date" value="#pfechaCal#">,
												'S',
													-1,
												#LSNumberFormat(rs,'99.9999')#,-1,1,#now()#,
												<cfif isdefined('Dcod') and len(trim(Dcod))><!---Dcodigo,MIGProid,MIGCueid--->
													#Dcod#
												<cfelse>
													null
												</cfif>
												,
												<cfif isdefined('proid') and len(trim(proid))>
													#proid#
												<cfelse>
													null
												</cfif>
												,
												<cfif isdefined('cueid') and len(trim(cueid))>
													#cueid#
												<cfelse>
													null
												</cfif>
												,3
												,'#periodoTipo_actual#'
												)
											</cfquery>
									 </cfif>
								</cfif>
						</cfif><!---RESULT--->
					</cfloop>
				</cfif>
			</cfloop>
			
			<cfreturn #msj#>	
	</cffunction>
	
	
	
	<!---PROCESO DE CALCULO DE METRICAS DERIVADAS--->
	<cffunction name="CalculoMetricasDerivadas" access="remote" returntype="string">
		<cfargument name="MIGMID" 		type="numeric" required="no" default="">
		<cfargument name="Periodo" 		type="string" required="no" default="">
		<cfargument name="Pinicio" 		type="string" required="no" default=""><!---fechas de periocidad inicio--->
		<cfargument name="Pfin" 		type="string" required="no" default=""><!---fechas de periocidad hasta--->--->
		<cfargument name="CEcodigo" 	type="numeric" default="#session.CEcodigo#">
		<cfargument name="Ecodigo" 		type="numeric" default="#session.Ecodigo#">
		<cfargument name="DSN" 			type="string"	default="#session.DSN#">
		<cfargument name="todos" 		type="boolean" required="no" default="false">
		<cfset msj = ''>
		
		<cf_dbfunction2 name="OP_concat"	returnvariable="_Cat">
		
		<cfset listPeriodos = "">
		<cfif isdefined('Arguments.Pinicio') and len(trim(Arguments.Pinicio))>
			<cfset listPeriodos = getRangoPeriodos(MIGMID='#Arguments.MIGMID#',Pinicio='#Arguments.Pinicio#',Pfin='#Arguments.Pfin#',CEcodigo='#Arguments.CEcodigo#',Ecodigo='#Arguments.Ecodigo#',DSN='#Arguments.DSN#')>
		</cfif>
		
			<!--- Formulas de las de Metricas--->
			<cfquery datasource="#session.DSN#" name="rsFormulas">
				select *
				from MIGMetricas a
				WHERE a.MIGMesmetrica = 'M'
					and a.dactiva = 1
					<cfif isdefined('Arguments.MIGMID') and len(trim(Arguments.MIGMID)) and Arguments.MIGMID GT 0>
					and a.MIGMid = #Arguments.MIGMID#
					</cfif>
					<cfif isdefined('calculadosList') and len(trim(calculadosList))>
					and a.MIGMid not in (<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#calculadosList#">)
					</cfif>
					<cfif isdefined('Arguments.Ecodigo') and len(trim(Arguments.Ecodigo))>
					and Ecodigo = #Arguments.Ecodigo#
					</cfif>
					order by MIGMsequencia	
			</cfquery>
			
			<cfloop query="rsFormulas">
				<cfset derivada_actual = rsFormulas.MIGMid>
				<cfset derivada_periodicidad = rsFormulas.MIGMperiodicidad>
				<cfset derivada_formula = rsFormulas.MIGMcalculo>
				<cfset derivada_codigo = rsFormulas.MIGMcodigo>
				<cfset derivada_tipoDetalle = rsFormulas.MIGMtipodetalle>
				<cfset derivada_corporativo = rsFormulas.MIGMescorporativo>
				
				<!---sacar la lista de filtros para la derivada actual--->
				<cfquery datasource="#Arguments.DSN#" name="rsFiltrosmetricas">
					select * from MIGFiltrosmetricas where MIGMid = #derivada_actual#
					order by MIGMdetalleid
				</cfquery>
				
				<!---sacar la lista de las metricas y detalles para esa derivada--->
				<cfquery datasource="#Arguments.DSN#" name="rsFiltrosderivadas">
					select * from MIGFiltrosderivadas where MIGMidderivada = #derivada_actual#
					order by MIGMidderivada, MIGMid 
				</cfquery>
				
				<!---sacar la lista de las metricas --->
				<cfquery  dbtype="query" name="rsMetricasXderivada">
					select distinct MIGMid from rsFiltrosderivadas order by MIGMid 
				</cfquery>
				<cfset listMetXP = ''>
				<cfif rsMetricasXderivada.recordCount GT 0>
					<cfset listMetXP = valuelist(rsMetricasXderivada.MIGMid)>
				</cfif>
				
				<!---definicion de los o el periodo a calcular--->
				<cfif not len(trim(Arguments.Periodo)) and not len(trim(Arguments.Pinicio))>	<!---periodo de la derivada actual para la metrica actual si el mismo no viene definido--->
					<!---obtine las fechas del periodo que estamos calculando para la derivada--->
					<cfinvoke component="utils" method="fnDSNdestino" returnvariable="dsnA"/>
					<cfinvoke component="utils" method="fnFechaToPeriodo" returnvariable="rsPerioA">
						<cfinvokeargument name="dsn" 		value="#dsnA#"/>
						<cfinvokeargument name="Fecha_ORI" 	value="#LSDateFormat(now())#"/>
						<cfinvokeargument name="Tipo_DST" 	value="#derivada_periodicidad#"/>
					</cfinvoke>
					<cfset listPeriodos = rsPerioA.Per>
				</cfif>
				<cfif len(trim(Arguments.Periodo))>												<!---periodo de la derivada definido si se hace por rango de periodos la lista se define al inicio de la funcion --->
					<cfset listPeriodos = Arguments.Periodo>
				</cfif>
				
				<cfloop list="#listperiodos#" index="periodo_actual">									<!--- calculo de la derivada x periodo--->
						
						<!---obtine las fechas del periodo que estamos calculando para la derivada--->
						<cfinvoke component="utils" method="fnDSNdestino" returnvariable="dsnA"/>
			
						<cfinvoke component="utils" method="fnPeriodoToFecha" returnvariable="rsPfecha">
							<cfinvokeargument name="dsn" 		value="#dsnA#"/>
							<cfinvokeargument name="Valor_ORI" 	value="#trim(periodo_actual)#"/>
							<cfinvokeargument name="Tipo_ORI" 	value="#derivada_periodicidad#"/>
						</cfinvoke>
						<cfif not isdefined('rsPfecha.fin') or not len(trim(rsPfecha.fin))>
							<cfset rsPfecha.fin = now()>
							<cfset rsPfecha.ini = now()>
						</cfif>
						<!---<cf_dump var="#rsPfecha#">(*)--->
						<cfset derivada_pfecha = rsPfecha.fin>
							
						<cfset DatosVariables = "">
						<cfset listaBlancos = "">
						<cfloop list="#listMetXP#" index="Metrica_actual">						<!---Generacion de los datos variables por periodo para la derivada segun la lista de metricas por la cual se compone--->
								<!---GENERAR RECALCULO DE METRICAS QUE COMPONEN LA DERIVADA--->
								<!---En esta parte genera resultados calculados sobre F_datos y los agrega en F_Resuldos y F_resumen --->
								
								<!---Generacion de las variables para el calculo la derivada --->
								<cfquery datasource="#Arguments.DSN#" name="rsMetPeriodicidad">	<!---periodicidad de las metricas --->
									select MIGMperiodicidad,MIGMcalculo,MIGMcodigo from MIGMetricas where MIGMid = #Metrica_actual#
									order by MIGMid 
								</cfquery>
								<cfset metrica_periodicidad= rsMetPeriodicidad.MIGMperiodicidad>
								<cfset metrica_codigo= rsMetPeriodicidad.MIGMcodigo>
								
								<cfset formula= ''>												<!---determina si existe una formula--->
								<cfif isdefined('rsMetPeriodicidad.MIGMcalculo') and len(trim(rsMetPeriodicidad.MIGMcalculo))>
								<cfset formula= rsMetPeriodicidad.MIGMcalculo>
								</cfif>
								
								<!---tipo y lista de detalles para una metrica que compone una derivada--->
								<cfquery  dbtype="query" name="rsDetalles">
									select * from rsFiltrosderivadas where MIGMid = #Metrica_actual#
								</cfquery>
								
								<cfset listDetalles = ''>
								<cfset tipoDetalle = 'D'>
								<cfif rsDetalles.recordCount GT 0>
									<cfset listDetalles = valuelist(rsDetalles.MIGMdetalleid)>
									<cfset tipoDetalle = rsDetalles.MIGMtipodetalle>
								</cfif>
								
								<cfinvoke component="utils" method="fnDSNdestino" returnvariable="dsnA"/>
								 	
								<cfinvoke component="utils" method="fnPeriodoConversion" returnvariable="ListConvert">
									<cfinvokeargument name="dsn" 		value="#dsnA#"/>
									<cfinvokeargument name="Valor_ORI" 	value="#trim(periodo_actual)#"/>
									<cfinvokeargument name="Tipo_ORI" 	value="#derivada_periodicidad#"/>
									<cfinvokeargument name="Tipo_DST" 	value="#metrica_periodicidad#"/>
								</cfinvoke>
								<cfif not isdefined('ListConvert.fin') or not len(trim(ListConvert.fin))>
									<cfset ListConvert.fin = trim(periodo_actual)>
									<cfset ListConvert.ini = trim(periodo_actual)>
								</cfif>
								
								<!--- CALCULO DE DATOS DE UNA METRICA PARA CALCULAR UNA DERIVADA (MISMO PROCESO PARA INDICADORES) --->
								<!---Datos que va a tomar en cuenta la derivada para la formula (variables). Los posibles casos de este query que genera el valor 
								para le metrica que queremos usar en la formula de la derivada, serian: 
									
									*si la metrica no posee formula y esta en la misma periodicidad de la derivada: 
										este caso es el mas simple, el valor para metrica seria el resultado del query rsBaseCalcInd que devolvería un unico registro, 
									
									*si la metrica no  posee formula y esta en diferente periodicidad de la derivada:
										Este caso seria la sumatoria del valor de la metrica de los diferntes periodos 
										
									*si la metrica posee una formula y esta en la misma periodicidad de la derivada:
										 el query rsBaseCalcInd devolveria diferentes metricas con valores validos para el recalculo de la metrica que necesitamos averiguar
										 con lleba generar variables, agregar la varibles en blanco, agregar la formula, pasarlo a la calculadora y el resultado seria 
										 igual la metrica que deseamos averiguar.
									
									*si la metrica posee una formula y esta en diferente periodicidad de la derivada:
										por cada periodo diferente que obtengamos en el query rsBaseCalcInd, necesitamos generar variables, hacer calculo para ese periodo 
										y asi para los demas periodos. y sumarlos para obtener el valor realcalculado para ese metrica con distinta pericidad. Es decir
										el valor de la metrica seria la sumatoria de los resultados que genere la formula x periodo.
										 --->
										
								<cfquery datasource="#session.DSN#" name="rsBaseCalcInd">
									select 
										a.MIGMid
										,b.MIGMcodigo
										<cfif tipodetalle is 'D'>
										,a.Dcodigo
										</cfif>
										<cfif tipodetalle is 'P'>
										,a.MIGProid
										</cfif>
										<cfif tipodetalle is 'C'>
										,a.MIGCueid
										</cfif>
										,a.periodo
										,a.Pfecha
										,a.CEcodigo
										,a.Ecodigo
										,a.mes
										,SUM(a.valor) as resultado
										,SUM(a.cantidad) as cantidad
										
									from F_DATOS a 
									inner join MIGMetricas b
									on b.MIGMid = a.MIGMid
									WHERE 
										<cfif not isdefined('derivada_corporativo') or derivada_corporativo NEQ 1>
										a.Ecodigo = #Arguments.Ecodigo#
										and </cfif>
										a.CEcodigo = #Arguments.CEcodigo#
										and a.MIGMid is not null 
										and a.periodo <= #ListConvert.fin#						<!---filtra por el rango de periodos de la metrica actual, puede generar metricas repetidas pero con diferente periodo, esto de corige mas adelante dependiendo del caso si tiene formala la metrica que queremos calcular primero se calcula para cada periodo y despues se realiza la sumatoria, de no tener formula solo se suman los diferentes periodos--->
										and a.periodo >= #ListConvert.ini#
										and a.periodo_tipo = '#metrica_periodicidad#'
										
										<cfif not len(trim(formula))>
										and a.MIGMid = #Metrica_actual#
										</cfif>
										
										<cfif isdefined('listDetalles') and len(trim(listDetalles))>
											<cfif tipodetalle is 'D'>
											and a.Dcodigo in(<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#listDetalles#">)
											</cfif>
											<cfif tipodetalle is 'P'>
											and a.MIGproid in(<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#listDetalles#">)
											</cfif>
											<cfif tipodetalle is 'C'>
											and a.MIGcueid in(<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#listDetalles#">)
											</cfif>
										</cfif>
										
										group by a.MIGMid
											,b.MIGMcodigo
											<cfif tipodetalle is 'D'>
											,a.Dcodigo
											</cfif>
											<cfif tipodetalle is 'P'>
											,a.MIGProid
											</cfif>
											<cfif tipodetalle is 'C'>
											,a.MIGCueid
											</cfif>
											,a.periodo	
											,a.Pfecha
											,a.CECODIGO
											,a.ECODIGO
											,a.mes
										
										order by a.MIGMid
											,b.MIGMcodigo
											<cfif tipodetalle is 'D'>
											,a.Dcodigo
											</cfif>
											<cfif tipodetalle is 'P'>
											,a.MIGProid
											</cfif>
											<cfif tipodetalle is 'C'>
											,a.MIGCueid
											</cfif>
											,a.periodo
											,a.Pfecha
											,a.CECODIGO
											,a.ECODIGO 
											,a.mes
								</cfquery>
								
								<!---  --->
								<cfif len(trim(formula))>	<!---Una metrica que es parte de una derivada, puede poseer o no una formula--->
									
										<cfquery dbtype="query" name="rsPeriodos">
											select distinct periodo from rsBaseCalcInd 
											order by periodo
										</cfquery>
										<cfset mPeriodoList = valuelist(rsPeriodos.periodo)>
										
										<!---calculo de la metrica por periodo y sumatoria--->
										<cfset resultadoMetrica = 0>
										<cfloop list="#mPeriodoList#" index="periodo_metrica_temp">
											
											<cfquery dbtype="query" name="rsBaseCalMet">
												select * from rsBaseCalcInd where periodo=#periodo_metrica_temp# 
												order by MIGMid
											</cfquery>
											
											<cfset listaBlancosM = ''>
											<cfset DatosVariablesMet = ''>
											<cfloop query="rsBaseCalMet">
												<cfset listaBlancosM = listaBlancosM & IIF(len(trim(listaBlancosM)),DE(','),DE('')) & rsBaseCalMet.MIGMid>
												<cfsavecontent variable="DatosVariablesMet">
												<cfoutput>#DatosVariablesMet##rsBaseCalMet.MIGMcodigo#=#rsBaseCalMet.resultado#;</cfoutput>
												</cfsavecontent>
											</cfloop>
											
											<cfquery datasource="#Arguments.DSN#" name="rsVariablesxPeriodoWhite">	
												select MIGMid,MIGMcodigo from MIGMetricas 
												where CEcodigo = #Arguments.CEcodigo#
												
												<cfif not isdefined('derivada_corporativo') or derivada_corporativo NEQ 1>
												and  Ecodigo = #Arguments.Ecodigo# 						
												</cfif>
												
												<cfif len(trim(listaBlancosM))>
												and MIGMid not in(<cfqueryparam list="yes" cfsqltype="cf_sql_numeric" value="#listaBlancosM#">)
												</cfif>
												
												order by MIGMid
											</cfquery>
											
											<cfset DatosVariablesWhite = "">
											<cfloop query="rsVariablesxPeriodoWhite">
												<cfsavecontent variable="DatosVariablesWhite">
												<cfoutput>#DatosVariablesWhite##rsVariablesxPeriodoWhite.MIGMcodigo#=0;</cfoutput>
												</cfsavecontent>
											</cfloop>
											
											<cfsavecontent variable="DatosVariablesMet">
											<cfoutput>#DatosVariablesMet##DatosVariablesWhite#</cfoutput>
											</cfsavecontent>
											
											<!---VARIABLES--->
											<cfset VariablesFormula = ''>
											<cfsavecontent variable="VariablesFormula">
											<cfoutput>#DatosVariablesMet# resultado=#formula#;</cfoutput>
											</cfsavecontent>
											
											<!---CALCULADORA--->
											<cfset result = calculate(VariablesFormula)>
											
											<cfif isdefined('session.debug') and session.debug>
												<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" titulo='#metrica_codigo#  Periodo: #periodo_metrica_temp#'>
												<cfdump var="Periodo: #periodo_metrica_temp#">;<br> 
												<cfdump var="#VariablesFormula#">;<br> 
												<cf_web_portlet_end>
											</cfif>
											
											<cfif isdefined('result')>
												<cfset rs = result.get('resultado').toString()>
												<cfset resultadoMetrica = resultadoMetrica + rs>	<!---suma de bido a que debe sumar el resutado para diferentes periodos en caso de que sean diferentes periocidades--->
											</cfif>
											
											<cfif isdefined('session.debug') and session.debug>
											<cfdump var="resultado: #rs#">;<br><br><br>
											</cfif>
											
										</cfloop>
										
										<cfif isdefined('session.debug') and session.debug and resultadoMetrica gt 0>
										<cfdump var="Total: #resultadoMetrica#">; <br><br><br>
										</cfif>
										
										<!---Se agrega en la formula--->
										<cfif resultadoMetrica GT 0>
											<cfset listaBlancos = listaBlancos & IIF(len(trim(listaBlancos)),DE(','),DE('')) & Metrica_actual>
											<cfsavecontent variable="DatosVariables">
											<cfoutput>#DatosVariables##metrica_codigo#=#resultadoMetrica#;</cfoutput>
											</cfsavecontent>
										</cfif>
										
								<cfelse>
										<!--- suma metricas iguales en diferentes periodos eje: caso en que se calcula una derivada Mensual y esta compuesto por una metrica diaria( que trae varios registros para el mes)--->
										<cfquery dbtype="query" name="rsBaseCalcInd">
										select MIGMid,MIGMcodigo
											<!---<cfif tipodetalle is 'D'>
											,Dcodigo
											</cfif>
											<cfif tipodetalle is 'P'>
											,MIGProid
											</cfif>
											<cfif tipodetalle is 'C'>
											,MIGCueid
											</cfif>--->
											,CEcodigo,Ecodigo,mes
											,SUM(resultado) as resultado
											,SUM(cantidad)as cantidad from rsBaseCalcInd
										group by MIGMid,MIGMcodigo
												<!---<cfif tipodetalle is 'D'>
												,Dcodigo
												</cfif>
												<cfif tipodetalle is 'P'>
												,MIGProid
												</cfif>
												<cfif tipodetalle is 'C'>
												,MIGCueid
												</cfif>--->
												,CECODIGO,ECODIGO,mes
										</cfquery>
									
									<cfloop query="rsBaseCalcInd">	
										<cfset listaBlancos = listaBlancos & IIF(len(trim(listaBlancos)),DE(','),DE('')) & rsBaseCalcInd.MIGMid>
										<cfsavecontent variable="DatosVariables">
										<cfoutput>#DatosVariables##rsBaseCalcInd.MIGMcodigo#=#rsBaseCalcInd.resultado#;</cfoutput>
										</cfsavecontent>
									</cfloop>
								</cfif>
								
						</cfloop><!---listMetXP--->	
						
						<cfset session.variablesPrincipales = DatosVariables>
						<!---Genera todas las variables que quedaron por fuera del periodo y los pone en 0--->
						<cfquery datasource="#Arguments.DSN#" name="rsVariablesxPeriodoWhite">	
							select MIGMid,MIGMcodigo from MIGMetricas 
							where CEcodigo = #Arguments.CEcodigo#	
							
							<cfif not isdefined('derivada_corporativo') or derivada_corporativo NEQ 1>
							and Ecodigo = #Arguments.Ecodigo#				
							</cfif>
							
							<cfif len(trim(listaBlancos))>
							and MIGMid not in(<cfqueryparam list="yes" cfsqltype="cf_sql_numeric" value="#listaBlancos#">)
							</cfif>
							
							order by MIGMid
						</cfquery>
											
						<cfset DatosVariablesWhite = "">
						<cfloop query="rsVariablesxPeriodoWhite">
							<cfsavecontent variable="DatosVariablesWhite">
							<cfoutput>#DatosVariablesWhite##rsVariablesxPeriodoWhite.MIGMcodigo#=0;</cfoutput>
							</cfsavecontent>
						</cfloop>
						<cfsavecontent variable="DatosVariables">
						<cfoutput>#DatosVariables##DatosVariablesWhite#</cfoutput>
						</cfsavecontent>
						
						<!---ACA VA EL CALCULO E INSERCIONES RESPECTIVAS--->
						<cfset VariablesFormula = ''>
						<cfsavecontent variable="VariablesFormula">
						<cfoutput>#DatosVariables# resultado=<cfif isdefined('derivada_formula') and len(trim(derivada_formula))>#derivada_formula#<cfelse>#derivada_codigo#</cfif>;</cfoutput>
						</cfsavecontent>
						
						<cfif isdefined('session.debug') and session.debug>
						<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" titulo='Formula final >>  Periodo: #periodo_actual#'>
						<br><string>Formula finalizando</strong><br>
						<cfdump var="#VariablesFormula#"> <br><br><br>
						<cf_web_portlet_end>
						</cfif>
						
						<!---CALCULADORA--->
						<cfset result = calculate(VariablesFormula)>
						
						<cfif isdefined('result')>
							<cfset rs = result.get('resultado').toString()>
							<!---INSERCIONES RESPECTIVAS(*)--->
							
							<!---determinara que depto pertene la derivada--->
							<cfquery datasource="#session.DSN#" name="rsPerteneceA"><!--- Localiza si para F_resultados ya existia el resultado --->
								Select MIGMdetalleid from MIGFiltrosMetricas
								where 
									MIGMid = #derivada_actual#
									and Ecodigo = #Arguments.Ecodigo#
							</cfquery>
							<cfquery datasource="#session.DSN#"><!--- Localiza si para F_resultados ya existia el resultado --->
								Delete F_Resultados
								where 
									MIGMid = #derivada_actual#
									and periodo = #periodo_actual#
									and Ecodigo = #Arguments.Ecodigo#
							</cfquery>
							<cfquery datasource="#session.DSN#"><!--- Localiza si para F_resumen ya existia el resultado --->
								Delete F_Resumen
								where 
									MIGMid = #derivada_actual#
									and periodo = #periodo_actual#
									and Ecodigo = #Arguments.Ecodigo#
							</cfquery>
							<!---<cf_dump var="#derivada_pfecha#">--->
							<cfquery datasource="#session.DSN#"><!--- Agregar derivada por Depto--->
									Insert into F_Resultados(CEcodigo,Ecodigo,cod_fuente,MIGMid,periodo,mes,MIGMesmetrica,pfecha,tipo,cantidad,resultado,importe,BMUsucodigo,fechaalta,Dcodigo,MIGProid,MIGCueid)
									VALUES(#Arguments.CEcodigo#,#Arguments.Ecodigo#,-1,#derivada_actual#,#periodo_actual#,-1,'M'
									,<cfqueryparam cfsqltype="cf_sql_date" value="#derivada_pfecha#">
									,'S'
									,-1
									,#LSNumberFormat(rs,'99.9999')#,-1,1,#now()#
									<cfif derivada_tipoDetalle is 'P'>
										,null
										,#rsPerteneceA.MIGMdetalleid#
										,null
									<cfelseif derivada_tipoDetalle is 'C'>
										,null
										,null
										,#rsPerteneceA.MIGMdetalleid#
									<cfelse>
										,#rsPerteneceA.MIGMdetalleid#
										,null
										,null
									</cfif>
									)
							</cfquery>
							
							<cfquery datasource="#session.DSN#"><!--- Agregar derivada por Depto--->
									Insert into F_Resumen(CEcodigo,Ecodigo,cod_fuente,MIGMid,periodo,mes,MIGMesmetrica,pfecha,tipo,cantidad,resultado,importe,BMUsucodigo,fechaalta,Dcodigo,MIGProid,MIGCueid,control)
									VALUES(#Arguments.CEcodigo#,#Arguments.Ecodigo#,-1,#derivada_actual#,#periodo_actual#,-1,'M'
									,<cfqueryparam cfsqltype="cf_sql_date" value="#derivada_pfecha#">
									,'S'
									,-1
									,#LSNumberFormat(rs,'99.9999')#,-1,1,#now()#
									<cfif derivada_tipoDetalle is 'P'>
										,null
										,#rsPerteneceA.MIGMdetalleid#
										,null
									<cfelseif derivada_tipoDetalle is 'C'>
										,null
										,null
										,#rsPerteneceA.MIGMdetalleid#
									<cfelse>
										,#rsPerteneceA.MIGMdetalleid#
										,null
										,null
									</cfif>
									,3
									)
							</cfquery>
							
						</cfif>
							
				</cfloop><!---listperiodos--->
				
			</cfloop><!---rsFormulas--->
			
			<cfreturn #msj#>	
	</cffunction>
	
	<!---PROCESO DE CALCULO DE INDICADORES--->
	<cffunction name="CalculoIndicadores" access="remote" returntype="string">
		<cfargument name="MIGMID" 		type="numeric" required="no" default="">
		<cfargument name="Periodo" 		type="string" required="no" default="">
		<cfargument name="Pinicio" 		type="string" required="no" default=""><!---fechas de periocidad inicio--->
		<cfargument name="Pfin" 		type="string" required="no" default=""><!---fechas de periocidad hasta--->--->
		<cfargument name="CEcodigo" 	type="numeric" default="#session.CEcodigo#">
		<cfargument name="Ecodigo" 		type="numeric" default="#session.Ecodigo#">
		<cfargument name="DSN" 			type="string"	default="#session.DSN#">
		<cfargument name="todos" 		type="boolean" required="no" default="false">
		<cfset msj = ''>
		
		<cf_dbfunction2 name="OP_concat"	returnvariable="_Cat">
		
		<cfset listPeriodos = "">
		<cfif isdefined('Arguments.Pinicio') and len(trim(Arguments.Pinicio))>
			<cfset listPeriodos = getRangoPeriodos(MIGMID='#Arguments.MIGMID#',Pinicio='#Arguments.Pinicio#',Pfin='#Arguments.Pfin#',CEcodigo='#Arguments.CEcodigo#',Ecodigo='#Arguments.Ecodigo#',DSN='#Arguments.DSN#')>
		</cfif>
		
			<!--- Formulas de las de Metricas--->
			<cfquery datasource="#session.DSN#" name="rsFormulas">
				select *
				from MIGMetricas a
				WHERE a.MIGMesmetrica = 'I'
					and a.dactiva = 1
					<cfif isdefined('Arguments.MIGMID') and len(trim(Arguments.MIGMID)) and Arguments.MIGMID GT 0>
					and a.MIGMid = #Arguments.MIGMID#
					</cfif>
					<cfif isdefined('calculadosList') and len(trim(calculadosList))>
					and a.MIGMid not in (<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#calculadosList#">)
					</cfif>
					<cfif isdefined('Arguments.Ecodigo') and len(trim(Arguments.Ecodigo))>
					and Ecodigo = #Arguments.Ecodigo#
					</cfif>
					order by MIGMsequencia	
			</cfquery>
			
			<cfloop query="rsFormulas">
				<cfset indicador_actual = rsFormulas.MIGMid>
				<cfset indicador_periodicidad = rsFormulas.MIGMperiodicidad>
				<cfset indicador_formula = rsFormulas.MIGMcalculo>
				<cfset indicador_codigo = rsFormulas.MIGMcodigo>
				<cfset indicador_tipoDetalle = rsFormulas.MIGMtipodetalle>
				<cfset indicador_corporativo = rsFormulas.MIGMescorporativo>
				
				<!---sacar la lista de filtros para el indicador actual--->
				<cfquery datasource="#Arguments.DSN#" name="rsFiltrosmetricas">
					select * from MIGFiltrosmetricas where MIGMid = #indicador_actual#
					order by MIGMdetalleid
				</cfquery>
				
				
				<!---sacar la lista de las metricas y detalles para ese indicador--->
				<cfquery datasource="#Arguments.DSN#" name="rsFiltrosindicadores">
					select * from MIGFiltrosindicadores where MIGMidindicador = #indicador_actual#
					order by MIGMidindicador, MIGMid 
				</cfquery>
				
				<!---sacar la lista de las metricas --->
				<cfquery  dbtype="query" name="rsMetricasXIndicador">
					select distinct MIGMid from rsFiltrosindicadores order by MIGMid 
				</cfquery>
				<cfset listMetXP = ''>
				<cfif rsMetricasXIndicador.recordCount GT 0>
					<cfset listMetXP = valuelist(rsMetricasXIndicador.MIGMid)>
				</cfif>
				
				<!---definicion de los o el periodo a calcular--->
				<cfif not len(trim(Arguments.Periodo)) and not len(trim(Arguments.Pinicio))>	<!---periodo del indicador actual para la metrica actual si el mismo no viene definido--->
					<!---obtine las fechas del periodo que estamos calculando para el indicador--->
					<cfinvoke component="utils" method="fnDSNdestino" returnvariable="dsnA"/>
					<cfinvoke component="utils" method="fnFechaToPeriodo" returnvariable="rsPerioA">
						<cfinvokeargument name="dsn" 		value="#dsnA#"/>
						<cfinvokeargument name="Fecha_ORI" 	value="#LSDateFormat(now())#"/>
						<cfinvokeargument name="Tipo_DST" 	value="#indicador_periodicidad#"/>
					</cfinvoke>
					<cfset listPeriodos = rsPerioA.Per>
				</cfif>
				<cfif len(trim(Arguments.Periodo))>												<!---periodo del indicador definido si se hace por rango de periodos la lista se define al inicio de la funcion --->
					<cfset listPeriodos = Arguments.Periodo>
				</cfif>
				
				<cfloop list="#listperiodos#" index="periodo_actual">									<!--- calculo del indicador x periodo--->
						
						<!---obtine las fechas del periodo que estamos calculando para el indicador--->
						<cfinvoke component="utils" method="fnDSNdestino" returnvariable="dsnA"/>
			
						<cfinvoke component="utils" method="fnPeriodoToFecha" returnvariable="rsPfecha">
							<cfinvokeargument name="dsn" 		value="#dsnA#"/>
							<cfinvokeargument name="Valor_ORI" 	value="#trim(periodo_actual)#"/>
							<cfinvokeargument name="Tipo_ORI" 	value="#indicador_periodicidad#"/>
						</cfinvoke>
						<cfif not isdefined('rsPfecha.fin') or not len(trim(rsPfecha.fin))>
							<cfset rsPfecha.fin = now()>
							<cfset rsPfecha.ini = now()>
						</cfif>
						<!---<cf_dump var="#rsPfecha#">(*)--->
						<cfset indicador_pfecha = rsPfecha.fin>
							
						<cfset DatosVariables = "">
						<cfset listaBlancos = "">
						<cfloop list="#listMetXP#" index="Metrica_actual">						<!---Generacion de los datos variables por periodo para el indicador segun la lista de metricas por la cual se compone--->
								<!---GENERAR RECALCULO DE METRICAS QUE COMPONEN EL INDICADOR--->
								<!---En esta parte genera resultados calculados sobre F_datos y los agrega en F_Resuldos y F_resumen --->
								
								<!---Generacion de las variables para el calculo del indicador --->
								<cfquery datasource="#Arguments.DSN#" name="rsMetPeriodicidad">	<!---periodicidad de las metricas --->
									select MIGMperiodicidad,MIGMcalculo,MIGMcodigo from MIGMetricas where MIGMid = #Metrica_actual#
									order by MIGMid 
								</cfquery>
								<cfset metrica_periodicidad= rsMetPeriodicidad.MIGMperiodicidad>
								<cfset metrica_codigo= rsMetPeriodicidad.MIGMcodigo>
								
								<cfset formula= ''>												<!---determina si existe una formula--->
								<cfif isdefined('rsMetPeriodicidad.MIGMcalculo') and len(trim(rsMetPeriodicidad.MIGMcalculo))>
								<cfset formula= rsMetPeriodicidad.MIGMcalculo>
								</cfif>
								
								<!---tipo y lista de detalles para una metrica que compone un indicador--->
								<cfquery  dbtype="query" name="rsDetalles">
									select * from rsFiltrosindicadores where MIGMid = #Metrica_actual#
								</cfquery>
								
								<cfset listDetalles = ''>
								<cfset tipoDetalle = 'D'>
								<cfif rsDetalles.recordCount GT 0>
									<cfset listDetalles = valuelist(rsDetalles.MIGMdetalleid)>
									<cfset tipoDetalle = rsDetalles.MIGMtipodetalle>
								</cfif>
								
								<cfinvoke component="utils" method="fnDSNdestino" returnvariable="dsnA"/>
								 	
								<cfinvoke component="utils" method="fnPeriodoConversion" returnvariable="ListConvert">
									<cfinvokeargument name="dsn" 		value="#dsnA#"/>
									<cfinvokeargument name="Valor_ORI" 	value="#trim(periodo_actual)#"/>
									<cfinvokeargument name="Tipo_ORI" 	value="#indicador_periodicidad#"/>
									<cfinvokeargument name="Tipo_DST" 	value="#metrica_periodicidad#"/>
								</cfinvoke>
								<cfif not isdefined('ListConvert.fin') or not len(trim(ListConvert.fin))>
									<cfset ListConvert.fin = trim(periodo_actual)>
									<cfset ListConvert.ini = trim(periodo_actual)>
								</cfif>
								
								<!--- CALCULO DE DATOS DE UNA METRICA PARA CALCULAR UN INDICADOR --->
								<!---Datos que va a tomar en cuenta el indicador para la formula (variables). Los posibles casos de este query que genera el valor 
								para le metrica que queremos usar en la formula del indicador, serian: 
									
									*si la metrica no posee formula y esta en la misma periodicidad del indicador: 
										este caso es el mas simple, el valor para metrica seria el resultado del query rsBaseCalcInd que devolvería un unico registro, 
									
									*si la metrica no  posee formula y esta en diferente periodicidad del indicador:
										Este caso seria la sumatoria del valor de la metrica de los diferntes periodos 
										
									*si la metrica posee una formula y esta en la misma periodicidad del indicador:
										 el query rsBaseCalcInd devolveria diferentes metricas con valores validos para el recalculo de la metrica que necesitamos averiguar
										 con lleba generar variables, agregar la varibles en blanco, agregar la formula, pasarlo a la calculadora y el resultado seria 
										 igual la metrica que deseamos averiguar.
									
									*si la metrica posee una formula y esta en diferente periodicidad del indicador:
										por cada periodo diferente que obtengamos en el query rsBaseCalcInd, necesitamos generar variables, hacer calculo para ese periodo 
										y asi para los demas periodos. y sumarlos para obtener el valor realcalculado para ese metrica con distinta pericidad. Es decir
										el valor de la metrica seria la sumatoria de los resultados que genere la formula x periodo.
										 --->
								<cfquery datasource="#session.DSN#" name="rsBaseCalcInd">
									select 
										a.MIGMid
										,b.MIGMcodigo
										<cfif tipodetalle is 'D'>
										,a.Dcodigo
										</cfif>
										<cfif tipodetalle is 'P'>
										,a.MIGProid
										</cfif>
										<cfif tipodetalle is 'C'>
										,a.MIGCueid
										</cfif>
										,a.periodo
										,a.Pfecha
										,a.CEcodigo
										,a.Ecodigo
										,a.mes
										,SUM(a.valor) as resultado
										,SUM(a.cantidad) as cantidad
										
									from F_DATOS a 
									inner join MIGMetricas b
									on b.MIGMid = a.MIGMid
									WHERE 
										<cfif not isdefined('indicador_corporativo') or indicador_corporativo NEQ 1>
										a.Ecodigo = #Arguments.Ecodigo#
										and </cfif>
										a.CEcodigo = #Arguments.CEcodigo#
										and a.MIGMid is not null 
										and a.periodo <= #ListConvert.fin#						<!---filtra por el rango de periodos de la metrica actual, puede generar metricas repetidas pero con diferente periodo, esto de corige mas adelante dependiendo del caso si tiene formala la metrica que queremos calcular primero se calcula para cada periodo y despues se realiza la sumatoria, de no tener formula solo se suman los diferentes periodos--->
										and a.periodo >= #ListConvert.ini#
										and a.periodo_tipo = '#metrica_periodicidad#'
										
										<cfif not len(trim(formula))>
										and a.MIGMid = #Metrica_actual#
										</cfif>
										
										<cfif isdefined('listDetalles') and len(trim(listDetalles))>
											<cfif tipodetalle is 'D'>
											and a.Dcodigo in(<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#listDetalles#">)
											</cfif>
											<cfif tipodetalle is 'P'>
											and a.MIGproid in(<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#listDetalles#">)
											</cfif>
											<cfif tipodetalle is 'C'>
											and a.MIGcueid in(<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#listDetalles#">)
											</cfif>
										</cfif>
										
										group by a.MIGMid
											,b.MIGMcodigo
											<cfif tipodetalle is 'D'>
											,a.Dcodigo
											</cfif>
											<cfif tipodetalle is 'P'>
											,a.MIGProid
											</cfif>
											<cfif tipodetalle is 'C'>
											,a.MIGCueid
											</cfif>
											,a.periodo	
											,a.Pfecha
											,a.CECODIGO
											,a.ECODIGO
											,a.mes
										
										order by a.MIGMid
											,b.MIGMcodigo
											<cfif tipodetalle is 'D'>
											,a.Dcodigo
											</cfif>
											<cfif tipodetalle is 'P'>
											,a.MIGProid
											</cfif>
											<cfif tipodetalle is 'C'>
											,a.MIGCueid
											</cfif>
											,a.periodo
											,a.Pfecha
											,a.CECODIGO
											,a.ECODIGO 
											,a.mes
								</cfquery>
								
								<!---  --->
								<cfif len(trim(formula))>	<!---Una metrica que es parte de un indicador, puede poseer o no una formula--->
									
										<cfquery dbtype="query" name="rsPeriodos">
											select distinct periodo from rsBaseCalcInd 
											order by periodo
										</cfquery>
										<cfset mPeriodoList = valuelist(rsPeriodos.periodo)>
										
										<!---calculo de la metrica por periodo y sumatoria--->
										<cfset resultadoMetrica = 0>
										<cfloop list="#mPeriodoList#" index="periodo_metrica_temp">
											
											<cfquery dbtype="query" name="rsBaseCalMet">
												select * from rsBaseCalcInd where periodo=#periodo_metrica_temp# 
												order by MIGMid
											</cfquery>
											
											<cfset listaBlancosM = ''>
											<cfset DatosVariablesMet = ''>
											<cfloop query="rsBaseCalMet">
												<cfset listaBlancosM = listaBlancosM & IIF(len(trim(listaBlancosM)),DE(','),DE('')) & rsBaseCalMet.MIGMid>
												<cfsavecontent variable="DatosVariablesMet">
												<cfoutput>#DatosVariablesMet##rsBaseCalMet.MIGMcodigo#=#rsBaseCalMet.resultado#;</cfoutput>
												</cfsavecontent>
											</cfloop>
											
											<cfquery datasource="#Arguments.DSN#" name="rsVariablesxPeriodoWhite">	
												select MIGMid,MIGMcodigo from MIGMetricas 
												where CEcodigo = #Arguments.CEcodigo#
												
												<cfif not isdefined('indicador_corporativo') or indicador_corporativo NEQ 1>
												and  Ecodigo = #Arguments.Ecodigo# 						
												</cfif>
												
												<cfif len(trim(listaBlancosM))>
												and MIGMid not in(<cfqueryparam list="yes" cfsqltype="cf_sql_numeric" value="#listaBlancosM#">)
												</cfif>
												
												order by MIGMid
											</cfquery>
											
											<cfset DatosVariablesWhite = "">
											<cfloop query="rsVariablesxPeriodoWhite">
												<cfsavecontent variable="DatosVariablesWhite">
												<cfoutput>#DatosVariablesWhite##rsVariablesxPeriodoWhite.MIGMcodigo#=0;</cfoutput>
												</cfsavecontent>
											</cfloop>
											
											<cfsavecontent variable="DatosVariablesMet">
											<cfoutput>#DatosVariablesMet##DatosVariablesWhite#</cfoutput>
											</cfsavecontent>
											
											<!---VARIABLES--->
											<cfset VariablesFormula = ''>
											<cfsavecontent variable="VariablesFormula">
											<cfoutput>#DatosVariablesMet# resultado=#formula#;</cfoutput>
											</cfsavecontent>
											
											<!---CALCULADORA--->
											<cfset result = calculate(VariablesFormula)>
											
											<cfif isdefined('session.debug') and session.debug>
												<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" titulo='#metrica_codigo#  Periodo: #periodo_metrica_temp#'>
												<cfdump var="Periodo: #periodo_metrica_temp#">;<br> 
												<cfdump var="#VariablesFormula#">;<br> 
												<cf_web_portlet_end>
											</cfif>
											
											<cfif isdefined('result')>
												<cfset rs = result.get('resultado').toString()>
												<cfset resultadoMetrica = resultadoMetrica + rs>	<!---suma de bido a que debe sumar el resutado para diferentes periodos en caso de que sean diferentes periocidades--->
											</cfif>
											
											<cfif isdefined('session.debug') and session.debug>
											<cfdump var="resultado: #rs#">;<br><br><br>
											</cfif>
											
										</cfloop>
										
										<cfif isdefined('session.debug') and session.debug and resultadoMetrica gt 0>
										<cfdump var="Total: #resultadoMetrica#">; <br><br><br>
										</cfif>
										
										<!---Se agrega en la formula--->
										<cfif resultadoMetrica GT 0>
											<cfset listaBlancos = listaBlancos & IIF(len(trim(listaBlancos)),DE(','),DE('')) & Metrica_actual>
											<cfsavecontent variable="DatosVariables">
											<cfoutput>#DatosVariables##metrica_codigo#=#resultadoMetrica#;</cfoutput>
											</cfsavecontent>
										</cfif>
										
								<cfelse>
										<!--- suma metricas iguales en diferentes periodos eje: caso en que se calcula un indicador Mensual y esta compuesto por una metrica diaria( que trae varios registros para el mes)--->
										<cfquery dbtype="query" name="rsBaseCalcInd">
										select MIGMid,MIGMcodigo
											<!---<cfif tipodetalle is 'D'>
											,Dcodigo
											</cfif>
											<cfif tipodetalle is 'P'>
											,MIGProid
											</cfif>
											<cfif tipodetalle is 'C'>
											,MIGCueid
											</cfif>--->
											,CEcodigo,Ecodigo,mes
											,SUM(resultado) as resultado
											,SUM(cantidad)as cantidad from rsBaseCalcInd
										group by MIGMid,MIGMcodigo
												<!---<cfif tipodetalle is 'D'>
												,Dcodigo
												</cfif>
												<cfif tipodetalle is 'P'>
												,MIGProid
												</cfif>
												<cfif tipodetalle is 'C'>
												,MIGCueid
												</cfif>--->
												,CECODIGO,ECODIGO,mes
										</cfquery>
									
									<cfloop query="rsBaseCalcInd">	
										<cfset listaBlancos = listaBlancos & IIF(len(trim(listaBlancos)),DE(','),DE('')) & rsBaseCalcInd.MIGMid>
										<cfsavecontent variable="DatosVariables">
										<cfoutput>#DatosVariables##rsBaseCalcInd.MIGMcodigo#=#rsBaseCalcInd.resultado#;</cfoutput>
										</cfsavecontent>
									</cfloop>
								</cfif>
								
						</cfloop><!---listMetXP--->	
						
						<cfset session.variablesPrincipales = DatosVariables>
						<!---Genera todas las variables que quedaron por fuera del periodo y los pone en 0--->
						<cfquery datasource="#Arguments.DSN#" name="rsVariablesxPeriodoWhite">	
							select MIGMid,MIGMcodigo from MIGMetricas 
							where CEcodigo = #Arguments.CEcodigo#	
							
							<cfif not isdefined('indicador_corporativo') or indicador_corporativo NEQ 1>
							and Ecodigo = #Arguments.Ecodigo#				
							</cfif>
							
							<cfif len(trim(listaBlancos))>
							and MIGMid not in(<cfqueryparam list="yes" cfsqltype="cf_sql_numeric" value="#listaBlancos#">)
							</cfif>
							
							order by MIGMid
						</cfquery>
											
						<cfset DatosVariablesWhite = "">
						<cfloop query="rsVariablesxPeriodoWhite">
							<cfsavecontent variable="DatosVariablesWhite">
							<cfoutput>#DatosVariablesWhite##rsVariablesxPeriodoWhite.MIGMcodigo#=0;</cfoutput>
							</cfsavecontent>
						</cfloop>
						<cfsavecontent variable="DatosVariables">
						<cfoutput>#DatosVariables##DatosVariablesWhite#</cfoutput>
						</cfsavecontent>
						
						<!---ACA VA EL CALCULO E INSERCIONES RESPECTIVAS--->
						<cfset VariablesFormula = ''>
						<cfsavecontent variable="VariablesFormula">
						<cfoutput>#DatosVariables# resultado=<cfif isdefined('indicador_formula') and len(trim(indicador_formula))>#indicador_formula#<cfelse>#indicador_codigo#</cfif>;</cfoutput>
						</cfsavecontent>
						
						<cfif isdefined('session.debug') and session.debug>
						<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" titulo='Formula final >>  Periodo: #periodo_actual#'>
						<br><string>Formula finalizando</strong><br>
						<cfdump var="#VariablesFormula#"> <br><br><br>
						<cf_web_portlet_end>
						</cfif>
						
						<!---CALCULADORA--->
						<cfset result = calculate(VariablesFormula)>
						
						<cfif isdefined('result')>
							<cfset rs = result.get('resultado').toString()>
							<!---INSERCIONES RESPECTIVAS(*)--->
							
							<!---determinara que depto pertene el indicador--->
							<cfquery datasource="#session.DSN#" name="rsPerteneceA"><!--- Localiza si para F_resultados ya existia el resultado --->
								Select MIGMdetalleid from MIGFiltrosMetricas
								where 
									MIGMid = #indicador_actual#
									and Ecodigo = #Arguments.Ecodigo#
							</cfquery>
							<cfquery datasource="#session.DSN#"><!--- Localiza si para F_resultados ya existia el resultado --->
								Delete F_Resultados
								where 
									MIGMid = #indicador_actual#
									and periodo = #periodo_actual#
									and Ecodigo = #Arguments.Ecodigo#
							</cfquery>
							<cfquery datasource="#session.DSN#"><!--- Localiza si para F_resumen ya existia el resultado --->
								Delete F_Resumen
								where 
									MIGMid = #indicador_actual#
									and periodo = #periodo_actual#
									and Ecodigo = #Arguments.Ecodigo#
							</cfquery>
							<!---<cf_dump var="#indicador_pfecha#">--->
							<cfquery datasource="#session.DSN#"><!--- Agregar indicador por Depto--->
									Insert into F_Resultados(CEcodigo,Ecodigo,cod_fuente,MIGMid,periodo,mes,MIGMesmetrica,pfecha,tipo,cantidad,resultado,importe,BMUsucodigo,fechaalta,Dcodigo,MIGProid,MIGCueid)
									VALUES(#Arguments.CEcodigo#,#Arguments.Ecodigo#,-1,#indicador_actual#,#periodo_actual#,-1,'I',
									<cfqueryparam cfsqltype="cf_sql_date" value="#indicador_pfecha#">,
									'S',
									-1,
									#LSNumberFormat(rs,'99.9999')#,-1,1,#now()#,
									#rsPerteneceA.MIGMdetalleid#
									,null
									,null
									
									)
							</cfquery>
							
							<cfquery datasource="#session.DSN#"><!--- Agregar indicador por Depto--->
									Insert into F_Resumen(CEcodigo,Ecodigo,cod_fuente,MIGMid,periodo,mes,MIGMesmetrica,pfecha,tipo,cantidad,resultado,importe,BMUsucodigo,fechaalta,Dcodigo,MIGProid,MIGCueid,control)
									VALUES(#Arguments.CEcodigo#,#Arguments.Ecodigo#,-1,#indicador_actual#,#periodo_actual#,-1,'I',
									<cfqueryparam cfsqltype="cf_sql_date" value="#indicador_pfecha#">,
									'S',
									-1,
									#LSNumberFormat(rs,'99.9999')#,-1,1,#now()#,
									#rsPerteneceA.MIGMdetalleid#
									,null
									,null
									,3
									)
							</cfquery>
							
						</cfif>
							
				</cfloop><!---listperiodos--->
				
			</cfloop><!---rsFormulas--->
			
			<cfreturn #msj#>	
	</cffunction>
	
	<!---validar que los datos no esten antes de agregarlos--->
	<cffunction name="reCalculoMetricasIndicadores" access="remote" returntype="string">
		<cfargument name="MIGMid_indicador" 		type="numeric" required="no" default="">
		<cfargument name="MIGMid_metrica" 			type="numeric" required="no" default="">
		<cfargument name="periodo_indicador" 		type="numeric" required="no" default="">
		<cfargument name="indicador_periodicidad" 	type="numeric" required="no" default="">
		<cfargument name="metrica_periodicidad" 	type="numeric" required="no" default="">
		
		<cfargument name="CEcodigo" 	type="numeric" 	default="#session.CEcodigo#">
		<cfargument name="Ecodigo" 		type="numeric" 	default="#session.Ecodigo#">
		<cfargument name="DSN" 			type="string"	default="#session.DSN#">
		<cfargument name="todos" 		type="boolean" 	required="no" default="false">
		 
		
		 
			<cfquery datasource="#Arguments.DSN#" name="rsMetPeriodicidad">	<!---periodicidad de las metricas --->
				select MIGMperiodicidad,MIGMcalculo from MIGMetricas where MIGMid = #Arguments.MIGMid_metrica#
				order by MIGMid 
			</cfquery>
			<cfset metrica_periodicidad= rsMetPeriodicidad.MIGMperiodicidad>
			
			<cfset formula= ''>												<!---determina si existe una formula--->
			<cfif isdefined('rsMetPeriodicidad.MIGMcalculo') and len(trim(rsMetPeriodicidad.MIGMcalculo))>
			<cfset formula= rsMetPeriodicidad.MIGMcalculo>
			</cfif>
			
			<!---tipo y lista de detalles para una metrica que compone un indicador--->
			<cfquery  dbtype="query" name="rsDetalles">
				select * from rsFiltrosindicadores where MIGMid = #Arguments.MIGMid_metrica#
			</cfquery>
			
			<cfset listDetalles = ''>
			<cfset tipoDetalle = 'D'>
			<cfif rsDetalles.recordCount GT 0>
				<cfset listDetalles = valuelist(rsDetalles.MIGMdetalleid)>
				<cfset tipoDetalle = rsDetalles.MIGMtipodetalle>
			</cfif>
			
			<cfinvoke component="utils" method="fnDSNdestino" returnvariable="dsnA"/>
				
			<cfinvoke component="utils" method="fnPeriodoConversion" returnvariable="ListConvert">
				<cfinvokeargument name="dsn" 		value="#dsnA#"/>
				<cfinvokeargument name="Valor_ORI" 	value="#trim(Arguments.periodo_indicador)#"/>
				<cfinvokeargument name="Tipo_ORI" 	value="#Arguments.indicador_periodicidad#"/>
				<cfinvokeargument name="Tipo_DST" 	value="#metrica_periodicidad#"/>
			</cfinvoke>
			<!---Datos que va a tomar en cuenta el indicador para la formula (variables)--->
			<!--- CALCULO DE DATOS--->
			<cfquery datasource="#session.DSN#" name="rsBaseCalcInd">
				select 
					a.MIGMid
					,b.MIGMcodigo
					<cfif tipodetalle is 'D'>
					,a.Dcodigo
					</cfif>
					<cfif tipodetalle is 'P'>
					,a.MIGProid
					</cfif>
					<cfif tipodetalle is 'C'>
					,a.MIGCueid
					</cfif>
					,a.periodo
					,a.Pfecha
					,a.CEcodigo
					,a.Ecodigo
					,a.mes
					,SUM(a.valor) as resultado
					,SUM(a.cantidad) as cantidad
					
				from F_DATOS a 
				inner join MIGMetricas b
				on b.MIGMid = a.MIGMid
				WHERE 
					a.Ecodigo = #Arguments.Ecodigo#
					and a.CEcodigo = #Arguments.CEcodigo#
					and a.MIGMid is not null 
					and a.periodo <= #ListConvert.fin#						<!---filtra por el rango de periodos de la metrica actual--->
					and a.periodo >= #ListConvert.ini#
					and a.periodo_tipo = '#metrica_periodicidad#'
					
					<cfif not len(trim(formula))>
					and a.MIGMid = #Arguments.MIGMid_metrica#
					</cfif>
					
					<cfif isdefined('listDetalles') and len(trim(listDetalles))>
						<cfif tipodetalle is 'D'>
						and a.Dcodigo in(<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#listDetalles#">)
						</cfif>
						<cfif tipodetalle is 'P'>
						and a.MIGproid in(<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#listDetalles#">)
						</cfif>
						<cfif tipodetalle is 'C'>
						and a.MIGcueid in(<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#listDetalles#">)
						</cfif>
					</cfif>
					
					group by a.MIGMid
						,b.MIGMcodigo
						<cfif tipodetalle is 'D'>
						,a.Dcodigo
						</cfif>
						<cfif tipodetalle is 'P'>
						,a.MIGProid
						</cfif>
						<cfif tipodetalle is 'C'>
						,a.MIGCueid
						</cfif>
						,a.PERIODO	
						,a.Pfecha
						,a.CECODIGO
						,a.ECODIGO
						,a.mes
					
					order by a.MIGMid
						,b.MIGMcodigo
						<cfif tipodetalle is 'D'>
						,a.Dcodigo
						</cfif>
						<cfif tipodetalle is 'P'>
						,a.MIGProid
						</cfif>
						<cfif tipodetalle is 'C'>
						,a.MIGCueid
						</cfif>
						,a.PERIODO	
						,a.Pfecha
						,a.CECODIGO
						,a.ECODIGO 
						,a.mes
			</cfquery>
			
			<cfif not len(trim(formula))>
			
				<!---genera uno o varios registros que hay que agregar en F_resultados y F_resumen con tipo S--->(*)
				<cfquery dbtype="query" name="rsPeriodos">
					select distinct periodo from rsBaseCalcInd	
				</cfquery>
				
					<cfquery datasource="#session.DSN#"> <!---en caso de que haya algo de basura--->
						Delete F_Resultados 
						where MIGMid=#Arguments.MIGMid_metrica# 
						and periodo=#rsBaseCalc.periodo#
						and Ecodigo = #Arguments.Ecodigo#
						and CEcodigo = #Arguments.CEcodigo#
						<cfif tipoDetalle EQ 'P'>
							and MIGProid = #rsBaseCalc.MIGProid#
						<cfelse>
							and MIGProid is null
						</cfif>
						<cfif tipoDetalle EQ 'C'>
							and MIGCueid = #rsBaseCalc.MIGCueid#
						<cfelse>
							and MIGCueid is null
						</cfif>
						<cfif tipoDetalle EQ 'D'>
							and Dcodigo = #rsBaseCalc.Dcodigo#
						<cfelse>
							and Dcodigo is null
						</cfif>
					</cfquery>
						
					<cfquery datasource="#session.DSN#"><!---verificar que este sea por producto o depto o cuenta--->
						Insert into F_Resultados(CEcodigo,Ecodigo,cod_fuente,MIGMid,MIGMesmetrica,periodo,mes,PFecha,tipo,cantidad,resultado,importe,BMUsucodigo,fechaalta,Dcodigo,MIGProid,MIGCueid)
						VALUES(#Arguments.CEcodigo#,#Arguments.Ecodigo#,-1,#rsBaseCalc.MIGMid#,'#rsTip.MIGMesmetrica#',#rsBaseCalc.periodo#,-1
						,<cfqueryparam cfsqltype="cf_sql_date" value="#rsBaseCalc.pfecha#">
						,'N'
						<cfif len(trim(rsBaseCalc.cantidad))>
							,#rsBaseCalc.cantidad#
						<cfelse>
							,-1
						</cfif>
						,#rsBaseCalc.resultado#,-1,1
						,<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
						
						<cfif tipoDetalle EQ 'D'>
							,#rsBaseCalc.Dcodigo#
						<cfelse>
							,null
						</cfif>
						
						<cfif tipoDetalle EQ 'P'>
							,#rsBaseCalc.MIGProid#
						<cfelse>
							,null
						</cfif>
						
						<cfif tipoDetalle EQ 'C'>
							,#rsBaseCalc.MIGCueid#
						<cfelse>
							,null
						</cfif>
						)
					</cfquery>
				
				
				
				
				
			<cfelse>
				<!---genera uno o varios registros que hay que generarlos en variables para un nuevo calculo en la caculadora, debe generarse en un ciclo por los diferentes periodos encontrados--->
				<!---en el ciclo por periodos, se realiza la insercion de los datos en F_resultados y F_resumen con Tipo S --->(*)
			</cfif>
			
			<!---AQUI --->
	</cffunction>
	
	<cfscript>
		function calculate ( input_text ) {
			var rdr = "";
			var parser = "";
			var m = "";
			calc_error = "";
			try {
				rdr = CreateObject("java", "java.io.StringReader");
				parser = CreateObject("java", "com.soin.rh.calculo.Calculator");
				rdr.init(input_text);
				parser.init(rdr);
				parser.parse();
				return parser.getSymbolTable();
			}
			catch(java.lang.Throwable excpt) {
				calc_error = excpt.Message;
			}
		}
		
		
	function validate_result ( symt ) {
		if (Len(calc_error) EQ 0) {
			try {
				symt.get("cantidad");
			} catch (java.lang.Throwable ex) {
				calc_error = calc_error & "MSG_CalculoCantidad";
			}
			try {		
				symt.get("importe");
			} catch (java.lang.Throwable ex) {
				calc_error = calc_error & "MSG_CalculoImporte";
			}
			try {
				symt.get("resultado");
			} catch (java.lang.Throwable ex) {
				calc_error = calc_error & "MSG_CalculoResultado";
			}
		}
	}
	</cfscript>
	
	<cffunction name="doMNS" access="remote" returntype="string">
		<cfargument name="MSN" 		type="string" required="yes">
			<cfoutput>
			<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='C&aacute;lculo'>
				<center><strong>#MSN#</strong></center>
			<cf_web_portlet_end>
			</cfoutput>
			<cfabort>
	</cffunction>

	<cffunction name="GetMetrica" access="remote" returntype="string">	<!---Funcion tanto para metricas como para indicadores--->
		<cfargument name="MIGMID" 		type="numeric" required="yes">
		<cfargument name="Periodo" 		type="string" required="no" default="">
		<cfargument name="Pinicio" 		type="string" required="no" default=""><!---fechas de periocidad inicio--->
		<cfargument name="Pfin" 		type="string" required="no" default=""><!---fechas de periocidad hasta--->--->
		<cfargument name="xProducto"	type="numeric" default="1">
		<cfargument name="xCuenta" 		type="numeric" default="0">
		<cfargument name="xDepto" 		type="numeric" default="0">
		<cfargument name="CEcodigo" 	type="numeric" default="#session.CEcodigo#">
		<cfargument name="Ecodigo" 		type="numeric" default="#session.Ecodigo#">
		<cfargument name="DSN" 			type="string"	default="#session.DSN#">
		<cfargument name="todos" 		type="boolean" 	required="no" default="false">
		<cfargument name="Recalcular" 	type="boolean" 	required="no" default="false">
		<cfargument name="parar" 		type="boolean" 	required="no" default="false">
		<cfargument name="msj" 			type="string" 	required="no" default="">
			
			<cf_dbfunction2 name="OP_concat"	returnvariable="_Cat">
			
			<cfset session.variablesPrincipales = ''>
			<cfquery datasource="#session.DSN#" name="rsTip"> 
				select MIGMtipodetalle,MIGMperiodicidad from MIGMetricas where MIGMid=#Arguments.MIGMid# 
			</cfquery>	
			<cfset tipodetalle =rsTip.MIGMtipodetalle>
			<cfset tipoperiodicidad =rsTip.MIGMperiodicidad>
			
			<cfset listPeriodos = "">
			<cfif isdefined('Arguments.Pinicio') and len(trim(Arguments.Pinicio))>
				<cfset listPeriodos = getRangoPeriodos(MIGMID='#Arguments.MIGMID#',Pinicio='#Arguments.Pinicio#',Pfin='#Arguments.Pfin#',CEcodigo='#Arguments.CEcodigo#',Ecodigo='#Arguments.Ecodigo#',DSN='#Arguments.DSN#')>
			</cfif>
			
			<!---definicion de los o el periodo a calcular--->
			<cfif not len(trim(Arguments.Periodo)) and not len(trim(listPeriodos))>	<!---periodo del indicador actual para la metrica actual si el mismo no viene definido--->
				<!---obtine las fechas del periodo que estamos calculando para el indicador--->
				<cfinvoke component="utils" method="fnDSNdestino" returnvariable="dsnA"/>
				<cfinvoke component="utils" method="fnFechaToPeriodo" returnvariable="rsPerioA">
					<cfinvokeargument name="dsn" 		value="#dsnA#"/>
					<cfinvokeargument name="Fecha_ORI" 	value="#LSDateFormat(now())#"/>
					<cfinvokeargument name="Tipo_DST" 	value="#tipoperiodicidad#"/>
				</cfinvoke>
				<cfset Arguments.Periodo =  rsPerioA.Per>
			</cfif>
			
			
			<cfset listaDetalleIds = "">
			<cfif isdefined('Arguments.MIGMID') and len(trim(Arguments.MIGMID)) and Arguments.MIGMID GT 0><!---Tipo de Detalle por el cual se va a Filtrar--->
				<cfset listaDetalleIds = getDetailsFiltros(MIGMID='#Arguments.MIGMID#',CEcodigo='#Arguments.CEcodigo#',Ecodigo='#Arguments.Ecodigo#',DSN='#Arguments.DSN#')>
			</cfif>
		
			<cfif isdefined('Arguments.Recalcular') and Arguments.Recalcular>
				<cfif isdefined('listPeriodos') and len(trim(listPeriodos))>
					<cfloop list='#listPeriodos#' index='item'>
						<cfset recalculo = BajaMetrica(MIGMID='#Arguments.MIGMID#',Periodo='#item#',todos='#Arguments.todos#',CEcodigo='#Arguments.CEcodigo#',Ecodigo='#Arguments.Ecodigo#',DSN='#Arguments.DSN#')>
					</cfloop>
				<cfelse>
					<cfset recalculo = BajaMetrica(MIGMID='#Arguments.MIGMID#',Periodo='#Arguments.Periodo#',todos='#Arguments.todos#',CEcodigo='#Arguments.CEcodigo#',Ecodigo='#Arguments.Ecodigo#',DSN='#Arguments.DSN#',listaDetalleIds='#listaDetalleIds#')>
				</cfif>
			</cfif>	
	
			<cfquery datasource="#Arguments.DSN#" name="rsDatosResult">
				select a.MIGMid
					,x.MIGMcodigo <!---si despues viene definido por depto producto o cuenta, se de be agregar--->
					,a.Periodo
					,a.resultado
					,a.Dcodigo
					,a.MIGCueid
					,a.MIGProid
					
				from F_Resultados a
				inner join MIGMetricas x
				on x.MIGMid = a.MIGMid 
				where  a.CEcodigo = #Arguments.CEcodigo#
					and a.Ecodigo = #Arguments.Ecodigo#
					and a.TIPO = 'S'
					and a.MIGMid is not null 
					<cfif not len(trim(Arguments.Periodo)) and not len(trim(Arguments.Pinicio))><!---periodo actual--->
						and a.Periodo = (select case b.MIGMperiodicidad
											when 'D' then <cf_dbfunction2 name="date_format" args="#now()#,YYYYDY">
											when 'W' then <cf_dbfunction2 name="date_format" args="#now()#,YYYYWK">
											when 'M' then <cf_dbfunction2 name="date_format" args="#now()#,YYYYMM">
											when 'T' then <cf_dbfunction2 name="date_format" args="#now()#,YYYYQQ">
											when 'A' then <cf_dbfunction2 name="date_format" args="#now()#,YYYY">#_Cat#'00'
											when 'S' then 
												case when <cf_dbfunction2 name="date_part" args="QQ,#now()#"> < 2 then
														  <cf_dbfunction2 name="date_format" args="#now()#,YYYY">#_Cat#'01'
												else
														  <cf_dbfunction2 name="date_format" args="#now()#,YYYY">#_Cat#'02'
												end
										end as pPeriodo
										from MIGMetricas b
										where b.MIGMid=a.MIGMid)
						
					</cfif>
						
					<cfif len(trim(Arguments.Periodo))>		<!---periodo definido--->
					and a.Periodo = #Arguments.Periodo#
					</cfif>
					
					<cfif isdefined('listPeriodos') and len(trim(listPeriodos))>
						and a.Periodo in (<cfqueryparam  list="yes" cfsqltype="cf_sql_integer" value="#listPeriodos#">) 
					</cfif>
					
					<cfif isdefined('Arguments.MIGMID') and len(trim(Arguments.MIGMID))>
					and a.MIGMid = #Arguments.MIGMID#
					</cfif>
					
					<cfif tipodetalle is 'D'>	<!---tipodetalle--->
					and a.MIGproid is null
					and a.MIGcueid is null
					</cfif>
					
					<cfif rsFiltros.detalle is 'P'>
					and a.Dcodigo is null
					and a.MIGcueid is null
					</cfif>
					
					<cfif rsFiltros.detalle is 'C'>
					and a.Dcodigo is null
					and a.MIGproid is null
					</cfif>
					
					group by a.MIGMid, x.MIGMcodigo,a.Periodo,a.resultado,a.Dcodigo,a.MIGCueid,a.MIGProid
					order by a.MIGMid, x.MIGMcodigo,a.Periodo,a.resultado,a.Dcodigo,a.MIGCueid,a.MIGProid
			</cfquery>
			
			<cfset traerPeriodo = ''>

			<cfif isdefined('listPeriodos') and len(trim(listPeriodos))>
				<cfloop list='#listPeriodos#' index='item'>
				<cfquery dbType="query" name="rsItem">
					select * from rsDatosResult where periodo=#item#
				</cfquery>
				<cfif rsItem.recordCount EQ 0>
					<cfset traerPeriodo= traerPeriodo & IIF(len(trim(traerPeriodo )),DE(','),DE(''))& item>
				</cfif>
				</cfloop>
			</cfif>
		
			<cfif (rsDatosResult.recordCount EQ 0 or ( isdefined('traerPeriodo')AND len(trim(traerPeriodo)) )) and not parar>
				<cfset oks = Calcular(MIGMID='#Arguments.MIGMID#',Periodo='#Arguments.Periodo#',Pinicio='#Arguments.Pinicio#',Pfin='#Arguments.Pfin#',todos='#Arguments.todos#',CEcodigo='#Arguments.CEcodigo#',Ecodigo='#Arguments.Ecodigo#',DSN='#Arguments.DSN#')><!---listaDetalleIds='#listaDetalleIds#',listPeriodos='#listPeriodos#'--->
				<cfset oks = GetMetrica(MIGMID='#Arguments.MIGMID#',Periodo='#Arguments.Periodo#',Pinicio='#Arguments.Pinicio#',Pfin='#Arguments.Pfin#',todos='#Arguments.todos#',CEcodigo='#Arguments.CEcodigo#',Ecodigo='#Arguments.Ecodigo#',DSN='#Arguments.DSN#', parar='true', msj='#oks#')><!---listaDetalleIds='#listaDetalleIds#',listPeriodos='#listPeriodos#'--->
			<cfelse>
				<cfif rsDatosResult.recordCount EQ 0>
					<cfset hola =doMNS('No se realizo el calculo favor revisar que los datos coincidan en periodo y/o departamento, product, cuenta.')>
				<cfelse>
					<cfquery dbtype="query" name="rsTotal">
						select SUM(resultado) as monto from rsDatosResult
					</cfquery>
					
					<cfif isdefined('Arguments.MIGMID') and len(trim(Arguments.MIGMID))>
						<cfquery datasource="#session.DSN#" name="rsFormula">
							select MIGMcalculo, MIGMcodigo from MIGMetricas where MIGMid = #Arguments.MIGMID# 
							<cfif isdefined('Arguments.Ecodigo') and len(trim(Arguments.Ecodigo))>
							and Ecodigo = #Arguments.Ecodigo#
							</cfif>
						</cfquery>
					</cfif>
					
					<cfoutput>
					<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='C&aacute;lculo'>
						
						<center><strong>#rsFormula.MIGMcodigo#</strong> = <strong>#rsTotal.monto#</strong><br>  <cfif isdefined("rsFormula.MIGMcalculo") and len(trim(rsFormula.MIGMcalculo))> Formula: <strong>#rsFormula.MIGMcalculo#</strong></cfif> <br></center>
						
						<cfif isdefined('session.variablesPrincipales') and len(trim(session.variablesPrincipales))>
							<center>
							<br>Valor de las variables:<cfdump var="#session.variablesPrincipales#"><br>
							</center>
						</cfif>
						
						<br>
						
						<table border="0" cellpadding="1" cellspacing="4" align="center">
						<tr><td align="center"><strong>Detalle</strong></td><td align="center"><strong>Periodo</strong></td><td align="center"><strong>Valor</strong></td></tr>
							<cfloop query="rsDatosResult">
								<tr><td>#rsDatosResult.Dcodigo# #rsDatosResult.MIGCueid# #rsDatosResult.MIGProid#</td><td>#rsDatosResult.periodo#</td><td>#rsDatosResult.resultado# </td></tr>
							</cfloop>
							<tr><td colspan="2" align="right"><strong>Total: #rsTotal.monto#</strong></td></tr>
						</table>
						
						<cfif len(trim(msj))>
							<br>
							<center><strong>Advertencia:</strong> #msj#</center>
						</cfif>
						<center>
							<br>
							Nota: si no se presentan Valor de las variables para alguna variable, se da por hecho que la misma se calcula con valor en cero, esto por que puede ser que la variable no exista para los detalles y o periodo(s) especificado(s).
							<br>
						</center>
						
					<cf_web_portlet_end>
					</cfoutput>
					<cfabort>
				</cfif>
			</cfif>
			
		
			<cfreturn #msj#>	
	</cffunction>
	
	<cffunction name="Calcular" access="remote" returntype="string">
		<cfargument name="MIGMID" 		type="numeric" required="no" default="">
		<cfargument name="Periodo" 		type="string" required="no" default="">
		<cfargument name="Pinicio" 		type="string" required="no" default=""><!---fechas de periocidad inicio--->
		<cfargument name="Pfin" 		type="string" required="no" default=""><!---fechas de periocidad hasta--->--->
		<cfargument name="xProducto"	type="numeric" required="no" default="1">
		<cfargument name="xCuenta" 		type="numeric" required="no" default="0">
		<cfargument name="xDepto" 		type="numeric" required="no" default="0">
		<cfargument name="CEcodigo" 	type="numeric" required="no" default="#session.CEcodigo#">
		<cfargument name="Ecodigo" 		type="numeric" required="no" default="#session.Ecodigo#">
		<cfargument name="DSN" 			type="string"  required="no" default="#session.DSN#">
		<cfset oks = ''>	
		<cfset oks = ProcesoBase(Pinicio='#Arguments.Pinicio#',Pfin='#Arguments.Pfin#',Periodo='#Arguments.Periodo#',MIGMID='#Arguments.MIGMID#',xProducto='#Arguments.xProducto#',xCuenta='#Arguments.xCuenta#',xDepto='#Arguments.xDepto#',CEcodigo='#Arguments.CEcodigo#',Ecodigo='#Arguments.Ecodigo#',DSN='#Arguments.DSN#',tipo='M')>
		<cfset oks = CalculoMetricas(Pinicio='#Arguments.Pinicio#',Pfin='#Arguments.Pfin#',Periodo='#Arguments.Periodo#',MIGMID='#Arguments.MIGMID#',xProducto='#Arguments.xProducto#',xCuenta='#Arguments.xCuenta#',xDepto='#Arguments.xDepto#',CEcodigo='#Arguments.CEcodigo#',Ecodigo='#Arguments.Ecodigo#',DSN='#Arguments.DSN#')>
		
		<cfquery datasource="#session.DSN#"> <!---en caso de que haya algo de basura--->
			Delete F_Resultados 
			where MIGMid=#Arguments.MIGMid# 
			and Ecodigo = #Arguments.Ecodigo#
			and CEcodigo = #Arguments.CEcodigo#
			and tipo = 'N'
		</cfquery>
		
		<cfset oks = CalculoIndicadores(Pinicio='#Arguments.Pinicio#',Pfin='#Arguments.Pfin#',Periodo='#Arguments.Periodo#',MIGMID='#Arguments.MIGMID#',xProducto='#Arguments.xProducto#',xCuenta='#Arguments.xCuenta#',xDepto='#Arguments.xDepto#',CEcodigo='#Arguments.CEcodigo#',Ecodigo='#Arguments.Ecodigo#',DSN='#Arguments.DSN#')>
		
		<cfreturn oks>
	</cffunction>
	
	<cffunction name="BajaMetrica" access="remote" returntype="string">				<!---Para recalcular --->
		<cfargument name="MIGMID" 			type="numeric" required="yes">
		<cfargument name="Periodo" 			type="string" required="no" default="">
		<cfargument name="Pinicio" 			type="string" required="no" default=""><!---fechas de periocidad inicio--->
		<cfargument name="Pfin" 			type="string" required="no" default=""><!---fechas de periocidad hasta--->--->
		<cfargument name="CEcodigo" 		type="numeric" required="no" default="#session.CEcodigo#">
		<cfargument name="Ecodigo" 			type="numeric" required="no" default="#session.Ecodigo#">
		<cfargument name="listPeriodos" 	type="string"  required="no" default="">
		<cfargument name="listaDetalleIds" 	type="string"  required="no" default="">
		
		<cfset rs = ''>
			
			<cftry>
				<cftransaction>
						
						<cfquery datasource="#Arguments.DSN#" name="rsTipodet">
							select MIGMtipodetalle from MIGMetricas 
							where  Ecodigo = #Arguments.Ecodigo#
							and MIGMid = #Arguments.MIGMID#
						</cfquery>
						<cfset tipodetalle = rsTipodet.MIGMtipodetalle>
						
						<cfquery datasource="#Arguments.DSN#">
							delete F_Resultados  
							where  MIGMid = #Arguments.MIGMID#
							<cfif len(trim(Arguments.Periodo))>								<!---periodo definido--->
							and Periodo = #Arguments.Periodo#
							</cfif>
							<cfif isdefined('listPeriodos') and len(trim(listPeriodos))>	<!---rango de periodos--->
								and Periodo in (<cfqueryparam  list="yes" cfsqltype="cf_sql_integer" value="#listPeriodos#">) 
							</cfif>
							
							<cfif isdefined('listaDetalleIds') and len(trim(listaDetalleIds))><!---lista de detalles--->
								<cfif tipodetalle is 'D'>
								and Dcodigo in(<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#listaDetalleIds#">)
								</cfif>
								<cfif rsFiltros.detalle is 'P'>
								and MIGproid in(<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#listaDetalleIds#">)
								</cfif>
								<cfif rsFiltros.detalle is 'C'>
								and MIGcueid in(<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#listaDetalleIds#">)
								</cfif>
							</cfif>
							
							<cfif tipodetalle is 'D'>	<!---tipodetalle--->
							and MIGproid is null
							and MIGcueid is null
							</cfif>
							<cfif rsFiltros.detalle is 'P'>
							and Dcodigo is null
							and MIGcueid is null
							</cfif>
							<cfif rsFiltros.detalle is 'C'>
							and Dcodigo is null
							and MIGproid is null
							</cfif>
						</cfquery>
						
						<cfquery datasource="#Arguments.DSN#">
							delete F_Resumen  
							where MIGMid = #Arguments.MIGMID#
							<cfif len(trim(Arguments.Periodo))>								<!---periodo definido--->
							and Periodo = #Arguments.Periodo#
							</cfif>
							
							<cfif isdefined('listaDetalleIds') and len(trim(listaDetalleIds))><!---lista de detalles--->
								<cfif tipodetalle is 'D'>
								and Dcodigo in(<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#listaDetalleIds#">)
								</cfif>
								<cfif rsFiltros.detalle is 'P'>
								and MIGproid in(<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#listaDetalleIds#">)
								</cfif>
								<cfif rsFiltros.detalle is 'C'>
								and MIGcueid in(<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#listaDetalleIds#">)
								</cfif>
							</cfif>
							
							<cfif tipodetalle is 'D'>	<!---tipodetalle--->
							and MIGproid is null
							and MIGcueid is null
							</cfif>
							
							<cfif rsFiltros.detalle is 'P'>
							and Dcodigo is null
							and MIGcueid is null
							</cfif>
							
							<cfif rsFiltros.detalle is 'C'>
							and Dcodigo is null
							and MIGproid is null
							</cfif>
							
						</cfquery>
				</cftransaction>
			<cfcatch type="any">
				<cfdump var="#cfcatch#">
				<cfset msn = doMNS('Hubo un error en el recalculo de datos, no se pudieron borrar los datos. Contacte al proveedor.')>
			</cfcatch>
			</cftry>
			
		<cfreturn #rs#>
	</cffunction>
	
	
	
</cfcomponent>