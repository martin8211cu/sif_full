	<cfsavecontent variable="presets_ret3">
		<cfset DiasRealesCalculoNomina = 0>
		<!--- funcion para conocer los dias desde la ultima nomina empleado a su fecha de nombramiento --->
	   <cf_dbfunction name="datediff" args="max(RChasta), c.EVfantig" returnvariable="_datediff">
		<cfquery name="DiasRealesLaborados" datasource="#Session.DSN#">		
			select c.DEid,
				   c.EVfantig, 
				   max(RChasta) as RChasta,
				   coalesce(abs(#preservesinglequotes(_datediff)#)+1,0) as DiasReales
			from HRCalculoNomina a, HSalarioEmpleado b, EVacacionesEmpleado c
	
			where a.RCNid=b.RCNid
			  and b.DEid = #DEid#
			  and b.DEid = c.DEid
			  and RChasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1_Accion#">
	
			group by c.DEid, c.EVfantig
		</cfquery>
		<cfif len(trim(DiasRealesLaborados.DiasReales)) gt 0>
			<cfset DiasRealesCalculoNomina = "#DiasRealesLaborados.DiasReales#">
		</cfif>
		DiasRealesCalculoNomina = <cfoutput>#DiasRealesCalculoNomina#</cfoutput>
		
		
		<!---ljimenez Calculo Dias Incapacidad (0:normal, 1:Henkel) --->
		<cfinvoke component="rh.Componentes.RHParametros" method="get" 
			datasource="#session.dsn#" ecodigo="#session.Ecodigo#" pvalor="790" default="0" returnvariable="vUsaDiasIncp"/>		
		
		<!--- parametro 790=1 ==> Henkel, calculo normal de lo contrario --->
		<cfif #vUsaDiasIncp# eq 1 >
			<cfset Dias_Incapacidad   = 0>
			<!--- CODIGO HECHO POR LIZANDRO--->
			<cfquery name="DiasRealesIncapacitado" datasource="#Session.DSN#">
				select sum(PEcantdias) as total
				  from HPagosEmpleado a
				  inner join HRCalculoNomina b
				  		on b.RCNid = a.RCNid
				  inner join CalendarioPagos c
				  		on c.CPid = a.RCNid
				  where b.RChasta >= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha_teorico#">
					  and b.RChasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha_Salarios_Final#">
					  and CPtipo =0
					  and  PEtiporeg in(0,3)
					  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
					  and RHTid in(select RHTid from RHTipoAccion where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#"> and RHTcomportam = 5)
				  order by RCdesde
			</cfquery>
			<cfif len(trim(DiasRealesIncapacitado.total))> 
				<cfset Dias_Incapacidad = DiasRealesIncapacitado.Total >    
			</cfif>
			Dias_Incapacidad = <cfoutput>#Dias_Incapacidad#</cfoutput>
			<!--- CODIGO HECHO POR LIZANDRO FIN --->
		<cfelse>
			<cfif (Len(Arguments.RHTid) Neq 0) And (Arguments.RHTid Neq 0)>
				<!--- si no hay Tipo de accion no se calcula la incapacidad --->
				<cfquery name="tipoaccion" datasource="#session.dsn#">
					select RHTcantdiascont,RHTnoretroactiva
					from RHTipoAccion d
					where RHTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHTid#" null="#Len(RHTid) Is 0 or RHTid Is 0#">
				</cfquery>
				<cfset Fecha1_Incapacidad = Fecha1_Accion>
				<cfset Dias_Incapacidad   = 0>
				<cfif Len(tipoaccion.RHTcantdiascont) and tipoaccion.RHTcantdiascont neq 0>
					<!--- Extrae de parametros RH el Concepto de Subsidio de Incapacidad --->
					<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#" 
					ecodigo="#session.Ecodigo#" pvalor="2525" default="0" returnvariable="CIidSub"/>
					<!--- Buscar la lista de incapacidades anteriores --->
					<cfloop from="1" to="#tipoaccion.RHTcantdiascont#" index="dummy">
						<cfset fechaminima = DateAdd('d', tipoaccion.RHTcantdiascont * -1, Fecha1_Incapacidad)>
						<cfset fechamaxima = DateAdd('d', -1, Fecha1_Incapacidad)>
						 <!--- Se modifico el calculo Dias_Incapacidad por que solo tomaba encuenta las no retroactivas --->
							<!--- Si el Parámetro está definido --->								
									 <cfquery datasource="#session.dsn#" name="incapacidadAnterior" >
										select 	min(coalesce(b.RHSPEfdesde, a.DLfvigencia)) as RHSPEfdesde, 
												<!-----sum(DDCcant) as duracion---->									
												case when  sum(RHSPEdiassub) > 0 then
													sum(RHSPEdiassub)
												else 
													sum(DDCcant)
												end as duracion 
										from DLaboralesEmpleado a
											inner join  DDConceptosEmpleado c
												on a.DLlinea = c.DLlinea                                
											left outer join RHSaldoPagosExceso b            
												on  b.RHTid = a.RHTid
												and b.DLlinea = a.DLlinea
												and RHSPEanulado=0	
												and b.DEid = a.DEid	
										where a.DEid = #DEid#
										  and a.RHTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHTid#" null="#Len(RHTid) Is 0 or RHTid Is 0#">
										  and a.Ecodigo = #Ecodigo#
										  and DLffin between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fechaminima#"> 
												and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fechamaxima#">
										  and DLfvigencia < <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fecha1_Incapacidad#">
											<cfif #CIidSub# NEQ 0 >										  
										  and c.CIid = #CIidSub#
										</cfif>										  
									</cfquery>
						<cfif Len(incapacidadAnterior.RHSPEfdesde) is 0><cfbreak></cfif>
						<cfloop query="incapacidadAnterior">
							<cfif Fecha1_Incapacidad GT incapacidadAnterior.RHSPEfdesde>
								<cfset Fecha1_Incapacidad = incapacidadAnterior.RHSPEfdesde>
							</cfif>
							<cfif Len(incapacidadAnterior.duracion)>
								<cfset Dias_Incapacidad = Dias_Incapacidad + incapacidadAnterior.duracion>
							</cfif>
						</cfloop>
					</cfloop>
				</cfif>
				
				Fecha1_Incapacidad      = #<cfoutput>#LSDateFormat(Fecha1_Incapacidad, "dd/mm/yyyy")#</cfoutput>#
				Dias_Incapacidad        = <cfoutput>#Dias_Incapacidad#</cfoutput>
			<cfelse>
				Fecha1_Incapacidad      = #01/01/1900#
				Dias_Incapacidad        = 0
			</cfif>
		</cfif>
		
		<cfset Saldo_Vacaciones = 0.00>
		<cfset Saldo_Vacaciones365 = 0.00><!--- 4-3-2010 Modificacion Vacaciones Mexico sobre 365 dias--->
		<cfset saldo_corriente = 0>
        <cfset saldo_corriente365 = 0>
		<!--- Solo si viene la accin se procede a calcular el saldo de vacaciones --->
		<cfif Len(Trim(Arguments.RHAlinea)) NEQ 0 and Arguments.RHAlinea NEQ 0>
			<cfif isdefined("arguments.origen") and origen eq 'DLaboralesEmpleado'>
				<cfquery name="rsFechaLiquidacion" datasource="#session.dsn#">
					select <cf_dbfunction name="dateadd" args="-1,a.DLfvigencia"> as fechaliquidacion
					from DLaboralesEmpleado a
					where a.DLlinea = #Arguments.RHAlinea#
				</cfquery>
			<cfelse>
				<cfquery name="rsFechaLiquidacion" datasource="#session.dsn#">
					select a.DLfvigencia as fechaliquidacion
					from RHAcciones a
					where a.RHAlinea = #Arguments.RHAlinea#
				</cfquery>
			</cfif>	
			<!--- Vacaciones Acumuladas --->
			<cfquery name="rsVacaciones" datasource="#Session.DSN#">
				select 	a.DEid, 
						coalesce(a.EVfecha, a.EVfantig) as Antiguedad, 
						coalesce(sum(b.DVEdisfrutados + b.DVEcompensados), 0.00) as Disponibles, 
						coalesce(sum(b.DVEenfermedad), 0.00) as DVEenfermedad,
						a.EVfantig
				from EVacacionesEmpleado a
					left outer join DVacacionesEmpleado b
						on a.DEid = b.DEid
						<!--- Se asumen que todas las vacaciones cuenta porque se esta ante una liquidacion
								Se realizan ajustes manuales en caso de que la liquidacion sea anterior a una accion de disfrute de vacaciones --->
				where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
				group by a.DEid, coalesce(a.EVfecha, a.EVfantig),a.EVfantig
			</cfquery>
            <cfif rsVacaciones.RecordCount and rsFechaLiquidacion.RecordCount GT 0>
				<!--- Regimen de Vacaciones --->
                <cfquery name="rsRegimen" datasource="#session.DSN#">
                    select RVid 
                    from LineaTiempo 
                    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
                      and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
                      and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsFechaLiquidacion.fechaliquidacion#"> between LTdesde and LThasta
                </cfquery>
   			<cfif rsRegimen.RecordCount GT 0>
					<!--- Lizandro pidio descomentar esta linea siguiente y comentar la que esta dos lineas abajo. --->			
                    <cfset vFecha = ListToArray(LSDateFormat(rsVacaciones.Antiguedad,'dd/mm/yyyy'),'/')>
                    <cfset vFecha365 = ListToArray(LSDateFormat(rsVacaciones.EVfantig,'dd/mm/yyyy'),'/')> <!--- 4-3-2010 Modificacion Vacaciones Mexico sobre 365 dias--->
                    <cfset Lvarfecha_ingreso = Createdate(vFecha[3],vFecha[2],vfecha[1]) >
                    <cfset Lvarfecha_ingreso365 = Createdate(vFecha365[3],vFecha365[2],vfecha365[1]) >
                    <!--- calcula la cantidad de aos laborados, a partir de su ingreso --->
                    <cfset anno = DateDiff('yyyy', Lvarfecha_ingreso, rsFechaLiquidacion.fechaliquidacion)>
                    <cfset anno365 = (DateDiff('d', Lvarfecha_ingreso365, rsFechaLiquidacion.fechaliquidacion-1)/365)> <!--- 5-3-2010 Modificacion Vacaciones Mexico sobre 365 dias--->
                    <!--- objeto date con la fecha del ltimo corte --->
                    <cfset Lvarfecha_corte = DateAdd('yyyy', anno, Lvarfecha_ingreso)>
            
                    <!--- calcula la cantidad de meses desde la fecha_corte(dia, mes de ingreso, ao en curso) hasta la fecha de hoy --->
                    <!--- 3-10-2010 LZ. La Fecha de Liquidacion siempre es Igual a un Día despues del último día laborado--->
                    <cfset meses = DateDiff('d', Lvarfecha_corte, rsFechaLiquidacion.fechaliquidacion)>
                    <cfset dias365 = meses> <!--- 4-3-2010 Modificacion Vacaciones Mexico sobre 365 dias--->
                    <cfset meses = meses  / 30.0>
                    
                    <!--- Calcula la cantidad de dias para el siguiente corte que le corresponden segun el regimen de vacaciones y la cantidad de aos laborados --->
                    <cfquery name="rsDias" datasource="#session.DSN#">
                        select coalesce(rv.DRVdias, 0) as DRVdias
                        from DRegimenVacaciones rv 
                        where rv.RVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRegimen.RVid#">
                          and rv.DRVcant = ( select coalesce(max(DRVcant),1) 
                                             from DRegimenVacaciones rv2 
                                             where rv2.RVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRegimen.RVid#">
                                               and rv2.DRVcant <= <cfqueryparam cfsqltype="cf_sql_float" value="#anno+1#"> )
                    </cfquery>
                    
                    <!--- 4-3-2010 Modificacion Vacaciones Mexico sobre 365 dias--->
                    <cfquery name="rsDias365" datasource="#session.DSN#">
                        select coalesce(rv.DRVdias, 0) as DRVdias
                        from DRegimenVacaciones rv 
                        where rv.RVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRegimen.RVid#">
                          and rv.DRVcant = ( select coalesce(max(DRVcant),1) 
                                             from DRegimenVacaciones rv2 
                                             where rv2.RVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRegimen.RVid#">
                                               and rv2.DRVcant <= <cfqueryparam cfsqltype="cf_sql_float" value="#anno365+1#"> )
                    </cfquery>
                    <!--- calcula el saldo corriente de vacaciones --->
                    <cfif rsDias.recordCount GT 0 and Len(Trim(rsDias.DRVdias))>
                    <!--- 3-10-2010 LZ Se Incluye generacion de Saldo Corriente para Vacaciones 360--->
                        <cfset saldo_corriente = (rsDias.DRVdias*meses)/12>
                        <cfset saldo_corriente365 = (rsDias365.DRVdias*dias365)/365> 				<!--- 4-3-2010 Modificacion Vacaciones Mexico sobre 365 dias--->
                    </cfif>
            
                    <cfif Len(Trim(rsVacaciones.Disponibles))>
                        <cfset Saldo_Vacaciones = rsVacaciones.Disponibles + saldo_corriente>
                        <cfset Saldo_Vacaciones365 = rsVacaciones.Disponibles + saldo_corriente365> <!--- 4-3-2010 Modificacion Vacaciones Mexico sobre 365 dias--->
                    <cfelse>
                        <cfset Saldo_Vacaciones = saldo_corriente >
                        <cfset Saldo_Vacaciones365 =saldo_corriente365>							<!--- 4-3-2010 Modificacion Vacaciones Mexico sobre 365 dias--->	
                    </cfif>
              	</cfif>
              </cfif>
              
              
            <cfelse >
        	<!--- Vacaciones Acumuladas --->
			<cfquery name="rsVacaciones" datasource="#Session.DSN#">
				select 	a.DEid, 
						coalesce(a.EVfecha, a.EVfantig) as Antiguedad, 
						coalesce(sum(b.DVEdisfrutados + b.DVEcompensados), 0.00) as Disponibles, 
						coalesce(sum(b.DVEenfermedad), 0.00) as DVEenfermedad,
						a.EVfantig
				from EVacacionesEmpleado a
					left outer join DVacacionesEmpleado b
						on a.DEid = b.DEid
						<!--- Se asumen que todas las vacaciones cuenta porque se esta ante una liquidacion
								Se realizan ajustes manuales en caso de que la liquidacion sea anterior a una accion de disfrute de vacaciones --->
				where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
				group by a.DEid, coalesce(a.EVfecha, a.EVfantig),a.EVfantig
			</cfquery>
			
			
			<cfquery name="rsFechaLiquidacion" datasource="#session.DSN#">
                    select <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1_Accion#"> as fechaliquidacion
            </cfquery>
			
			
            <cfif rsVacaciones.RecordCount>
				<!--- Regimen de Vacaciones --->
                <cfquery name="rsRegimen" datasource="#session.DSN#">
                    select RVid 
                    from LineaTiempo 
                    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
                      and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
                      and <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1_Accion#"> between LTdesde and LThasta
                </cfquery>
                
   			<cfif rsRegimen.RecordCount GT 0>
					<!--- Lizandro pidio descomentar esta linea siguiente y comentar la que esta dos lineas abajo. --->			
                    <cfset vFecha = ListToArray(LSDateFormat(rsVacaciones.Antiguedad,'dd/mm/yyyy'),'/')>
                    <cfset vFecha365 = ListToArray(LSDateFormat(rsVacaciones.EVfantig,'dd/mm/yyyy'),'/')> <!--- 4-3-2010 Modificacion Vacaciones Mexico sobre 365 dias--->
                    <cfset Lvarfecha_ingreso = Createdate(vFecha[3],vFecha[2],vfecha[1]) >
                    <cfset Lvarfecha_ingreso365 = Createdate(vFecha365[3],vFecha365[2],vfecha365[1]) >
                    <!--- calcula la cantidad de aos laborados, a partir de su ingreso --->
                    <cfset anno = DateDiff('yyyy', Lvarfecha_ingreso, rsFechaLiquidacion.fechaliquidacion)>
                    <cfset anno365 = (DateDiff('d', Lvarfecha_ingreso365, rsFechaLiquidacion.fechaliquidacion-1)/365)> <!--- 5-3-2010 Modificacion Vacaciones Mexico sobre 365 dias--->
                    <!--- objeto date con la fecha del ltimo corte --->
                    <cfset Lvarfecha_corte = DateAdd('yyyy', anno, Lvarfecha_ingreso)>
            
                    <!--- calcula la cantidad de meses desde la fecha_corte(dia, mes de ingreso, ao en curso) hasta la fecha de hoy --->
                    <!--- 3-10-2010 LZ. La Fecha de Liquidacion siempre es Igual a un Día despues del último día laborado--->
                    <cfset meses = DateDiff('d', Lvarfecha_corte, rsFechaLiquidacion.fechaliquidacion)>
                    <cfset dias365 = meses> <!--- 4-3-2010 Modificacion Vacaciones Mexico sobre 365 dias--->
                    <cfset meses = meses  / 30.0>
                    
                    <!--- Calcula la cantidad de dias para el siguiente corte que le corresponden segun el regimen de vacaciones y la cantidad de aos laborados --->
                    <cfquery name="rsDias" datasource="#session.DSN#">
                        select coalesce(rv.DRVdias, 0) as DRVdias
                        from DRegimenVacaciones rv 
                        where rv.RVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRegimen.RVid#">
                          and rv.DRVcant = ( select coalesce(max(DRVcant),1) 
                                             from DRegimenVacaciones rv2 
                                             where rv2.RVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRegimen.RVid#">
                                               and rv2.DRVcant <= <cfqueryparam cfsqltype="cf_sql_float" value="#anno+1#"> )
                    </cfquery>
                    
                    <!--- 4-3-2010 Modificacion Vacaciones Mexico sobre 365 dias--->
                    <cfquery name="rsDias365" datasource="#session.DSN#">
                        select coalesce(rv.DRVdias, 0) as DRVdias
                        from DRegimenVacaciones rv 
                        where rv.RVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRegimen.RVid#">
                          and rv.DRVcant = ( select coalesce(max(DRVcant),1) 
                                             from DRegimenVacaciones rv2 
                                             where rv2.RVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRegimen.RVid#">
                                               and rv2.DRVcant <= <cfqueryparam cfsqltype="cf_sql_float" value="#anno365+1#"> )
                    </cfquery>
                    <!--- calcula el saldo corriente de vacaciones --->
                    <cfif rsDias.recordCount GT 0 and Len(Trim(rsDias.DRVdias))>
                    <!--- 3-10-2010 LZ Se Incluye generacion de Saldo Corriente para Vacaciones 360--->
                        <cfset saldo_corriente = (rsDias.DRVdias*meses)/12>
                        <cfset saldo_corriente365 = (rsDias365.DRVdias*dias365)/365> 				<!--- 4-3-2010 Modificacion Vacaciones Mexico sobre 365 dias--->
                    </cfif>
            
                    <cfif Len(Trim(rsVacaciones.Disponibles))>
					<!--- Recupera el parametro de Controla Vacaciones por Periodo --->	
					<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#" 
					ecodigo="#Arguments.Ecodigo#" pvalor="895" default="0" returnvariable="PvalorControlVacLineaTiempo"/>	
					
					<cfif trim(PvalorControlVacLineaTiempo) EQ '1' ><!--- fcastro 24/4/12 realiza proyeccion de dias segun cortes en linea de tiempo BNvital--->		
						<cfinvoke component="rh.Componentes.RH_VacacionesProyeccion" method="calcularProyectado" returnvariable="Proyectado">
							<cfinvokeargument name="IdsEmpleados"  value="#Arguments.DEid#">
							<cfinvokeargument name="fechaLimitaSuperior"  value="#rsFechaLiquidacion.fechaliquidacion#">
							<cfinvokeargument name="totalizado"    value="true">
							<cfinvokeargument name="Debug"    value="false">
					</cfinvoke>
						<cfif Proyectado.RecordCount GT 0 >
							   <cfset saldo_corriente = Proyectado.dias>
						<cfelse>
							   <cfset saldo_corriente = 0>
						</cfif>
					</cfif>
                        <cfset Saldo_Vacaciones = rsVacaciones.Disponibles + saldo_corriente>
                        <cfset Saldo_Vacaciones365 = rsVacaciones.Disponibles + saldo_corriente365> <!--- 4-3-2010 Modificacion Vacaciones Mexico sobre 365 dias--->
                    <cfelse>
                        <cfset Saldo_Vacaciones = saldo_corriente >
                        <cfset Saldo_Vacaciones365 =saldo_corriente365>							<!--- 4-3-2010 Modificacion Vacaciones Mexico sobre 365 dias--->	
                    </cfif>
              	</cfif>
              </cfif>

              
              
              
              
		</cfif>
		Saldo_Vacaciones = <cfoutput>#Saldo_Vacaciones#</cfoutput>
		Saldo_Vacaciones365 = <cfoutput>#Saldo_Vacaciones365#</cfoutput> 				<!--- 4-3-2010 Modificacion Vacaciones Mexico sobre 365 dias--->
		
		
		<!--- Calculo de Dias adicionales a la fecha del ultimo pago --->
		<cfset DiasPagoLiq = 0>
		<!--- Dias que no pagan --->
		<cfquery name="rsDiasNoPagados" datasource="#Session.DSN#">
			select DTNdia
			from DiasTiposNomina
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			and Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Tcodigo#">
		</cfquery>
		<!--- Ultima Fecha de Pago --->
		<cfquery name="rsUltimoPago" datasource="#Session.DSN#">
			select max(cp.CPhasta) as FechaPago
			from HSalarioEmpleado b, HRCalculoNomina a, CalendarioPagos cp
			where b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
			and a.RCNid = b.RCNid
			and a.RChasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1_Accion#">
			and a.RCdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha_Ingreso#">
			and cp.CPid = a.RCNid
			and cp.CPtipo = 0
			and a.RCestado = 3
		</cfquery>
		<!--- Dias adicionales a partir de la ltima fecha de pago --->
		<cfif Len(Trim(rsUltimoPago.FechaPago))>
			<cfset DiasPagoLiq = DateDiff('d', rsUltimoPago.FechaPago, Fecha1_Accion)>
			<!--- Quitar lo das de no pago --->
			<cfif rsDiasNoPagados.recordCount>
				<cfset i = rsUltimoPago.FechaPago>
				<cfloop condition="DateCompare(i, Fecha1_Accion) LE 0">
					<cfloop query="rsDiasNoPagados">
						<cfset dia1 = "" & DayOfWeek(i)>
						<cfset dia2 = "" & rsDiasNoPagados.DTNdia>
						<cfif Trim(dia1) EQ Trim(dia2)>
							<cfset DiasPagoLiq = DiasPagoLiq - 1>
						</cfif>
					</cfloop>
					<cfset i = DateAdd('d', 1, i)>
				</cfloop>
			</cfif>
		</cfif>
		DiasPagoLiq = <cfoutput>#DiasPagoLiq#</cfoutput>
	
		<cfquery datasource="#session.dsn#" name="TipoPago">
			select 
				Ttipopago, FactorDiasSalario
			from TiposNomina a, LineaTiempo b
			where b.DEid = #DEid#
			and a.Ecodigo = #Ecodigo#
			and b.Ecodigo = #Ecodigo#
			and a.Tcodigo = b.Tcodigo
			and <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1_Accion#"> between LTdesde and LThasta 
		</cfquery>
		TipoPago = <cfoutput>#TipoPago.Ttipopago#</cfoutput><cfif Not Len(TipoPago.Ttipopago)>0</cfif>
		<!--- LZ, por si acaso el Factor es Cero --->				
		<cfif TipoPago.FactorDiasSalario EQ 0 or TipoPago.RecordCount EQ 0>
			<cfquery name="TipoPago" datasource="#Session.DSN#">
				select Pvalor as FactorDiasSalario
				from RHParametros
				where Ecodigo = #Ecodigo#
				and Pcodigo = 80
			</cfquery>
		</cfif>		
		FactorDiasSalario = <cfoutput>#TipoPago.FactorDiasSalario#</cfoutput><cfif Not Len(TipoPago.FactorDiasSalario)>0</cfif>

		<!--- ************************************************************************************************************* --->
		<!--- ***  Inicia el calculo el pago de vacaciones acumuladas por periodo al salario promedio correspondiente   *** --->
		<!--- ************************************************************************************************************* --->
		<cfset PagoDiasVacAcum = 0>
		<cfset DiasVacacionesAcum = 0>
        <cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#" ecodigo="#session.ecodigo#" pvalor="2505" default="0" returnvariable="vCtrlVacXPeriodo"/>
		<cfif vCtrlVacXPeriodo>
        
            <cfquery name="rsVacSolicitadas" datasource="#Session.DSN#">
                select coalesce(a.RHAvdisf,0) as RHAvdisf ,ta.RHTcomportam
                from RHAcciones a
                	inner join RHTipoAccion ta
                    	on ta.RHTid = a.RHTid
                where  a.RHAlinea = #Arguments.RHAlinea#
            </cfquery>
            <cfset lvarVacSolicitadas = rsVacSolicitadas.RHAvdisf>
			
            <cfif len(trim(lvarVacSolicitadas))>
                <cfquery name="rsVacSaldo" datasource="#Session.DSN#">
                    select DVAperiodo
                         ,abs(coalesce(sum(case when dva.DVAsaldodias < 0 then dva.DVAsaldodias else 0 end ),0))
                        -
                        (select coalesce(sum(va.DVAsaldodias),0)
                        from DVacacionesAcum va 
                        where va.DEid = dva.DEid and va.DVAperiodo = dva.DVAperiodo and not va.DVElinea is null
                        ) - coalesce(sum(case when dva.DVAsaldodias > 0 and dva.DVAmanual = 1 then dva.DVAsaldodias else 0 end ),0) as vacDisf
                         ,case when sum(dva.DVAsaldodias ) < 0 then 0 else  sum(dva.DVAsaldodias) end as vacDisp
                         ,sum(DVAdiasPotenciales) as vacPot
                         ,sum(DVASalarioProm) as DVASalarioProm
                         ,sum(DVASalarioPdiario) as DVASalarioPdiario
                    from DVacacionesAcum dva
                    where DEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
                      and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Ecodigo#">
                      and (dva.DVElinea in (select dve.DVElinea
                                      from DVacacionesEmpleado dve
                                      where dve.DEid = dva.DEid
                                       and dve.Ecodigo = dva.Ecodigo
                                       and dve.DVErefLinea is null
                                     ) 
                      or dva.DVElinea is null)
                    group by dva.DEid, dva.DVAperiodo
                    having sum(dva.DVAdiasPotenciales) - (abs(coalesce(sum(case when dva.DVAsaldodias < 0 then dva.DVAsaldodias else 0 end ),0))
                      -
                      (select coalesce(sum(va.DVAsaldodias),0)
                      from DVacacionesAcum va 
                      where va.DEid = dva.DEid and va.DVAperiodo = dva.DVAperiodo and not va.DVElinea is null
                      ) - coalesce(sum(case when dva.DVAsaldodias > 0 and dva.DVAmanual = 1 then dva.DVAsaldodias else 0 end ),0)) > 0
                      and sum(DVASalarioPdiario) > 0
                    order by dva.DEid, dva.DVAperiodo
                </cfquery>
    
                <cfloop query="rsVacSaldo">
                        <cfif rsVacSaldo.vacDisp gte lvarVacSolicitadas>
                            <cfset DiasVacacionesAcum = DiasVacacionesAcum + lvarVacSolicitadas>
                            <cfset PagoDiasVacAcum = PagoDiasVacAcum + (lvarVacSolicitadas * rsVacSaldo.DVASalarioPdiario)>
                            <cfset lvarVacSolicitadas = 0>
                        <cfelse>
                            <cfset DiasVacacionesAcum = DiasVacacionesAcum + rsVacSaldo.vacDisp>
                            <cfset PagoDiasVacAcum = PagoDiasVacAcum + (rsVacSaldo.vacDisp * rsVacSaldo.DVASalarioPdiario)>
                            <cfset lvarVacSolicitadas    = lvarVacSolicitadas - rsVacSaldo.vacDisp>
                        </cfif>
                        <cfif lvarVacSolicitadas eq 0 >
                            <cfbreak>
                        </cfif>	
                </cfloop>
        	</cfif>
        </cfif>
		<!---
		<br/>
		********************
		<cfdump var="#SaldoVacas#"><br/>
		cantidad :<cfdump var="#cantidad#"><br/>
		vacacionesSolicitadas :<cfdump var="#vacacionesSolicitadas#"><br/>
		DiasVacacionesAcum :<cfdump var="#DiasVacacionesAcum#"><br/>
		PagoDiasVacAcum :<cf_dump var="#PagoDiasVacAcum#"><br/>   --->

		PagoDiasVacAcum = <cfoutput>#PagoDiasVacAcum#</cfoutput>
		DiasVacacionesAcum = <cfoutput>#DiasVacacionesAcum#</cfoutput>

		<!--- ************************************************************************************************************* --->
		<!--- ***  fin el calculo el pago de vacaciones acumuladas por periodo al salario promedio correspondiente      *** --->
		<!--- ************************************************************************************************************* --->		

		<!--- ************************************************************************************************************* --->
		<!--- ***  calculo del salario promedio para el pago de vacaciones fuera de periodo cumplido  ljimenez          *** --->
		<!--- ************************************************************************************************************* --->					
		
		<cfset SalarioPromedioVacLiq = 0.0000>
			<cfif Len(RHAlinea) Is 0 Or RHAlinea Is 0>
				<cfset Tcodigo = Arguments.Tcodigo>
			<cfelse>
				<cfif isdefined("arguments.origen") and origen eq 'DLaboralesEmpleado'>
					<cfquery name="rsTcodigo" datasource="#Session.DSN#">
						select Tcodigo
						from DLaboralesEmpleado
						where DLlinea = #RHAlinea#
					</cfquery>
				<cfelse>
					<cfquery name="rsTcodigo" datasource="#Session.DSN#">
						select Tcodigo
						from RHAcciones
						where RHAlinea = #RHAlinea#
					</cfquery>
				</cfif>
				
				<cfset Tcodigo = rsTcodigo.Tcodigo>
			</cfif>
			<cfif not lvarMasivo>
				<cf_dbtemp name="SP_PagosEmp" returnvariable="tbl_PagosEmpleado">
					<!--- <cf_dbtempcol name="Registro" type="numeric" identity="yes" mandatory="yes">  --->
					<cf_dbtempcol name="RCNid" type="numeric">
					<cf_dbtempcol name="DEid" type="numeric"> 
					<cf_dbtempcol name="FechaDesde" type="datetime">
					<cf_dbtempcol name="FechaHasta" type="datetime">
					<cf_dbtempcol name="Cantidad" type="int">
					<cf_dbtempcol name="RHAlinea" type="numeric">
					<cf_dbtempkey cols="RCNid,DEid">
					<!--- <cf_dbtempkey cols="Registro"> --->
				</cf_dbtemp>
			</cfif>
			
			<cfquery name="rsTipoPago" datasource="#Session.DSN#">
				select Ttipopago
				from TiposNomina
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Tcodigo#">
			</cfquery>
			<cfset Ttipopago = rsTipoPago.Ttipopago>
		
			<cfquery name="rsDiasNoPago" datasource="#Session.DSN#">
				select count(1) as diasnopago
				from DiasTiposNomina
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Tcodigo#">
			</cfquery>
			<cfset DiasNoPago = rsDiasNoPago.diasnopago>
		
			<cfswitch expression="#Ttipopago#">
				<cfcase value="0"> <cfset DiasNoPago = DiasNoPago * 1> </cfcase>
				<cfcase value="1"> <cfset DiasNoPago = DiasNoPago * 2> </cfcase>
				<cfcase value="2"> <cfset DiasNoPago = DiasNoPago * 2> </cfcase>
				<cfcase value="3"> <cfset DiasNoPago = DiasNoPago * 4> </cfcase>
				<cfdefaultcase> <cfset DiasNoPago = DiasNoPago * 1> </cfdefaultcase>
			</cfswitch>
			
			<!--- Saca de parametros RH la cantidad de meses o periodos a tomar en cuenta para el calculo de salario Promedio default 13 periodos--->
			<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#" 
				ecodigo="#session.Ecodigo#" pvalor="160" default="13" returnvariable="CantidadPeriodos"/>

			<!--- Saca de parametros RH el indicador de meses (1) o periodos (0) --->
			<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#" 
				ecodigo="#session.Ecodigo#" pvalor="161" default="0" returnvariable="TipoPeriodos"/>
			
			<!---ljimenez si el concepto de pago trae los parametros para el calculo de salario promedio los utiliza.--->
			<cfif isdefined("arguments.CIsprango") and #arguments.CIsprango# GT 0>
				<cfset TipoPeriodos 	= #arguments.CIsprango# >
				<cfset CantidadPeriodos = #arguments.CIspcantidad# >
			</cfif>
	
			<cfquery name="rsFecha1" datasource="#Session.DSN#">
				select max(CPdesde) as fecha1
				from CalendarioPagos
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Tcodigo#">
				and CPdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1_Accion#">
			</cfquery>
			
			<!---ljimenez si el concepto de pago trae parametro mes completo se actualiza la fecha al inicio del mes.--->
			<cfif isdefined("arguments.CImescompleto") and #arguments.CImescompleto# GT 0>
				<cfquery name="rsFecha1" datasource="#Session.DSN#">
					select #CreateDate(year(rsFecha1.fecha1), month(rsFecha1.fecha1), 01)# as fecha1
				</cfquery>
			</cfif>
				
			<cfquery name="rsFecha2" datasource="#Session.DSN#">
				select max(CPhasta) as fecha1
				from CalendarioPagos
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Tcodigo#">
				and CPdesde < <cfqueryparam cfsqltype="cf_sql_date" value="#rsFecha1.fecha1#">
			</cfquery>
			
				
			<cfset Fecha1 = rsFecha2.fecha1>
			<!--- JC Resta la cantidad de meses a Fecha1, es decir se devuelve esa cantidad de meses --->
			<cfif (Len(Trim(Fecha1)))>
				<cfset Fecha3 = DateAdd('m', -CantidadPeriodos, Fecha1)>
				
				<!---ljimenez buscamos las fecha maxima del calendario limite para nuestro calculo--->
				<cfquery name="rsFecha3" datasource="#Session.DSN#">
					select max(CPhasta) as fecha3
					from CalendarioPagos
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Tcodigo#">
					and  <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha3#"> between CPdesde and CPhasta
				</cfquery>
				<cfset Fecha3 = #rsFecha3.fecha3#>
			<cfelse>
				<cfset Fecha3 = DateAdd('m', -CantidadPeriodos, now())>  <!--- OJO ESTO LO TUVE QUE PONER PORQUE SI NO ME DA ERROR  DE NULL, NULL --->  
			</cfif>
			
			<cfif Len(Trim(Fecha1))>
				<cfquery name="rsFechax" datasource="#Session.DSN#">
					select EVfecha
					from EVacacionesEmpleado
					where DEid = #DEid#
					order by DEid
				</cfquery>
				
				<cfset Fecha2 = rsFechax.EVfecha>
				
				<cfquery name="tbl_PagosEmpleadoInsert" datasource="#session.DSN#">
					insert into #tbl_PagosEmpleado# (RCNid, DEid, FechaDesde, FechaHasta, Cantidad, RHAlinea)
					select distinct a.RCNid, #DEid#, a.RCdesde, a.RChasta, 0, <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
					from HSalarioEmpleado b, HRCalculoNomina a, CalendarioPagos cp
					where b.DEid = #DEid#
						and a.RCNid = b.RCNid
						and a.Ecodigo = #Ecodigo#
						and a.RChasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha1#">
						and a.RCdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#Fecha2#">   <!--- esta fecha es la que varia ljimenez --->
						and cp.CPid = a.RCNid
						<!--- ljimenez se elimina esta condicion para que tome en cuenta todas la nominas incluyendo las especiales
						la configuracion para ver si afectan o no afectan el salario promedio se hace a nivel de sistema --->
						<!---and cp.CPtipo = 0--->
					order by a.RChasta desc
				</cfquery>
			</cfif>
			
			<!--- Borrar de la historia los periodos donde existe incapacidad --->
			<!---El siguiente codigo se agrega debido a que en el ITCR pagan la incapacidad completa y la toman en cuenta para el calculo del salario promedio--->
				<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#" 
					ecodigo="#session.Ecodigo#" pvalor="2037" default="0" returnvariable="vUsaIncSP"/>
				
				<cfif #vUsaIncSP# EQ 0 >
					<cfquery name="delPagosEmpleado" datasource="#Session.DSN#">
						delete from #tbl_PagosEmpleado#
						where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
						  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
						  and exists (	select 1
										from HPagosEmpleado pe, RHTipoAccion d
										where pe.DEid = #tbl_PagosEmpleado#.DEid
											and pe.RCNid = #tbl_PagosEmpleado#.RCNid
											and d.RHTid = pe.RHTid
											and d.RHTcomportam = 5 )
					</cfquery>
					
					<cfquery name="delPagosEmpleado" datasource="#Session.DSN#">
						delete from #tbl_PagosEmpleado#
						where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
						  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
						  and exists (
							
							select 1
							from 	DLaboralesEmpleado a
							inner join  RHTipoAccion x
								on x.RHTid = a.RHTid
								and x.RHTcomportam = 5
							left outer join RHSaldoPagosExceso pe
								on a.DLlinea = pe.DLlinea
								and pe.RHSPEanulado = 0
							where a.DEid = #tbl_PagosEmpleado#.DEid
							and 
							(
							(a.DLfvigencia between  #tbl_PagosEmpleado#.FechaDesde and  #tbl_PagosEmpleado#.FechaHasta)
							or
							(a.DLffin between  #tbl_PagosEmpleado#.FechaDesde and  #tbl_PagosEmpleado#.FechaHasta)
							)
						)
					</cfquery>
				</cfif>
			<!--- Borrar de la historia los periodos donde existe permisos sin goce de salario --->
			<cfquery name="delPagosEmpleado" datasource="#Session.DSN#">
				delete from #tbl_PagosEmpleado#
				where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
				  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
				  and exists (	select 1
								from HPagosEmpleado pe, RHTipoAccion d
								where pe.DEid = #tbl_PagosEmpleado#.DEid
									and pe.RCNid = #tbl_PagosEmpleado#.RCNid
									and d.RHTid = pe.RHTid
									and d.RHTcomportam = 4 
									AND d.RHTpaga = 0)
			</cfquery>
			
			<cfquery name="delPagosEmpleado" datasource="#Session.DSN#">
				delete from #tbl_PagosEmpleado#
				where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
				  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
				  and exists (
					select 1
					from 	DLaboralesEmpleado a
					inner join  RHTipoAccion x
						on x.RHTid = a.RHTid
						and x.RHTcomportam = 4 
						and x.RHTpaga = 0
					left outer join RHSaldoPagosExceso pe
						on a.DLlinea = pe.DLlinea
						and pe.RHSPEanulado = 0
					where a.DEid = #tbl_PagosEmpleado#.DEid
					and 
					(
					(a.DLfvigencia between  #tbl_PagosEmpleado#.FechaDesde and  #tbl_PagosEmpleado#.FechaHasta)
					or
					(a.DLffin between  #tbl_PagosEmpleado#.FechaDesde and  #tbl_PagosEmpleado#.FechaHasta)
					)
				)
			</cfquery>
			
			<!---	Borrar de la historia los periodos anteriores o iguales a una salida de la empresa 
					Se busca la fecha maxima de salida y se eliminan los pagos anteriores --->
				<cfquery name="rsFechaSalida" datasource="#Session.DSN#">
					select max(DLfvigencia) as fechasalida
					from DLaboralesEmpleado dl, RHTipoAccion ta
					where dl.DEid = #DEid#
					and ta.RHTid = dl.RHTid
					and ta.RHTcomportam = 2
					and dl.DLlinea !=  #vDLlinea#					
				</cfquery>
				<cfif rsFechaSalida.recordCount and Len(Trim(rsFechaSalida.fechasalida))>
					<cfquery name="delPagosEmpleado" datasource="#Session.DSN#">
						delete from #tbl_PagosEmpleado#
						where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
						  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
						  and (  
						  	FechaDesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechaSalida.fechasalida#"> 
							or
						  	FechaHasta <= <cfqueryparam cfsqltype="cf_sql_date" value="#rsFechaSalida.fechasalida#"> 	
						  )
					</cfquery>
				</cfif>

				<cfquery name="rsPagosEmpleado" datasource="#Session.DSN#">
					select *
					from #tbl_PagosEmpleado#
					WHERE RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
					  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
					<!---order by Registro --->
					 order by FechaHasta desc,RCNid,DEid
				</cfquery>
				<cfloop query="rsPagosEmpleado">
					<cfquery name="updPagoEmpleado" datasource="#Session.DSN#">
						update #tbl_PagosEmpleado#
						set Cantidad = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPagosEmpleado.CurrentRow#">
						 <!--- where Registro = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPagosEmpleado.Registro#"> --->
						where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPagosEmpleado.RCNid#">
						and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPagosEmpleado.DEid#">
					</cfquery>
				</cfloop>

				<cfquery name="rsPagosEmpleado" datasource="#Session.DSN#">
					select 1
					from #tbl_PagosEmpleado#
					where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
					  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
				</cfquery>
				<cfif rsPagosEmpleado.recordCount>
				
				<!---ljimenez Tomar en salario promedio los retroactivos distribuidos por mes --->
					<cfinvoke component="rh.Componentes.RHParametros" method="get" 
						datasource="#session.dsn#" ecodigo="#session.Ecodigo#" pvalor="2038" default="0" returnvariable="vUsaRetro"/>				
	
					<cfif #vUsaRetro# eq 1>
						<!---Saco el salario que le corresponde a la nomina sin los retroactivos--->
						<cfquery name="rsSalarioPromedio01" datasource="#Session.DSN#">
							select coalesce(sum(hp.PEmontores),0) as salario
							from  HPagosEmpleado hp
								inner join HRCalculoNomina n
									inner join #tbl_PagosEmpleado# pe
									on pe.RCNid=n.RCNid
								on n.RCNid=hp.RCNid
								and n.RCdesde=hp.PEdesde
								and n.RChasta=hp.PEhasta
							where pe.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
							and hp.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
						</cfquery>
						
						<!---Saco el salario si tiene algun retroactivo--->
						<cfquery name="rsSalarioPromedioR" datasource="#session.dsn#">
							select coalesce(sum(hp.PEmontores),0) as salario
								from  HPagosEmpleado hp,#tbl_PagosEmpleado# pe
								where hp.PEdesde  between pe.FechaDesde and pe.FechaHasta
								and hp.PEtiporeg in (1,2)
								and  pe.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
								and hp.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
						</cfquery>	
					
						<!---Saco las incidencias del mes--->
						<cfquery name="rsSalarioPromedio2" datasource="#session.dsn#">
							select coalesce(sum(hi.ICmontores),0) as incidente
							from  HIncidenciasCalculo hi, HRCalculoNomina n,#tbl_PagosEmpleado# pe,CIncidentes ci
							where hi.RCNid=pe.RCNid
								and n.RCNid=hi.RCNid
								and hi.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
								and hi.ICfecha between n.RCdesde and n.RChasta
								and  pe.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
								and ci.CIid = hi.CIid
								and ci.CIafectasalprom = 0
						</cfquery>
						<!---saco las incidencias retroactivas--->
						<cfquery name="rsSalarioPromedioRI" datasource="#Session.DSN#">
							select coalesce(sum(hi.ICmontores),0) as incidente
							from  HIncidenciasCalculo hi, #tbl_PagosEmpleado# pe,CIncidentes ci
							where hi.RCNid=pe.RCNid
								and hi.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
								and hi.ICfecha between pe.FechaDesde and pe.FechaHasta
								and  pe.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
								and ci.CIid = hi.CIid
								and ci.CIafectasalprom = 0
						</cfquery>
						<cfquery name="rsSalarioPromedio3" datasource="#Session.DSN#">
							select sum(coalesce(PEcantdias, 0)) as dias
							from HPagosEmpleado b, #tbl_PagosEmpleado# a
							where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
							  and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
							  and b.RCNid = a.RCNid
							  and b.DEid = a.DEid
							  and b.PEtiporeg = 0
						</cfquery>
						<cfif rsSalarioPromedio3.recordCount GT 0 AND rsSalarioPromedio3.dias GT 0>
							<cfset Lvardias = rsSalarioPromedio3.dias>
						<cfelse>
							<cfset Lvardias = 1>
						</cfif>
						<cfset Lvardias = Lvardias * 1.0000>	

						<!--- Obtener el salario promedio diario --->
						<cfset SalarioPromedio = ((rsSalarioPromedio01.salario+rsSalarioPromedioR.salario) - (rsSalarioPromedio2.incidente+rsSalarioPromedioRI.incidente)) / Lvardias>
					<cfelse>
					<cfquery name="rsSalarioPromedioVacLiq1" datasource="#Session.DSN#">
						select sum(SEsalariobruto + SEincidencias) as salario
						from HSalarioEmpleado se, #tbl_PagosEmpleado# pe
						where se.RCNid = pe.RCNid
						  and se.DEid = pe.DEid
						  and pe.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
						  and pe.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
					</cfquery>

					<cfquery name="rsSalarioPromedioVacLiq2" datasource="#Session.DSN#">
						select coalesce(sum(ic.ICmontores), 0.00) as incidencias
						from #tbl_PagosEmpleado# pe, HIncidenciasCalculo ic, CIncidentes ci
						where pe.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
						  and pe.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
						  and  ic.RCNid = pe.RCNid
						  and ic.DEid = pe.DEid
						  and ci.CIid = ic.CIid
						  and ci.CIafectasalprom = 0
					</cfquery>
					
					<cfquery name="rsSalarioPromedioVacLiq3" datasource="#Session.DSN#">
						select sum(coalesce(PEcantdias, 0)) as dias
						from HPagosEmpleado b, #tbl_PagosEmpleado# a
						where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarRHAlinea#">
						  and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
						  and b.RCNid = a.RCNid
						  and b.DEid = a.DEid
						  and b.PEtiporeg = 0
					</cfquery>
		
					
					<cfif rsSalarioPromedioVacLiq3.recordCount GT 0 AND rsSalarioPromedioVacLiq3.dias GT 0>
						<cfset Lvardias = rsSalarioPromedioVacLiq3.dias>
					<cfelse>
						<cfset Lvardias = 1>
					</cfif>
						
					<cfset Lvardias = Lvardias * 1.0000>	
					
					<!--- Obtener el salario promedio diario --->
					<cfset SalarioPromedioVacLiq = (rsSalarioPromedioVacLiq1.salario - rsSalarioPromedioVacLiq2.incidencias)>
					<cfset SalarioPromedioVacLiq = SalarioPromedioVacLiq / Lvardias>
			</cfif>
					

					

					<!--- Salario Promedio = Salario Promedio Diario * Cantidad de Dias para calculo de Salario Diario --->
					<cfquery name="rsParametros" datasource="#Session.DSN#">
						select FactorDiasSalario as Pvalor
						from TiposNomina
						where Ecodigo = #session.Ecodigo#
						  and Tcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Tcodigo#">
					</cfquery>
					<cfif len(trim(rsParametros.Pvalor)) EQ 0 or rsParametros.RecordCount EQ 0>
						<cfquery name="rsParametros" datasource="#Session.DSN#">
							select Pvalor
							from RHParametros
							where Ecodigo = #Ecodigo#
							and Pcodigo = 80
						</cfquery>
					</cfif>
					
					<!---<cfset SalarioPromedioVacLiq = SalarioPromedioVacLiq * rsParametros.Pvalor> --->
					

					<cfif not lvarMasivo>
						<cfquery name="dropPagosEmpleado" datasource="#Session.DSN#">
							delete  from #tbl_PagosEmpleado#
						</cfquery>
					</cfif>
					

				<cfelse>
					<cfset SalarioPromedioVacLiq = 0>
				</cfif>
		
		SalarioPromedioVacLiq = <cfoutput>#SalarioPromedioVacLiq#</cfoutput>

		
		
		<!--- ************************************************************************************************************* --->
		<!--- ***  Fin calculo del salario promedio para el pago de vacaciones fuera de periodo cumplido   ljimenez     *** --->
		<!--- ************************************************************************************************************* --->					

		<!--- ************************************************************************************************************* --->
		<!--- ***  Inicio calculo dias de vacaciones que le corresponde para el periodo cumplido           ljimenez     *** --->
		<!--- ************************************************************************************************************* --->		
		

		<cfset VacacionesPeriodo = 0.00>
		
		<!--- Solo si viene la accin se procede a calcular el saldo de vacaciones --->
		
		<cfif Len(Trim(Arguments.DEid)) NEQ 0 and Arguments.DEid GT 0>
	
			<cfset Finicio = #Arguments.Fecha1_Accion#>
			<cfset Ffin	   = #Arguments.Fecha2_Accion#>
			
			
			<!--- calcula la cantidad de aos laborados, a partir de su ingreso --->
			<cfquery name="rsFechaAntig" datasource="#session.DSN#">
				select EVfantig 
				from EVacacionesEmpleado 
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
			</cfquery>
            
			<cfif isdefined('rsFechaAntig') and rsFechaAntig.RecordCount GT 0>
				<cfset anno = DateDiff('yyyy', #rsFechaAntig.EVfantig#, Finicio)>
            <cfelse>
            	<cfset anno = 0>
            </cfif>
            
           

            <!----            
            <cfif Len(Trim(Arguments.DEid)) NEQ 0 and Arguments.DEid EQ 413>
            	<cfdump var="#rsFechaAntig#">
				<cf_dump var="#anno#">
			</cfif>
			--->
            
			<!--- Regimen de Vacaciones --->
			<cfquery name="rsRegimen" datasource="#session.DSN#">
				select RVid 
				from LineaTiempo 
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
				  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
				  and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.Fecha2_Accion#"> between LTdesde and LThasta
			</cfquery>
			<!--- Calcula la cantidad de dias para el siguiente corte que le corresponden segun el regimen de vacaciones y la cantidad de años laborados --->
            <cfif rsRegimen.RecordCount>
			<cfquery name="rsDias" datasource="#session.DSN#">
				select coalesce(rv.DRVdias, 0) as DRVdias
				from DRegimenVacaciones rv 
				where rv.RVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRegimen.RVid#">
				  and rv.DRVcant = ( select coalesce(max(DRVcant),1) 
									 from DRegimenVacaciones rv2 
									 where rv2.RVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRegimen.RVid#">
									   and rv2.DRVcant <= <cfqueryparam cfsqltype="cf_sql_numeric" value="#anno#">)
			</cfquery>
			</cfif>
			
						<!--- calcula el saldo corriente de vacaciones --->
			<cfif isdefined('rsDias') and rsDias.recordCount GT 0 and Len(Trim(rsDias.DRVdias))>
				<cfset VacacionesPeriodo = rsDias.DRVdias>
			</cfif>
		</cfif>
		VacacionesPeriodo = <cfoutput>#VacacionesPeriodo#</cfoutput>
		
		<!--- ************************************************************************************************************* --->
		<!--- ***  Fin calculo dias de vacaciones que le corresponde para el periodo cumplido              ljimenez     *** --->
		<!--- ************************************************************************************************************* --->
		
		<!--- ************************************************************************************************************* --->
		<!--- ***  Variable Salario Diario Integral (Par&aacute;metros Generales Para Mexico, SDI)          		    *** --->
		<!--- ************************************************************************************************************* --->
		<cfset SMGA = 0.00>
		<cfinvoke component="rh.Componentes.RHLiquidacionMX" method="fnGetSalarioMinimo" returnvariable="SMGA">
			<cfinvokeargument name="Validar" value="false">
		</cfinvoke>
		SMGA = <cfoutput>#SMGA#</cfoutput>
		
		<cfset SMG = 0.00>
		<cfinvoke component="rh.Componentes.RH_CalculoNomina" method="SMG" returnvariable="SMG">
			<cfinvokeargument name="DEid" value="#Arguments.DEid#">
		</cfinvoke>
		SMG = <cfoutput>#SMG#</cfoutput>
		
		<cfset SDI = 0.00>
		<cfinvoke component="rh.Componentes.RH_CalculoNomina" method="SDI" returnvariable="SDI">
			<cfinvokeargument name="DEid" value="#Arguments.DEid#">
		</cfinvoke>
		SDI = <cfoutput>#SDI#</cfoutput>
        
        
        <!---SML. Inicio Variable para el calculo de Prop Prima Vacacional --->
		<cfset saldo_PrimaVac = 0><!--- 4-3-2010 Modificacion Vacaciones Mexico sobre 365 dias Saldo_Vacaciones365--->
        <cfset saldo_PropPrimaVac = 0>
        <cfset saldo_PrimaVacacional = 0.00>
		<!--- Solo si viene la accin se procede a calcular el saldo de vacaciones --->
		<cfif Len(Trim(Arguments.RHAlinea)) NEQ 0 and Arguments.RHAlinea NEQ 0>
			<cfif isdefined("arguments.origen") and origen eq 'DLaboralesEmpleado'>
				<cfquery name="rsFechaLiquidacion" datasource="#session.dsn#">
					select <cf_dbfunction name="dateadd" args="-1,a.DLfvigencia"> as fechaliquidacion
					from DLaboralesEmpleado a
					where a.DLlinea = #Arguments.RHAlinea#
				</cfquery>
			<cfelse>
				<cfquery name="rsFechaLiquidacion" datasource="#session.dsn#">
					select a.DLfvigencia as fechaliquidacion
					from RHAcciones a
					where a.RHAlinea = #Arguments.RHAlinea#
				</cfquery>
			</cfif>	
			<!--- Vacaciones Acumuladas --->
			<cfquery name="rsVacaciones" datasource="#Session.DSN#">
				select 	a.DEid, 
						coalesce(a.EVfecha, a.EVfantig) as Antiguedad, 
						coalesce(sum(b.DVEdisfrutados + b.DVEcompensados), 0.00) as Disponibles, 
						coalesce(sum(b.DVEenfermedad), 0.00) as DVEenfermedad,
						a.EVfantig
				from EVacacionesEmpleado a
					left outer join DVacacionesEmpleado b
						on a.DEid = b.DEid
						<!--- Se asumen que todas las vacaciones cuenta porque se esta ante una liquidacion
								Se realizan ajustes manuales en caso de que la liquidacion sea anterior a una accion de disfrute de vacaciones --->
				where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
				group by a.DEid, coalesce(a.EVfecha, a.EVfantig),a.EVfantig
			</cfquery>
            <cfif rsVacaciones.RecordCount and rsFechaLiquidacion.RecordCount GT 0>
				<!--- Regimen de Vacaciones --->
                <cfquery name="rsRegimen" datasource="#session.DSN#">
                    select RVid 
                    from LineaTiempo 
                    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#"> 
                      and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
                      and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsFechaLiquidacion.fechaliquidacion#"> between LTdesde and LThasta
                </cfquery>
   			<cfif rsRegimen.RecordCount GT 0>
					<!--- Lizandro pidio descomentar esta linea siguiente y comentar la que esta dos lineas abajo. --->			
                    <cfset vFecha = ListToArray(LSDateFormat(rsVacaciones.Antiguedad,'dd/mm/yyyy'),'/')>
                    <cfset vFecha365 = ListToArray(LSDateFormat(rsVacaciones.EVfantig,'dd/mm/yyyy'),'/')> <!--- 4-3-2010 Modificacion Vacaciones Mexico sobre 365 dias--->
                    <cfset Lvarfecha_ingreso = Createdate(vFecha[3],vFecha[2],vfecha[1]) >
                    <cfset Lvarfecha_ingreso365 = Createdate(vFecha365[3],vFecha365[2],vfecha365[1]) >
                    <!--- calcula la cantidad de aos laborados, a partir de su ingreso --->
                    <cfset anno = DateDiff('yyyy', Lvarfecha_ingreso, rsFechaLiquidacion.fechaliquidacion)>
                    <cfset anno365 = (DateDiff('d', Lvarfecha_ingreso365, rsFechaLiquidacion.fechaliquidacion-1)/365)> <!--- 5-3-2010 Modificacion Vacaciones Mexico sobre 365 dias--->
                    <!--- objeto date con la fecha del ltimo corte --->
                    <cfset Lvarfecha_corte = DateAdd('yyyy', anno, Lvarfecha_ingreso)>
            
                    <!--- calcula la cantidad de meses desde la fecha_corte(dia, mes de ingreso, ao en curso) hasta la fecha de hoy --->
                    <!--- 3-10-2010 LZ. La Fecha de Liquidacion siempre es Igual a un Día despues del último día laborado--->
                    <cfset meses = DateDiff('d', Lvarfecha_corte, rsFechaLiquidacion.fechaliquidacion)>
                    <cfset dias365 = meses> <!--- 4-3-2010 Modificacion Vacaciones Mexico sobre 365 dias--->
                    <cfset meses = meses  / 30.0>
                    
                    <!--- Calcula la cantidad de dias para el siguiente corte que le corresponden segun el regimen de vacaciones y la cantidad de aos laborados --->
                    <cfquery name="rsDias" datasource="#session.DSN#">
                        select coalesce(rv.DRVdias, 0) as DRVdias
                        from DRegimenVacaciones rv 
                        where rv.RVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRegimen.RVid#">
                          and rv.DRVcant = ( select coalesce(max(DRVcant),1) 
                                             from DRegimenVacaciones rv2 
                                             where rv2.RVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRegimen.RVid#">
                                               and rv2.DRVcant <= <cfqueryparam cfsqltype="cf_sql_float" value="#anno+1#"> )
                    </cfquery>
                    
                    <!--- 4-3-2010 Modificacion Vacaciones Mexico sobre 365 dias--->
                    <cfquery name="rsDias365" datasource="#session.DSN#">
                        select coalesce(rv.DRVdias, 0) as DRVdias
                        from DRegimenVacaciones rv 
                        where rv.RVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRegimen.RVid#">
                          and rv.DRVcant = ( select coalesce(max(DRVcant),1) 
                                             from DRegimenVacaciones rv2 
                                             where rv2.RVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRegimen.RVid#">
                                               and rv2.DRVcant <= <cfqueryparam cfsqltype="cf_sql_float" value="#anno365+1#"> )
                    </cfquery>
                    <!--- calcula el saldo corriente de vacaciones --->
                    <cfif rsDias.recordCount GT 0 and Len(Trim(rsDias.DRVdias))>
                    <!--- 3-10-2010 LZ Se Incluye generacion de Saldo Corriente para Vacaciones 360--->
                        <cfset saldo_PrimaVac = (dias365/365) * rsDias365.DRVdias> 				<!--- 4-3-2010 Modificacion Vacaciones Mexico sobre 365 dias--->
                    </cfif>
                    
                    <cfquery name="vParam" datasource="#session.dsn#">
						select Pvalor from RHParametros where Pcodigo = 2031 and Ecodigo=#session.Ecodigo#
					</cfquery>
                    
                    <cfif isdefined('vParam') and len(trim(vParam.Pvalor)) GT 0>
                    	<cfquery name="validacionPrima" datasource="#session.dsn#">
							select 1 as validacion from HIncidenciasCalculo
							where CIid in (#vParam.Pvalor#) 
								and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
								and CPperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#vFecha[3]#">
                    	</cfquery>
            		</cfif>
                    
                    <cfif isdefined('validacionPrima') and validacionPrima.RecordCount EQ 0>
                        <cfset saldo_PrimaVacacional = #rsVacaciones.Disponibles# + #saldo_PrimaVac#> <!--- 4-3-2010 Modificacion Vacaciones Mexico sobre 365 dias--->
                    <cfelse>
                        <cfset saldo_PrimaVacacional = #saldo_PrimaVac#>							<!--- 4-3-2010 Modificacion Vacaciones Mexico sobre 365 dias--->	
                    </cfif>
              	</cfif>
              </cfif>
              </cfif>
			  saldo_PrimaVacacional = <cfoutput>#saldo_PrimaVacacional#</cfoutput> 
	
        <!---SML. Final Variable para el calculo de Prop Prima Vacacional --->
        

	</cfsavecontent>
