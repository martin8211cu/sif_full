<!---
	Componente de Contabilidad General.
	Contiene las siguientes funciones:
		1. Nuevo_Asiento
		3. Cierre_Mes
--->
<cfcomponent displayname="Contabilidad" hint="Funciones Módulo de Contabilidad General">
	<!---
		1. Función Nuevo Asiento
	--->
	<cffunction output="false" name="Nuevo_Asiento" access="public" returntype="numeric" hint="Retorna Edocumento">
		<cfargument name="Ecodigo" type="numeric" required="no">
		<cfargument name="Conexion" type="string" required="no">
		
		<cfargument name="Cconcepto" type="string" required="no" default="-1">
		<cfargument name="Oorigen" type="string" required="yes">
		<cfargument name="Eperiodo" type="numeric" required="yes">
		<cfargument name="Emes" type="numeric" required="yes">
		
		<cfargument name="Ocodigo" type="string" required="no" default="">	<!--- Mandar un -1 para que no sea tomado en cuenta --->
		<cfargument name="Usucodigo" type="string" required="no" default="">	<!--- Mandar un -1 para que no sea tomado en cuenta --->
		<cfargument name="Efecha" type="date" required="no">
		
		<cfif len(trim(Arguments.Cconcepto)) eq 0 >
			<cfset Arguments.Cconcepto = -1 >		
		</cfif>
		
		<cfif not isdefined("arguments.ecodigo")>
		 	<cfset arguments.ecodigo = session.Ecodigo>
		</cfif>

		<cfif not isdefined("arguments.conexion")>
		 	<cfset arguments.conexion = session.dsn>
		</cfif>

		<!---1--->
		<cfif Arguments.Cconcepto EQ -1 >
			<cfquery name="rsNA1" datasource="#Arguments.Conexion#">
				select Cconcepto
				from ConceptoContable
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
					and Oorigen = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Oorigen#">
			</cfquery>
			<cfif rsNA1.RecordCount>
				<cfset Arguments.Cconcepto = rsNA1.Cconcepto>
			</cfif>
		</cfif>

		<!--- Obtención del agrupamiento según el Concepto Contable por Auxiliar --->
		<cfset Agrupamiento = 0>
		<cfquery name="rsAgrupamiento" datasource="#Arguments.Conexion#">
			select Resumir
			from ConceptoContable
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			and Cconcepto = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Cconcepto#">
			and Oorigen = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Oorigen#">
		</cfquery>
		<cfif rsAgrupamiento.recordCount>
			<cfset Agrupamiento = rsAgrupamiento.Resumir>
		</cfif>

		<!--- Filtros para la obtención del tipo de numeración para el Concepto Contable --->
		<cfset NumeracionConcepto = 0>
		<cfquery name="rsNumeracion" datasource="#Arguments.Conexion#">
			select Ctiponumeracion as NumeracionConcepto
			from ConceptoContableE
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			and Cconcepto = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Cconcepto#">
		</cfquery>
		<cfif rsNumeracion.recordCount>
			<cfset NumeracionConcepto = rsNumeracion.NumeracionConcepto>
		</cfif>

		<cfset LvEcodigo = Arguments.Ecodigo>
		<cfset LvCconcepto = Arguments.Cconcepto>
		<cfset LvEperiodo = Arguments.Eperiodo>
		<cfset LvEmes = Arguments.Emes>
		
		<cfif NumeracionConcepto EQ 3>
			<!--- Por Empresa --->
			<cfset LvCconcepto = 0>
			<cfset LvEperiodo = 0>
			<cfset LvEmes = 0>
		</cfif> 
		<cfif NumeracionConcepto EQ 2>
			<!--- Por Empresa / Concepto --->
			<cfset LvEperiodo = 0>
			<cfset LvEmes = 0>
		</cfif> 
		<cfif NumeracionConcepto EQ 1>
			<!--- Por Empresa / Concepto / Periodo --->
			<cfset LvEmes = 0>
		</cfif> 

		<!---2--->
		<cfif LvCconcepto EQ -1 >
			<cf_errorCode	code = "51118" msg = "No se ha definido el concepto de asiento contable">
		</cfif>

		<cfset ExisteEnEcontables = false>
		<cfif NOT (Agrupamiento EQ 0 OR NOT isdefined("Arguments.Ocodigo") OR Len(Trim(Arguments.Ocodigo)) EQ 0 OR NOT isdefined("Arguments.Usucodigo") OR Len(Trim(Arguments.Usucodigo)) EQ 0 OR NOT isdefined("Arguments.Efecha") OR Len(Trim(Arguments.Efecha)) EQ 0)>
			<cfquery name="rsEContables" datasource="#Arguments.Conexion#">
				select 1 
				from EContables ed
				where ed.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvEcodigo#">
				and ed.Cconcepto = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvCconcepto#">
				and ed.Eperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvEperiodo#">
				and ed.Emes = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvEmes#">
				and ed.Oorigen = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Oorigen#">
				<cfif IsDefined("Arguments.Ocodigo") and IsNumeric(Arguments.Ocodigo) and (Agrupamiento EQ 2 OR Agrupamiento EQ 3 OR Agrupamiento EQ 5 OR Agrupamiento EQ 6)>
				and ed.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ocodigo#">
				</cfif>
				<cfif IsDefined("Arguments.Efecha") and IsDate(Arguments.Efecha) and (Agrupamiento EQ 4 OR Agrupamiento EQ 5 OR Agrupamiento EQ 6)>
				and <cf_dbfunction name="to_datechar" args="ed.Efecha"> = <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Efecha#">
				</cfif>
				<cfif IsDefined("Arguments.Usucodigo") and IsNumeric(Arguments.Usucodigo) and (Agrupamiento EQ 4 OR Agrupamiento EQ 5 OR Agrupamiento EQ 6)>
				and ed.ECusucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
				</cfif>
				and ed.ECestado = 0 
			</cfquery>
			<cfif rsEContables.recordCount GT 0>
				<cfset ExisteEnEcontables = true>
			</cfif>
		</cfif>

		<!--- Si es necesario generar un nuevo documento, No se puede resumir si no viene alguno de los campos --->
		<cfif Agrupamiento EQ 0 OR NOT isdefined("Arguments.Ocodigo") OR Len(Trim(Arguments.Ocodigo)) EQ 0 OR NOT isdefined("Arguments.Usucodigo") OR Len(Trim(Arguments.Usucodigo)) EQ 0 OR NOT isdefined("Arguments.Efecha") OR Len(Trim(Arguments.Efecha)) EQ 0 OR NOT ExisteEnEcontables>
			<cfquery name="rsNA2" datasource="#Arguments.Conexion#">
				select count(1) as cuenta
				from ConceptoContableN
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvEcodigo#">
				and Cconcepto = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvCconcepto#">
				and Eperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvEperiodo#">
				and Emes = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvEmes#">
			</cfquery>
			<cfif rsNA2.cuenta gt 0>
				<cfquery name="rsNA2" datasource="#Arguments.Conexion#">
					update ConceptoContableN
					set Edocumento = Edocumento + 1
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvEcodigo#">
					and Cconcepto = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvCconcepto#">
					and Eperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvEperiodo#">
					and Emes = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvEmes#">
				</cfquery>
			<cfelse>
				  <cftry>
						<cfquery name="rsNA2" datasource="#Arguments.Conexion#">
							insert into ConceptoContableN (Ecodigo, Cconcepto, Eperiodo, Emes, Edocumento)
							values(<cfqueryparam cfsqltype="cf_sql_integer" value="#LvEcodigo#">
							, <cfqueryparam cfsqltype="cf_sql_integer" value="#LvCconcepto#">
							, <cfqueryparam cfsqltype="cf_sql_integer" value="#LvEperiodo#">
							, <cfqueryparam cfsqltype="cf_sql_integer" value="#LvEmes#">
							, 1)
						</cfquery>
					<cfcatch>
						<cf_errorCode	code = "51119" msg = "No se pudo insertar el Concepto Contable! (Tabla: ConceptoContableN) Proceso Cancelado!">
					</cfcatch>
				</cftry>
			</cfif>

			<cfquery name="rsNA3" datasource="#Arguments.Conexion#">
				select Edocumento
				from ConceptoContableN
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvEcodigo#">
				and Cconcepto = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvCconcepto#">
				and Eperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvEperiodo#">
				and Emes = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvEmes#">
			</cfquery>
			
		<!--- Si NO es necesario generar un nuevo documento, se busca el que ya existe y se devuelve ese --->
		<cfelse>
			<cfquery name="rsNA3" datasource="#Arguments.Conexion#">
				select min(ed.Edocumento) as Edocumento
				from EContables ed
				where ed.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvEcodigo#">
				and ed.Cconcepto = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvCconcepto#">
				and ed.Eperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvEperiodo#">
				and ed.Emes = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvEmes#">
				and ed.Oorigen = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Oorigen#">
				<cfif IsDefined("Arguments.Ocodigo") and IsNumeric(Arguments.Ocodigo) and (Agrupamiento EQ 2 OR Agrupamiento EQ 3 OR Agrupamiento EQ 5 OR Agrupamiento EQ 6)>
				and ed.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ocodigo#">
				</cfif>
				<cfif IsDefined("Arguments.Efecha") and IsDate(Arguments.Efecha) and (Agrupamiento EQ 4 OR Agrupamiento EQ 5 OR Agrupamiento EQ 6)>
				and <cf_dbfunction name="to_datechar" args="ed.Efecha"> = <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Efecha#">
				</cfif>
				<cfif IsDefined("Arguments.Usucodigo") and IsNumeric(Arguments.Usucodigo) and (Agrupamiento EQ 4 OR Agrupamiento EQ 5 OR Agrupamiento EQ 6)>
				and ed.ECusucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
				</cfif>
				and ed.ECestado = 0 
			</cfquery>
			
			<cfquery name="rsNA4" datasource="#Arguments.Conexion#">
					<!--- Cambio para modificar la descripcion del asiento contable que se va a agrupar --->
					update EContables
					set Edescripcion = 
						rtrim(
							coalesce(( select Odescripcion from Origenes where Oorigen = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Oorigen#"> ) , ' ')
							) 
						|| ':'
						<cfif IsDefined("Arguments.Usucodigo") and IsNumeric(Arguments.Usucodigo) and (Agrupamiento EQ 4 OR Agrupamiento EQ 5 OR Agrupamiento EQ 6)>
							||
							rtrim(
								coalesce(( select Usulogin from Usuario where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#"> ) , ' ')
								) 
						</cfif>
						<cfif IsDefined("Arguments.Ocodigo") and IsNumeric(Arguments.Ocodigo) and (Agrupamiento EQ 2 OR Agrupamiento EQ 3 OR Agrupamiento EQ 5 OR Agrupamiento EQ 6)>
							|| ' Oficina:' 
							||
							rtrim(
								coalesce(( select Oficodigo from Oficinas where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvEcodigo#"> and Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ocodigo#"> ) , ' ')
								) 
						</cfif>
						<cfif IsDefined("Arguments.Efecha") and IsDate(Arguments.Efecha) and (Agrupamiento EQ 4 OR Agrupamiento EQ 5 OR Agrupamiento EQ 6)>
							|| ' Fecha:' || LSDateformat(#Arguments.Efecha#, "DD/MM/YYYY")
						</cfif>
						where EContables.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvEcodigo#">
						and EContables.Cconcepto = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvCconcepto#">
						and EContables.Eperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvEperiodo#">
						and EContables.Emes = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvEmes#">
						and EContables.Oorigen = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.Oorigen#">
						<cfif IsDefined("Arguments.Ocodigo") and IsNumeric(Arguments.Ocodigo) and (Agrupamiento EQ 2 OR Agrupamiento EQ 3 OR Agrupamiento EQ 5 OR Agrupamiento EQ 6)>
							and EContables.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ocodigo#">
						</cfif>
						<cfif IsDefined("Arguments.Efecha") and IsDate(Arguments.Efecha) and (Agrupamiento EQ 4 OR Agrupamiento EQ 5 OR Agrupamiento EQ 6)>
							and <cf_dbfunction name="to_datechar" args="EContables.Efecha"> = <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.Efecha#">
						</cfif>
						<cfif IsDefined("Arguments.Usucodigo") and IsNumeric(Arguments.Usucodigo) and (Agrupamiento EQ 4 OR Agrupamiento EQ 5 OR Agrupamiento EQ 6)>
							and EContables.ECusucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
						</cfif>
						and EContables.ECestado = 0 
					  	and EContables.Edocumento = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsNA3.Edocumento#">
			</cfquery>
			
		</cfif>
		
		<cfreturn rsNA3.Edocumento>
	</cffunction>

	<!---
		3. Función Cierre Mes
	--->
	<cffunction output="true" name="Cierre_Mes" access="public" hint="Retorna Nulo">
		<cfargument name="Ecodigo" type="numeric" required="no">
		<cfargument name="Conexion" type="string" required="no">

		<cfargument name="debug" type="boolean" default="false">

		<cfif isdefined("session.Ecodigo") and not isdefined("arguments.ecodigo")>
		 	<cfset arguments.ecodigo = session.Ecodigo>
		</cfif>
		<cfif isdefined("session.dsn") and not isdefined("arguments.conexion")>
		 	<cfset arguments.conexion = session.dsn>
		</cfif>

		<!---1--->
		<cfset Pcodigo_per = 30>
		<cfset Pcodigo_mes = 40>
		<cfset Pcodigo_mes_fiscal = 45>
		<cfset Pcodigo_aux_per = 50>
		<cfset Pcodigo_aux_mes = 60>
		<cfset Pcodigo_utilidad = 300>
		<cfset sistema = 'CG'>
		<cfset sistema_aux = 'GN'>
		<!---2--->
		<!--- Obtener los valores de Conta --->
		<cfquery name="rsMes" datasource="#Arguments.Conexion#">
			select <cf_dbfunction name="to_number" datasource="#Arguments.Conexion#" args="Pvalor"> as mes
			from Parametros
			where Pcodigo = #Pcodigo_mes#
			and Mcodigo = '#sistema#'
			and Ecodigo = #Arguments.Ecodigo#
		</cfquery>
		<cfquery name="rsPeriodo" datasource="#Arguments.Conexion#">
			select <cf_dbfunction name="to_number" datasource="#Arguments.Conexion#" args="Pvalor"> as periodo
			from Parametros
			where Pcodigo = #Pcodigo_per#
			and Mcodigo = '#sistema#'
			and Ecodigo = #Arguments.Ecodigo#
		</cfquery>
		<cfquery name="rsMesFiscal" datasource="#Arguments.Conexion#">
			select <cf_dbfunction name="to_number" datasource="#Arguments.Conexion#" args="Pvalor"> as mes
			from Parametros
			where Pcodigo = #Pcodigo_mes_fiscal#
			and Mcodigo = '#sistema#'
			and Ecodigo = #Arguments.Ecodigo#
		</cfquery>
		<cfquery name="rsCuentaUtilidad" datasource="#Arguments.Conexion#">
			select Pvalor as cuenta
			from Parametros
			where Pcodigo = #Pcodigo_utilidad#
			and Mcodigo = '#sistema#'
			and Ecodigo = #Arguments.Ecodigo#
		</cfquery>
		
		<!---3--->
		<!--- Obtener los valores de Auxiliares --->
		<cfquery name="rsMes_Aux" datasource="#Arguments.Conexion#">
			select <cf_dbfunction name="to_number" datasource="#Arguments.Conexion#" args="Pvalor"> as mes_aux
			from Parametros
			where Pcodigo = #Pcodigo_aux_mes#
			and Mcodigo = '#sistema_aux#'
			and Ecodigo = #Arguments.Ecodigo#
		</cfquery>
		<cfquery name="rsPeriodo_Aux" datasource="#Arguments.Conexion#">
			select <cf_dbfunction name="to_number" datasource="#Arguments.Conexion#" args="Pvalor"> as periodo_aux
			from Parametros
			where Pcodigo = #Pcodigo_aux_per#
			and Mcodigo = '#sistema_aux#'
			and Ecodigo = #Arguments.Ecodigo#
		</cfquery>
		<!---4--->
		<!--- Validar si ya se realizo el cierre de Auxiliares --->
		<cfif ((rsPeriodo_Aux.periodo_aux lt rsPeriodo.periodo) or ((rsPeriodo_Aux.periodo_aux eq rsPeriodo.periodo) and (rsMes_Aux.mes_aux lte rsMes.mes)))>
			<cf_errorCode	code = "51120" msg = "Debe realizar el cierre de auxiliares, antes de realizar el cierre contable.">
		</cfif>
		<!---5--->
		<!--- validar si hay documentos sin Postear --->
		<cfquery name="rsNum_Docs" datasource="#Arguments.Conexion#">
			select count(1) as num_docs
			from EContables
			where Emes = #rsMes.mes#
			and Eperiodo = #rsPeriodo.periodo#
			and Ecodigo = #Arguments.Ecodigo#
		</cfquery>
		<cfif rsNum_Docs.num_docs gt 0>
			<cf_errorCode	code = "51121" msg = "Aún existen documentos sin postear, para esta empresa, mes y periodo.">
		</cfif>
		<!---6--->
		<cfset periodoant = rsPeriodo.periodo>
		<cfset mesant = rsMes.mes>
    	<!--- actualizar el mes y periodo --->
		<cfset result = querysetcell(rsMes,"mes",((rsMes.mes MOD 12) + 1))>
		
		<cfif rsMes.mes eq 1>
			<cfset result = querysetcell(rsPeriodo,"periodo",(rsPeriodo.periodo + 1))>
		</cfif>

		<!---7--->
		<cftransaction>
			<!---Cálculo de la Revaluación--->
			<!---
				Copiar los datos del periodo actual al nuevo periodo
				Cambio realizado.  No se generan registros cuando el saldo inicial es cero para no generar overhead 
			--->
			<cftry>
				<cfquery name="rsCM_Tran_1" datasource="#Arguments.Conexion#">
					insert into SaldosContables (Ecodigo, Ocodigo, Ccuenta, 
						Mcodigo, Speriodo, Smes, 
						SLinicial, DLdebitos, CLcreditos, 
						SOinicial, DOdebitos, COcreditos)
					select Ecodigo, Ocodigo, Ccuenta, 
						Mcodigo, #rsPeriodo.periodo#, #rsMes.mes#,
						SLinicial + DLdebitos - CLcreditos, 0, 0,
						SOinicial + DOdebitos - COcreditos, 0, 0
					from SaldosContables
					where Smes = #mesant#
						and Speriodo = #periodoant#
						and Ecodigo = #Arguments.Ecodigo#
						and (SLinicial + DLdebitos - CLcreditos <> 0.00 or SOinicial + DOdebitos - COcreditos <> 0.00)
				</cfquery>

				<cfcatch type="any">
					<cf_errorCode	code = "51127" msg = "Error en actualizar datos de Saldos Contables.">
				</cfcatch>
			</cftry>

			<!--- Realizar el cierre Anual --->
			<cfif mesant EQ rsMesFiscal.mes>
				<!--- Concepto Contable --->
				<cfquery name="rsConceptoContableE" datasource="#Arguments.Conexion#">
					select min(Cconcepto) as Cconcepto
					from ConceptoContable
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
					and Oorigen = 'CGDC'
				</cfquery>
				<cfif rsConceptoContableE.recordCount GT 0>
						<cfinvoke component="CG_GeneraAsiento" returnvariable="Intarc" method="CreaIntarc" ></cfinvoke>
						<cfquery name="rsIntarcInsert" datasource="#Arguments.Conexion#">
							insert into #Intarc#(Periodo, Mes, Ocodigo, INTDES, INTDOC, INTREF, INTTIP, Ccuenta, INTMOE, INTMON, Mcodigo, INTCAM, INTFEC, INTORI, INTREL)
							select 
								<cfqueryparam cfsqltype="cf_sql_integer" value="#periodoant#"> as Periodo,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#mesant#"> as Mes,
								a.Ocodigo as Oficina, 
								<cfqueryparam cfsqltype="cf_sql_varchar" value="Cierre Anual"> as Descripcion,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="Cierre Anual"> as Documento,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="Cierre Anual"> as Referencia,
								case when (SLinicial + DLdebitos - CLcreditos) < 0 then 'D' else 'C' end as TipoMovimiento, 
								a.Ccuenta as Cuenta, 
								abs(SOinicial + DOdebitos - COcreditos) as SaldoOrigen,
								abs(SLinicial + DLdebitos - CLcreditos) as SaldoLocal, 
								a.Mcodigo as Moneda,
								0.00 as TipoCambio,
								'?', '?', 0
							from SaldosContables a, CContables b, CtasMayor c
							where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
							  and a.Speriodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#periodoant#">
							  and a.Smes = <cfqueryparam cfsqltype="cf_sql_integer" value="#mesant#">
							  and ((SLinicial + DLdebitos - CLcreditos) <> 0.00 or (SOinicial + DOdebitos - COcreditos) <> 0.00)
							  and b.Ccuenta = a.Ccuenta
							  and b.Ecodigo = a.Ecodigo
							  and b.Cmovimiento = 'S'
							  and c.Cmayor = b.Cmayor
							  and c.Ecodigo = b.Ecodigo
							  and c.Ctipo in ('I', 'G')
						</cfquery>
						
						<!---
						<cfquery datasource="#Arguments.Conexion#" name="display1">
							select sum(i.INTMOE * (case i.INTTIP when 'C' then -1 else 1 end)) as diferencia_original,
								   sum(i.INTMON * (case i.INTTIP when 'C' then -1 else 1 end)) as diferencia_local
							from #Intarc# i
							group by Ocodigo, Mcodigo
						</cfquery>
						<cfdump var="#display1#">

						<cfquery datasource="#Arguments.Conexion#" name="display1">
							select *
							from #Intarc# i
							where Ocodigo = 0
							and Mcodigo = 3
							order by Ocodigo, Mcodigo
						</cfquery>
						<cfdump var="#display1#">

						--->
						
						<!---
						<cfquery name="VerificaSaldos3" datasource="#Arguments.Conexion#">
							select Mcodigo, Ocodigo, INTTIP, sum(INTMON) as MontoLocal, sum(INTMOE) as MontoMoneda, sum(INTMON * case when INTTIP = 'D' then 1 else -1 end) as MontoLocalTipo
							from #Intarc#
							group by Mcodigo, Ocodigo, INTTIP
						</cfquery>
						
						<cfdump var = "#VerificaSaldos3#">
						--->
						
						<!--- Caso en que la suma de Debitos - Creditos tanto en Moneda Origen como Moneda Local sean del mismo signo --->
						<cfquery name="rsIntarcUtilidad" datasource="#Arguments.Conexion#">
							insert into #Intarc#(Periodo, Mes, Ocodigo, INTDES, INTDOC, INTREF, INTTIP, Ccuenta, INTMOE, INTMON, Mcodigo, INTCAM, INTFEC, INTORI, INTREL)
							select 
								<cfqueryparam cfsqltype="cf_sql_integer" value="#periodoant#"> as Periodo,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#mesant#"> as Mes,
								Ocodigo as Oficina, 
								<cfqueryparam cfsqltype="cf_sql_varchar" value="Cierre Anual"> as Descripcion,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="Cierre Anual"> as Documento,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="Cierre Anual"> as Referencia,
								case 
								when sum(INTMOE * (case INTTIP when 'C' then -1 else 1 end)) > 0 then 'C' 
								when sum(INTMOE * (case INTTIP when 'C' then -1 else 1 end)) < 0 then 'D'
								else 
									case 
									when sum(INTMON * (case INTTIP when 'C' then -1 else 1 end)) > 0 then 'C' 
									else 'D'
									end
								end as TipoMovimiento,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCuentaUtilidad.cuenta#"> as Cuenta,
								abs(sum(INTMOE * (case INTTIP when 'C' then -1 else 1 end))) as SaldoOrigen,
								abs(sum(INTMON * (case INTTIP when 'C' then -1 else 1 end))) as SaldoLocal,
								Mcodigo as Moneda, 
								0.00 as TipoCambio,
								'?', '?', 0
							from #Intarc#
							where Ccuenta <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCuentaUtilidad.cuenta#">
							group by Ocodigo, Mcodigo
							having (sum(INTMOE * (case INTTIP when 'C' then -1 else 1 end)) <> 0 or sum(INTMON * (case INTTIP when 'C' then -1 else 1 end)) <> 0)
							and (
							(sum(INTMOE * (case INTTIP when 'C' then -1 else 1 end)) <= 0 and sum(INTMON * (case INTTIP when 'C' then -1 else 1 end)) <= 0)
							or
							(sum(INTMOE * (case INTTIP when 'C' then -1 else 1 end)) >= 0 and sum(INTMON * (case INTTIP when 'C' then -1 else 1 end)) >= 0)
							)
						</cfquery>
						
						<!---
						<cfquery datasource="#Arguments.Conexion#" name="display1">
							select sum(i.INTMOE * (case i.INTTIP when 'C' then -1 else 1 end)) as diferencia_original,
								   sum(i.INTMON * (case i.INTTIP when 'C' then -1 else 1 end)) as diferencia_local
							from #Intarc# i
							group by Ocodigo, Mcodigo
						</cfquery>
						<cfdump var="#display1#">

						<cfquery datasource="#Arguments.Conexion#" name="display1">
							select *
							from #Intarc# i
							where Ocodigo = 0
							and Mcodigo = 3
							order by Ocodigo, Mcodigo
						</cfquery>
						<cfdump var="#display1#">
						--->

						<!--- Suma de Montos en Moneda Origen dejando Moneda Local en cero cuando la suma de Debitos - Creditos en Moneda Origen son de signo diferente al de la Moneda Local --->
						<cfquery name="rsIntarcUtilidad2" datasource="#Arguments.Conexion#">
							insert into #Intarc#(Periodo, Mes, Ocodigo, INTDES, INTDOC, INTREF, INTTIP, Ccuenta, INTMOE, INTMON, Mcodigo, INTCAM, INTFEC, INTORI, INTREL)
							select 
								<cfqueryparam cfsqltype="cf_sql_integer" value="#periodoant#"> as Periodo,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#mesant#"> as Mes,
								Ocodigo as Oficina, 
								<cfqueryparam cfsqltype="cf_sql_varchar" value="Cierre Anual"> as Descripcion,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="Cierre Anual"> as Documento,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="Cierre Anual"> as Referencia,
								case 
								when sum(INTMOE * (case INTTIP when 'C' then -1 else 1 end)) > 0 then 'C' 
								else 'D'
								end as TipoMovimiento,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCuentaUtilidad.cuenta#"> as Cuenta,
								abs(sum(INTMOE * (case INTTIP when 'C' then -1 else 1 end))) as SaldoOrigen,
								0.00 as SaldoLocal,
								Mcodigo as Moneda, 
								0.00 as TipoCambio,
								'?', '?', 0
							from #Intarc#
							where Ccuenta <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCuentaUtilidad.cuenta#">
							group by Ocodigo, Mcodigo
							having (sum(INTMOE * (case INTTIP when 'C' then -1 else 1 end)) <> 0 or sum(INTMON * (case INTTIP when 'C' then -1 else 1 end)) <> 0)
							and not (
							(sum(INTMOE * (case INTTIP when 'C' then -1 else 1 end)) <= 0 and sum(INTMON * (case INTTIP when 'C' then -1 else 1 end)) <= 0)
							or
							(sum(INTMOE * (case INTTIP when 'C' then -1 else 1 end)) >= 0 and sum(INTMON * (case INTTIP when 'C' then -1 else 1 end)) >= 0)
							)
						</cfquery>
						
						<!---
						<cfquery datasource="#Arguments.Conexion#" name="display1">
							select Ocodigo, Mcodigo,
								   sum(i.INTMOE * (case i.INTTIP when 'C' then -1 else 1 end)) as diferencia_original,
								   sum(i.INTMON * (case i.INTTIP when 'C' then -1 else 1 end)) as diferencia_local
							from #Intarc# i
							group by Ocodigo, Mcodigo
						</cfquery>
						<cfdump var="#display1#">
						
						<cfquery datasource="#Arguments.Conexion#" name="display1">
							select *
							from #Intarc# i
							where Ocodigo = 0
							and Mcodigo = 3
							order by Ocodigo, Mcodigo
						</cfquery>
						<cfdump var="#display1#">
						--->

						<!--- Suma de Montos en Moneda Origen dejando Moneda Local en cero cuando la suma de Debitos - Creditos en Moneda Origen son de signo diferente al de la Moneda Local --->
						<cfquery name="rsIntarcUtilidad3" datasource="#Arguments.Conexion#">
							insert into #Intarc#(Periodo, Mes, Ocodigo, INTDES, INTDOC, INTREF, INTTIP, Ccuenta, INTMOE, INTMON, Mcodigo, INTCAM, INTFEC, INTORI, INTREL)
							select 
								<cfqueryparam cfsqltype="cf_sql_integer" value="#periodoant#"> as Periodo,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#mesant#"> as Mes,
								Ocodigo as Oficina, 
								<cfqueryparam cfsqltype="cf_sql_varchar" value="Cierre Anual"> as Descripcion,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="Cierre Anual"> as Documento,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="Cierre Anual"> as Referencia,
								case 
								when sum(INTMON * (case INTTIP when 'C' then -1 else 1 end)) > 0 then 'C' 
								else 'D'
								end as TipoMovimiento,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCuentaUtilidad.cuenta#"> as Cuenta,
								0.00 as SaldoOrigen,
								abs(sum(INTMON * (case INTTIP when 'C' then -1 else 1 end))) as SaldoLocal,
								Mcodigo as Moneda, 
								0.00 as TipoCambio,
								'?', '?', 0
							from #Intarc#
							where Ccuenta <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCuentaUtilidad.cuenta#">
							group by Ocodigo, Mcodigo
							having (sum(INTMOE * (case INTTIP when 'C' then -1 else 1 end)) <> 0 or sum(INTMON * (case INTTIP when 'C' then -1 else 1 end)) <> 0)
							and not (
							(sum(INTMOE * (case INTTIP when 'C' then -1 else 1 end)) <= 0 and sum(INTMON * (case INTTIP when 'C' then -1 else 1 end)) <= 0)
							or
							(sum(INTMOE * (case INTTIP when 'C' then -1 else 1 end)) >= 0 and sum(INTMON * (case INTTIP when 'C' then -1 else 1 end)) >= 0)
							)
						</cfquery>
						
						<!---
						<cfquery datasource="#Arguments.Conexion#" name="display1">
							select Ocodigo, Mcodigo,
								   sum(i.INTMOE * (case i.INTTIP when 'C' then -1 else 1 end)) as diferencia_original,
								   sum(i.INTMON * (case i.INTTIP when 'C' then -1 else 1 end)) as diferencia_local
							from #Intarc# i
							group by Ocodigo, Mcodigo
						</cfquery>
						<cfdump var="#display1#">
						
						<cfquery datasource="#Arguments.Conexion#" name="display1">
							select *
							from #Intarc# i
							where Ocodigo = 0
							and Mcodigo = 3
							order by Ocodigo, Mcodigo
						</cfquery>
						<cfdump var="#display1#">

						<cfquery name="VerificaSaldos1" datasource="#Arguments.Conexion#">
							select sum(a.SLinicial) as SaldoLocal, sum(a.SOinicial) as SaldoMoneda
							from SaldosContables a, CContables b
							where a.Ecodigo = #Arguments.Ecodigo#
							  and a.Speriodo = 2003
							  and a.Smes = 3
							  and a.Ccuenta = b.Ccuenta
							  and b.Cmayor = b.Cformato
						</cfquery>
						
						<cfdump var = "#VerificaSaldos1#">
						--->
						
						<cfinvoke component="CG_GeneraAsiento" returnvariable="IDcontable" method="GeneraAsiento">
							<cfinvokeargument name="Oorigen" value="CGDC">
							<cfinvokeargument name="Cconcepto" value="#rsConceptoContableE.Cconcepto#">
							<cfinvokeargument name="Eperiodo" value="#periodoant#">
							<cfinvokeargument name="Emes" value="#mesant#">
							<cfinvokeargument name="Efecha" value="#DateAdd('d', -1, DateAdd('m', 1, CreateDate(periodoant, mesant, 1)))#">
							<cfinvokeargument name="Edescripcion" value="Cierre Anual">
							<cfinvokeargument name="Edocbase" value="Cierre Anual">
							<cfinvokeargument name="Ereferencia" value="Cierre Anual">
							<cfinvokeargument name="interfazconta" value="true">
							<cfinvokeargument name="debug" value="false">
						</cfinvoke>

						<cfquery name="updEContable" datasource="#Arguments.Conexion#">
							update EContables
							set ECtipo = 1
							where IDcontable = #IDcontable#
						</cfquery>

						<cfinvoke component="sif.Componentes.CG_AplicaAsiento"  method="CG_AplicaAsiento">
							<cfinvokeargument name="IDcontable" value="#IDcontable#">
							<cfinvokeargument name="CtlTransaccion" value="false">
						</cfinvoke>

						<!---
						<cfquery name="VerificaSaldos" datasource="#Arguments.Conexion#">
							select b.Cmayor, a.Mcodigo, a.SLinicial, a.SOinicial
							from SaldosContables a, CContables b
							where a.Ecodigo = #Arguments.Ecodigo#
							  and a.Speriodo = 2003
							  and a.Smes = 3
							  and a.Ccuenta = b.Ccuenta
							  and b.Cmayor = b.Cformato
							order by b.Cmayor, a.Mcodigo
						</cfquery>
						<cfquery name="VerificaSaldos1" datasource="#Arguments.Conexion#">
							select sum(a.SLinicial) as SaldoLocal, sum(a.SOinicial) as SaldoMoneda
							from SaldosContables a, CContables b
							where a.Ecodigo = #Arguments.Ecodigo#
							  and a.Speriodo = 2003
							  and a.Smes = 3
							  and a.Ccuenta = b.Ccuenta
							  and b.Cmayor = b.Cformato
						</cfquery>

						<cfdump var="#VerificaSaldos#">
						<cfdump var="#VerificaSaldos1#">
						--->
						
				</cfif>
			</cfif>

			
			<!---Actualizar el Periodo y el Mes --->
			<cftry>
				<cfquery name="rsUpdParam1" datasource="#Arguments.Conexion#">
					update Parametros 
					set Pvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#NumberFormat(rsMes.mes,'0')#">
					where Ecodigo = #Arguments.Ecodigo#
					and Pcodigo = #Pcodigo_mes#
					and Mcodigo = '#sistema#'
				</cfquery>
				<cfquery name="rsUpdParam2" datasource="#Arguments.Conexion#">
					update Parametros 
					set Pvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#NumberFormat(rsPeriodo.periodo,'0')#">
					where Ecodigo = #Arguments.Ecodigo#
					and Pcodigo = #Pcodigo_per#
					and Mcodigo = '#sistema#'
				</cfquery>
				
				<cfcatch type="any">
					<cf_errorCode	code = "51126" msg = "Se presentó un error al intentar actualizar el período Contable. Proceso Cancelado!">
				</cfcatch>
			</cftry>
			<cfif Arguments.debug>
				<cftransaction action="rollback"/>
			</cfif>
		</cftransaction>
	</cffunction>
</cfcomponent>


