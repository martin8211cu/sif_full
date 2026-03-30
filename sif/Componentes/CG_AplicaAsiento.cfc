<!---
	Modificado por: Steve Vado
	Fecha : 22/Dic/2005
	Marca : SVR20050522-01
	Motivo:	Actualiza en GATransacciones cada uno de los documentos que	han sido aplicados,
			utilizando la referencias de las tablas EContables y DContables.

	<!-----
		M.Esquivel.  Modificación del componente el 27/Oct/2005:
		Soporte de Asientos Retroactivos Reversibles.  Un asiento retroactivo reversible debe generar el asiento en el siguiente mes,
		Tomando en consideración si el mes del nuevo asiento es anterior al cierre de la contabilidad.
		Si es anterior, lo genera retroactivo.
		Si es igual o mayor, lo genera normal.
	----->

	Modificado por Gustavo Fonseca H.
		Fecha: 9-3-2006.
		Motivo: Correción de la obtención del datasource y el Ecodigo en los querys del caso retroactivo,
		para que usen los de session. Tambien se corrige error de sintaxis en un insert a la tabla temporal.


--->
<cfcomponent output="no">
	<cffunction name="CG_AplicaAsiento" access="public" output="no">
		<cfargument name="IDcontable" 		type="numeric">
		<cfargument name="CtlTransaccion" 	type="boolean" 	default="true">
		<cfargument name="tipoMensaje" 		type="string" 	required="no" 	default="cfthrow">
		<cfargument name="inter" 			type="string" 	required="no" 	default="N">
		<cfargument name='MesCierre' 		type='boolean' 	required="no"	default="false">
<!--- Control Evento Inicia
        <cfargument name="NumeroEvento" 	type="string" 	required="no">
 Control Evento Fin --->

		<cfquery datasource="#session.dsn#" name="Periodo">
			select Pvalor from Parametros
			where Ecodigo = #session.Ecodigo#
			  and Pcodigo = 30
		</cfquery>

		<cfquery datasource="#session.dsn#" name="Mes">
			select Pvalor from Parametros
			where Ecodigo = #session.Ecodigo#
			  and Pcodigo = 40
		</cfquery>

		<cfquery datasource="#session.dsn#" name="MesCierreFiscal">
			select Pvalor
			from Parametros
			where Ecodigo = #session.Ecodigo#
			  and Pcodigo = 45
		</cfquery>

		<cfquery datasource="#session.dsn#" name="MesCierreCorporativo">
			select Pvalor
			from Parametros
			where Ecodigo = #session.Ecodigo#
			  and Pcodigo = 46
		</cfquery>

		<cfquery datasource="#session.dsn#" name="EContables">
			select ec.Eperiodo, ec.Emes, ec.Cconcepto, ec.Edocumento, ec.NAP,
					<cfif not arguments.MesCierre>
						ec.ECtipo,
					<cfelse>
						1 as ECtipo,
					</cfif>
					ec.Edocbase, ec.Ereferencia, ec.Efecha, ec.ECreversible, ec.ECauxiliar, cc.NoGeneraNap, Oorigen
			 from EContables ec
             	inner join ConceptoContableE cc
            		on cc.Ecodigo   = ec.Ecodigo
                   and cc.Cconcepto = ec.Cconcepto
			where ec.IDcontable = #Arguments.IDcontable#
		</cfquery>

		<cfif EContables.RecordCount is 0>
			<cf_errorCode	code = "51013" msg = "El asiento no existe. Proceso Cancelado">
		</cfif>

		<cfset Pcodigo_utilidad = 300>
		<cfquery name="rsCuentaUtilidad" datasource="#session.dsn#">
			select Pvalor as cuenta
			from Parametros
			where Pcodigo = #Pcodigo_utilidad#
			and Ecodigo = #session.Ecodigo#
		</cfquery>

		<!---
			Realiza el Ajuste por Redondeo cuando hay mas de 2 decimales
		--->
		<cfquery name="rsCuentaRedondeo" datasource="#session.dsn#">
			select Pvalor as Ccuenta
			from Parametros
			where Pcodigo = 100
			and Ecodigo = #session.Ecodigo#
		</cfquery>
		<cfquery name="rsCFcuentaRedondeo" datasource="#session.dsn#">
			select CFcuenta, CPcuenta
			  from CFinanciera
			 where Ccuenta = #rsCuentaRedondeo.Ccuenta#
		</cfquery>
		<cfquery name="rsRedondear" datasource="#session.dsn#">
			select  IDcontable, Ecodigo, Eperiodo, Emes, Cconcepto, Edocumento, Ocodigo, Mcodigo,
					(select max(Dlinea) from HDContables where IDcontable=d.IDcontable) as ULT_linea,
					case
						when sum(case when Dmovimiento = 'D' then Dlocal else -Dlocal end) < sum(case when Dmovimiento = 'D' then round(Dlocal,2) else -round(Dlocal,2) end)
						then 'C' else 'D'
					end as TIPO,
					round(abs(sum(case when Dmovimiento = 'D' then Dlocal else -Dlocal end) - sum(case when Dmovimiento = 'D' then round(Dlocal,2) else -round(Dlocal,2) end)),2) as MONTO
			  from DContables d
			 where IDcontable = #Arguments.IDcontable#
			   and Dlocal <> round(Dlocal,2)
			 group by IDcontable, Ecodigo, Eperiodo, Emes, Cconcepto, Edocumento, Ocodigo, Mcodigo
			having round(sum(case when Dmovimiento = 'D' then Dlocal else -Dlocal end) - sum(case when Dmovimiento = 'D' then round(Dlocal,2) else -round(Dlocal,2) end),2) <> 0
		</cfquery>
		<cfif rsRedondear.recordCount NEQ 0>
			<cfif rsCFcuentaRedondeo.CPcuenta NEQ "" AND EContables.NAP NEQ "">
				<cfthrow message="Existen líneas de Asiento con más de 2 decimales que no se pueden redondear porque ya existe NAP y la Cuenta de Ajuste por Redondeo tambien es de presupuesto.">
			</cfif>
			<cfloop query="rsRedondear">
				<cfquery datasource="#session.dsn#">
					insert into DContables (
						IDcontable, Ecodigo, Eperiodo, Emes, Cconcepto, Edocumento, Ocodigo, Mcodigo,
						Ccuenta, CFcuenta, Ddescripcion,
						Dlinea, Dmovimiento,
						Dlocal, Doriginal, Dtipocambio
					)
					values (
						#rsRedondear.IDcontable#, #rsRedondear.Ecodigo#, #rsRedondear.Eperiodo#, #rsRedondear.Emes#,
						#rsRedondear.Cconcepto#, #rsRedondear.Edocumento#, #rsRedondear.Ocodigo#, #rsRedondear.Mcodigo#,
						#rsCuentaRedondeo.Ccuenta#, #rsCFcuentaRedondeo.CFcuenta#, 'Ajuste por Redondeo',
						#rsRedondear.ULT_linea + rsRedondear.currentRow#, '#rsRedondear.TIPO#',
						#rsRedondear.MONTO#,0,0
					)
				</cfquery>
			</cfloop>
			<cfquery datasource="#session.dsn#">
				update DContables
				   set Dlocal = round(Dlocal,2)
				 where IDcontable = #Arguments.IDcontable#
				   and Dlocal <> round(Dlocal,2)
			</cfquery>
		</cfif>

		<!---
			Verificar que el periodo y mes corresponda con el periodo y mes del asiento, para que se pueda aplicar.  Si no corresponde, envia error.
			ECtipo:
				0  = Asiento Normal
				1  = Cierre de Periodo Fiscal
				11 = Cierre de Periodo Corporativo
				2  = Retroactivo
				20 = Normal Intercompany
				21 = Cierre de Periodo Intercompany
		--->

		<cfset LvarAnoMesActual			= Periodo.Pvalor      * 12	+ Mes.Pvalor>
		<cfset LvarAnoMesAsiento		= EContables.Eperiodo * 12	+ EContables.Emes>
		<cfset LvarMesCierreFiscal		= MesCierreFiscal.Pvalor>
		<cfset LvarMesCierreCorporativo	= MesCierreCorporativo.Pvalor>

		<cfif LvarMesCierreCorporativo EQ 0 AND EContables.ECtipo NEQ "1" and EContables.ECtipo NEQ "11">
			<cfthrow message="Está en Ejecución el Proceso de Inicialización de Períodos Fiscales y Corporativos">
		</cfif>
		<cfif LvarMesCierreCorporativo EQ "" OR LvarMesCierreCorporativo LT 0>
			<cfinvoke
				component	= "CG_CierreMes"
				method		= "sbInicializaPeriodoCorporativo"

				Mes			= "#LvarMesCierreFiscal#"
				Ecodigo		= "#session.Ecodigo#"
				Conexion	= "#session.dsn#"
			/>
			<cfset LvarMesCierreCorporativo	= LvarMesCierreFiscal>
		</cfif>

		<cfset LvarHayCorporativo = LvarMesCierreFiscal NEQ LvarMesCierreCorporativo>

		<cfif Mes.Pvalor GT LvarMesCierreFiscal>
			<cfset LvarAnoMesCierre			= (Periodo.Pvalor+1) * 12 + LvarMesCierreFiscal>
			<cfset LvarAnoMesCierreAnterior = Periodo.Pvalor 	 * 12 + LvarMesCierreFiscal>
			<cfset LvarAnoMesCierreTrasAnt	= (Periodo.Pvalor-1) * 12 + LvarMesCierreFiscal>
		<cfelse>
			<cfset LvarAnoMesCierre			= Periodo.Pvalor 	 * 12 + LvarMesCierreFiscal>
			<cfset LvarAnoMesCierreAnterior = (Periodo.Pvalor-1) * 12 + LvarMesCierreFiscal>
			<cfset LvarAnoMesCierreTrasAnt	= (Periodo.Pvalor-2) * 12 + LvarMesCierreFiscal>
		</cfif>

		<cfset LvarControlarPresupuesto = true>
		<cfset LvarPeriodoCerrado = false>
		<cfif EContables.ECtipo EQ 1 OR EContables.ECtipo EQ 11>
			<!--- Asiento de Cierre --->
			<cfset LvarControlarPresupuesto = false>
		<cfelseif EContables.ECtipo NEQ 2>
			<!--- Asiento de Normal --->
			<cfif LvarAnoMesAsiento NEQ LvarAnoMesActual>
				<cf_errorCode	code = "51014"
								msg  = "El Documento corresponde al período @errorDat_1@-@errorDat_2@ y la Contabilidad se encuentra en el período @errorDat_3@-@errorDat_4@. Proceso Cancelado"
								errorDat_1="#EContables.Eperiodo#"
								errorDat_2="#EContables.Emes#"
								errorDat_3="#Periodo.Pvalor#"
								errorDat_4="#Mes.Pvalor#"
				>
			</cfif>
		<cfelseif EContables.ECtipo EQ 2>
			<!--- Asiento de Retroactivo --->
			<cfif LvarAnoMesAsiento GTE LvarAnoMesActual>
				<cf_errorCode	code = "51015"
								msg  = "El Documento Retroactivo del período @errorDat_1@-@errorDat_2@ NO puede procesarse en el período @errorDat_3@-@errorDat_4@. Proceso Cancelado"
								errorDat_1="#EContables.Eperiodo#"
								errorDat_2="#EContables.Emes#"
								errorDat_3="#Periodo.Pvalor#"
								errorDat_4="#Mes.Pvalor#"
				>
			</cfif>

			<cfif LvarAnoMesAsiento LTE LvarAnoMesCierreAnterior>
				<cfset LvarPeriodoCerrado = true>
			<cfelseif LvarAnoMesAsiento LTE LvarAnoMesCierreTrasAnt>
	        	<cfset LvarControlarPresupuesto = false>
			</cfif>
		</cfif>
		<!---►►Si el Concepto Contable se le indico que no generar presupuesto se coloca la bandera de afectacion presupuestaria en FALSE◄◄--->
		<cfif EContables.NoGeneraNap EQ 1>
        	<cfset LvarControlarPresupuesto = false>
        </cfif>

		<!---
			Parametro para verificar si hay que validar el periodo y mes contra la fecha del asiento a generar o aplicar
		--->
		<cfquery datasource="#session.dsn#" name="chkFechasGenAplicar">
			select Pvalor from Parametros
			where Ecodigo = #session.Ecodigo#
			  and Pcodigo = 700
		</cfquery>

		<cfif chkFechasGenAplicar.recordCount and chkFechasGenAplicar.Pvalor EQ 'S'>
			<cfif Year(EContables.Efecha) NEQ EContables.Eperiodo or Month(EContables.Efecha) NEQ EContables.Emes>
				<cf_errorCode	code = "51016" msg = "El período y el mes del asiento debe coincidir con la fecha del asiento.">
			</cfif>
		</cfif>

		<cfquery datasource="#session.dsn#" name="DContables">
			select count(1) as cantidad
			from DContables
			where IDcontable = #Arguments.IDcontable#
		</cfquery>

		<cfif DContables.cantidad is 0>
			<cf_errorCode	code = "51017" msg = "No existen Movimientos para este asiento. Proceso Cancelado">
		</cfif>

		<cfset LvarTablaAsiento = "DContables">
		<cfset LvarResumir = false>
		<cfif DContables.cantidad GT 500000>
			<cfset LvarResumir = true>

			<cf_dbtemp name="CGDetAsiento_v1" returnvariable="CGDetAsiento_v1" datasource="#session.dsn#">
				<cf_dbtempcol name="Dlinea" type="numeric" identity="true" mandatory="true">
				<cf_dbtempcol name="IDcontable" type="numeric">
				<cf_dbtempcol name="Ecodigo" type="int">
				<cf_dbtempcol name="Cconcepto" type="int">
				<cf_dbtempcol name="Ocodigo" type="int">
				<cf_dbtempcol name="Eperiodo" type="int">
				<cf_dbtempcol name="Emes" type="int">
				<cf_dbtempcol name="Edocumento" type="int">
				<cf_dbtempcol name="Ddescripcion" type="varchar(100)">
				<cf_dbtempcol name="Ddocumento" type="varchar(20)">
				<cf_dbtempcol name="Dreferencia" type="varchar(25)">
				<cf_dbtempcol name="Dmovimiento" type="char(1)">
				<cf_dbtempcol name="Mcodigo" type="numeric">
				<cf_dbtempcol name="Dtipocambio" type="float">
				<cf_dbtempcol name="Ccuenta" type="numeric">
				<cf_dbtempcol name="CFcuenta" type="numeric">
				<cf_dbtempcol name="Doriginal" type="money">
				<cf_dbtempcol name="Dlocal" type="money">
                <cf_dbtempcol name="CFid" type="numeric">
				<cf_dbtempcol name="PCGDid" type="numeric">
<!--- Control Evento Inicia --->
                <cf_dbtempcol name="NumeroEvento" type="varchar(20)">
<!--- Control Evento Fin --->
			</cf_dbtemp>

			<cfset LvarTablaAsiento = CGDetAsiento_v1>
			<cfquery datasource="#session.dsn#">
				insert into #LvarTablaAsiento# (
					IDcontable, Ecodigo, Cconcepto,
					Ocodigo, Eperiodo, Emes,
					Edocumento, Ccuenta, CFcuenta,
					Dmovimiento, Mcodigo,
					Ddescripcion, Dreferencia,
					Dtipocambio, Doriginal, Dlocal, CFid, PCGDid
<!--- Control Evento Inicia --->
                    ,NumeroEvento
<!--- Control Evento Fin --->
                    )
				select
					#Arguments.IDcontable#, Ecodigo, Cconcepto,
					Ocodigo, Eperiodo, Emes,
					Edocumento, Ccuenta, CFcuenta,
					Dmovimiento, Mcodigo,
					'Resumen', 'Resumen',
					avg(Dtipocambio), sum(Doriginal), sum(Dlocal), CFid, PCGDid
<!--- Control Evento Inicia --->
                    ,NumeroEvento
<!--- Control Evento Fin --->
				from DContables
				where IDcontable = #Arguments.IDcontable#
				group by Ecodigo, Cconcepto, Ocodigo, Eperiodo, Emes, Edocumento, Ccuenta, CFcuenta, Dmovimiento, Mcodigo, PCGDid
			</cfquery>

		</cfif>

		<!--- agregado por danim/mauricio el 21/12/2004 : validar que las cuentas estén en el cubo --->
		<cfquery datasource="#session.dsn#" name="rs_sin_cubo">
			select
				count(1) as CtasInconsistentes
			from #LvarTablaAsiento# d
			where d.IDcontable = #Arguments.IDcontable#
			  and not exists (
			  		select 1
					from PCDCatalogoCuenta c
					where c.Ccuenta = d.Ccuenta)
		</cfquery>

		<cfif rs_sin_cubo.RecordCount  and rs_sin_cubo.CtasInconsistentes GT 0>
			<cf_errorCode	code = "51018" msg = "Existen Movimientos en este asiento con cuentas inconsistentes (Problemas en estructura de mayorizacion).">
		</cfif>

		<!--- Llama a la funcion encargada de validar reglas, Cts Inactivas y Pertenencia --->
		<!--- M. Esquivel. 13 Febrero 2006.  No hacer validaciones cuando el asiento llega de auxiliar --->
		<cfif EContables.ECtipo NEQ 1 and EContables.ECtipo NEQ 21 and EContables.ECauxiliar NEQ 'S'>
			<cfset CG_ValidacionesAsiento(Arguments.IDcontable,Mid(dateformat(Now(),"yyyymmdd"),1,6),Arguments.tipoMensaje)>
		</cfif>

		<cfquery datasource="#session.dsn#" name="rs_nomovimiento">
			select
				count(1) as Cantidad
			from #LvarTablaAsiento# d
				inner join CContables t
					 on t.Ccuenta = d.Ccuenta
					and t.Cmovimiento <> 'S'
			where d.IDcontable = #Arguments.IDcontable#
		</cfquery>
		<cfif rs_nomovimiento.RecordCount and rs_nomovimiento.Cantidad NEQ 0>
			<cf_errorCode	code = "51019" msg = "Existen Movimientos en este asiento con cuentas que no aceptan movimientos! Proceso Cancelado">
		</cfif>

		<!--- ver si esta balanceado
			12/marzo/2006.  Mauricio Esquivel
			  Cuando el asiento no es intercompany debe estar balanceado por cada una de las oficinas incluidas en el asiento
			  Cuando el asiento es intercompany, no se puede verificar el balanceo por oficina, debe hacerse por moneda del asiento
			  La cuenta de intercompany que hace el balance se obiene en el proceso de aplicación de asientos intercompany
		--->
		<cfif arguments.inter NEQ 'S'>
			<cfquery datasource="#session.dsn#" name="rsdescuadre">
				select d.Ocodigo, d.Mcodigo,
				sum(case when Dmovimiento = 'D' then Doriginal else 0 end) DEB,
				sum(case when Dmovimiento = 'C' then Doriginal else 0 end) CRE
				from #LvarTablaAsiento# d
				where IDcontable = #Arguments.IDcontable#
				group by d.Ocodigo, d.Mcodigo
				having
				sum(case when Dmovimiento = 'D' then Doriginal else 0 end) <> sum(case when Dmovimiento = 'C' then Doriginal else 0 end)
			</cfquery>

			<cfif rsdescuadre.RecordCount>

				<cfset LvarMensajeDescuadre = "El Asiento (Póliza) se encuentra Desbalanceado:">

				<cfloop query="rsdescuadre">
					<cfquery datasource="#session.dsn#" name="moneda">
						select Miso4217
						from Monedas
						where Ecodigo = #session.Ecodigo#
						  and Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsdescuadre.Mcodigo#">
					</cfquery>
					<cfquery datasource="#session.dsn#" name="oficina">
						select Oficodigo
						from Oficinas
						where Ecodigo = #session.Ecodigo#
						  and Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsdescuadre.Ocodigo#">
					</cfquery>

					<cfset LvarMensajeDescuadre = LvarMensajeDescuadre & " Oficina #trim(oficina.Oficodigo)#: #moneda.Miso4217# #NumberFormat(rsdescuadre.DEB, ',0.00')# #NumberFormat(rsdescuadre.CRE, ',0.00')#">
				</cfloop>

				<cfthrow message="#LvarMensajeDescuadre#">
				<cfreturn>
			</cfif>

		<cfelse>
			<cfquery datasource="#session.dsn#" name="rsdescuadre">
				select d.Mcodigo,
				sum(case when Dmovimiento = 'D' then Doriginal else 0 end) DEB,
				sum(case when Dmovimiento = 'C' then Doriginal else 0 end) CRE
				from #LvarTablaAsiento# d
				where IDcontable = #Arguments.IDcontable#
				group by d.Mcodigo
				having
				sum(case when Dmovimiento = 'D' then Doriginal else 0 end) <> sum(case when Dmovimiento = 'C' then Doriginal else 0 end)
			</cfquery>

			<cfif rsdescuadre.RecordCount>
				<cfset LvarMensajeDescuadre = "El Asiento (Póliza) se encuentra Desbalanceado:">
				<cfloop query="rsdescuadre">
					<cfquery datasource="#session.dsn#" name="moneda">
						select Miso4217
						from Monedas
						where Ecodigo = #session.Ecodigo#
						  and Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsdescuadre.Mcodigo#">
					</cfquery>
					<cfset LvarMensajeDescuadre = LvarMensajeDescuadre & " Moneda: #moneda.Miso4217# #NumberFormat(rsdescuadre.DEB, ',0.00')# #NumberFormat(rsdescuadre.CRE, ',0.00')#">
				</cfloop>
				<cfthrow message="#LvarMensajeDescuadre#">
				<cfreturn>
			</cfif>
		</cfif>

		<!--- Validacion de Cuentas de la Empresa --->
		<cfif Arguments.inter NEQ 'S'>
			<cfquery name="rsVerificaCuentasEmpresa" datasource="#session.dsn#">
				select count(1) as Cantidad
				from DContables d
					inner join CContables c
					on c.Ccuenta = d.Ccuenta
				where d.IDcontable = #Arguments.IDcontable#
				and ( c.Ecodigo <> d.Ecodigo or c.Ecodigo <> #session.Ecodigo# or d.Ecodigo <> #session.Ecodigo# )
			</cfquery>
			<cfif rsVerificaCuentasEmpresa.Cantidad NEQ 0>
				<cf_errorCode	code = "51020" msg = "Error de Datos. Existen Cuentas de Empresas Diferentes y el Asiento no es InterEmpresa. Contacte a Soporte Técnico">
			</cfif>
		</cfif>

		<!--- Llenado de la Tabla de Periodos Procesados *** MDM 02/03/2006*** --->
		<!---  a) Insertar el periodo/Mes Actual si no existe --->
		<cfquery name="rsPerProcexists" datasource="#session.dsn#">
			select 1
			from CGPeriodosProcesados
			where Ecodigo = #session.Ecodigo#
			  and Speriodo = #EContables.Eperiodo#
			  and Smes = #EContables.Emes#
		</cfquery>
		<cfif rsPerProcexists.Recordcount eq 0>
			<cfquery name="rsinsPerProc" datasource="#session.dsn#">
				insert into CGPeriodosProcesados (Ecodigo, Speriodo, Smes, BMUsucodigo, BMFecha)
				values (
					#session.Ecodigo#,
					#EContables.Eperiodo#,
					#EContables.Emes#,
					#session.Usucodigo#,
					<cf_dbfunction name="now">)
			</cfquery>
		</cfif>
		<!--- Mayorizacion en la tabla de Saldos Contables. Actualiza los saldos (debitos / creditos) de todos los niveles de todas las cuentas del asiento --->
		<cf_dbtemp name="CGAplAst_v1" 	returnvariable="tabCtaNiv">
			<cf_dbtempcol name="Ecodigo" type="int">
			<cf_dbtempcol name="Ocodigo" type="int">
			<cf_dbtempcol name="Ccuentaniv" type="numeric">
			<cf_dbtempcol name="Mcodigo" type="numeric">
			<cf_dbtempcol name="Speriodo" type="int">
			<cf_dbtempcol name="Smes" type="int">
			<cf_dbtempcol name="debitosl" type="money">
			<cf_dbtempcol name="creditosl" type="money">
			<cf_dbtempcol name="debitoso" type="money">
			<cf_dbtempcol name="creditoso" type="money">
			<cf_dbtempkey cols="Ecodigo,Ocodigo,Ccuentaniv,Mcodigo,Speriodo,Smes">
		</cf_dbtemp>
		<cf_dbtemp name="CGAplRes_v1" 	returnvariable="tabResNiv">
			<cf_dbtempcol name="Ecodigo" type="int">
			<cf_dbtempcol name="Ocodigo" type="int">
			<cf_dbtempcol name="Ccuentaniv" type="numeric">
			<cf_dbtempcol name="Mcodigo" type="numeric">
			<cf_dbtempcol name="Speriodo" type="int">
			<cf_dbtempcol name="Smes" type="int">
			<cf_dbtempcol name="debitosl" type="money">
			<cf_dbtempcol name="creditosl" type="money">
			<cf_dbtempcol name="debitoso" type="money">
			<cf_dbtempcol name="creditoso" type="money">
			<cf_dbtempkey cols="Ecodigo,Ocodigo,Ccuentaniv,Mcodigo,Speriodo,Smes">
		</cf_dbtemp>

		<cfif LvarHayCorporativo>
			<cf_dbtemp name="CGAplAs2_v1" 	returnvariable="tabCtaNiv2">
				<cf_dbtempcol name="Ecodigo" type="int">
				<cf_dbtempcol name="Ocodigo" type="int">
				<cf_dbtempcol name="Ccuentaniv" type="numeric">
				<cf_dbtempcol name="Mcodigo" type="numeric">
				<cf_dbtempcol name="Speriodo" type="int">
				<cf_dbtempcol name="Smes" type="int">
				<cf_dbtempcol name="debitosl" type="money">
				<cf_dbtempcol name="creditosl" type="money">
				<cf_dbtempcol name="debitoso" type="money">
				<cf_dbtempcol name="creditoso" type="money">
				<cf_dbtempkey cols="Ecodigo,Ocodigo,Ccuentaniv,Mcodigo,Speriodo,Smes">
			</cf_dbtemp>
			<cf_dbtemp name="CGAplRe2_v1" 	returnvariable="tabResNiv2">
				<cf_dbtempcol name="Ecodigo" type="int">
				<cf_dbtempcol name="Ocodigo" type="int">
				<cf_dbtempcol name="Ccuentaniv" type="numeric">
				<cf_dbtempcol name="Mcodigo" type="numeric">
				<cf_dbtempcol name="Speriodo" type="int">
				<cf_dbtempcol name="Smes" type="int">
				<cf_dbtempcol name="debitosl" type="money">
				<cf_dbtempcol name="creditosl" type="money">
				<cf_dbtempcol name="debitoso" type="money">
				<cf_dbtempcol name="creditoso" type="money">
				<cf_dbtempkey cols="Ecodigo,Ocodigo,Ccuentaniv,Mcodigo,Speriodo,Smes">
			</cf_dbtemp>
		</cfif>

		<cfinvoke
			 component		= "PRES_Presupuesto"
			 method			= "CreaTablaIntPresupuesto"

			 Conexion		= "#session.dsn#"
		/>

		<cfif CtlTransaccion>
			<cfquery name="rsVerificaHEContables" datasource="#session.dsn#">
				select count(1) as cantidad
				  from HEContables
				 where IDcontable = #Arguments.IDcontable#
			</cfquery>

			<cfif rsVerificaHEContables.cantidad GT 0>
				<cf_errorCode	code = "51021" msg = "El Asiento ya fue aplicado o está en proceso de aplicación. Proceso Cancelado!">
			</cfif>
			<cftransaction action="begin">
			<cftry>
				<!--- bloqueo de registro para evitar problemas de concurrencia --->
				<cfquery datasource="#session.dsn#">
					update EContables
					   set ECauxiliar = ECauxiliar
					 where IDcontable = #Arguments.IDcontable#
				</cfquery>
				
				<cfif LvarControlarPresupuesto>
					<cfinvoke
						 component		= "PRES_Presupuesto"
						 method			= "ControlPresupuestarioEContables">
							<cfinvokeargument name="IDcontable" 		value="#Arguments.IDcontable#"/>
							<cfinvokeargument name="PeriodoCerrado" 	value="#LvarPeriodoCerrado#"/>
							<cfif EContables.Oorigen EQ 'TEPN'>
								<cfinvokeargument name="validaComp" value="True"/>
							</cfif>
					</cfinvoke>
				</cfif>

 				<cfif isdefined("request.Errores") and arrayLen(request.Errores) GTE 1>
                	<cf_errorCode code = "60000" msg = "ERROR: El monto a descomprometer de la cuenta es menor al monto comprometido. Verifique lista de NRCs">
 				</cfif>

				<!--- inserción de registro para evitar problemas de concurrencia (dos procesos aplicando el mismo asiento --->
				<cfquery datasource="#session.dsn#">
					insert into HEContables (
							IDcontable, Ecodigo, Eperiodo, Emes, Cconcepto, Edocumento, Efecha, Edescripcion, Edocbase, Ereferencia, ECauxiliar, ECusuario,
							ECtipo,
							Ocodigo, Oorigen, ECusucodigo, ECfechacreacion, ECestado,
							ECusucodigoaplica, ECfechaaplica, ECipaplica, BMUsucodigo,
							NAP, NRP, CPNAPIid
						)
					select
							IDcontable, Ecodigo, Eperiodo, Emes, Cconcepto, Edocumento, Efecha, Edescripcion, Edocbase, Ereferencia, ECauxiliar, ECusuario,
							<cfif not arguments.MesCierre>
								ECtipo,
							<cfelse>
								1,
							</cfif>
							Ocodigo, Oorigen, ECusucodigo, ECfechacreacion, ECestado,
							#Session.Usucodigo#,
							<cf_dbfunction name="now">,
							'#Session.sitio.ip#',
							#Session.Usucodigo#,
							NAP, NRP, CPNAPIid
					  from 	EContables
					 where 	IDcontable = #Arguments.IDcontable#
				</cfquery>

                <cfquery name="rsRecursivo" datasource="#session.DSN#">
                	select coalesce(ECrecursivo, 0) as ECrecursivo, FFECrecursivo
                    from EContables
                    where 	IDcontable = #Arguments.IDcontable#
                </cfquery>
                <cfif rsRecursivo.ECrecursivo eq 1>
                	<cfquery datasource="#session.DSN#">
                    	insert into AsientosRecursivos
                        	(
                        	 Ecodigo,
                             IDcontable,
                             BMUsucodigo,
                             BMFecha,
                             FFECrecursivo)
                         values
                         	(
                             #session.Ecodigo#,
                             #Arguments.IDcontable#,
                             #session.usucodigo#,
                             <cf_dbfunction name="now">,
                             <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"  value="#lsparsedatetime(rsRecursivo.FFECrecursivo)#" voidNull>)
                    </cfquery>
                </cfif>

				<cfif Arguments.inter EQ 'S'>
					<cfinvoke
                     component="sif.Componentes.CG_AplicaIntercompany"
                     method="CG_AplicaIntercompany">
                         <cfinvokeargument name="IDcontable" value="#Arguments.IDcontable#">
                    </cfinvoke>
				</cfif>

				<cfif EContables.ECtipo eq 1 OR EContables.ECtipo eq 11>
					<cfset LvarMesAjuste	= EContables.Emes>
					<cfset LvarAnoAjuste	= EContables.Eperiodo>
					<cfset LvarMesAjuste 	= (LvarMesAjuste MOD 12) + 1>
					<cfif LvarMesAjuste eq 1>
						<cfset LvarAnoAjuste = LvarAnoAjuste + 1>
					</cfif>
					<cfset sbMayorizarSaldosContables(Arguments.IDcontable, EContables.ECtipo, LvarAnoAjuste, LvarMesAjuste, rsCuentaUtilidad.cuenta)>
				<cfelse>
					<cfset LvarMesAsiento	= EContables.Emes>
					<cfset LvarAnoAsiento	= EContables.Eperiodo>
					<cfset sbMayorizarSaldosContables(Arguments.IDcontable, EContables.ECtipo, LvarAnoAsiento, LvarMesAsiento, rsCuentaUtilidad.cuenta)>
				</cfif>


				<!---- Procesar los asientos retroactivos: Ajustar los SaldosIniciales hasta el periodo actual y Ajustar Primer Cierre Anual (Utilidades += I-G)--->
				<cfif EContables.ECtipo eq 2 and  LvarAnoMesAsiento LT LvarAnoMesActual>
					<cfset AjusteRetroactivo(Arguments.IDcontable, rsCuentaUtilidad.cuenta, EContables.Eperiodo, EContables.Emes)>
				</cfif>
				<cfset GrabarTransaccion(Arguments.IDcontable, Periodo.Pvalor, Mes.Pvalor, LvarAnoMesActual)>
				<!--- Se cambian los valores del asiento para permitir sacar el borrado de la transacción --->
				<cfquery datasource="#session.dsn#">
					update EContables
					   set Eperiodo = -1, Emes = -1
					 where IDcontable = #Arguments.IDcontable#
				</cfquery>

				<cftransaction action="commit" />
            <cfcatch>
                <cftransaction action="rollback" />

				<cfif isdefined("request.Errores") and arrayLen(request.Errores) GTE 1>
					<cfset varIDconta = 0>
                    <cfloop index="i" from="1" to="#arrayLen(request.Errores)#">
                        <cfif varIDconta neq #request.Errores[i].IDconta#>
                            <cfset varIDconta = #request.Errores[i].IDconta#>
							<cfquery name="updateNCREnc" datasource="#session.dsn#">
                                update MensNRCE set Estado = 0
                                where Ecodigo = #request.Errores[i].Ecodigo#
                                and NRC_Periodo = #request.Errores[i].Eperiodo#
                                and NRC_Mes = #request.Errores[i].Emes#
                                and NRC_ModuloOrigen = '#request.Errores[i].NRC_ModuloOrigen#'
                                and NRC_RefOrigen = '#request.Errores[i].Edocbase#'
                                and NRC_DocumentoOrigen = '#request.Errores[i].Oorigen#'
								and Estado = 1
							</cfquery>
                            <cfquery name="rsNCREnc" datasource="#session.dsn#">
                                select NRC_Numero from MensNRCE
                                where Ecodigo = #request.Errores[i].Ecodigo#
                                and NRC_Periodo = #request.Errores[i].Eperiodo#
                                and NRC_Mes = #request.Errores[i].Emes#
                                and NRC_ModuloOrigen = '#request.Errores[i].NRC_ModuloOrigen#'
                                and NRC_RefOrigen = '#request.Errores[i].Edocbase#'
                                and NRC_DocumentoOrigen = '#request.Errores[i].Oorigen#'
								and Estado = 1
                            </cfquery>
                            <cfif rsNCREnc.recordCount EQ 0>
                                <cfquery name="rsInsertNCREnc" datasource="#session.dsn#">
                                    insert MensNRCE (Ecodigo,NRC_Periodo,NRC_Mes,
                                    NRC_ModuloOrigen,NRC_RefOrigen,
                                    NRC_DocumentoOrigen,NRC_Cconcepto,Estado)
                                    values(#request.Errores[i].Ecodigo#,#request.Errores[i].Eperiodo#,#request.Errores[i].Emes#,
                                    '#request.Errores[i].NRC_ModuloOrigen#','#request.Errores[i].Edocbase#',
                                    '#request.Errores[i].Oorigen#',#request.Errores[i].Cconcepto#,1)
                                    <cf_dbidentity1 datasource="#Session.DSN#">
                                </cfquery>
                                <cf_dbidentity2 datasource="#Session.DSN#" name="rsIdentNCREnc">
                                <cfset varNRC_Numero = rsIdentNCREnc.identity>
                            <cfelse>
                                <cfset varNRC_Numero = #rsNCREnc.NRC_Numero#>
                            </cfif>
                            <cfquery name="rsDeleteNCRDet" datasource="#session.dsn#">
                                delete MensNRCD where NRC_Numero = #varNRC_Numero#
                            </cfquery>
                        </cfif>
                        <cfquery name="rsInsertNCRDet" datasource="#session.dsn#">
                            insert MensNRCD (NRC_Numero,CPNAPnum,CPcuenta,NRCD_Periodo,
                                NRCD_Mes,MontoComprometido,MontoEjecutar)
                            values (#varNRC_Numero#,#request.Errores[i].CPNAPnum#,#request.Errores[i].CPcuenta#,#request.Errores[i].Dperiodo#,
                                #request.Errores[i].Dmes#,#request.Errores[i].LvarMontoNAP#,#request.Errores[i].LvarMonto#)
                        </cfquery>
                    </cfloop>
				<cfelse>
					<cfif isdefined("cfcatch.Message")>
                        <cfset Mensaje="#cfcatch.Message#">
                    <cfelse>
                        <cfset Mensaje="">
                    </cfif>
                    <cfif isdefined("cfcatch.Detail")>
                        <cfset Detalle="#cfcatch.Detail#">
                    <cfelse>
                        <cfset Detalle="">
                    </cfif>
                    <cfif isdefined("cfcatch.sql")>
                        <cfset SQL="#cfcatch.sql#">
                    <cfelse>
                        <cfset SQL="">
                    </cfif>
                    <cfif isdefined("cfcatch.where")>
                        <cfset PARAM="#cfcatch.where#">
                    <cfelse>
                        <cfset PARAM="">
                    </cfif>
                    <cfif isdefined("cfcatch.StackTrace")>
                        <cfset PILA="#cfcatch.StackTrace#">
                    <cfelse>
                        <cfset PILA="">
                    </cfif>
					<cfthrow message="#Mensaje#.  #Detalle#  #SQL#  #PARAM#">
                </cfif>

               </cfcatch>
            </cftry>
			</cftransaction>

			<cfif isdefined("request.Errores") and arrayLen(request.Errores) GTE 1>
                <cfthrow message= "ERROR EN CONTROL PRESUPUESTARIO: El monto a descomprometer de la cuenta es menor al monto comprometido. Consulte los rechazos de NRCs ">
 			</cfif>
			<!--- Borrar los detalles y Encabezado del Asiento en Proceso --->
			<cfif LvarResumir>
				<cfquery datasource="#session.dsn#">
					delete from #LvarTablaAsiento#
				</cfquery>
			</cfif>
            <cftransaction>
				<!--- Bloquear la tabla EContables en la transaccion para evitar deadlocks --->
				<cfquery datasource="#session.dsn#">
					update EContables
					   set Eperiodo = -2, Emes = -2
					 where IDcontable = #Arguments.IDcontable#
				</cfquery>
                <cfquery datasource="#session.dsn#">
                    delete from DContables
                    where IDcontable = #Arguments.IDcontable#
                </cfquery>
                <cfquery datasource="#session.dsn#">
                    delete from EContables
                    where IDcontable = #Arguments.IDcontable#
                </cfquery>
            </cftransaction>
		<cfelse>
			<cf_errorCode	code = "51022" msg = "No se puede procesar la Aplicación del Asiento en una transaccion. La transacción se controla en el Posteo! Proceso Cancelado">
		</cfif>
	</cffunction>

	<cffunction name="sbMayorizarSaldosContables" access="private" output="no">
		<cfargument name="IDcontable"       type = "numeric" required = "yes">
		<cfargument name="Tipo"             type = "numeric" required = "yes">
		<cfargument name="NuevoPeriodo"     type = "numeric" required = "yes">
		<cfargument name="NuevoMes"         type = "numeric" required = "yes">
		<cfargument name="CuentaUtilidad" 	type = "numeric" required="yes">
		<!---
			Tipo de Actualizacion:
				Ajuste por Asientos de Cierre:
				1		= Asiento de Cierre Fiscal
				11		= Asiento de Cierre Corporativo
				Ajuste por Arrastre de Saldos de Meses posteriores al Asiento Retroactivo
				100		= Arrastre de SaldosIniciales Fiscal
				101		= Arrastre de SaldosIniciales Fiscal y Ajuste al Primer Cierre Fiscal
				201		= Arrastre de SaldosIniciales Fiscal y Ajuste a Siguientes Cierres Fiscal
				110		= Arrastre de SaldosIniciales Corporativo
				111		= Arrastre de SaldosIniciales Corporativo y Ajuste al Primer Cierre Corporativo
				211		= Arrastre de SaldosIniciales Corporativo y Ajuste a Siguientes Cierres Corporativo
				Otros
				n		= Normal

			Tipo de Mayorizacion:
				N	= Mayorización Normal:							Actualiza Debitos y Creditos
				F	= Ajuste al SaldoInicial Fiscal:				Se usa en Asientos de Cierre Fiscal y Meses posteriores al Asiento Retroactivo
				C	= Ajuste al SaldoInicial Corporativo:			Se usa en Asientos de Cierre Corporativos y Ajuste Corporativo a Meses posteriores al Asiento Retroactivo
				FC	= Ajuste al SaldoInicial Fiscal y Corporativo:	Se usa igual que en F pero Cierre Corporativo = Cierre Fiscal
		--->

		<cfif Arguments.Tipo GTE 100 AND NOT listFind("1,11,100,101,201,110,111,211",Arguments.Tipo)>
			<cfthrow message="Tipo de Mayorizacion incorrecto">
		</cfif>

		<!--- Tipos de Ajuste al SaldoInicial de SaldosContables --->
		<cfset LvarAjusteFiscal			= listFind("1,100,101,201",Arguments.Tipo)>
		<cfset LvarAjusteCorporativo 	= listFind("11,110,111,211",Arguments.Tipo)>
		<cfset LvarAjusteXRetroactivos	= listFind("100,110,101,111,201,211",Arguments.Tipo)>

		<!---
			En Cierres: también se Mayoriza o Ajusta SaldosContablesCierre
				En Cierre Anual: 					se Mayoriza Cierre de Resultados y Utilidad
				En Retroactivo Primer Cierre: 		se Mayoriza Cierre de Utilidad,
													y luego se Ajusta SaldoInicial y se Mayoriza Cierre de Resultados
				En Retroactivo Siguientes Cierres:	se Ajusta SaldoInicial de Utilidad
		--->
		<cfset LvarAjusteXCierres	 			= listFind("1,11,101,111,201,211",Arguments.Tipo)>
		<cfset LvarCierreAnual					= listFind("1,11",Arguments.Tipo)>
		<cfset LvarAjusteRetPrimerCierre		= listFind("101,111",Arguments.Tipo)>
		<cfset LvarAjusteRetSiguientesCierres	= listFind("201,211",Arguments.Tipo)>

		<cfif LvarAjusteFiscal>
			<cfif LvarHayCorporativo>
				<cfset LvarMayorizacion = 'F'>
			<cfelse>
				<cfset LvarMayorizacion = 'FC'>
			</cfif>
		<cfelseif LvarAjusteCorporativo>
			<cfif LvarHayCorporativo>
				<cfset LvarMayorizacion = 'C'>
			<cfelse>
				<cfthrow message="No se permite aplicar un Asiento de Cierre Corporativo si el Mes de Cierre Corporativo es igual al Mes de Cierre Fiscal">
			</cfif>
		<cfelse>
			<!--- N=Normal --->
			<cfset LvarMayorizacion = 'N'>
		</cfif>

		<!--- Cuando es Ajuste a Meses posteriores del Asiento Retroactivo se arrastran los movimientos al nuevo periodo --->
		<cfif LvarAjusteXRetroactivos>
			<cfquery datasource="#session.dsn#">
				update #tabCtaNiv#
				set Speriodo = #Arguments.NuevoPeriodo#, Smes = #Arguments.NuevoMes#
			</cfquery>
		<cfelse>
			<cfquery datasource="#session.dsn#">
				insert into #tabCtaNiv# (Ecodigo, Ocodigo, Ccuentaniv, Mcodigo,
					Speriodo, Smes,
					debitosl, creditosl, debitoso, creditoso)
				select
					#session.Ecodigo# as Ecodigo,
					a.Ocodigo,
					b.Ccuentaniv as Ccuenta,
					a.Mcodigo,
					#Arguments.NuevoPeriodo#,
					#Arguments.NuevoMes#,
					sum(case when Dmovimiento = 'D' then round(Dlocal, 2) else 0 end) debitosl,
					sum(case when Dmovimiento = 'C' then round(Dlocal, 2) else 0 end) creditosl,
					sum(case when Dmovimiento = 'D' then round(Doriginal, 2) else 0 end) debitoso,
					sum(case when Dmovimiento = 'C' then round(Doriginal, 2) else 0 end) creditoso
				from #LvarTablaAsiento# a
					inner join PCDCatalogoCuenta b
						on b.Ccuenta = a.Ccuenta
				where a.IDcontable = #Arguments.IDcontable#
				group by b.Ccuentaniv, a.Ocodigo, a.Mcodigo
			</cfquery>
		</cfif>

		<!--- Insertar los registros que no existan aun en SaldosContables para permitir realizar el update desde la tabla #mayoriza --->
		<!--- Cuando es AsientoDeCierre, se supone que ya están todas las cuentas con Saldo, pero la Cuenta de Utilidades puede no tener Saldo el último mes de cierre --->
		<cfquery datasource="#session.dsn#">
			insert into SaldosContables (
				Ecodigo,   Ocodigo,   Ccuenta,    Mcodigo,   Speriodo,  Smes,
				SLinicial, DLdebitos, CLcreditos, SOinicial, DOdebitos, COcreditos)
			select
				#session.Ecodigo#,
				a.Ocodigo, a.Ccuentaniv, a.Mcodigo,
				#Arguments.NuevoPeriodo#,
				#Arguments.NuevoMes#,
				0.00, 0.00, 0.00, 0.00, 0.00, 0.00
			from #tabCtaNiv# a
			where (
				select count(1)
				from SaldosContables k
				where k.Ccuenta 	= a.Ccuentaniv
				  and k.Speriodo 	= a.Speriodo
				  and k.Smes 		= a.Smes
				  and k.Ecodigo 	= a.Ecodigo
				  and k.Ocodigo 	= a.Ocodigo
				  and k.Mcodigo 	= a.Mcodigo
				) = 0
		</cfquery>

		<cfset LvarCtasNiveles = "#tabCtaNiv# a " &
								 "where a.Ccuentaniv	= SaldosContables.Ccuenta "		&
								 "  and a.Speriodo		= SaldosContables.Speriodo "	&
								 "  and a.Smes			= SaldosContables.Smes " 		&
								 "  and a.Ecodigo		= SaldosContables.Ecodigo " 	&
								 "  and a.Ocodigo		= SaldosContables.Ocodigo " 	&
								 "  and a.Mcodigo		= SaldosContables.Mcodigo"
		>

		<cfif ListFind('sybase,sqlserver', session.dsinfo.type)>
			<cfquery datasource="#session.dsn#">
				update SaldosContables
				   set
					<cfif LvarMayorizacion EQ "N">
						<!--- Mayorización Normal --->
						DLdebitos  = DLdebitos  + a.debitosl,
						CLcreditos = CLcreditos + a.creditosl,
						DOdebitos  = DOdebitos  + a.debitoso,
						COcreditos = COcreditos + a.creditoso,
					<cfelse>
						<cfif LvarMayorizacion EQ "F" OR LvarMayorizacion EQ "FC">
							<!--- Ajuste al SaldoInicial Fiscal --->
							SLinicial	= SLinicial		+ a.debitosl - a.creditosl,
							SOinicial	= SOinicial		+ a.debitoso - a.creditoso,
						</cfif>
						<cfif LvarMayorizacion EQ "C" OR LvarMayorizacion EQ "FC">
							<!--- Ajuste al SaldoInicial Corporativo --->
							SLinicialGE	= SLinicialGE	+ a.debitosl - a.creditosl,
							SOinicialGE	= SOinicialGE	+ a.debitoso - a.creditoso,
						</cfif>
					</cfif>
						BMFecha = <cf_dbfunction name="now">
				  from #tabCtaNiv# a
				 where SaldosContables.Ecodigo	= #session.Ecodigo#
				   and SaldosContables.Speriodo	= #Arguments.NuevoPeriodo#
				   and SaldosContables.Smes		= #Arguments.NuevoMes#

				   and SaldosContables.Ccuenta	= a.Ccuentaniv
				   and SaldosContables.Speriodo	= a.Speriodo
				   and SaldosContables.Smes		= a.Smes
				   and SaldosContables.Ecodigo	= a.Ecodigo
				   and SaldosContables.Ocodigo	= a.Ocodigo
				   and SaldosContables.Mcodigo	= a.Mcodigo
			</cfquery>
		<cfelseif ListFind('oracle,db2', session.dsinfo.type)>
			<cfquery datasource="#session.dsn#">
				update SaldosContables
				   set
					<cfif LvarMayorizacion EQ "N">
						<!--- Mayorización Normal --->
						DLdebitos	= DLdebitos 	+ (select a.debitosl	from #LvarCtasNiveles#),
						CLcreditos	= CLcreditos	+ (select a.creditosl	from #LvarCtasNiveles#),
						DOdebitos	= DOdebitos		+ (select a.debitoso	from #LvarCtasNiveles#),
						COcreditos	= COcreditos	+ (select a.creditoso	from #LvarCtasNiveles#),
					<cfelse>
						<cfif LvarMayorizacion EQ "F" OR LvarMayorizacion EQ "FC">
							<!--- Ajuste al SaldoInicial Fiscal --->
							SLinicial	= SLinicial		+ (select a.debitosl - a.creditosl from #LvarCtasNiveles#),
							SOinicial	= SOinicial		+ (select a.debitoso - a.creditoso from #LvarCtasNiveles#),
						</cfif>
						<cfif LvarMayorizacion EQ "C" OR LvarMayorizacion EQ "FC">
							<!--- Ajuste al SaldoInicial Corporativo --->
							SLinicialGE	= SLinicialGE	+ (select a.debitosl - a.creditosl from #LvarCtasNiveles#),
							SOinicialGE	= SOinicialGE	+ (select a.debitoso - a.creditoso from #LvarCtasNiveles#),
						</cfif>
					</cfif>
						BMFecha = <cf_dbfunction name="now">
				 where Ecodigo	= #session.Ecodigo#
				   and Speriodo	= #Arguments.NuevoPeriodo#
				   and Smes		= #Arguments.NuevoMes#
				   and ( select count(1) from #LvarCtasNiveles# ) > 0
			</cfquery>
		<cfelse>
			<cf_errorCode	code = "51023"
							msg  = "No implementado para DBMS @errorDat_1@"
							errorDat_1="#session.dsinfo.type#"
			>
		</cfif>

		<!--- Cuando hay que Ajustar o Mayorizar SaldosContablesCierre --->
		<cfif LvarAjusteXCierres>
			<cfset LvarMesCierre = Arguments.NuevoMes - 1>
			<cfif LvarMesCierre EQ 0>
				<cfset LvarMesCierre = 12>
				<cfset LvarAnoCierre = Arguments.NuevoPeriodo - 1>
			<cfelse>
				<cfset LvarAnoCierre = Arguments.NuevoPeriodo>
			</cfif>

			<cfif Arguments.Tipo LT 100>
				<cfset LvarECtipo = Arguments.Tipo>
			<cfelseif Arguments.Tipo LT 200>
				<cfset LvarECtipo = Arguments.Tipo - 100>
			<cfelse>
				<cfset LvarECtipo = Arguments.Tipo - 200>
			</cfif>

			<!--- En SaldosContablesCierre sólo están Cuentas de Resultado y Utilidad que vengan en el asiento --->
			<cfset sbCrearSaldosContablesCierre(LvarECtipo, LvarAnoCierre, LvarMesCierre, Arguments.CuentaUtilidad, tabCtaNiv)>

			<cfset LvarCtasNiveles = "#tabCtaNiv# a " &
									 "where a.Ccuentaniv	= SaldosContablesCierre.Ccuenta "	&
									 "  and a.Speriodo		= SaldosContablesCierre.Speriodo "	&
									 "  and a.Smes			= SaldosContablesCierre.Smes " 		&
									 "  and a.Ecodigo		= SaldosContablesCierre.Ecodigo " 	&
									 "  and a.Ocodigo		= SaldosContablesCierre.Ocodigo " 	&
									 "  and a.Mcodigo		= SaldosContablesCierre.Mcodigo"
			>

			<cfif LvarCierreAnual>
				<!--- Cierre Anual: Mayorización Normal del Cierre de Resultados y Utilidad --->
				<cfquery datasource="#session.dsn#">
					update SaldosContablesCierre
					   set
							DLdebitos	= DLdebitos 	+ (select a.debitosl	from #LvarCtasNiveles#),
							CLcreditos	= CLcreditos	+ (select a.creditosl	from #LvarCtasNiveles#),
							DOdebitos	= DOdebitos		+ (select a.debitoso	from #LvarCtasNiveles#),
							COcreditos	= COcreditos	+ (select a.creditoso	from #LvarCtasNiveles#),
							BMFecha = <cf_dbfunction name="now">
					 where Ecodigo	= #session.Ecodigo#
					   and Speriodo	= #LvarAnoCierre#
					   and Smes		= #LvarMesCierre#
					   and ECtipo 	= #LvarECtipo#
					   and ( select count(1) from #LvarCtasNiveles# ) > 0
				</cfquery>
			<cfelseif LvarAjusteRetSiguientesCierres>
				<!--- Retroactivo Siguientes Cierres: Ajuste SaldoInicial de Utilidad --->
				<!--- Se realizó en sbCrearSaldosContablesCierre --->
			<cfelseif LvarAjusteRetPrimerCierre>
				<!--- Retroactivo Primer Cierre: Mayorización Normal del Cierre de Utilidad --->
				<cfquery datasource="#session.dsn#">
					update SaldosContablesCierre
					   set
							DLdebitos	= DLdebitos 	+ (select a.debitosl	from #LvarCtasNiveles#),
							CLcreditos	= CLcreditos	+ (select a.creditosl	from #LvarCtasNiveles#),
							DOdebitos	= DOdebitos		+ (select a.debitoso	from #LvarCtasNiveles#),
							COcreditos	= COcreditos	+ (select a.creditoso	from #LvarCtasNiveles#),
							BMFecha = <cf_dbfunction name="now">
					 where Ecodigo	= #session.Ecodigo#
					   and Speriodo	= #LvarAnoCierre#
					   and Smes		= #LvarMesCierre#
					   and ECtipo 	= #LvarECtipo#
					   and ( select count(1) from #LvarCtasNiveles# ) > 0
				</cfquery>

				<!---  En Retroactivo primer Cierre: Ajusta SaldoInicial y Mayoriza el Cierre de las cuentas de Resultados que están respaldas en tabResNiv --->
				<cfset sbCrearSaldosContablesCierre(LvarECtipo, LvarAnoCierre, LvarMesCierre, Arguments.CuentaUtilidad, tabResNiv)>
				<cfset LvarCtasNiveles = "#tabResNiv# a " &
										 "where a.Ccuentaniv	= SaldosContablesCierre.Ccuenta "	&
										 "  and a.Speriodo		= SaldosContablesCierre.Speriodo "	&
										 "  and a.Smes			= SaldosContablesCierre.Smes " 		&
										 "  and a.Ecodigo		= SaldosContablesCierre.Ecodigo " 	&
										 "  and a.Ocodigo		= SaldosContablesCierre.Ocodigo " 	&
										 "  and a.Mcodigo		= SaldosContablesCierre.Mcodigo"
				>
				<cfquery datasource="#session.dsn#">
					update SaldosContablesCierre
					   set
							<!--- Mayorización Normal del Cierre (Inverso) de Resultados --->
							DLdebitos	= DLdebitos 	+ (select a.creditosl	from #LvarCtasNiveles#),
							CLcreditos	= CLcreditos	+ (select a.debitosl	from #LvarCtasNiveles#),
							DOdebitos	= DOdebitos		+ (select a.creditoso	from #LvarCtasNiveles#),
							COcreditos	= COcreditos	+ (select a.debitoso	from #LvarCtasNiveles#),
							BMFecha = <cf_dbfunction name="now">
					 where Ecodigo	= #session.Ecodigo#
					   and Speriodo	= #LvarAnoCierre#
					   and Smes		= #LvarMesCierre#
					   and ECtipo 	= #LvarECtipo#
					   and ( select count(1) from #LvarCtasNiveles# ) > 0
				</cfquery>
				<cfquery datasource="#session.dsn#">
					delete from #tabResNiv#
				</cfquery>
			<cfelse>
				<cfthrow message="Tipo de Ajuste por Cierre Incorrecto">
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="sbCrearSaldosContablesCierre" output="false" returntype="void">
		<cfargument name="ECtipo"           type = "numeric" required = "yes">
		<cfargument name="AnoCierre"     	type = "numeric" required = "yes">
		<cfargument name="MesCierre"        type = "numeric" required = "yes">
		<cfargument name="CuentaUtilidad" 	type = "numeric" required="yes">
		<cfargument name="tabCtaNiv" 		type = "string" required="yes">

		<cfquery datasource="#session.dsn#">
			update #Arguments.tabCtaNiv#
			set Speriodo = #Arguments.AnoCierre#, Smes = #Arguments.MesCierre#
		</cfquery>

		<!--- Inserta las cuentas de Resultados que vengan en el asiento y sean nuevas --->
		<cfquery datasource="#session.dsn#">
			insert into SaldosContablesCierre (
				Ecodigo,   ECtipo,	  Ocodigo,   Ccuenta,    Mcodigo,   Speriodo,  Smes,
				SLinicial, DLdebitos, CLcreditos, SOinicial, DOdebitos, COcreditos)
			select
				#session.Ecodigo#, #Arguments.ECtipo#,
				a.Ocodigo, a.Ccuentaniv, a.Mcodigo,
				#Arguments.AnoCierre#,
				#Arguments.MesCierre#,
				0.00, 0.00, 0.00, 0.00, 0.00, 0.00
			  from #Arguments.tabCtaNiv# a
				inner join CContables c
					inner join CtasMayor m
						 on m.Ecodigo = c.Ecodigo
						and m.Cmayor  = c.Cmayor
						and m.Ctipo   in ('I', 'G')
					on c.Ccuenta = a.Ccuentaniv
			 where (
					select count(1)
					  from SaldosContablesCierre
					 where Ccuenta	= a.Ccuentaniv
					   and Speriodo	= a.Speriodo
					   and Smes		= a.Smes
					   and Ecodigo	= a.Ecodigo
					   and ECtipo 	= #Arguments.ECtipo#
					   and Ocodigo	= a.Ocodigo
					   and Mcodigo	= a.Mcodigo
					) = 0
		</cfquery>

		<!--- Inserta la Cuenta de Utilidades si viene en el asiento y sea nueva --->
		<cfquery datasource="#session.dsn#">
			insert into SaldosContablesCierre (
				Ecodigo,   ECtipo,	  Ocodigo,   Ccuenta,    Mcodigo,   Speriodo,  Smes,
				SLinicial, DLdebitos, CLcreditos, SOinicial, DOdebitos, COcreditos)
			select
				#session.Ecodigo#, #Arguments.ECtipo#,
				a.Ocodigo, a.Ccuentaniv, a.Mcodigo,
				#Arguments.AnoCierre#,
				#Arguments.MesCierre#,
				0.00, 0.00, 0.00, 0.00, 0.00, 0.00
			  from #Arguments.tabCtaNiv# a
				inner join PCDCatalogoCuenta b
					 on b.Ccuenta 	 = #Arguments.CuentaUtilidad#
					and b.Ccuentaniv = a.Ccuentaniv
			 where (
					select count(1)
					  from SaldosContablesCierre
					 where Ccuenta	= a.Ccuentaniv
					   and Speriodo	= a.Speriodo
					   and Smes		= a.Smes
					   and Ecodigo	= a.Ecodigo
					   and ECtipo 	= #Arguments.ECtipo#
					   and Ocodigo	= a.Ocodigo
					   and Mcodigo	= a.Mcodigo
					) = 0
		</cfquery>

		<cfset LvarSaldosContables = "SaldosContables s " &
									 "where s.Ccuenta		= SaldosContablesCierre.Ccuenta "	&
									 "  and s.Speriodo		= SaldosContablesCierre.Speriodo "	&
									 "  and s.Smes			= SaldosContablesCierre.Smes " 		&
									 "  and s.Ecodigo		= SaldosContablesCierre.Ecodigo " 	&
									 "  and s.Ocodigo		= SaldosContablesCierre.Ocodigo " 	&
									 "  and s.Mcodigo		= SaldosContablesCierre.Mcodigo"
		>

		<cfquery datasource="#session.dsn#">
			update SaldosContablesCierre
			   set
					SLinicial	= coalesce ((select SLinicial  +DLdebitos-CLcreditos from #LvarSaldosContables#),0),
					SOinicial	= coalesce ((select SOinicial  +DOdebitos-COcreditos from #LvarSaldosContables#),0),
					SLinicialGE	= coalesce ((select SLinicialGE+DLdebitos-CLcreditos from #LvarSaldosContables#),0),
					SOinicialGE	= coalesce ((select SOinicialGE+DOdebitos-COcreditos from #LvarSaldosContables#),0),
					BMFecha = <cf_dbfunction name="now">
			 where Ecodigo	= #session.Ecodigo#
			   and Speriodo	= #Arguments.AnoCierre#
			   and Smes		= #Arguments.MesCierre#
			   and ECtipo 	= #Arguments.ECtipo#
			   and (
			   		select count(1)
					  from #Arguments.tabCtaNiv# a
					 where a.Ccuentaniv	= SaldosContablesCierre.Ccuenta
					   and a.Speriodo	= SaldosContablesCierre.Speriodo
					   and a.Smes		= SaldosContablesCierre.Smes
					   and a.Ecodigo	= SaldosContablesCierre.Ecodigo
					   and a.Ocodigo	= SaldosContablesCierre.Ocodigo
					   and a.Mcodigo	= SaldosContablesCierre.Mcodigo
					) > 0
		</cfquery>
	</cffunction>

	<!--- Arrastrar los saldos de los asientos retroactivos hasta el período actual --->
	<!--- Unicamente en el primer cierre anual se pasa los movimientos de Resultados a la cuenta de Utilidades --->
	<cffunction name="AjusteRetroactivo" access="private" output="no">
		<cfargument name="IDcontable" type="numeric" required="yes">
		<cfargument name="CuentaUtilidad" type="numeric" required="yes">
		<cfargument name="Periodo" type="numeric" required="yes">
		<cfargument name="Mes" type="numeric" required="yes">

		<cfset var LvarMesAsiento	= Arguments.Mes>
		<cfset var LvarAnoAsiento	= Arguments.Periodo>
		<cfset var LvarMesAjuste	= Arguments.Mes>
		<cfset var LvarAnoAjuste	= Arguments.Periodo>

		<cfset LvarAnoMesAjuste = LvarAnoMesAsiento>

		<cfset LvarCierreFiscal_1 = 0>
		<cfset LvarCierreCorporativo_1 = 0>

		<!--- OJO: hay 2 tablas de trabajo #tabCtaNiv#, una para mayorizacion fiscal y otra para corporativo, que se van alternando según se requiera --->
		<!--- OJO: hay 2 tablas de trabajo #tabResNiv#, una para mayorizacion fiscal y otra para corporativo, que se van alternando según se requiera --->
		<cfset tabCtaNiv_Fiscal = tabCtaNiv>
		<cfset tabResNiv_Fiscal = tabResNiv>

		<!--- Cuando tambien hay Cierre Anual Corporativo se llevan 2 juegos de Saldos --->
		<cfif LvarHayCorporativo>
			<cfset tabCtaNiv_Corporativo = tabCtaNiv2>
			<cfset tabResNiv_Corporativo = tabResNiv2>

			<cfquery datasource="#session.dsn#">
				delete from #tabCtaNiv_Corporativo#
			</cfquery>
			<cfquery datasource="#session.dsn#">
				insert into #tabCtaNiv_Corporativo#
					(Ecodigo, Ocodigo, Ccuentaniv, Mcodigo,
					Speriodo, Smes,
					debitosl, creditosl, debitoso, creditoso)
				select
					Ecodigo, Ocodigo, Ccuentaniv, Mcodigo,
					Speriodo, Smes,
					debitosl, creditosl, debitoso, creditoso
				from #tabCtaNiv_Fiscal#
			</cfquery>
		</cfif>

		<cfloop condition = "LvarAnoMesAjuste LT LvarAnoMesActual">
			<cfif LvarCierreFiscal_1 EQ 0 and LvarMesAjuste Eq LvarMesCierreFiscal>
				<cfset LvarCierreFiscal_1 = 1>
				<cfset tabCtaNiv = tabCtaNiv_Fiscal>
				<cfset tabResNiv = tabResNiv_Fiscal>
				<cfset LvarECtipo = 1>
			<cfelseif LvarHayCorporativo and LvarCierreCorporativo_1 EQ 0 and LvarMesAjuste Eq LvarMesCierreCorporativo>
				<cfset LvarCierreCorporativo_1 = 1>
				<cfset tabCtaNiv = tabCtaNiv_Corporativo>
				<cfset tabResNiv = tabResNiv_Corporativo>
				<cfset LvarECtipo = 11>
			</cfif>

			<cfset LvarMesAsiento	= LvarMesAjuste>
			<cfset LvarAnoAsiento	= LvarAnoAjuste>
			<cfset LvarAnoMesAsiento = LvarAnoAsiento * 12 + LvarMesAsiento>

			<cfset LvarMesAjuste = (LvarMesAjuste MOD 12) + 1>
			<cfif LvarMesAjuste eq 1>
				<cfset LvarAnoAjuste = LvarAnoAjuste + 1>
			</cfif>

			<cfset LvarAnoMesAjuste = LvarAnoAjuste * 12 + LvarMesAjuste>

			<cfif LvarCierreFiscal_1 EQ 1 OR LvarCierreCorporativo_1 EQ 1>
				<!--- Respalda las cuentas de Resultado para Ajustar los SaldosContablesCierre en la mayorización --->
				<cfquery datasource="#session.dsn#">
					insert into #tabResNiv#
						(Ecodigo, Ocodigo, Ccuentaniv, Mcodigo,
						Speriodo, Smes,
						debitosl, creditosl, debitoso, creditoso)
					select
						Ecodigo, Ocodigo, Ccuentaniv, Mcodigo,
						Speriodo, Smes,
						debitosl, creditosl, debitoso, creditoso
					  from #tabCtaNiv#
					 where (
							select count(1)
							  from CContables c
								inner join CtasMayor m
									   on m.Ecodigo = c.Ecodigo
									  and m.Cmayor  = c.Cmayor
									  and m.Ctipo in ('I', 'G')
							 where c.Ccuenta = #tabCtaNiv#.Ccuentaniv
							) > 0
				</cfquery>

				<!--- 1. Borrar de la tabla de trabajo las cuentas que corresponden a Cuentas de Resultados pues estas no actualizan los saldos a futuro --->
				<cfquery name="rsBorraResultados" datasource="#session.dsn#">
					delete from #tabCtaNiv#
					 where (
							select count(1)
							  from CContables c
								inner join CtasMayor m
									   on m.Ecodigo = c.Ecodigo
									  and m.Cmayor  = c.Cmayor
									  and m.Ctipo in ('I', 'G')
							 where c.Ccuenta = #tabCtaNiv#.Ccuentaniv
							) > 0
				</cfquery>

				<!--- 1b. Borrar de la tabla de trabajo las cuentas de Contabilidad Presupuestaria MX pues estas no actualizan los saldos a futuro --->
				<cfquery name="rsSQL" datasource="#session.dsn#">
					select Pvalor
					  from Parametros
					 where Ecodigo = #session.Ecodigo#
					   and Pcodigo = 1140
				</cfquery>
				<cfif rsSQL.Pvalor EQ "S">
					<cfquery datasource="#session.dsn#">
						delete from #tabCtaNiv#
						 where (
								select count(1)
								  from CContables c
									inner join CPtipoMovContable cp
										   on cp.Ecodigo = c.Ecodigo
										  and cp.Cmayor  = c.Cmayor
										  and cp.CPPid	 = (select CPPid from CPresupuestoPeriodo where Ecodigo=c.Ecodigo and #LvarAnoMesAsiento# between CPPanoMesDesde and CPPanoMesHasta)
								 where c.Ccuenta = #tabCtaNiv#.Ccuentaniv
								) > 0
					</cfquery>
				</cfif>

				<!--- Insertar las Cuentas de Utilidad a la tabla de Mayorizacion si es que no existen --->
				<cfquery datasource="#session.dsn#">
					update #tabCtaNiv#
					set Speriodo = #LvarAnoAjuste#, Smes = #LvarMesAjuste#
				</cfquery>
				<cfquery name="rsCalculaUtilidad" datasource="#session.dsn#">
					insert into #tabCtaNiv#
						(Ecodigo, Ocodigo, Ccuentaniv, Mcodigo,
						Speriodo, Smes,
						debitosl, creditosl, debitoso, creditoso)
					select
						distinct
						#session.Ecodigo#, a.Ocodigo, b.Ccuentaniv, a.Mcodigo,
						#LvarAnoAjuste#, #LvarMesAjuste#,
						0.00, 0.00, 0.00, 0.00
					from #LvarTablaAsiento# a, PCDCatalogoCuenta b
					where a.IDcontable 	= #Arguments.IDcontable#
					  and b.Ccuenta 	= #Arguments.CuentaUtilidad#
					  and not exists(
							select 1
							from #tabCtaNiv# c
							where c.Ccuentaniv = b.Ccuentaniv
							  and c.Ocodigo    = a.Ocodigo
							  and c.Mcodigo    = a.Mcodigo
							 )
				</cfquery>

				<!--- 2. Actualizar los montos correspondientes de las cuentas de utilidad por los movimientos hechos a cuentas de resultado --->
				<cfquery name="rsCalculaUtilidad" datasource="#session.dsn#">
					update #tabCtaNiv#
					set
							debitosl 	= debitosl  + coalesce((
										select sum(case when Dmovimiento = 'D' then round(Dlocal, 2) else 0 end)
										from #LvarTablaAsiento# d
											inner join CContables c
													inner join CtasMayor m
															on  m.Ecodigo = c.Ecodigo
															and m.Cmayor  = c.Cmayor
															and m.Ctipo in ('I', 'G')
												on c.Ccuenta = d.Ccuenta
										where d.IDcontable = #Arguments.IDcontable#
										  and d.Ocodigo    = #tabCtaNiv#.Ocodigo
										  and d.Mcodigo    = #tabCtaNiv#.Mcodigo
										) , 0.00),
							creditosl	= creditosl + coalesce((
										select sum(case when Dmovimiento = 'C' then round(Dlocal, 2) else 0 end)
										from #LvarTablaAsiento# d
											inner join CContables c
													inner join CtasMayor m
															on  m.Ecodigo = c.Ecodigo
															and m.Cmayor  = c.Cmayor
															and m.Ctipo in ('I', 'G')
												on c.Ccuenta = d.Ccuenta
										where d.IDcontable = #Arguments.IDcontable#
										  and d.Ocodigo    = #tabCtaNiv#.Ocodigo
										  and d.Mcodigo    = #tabCtaNiv#.Mcodigo
										) , 0.00),
							debitoso	= debitoso  + coalesce((
										select sum(case when Dmovimiento = 'D' then round(Doriginal, 2) else 0 end)
										from #LvarTablaAsiento# d
											inner join CContables c
													inner join CtasMayor m
															on  m.Ecodigo = c.Ecodigo
															and m.Cmayor  = c.Cmayor
															and m.Ctipo in ('I', 'G')
												on c.Ccuenta = d.Ccuenta
										where d.IDcontable = #Arguments.IDcontable#
										  and d.Ocodigo    = #tabCtaNiv#.Ocodigo
										  and d.Mcodigo    = #tabCtaNiv#.Mcodigo
										) , 0.00),
							creditoso	= creditoso + coalesce((
										select sum(case when Dmovimiento = 'C' then round(Doriginal, 2) else 0 end)
										from #LvarTablaAsiento# d
											inner join CContables c
													inner join CtasMayor m
															on  m.Ecodigo = c.Ecodigo
															and m.Cmayor  = c.Cmayor
															and m.Ctipo in ('I', 'G')
												on c.Ccuenta = d.Ccuenta
										where d.IDcontable = #Arguments.IDcontable#
										  and d.Ocodigo    = #tabCtaNiv#.Ocodigo
										  and d.Mcodigo    = #tabCtaNiv#.Mcodigo
										) , 0.00)
					where (
							select count(1)
							from PCDCatalogoCuenta b
							where b.Ccuenta = #Arguments.CuentaUtilidad#
							  and b.Ccuentaniv = #tabCtaNiv#.Ccuentaniv
						 ) > 0
				</cfquery>
			</cfif>

			<!---
				Aqui la mayorización es arrastrar los saldos hasta el período actual
				excepto en el primer cierre Anual que hace asiento de ajuste al cierre
			--->
			<cfif LvarCierreFiscal_1 EQ 1>
				<cfset LvarCierreFiscal_1 = 2>
				<!--- Primer Cierre Fiscal:
					Generar Asiento de Ajuste al Cierre Fiscal
					Ajustar SaldosIniciales Fiscal y SaldosInicialesCierre Fiscal
					Ajustar SaldosIniciales Corporativo
				--->
				<cfset tabCtaNiv = tabCtaNiv_Fiscal>
				<cfset tabResNiv = tabResNiv_Fiscal>
				<!--- Generar Asiento de Ajuste Cierre Fiscal --->
				<cfset sbAsientoAjusteCierreAnualXRetroactivo(Arguments.IDcontable, 1, LvarAnoAsiento, LvarMesAsiento, Arguments.CuentaUtilidad)>
				<!--- Ajustar SaldosIniciales Fiscal y SaldosInicialesCierre Fiscal ECtipo=1 + 100 --->
				<cfset sbMayorizarSaldosContables(Arguments.IDcontable, 101, LvarAnoAjuste, LvarMesAjuste, Arguments.CuentaUtilidad)>

				<cfif LvarHayCorporativo>
					<!--- Ajustar SaldosIniciales Corporativos tipo=110 --->
					<cfset tabCtaNiv = tabCtaNiv_Corporativo>
					<cfset tabResNiv = tabResNiv_Corporativo>
					<cfset sbMayorizarSaldosContables(Arguments.IDcontable, 110, LvarAnoAjuste, LvarMesAjuste, Arguments.CuentaUtilidad)>
				</cfif>
			<cfelseif LvarCierreCorporativo_1 EQ 1>
				<cfset LvarCierreCorporativo_1 = 2>
				<!--- Primer Cierre Corporativo:
					Ajustar SaldosIniciales Fiscal
					Generar Asiento de Ajuste al Cierre Corporativo
					Ajustar SaldosIniciales Corporativo y SaldosInicialesCierre Corporativo
				--->
				<!--- Ajustar SaldosIniciales Fiscales tipo=100 --->
				<cfset tabCtaNiv = tabCtaNiv_Fiscal>
				<cfset tabResNiv = tabResNiv_Fiscal>
				<cfset sbMayorizarSaldosContables(Arguments.IDcontable, 100, LvarAnoAjuste, LvarMesAjuste, Arguments.CuentaUtilidad)>

				<cfset tabCtaNiv = tabCtaNiv_Corporativo>
				<cfset tabResNiv = tabResNiv_Corporativo>
				<!--- Generar Asiento de Ajuste al Cierre Corporativo --->
				<cfset sbAsientoAjusteCierreAnualXRetroactivo(Arguments.IDcontable, 11, LvarAnoAsiento, LvarMesAsiento, Arguments.CuentaUtilidad)>
				<!--- Ajustar SaldosIniciales Corporativo y SaldosInicialesCierre Corporativo ECtipo=11 + 100 --->
				<cfset sbMayorizarSaldosContables(Arguments.IDcontable, 111, LvarAnoAjuste, LvarMesAjuste, Arguments.CuentaUtilidad)>
			<cfelseif LvarCierreFiscal_1 EQ 2 and LvarMesAsiento Eq LvarMesCierreFiscal>
				<!--- Ajustar SaldosIniciales Fiscales y SaldosCierre de Utilidad tipo=1 +200 y Corporativos tipo=110 --->
				<cfset tabCtaNiv = tabCtaNiv_Fiscal>
				<cfset tabResNiv = tabResNiv_Fiscal>
				<cfset sbMayorizarSaldosContables(Arguments.IDcontable, 201, LvarAnoAjuste, LvarMesAjuste, Arguments.CuentaUtilidad)>

				<cfif LvarHayCorporativo>
					<cfset tabCtaNiv = tabCtaNiv_Corporativo>
					<cfset tabResNiv = tabResNiv_Corporativo>
					<cfset sbMayorizarSaldosContables(Arguments.IDcontable, 110, LvarAnoAjuste, LvarMesAjuste, Arguments.CuentaUtilidad)>
				</cfif>
			<cfelseif LvarCierreCorporativo_1 EQ 2 and LvarMesAsiento Eq LvarMesCierreCorporativo>
				<!--- Ajustar SaldosIniciales Fiscales tipo=100 y Corporativos y SaldosCierre de Utilidad tipo=11 + 200 --->
				<cfset tabCtaNiv = tabCtaNiv_Fiscal>
				<cfset tabResNiv = tabResNiv_Fiscal>
				<cfset sbMayorizarSaldosContables(Arguments.IDcontable, 100, LvarAnoAjuste, LvarMesAjuste, Arguments.CuentaUtilidad)>

				<cfset tabCtaNiv = tabCtaNiv_Corporativo>
				<cfset tabResNiv = tabResNiv_Corporativo>
				<cfset sbMayorizarSaldosContables(Arguments.IDcontable, 211, LvarAnoAjuste, LvarMesAjuste, Arguments.CuentaUtilidad)>
			<cfelse>
				<!--- Ajustar SaldosIniciales Fiscales tipo=100 y Corporativos tipo=110 --->
				<cfset tabCtaNiv = tabCtaNiv_Fiscal>
				<cfset tabResNiv = tabResNiv_Fiscal>
				<cfset sbMayorizarSaldosContables(Arguments.IDcontable, 100, LvarAnoAjuste, LvarMesAjuste, Arguments.CuentaUtilidad)>

				<cfif LvarHayCorporativo>
					<cfset tabCtaNiv = tabCtaNiv_Corporativo>
					<cfset tabResNiv = tabResNiv_Corporativo>
					<cfset sbMayorizarSaldosContables(Arguments.IDcontable, 110, LvarAnoAjuste, LvarMesAjuste, Arguments.CuentaUtilidad)>
				</cfif>
			</cfif>
		</cfloop>
	</cffunction>

	<cffunction name="GrabarTransaccion" access="private" output="no">
			<cfargument name = "IDcontable"     type="numeric" required="yes">
			<cfargument name = "lArgPeriodo"    type="numeric" required="yes">
			<cfargument name = "lArgMes"        type="numeric" required="yes">
			<cfargument name = "lArgPeriodoMes" type="numeric" required="yes">

			<!---
				Generar la historia en las estructuras historicas de Asientos / Polizas Contables
				El insert a HEContables pasa al inicio de la transaccion
			--->
			<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
			<cfquery datasource="#session.dsn#">
				insert into HDContables (
					IDcontable, Ecodigo, Eperiodo, Emes, Cconcepto, Edocumento, Dlinea, Ocodigo, Ddescripcion, Ddocumento, Dmovimiento,
					Ccuenta, CFcuenta, Doriginal, Dlocal, Mcodigo, Dtipocambio, Dreferencia, CFid
<!--- Control Evento Inicia --->
                    ,NumeroEvento
<!--- Control Evento Fin --->
                    )
				select
					IDcontable, Ecodigo, Eperiodo, Emes, Cconcepto, Edocumento, Dlinea, Ocodigo, Ddescripcion, Ddocumento, Dmovimiento,
					Ccuenta, CFcuenta, Doriginal, Dlocal, Mcodigo, Dtipocambio, Dreferencia, CFid
<!--- Control Evento Inicia --->
                    ,NumeroEvento
<!--- Control Evento Fin --->
				from #LvarTablaAsiento#
				where IDcontable = #Arguments.IDcontable#
			</cfquery>

			<cfquery name="rsAsiento" datasource="#Session.DSN#">
				select
					IDcontable, Ecodigo, Cconcepto, Eperiodo, Emes,
					Edocumento, Efecha, Edescripcion, Edocbase, Ereferencia,
					ECauxiliar, ECusuario, ECselect, ECtipo, Ocodigo, Oorigen,
					ECusucodigo, ECfechacreacion, ECipcrea, ECestado,
					NAP, NRP, BMUsucodigo, ECreversible
				from EContables
				where IDcontable = #Arguments.IDcontable#
			</cfquery>
			<cfset LvarOorigenAsiento = rsAsiento.Oorigen>
			<!--- Si el asiento contable es reversible --->
			<cfif rsAsiento.recordCount and rsAsiento.ECreversible EQ 1>
				<!--- Obtener el Periodo y el mes siguientes al asiento que se está aplicando --->
				<cfset ProximoMes = (rsAsiento.Emes MOD 12) + 1>
				<cfif ProximoMes eq 1>
					<cfset ProximoPeriodo = rsAsiento.Eperiodo + 1>
				<cfelse>
					<cfset ProximoPeriodo = rsAsiento.Eperiodo>
				</cfif>

				<!--- Creación del nuevo asiento --->
				<cfinvoke returnvariable="Edoc" component="sif.Componentes.Contabilidad" method="Nuevo_Asiento"
					Ecodigo="#rsAsiento.Ecodigo#"
					Cconcepto="#rsAsiento.Cconcepto#"
					Oorigen=" "
					Eperiodo="#ProximoPeriodo#"
					Emes="#ProximoMes#">
				</cfinvoke>

				<cfset LvarTipoDocumento = 0>

				<cfif EContables.ECtipo EQ 2>
					<!---  Es un documento retroactivo y reversible. Si el asiento reversado queda en un mes cerrado, debe ser retroactivo al generarse --->

					<cfset lFuncPeriodoMes = ProximoPeriodo * 12 + ProximoMes>

					<cfif lFuncPeriodoMes LT lArgPeriodoMes>
						<cfset LvarTipoDocumento = 2>
					</cfif>
				</cfif>
				<cfquery name="PREinsECRev" datasource="#Session.DSN#">
				    select Ecodigo, Cconcepto, Edescripcion, Edocbase, Ereferencia, ECusuario, ECselect,Ocodigo, Oorigen
					  from EContables
					where IDcontable = #Arguments.IDcontable#
				</cfquery>
				<cfquery name="insEContableRev" datasource="#Session.DSN#">
					insert into EContables (
						Ecodigo, Cconcepto,
						Eperiodo,
						Emes,
						Edocumento,
						Efecha,
						Edescripcion, Edocbase, Ereferencia, ECauxiliar, ECusuario,
						ECselect,
						ECtipo,
						Ocodigo,
						Oorigen,
						ECusucodigo,
						ECfechacreacion,
						ECipcrea,
						ECestado,
						BMUsucodigo)
					values(
						   #PREinsECRev.Ecodigo#,
						   #PREinsECRev.Cconcepto#,
						   #ProximoPeriodo#,
						   #ProximoMes#,
						   #Edoc#,
						   #createdate(ProximoPeriodo,ProximoMes,01)#,
						   'Reversión de ' #_Cat# '#PREinsECRev.Edescripcion#',
						   '#PREinsECRev.Edocbase#',
						   '#PREinsECRev.Ereferencia#',
						   'S',
						   '#PREinsECRev.ECusuario#',
                           <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#PREinsECRev.ECselect#" voidnull>,
						   #LvarTipoDocumento#,
						   <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#PREinsECRev.Ocodigo#" voidnull>,
						   <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#PREinsECRev.Oorigen#" voidnull>,
						   #Session.Usucodigo#,
						   <cf_dbfunction name="now">,
						   '#Session.sitio.ip#',
						   1,
						   #Session.Usucodigo#
					)
				  <cf_dbidentity1 datasource="#Session.DSN#" verificar_transaccion="false">
				</cfquery>
				<cf_dbidentity2 datasource="#Session.DSN#" name="insEContableRev" verificar_transaccion="false">

				<cfquery name="insDContablesRev" datasource="#Session.DSN#">
					insert into DContables (IDcontable, Dlinea, Ecodigo, Cconcepto, Eperiodo, Emes, Edocumento, Ocodigo, Ddescripcion, Ddocumento, Dreferencia, Dmovimiento, Ccuenta, CFcuenta, Doriginal, Dlocal, Mcodigo, Dtipocambio, BMUsucodigo, CFid
<!--- Control Evento Inicia --->
                    ,NumeroEvento
<!--- Control Evento Fin --->
                    )
					select #insEContableRev.identity#,
						   Dlinea, Ecodigo, Cconcepto,
						   #ProximoPeriodo#,
						   #ProximoMes#,
						   #Edoc#,
						   Ocodigo, Ddescripcion, Ddocumento, Dreferencia,
						   case when Dmovimiento = 'D' then 'C' else 'D' end as Dmovimiento,
						   Ccuenta, CFcuenta, Doriginal, Dlocal, Mcodigo, Dtipocambio,
						   #Session.Usucodigo#,
                           CFid
<!--- Control Evento Inicia --->
                           ,NumeroEvento
<!--- Control Evento Fin --->
					from DContables
					where IDcontable = #Arguments.IDcontable#
				</cfquery>
			</cfif>

			<cfif len(LvarOorigenAsiento) EQ 0 or left(LvarOorigenAsiento,2) NEQ 'AF'>
				<cfquery name="rsGATransacciones" datasource="#session.dsn#">
					select count(1) as CantidadRegistros
					from GATransacciones
					where IDcontable = #Arguments.IDcontable#
				</cfquery>
				<cfif rsGATransacciones.CantidadRegistros EQ 0>
					<!---
						Se procesan cuentas de Activos Fijos y se insertan o actualizan datos en sistema de Gestion de Activos, tabla GATransacciones
						Unicamente cuando no existen registros de este asiento contable en la tabla GATransacciones
					--->
					<cfquery datasource="#session.dsn#">
							insert into GATransacciones (
									Ecodigo, 			Cconcepto, 				GATperiodo, 		GATmes,
									GATmonto,
									Edocumento,
									GATfecha,
									GATdescripcion,		Ocodigo,
									fechaalta,
									BMUsucodigo,
									CFcuenta, 			GATestado,				IDcontable,			CFid
							)
							select 	a.Ecodigo, 		a.Cconcepto,				a.Eperiodo, 			a.Emes,
									round(a.Dlocal * case when a.Dmovimiento = 'D' then 1.00 else -1.00 end,2),
									a.Edocumento,
									<cfqueryparam cfsqltype="cf_sql_date" value="#rsAsiento.Efecha#">,
									a.Ddescripcion, 			a.Ocodigo,
									<cf_dbfunction name="now">,
									#Session.Usucodigo#,
									a.CFcuenta,			0,
									a.IDcontable, CFid
							from DContables a
								inner join CFinanciera b
								   on b.CFcuenta = a.CFcuenta
								   and b.Ecodigo = a.Ecodigo
							where a.IDcontable = #Arguments.IDcontable#
							and exists(
								select 1
								from GACMayor c
									where c.Ecodigo = b.Ecodigo
									  and c.Cmayor  = b.Cmayor
									  and <cf_dbfunction name="like" args="b.CFformato ; {fn concat(c.Cmascara,'%')}" delimiters=";">
							)
					</cfquery>
				</cfif>
			</cfif>
	</cffunction>

	<!--- Se incluyó esta funcion para realizar validaciones de Reglas, Cts Inactivas y Pertenencia --->
	<cffunction name="CG_ValidacionesAsiento" access="public" output="no">
		<cfargument name="IDcontable" type="numeric">
		<cfargument name="Efecha" type="numeric" required="no">
		<cfargument name="tipoMensaje" type="string" required="no" default="cfthrow">
		<cfargument name="LineasMaximas" type="numeric" required="no" default="100">

		<!---
			tipoMensaje: 	cfthrow=cfthrow
							not cfthrow=muestra un html
		--->

		<cfif Arguments.TipoMensaje EQ "cfthrow">
			<cfset LineasMaximas = 10>
		</cfif>

		<cfif not isdefined("Arguments.Efecha")>
			<cfset Var_Efecha = Mid(dateformat(Now(),"yyyymmdd"),1,6)>
		<cfelse>
			<cfset Var_Efecha = Arguments.Efecha>
		</cfif>

		<!--- ******************* Validacion de Reglas ******************* --->
		<cfset Lvar_mensaje = "">
		<cfquery name="rsReglas" datasource="#session.dsn#"  maxrows="#LineasMaximas#">
			select distinct CFformato
			  from EContables A
				inner join #LvarTablaAsiento# B
					 on B.IDcontable = A.IDcontable
				inner join CFinanciera C
					 on C.CFcuenta = B.CFcuenta
				inner join Oficinas O
					  on O.Ecodigo  = C.Ecodigo
					 and O.Ocodigo  = B.Ocodigo
			where B.IDcontable = #Arguments.IDcontable#
			  and exists(select 1
						 from PCReglas R
						 where R.PCRref is null
						   and R.PCRvalida = 1
						   and R.Cmayor = C.Cmayor
						   and R.Ecodigo = C.Ecodigo
						   and A.Efecha between R.PCRdesde and R.PCRhasta
			  and not exists(select 1
							 from PCReglas  R2
							 where R2.PCRref is null
							   and R2.PCRvalida = 1
							   and C.Cmayor = R2.Cmayor
							   and C.Ecodigo = R2.Ecodigo
							   and A.Efecha between R2.PCRdesde and R2.PCRhasta
							   and <cf_dbfunction name="like" args="C.CFformato ; R2.PCRregla" delimiters=";">
							   and <cf_dbfunction name="like" args="O.Oficodigo ; coalesce(R2.OficodigoM, '%')" delimiters=";">
							   and not exists (select 1
										   from PCReglas F
										   where F.PCRref = R2.PCRid
										   and F.PCRvalida = 0
										   and A.Efecha between F.PCRdesde and F.PCRhasta
										   and <cf_dbfunction name="like" args="C.CFformato ; F.PCRregla" delimiters=";">
										   and <cf_dbfunction name="like" args="O.Oficodigo ; coalesce(F.OficodigoM, '%')" delimiters=";"> ))
					)
		</cfquery>
		<cfloop query="rsReglas">
			<cfset Lvar_mensaje = Lvar_mensaje & "La Cuenta #rsReglas.CFformato# no cumple con una regla de inclusión, o es una excepción a la regla<BR>">
		</cfloop>
		<cfquery name="rsReglas" datasource="#session.dsn#" maxrows="#LineasMaximas#">
			select distinct CFformato
			from EContables A
				inner join #LvarTablaAsiento# B
					 on B.IDcontable = A.IDcontable
				inner join CFinanciera C
					 on C.CFcuenta = B.CFcuenta
				inner join Oficinas O
					 on O.Ecodigo  = C.Ecodigo
					 and O.Ocodigo = B.Ocodigo
			where B.IDcontable = #Arguments.IDcontable#
			  and exists(select 1
						 from PCReglas R
						 where R.PCRref is null
						   and R.PCRvalida = 0
						   and R.Cmayor = C.Cmayor
						   and R.Ecodigo = C.Ecodigo
						   and A.Efecha between R.PCRdesde and R.PCRhasta
			  and exists(select 1
							 from PCReglas  R2
							 where R2.PCRref is null
							   and R2.PCRvalida = 0
							   and C.Cmayor = R2.Cmayor
							   and C.Ecodigo = R2.Ecodigo
							   and A.Efecha between R2.PCRdesde and R2.PCRhasta
							   and <cf_dbfunction name="like" args="C.CFformato ; R2.PCRregla" delimiters=";">
							   and <cf_dbfunction name="like" args="O.Oficodigo ; coalesce(R2.OficodigoM, '%')" delimiters=";">
							   and not exists (select 1
										   from PCReglas F
										   where F.PCRref = R2.PCRid
										   and F.PCRvalida = 1
										   and A.Efecha between F.PCRdesde and F.PCRhasta
										   and <cf_dbfunction name="like" args="C.CFformato ; F.PCRregla" delimiters=";">
			   							   and <cf_dbfunction name="like" args="O.Oficodigo ; coalesce(F.OficodigoM, '%')" delimiters=";"> ))
						)
		</cfquery>
		<cfloop query="rsReglas">
			<cfset Lvar_mensaje = Lvar_mensaje & "La Cuenta #rsReglas.CFformato# tiene una regla de exclusión, y no es una excepción a la regla<BR>">
		</cfloop>

		<!--- Validacion de Cuentas Inactivas --->

		<!--- Cuentas Financieras --->
		<cfquery name="CtsInactivas" datasource="#Session.DSN#" maxrows="#LineasMaximas#">
			Select distinct cf.CFformato, i.CFIdesde, i.CFIhasta
			from EContables a
				inner join #LvarTablaAsiento# b
					on b.IDcontable = a.IDcontable
						inner join CFinanciera cf
							on cf.CFcuenta = b.CFcuenta
							inner join PCDCatalogoCuentaF cc
								on cc.CFcuenta = cf.CFcuenta
								inner join CFInactivas i
									on  i.CFcuenta = cc.CFcuentaniv
									and a.Efecha between i.CFIdesde and i.CFIhasta
			where a.IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDcontable#">
		</cfquery>

		<cfloop query ="CtsInactivas">
			<cfset Lvar_mensaje = Lvar_mensaje & "La Cuenta Financiera '#trim(CtsInactivas.CFformato)#' esta inactiva desde '#dateFormat(CtsInactivas.CFIdesde,"DD/MM/YYYY")#' hasta '#dateFormat(CtsInactivas.CFIhasta,"DD/MM/YYYY")#' <BR>">
		</cfloop>

		<!--- Cuentas Contables --->
		<cfquery name="CtsInactivasC" datasource="#Session.DSN#" maxrows="#LineasMaximas#">
			Select distinct cc.Cformato, i.CCIdesde, i.CCIhasta
			from EContables a
				inner join #LvarTablaAsiento# b
					on b.IDcontable = a.IDcontable
						inner join CFinanciera cf
							on cf.CFcuenta = b.CFcuenta
							inner join CContables cc
								on cf.Ccuenta = cc.Ccuenta
							inner join PCDCatalogoCuenta cb
								on cc.Ccuenta = cb.Ccuenta
								inner join CCInactivas i
									on  i.Ccuenta = cb.Ccuentaniv
									and a.Efecha between i.CCIdesde and i.CCIhasta
			where a.IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDcontable#">
		</cfquery>

		<cfloop query ="CtsInactivasC">
			<cfset Lvar_mensaje = Lvar_mensaje & "La Cuenta Contable '#trim(CtsInactivasC.Cformato)#' esta inactiva desde '#dateFormat(CtsInactivasC.CCIdesde,"DD/MM/YYYY")#' hasta '#dateFormat(CtsInactivasC.CCIhasta,"DD/MM/YYYY")#' <br>">
		</cfloop>

		<!--- Cuentas Presupuestarias --->
		<cfquery name="CtsInactivasP" datasource="#Session.DSN#" maxrows="#LineasMaximas#">
			Select distinct cp.CPformato, i.CPIdesde, i.CPIhasta
			from EContables a
				inner join #LvarTablaAsiento# b
					on b.IDcontable = a.IDcontable
						inner join CFinanciera cf
							on cf.CFcuenta = b.CFcuenta
							inner join CPresupuesto cp
								on cf.CPcuenta = cp.CPcuenta
								inner join PCDCatalogoCuentaP cb
									on cp.CPcuenta = cb.CPcuenta
									inner join CPInactivas i
										on  i.CPcuenta = cb.CPcuentaniv
										and a.Efecha between i.CPIdesde and i.CPIhasta
			where a.IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDcontable#">
		</cfquery>

		<cfloop query ="CtsInactivasP">
			<cfset Lvar_mensaje = Lvar_mensaje & "La Cuenta de Presupuesto '#trim(CtsInactivasP.CPformato)#' esta inactiva desde '#dateFormat(CtsInactivasP.CPIdesde,"DD/MM/YYYY")#' hasta '#dateFormat(CtsInactivasP.CPIhasta,"DD/MM/YYYY")#' <BR>">
		</cfloop>

		<!--- Validacion por Oficinas --->
		<cfquery name="ValoresOfc" datasource="#Session.DSN#" maxrows="#LineasMaximas#">
			Select distinct
				dc.PCDvalor,  dc.PCDdescripcion , ec.PCEcodigo , ec.PCEdescripcion , cf.CFformato , cc.PCDCniv , o.Oficodigo
			from EContables a
				inner join #LvarTablaAsiento# b
					on b.IDcontable = a.IDcontable
					inner join CFinanciera cf
						on cf.CFcuenta = b.CFcuenta
						inner join Oficinas o
							 on o.Ecodigo = cf.Ecodigo
							and o.Ocodigo = b.Ocodigo
							inner join PCDCatalogoCuentaF cc
								on cc.CFcuenta = cf.CFcuenta
								inner join PCDCatalogo dc
									on dc.PCDcatid = cc.PCDcatid
									inner join PCECatalogo ec
										 on ec.PCEcatid = dc.PCEcatid
										and ec.PCEempresa = 1
										and ec.PCEoficina = 1
			where a.IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDcontable#">
			  and not exists(
					select 1
					from PCDCatalogoValOficina vo
					where vo.PCDcatid = cc.PCDcatid
					  and vo.Ecodigo  = o.Ecodigo
					  and vo.Ocodigo  = o.Ocodigo)
		</cfquery>

		<cfloop query ="ValoresOfc">
			<cfset Lvar_mensaje = Lvar_mensaje & "El valor #ValoresOfc.PCDvalor# - #ValoresOfc.PCDdescripcion# , del catalogo #ValoresOfc.PCEcodigo# - #ValoresOfc.PCEdescripcion# , Cuenta #ValoresOfc.CFformato# , nivel #ValoresOfc.PCDCniv# no es permitido en la oficina #ValoresOfc.Oficodigo# <BR>">
		</cfloop>

		<cfif isdefined("Lvar_mensaje") and len(Lvar_mensaje)>
			<cfif Arguments.TipoMensaje EQ "cfthrow">
				<cfthrow message="#Lvar_mensaje#">
			<cfelse>
				<cflocation url="/cfmx/sif/Utiles/CG_AplicaAsientoErrores.cfm?Errores=#urlEncodedFormat(Lvar_mensaje)#">
			</cfif>
		</cfif>
	</cffunction>

	<!--- Este asiento no se aplica: sólo se registra, porque se mayoriza como ajuste --->
	<!--- Se usa tanto en Aplicacion de Asientos Retroactivos como en Arranque de Cierre Corporativo --->
	<cffunction name="sbAsientoAjusteCierreAnualXRetroactivo" output="no" access="package">
		<cfargument name="IDcontable"		type="numeric">
		<cfargument name="ECtipo"			type="numeric">
		<cfargument name="Periodo"			type="numeric">
		<cfargument name="Mes"				type="numeric">
		<cfargument name="CuentaUtilidad" 	type="numeric" required="yes">
		<cfargument name="fromH" 			type="boolean" default="no">

		<cfif Arguments.fromH>
			<cfset LvarTablaAsiento = "HDContables">
		</cfif>

		<cfquery name="rsSQL" datasource="#session.dsn#">
			select 	count(1) as cantidad
			  from 	#LvarTablaAsiento# d
				inner join CContables c
						inner join CtasMayor m
								on  m.Ecodigo = c.Ecodigo
								and m.Cmayor  = c.Cmayor
								and m.Ctipo in ('I', 'G')
					on c.Ccuenta = d.Ccuenta
			 where 	d.IDcontable = #Arguments.IDcontable#
		</cfquery>
		<cfif rsSQL.cantidad EQ 0>
			<cfreturn>
		</cfif>

		<!--- Creación del nuevo asiento --->
		<cfif Arguments.ECtipo EQ "1">
			<cfset LvarOrigen 		= "CGCF">
			<cfset LvarTipoCierre 	= "CIERRE FISCAL">
			<cfset LvarDocRef 		= "RETROACTIVO FISCAL">
		<cfelseif Arguments.ECtipo EQ "11">
			<cfset LvarOrigen 		= "CGCC">
			<cfset LvarTipoCierre 	= "CIERRE CORPORATIVO">
			<cfset LvarDocRef 		= "RETROACTIVO CORPORATIVO">
		<cfelse>
			<cfthrow message="Generación de Asiento de Ajuste al Cierre por Asiento Retroactivo.  Tipo de Asiento incorrecto">
		</cfif>

		<cfquery name="rsSQL" datasource="#session.dsn#">
			select Cconcepto
			  from ConceptoContable
			 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			   and Oorigen = <cfqueryparam cfsqltype="cf_sql_char" value="#LvarOrigen#">
		</cfquery>
		<cfset LvarCconcepto = rsSQL.Cconcepto>
		<cfinvoke returnvariable="LvarEdoc" component="sif.Componentes.Contabilidad" method="Nuevo_Asiento"
			Ecodigo		= "#session.Ecodigo#"
			Cconcepto	= "#LvarCconcepto#"
			Oorigen		= "#LvarOrigen#"
			Eperiodo	= "#Arguments.Periodo#"
			Emes		= "#Arguments.Mes#">
		</cfinvoke>

		<cfquery name="rsSQL" datasource="#session.dsn#">
			select 	Eperiodo, Emes, Cconcepto, Edocumento
			  from 	HEContables
			 where 	IDcontable = #Arguments.IDcontable#
		</cfquery>
		<cfset LvarDocBase		= "#rsSQL.Eperiodo#/#numberFormat(rsSQL.Emes,"00")# #rsSQL.Cconcepto#-#rsSQL.Edocumento#">
		<cfset LvarDescripcion	= "AJUSTE AL #LvarTipoCierre# POR POLIZA RETROACTIVA #LvarDocBase#">
		<cfquery name="rsInsert" datasource="#session.dsn#">
			insert into EContables (
					Ecodigo, Eperiodo, Emes, Cconcepto, Edocumento,
					Edescripcion, Edocbase, Ereferencia,
					ECtipo,
					Efecha, ECauxiliar, ECusuario,
					Ocodigo, Oorigen, ECusucodigo, ECfechacreacion, ECestado,
					NAP, NRP, CPNAPIid
				)
			select
					#session.Ecodigo#, #Arguments.Periodo#, #Arguments.Mes#, #LvarCconcepto#, #LvarEdoc#,
					'#LvarDescripcion#',
					'#LvarDocBase#',
					'#LvarDocRef#',
					#Arguments.ECtipo#,
					Efecha, ECauxiliar, ECusuario,
					Ocodigo, Oorigen, ECusucodigo, ECfechacreacion, ECestado,
					0, 0, 0
			  from 	HEContables
			 where 	IDcontable = #Arguments.IDcontable#
			<cf_dbidentity1 datasource="#Session.DSN#" name="rsInsert" returnvariable="LvarNewIDcontable">
		</cfquery>
		<cf_dbidentity2 datasource="#Session.DSN#" name="rsInsert" returnvariable="LvarNewIDcontable">

		<cfquery datasource="#session.dsn#">
			insert into HEContables (
					IDcontable,
					Ecodigo, Eperiodo, Emes, Cconcepto, Edocumento,
					Edescripcion, Edocbase, Ereferencia,
					ECtipo,
					Efecha, ECauxiliar, ECusuario,
					Ocodigo, Oorigen, ECusucodigo, ECfechacreacion, ECestado,
					ECusucodigoaplica, ECfechaaplica, ECipaplica, BMUsucodigo,
					NAP, NRP, CPNAPIid
				)
			select
					#LvarNewIDcontable#,
					Ecodigo, Eperiodo, Emes, Cconcepto, Edocumento,
					Edescripcion, Edocbase, Ereferencia,
					ECtipo,
					Efecha, ECauxiliar, ECusuario,
					Ocodigo, Oorigen, ECusucodigo, ECfechacreacion, ECestado,
					#Session.Usucodigo#,
					<cf_dbfunction name="now">,
					'#Session.sitio.ip#',
					#Session.Usucodigo#,
					NAP, NRP, CPNAPIid
			  from 	EContables
			 where 	IDcontable = #LvarNewIDcontable#
		</cfquery>

		<cfquery datasource="#session.dsn#">
			insert into HDContables (
				IDcontable,
				Ecodigo, Eperiodo, Emes, Cconcepto, Edocumento,
				Ddescripcion, Ddocumento, Dreferencia,
				Ocodigo, Mcodigo, Ccuenta, CFcuenta,
				Dlinea,
				Dmovimiento, Doriginal, Dlocal, Dtipocambio)
			select
				#LvarNewIDcontable#,
				#session.Ecodigo#, #Arguments.Periodo#, #Arguments.Mes#, #LvarCconcepto#, #LvarEdoc#,
					'#LvarDescripcion#',
					'#LvarDocBase#',
					'#LvarDocRef#',
				d.Ocodigo, d.Mcodigo, d.Ccuenta, min(d.CFcuenta),
				min(Dlinea),
				<!--- Como se está ajustando el cierre: cuando el ajuste es Debito, se debe cancelar con Credito --->
				case when sum(case when Dmovimiento = 'D' then Dlocal 	 else -Dlocal 	 end) < 0 then 'D' else 'C' end,
				abs(round(sum(case when Dmovimiento = 'D' then Doriginal else -Doriginal end), 2)),
				abs(round(sum(case when Dmovimiento = 'D' then Dlocal 	 else -Dlocal 	 end), 2)),
				0
			from #LvarTablaAsiento# d
				inner join CContables c
						inner join CtasMayor m
								on  m.Ecodigo = c.Ecodigo
								and m.Cmayor  = c.Cmayor
								and m.Ctipo in ('I', 'G')
					on c.Ccuenta = d.Ccuenta
			where IDcontable = #Arguments.IDcontable#
			group by d.Ccuenta, d.Ocodigo, d.Mcodigo
		</cfquery>

		<cfquery name="rsUtilidad" datasource="#session.dsn#">
			select CFcuenta
			  from CFinanciera
			 where Ecodigo = #session.Ecodigo#
			   and Ccuenta = #arguments.CuentaUtilidad#
		</cfquery>

		<cfquery name="rsSQL" datasource="#session.dsn#">
			select 	max(Dlinea) as Linea
			 from HDContables
			where IDcontable = #LvarNewIDcontable#
		</cfquery>
		<cfset LvarLinea = rsSQL.Linea>
		<cfquery name="rsDetalle" datasource="#session.dsn#">
			select 	Ocodigo, Mcodigo,
					    round(sum(case when Dmovimiento = 'D' then Dlocal 	 else -Dlocal end), 2) as Monto,
					abs(round(sum(case when Dmovimiento = 'D' then Doriginal else -Doriginal end), 2)) as Doriginal,
					abs(round(sum(case when Dmovimiento = 'D' then Dlocal 	 else -Dlocal 	 end), 2)) as Dlocal
			 from HDContables
			where IDcontable = #LvarNewIDcontable#
			group by Ocodigo, Mcodigo
		</cfquery>
		<cfloop query="rsDetalle">
			<cfset LvarLinea = LvarLinea + 100>
			<cfquery datasource="#session.dsn#">
				insert into HDContables (
					IDcontable,
					Ecodigo, Eperiodo, Emes, Cconcepto, Edocumento,
					Ddescripcion, Ddocumento, Dreferencia,
					Ocodigo, Mcodigo, Ccuenta, CFcuenta,
					Dlinea,
					Dmovimiento, Doriginal, Dlocal, Dtipocambio
				)
				values (
					#LvarNewIDcontable#,
					#session.Ecodigo#, #Arguments.Periodo#, #Arguments.Mes#, #LvarCconcepto#, #LvarEdoc#,
						'#LvarDescripcion#',
						'#LvarDocBase#',
						'#LvarDocRef#',
					#rsDetalle.Ocodigo#, #rsDetalle.Mcodigo#, #Arguments.CuentaUtilidad#, #rsUtilidad.CFcuenta#,
					#LvarLinea#,
					<!--- Como se está ajustando el cierre: cuando el ajuste es Debito, se canceló con Credito, por tanto, Utilidad es Debito --->
					<cfif rsDetalle.Monto LTE 0>'D'<cfelse>'C'</cfif>,
					#rsDetalle.Doriginal#,
					#rsDetalle.Dlocal#,
					0
				)
			</cfquery>
		</cfloop>

		<cfquery datasource="#session.dsn#">
			update HDContables
			   set Dlinea =
			   		(
						select count(1)
						  from HDContables d
						 where d.IDcontable = HDContables.IDcontable
						   and d.Dlinea <= HDContables.Dlinea
					)
				 , Dtipocambio =
				 		case
							when Dlocal = 0
								then 1
								else Doriginal / Dlocal
						end
			where IDcontable = #LvarNewIDcontable#
		</cfquery>

		<cfquery name="rsInsert" datasource="#session.dsn#">
			delete from EContables
			 where IDcontable = #LvarNewIDcontable#
		</cfquery>
	</cffunction>

	<!--- Se incluyó funcion para validar querys (ADVV) --->
	<cffunction name="fnExists" output="no" access="private">
		<cfargument name="LvarSQL">

		<cfif isDefined("session.dsn") and not isDefined("arguments.LvarDatasource")>
			<cfset arguments.LvarDatasource = session.dsn>
		</cfif>

		<cfquery name="rsExists" datasource="#session.dsn#" >
			select count(1) as cantidad from dual where exists(#preservesinglequotes(LvarSQL)#)
		</cfquery>
		<cfreturn (rsExists.cantidad EQ 1)>
	</cffunction>

	<cffunction name="fnCFcatchFuenteLinea" returntype="string" access="public">
		<cfargument name="objCFcatch" type="any">
		<cfset var LvarError = "">
		<cftry>
			<cfif isdefined("Arguments.objCFcatch.TagContext")>
				<cfset LvarTagContext1 = Arguments.objCFcatch.TagContext[1]>
				<cfif ucase(Arguments.objCFcatch.Type) EQ "APPLICATION" AND isdefined('LvarTagContext1.ID') AND ucase(LvarTagContext1.ID) EQ "CFTHROW">
					<cfreturn "">
				</cfif>
				<cfset LvarError = LvarTagContext1.Template>
				<cfif find(expandPath("/"),LvarError)>
					<cfset LvarError = mid(LvarError,find(expandPath("/"),LvarError),len(LvarError))>
					<cfset LvarError = Replace(LvarError,expandPath("/"),"CFMX/")>
					<cfset LvarError = REReplace(LvarError,"[/\\]","/","ALL")>
				</cfif>
				<cfset LvarError = "<BR>" & LvarError & ": " & LvarTagContext1.Line>
			</cfif>
		<cfcatch type="any"></cfcatch>
		</cftry>
		<cfreturn LvarError>
	</cffunction>
</cfcomponent>
