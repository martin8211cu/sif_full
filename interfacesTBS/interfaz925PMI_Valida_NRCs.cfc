<cfcomponent output="no">
	<cffunction name="CG_AplicaAsiento" access="public" output="no">
		<cfargument name="ID925" 		type="numeric">
		<cfargument name="Periodo" 		type="numeric">
		<cfargument name="Mes" 		type="numeric">
 
	
		<cfquery datasource="#session.dsn#" name="rsCuentasNomina">
			select e.ID, e.Num_Nomina, e.Fecha_Emision, case n.Cancelacion when 0 then 'NO' when 1 then 'SI' end as Cancelacion, CFcuenta, CFformato,
			Total_Linea from IE925 e
			inner join ID925 d on e.ID = d.ID
			inner join Enc_Pago_Nomina n on n.IE925 = e.ID
			where e.ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.ID925#">
			and Tipo = 'D'
		</cfquery>

		<cfif rsCuentasNomina.RecordCount is 0>
			
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
		<!---??Si el Concepto Contable se le indico que no generar presupuesto se coloca la bandera de afectacion presupuestaria en FALSE??--->
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
                            <cfquery name="rsNCREnc" datasource="#session.dsn#">
                                select NRC_Numero from MensNRCE
                                where Ecodigo = #request.Errores[i].Ecodigo#
                                and NRC_Periodo = #request.Errores[i].Eperiodo#
                                and NRC_Mes = #request.Errores[i].Emes#
                                and NRC_ModuloOrigen = '#request.Errores[i].NRC_ModuloOrigen#'
                                and NRC_RefOrigen = '#request.Errores[i].Edocbase#'
                                and NRC_DocumentoOrigen = '#request.Errores[i].Oorigen#'
                            </cfquery>
                            <cfif rsNCREnc.recordCount EQ 0>
                                <cfquery name="rsInsertNCREnc" datasource="#session.dsn#">
                                    insert MensNRCE (Ecodigo,NRC_Periodo,NRC_Mes,
                                    NRC_ModuloOrigen,NRC_RefOrigen,
                                    NRC_DocumentoOrigen,NRC_Cconcepto)
                                    values(#request.Errores[i].Ecodigo#,#request.Errores[i].Eperiodo#,#request.Errores[i].Emes#,
                                    '#request.Errores[i].NRC_ModuloOrigen#','#request.Errores[i].Edocbase#',
                                    '#request.Errores[i].Oorigen#',#request.Errores[i].Cconcepto#)
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
