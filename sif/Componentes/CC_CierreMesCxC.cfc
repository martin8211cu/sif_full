<!---
	Modificado por Gustavo Fonseca H.
		Fecha 16-2-2006.
		Motivo: Se cambia: cfsqltype="integer" por cfsqltype="cf_sql_integer" en varios puntos de este fuente.
			Se modifica para poner: coalesce(do.id_direccionFact, s.id_direccion).

	Esta es la nomenclatura para los nombres de las tablas temporales que se van a crear
	en el procedimiento de cierre de auxiliares;
		- Para CC_CierreMesCxC
			* Monedas = CierreMes_M
			* Documentos = CierreMes_D
		- Para CP_CierreMesCxP
			* Monedas = CierreMes_M2
			* Documentos = CierreMes_D2
		- Para MB_CierreMesBancos
			* SaldosBancarios = CierreMesB_SB
	-------------------------------------------------------------------------------------------
	property intarc:
	       Contiene el nombre de la tabla temporal de interfaz contable.
		   No debe accederse sin antes haber invocado la funcion "CreaIntarc" del componente "CG_GeneraAsiento.cfc".
	function CreaIntarc:
			Crea o prepara la tabla temporal #This.intarc#.
	property Monedas:
			Nombre de la tabla temporal de Monedas
			No debe accederse sin antes haber invocado la funcion "CreaMonedas"
	function CreaMonedas:
			Crea o prepara la tabla temporal #This.Monedas#.
	property CCDocumentos:
			Nombre de la tabla temporal de CCDocumentos
			No debe accederse sin antes haber invocado la funcion "CreaDocs"
	function CreaDocs:
			Crea o prepara la tabla temporal #This.CCDocumentos#.
--->
<cfcomponent output="no">
	<cffunction name="SISaldosIniciales" access="public" output="no">
		<cfargument name='Ecodigo' type='numeric' required='true' >
		<cfargument name='PeriodoCerrado' type='numeric' required='true'>
		<cfargument name='MesCerrado' type='numeric' required='true'>
		<cfargument name='debug' type="boolean" required='false' default='false'>
		<cfargument name='SIdocumentos' type="string" required='yes'>
		<cfargument name='conexion' type='string' required='false' default="#Session.DSN#">

		<cfset LvarNuevoPeriodo = Arguments.PeriodoCerrado>
		<cfset LvarNuevoMes     = Arguments.MesCerrado>

		<cfset LvarNuevoMes = LvarNuevoMes + 1>

		<cfif LvarNuevoMes eq 13>
			<cfset LvarNuevoPeriodo = LvarNuevoPeriodo + 1>
			<cfset LvarNuevoMes     = 1>
		</cfif>

		<cfset LvarfechainiActual   = CreateDate(LvarNuevoPeriodo,LvarNuevoMes,1)>
		<cfset LvarfechainiAnterior = CreateDate(Arguments.PeriodoCerrado,Arguments.MesCerrado,1)>

		<!--- Parametros para los periodos de vencimiento --->
		<cfquery name="rsParametros" datasource="#session.DSN#">
			select Pvalor as DiasAntiguedad1
			from Parametros
			where Ecodigo = #session.Ecodigo#
				and Pcodigo = 310
		</cfquery>
		<cfif isdefined("rsParametros") and rsParametros.recordcount gt 0>
			<cfset LvarDiasAntiguedad1 = rsParametros.DiasAntiguedad1>
		<cfelse>
			<cf_errorCode	code = "50178" msg = "Debe definir el primer período en los parámetros.">
		</cfif>

		<cfquery name="rsParametros" datasource="#session.DSN#">
			select Pvalor as DiasAntiguedad2
			from Parametros
			where Ecodigo = #session.Ecodigo#
				and Pcodigo = 320
		</cfquery>

		<cfif isdefined("rsParametros") and rsParametros.recordcount gt 0>
			<cfset LvarDiasAntiguedad2 = rsParametros.DiasAntiguedad2>
		<cfelse>
			<cf_errorCode	code = "50179" msg = "Debe definir el segundo período en los parámetros.">
		</cfif>

		<cfquery name="rsParametros" datasource="#session.DSN#">
			select Pvalor as DiasAntiguedad3
			from Parametros
			where Ecodigo = #session.Ecodigo#
				and Pcodigo = 330
		</cfquery>
		<cfif isdefined("rsParametros") and rsParametros.recordcount gt 0>
			<cfset LvarDiasAntiguedad3 = rsParametros.DiasAntiguedad3>
		<cfelse>
			<cf_errorCode	code = "50180" msg = "Debe definir el tercer período en los parámetros.">
		</cfif>
		<cfquery name="rsParametros" datasource="#session.DSN#">
			select Pvalor as DiasAntiguedad4
			from Parametros
			where Ecodigo = #session.Ecodigo#
				and Pcodigo = 340
		</cfquery>
		<cfif isdefined("rsParametros") and rsParametros.recordcount gt 0>
			<cfset LvarDiasAntiguedad4 = rsParametros.DiasAntiguedad4>
		<cfelse>
			<cf_errorCode	code = "50181" msg = "Debe definir el cuarto período en los parámetros.">
		</cfif>
		<!---
			Se definen las fechas de Antiguedad para no requerir uso de funciones de Base de Datos ( datediff ).
			Se resta 1 a la fecha de antiguedad porque la fecha de inicio actual es el primer dia del mes "nuevo" y esa fecha no está vencido el documento
		--->
		<cfset LvarFechaAntiguedad1 = dateadd("d", -LvarDiasAntiguedad1 - 1, LvarfechainiActual)>
		<cfset LvarFechaAntiguedad2 = dateadd("d", -LvarDiasAntiguedad2 - 1, LvarfechainiActual)>
		<cfset LvarFechaAntiguedad3 = dateadd("d", -LvarDiasAntiguedad3 - 1, LvarfechainiActual)>
		<cfset LvarFechaAntiguedad4 = dateadd("d", -LvarDiasAntiguedad4 - 1, LvarfechainiActual)>
		<cfset LvarFechaAntiguedad5 = dateadd("d", -LvarDiasAntiguedad4 - 1 - 30, LvarfechainiActual)>

		<!--- Actualizar los saldos iniciales de los clientes
			  Saldo a la fecha de hoy de cada uno de los documentos vigentes, los otros estaban con saldo cero al cierre
		--->
		<cfquery name="rs2" datasource="#arguments.conexion#">
			insert into  #SIdocumentos# (
					Ecodigo,
					Mcodigo,
					SNcodigo,
					SNid,
					CCTcodigo,
					Ddocumento,
					id_direccion,
					fecha,
					saldo,
					fechavencimiento,
					tipo,
					HDid )
			select  d.Ecodigo,
					d.Mcodigo,
					d.SNcodigo,
					s.SNid,
					d.CCTcodigo,
					d.Ddocumento,
					coalesce(d.id_direccionFact, s.id_direccion),
					d.Dfecha,
					d.Dsaldo,
					d.Dvencimiento,
					t.CCTtipo,
					h.HDid
			from Documentos d
				inner join SNegocios s
				on s.Ecodigo = d.Ecodigo
				and s.SNcodigo = d.SNcodigo

				inner join CCTransacciones t
				on t.CCTcodigo = d.CCTcodigo
				and t.Ecodigo  = d.Ecodigo

				inner join HDocumentos h
				on  h.Ddocumento = d.Ddocumento
				and h.CCTcodigo  = d.CCTcodigo
				and h.SNcodigo   = d.SNcodigo
				and h.Ecodigo    = d.Ecodigo
			where d.Ecodigo = #arguments.Ecodigo#
			  and d.Dfecha  < <cfqueryparam cfsqltype="cf_sql_date" value="#LvarfechainiActual#">
		</cfquery>


		<!--- sumar al saldo de los documentos los movimientos posteriores al cierre. Documentos Tipo Debito o Credito con aplicación de Neteo --->
		<cfquery name="rs2" datasource="#arguments.conexion#">
			update #SIdocumentos#
			set saldo = saldo +
					coalesce((
						select sum(m.Dtotalref)
						from BMovimientos m
						where m.DRdocumento =  #SIdocumentos#.Ddocumento
						  and m.CCTRcodigo  =  #SIdocumentos#.CCTcodigo
						  and m.Ecodigo     =  #SIdocumentos#.Ecodigo
						  and m.Dfecha      >= <cfqueryparam cfsqltype="cf_sql_date" value="#LvarfechainiActual#">
						  and m.Dfecha      > #SIdocumentos#.fecha
						  and (m.CCTRcodigo <> #SIdocumentos#.CCTcodigo or m.DRdocumento <> #SIdocumentos#.Ddocumento )
					) , 0.00)
		</cfquery>

		<!--- sumar al saldo de los documentos los movimientos posteriores al cierre. Documentos que no son tipo Credito generados por un Recibo de Caja --->
		<cfquery name="rs2" datasource="#arguments.conexion#">
			update #SIdocumentos#
			set saldo = saldo +
					coalesce((
						select sum(m.Dtotalref)
						from BMovimientos m
						where m.Ddocumento  =  #SIdocumentos#.Ddocumento
						  and m.CCTcodigo   =  #SIdocumentos#.CCTcodigo
						  and m.Ecodigo     =  #SIdocumentos#.Ecodigo
						  and m.SNcodigo    =  #SIdocumentos#.SNcodigo
						  and m.Dfecha      >= <cfqueryparam cfsqltype="cf_sql_date" value="#LvarfechainiActual#">
						  and m.Dfecha      > #SIdocumentos#.fecha
						  and (m.CCTRcodigo  <> #SIdocumentos#.CCTcodigo or m.DRdocumento <> #SIdocumentos#.Ddocumento )
					) , 0.00)
			where tipo = 'C'
		</cfquery>

		<!--- Actualizar la tabla #SIdocumentos# con saldo negativo cuando la transaccion es negativa (credito) --->
		<cfquery datasource="#arguments.conexion#">
			update #SIdocumentos#
			set saldo = saldo * -1
			where tipo = 'C'
		</cfquery>

		<cfquery datasource="#arguments.conexion#" name="x">
			insert into  SNSaldosIniciales (Ecodigo, Mcodigo, SNid, id_direccion, Speriodo, Smes, SIsaldoinicial, SIsinvencer, 	SIcorriente, SIp1, SIp2, SIp3, SIp4, SIp5, SIp5p, BMfechaalta, BMUsucodigo)
			select distinct do.Ecodigo, do.Mcodigo, s.SNid,
			coalesce(do.id_direccionFact, s.id_direccion),
			#LvarNuevoPeriodo#, #LvarNuevoMes#, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, <cf_dbfunction name="now">, #Session.Usucodigo#
			from Documentos do
				inner join SNegocios s
					 on s.Ecodigo  = do.Ecodigo
					and s.SNcodigo = do.SNcodigo
				inner join Monedas m
					on m.Mcodigo = do.Mcodigo
			where do.Ecodigo = #arguments.Ecodigo#
		</cfquery>

		<!--- Actualizar el saldo de la tabla #SIdocumentos# --->
		<cfquery datasource="#arguments.conexion#">
			update SNSaldosIniciales
			set
				SIsaldoinicial =
					coalesce((
						select sum(d.saldo)
						from #SIdocumentos# d
						where d.SNid         = SNSaldosIniciales.SNid
						  and d.id_direccion = SNSaldosIniciales.id_direccion
						  and d.Mcodigo      = SNSaldosIniciales.Mcodigo
					), 0.00),

				SIcorriente =
					coalesce((
						select sum(d.saldo)
						from #SIdocumentos# d
						where d.SNid              = SNSaldosIniciales.SNid
						  and d.id_direccion      = SNSaldosIniciales.id_direccion
						  and d.Mcodigo           = SNSaldosIniciales.Mcodigo
						  and d.fechavencimiento >= <cfqueryparam cfsqltype="cf_sql_date" value="#LvarfechainiActual#">
						  and d.fecha            <  <cfqueryparam cfsqltype="cf_sql_date" value="#LvarfechainiActual#">
						  and d.fecha            >= <cfqueryparam cfsqltype="cf_sql_date" value="#LvarfechainiAnterior#">
					), 0.00),

				SIsinvencer =
					coalesce((
						select sum(d.saldo)
						from #SIdocumentos# d
						where d.SNid              = SNSaldosIniciales.SNid
						  and d.id_direccion      = SNSaldosIniciales.id_direccion
						  and d.Mcodigo      	  = SNSaldosIniciales.Mcodigo
						  and d.fechavencimiento >= <cfqueryparam cfsqltype="cf_sql_date" value="#LvarfechainiActual#">
						  and d.fecha            <  <cfqueryparam cfsqltype="cf_sql_date" value="#LvarfechainiActual#">
						  and d.fecha            <  <cfqueryparam cfsqltype="cf_sql_date" value="#LvarfechainiAnterior#">
					), 0.00),

				SIp1 =
					coalesce((
						select sum(d.saldo)
						from #SIdocumentos# d
						where d.SNid             = SNSaldosIniciales.SNid
						  and d.id_direccion     = SNSaldosIniciales.id_direccion
						  and d.Mcodigo      	 = SNSaldosIniciales.Mcodigo
						  and d.fecha            <  <cfqueryparam cfsqltype="cf_sql_date" value="#LvarfechainiActual#">
						  and d.fechavencimiento <  <cfqueryparam cfsqltype="cf_sql_date" value="#LvarfechainiActual#">
						  and d.fechavencimiento >= <cfqueryparam cfsqltype="cf_sql_date" value="#LvarfechaAntiguedad1#">
					), 0.00),

				SIp2 =
					coalesce((
						select sum(d.saldo)
						from #SIdocumentos# d
						where d.SNid             = SNSaldosIniciales.SNid
						  and d.id_direccion     = SNSaldosIniciales.id_direccion
						  and d.Mcodigo      	 = SNSaldosIniciales.Mcodigo
						  and d.fecha            <  <cfqueryparam cfsqltype="cf_sql_date" value="#LvarfechainiActual#">
						  and d.fechavencimiento <  <cfqueryparam cfsqltype="cf_sql_date" value="#LvarfechaAntiguedad1#">
						  and d.fechavencimiento >= <cfqueryparam cfsqltype="cf_sql_date" value="#LvarfechaAntiguedad2#">
					), 0.00),

				SIp3 =
					coalesce((
						select sum(d.saldo)
						from #SIdocumentos# d
						where d.SNid             = SNSaldosIniciales.SNid
						  and d.id_direccion     = SNSaldosIniciales.id_direccion
						  and d.Mcodigo      	 = SNSaldosIniciales.Mcodigo
						  and d.fecha            <  <cfqueryparam cfsqltype="cf_sql_date" value="#LvarfechainiActual#">
						  and d.fechavencimiento <  <cfqueryparam cfsqltype="cf_sql_date" value="#LvarfechaAntiguedad2#">
						  and d.fechavencimiento >= <cfqueryparam cfsqltype="cf_sql_date" value="#LvarfechaAntiguedad3#">
					), 0.00),

				SIp4 =
					coalesce((
						select sum(d.saldo)
						from #SIdocumentos# d
						where d.SNid             = SNSaldosIniciales.SNid
						  and d.id_direccion     = SNSaldosIniciales.id_direccion
						  and d.Mcodigo      	 = SNSaldosIniciales.Mcodigo
						  and d.fecha            <  <cfqueryparam cfsqltype="cf_sql_date" value="#LvarfechainiActual#">
						  and d.fechavencimiento <  <cfqueryparam cfsqltype="cf_sql_date" value="#LvarfechaAntiguedad3#">
						  and d.fechavencimiento >= <cfqueryparam cfsqltype="cf_sql_date" value="#LvarfechaAntiguedad4#">
					), 0.00),

				SIp5 =
					coalesce((
						select sum(d.saldo)
						from #SIdocumentos# d
						where d.SNid             = SNSaldosIniciales.SNid
						  and d.id_direccion     = SNSaldosIniciales.id_direccion
						  and d.Mcodigo      	 = SNSaldosIniciales.Mcodigo
						  and d.fecha            <  <cfqueryparam cfsqltype="cf_sql_date" value="#LvarfechainiActual#">
						  and d.fechavencimiento <  <cfqueryparam cfsqltype="cf_sql_date" value="#LvarfechaAntiguedad4#">
						  and d.fechavencimiento >= <cfqueryparam cfsqltype="cf_sql_date" value="#LvarfechaAntiguedad5#">
					), 0.00),
				SIp5p =
					coalesce((
						select sum(d.saldo)
						from #SIdocumentos# d
						where d.SNid             = SNSaldosIniciales.SNid
						  and d.id_direccion     = SNSaldosIniciales.id_direccion
						  and d.Mcodigo      	 = SNSaldosIniciales.Mcodigo
						  and d.fecha            <  <cfqueryparam cfsqltype="cf_sql_date" value="#LvarfechainiActual#">
						  and d.fechavencimiento <  <cfqueryparam cfsqltype="cf_sql_date" value="#LvarfechaAntiguedad5#">
					), 0.00)

			where Speriodo = #LvarNuevoPeriodo#
			  and Smes     = #LvarNuevoMes#
			  and Ecodigo  = #arguments.Ecodigo#
		</cfquery>

		<!--- Borrar los registros que tienen todas las columnas en cero --->
		<cfquery datasource="#arguments.conexion#">
			delete from SNSaldosIniciales
			where Speriodo = #LvarNuevoPeriodo#
			  and Smes     = #LvarNuevoMes#
			  and Ecodigo  = #arguments.Ecodigo#
			  and ( SIsaldoinicial = 0 and SIsinvencer = 0 and SIcorriente = 0 and SIp1 = 0 and SIp2 = 0 and SIp3 = 0 and SIp4 = 0 and SIp5 = 0 and SIp5p = 0 )
		</cfquery>

		<!--- Insertar los documentos que están con saldo a inicio de mes.  Histórico de Documentos al cierre de mes --->
		<cfquery datasource="#arguments.conexion#">
			insert into SNSaldosInicialesD (
				Ecodigo, Speriodo, Smes, SNid, HDid, SNcodigo,
				CCTcodigo, Ddocumento, id_direccion, Mcodigo,
				Dsaldo, Dantiguedad )
			select
				d.Ecodigo, #LvarNuevoPeriodo#, #LvarNuevoMes#, d.SNid, d.HDid, d.SNcodigo,
				d.CCTcodigo, d.Ddocumento, d.id_direccion, d.Mcodigo,
				d.saldo, <cf_dbfunction name="datediff" args="d.fechavencimiento, #LvarfechainiActual#">
			from #SIdocumentos# d
				<!---
				inner join HDocumentos doc
				on  doc.Ddocumento = d.Ddocumento
				and doc.CCTcodigo  = d.CCTcodigo
				and doc.Ecodigo    = d.Ecodigo
				and doc.SNcodigo   = d.SNcodigo
				--->
			where d.saldo <> 0
		</cfquery>
		<cfif arguments.debug>
			<cfquery datasource="#arguments.conexion#" name="rsSaldosIniciales">
				select *
				from SNSaldosIniciales
				where Ecodigo  = #arguments.Ecodigo#
				  and Speriodo = #LvarNuevoPeriodo#
			  	  and Smes     = #LvarNuevoMes#
			</cfquery>
			<cf_dump var="#rsSaldosIniciales#" label="Saldos Iniciales de Cuentas por Cobrar">
		</cfif>
	</cffunction>

	<!--- Cierre de Mes de Cuentas x Cobrar --->
	<cffunction name='CierreMes' access='public' output='no'>
		<cfargument name='Ecodigo' type='numeric' required='true'>
		<cfargument name='debug' type="boolean" required='false' default='false'>
		<cfargument name='conexion' type='string' required='false' default="#Session.DSN#">
		<cfargument name="Monedas" type="string" required="yes">
		<cfargument name="CCDocumentos" type="string" required="yes">
		<cfargument name="SIdocumentos" type="string" required="yes">
		<cfargument name="Intarc" type="string" required="yes">

		<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
		<cfset Monedas = Arguments.Monedas>
		<cfset CCDocumentos = Arguments.CCDocumentos>
		<cfset SIdocumentos = Arguments.SIdocumentos>
		<cfset Intarc = Arguments.Intarc>

		<!--- Validar que exista una dirección principal del socio --->
		<cfquery name="rsValidaSocio" datasource="#Arguments.Conexion#">
			select count(1) as Cantidad
			from SNegocios s
			where s.Ecodigo = #Arguments.Ecodigo#
			  and s.SNtipo  in ('C', 'A')
			  and ((
			  		select count(1)
					from SNDirecciones ds
					where ds.SNid = s.SNid
					  and ds.id_direccion = s.id_direccion
				 )) = 0
		</cfquery>
		<cfif rsValidaSocio.Cantidad GT 0>
			<cf_errorCode	code = "50982"
							msg  = "Existen @errorDat_1@ socios sin Dirección Principal. Por Favor verifique los socios"
							errorDat_1="#rsValidaSocio.Cantidad#"
			>
		</cfif>

		<cfquery datasource="#Arguments.conexion#">
			delete from #Monedas#
		</cfquery>

		<cfquery datasource="#Arguments.conexion#">
			delete from #CCDocumentos#
		</cfquery>

		<cfquery datasource="#Arguments.conexion#">
			delete from #SIdocumentos#
		</cfquery>

		<cfquery datasource="#Arguments.conexion#">
			delete from #Intarc#
		</cfquery>

		<cfif Intarc NEQ '' and Monedas NEQ '' and CCDocumentos NEQ ''>
			<!--- Parámetros Generales --->
			<cfset lin = 1>
			<cfset Periodo = -1>
			<cfset Mes = -1>
			<cfset Fecha = Now()>
			<cfset descripcion = 'CxC: Diferencial Cambiario Mensual.'>
			<cfset Ocodigo = 0>
			<cfset DescMoneda = ''>
			<cfset Monloc = 0>
			<cfset descerror = ''>
			<cfset error = 0>

			<cfquery name="rs_Monloc" datasource="#arguments.conexion#">
				select Mcodigo
				from Empresas
				where Ecodigo = #arguments.Ecodigo#
			</cfquery>

			<cfif isdefined('rs_Monloc') and rs_Monloc.recordCount GT 0>
				<cfset Monloc = rs_Monloc.Mcodigo>
			</cfif>

			<cfquery name="rs_Param1" datasource="#arguments.conexion#">
				select Pvalor
				from Parametros
				where Ecodigo = #arguments.Ecodigo#
				  and Mcodigo = 'GN'
				  and Pcodigo = 50
			</cfquery>
			<cfif isdefined('rs_Param1') and rs_Param1.recordCount GT 0>
				<cfset Periodo = rs_Param1.Pvalor>
			</cfif>

			<cfquery name="rs_Param2" datasource="#arguments.conexion#">
				select Pvalor
				from Parametros
				where Ecodigo = #arguments.Ecodigo#
				  and Mcodigo = 'GN'
				  and Pcodigo = 60
			</cfquery>
			<cfif isdefined('rs_Param2') and rs_Param2.recordCount GT 0>
				<cfset Mes = rs_Param2.Pvalor>
			</cfif>

			<!--- 1) Validaciones Generales --->
			<cfif Periodo EQ -1 or Mes EQ -1>
				<cf_errorCode	code = "50983" msg = "No se ha definido el parámetro de Período o Mes para los sistemas Auxiliares! Proceso Cancelado!">
			</cfif>

			<!--- 2) Asiento Contable x Diferencial Cambiario Mensual --->
			<cfquery name="rs_Docs" datasource="#arguments.conexion#">
				select count(1) as Cantidad
				from Documentos
				where Ecodigo = #arguments.Ecodigo#
					and Dsaldo <> 0.00
					and Mcodigo is not null
			</cfquery>

			<cfif isdefined('rs_Docs') and rs_Docs.Cantidad GT 0>
				<cfquery name="rs_ADocs" datasource="#arguments.conexion#">
					insert INTO #CCDocumentos#( CCTcodigo, Ddocumento, Ecodigo, Mes, Periodo, Ocodigo, SNcodigo, Mcodigo, Ccuenta, Dsaldo, Saldo, Dtcultrev)
					select  a.CCTcodigo, a.Ddocumento, #session.Ecodigo#, #Mes#, #Periodo#, a.Ocodigo, a.SNcodigo, a.Mcodigo, a.Ccuenta,
							a.Dsaldo *
								(
								case b.CCTtipo
									when 'D' then 1.00
									when 'C' then -1.00
									else 0.00 end
								),
							0.00, a.Dtcultrev
					from Documentos a
						inner join CCTransacciones b
							 ON b.Ecodigo   = a.Ecodigo
							AND b.CCTcodigo = a.CCTcodigo
					where a.Ecodigo = #arguments.Ecodigo#
					  and a.Mcodigo is not null
					  and a.Dsaldo <> 0.00
				</cfquery>

				<cfquery name="rs_AMonedas" datasource="#arguments.conexion#">
					insert INTO #Monedas#(Mcodigo, Ecodigo, Mes, Periodo, Ocodigo, TC, Total)
					select distinct Mcodigo, #session.Ecodigo#, #Mes#, #Periodo#, Ocodigo, -1, 0.00
					from #CCDocumentos#
				</cfquery>

				<!---Actualiza el Tipo de Cambio de la tabla temporal Monedas--->
				<cfquery name="TempUpdMonedas" datasource="#arguments.conexion#">
					select coalesce(a.TCEtipocambio,-1) TCEtipocambio, a.Mcodigo,a.Periodo,a.Mes,a.Ecodigo
					 from #Monedas# mon
					   inner join TipoCambioEmpresa a
					      on a.Mcodigo = mon.Mcodigo
						 and a.Periodo = mon.Periodo
						 and a.Mes 	   = mon.Mes
						 and a.Ecodigo = mon.Ecodigo
					WHERE a.Ecodigo = #Arguments.Ecodigo#
					  and a.Periodo = #Periodo#
					  and a.Mes     = #Mes#
				</cfquery>
				<cfloop query="TempUpdMonedas">
					<cfquery datasource="#arguments.conexion#">
						update #Monedas#
							set TC = #TempUpdMonedas.TCEtipocambio#
						where #Monedas#.Mcodigo  = #TempUpdMonedas.Mcodigo#
						  and #Monedas#.Periodo  = #TempUpdMonedas.Periodo#
						  and #Monedas#.Mes 	 = #TempUpdMonedas.Mes#
						   and #Monedas#.Ecodigo = #TempUpdMonedas.Ecodigo#
				     </cfquery>
				</cfloop>
				<!---Actualiza la moneda local de la empresa con tipo de cambio 1 cuando no se encontro tipo de cambio--->
				<cfquery datasource="#arguments.conexion#">
					update #Monedas#
					  set TC = 1
					where Mcodigo = (select Mcodigo from Empresas where Ecodigo = #Session.Ecodigo#)
					and TC = -1
				</cfquery>
				<!---Actualiza el Mnombre de la tabla Temporal monedas--->
				<cfquery datasource="#arguments.conexion#">
					update #Monedas#
						set Mnombre = (select Mnombre from Monedas where Mcodigo = #Monedas#.Mcodigo)
				</cfquery>
				<!---Actualiza el Saldo por el tipo de cambio--->
				<cfquery datasource="#arguments.conexion#">
					update #CCDocumentos#
						set Saldo = Dsaldo * ((select TC
						                        from #Monedas# a
												 where a.Mcodigo = #CCDocumentos#.Mcodigo
								                   and a.Ocodigo = #CCDocumentos#.Ocodigo
								                   and a.Periodo = #CCDocumentos#.Periodo
								                   and a.Mes     = #CCDocumentos#.Mes
								                   and a.Ecodigo = #CCDocumentos#.Ecodigo
											 )- Dtcultrev)
				</cfquery>
 				<cfquery name="rs_C_MonedasTmp2" datasource="#arguments.conexion#">
					update #Monedas# set Total = (
								select sum(Saldo)
								from #CCDocumentos# a
								where a.Mcodigo = #Monedas#.Mcodigo
									and a.Ocodigo = #Monedas#.Ocodigo
							)
				</cfquery>

 				<cfquery name="rs_update_Monedas_MenCero" datasource="#arguments.conexion#">
					Select <cf_dbfunction name="to_number" datasource="#arguments.conexion#" args="a.Pvalor"> as Pvalor, m.Mcodigo
					from Parametros a, #Monedas# m
					where a.Ecodigo = #arguments.Ecodigo#
					  and a.Pcodigo = 120
					  and m.Total < 0.00
					  and a.Mcodigo = 'CC'
				</cfquery>

				<cfquery name="rs_ParamPvalor_1" datasource="#arguments.conexion#">
					Select <cf_dbfunction name="to_number" datasource="#arguments.conexion#" args="Pvalor"> as Pvalor
					from Parametros
					where Ecodigo = #arguments.Ecodigo#
					  and Pcodigo = 110
					  and Mcodigo = 'CC'
				</cfquery>

				<cfquery name="rs_ParamPvalor_2" datasource="#arguments.conexion#">
					Select <cf_dbfunction name="to_number" datasource="#arguments.conexion#" args="Pvalor"> as Pvalor
					from Parametros
					where Ecodigo = #arguments.Ecodigo#
					  and Pcodigo = 120
					  and Mcodigo = 'CC'
				</cfquery>

				<cfif isdefined('rs_ParamPvalor_1') and rs_ParamPvalor_1.recordCount GT 0>
					<cfquery name="rs_UpdateMonedas_1" datasource="#arguments.conexion#">
						update #Monedas#
							set	Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_ParamPvalor_1.Pvalor#">
						where Ecodigo = #arguments.Ecodigo#
							and Total >= 0.00
					</cfquery>
				</cfif>

				<cfif isdefined('rs_ParamPvalor_2') and rs_ParamPvalor_2.recordCount GT 0>
					<cfquery name="rs_UpdateMonedas_2" datasource="#arguments.conexion#">
						update #Monedas#
							set	Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs_ParamPvalor_2.Pvalor#">
						where Ecodigo = #arguments.Ecodigo#
							and Total < 0.00
					</cfquery>
				</cfif>

				<cfif arguments.debug>
					<cfquery datasource="#arguments.conexion#" name="rsMonedasTMP">
						select Mcodigo, Ocodigo, TC, Mnombre, Total, Ccuenta
						from #Monedas#
					</cfquery>
					<cfif isdefined('rsMonedasTMP')>
						<cfdump var="#rsMonedasTMP#" label="Monedas tmp CierreMesCxC">
					</cfif>

					<cfquery datasource="#arguments.conexion#" name="rsCPDocumentosTMP">
						select CCTcodigo, Ddocumento, Ocodigo, SNcodigo, Mcodigo, Ccuenta, Dsaldo, Saldo, Dtcultrev
						from #CCDocumentos#
					</cfquery>
					<cfif isdefined('rsCPDocumentosTMP')>
						<cfdump var="#rsCPDocumentosTMP#" label="CCDocumentos tmp CierreMesCxC">
					</cfif>
				</cfif>

				<cfquery name="rs_C_MonedasTmp4" datasource="#arguments.conexion#">
					select 1
					from #Monedas#
					where TC <= 0.00
				</cfquery>

 				<cfif isdefined('rs_C_MonedasTmp4') and rs_C_MonedasTmp4.recordCount GT 0>
					<cfquery name="rs_C_MonedasDesc" maxrows="1" datasource="#arguments.conexion#">
						select b.Mnombre
						from #Monedas# a, Monedas b
						where a.Mcodigo = b.Mcodigo
						  and a.TC <= 0.00
					</cfquery>

					<cfset nameMoneda = 'Nombre-Moneda'>
					<cfif isdefined('rs_C_MonedasDesc') and rs_C_MonedasDesc.recordCount GT 0 and rs_C_MonedasDesc.Mnombre NEQ ''>
						<cfset nameMoneda = rs_C_MonedasDesc.Mnombre>
					</cfif>
					<cfset msg = "Error! No se ha definido el Tipo de Cambio para la Moneda: " & nameMoneda & " , Período: " & Periodo & ", Mes: " & Mes & ". Proceso Cancelado!.">

					<cfthrow message="#msg#">
				</cfif>

				<cfset FechaHoy = DateFormat(Now(),'yyyymmdd')>

				<cfquery name="rsCuentaIngDifCam" datasource="#session.DSN#">
					select p.Pvalor as CuentaIngDifCam
					from Parametros p
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and Pcodigo = 110
				</cfquery>
				<cfif isdefined("rsCuentaIngDifCam") and rsCuentaIngDifCam.recordcount gt 0>
					<cfset CuentaIngDifCam = rsCuentaIngDifCam.CuentaIngDifCam>
				<cfelse>
					<cf_errorCode	code = "50984" msg = "No se ha definido la cuenta de ingresos de diferencial cambiario.">
				</cfif>

				<cfquery name="rsCuentaGasDifCam" datasource="#session.DSN#">
					select p.Pvalor as CuentaGasDifCam
					from Parametros p
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and Pcodigo = 120
				</cfquery>
				<cfif isdefined("rsCuentaGasDifCam") and rsCuentaGasDifCam.recordcount gt 0>
					<cfset CuentaGasDifCam = rsCuentaGasDifCam.CuentaGasDifCam>
				<cfelse>
					<cf_errorCode	code = "50985" msg = "No se ha definido la cuenta de gasto de diferencial cambiario.">
				</cfif>

				<!--- DIFERENCIAL CAMBIARIO  Cuenta por Cobrar --->
				<cfquery name="rs_A_Intarc" datasource="#arguments.conexion#">
						insert INTO #Intarc# (INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE,CFid)
						 select
						 	  DISTINCT
							  'CCCM',
							  1,
							  doc.CCTcodigo,
							  doc.Ddocumento,
							  abs(round(doc.Dsaldo * (tc.TCEtipocambio - doc.Dtcultrev), 2)),
							  case when round(doc.Dsaldo * (tc.TCEtipocambio - doc.Dtcultrev), 2) >= 0.00 then 'D' else 'C' end	,
							  'Ajuste Diferencial Cambiario Documento: ' #_Cat# rtrim(doc.CCTcodigo) #_Cat# '-' #_Cat# rtrim(doc.Ddocumento),
							  '#FechaHoy#',
							  0.00,
							  #Periodo#,
							  #Mes#,
							  doc.Ccuenta,
							  doc.Mcodigo,
							  doc.Ocodigo,
							  0.00,
                              doc.CFid
						from Documentos doc
						 inner join TipoCambioEmpresa tc
						  on tc.Mcodigo = doc.Mcodigo
						  and tc.Periodo = #Periodo#
						  and tc.Mes     = #Mes#
						 inner join CCTransacciones t
						  on t.CCTcodigo = doc.CCTcodigo
						  and t.Ecodigo = doc.Ecodigo
						  and t.CCTtipo ='D'
						where doc.Ecodigo = #arguments.Ecodigo#
						  and doc.Dsaldo <> 0.00
						  and doc.Mcodigo is not null
						  and round(doc.Dsaldo * (tc.TCEtipocambio - doc.Dtcultrev), 2) <> 0
				</cfquery>
				<cfquery name="rs_A_Intarc" datasource="#arguments.conexion#">
						insert INTO #Intarc# (INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE,CFid)
						 select
						      DISTINCT
							  'CCCM',
							  1,
							  doc.CCTcodigo,
							  doc.Ddocumento,
							  abs(round(doc.Dsaldo * (tc.TCEtipocambio - doc.Dtcultrev), 2)),
							  case when round(doc.Dsaldo * (tc.TCEtipocambio - doc.Dtcultrev), 2) >= 0.00 then 'C' else 'D' end	,
							  'Ajuste Diferencial Cambiario Documento: ' #_Cat# rtrim(doc.CCTcodigo) #_Cat# '-' #_Cat# rtrim(doc.Ddocumento),
							  '#FechaHoy#',
							  0.00,
							  #Periodo#,
							  #Mes#,
							  doc.Ccuenta,
							  doc.Mcodigo,
							  doc.Ocodigo,
							  0.00,
                              doc.CFid
						from Documentos doc
						 inner join TipoCambioEmpresa tc
						  on tc.Mcodigo = doc.Mcodigo
						  and tc.Periodo = #Periodo#
						  and tc.Mes     = #Mes#
						 inner join CCTransacciones t
						  on t.CCTcodigo = doc.CCTcodigo
						  and t.Ecodigo = doc.Ecodigo
						  and t.CCTtipo ='C'
						where doc.Ecodigo = #arguments.Ecodigo#
						  and doc.Dsaldo <> 0.00
						  and doc.Mcodigo is not null
						  and round(doc.Dsaldo * (tc.TCEtipocambio - doc.Dtcultrev), 2) <> 0
				</cfquery>
				<!--- DIFERENCIAL CAMBIARIO  IMPUESTOS --->
				<cfquery name="rs_A_Intarc" datasource="#arguments.conexion#">
					insert INTO #Intarc# (INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE,CFid)
					select DISTINCT
						  'CCCM',
						  1,
						  doc.CCTcodigo,
						  doc.Ddocumento,
						  abs(round((imp.MontoCalculado - imp.MontoPagado) * (tc.TCEtipocambio - doc.Dtcultrev), 2)),
						  case when round((imp.MontoCalculado - imp.MontoPagado) * (tc.TCEtipocambio - doc.Dtcultrev), 2) >= 0.00 then 'C' else 'D' end,
						  'Dif. Cambiario Impuesto Documento : ' #_Cat# rtrim(doc.CCTcodigo) #_Cat# '-' #_Cat# rtrim(doc.Ddocumento),
						  '#FechaHoy#',
						  0.00,
						  #Periodo#,
						  #Mes#,
						  imp.CcuentaImp,
						  doc.Mcodigo,
						  doc.Ocodigo,
						  0.00
                          ,doc.CFid
					from Documentos doc
					 inner join ImpDocumentosCxC imp
					  on  imp.CCTcodigo = doc.CCTcodigo
					  and imp.Documento = doc.Ddocumento
					  and imp.Ecodigo   = doc.Ecodigo
					 inner join TipoCambioEmpresa tc
					  on tc.Mcodigo = doc.Mcodigo
					  and tc.Periodo = #Periodo#
					  and tc.Mes     = #Mes#
					 inner join CCTransacciones t
					  on t.CCTcodigo = doc.CCTcodigo
					  and t.Ecodigo = doc.Ecodigo
					  and t.CCTtipo ='D'
					where doc.Ecodigo = #arguments.Ecodigo#
					  and doc.Dsaldo >= 0.05
					  and doc.Mcodigo is not null
					  and round((imp.MontoCalculado - imp.MontoPagado) * (tc.TCEtipocambio - doc.Dtcultrev), 2) <> 0
				</cfquery>
				<cfquery name="rs_A_Intarc" datasource="#arguments.conexion#">
					insert INTO #Intarc# (INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE,CFid)
					select DISTINCT
						  'CCCM',
						  1,
						  doc.CCTcodigo,
						  doc.Ddocumento,
						  abs(round((imp.MontoCalculado - imp.MontoPagado) * (tc.TCEtipocambio - doc.Dtcultrev), 2)),
						  case when round((imp.MontoCalculado - imp.MontoPagado) * (tc.TCEtipocambio - doc.Dtcultrev), 2) >= 0.00 then 'D' else 'C' end,
						  'Dif. Cambiario Impuesto Documento: ' #_Cat# rtrim(doc.CCTcodigo) #_Cat# '-' #_Cat# rtrim(doc.Ddocumento),
						  '#FechaHoy#',
						  0.00,
						  #Periodo#,
						  #Mes#,
						  imp.CcuentaImp,
						  doc.Mcodigo,
						  doc.Ocodigo,
						  0.00
                          ,doc.CFid
					from Documentos doc
					 inner join ImpDocumentosCxC imp
					  on  imp.CCTcodigo = doc.CCTcodigo
					  and imp.Documento = doc.Ddocumento
					  and imp.Ecodigo   = doc.Ecodigo
					 inner join TipoCambioEmpresa tc
					  on tc.Mcodigo = doc.Mcodigo
					  and tc.Periodo = #Periodo#
					  and tc.Mes     = #Mes#
					 inner join CCTransacciones t
					  on t.CCTcodigo = doc.CCTcodigo
					  and t.Ecodigo = doc.Ecodigo
					  and t.CCTtipo ='C'
					where doc.Ecodigo = #arguments.Ecodigo#
					  and doc.Dsaldo > 0.05
					  and doc.Mcodigo is not null
					  and round((imp.MontoCalculado - imp.MontoPagado) * (tc.TCEtipocambio - doc.Dtcultrev), 2) <> 0
				</cfquery>
				<!--- DIFERENCIAL CAMBIARIO  GASTOS --->
				<cfquery name="rs_A_Intarc" datasource="#arguments.conexion#">
					insert INTO #Intarc# (INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE,CFid)
					 select DISTINCT
						'CCCM',
						1,
						'Cierre:' #_Cat# '#Periodo#' #_Cat# '/' #_Cat# <cfif len(#Mes#) EQ 1>'0'#_Cat#</cfif>'#Mes#',
						'CxC',
						sum(INTMON * case when INTTIP = 'D' then 1 else -1 end),
						'C',
						'Ingreso (Gasto) por Diferencial Cambiario',
						'#FechaHoy#',
						1,
						#Periodo#,
						#Mes#,
						case when sum(INTMON * case when INTTIP = 'D' then 1 else -1 end) > 0 then #CuentaIngDifCam# else #CuentaGasDifCam# end,
						a.Mcodigo,
						a.Ocodigo,
						0.00
                        ,a.CFid
					 from #Intarc# a
					 group by
						a.Mcodigo,
						a.Ocodigo,
                        a.CFid
				</cfquery>

				<cfif arguments.debug>
					<cfquery datasource="#arguments.conexion#" name="rsIntarcTMP">
						select INTLIN, INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE
						from #Intarc#
						order by Mcodigo,INTTIP
					</cfquery>
					<cfif isdefined('rsIntarcTMP')>
						<cfdump var="#rsIntarcTMP#" label="Intarc tmp CierreMesCxC">
					</cfif>
				</cfif>

				<cfquery name="rs_revisa_Intarc" datasource="#arguments.conexion#">
						select count(1) as cantidad
						from #Intarc#
				</cfquery>

				<cfif isdefined('rs_revisa_Intarc') and rs_revisa_Intarc.cantidad GT 1>
					<cfinvoke component="CG_GeneraAsiento" method="GeneraAsiento" >
						<cfinvokeargument name="Ecodigo" value="#arguments.Ecodigo#"/>
						<cfinvokeargument name="Oorigen" value="CCCM"/>
						<cfinvokeargument name="Eperiodo" value="#Periodo#"/>
						<cfinvokeargument name="Emes" value="#Mes#"/>
						<cfinvokeargument name="Efecha" value="#DateAdd('d', -1, DateAdd('m', 1, CreateDate(Periodo, Mes, 1)))#"/>
						<cfinvokeargument name="Edescripcion" value="#descripcion#"/>
						<cfinvokeargument name="Ereferencia" value="CxC: Revaluación"/>
						<cfinvokeargument name="Edocbase" value="Mes #Periodo#-#Mes#"/>
					</cfinvoke>
				</cfif>
				<!--- Actualiza el último tipo de cambio en los documentos --->

                <cfquery datasource="#arguments.conexion#">
                	update Documentos
                    set Dtcultrev =
                      (
                        select min(TC)
                        from #Monedas# a
                        where Documentos.Mcodigo = a.Mcodigo
                         and Documentos.Ocodigo = a.Ocodigo
                        and Documentos.Ecodigo = a.Ecodigo
                        and a.Periodo = #Periodo#
                        and a.Mes = #Mes#
                      )
                    where Documentos.Ecodigo = #arguments.Ecodigo#
                      and Documentos.Dsaldo <> 0.00
                </cfquery>
			</cfif>

			<!--- Saldos Iniciales --->
			<cfset this.SISaldosIniciales(arguments.Ecodigo, periodo, mes,arguments.debug, SIdocumentos, Arguments.conexion) >
		<cfelse>
			<cf_errorCode	code = "50986" msg = "Hubo un error en la creación de las tablas temporales en el cálculo del cierre de mes de CxC. Proceso Cancelado !">
		</cfif>

	</cffunction>

	<cffunction name="CMA_CierreMesCxC_BorrarCeros" access="public" output="no">
		<cfargument name="Ecodigo" default="-1" required="yes">
		<cfargument name="conexion" default="#session.dsn#" required="yes">

		<cftransaction>
			<cftry>
                <!--- 3) Eliminar Plan de Pagos de Documentos sin Saldo --->
                <!---
					FK_DPAGOS_RF_DOCSCX_PLANPAGO
					DPagos FOREIGN KEY (Ecodigo, Doc_CCTcodigo, Ddocumento, PPnumero)
					REFERENCES PlanPagos(Ecodigo, CCTcodigo, Ddocumento, PPnumero)
				--->
                <cfquery datasource="#arguments.conexion#">
                    delete from DPagos
                    where Ecodigo = #arguments.Ecodigo#
                      and (
                            select count(1)
                            from Documentos b
                            where b.Ecodigo    = DPagos.Ecodigo
                              and b.CCTcodigo  = DPagos.Doc_CCTcodigo
                              and b.Ddocumento = DPagos.Ddocumento
                              and b.Dsaldo = 0.00
                              ) > 0
                </cfquery>
            <cfcatch type="any">
                <cf_errorCode	code = "50987"
                				msg  = "Hubo un error en el borrado de los documentos sin saldo ( Borrando DPagos ) en el cálculo del cierre de mes de CxC. Proceso Cancelado !"
                				errorDat_1="#cfcatch.Message#"
                				errorDat_2="#cfcatch.Detail#"
                >
            </cfcatch>
            </cftry>

			<cftry>
                <cfquery datasource="#arguments.conexion#">
                     delete from PlanPagos
                     where PlanPagos.Ecodigo = #arguments.Ecodigo#
                     and (
                         select count(1)
                         from Documentos a
                         where a.Ecodigo    = PlanPagos.Ecodigo
                           and a.CCTcodigo  = PlanPagos.CCTcodigo
                           and a.Ddocumento = PlanPagos.Ddocumento
                           and a.Dsaldo     = 0.00
                         ) > 0
                </cfquery>

            <cfcatch type="any">
                <cf_errorCode	code = "50988"
                				msg  = "Hubo un error en el borrado de los documentos sin saldo en el cálculo del cierre de mes de CxC. Proceso Cancelado !"
                				errorDat_1="#cfcatch.Message#"
                				errorDat_2="#cfcatch.Detail#"
                >
            </cfcatch>
            </cftry>
            <cftry>
                <!--- 3) Eliminar Detalles de Documentos sin Saldo --->
                <cfquery name="rs_B_Doc" datasource="#arguments.conexion#">
                     delete from DDocumentos
                     where DDocumentos.Ecodigo = #arguments.Ecodigo#
                     and (
                         select count(1)
                         from Documentos a
                         where a.Ecodigo    = DDocumentos.Ecodigo
                           and a.CCTcodigo  = DDocumentos.CCTcodigo
                           and a.Ddocumento = DDocumentos.Ddocumento
                           and a.Dsaldo     = 0.00
                         ) > 0
                </cfquery>
            <cfcatch type="any">
                <cf_errorCode	code = "50988"
                				msg  = "Hubo un error en el borrado de los documentos sin saldo en el cálculo del cierre de mes de CxC. Proceso Cancelado !"
                				errorDat_1="#cfcatch.Message#"
                				errorDat_2="#cfcatch.Detail#"
                >
            </cfcatch>
            </cftry>
            <cftry>
                <!--- Eliminar Documentos --->
                <cfquery name="rs_C_Doc2" datasource="#arguments.conexion#">
                    delete from Documentos
                    where Ecodigo = #arguments.Ecodigo#
                      and Dsaldo = 0.00
                </cfquery>
            <cfcatch type="any">
                <cf_errorCode	code = "50989"
                				msg  = "Hubo un error en el borrado de los documentos en el cálculo del cierre de mes de CxC. Proceso Cancelado!"
                				errorDat_1="#cfcatch.Message#"
                				errorDat_2="#cfcatch.Detail#"
                >
            </cfcatch>
            </cftry>
        </cftransaction>
	</cffunction>
</cfcomponent>


