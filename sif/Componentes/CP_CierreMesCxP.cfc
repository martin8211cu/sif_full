<!---
	Cierre de Mes de Cuentas x Pagar

	Esta es la nomenclatura para los nombres de las tablas temporales que se van a crear
	en el procedimiento de cierre de auxiliares;
		- Para CP_CierreMesCxP
			* Monedas = CierreMes_M
			* Documentos = CierreMes_D
		- Para CP_CierreMesCxP
			* Monedas = CierreMes_M2
			* Documentos = CierreMes_D2
		- Para MB_CierreMesBancos
			* SaldosBancarios = CierreMesB_SB
--->
<cfcomponent output="no">
	<cffunction name="SISaldosIniciales" access="public" output="no">
		<cfargument name='Ecodigo'        type='numeric' required='true' >
		<cfargument name='PeriodoCerrado' type='numeric' required='true'>
		<cfargument name='MesCerrado'     type='numeric' required='true'>
		<cfargument name='debug'          type="boolean" required='false' default='false'>
		<cfargument name='SIdocumentos'   type="string"  required="yes">
		<cfargument name='conexion'       type='string'  required='false' default="#Session.DSN#">
		<cfargument name='docsCE' 		  type="boolean" required='false' default="false">

		<cfset SIdocumentos = Arguments.SIdocumentos>
		<cfset LvarNuevoPeriodo = Arguments.PeriodoCerrado>
		<cfset LvarNuevoMes     = Arguments.MesCerrado>

		<cfset LvarNuevoMes = LvarNuevoMes + 1>

		<cfif LvarNuevoMes eq 13>
			<cfset LvarNuevoPeriodo = LvarNuevoPeriodo + 1>
			<cfset LvarNuevoMes     = 1>
		</cfif>

		<cfset fechaini = CreateDate(LvarNuevoPeriodo,LvarNuevoMes,1)>

		<!--- Parametros para los periodos de vencimiento --->
		<cfquery name="rsParametros1" datasource="#session.DSN#">
			select Pvalor as p1
			from Parametros
			where Ecodigo =  #session.Ecodigo#
				and Pcodigo = 310
		</cfquery>
		<cfif isdefined("rsParametros1") and rsParametros1.recordcount gt 0>
			<cfset p1 = rsParametros1.p1>
		<cfelse>
			<cf_errorCode	code = "50178" msg = "Debe definir el primer período en los parámetros.">
		</cfif>

		<cfquery name="rsParametros2" datasource="#session.DSN#">
			select Pvalor as p2
			from Parametros
			where Ecodigo =  #session.Ecodigo#
				and Pcodigo = 320
		</cfquery>

		<cfif isdefined("rsParametros2") and rsParametros2.recordcount gt 0>
			<cfset p2 = rsParametros2.p2>
		<cfelse>
			<cf_errorCode	code = "50179" msg = "Debe definir el segundo período en los parámetros.">
		</cfif>

		<cfquery name="rsParametros3" datasource="#session.DSN#">
			select Pvalor as p3
			from Parametros
			where Ecodigo =  #session.Ecodigo#
				and Pcodigo = 330
		</cfquery>
		<cfif isdefined("rsParametros3") and rsParametros3.recordcount gt 0>
			<cfset p3 = rsParametros3.p3>
		<cfelse>
			<cf_errorCode	code = "50180" msg = "Debe definir el tercer período en los parámetros.">
		</cfif>
		<cfquery name="rsParametros4" datasource="#session.DSN#">
			select Pvalor as p4
			from Parametros
			where Ecodigo =  #session.Ecodigo#
				and Pcodigo = 340
		</cfquery>
		<cfif isdefined("rsParametros4") and rsParametros4.recordcount gt 0>
			<cfset p4 = rsParametros4.p4>
		<cfelse>
			<cf_errorCode	code = "50181" msg = "Debe definir el cuarto período en los parámetros.">
		</cfif>
		<cfif arguments.docsCE EQ 0>
			<cfquery datasource="#arguments.conexion#" name="x">
				insert into  SNSaldosInicialesCP (Ecodigo, Mcodigo, SNid, id_direccion, Speriodo, Smes, SIsaldoinicial, SIsinvencer, 	SIcorriente, SIp1, SIp2, SIp3, SIp4, SIp5, SIp5p, BMfechaalta, BMUsucodigo)
				select distinct do.Ecodigo, do.Mcodigo, s.SNid,
				coalesce(do.id_direccion, s.id_direccion),
				#LvarNuevoPeriodo#, #LvarNuevoMes#, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, 0.00, <cf_dbfunction name="now">, #Session.Usucodigo#
				from EDocumentosCP do
					inner join SNegocios s
						 on s.Ecodigo  = do.Ecodigo
						and s.SNcodigo = do.SNcodigo
					inner join SNDirecciones ds
						on ds.SNid = s.SNid
						and ds.id_direccion = s.id_direccion
					inner join Monedas m
						on m.Ecodigo = #arguments.Ecodigo#
						and m.Mcodigo = do.Mcodigo
				where do.Ecodigo = #arguments.Ecodigo#
			</cfquery>
		</cfif>
		<!--- Actualizar los saldos iniciales de los clientes
			  Saldo a la fecha de hoy de cada uno de los documentos vigentes, los otros estaban con saldo cero al cierre
		--->
		<cfquery name="rs2" datasource="#arguments.conexion#">
			insert into  #SIdocumentos# ( Ecodigo,
									Mcodigo,
									SNcodigo,
									SNid,
									CPTcodigo,
									Ddocumento,
									id_direccion,
									fecha,
									saldo,
									fechavencimiento )
			select  d.Ecodigo,
					d.Mcodigo,
					d.SNcodigo,
					s.SNid,
					d.CPTcodigo,
					d.Ddocumento,
					coalesce(d.id_direccion, s.id_direccion),
					d.Dfecha,
					d.EDsaldo,
					d.Dfechavenc
			from EDocumentosCP d
				inner join SNegocios s
					on s.Ecodigo = d.Ecodigo
					and s.SNcodigo = d.SNcodigo
			where d.Ecodigo = #arguments.Ecodigo#
			  and d.Dfecha < <cfqueryparam cfsqltype="cf_sql_date" value="#fechaini#">
			  <cfif arguments.docsCE EQ 1>
				  and d.CPTcodigo in('FE','NH')
			<cfelse>
				   and d.CPTcodigo not in('FE','NH')
			</cfif>
		</cfquery>

		<!--- sumar al saldo de los documentos los movimientos posteriores al cierre. Documentos que no son tipo Recibos de Caja --->
		<cfquery name="rs2" datasource="#arguments.conexion#">
			update #SIdocumentos#
			set saldo = saldo +
					coalesce((
						select sum(m.BMmontoref)
						from BMovimientosCxP m
						where m.Ddocumento =  #SIdocumentos#.Ddocumento
						  and m.CPTRcodigo  =  #SIdocumentos#.CPTcodigo
						  and m.SNcodigo   =  #SIdocumentos#.SNcodigo
						  and m.Dfecha     >= <cfqueryparam cfsqltype="cf_sql_date" value="#fechaini#">
						  and (m.CPTRcodigo  <> #SIdocumentos#.CPTcodigo or m.DRdocumento <> #SIdocumentos#.Ddocumento)
						  and m.Dfecha     >= #SIdocumentos#.fecha
					) , 0.00)
		</cfquery>

		<!--- Actualizar la tabla #SIdocumentos# con saldo negativo cuando la transaccion es negativa (credito) --->
		<cfquery name="rsForm" datasource="#arguments.conexion#">
			select Ecodigo, CPTcodigo
			from CPTransacciones
			where Ecodigo   = #arguments.Ecodigo#
			  and CPTtipo   = 'D'
		</cfquery>
		<cfloop query="rsForm">
			<cfquery datasource="#arguments.conexion#">
				update #SIdocumentos#
				set saldo = saldo * -1
				where Ecodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.Ecodigo#">
				  and CPTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsForm.CPTcodigo#">
			</cfquery>
		</cfloop>

		<!--- De aquí en adelante se utiliza datediff --->
		<!--- Asegurarse de que la informacion sobre las conexiones este disponible --->
		<cfinvoke component="home.Componentes.DbUtils" method="generate_dsinfo"
			refresh="no"
			datasource="#arguments.conexion#" />

		<cfif not StructKeyExists(Application.dsinfo, arguments.conexion)>
			<cf_errorCode	code = "50599"
							msg  = "Datasource no definido: @errorDat_1@"
							errorDat_1="#HTMLEditFormat(arguments.conexion)#"
			>
		</cfif>

		<!--- Actualizar el saldo de la tabla #SIdocumentos# --->
		<cfquery datasource="#arguments.conexion#">
			update SNSaldosInicialesCP
			set
				SIsaldoinicial =
					coalesce((
						select sum(d.saldo)
						from #SIdocumentos# d
						where d.SNid         = SNSaldosInicialesCP.SNid
						  and d.id_direccion = SNSaldosInicialesCP.id_direccion
						  and d.Mcodigo      = SNSaldosInicialesCP.Mcodigo
					), 0.00)
			where Speriodo = #LvarNuevoPeriodo#
			  and Smes     = #LvarNuevoMes#
			  and Ecodigo  = #arguments.Ecodigo#
		</cfquery>

		<cfquery datasource="#arguments.conexion#">
			update SNSaldosInicialesCP
			set
				SIcorriente =
					coalesce((
						select sum(d.saldo)
						from #SIdocumentos# d
						where d.SNid = SNSaldosInicialesCP.SNid
						  and d.id_direccion = SNSaldosInicialesCP.id_direccion
						  and d.Mcodigo = SNSaldosInicialesCP.Mcodigo
						  and d.fechavencimiento >= <cfqueryparam cfsqltype="cf_sql_date" value="#fechaini#">
						  and <cf_dbfunction name="date_part"  args="mm,d.fecha"> = #MesCerrado#
						  and <cf_dbfunction name="date_part"  args="yy,d.fecha"> = #PeriodoCerrado#
					), 0.00)
			where Speriodo = #LvarNuevoPeriodo#
			  and Smes     = #LvarNuevoMes#
			  and Ecodigo  = #arguments.Ecodigo#
		</cfquery>


		<cfquery datasource="#arguments.conexion#">
			update SNSaldosInicialesCP
			set
				SIsinvencer =
					coalesce((
						select sum(d.saldo)
						from #SIdocumentos# d
						where d.SNid            = SNSaldosInicialesCP.SNid
						  and d.id_direccion    = SNSaldosInicialesCP.id_direccion
						  and d.Mcodigo      	= SNSaldosInicialesCP.Mcodigo
						  and d.fechavencimiento >= <cfqueryparam cfsqltype="cf_sql_date" value="#fechaini#">
						  and (<cf_dbfunction name="date_part"  args="mm,d.fecha"> <> #MesCerrado#
						   or <cf_dbfunction name="date_part"  args="yy,d.fecha"> <> #PeriodoCerrado#)
					), 0.00)
			where Speriodo = #LvarNuevoPeriodo#
			  and Smes     = #LvarNuevoMes#
			  and Ecodigo  = #arguments.Ecodigo#
		</cfquery>


		<cfquery datasource="#arguments.conexion#">
			update SNSaldosInicialesCP
			set
				SIp1 =
					coalesce((
						select sum(d.saldo)
						from #SIdocumentos# d
						where d.SNid             = SNSaldosInicialesCP.SNid
						  and d.id_direccion     = SNSaldosInicialesCP.id_direccion
						  and d.Mcodigo      	 = SNSaldosInicialesCP.Mcodigo
						  and d.fechavencimiento < <cfqueryparam cfsqltype="cf_sql_date" value="#fechaini#">
						  and <cf_dbfunction name="datediff" args="d.fechavencimiento; #fechaini#;DD" delimiters=";"> between 1 and #p1+1#
					), 0.00)
			where Speriodo = #LvarNuevoPeriodo#
			  and Smes     = #LvarNuevoMes#
			  and Ecodigo = #arguments.Ecodigo#
		</cfquery>

		<cfquery datasource="#arguments.conexion#">
			update SNSaldosInicialesCP
			set
				SIp2 =
					coalesce((
						select sum(d.saldo)
						from #SIdocumentos# d
						where d.SNid = SNSaldosInicialesCP.SNid
						  and d.id_direccion = SNSaldosInicialesCP.id_direccion
						  and d.Mcodigo = SNSaldosInicialesCP.Mcodigo
						  and d.fechavencimiento < <cfqueryparam cfsqltype="cf_sql_date" value="#fechaini#">
						  and <cf_dbfunction name="datediff" args="d.fechavencimiento; #fechaini#; DD" delimiters=";"> between #p1+2# and #p2+1#
					), 0.00)
			where Speriodo = #LvarNuevoPeriodo#
			  and Smes     = #LvarNuevoMes#
			  and Ecodigo = #arguments.Ecodigo#
		</cfquery>

		<cfquery datasource="#arguments.conexion#">
			update SNSaldosInicialesCP
			set
				SIp3 =
					coalesce((
						select sum(d.saldo)
						from #SIdocumentos# d
						where d.SNid             = SNSaldosInicialesCP.SNid
						  and d.id_direccion     = SNSaldosInicialesCP.id_direccion
						  and d.Mcodigo      	= SNSaldosInicialesCP.Mcodigo
						  and d.fechavencimiento < <cfqueryparam cfsqltype="cf_sql_date" value="#fechaini#">
						  and <cf_dbfunction name="datediff" args="d.fechavencimiento; #fechaini#; DD" delimiters=";"> between #p2+2# and #p3+1#
					), 0.00)
			where Speriodo = #LvarNuevoPeriodo#
			  and Smes     = #LvarNuevoMes#
			  and Ecodigo = #arguments.Ecodigo#
		</cfquery>

		<cfquery datasource="#arguments.conexion#">
			update SNSaldosInicialesCP
			set
				SIp4 =
					coalesce((
						select sum(d.saldo)
						from #SIdocumentos# d
						where d.SNid             = SNSaldosInicialesCP.SNid
						  and d.id_direccion     = SNSaldosInicialesCP.id_direccion
						  and d.Mcodigo      	= SNSaldosInicialesCP.Mcodigo
						  and d.fechavencimiento < <cfqueryparam cfsqltype="cf_sql_date" value="#fechaini#">
						  and <cf_dbfunction name="datediff" args="d.fechavencimiento; #fechaini#; DD" delimiters=";"> between #p3+2# and #p4+1#
					), 0.00)
			where Speriodo = #LvarNuevoPeriodo#
			  and Smes     = #LvarNuevoMes#
			  and Ecodigo  = #arguments.Ecodigo#
		</cfquery>

		<cfquery datasource="#arguments.conexion#">
			update SNSaldosInicialesCP
			set
				SIp5 =
					coalesce((
						select sum(d.saldo)
						from #SIdocumentos# d
						where d.SNid             = SNSaldosInicialesCP.SNid
						  and d.id_direccion     = SNSaldosInicialesCP.id_direccion
						  and d.Mcodigo      	= SNSaldosInicialesCP.Mcodigo
						  and d.fechavencimiento < <cfqueryparam cfsqltype="cf_sql_date" value="#fechaini#">
						  and <cf_dbfunction name="datediff" args="d.fechavencimiento; #fechaini#; DD" delimiters=";"> between #p4+2# and 151
					), 0.00)
			where Speriodo = #LvarNuevoPeriodo#
			  and Smes     = #LvarNuevoMes#
			  and Ecodigo  = #arguments.Ecodigo#
		</cfquery>

		<cfquery datasource="#arguments.conexion#">
			update SNSaldosInicialesCP
			set
				SIp5p =
					coalesce((
						select sum(d.saldo)
						from #SIdocumentos# d
						where d.SNid             = SNSaldosInicialesCP.SNid
						  and d.id_direccion     = SNSaldosInicialesCP.id_direccion
						  and d.Mcodigo      	= SNSaldosInicialesCP.Mcodigo
						  and d.fechavencimiento < <cfqueryparam cfsqltype="cf_sql_date" value="#fechaini#">
						  and <cf_dbfunction name="datediff" args="d.fechavencimiento; #fechaini#; DD" delimiters=";"> > 151
					), 0.00)
			where Speriodo = #LvarNuevoPeriodo#
			  and Smes     = #LvarNuevoMes#
			  and Ecodigo  = #arguments.Ecodigo#
		</cfquery>

		<!--- Borrar los registros que tienen todas las columnas en cero --->
		<cfquery datasource="#arguments.conexion#">
			delete from SNSaldosInicialesCP
			where Speriodo = #LvarNuevoPeriodo#
			  and Smes     = #LvarNuevoMes#
			  and Ecodigo  = #arguments.Ecodigo#
			  and (
			      SIsaldoinicial = 0
			  and SIsinvencer = 0
			  and SIcorriente = 0
			  and SIp1 = 0
			  and SIp2 = 0
			  and SIp3 = 0
			  and SIp4 = 0
			  and SIp5 = 0
			  and SIp5p = 0
			  )
		</cfquery>

		<!--- Insertar los documentos que están con saldo a inicio de mes.  Histórico de Documentos al cierre de mes --->
		<cfquery datasource="#arguments.conexion#">
			insert into SNSaldosInicialesCPD (
				Ecodigo, Speriodo, Smes, SNid, HDid, SNcodigo,
				CPTcodigo, Ddocumento, id_direccion, Mcodigo,
				Dsaldo, Dantiguedad )
			select
				d.Ecodigo, #LvarNuevoPeriodo#, #LvarNuevoMes#, d.SNid, -1, d.SNcodigo,
				d.CPTcodigo, d.Ddocumento, d.id_direccion, d.Mcodigo,
				d.saldo, <cf_dbfunction name="datediff" args="d.fechavencimiento, #fechaini#">
			from #SIdocumentos# d
			where d.saldo <> 0
		</cfquery>

		<cfif arguments.debug>
			<cfquery datasource="#arguments.conexion#" name="rsSaldosIniciales">
				select *
				from SNSaldosInicialesCP
				where Ecodigo  =  #arguments.Ecodigo#
				  and Speriodo =  #LvarNuevoPeriodo#
			  	  and Smes     =  #LvarNuevoMes#
			</cfquery>
			<cfif isdefined('rsSaldosIniciales')>
				<cf_dump var="#rsSaldosIniciales#" label="Saldos Iniciales de Cuentas por Cobrar">
			</cfif>
		</cfif>
	</cffunction>

	<!--- Cierre de Mes de Cuentas x Pagar para la Comercializadora del Estado--->
	<cffunction name='CierreMesCxPCE' access='public' output='no'>
		<cfargument name='Ecodigo' type='numeric' required='true'>
		<cfargument name='debug' type="boolean" required='false' default='false'>
		<cfargument name='conexion' type='string' required='false' default="#Session.DSN#">
		<cfargument name='Monedas' type="string" required="yes">
		<cfargument name='CPDocumentos' type="string" required="yes">
		<cfargument name='SIdocumentos' type="string" required="yes">
		<cfargument name='Intarc' type="string" required="yes">
		<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
		<cfset Monedas = Arguments.Monedas>
		<cfset CPDocumentos= Arguments.CPDocumentos>
		<cfset SIdocumentos= Arguments.SIdocumentos>
		<cfset Intarc= Arguments.Intarc>
		<!--- Creacion de las tablas temporales --->
		<cfquery datasource="#arguments.conexion#">
			delete from #Monedas#
		</cfquery>
		<cfquery datasource="#arguments.conexion#">
			delete from #CPDocumentos#
		</cfquery>
		<cfquery datasource="#arguments.conexion#">
			delete from #SIdocumentos#
		</cfquery>
		<cfquery datasource="#arguments.conexion#">
			delete from #Intarc#
		</cfquery>
		<!--- Parámetros Generales --->
		<cfset lin = 1>
		<cfset Periodo = -1>
		<cfset Mes = -1>
		<cfset Fecha = Now()>
		<cfset descripcion = 'CxP CE: Diferencial Cambiario Mensual'>
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
		<cfif isdefined('rs_Monloc') and rs_Monloc.recordCount GT 0 and rs_Monloc.Mcodigo NEQ ''>
			<cfset Monloc = rs_Monloc.Mcodigo>
		</cfif>
		<cfquery name="rs_Periodo" datasource="#arguments.conexion#">
			select Pvalor as Pvalor
			from Parametros
			where Ecodigo = #arguments.Ecodigo#
			  and Mcodigo = 'GN'
			  and Pcodigo = 50
		</cfquery>
		<cfif isdefined('rs_Periodo') and rs_Periodo.recordCount GT 0 and rs_Periodo.Pvalor NEQ ''>
			<cfset Periodo = rs_Periodo.Pvalor>
		</cfif>
		<cfquery name="rs_Mes" datasource="#arguments.conexion#">
			Select Pvalor as Pvalor
			from Parametros
			where Ecodigo = #arguments.Ecodigo#
			  and Mcodigo = 'GN'
			  and Pcodigo = 60
		</cfquery>
		<cfif isdefined('rs_Mes') and rs_Mes.recordCount GT 0 and rs_Mes.Pvalor NEQ ''>
			<cfset Mes = rs_Mes.Pvalor>
		</cfif>
		<!---  1) Validaciones Generales --->
		<cfif Periodo EQ -1 and Mes EQ -1>
			<cf_errorCode	code = "51088" msg = "No se ha definido el parámetro de Período o Mes para los sistemas Auxiliares! Proceso Cancelado !">
		</cfif>

 		<!---   2) Asiento Contable x Diferencial Cambiario Mensual --->
		<cfquery name="rs_EDocumentosCP" datasource="#arguments.conexion#">
			select 1
			from EDocumentosCP
			where Ecodigo = #arguments.Ecodigo#
				and CPTcodigo in('FE','NH')
				and EDsaldo <> 0.00
				and Mcodigo <> #Monloc#
		</cfquery>
		<cfif isdefined('rs_EDocumentosCP') and rs_EDocumentosCP.recordCount GT 0>
			<cfquery name="rs_EDocumentosCP" datasource="#arguments.conexion#">
				insert INTO #CPDocumentos# ( IDdocumento, Ecodigo, Mes, Periodo, CPTcodigo, Ddocumento, Ocodigo, SNcodigo, Mcodigo, Ccuenta,
				EDsaldo, Saldo, EDtcultrev)
				select IDdocumento, #arguments.Ecodigo#, #Mes#, #Periodo#, CPTcodigo, Ddocumento, Ocodigo, SNcodigo, Mcodigo, Ccuenta, EDsaldo,
				0.00, EDtcultrev
				from EDocumentosCP
				where Ecodigo = #arguments.Ecodigo#
				and CPTcodigo  in('FE','NH')
				and Mcodigo <> #Monloc#
				and EDsaldo <> 0.00
			</cfquery>

 			<cfquery name="rs_Monedas" datasource="#arguments.conexion#">
				insert INTO #Monedas#(Mcodigo, Ocodigo, TC, Total, Ecodigo, Mes, Periodo)
				select distinct Mcodigo, Ocodigo, -1, 0.00, #arguments.Ecodigo#, #Mes#, #Periodo#
				from #CPDocumentos#
			</cfquery>
			<cfoutput>
				<cf_dbupdate table="#Monedas#" datasource="#arguments.conexion#">
					<cf_dbupdate_join table="TipoCambioEmpresa a">
						on a.Mcodigo = #Monedas#.Mcodigo
							and a.Periodo = #Monedas#.Periodo
							and a.Mes = #Monedas#.Mes
							and a.Ecodigo = #Monedas#.Ecodigo
					</cf_dbupdate_join>

					<cf_dbupdate_set name='TC' expr="coalesce(TCEtipocambioventa, TCEtipocambio, 0)" />

					<cf_dbupdate_where>
						WHERE #Monedas#.Ecodigo =   <cf_dbupdate_param type="integer" value="#arguments.Ecodigo#">
							and #Monedas#.Periodo = <cf_dbupdate_param type="integer" value="#Periodo#">
							and #Monedas#.Mes = <cf_dbupdate_param type="integer" value="#Mes#">
					</cf_dbupdate_where>
				</cf_dbupdate>
			</cfoutput>

 			<cfoutput>
				<cf_dbupdate table="#Monedas#" datasource="#arguments.conexion#">
					<cf_dbupdate_join table="Monedas a">
						on #Monedas#.Mcodigo = a.Mcodigo
					</cf_dbupdate_join>
					<cf_dbupdate_set name='#Monedas#.Mnombre' expr="a.Mnombre" />
				</cf_dbupdate>
			</cfoutput>

 			<cfoutput>
				<cf_dbupdate table="#CPDocumentos#" datasource="#arguments.conexion#">
					<cf_dbupdate_join table="#Monedas# a">
						on a.Mcodigo = #CPDocumentos#.Mcodigo
							and a.Ocodigo = #CPDocumentos#.Ocodigo
					</cf_dbupdate_join>

					<cf_dbupdate_set name='Saldo' expr="#CPDocumentos#.EDsaldo * (a.TC - #CPDocumentos#.EDtcultrev)" />
				</cf_dbupdate>
			</cfoutput>

			<cfquery name="rs_update_Monedas_3" datasource="#arguments.conexion#">
				update #Monedas# set Total = (	select sum(Saldo)
												from #CPDocumentos# a
												where a.Mcodigo = #Monedas#.Mcodigo
													and a.Ocodigo = #Monedas#.Ocodigo
											  )
			</cfquery>
			<!--- Cuenta de Egreso por dif. Cambiario  CxP --->
			<cfquery   name="rs_ParamPvalor_1" datasource="#arguments.conexion#">
				select OtraCtaEgresoDifCamCxP  as Pvalor
				from CPTransacciones
				where Ecodigo = #arguments.Ecodigo#
				and CPTcodigo = 'FE'
			</cfquery>
			<!--- Cuenta de Ingreso por dif. Cambiario  CxP --->
			<cfquery   name="rs_ParamPvalor_2" datasource="#arguments.conexion#">
				select OtraCtaIngresoDifCamCxP  as Pvalor
				from CPTransacciones
				where Ecodigo = #arguments.Ecodigo#
				and CPTcodigo = 'FE'
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
					<cfdump var="#rsMonedasTMP#" label="Monedas tmp CierreMesCxP">
				</cfif>


				<cfquery datasource="#arguments.conexion#" name="rsCPDocumentosTMP">
					select IDdocumento, CPTcodigo, Ddocumento, Ocodigo, SNcodigo, Mcodigo, Ccuenta, EDsaldo, Saldo, EDtcultrev
					from #CPDocumentos#
				</cfquery>
				<cfif isdefined('rsCPDocumentosTMP')>
					<cfdump var="#rsCPDocumentosTMP#" label="Monedas tmp CierreMesCxP">
				</cfif>
			</cfif>
			<cfquery name="rs_MonedasTemp" datasource="#arguments.conexion#">
				select 1
				from #Monedas#
				where TC <= 0.00
			</cfquery>

			<cfif isdefined('rs_MonedasTemp') and rs_MonedasTemp.recordCount GT 0>
				<cfquery name="rs_desMonedas" datasource="#arguments.conexion#" maxrows="1">
					select b.Mnombre
					from #Monedas# a, Monedas b
					where a.Mcodigo = b.Mcodigo
					  and a.TC <= 0.00
				</cfquery>

				<cfset DescMoneda = "">
				<cfif isdefined('rs_desMonedas') and rs_desMonedas.recordCount GT 0>
					<cfset DescMoneda = rs_desMonedas.Mnombre>
				</cfif>
				<cfset msg = "Error! No se ha definido el Tipo de Cambio para la Moneda: " & DescMoneda & " , Período: " & Periodo & ", Mes: " & Mes & ". Proceso Cancelado!.">

				<cfthrow message="#msg#">
			</cfif>

			<cfset FechaHoy = DateFormat(Now(),'yyyymmdd')>

			<cfquery name="rsCuentaIngDifCam" datasource="#session.DSN#">
				select OtraCtaIngresoDifCamCxP  as CuentaIngDifCam
				from CPTransacciones
				where Ecodigo = #arguments.Ecodigo#
				and CPTcodigo = 'FE'
			</cfquery>
			<cfif isdefined("rsCuentaIngDifCam") and rsCuentaIngDifCam.recordcount gt 0>
				<cfset CuentaIngDifCam = rsCuentaIngDifCam.CuentaIngDifCam>
			<cfelse>
				<cf_errorCode	code = "50984" msg = "No se ha definido la cuenta de ingresos de diferencial cambiario para la Comercializadora del Estado .">
			</cfif>

			<cfquery name="rsCuentaGasDifCam" datasource="#session.DSN#">
				select OtraCtaEgresoDifCamCxP  as CuentaGasDifCam
				from CPTransacciones
				where Ecodigo = #arguments.Ecodigo#
				and CPTcodigo = 'FE'
			</cfquery>
			<cfif isdefined("rsCuentaGasDifCam") and rsCuentaGasDifCam.recordcount gt 0>
				<cfset CuentaGasDifCam = rsCuentaGasDifCam.CuentaGasDifCam>
			<cfelse>
				<cf_errorCode	code = "50985" msg = "No se ha definido la cuenta de gasto de diferencial cambiario para la Comercializadora del Estado.">
			</cfif>

			<!--- DIFERENCIAL CAMBIARIO  Cuenta por PAGAR --->
			<cfquery name="rs_A_Intarc" datasource="#arguments.conexion#">
				insert INTO #Intarc# (INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE)
				 select
					  'CPCC',
					  1,
					  doc.CPTcodigo,
					  doc.Ddocumento,
					  abs(round(doc.EDsaldo * (tc.TC - doc.EDtcultrev), 2)),
					  case when round(doc.EDsaldo * (tc.TC - doc.EDtcultrev), 2) >= 0.00 then 'D' else 'C' end	,
					  'Ajuste Diferencial Cambiario Documento CE: ' #_Cat# rtrim(doc.CPTcodigo) #_Cat# '-' #_Cat# rtrim(doc.Ddocumento),
					  '#FechaHoy#',
					  0.00,
					  #Periodo#,
					  #Mes#,
					  doc.Ccuenta,
					  doc.Mcodigo,
					  doc.Ocodigo,
					  0.00
				from EDocumentosCP doc
				 inner join #monedas# tc
				  on tc.Mcodigo = doc.Mcodigo
				  AND tc.Mcodigo = doc.Ocodigo
				  and tc.Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">
				  and tc.Mes     = <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">
				 inner join CPTransacciones t
				  on t.CPTcodigo = doc.CPTcodigo
				  and t.Ecodigo = doc.Ecodigo
				  and t.CPTtipo ='D'
				where doc.Ecodigo =  #arguments.Ecodigo#
				  and doc.EDsaldo <> 0.00
				  and doc.Mcodigo <> #Monloc#
				  and round(doc.EDsaldo * (tc.TC - doc.EDtcultrev), 2) <> 0
				  and doc.CPTcodigo in ('FE','NH')
			</cfquery>
			<cfquery name="rs_A_Intarc" datasource="#arguments.conexion#">
				insert INTO #Intarc# (INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE)
				 select
					  'CPCC',
					  1,
					  doc.CPTcodigo,
					  doc.Ddocumento,
					  abs(round(doc.EDsaldo * (tc.TC - doc.EDtcultrev), 2)),
					  case when round(doc.EDsaldo * (tc.TC - doc.EDtcultrev), 2) >= 0.00 then 'C' else 'D' end	,
					  'Ajuste Diferencial Cambiario Documento CE: ' #_Cat# rtrim(doc.CPTcodigo) #_Cat# '-' #_Cat# rtrim(doc.Ddocumento),
					  '#FechaHoy#',
					  0.00,
					  #Periodo#,
					  #Mes#,
					  doc.Ccuenta,
					  doc.Mcodigo,
					  doc.Ocodigo,
					  0.00
				from EDocumentosCP doc
				 inner join #monedas# tc
				  on tc.Mcodigo = doc.Mcodigo
				  AND tc.Mcodigo = doc.Ocodigo
				  and tc.Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">
				  and tc.Mes     = <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">
				 inner join CPTransacciones t
				  on t.CPTcodigo = doc.CPTcodigo
				  and t.Ecodigo = doc.Ecodigo
				  and t.CPTtipo ='C'
				where doc.Ecodigo =  #arguments.Ecodigo#
				  and doc.EDsaldo <> 0.00
				  and doc.Mcodigo <> #Monloc#
				  and round(doc.EDsaldo * (tc.TC - doc.EDtcultrev), 2) <> 0
				  and doc.CPTcodigo in ('FE','NH')
			</cfquery>
			<!--- DIFERENCIAL CAMBIARIO  IMPUESTOS --->
				<cfquery name="rs_A_Intarc" datasource="#arguments.conexion#">
					insert INTO #Intarc# (INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE)
					select
						  'CPCC',
						  1,
						  doc.CPTcodigo,
						  doc.Ddocumento,
						  abs(round((imp.MontoCalculado - imp.MontoPagado) * (tc.TC - doc.EDtcultrev), 2)),
						  case when round((imp.MontoCalculado - imp.MontoPagado) * (tc.TC - doc.EDtcultrev), 2) >= 0.00 then 'C' else 'D' end,
						  'Diferencial Cambiario Impuesto Documento CE: ' #_Cat# rtrim(doc.CPTcodigo) #_Cat# '-' #_Cat# rtrim(doc.Ddocumento),
						  '#FechaHoy#',
						  0.00,
						  #Periodo#,
						  #Mes#,
						  imp.CcuentaImp,
						  doc.Mcodigo,
						  doc.Ocodigo,
						  0.00
					from EDocumentosCP doc
					 inner join ImpDocumentosCxP imp
					  on  imp.IDdocumento = doc.IDdocumento
					  and imp.Ecodigo   = doc.Ecodigo
					 inner join #monedas# tc
					  on tc.Mcodigo = doc.Mcodigo
					  and tc.Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">
					  and tc.Mes     = <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">
					 inner join CPTransacciones t
					  on t.CPTcodigo = doc.CPTcodigo
					  and t.Ecodigo = doc.Ecodigo
					  and t.CPTtipo ='D'
					where doc.Ecodigo =  #arguments.Ecodigo#
					  and doc.EDsaldo <> 0.00
					  and doc.Mcodigo <> #Monloc#
					  and round((imp.MontoCalculado - imp.MontoPagado) * (tc.TC - doc.EDtcultrev), 2) <> 0
					  and doc.CPTcodigo in ('FE','NH')
				</cfquery>
				<cfquery name="rs_A_Intarc" datasource="#arguments.conexion#">
					insert INTO #Intarc# (INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE)
					select
						  'CPCC',
						  1,
						  doc.CPTcodigo,
						  doc.Ddocumento,
						  abs(round((imp.MontoCalculado - imp.MontoPagado) * (tc.TC - doc.EDtcultrev), 2)),
						  case when round((imp.MontoCalculado - imp.MontoPagado) * (tc.TC - doc.EDtcultrev), 2) >= 0.00 then 'D' else 'C' end,
						  'Diferencial Cambiario Documento CE: ' #_Cat# rtrim(doc.CPTcodigo) #_Cat# '-' #_Cat# rtrim(doc.Ddocumento),
						  '#FechaHoy#',
						  0.00,
						  #Periodo#,
						  #Mes#,
						  imp.CcuentaImp,
						  doc.Mcodigo,
						  doc.Ocodigo,
						  0.00
					from EDocumentosCP doc
					 inner join ImpDocumentosCxP imp
					  on  imp.IDdocumento = doc.IDdocumento
					  and imp.Ecodigo   = doc.Ecodigo
					 inner join #monedas# tc
					  on tc.Mcodigo = doc.Mcodigo
					  and tc.Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">
					  and tc.Mes     = <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">
					 inner join CPTransacciones t
					  on t.CPTcodigo = doc.CPTcodigo
					  and t.Ecodigo = doc.Ecodigo
					  and t.CPTtipo ='C'
					where doc.Ecodigo = #arguments.Ecodigo#
					  and doc.EDsaldo <> 0.00
					  and doc.Mcodigo <> #Monloc#
					  and round((imp.MontoCalculado - imp.MontoPagado) * (tc.TC - doc.EDtcultrev), 2) <> 0
					  and doc.CPTcodigo in ('FE','NH')
				</cfquery>

				<!--- DIFERENCIAL CAMBIARIO  GASTOS --->
				<cfquery name="rs_A_Intarc" datasource="#arguments.conexion#">
					insert INTO #Intarc# (INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE)
					 select
						'CPCC',
						1,
						'Cierre:' #_Cat# '#Periodo#' #_Cat# '/' #_Cat# <cfif len(#Mes#) EQ 1>'0'#_Cat#</cfif>'#Mes#',
						'CxP CE',
						sum(INTMON * case when INTTIP = 'D' then 1 else -1 end),
						'C',
						'Ingreso (Gasto) por Diferencial Cambiario CE',
						'#FechaHoy#',
						1,
						#Periodo#,
						#Mes#,
						case when sum(INTMON * case when INTTIP = 'D' then 1 else -1 end) > 0 then #CuentaIngDifCam# else #CuentaGasDifCam# end,
						a.Mcodigo,
						a.Ocodigo,
						0.00
					 from #Intarc# a
					 group by
						a.Mcodigo,
						a.Ocodigo
				</cfquery>

			<cfif arguments.debug>
				<cfquery datasource="#arguments.conexion#" name="rsIntarcTMP">
			        select INTLIN, INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE
					from #Intarc#
					order by Mcodigo,INTTIP
				</cfquery>
				<cfif isdefined('rsIntarcTMP')>
					<cfdump var="#rsIntarcTMP#" label="tabla Intarc tmp en CierreMesCxP">
				</cfif>
			</cfif>

			<cfquery name="rs_revisa_Intarc" datasource="#arguments.conexion#">
					select INTLIN, INTTIP, Mcodigo, INTMOE
					from #Intarc#
			</cfquery>

			<cfif isdefined('rs_revisa_Intarc') and rs_revisa_Intarc.RecordCount GT 0>
				<cfinvoke component="CG_GeneraAsiento" method="GeneraAsiento" >
					<cfinvokeargument name="Ecodigo" value="#arguments.Ecodigo#"/>
					<cfinvokeargument name="Oorigen" value="CPCC"/>
					<cfinvokeargument name="Eperiodo" value="#Periodo#"/>
					<cfinvokeargument name="Emes" value="#Mes#"/>
					<cfinvokeargument name="Efecha" value="#DateAdd('d', -1, DateAdd('m', 1, CreateDate(Periodo, Mes, 1)))#"/>
					<cfinvokeargument name="Edescripcion" value="#descripcion#"/>
					<cfinvokeargument name="Ereferencia" value="CxP CE: Revaluación"/>
					<cfinvokeargument name="Edocbase" value="Mes #Periodo#-#Mes# CE"/>
				</cfinvoke>
			</cfif>

			<!--- Actualiza el último tipo de cambio en los documentos --->
			<cf_dbupdate table="EDocumentosCP" datasource="#arguments.conexion#">
				<cf_dbupdate_join table="#Monedas# a">
					on EDocumentosCP.Mcodigo = a.Mcodigo
						and EDocumentosCP.Ocodigo = a.Ocodigo
				</cf_dbupdate_join>

				<cf_dbupdate_set name='EDtcultrev' expr="a.TC" />

				<cf_dbupdate_where>
					WHERE EDocumentosCP.Ecodigo =   <cf_dbupdate_param type="integer" value="#arguments.Ecodigo#">
						and EDocumentosCP.EDsaldo <> 0.00
						and EDocumentosCP.CPTcodigo in ('FE','NH')
				</cf_dbupdate_where>
			</cf_dbupdate>
		</cfif>

		<!--- Saldos Iniciales --->
		<cfset this.SISaldosIniciales(arguments.Ecodigo, periodo, mes, arguments.debug, SIdocumentos, Arguments.conexion,1)>
	</cffunction>
	<!--- Cierre de Mes de Cuentas x Pagar --->
	<cffunction name='CierreMesCxP' access='public' output='no'>
		<cfargument name='Ecodigo' type='numeric' required='true'>
		<cfargument name='debug' type="boolean" required='false' default='false'>
		<cfargument name='conexion' type='string' required='false' default="#Session.DSN#">
		<cfargument name='Monedas' type="string" required="yes">
		<cfargument name='CPDocumentos' type="string" required="yes">
		<cfargument name='SIdocumentos' type="string" required="yes">
		<cfargument name='Intarc' type="string" required="yes">

		<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
		<cfset Monedas = Arguments.Monedas>
		<cfset CPDocumentos= Arguments.CPDocumentos>
		<cfset SIdocumentos= Arguments.SIdocumentos>
		<cfset Intarc= Arguments.Intarc>
		<!--- Creacion de las tablas temporales --->
		<cfquery datasource="#arguments.conexion#">
			delete from #Monedas#
		</cfquery>
		<cfquery datasource="#arguments.conexion#">
			delete from #CPDocumentos#
		</cfquery>
		<cfquery datasource="#arguments.conexion#">
			delete from #SIdocumentos#
		</cfquery>
		<cfquery datasource="#arguments.conexion#">
			delete from #Intarc#
		</cfquery>


		<!--- Parámetros Generales --->
		<cfset lin = 1>
		<cfset Periodo = -1>
		<cfset Mes = -1>
		<cfset Fecha = Now()>
		<cfset descripcion = 'CxP: Diferencial Cambiario Mensual'>
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

		<cfif isdefined('rs_Monloc') and rs_Monloc.recordCount GT 0 and rs_Monloc.Mcodigo NEQ ''>
			<cfset Monloc = rs_Monloc.Mcodigo>
		</cfif>

		<cfquery name="rs_Periodo" datasource="#arguments.conexion#">
			select Pvalor as Pvalor
			from Parametros
			where Ecodigo = #arguments.Ecodigo#
			  and Mcodigo = 'GN'
			  and Pcodigo = 50
		</cfquery>

		<cfif isdefined('rs_Periodo') and rs_Periodo.recordCount GT 0 and rs_Periodo.Pvalor NEQ ''>
			<cfset Periodo = rs_Periodo.Pvalor>
		</cfif>

		<cfquery name="rs_Mes" datasource="#arguments.conexion#">
			Select Pvalor as Pvalor
			from Parametros
			where Ecodigo = #arguments.Ecodigo#
			  and Mcodigo = 'GN'
			  and Pcodigo = 60
		</cfquery>

		<cfif isdefined('rs_Mes') and rs_Mes.recordCount GT 0 and rs_Mes.Pvalor NEQ ''>
			<cfset Mes = rs_Mes.Pvalor>
		</cfif>

		<!---  1) Validaciones Generales --->
		<cfif Periodo EQ -1 and Mes EQ -1>
			<cf_errorCode	code = "51088" msg = "No se ha definido el parámetro de Período o Mes para los sistemas Auxiliares! Proceso Cancelado !">
		</cfif>

 		<!---   2) Asiento Contable x Diferencial Cambiario Mensual --->
		<cfquery name="rs_EDocumentosCP" datasource="#arguments.conexion#">
			select 1
			from EDocumentosCP
			where Ecodigo = #arguments.Ecodigo#
				and CPTcodigo not in('FE','NH')
				and EDsaldo <> 0.00
				and Mcodigo <> #Monloc#
		</cfquery>

		<cfif isdefined('rs_EDocumentosCP') and rs_EDocumentosCP.recordCount GT 0>
			<cfquery name="rs_EDocumentosCP" datasource="#arguments.conexion#">
				insert INTO #CPDocumentos# ( IDdocumento, Ecodigo, Mes, Periodo, CPTcodigo, Ddocumento, Ocodigo, SNcodigo, Mcodigo, Ccuenta, EDsaldo, Saldo, EDtcultrev)
				select IDdocumento, #arguments.Ecodigo#, #Mes#, #Periodo#, CPTcodigo, Ddocumento, Ocodigo, SNcodigo, Mcodigo, Ccuenta, EDsaldo, 0.00, EDtcultrev
				from EDocumentosCP
				where Ecodigo = #arguments.Ecodigo#
				and CPTcodigo not in('FE','NH')
				and Mcodigo <> #Monloc#
				and EDsaldo <> 0.00
			</cfquery>

 			<cfquery name="rs_Monedas" datasource="#arguments.conexion#">
				insert INTO #Monedas#(Mcodigo, Ocodigo, TC, Total, Ecodigo, Mes, Periodo)
				select distinct Mcodigo, Ocodigo, -1, 0.00, #arguments.Ecodigo#, #Mes#, #Periodo#
				from #CPDocumentos#
			</cfquery>
			<cfoutput>
				<cf_dbupdate table="#Monedas#" datasource="#arguments.conexion#">
					<cf_dbupdate_join table="TipoCambioEmpresa a">
						on a.Mcodigo = #Monedas#.Mcodigo
							and a.Periodo = #Monedas#.Periodo
							and a.Mes = #Monedas#.Mes
							and a.Ecodigo = #Monedas#.Ecodigo
					</cf_dbupdate_join>

					<cf_dbupdate_set name='TC' expr="coalesce(TCEtipocambioventa, TCEtipocambio, 0)" />

					<cf_dbupdate_where>
						WHERE #Monedas#.Ecodigo =   <cf_dbupdate_param type="integer" value="#arguments.Ecodigo#">
							and #Monedas#.Periodo = <cf_dbupdate_param type="integer" value="#Periodo#">
							and #Monedas#.Mes = <cf_dbupdate_param type="integer" value="#Mes#">
					</cf_dbupdate_where>
				</cf_dbupdate>
			</cfoutput>

 			<cfoutput>
				<cf_dbupdate table="#Monedas#" datasource="#arguments.conexion#">
					<cf_dbupdate_join table="Monedas a">
						on #Monedas#.Mcodigo = a.Mcodigo
					</cf_dbupdate_join>
					<cf_dbupdate_set name='#Monedas#.Mnombre' expr="a.Mnombre" />
				</cf_dbupdate>
			</cfoutput>

 			<cfoutput>
				<cf_dbupdate table="#CPDocumentos#" datasource="#arguments.conexion#">
					<cf_dbupdate_join table="#Monedas# a">
						on a.Mcodigo = #CPDocumentos#.Mcodigo
							and a.Ocodigo = #CPDocumentos#.Ocodigo
					</cf_dbupdate_join>

					<cf_dbupdate_set name='Saldo' expr="#CPDocumentos#.EDsaldo * (a.TC - #CPDocumentos#.EDtcultrev)" />
				</cf_dbupdate>
			</cfoutput>

			<cfquery name="rs_update_Monedas_3" datasource="#arguments.conexion#">
				update #Monedas# set Total = (	select sum(Saldo)
												from #CPDocumentos# a
												where a.Mcodigo = #Monedas#.Mcodigo
													and a.Ocodigo = #Monedas#.Ocodigo
											  )
			</cfquery>

			<cfquery name="rs_ParamPvalor_1" datasource="#arguments.conexion#">
				Select Pvalor as Pvalor
				from Parametros
				where Ecodigo = #arguments.Ecodigo#
				  and Pcodigo = 140
				  and Mcodigo = 'CP'
			</cfquery>

			<cfquery name="rs_ParamPvalor_2" datasource="#arguments.conexion#">
				Select Pvalor as Pvalor
				from Parametros
				where Ecodigo = #arguments.Ecodigo#
				  and Pcodigo = 130
				  and Mcodigo = 'CP'
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
					<cfdump var="#rsMonedasTMP#" label="Monedas tmp CierreMesCxP">
				</cfif>


				<cfquery datasource="#arguments.conexion#" name="rsCPDocumentosTMP">
					select IDdocumento, CPTcodigo, Ddocumento, Ocodigo, SNcodigo, Mcodigo, Ccuenta, EDsaldo, Saldo, EDtcultrev
					from #CPDocumentos#
				</cfquery>
				<cfif isdefined('rsCPDocumentosTMP')>
					<cfdump var="#rsCPDocumentosTMP#" label="Monedas tmp CierreMesCxP">
				</cfif>
			</cfif>
			<cfquery name="rs_MonedasTemp" datasource="#arguments.conexion#">
				select 1
				from #Monedas#
				where TC <= 0.00
			</cfquery>

			<cfif isdefined('rs_MonedasTemp') and rs_MonedasTemp.recordCount GT 0>
				<cfquery name="rs_desMonedas" datasource="#arguments.conexion#" maxrows="1">
					select b.Mnombre
					from #Monedas# a, Monedas b
					where a.Mcodigo = b.Mcodigo
					  and a.TC <= 0.00
				</cfquery>

				<cfset DescMoneda = "">
				<cfif isdefined('rs_desMonedas') and rs_desMonedas.recordCount GT 0>
					<cfset DescMoneda = rs_desMonedas.Mnombre>
				</cfif>
				<cfset msg = "Error! No se ha definido el Tipo de Cambio para la Moneda: " & DescMoneda & " , Período: " & Periodo & ", Mes: " & Mes & ". Proceso Cancelado!.">

				<cfthrow message="#msg#">
			</cfif>

			<cfset FechaHoy = DateFormat(Now(),'yyyymmdd')>

			<cfquery name="rsCuentaIngDifCam" datasource="#session.DSN#">
				select p.Pvalor as CuentaIngDifCam
				from Parametros p
				where Ecodigo =  #session.Ecodigo#
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
				where Ecodigo =  #session.Ecodigo#
				and Pcodigo = 120
			</cfquery>
			<cfif isdefined("rsCuentaGasDifCam") and rsCuentaGasDifCam.recordcount gt 0>
				<cfset CuentaGasDifCam = rsCuentaGasDifCam.CuentaGasDifCam>
			<cfelse>
				<cf_errorCode	code = "50985" msg = "No se ha definido la cuenta de gasto de diferencial cambiario.">
			</cfif>

			<!--- DIFERENCIAL CAMBIARIO  Cuenta por PAGAR --->
			<cfquery name="rs_A_Intarc" datasource="#arguments.conexion#">
				insert INTO #Intarc# (INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE)
				 select
					  'CPCM',
					  1,
					  doc.CPTcodigo,
					  doc.Ddocumento,
					  abs(round(doc.EDsaldo * (tc.TC - doc.EDtcultrev), 2)),
					  case when round(doc.EDsaldo * (tc.TC - doc.EDtcultrev), 2) >= 0.00 then 'D' else 'C' end	,
					  'Ajuste Diferencial Cambiario Documento: ' #_Cat# rtrim(doc.CPTcodigo) #_Cat# '-' #_Cat# rtrim(doc.Ddocumento),
					  '#FechaHoy#',
					  0.00,
					  #Periodo#,
					  #Mes#,
					  doc.Ccuenta,
					  doc.Mcodigo,
					  doc.Ocodigo,
					  0.00
				from EDocumentosCP doc
				 inner join #monedas# tc
				  on tc.Mcodigo = doc.Mcodigo
				  and tc.Ocodigo = doc.Ocodigo
				  and tc.Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">
				  and tc.Mes     = <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">
				 inner join CPTransacciones t
				  on t.CPTcodigo = doc.CPTcodigo
				  and t.Ecodigo = doc.Ecodigo
				  and t.CPTtipo ='D'
				where doc.Ecodigo =  #arguments.Ecodigo#
				  and doc.EDsaldo <> 0.00
				  and doc.Mcodigo <> #Monloc#
				  and round(doc.EDsaldo * (tc.TC - doc.EDtcultrev), 2) <> 0
				  and doc.CPTcodigo not in ('FE','NH')
			</cfquery>
			<cfquery name="rs_A_Intarc" datasource="#arguments.conexion#">
				insert INTO #Intarc# (INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE)
				 select
					  'CPCM',
					  1,
					  doc.CPTcodigo,
					  doc.Ddocumento,
					  abs(round(doc.EDsaldo * (tc.TC - doc.EDtcultrev), 2)),
					  case when round(doc.EDsaldo * (tc.TC - doc.EDtcultrev), 2) >= 0.00 then 'C' else 'D' end	,
					  'Ajuste Diferencial Cambiario Documento: ' #_Cat# rtrim(doc.CPTcodigo) #_Cat# '-' #_Cat# rtrim(doc.Ddocumento),
					  '#FechaHoy#',
					  0.00,
					  #Periodo#,
					  #Mes#,
					  doc.Ccuenta,
					  doc.Mcodigo,
					  doc.Ocodigo,
					  0.00
				from EDocumentosCP doc
				 inner join #monedas# tc
				  on tc.Mcodigo = doc.Mcodigo
				  and tc.Ocodigo = doc.Ocodigo
				  and tc.Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">
				  and tc.Mes     = <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">
				 inner join CPTransacciones t
				  on t.CPTcodigo = doc.CPTcodigo
				  and t.Ecodigo = doc.Ecodigo
				  and t.CPTtipo ='C'
				where doc.Ecodigo =  #arguments.Ecodigo#
				  and doc.EDsaldo <> 0.00
				  and doc.Mcodigo <> #Monloc#
				  and round(doc.EDsaldo * (tc.TC - doc.EDtcultrev), 2) <> 0
				  and doc.CPTcodigo not in ('FE','NH')
			</cfquery>
			<!--- DIFERENCIAL CAMBIARIO  IMPUESTOS --->
				<cfquery name="rs_A_Intarc" datasource="#arguments.conexion#">
					insert INTO #Intarc# (INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE)
					select
						  'CPCM',
						  1,
						  doc.CPTcodigo,
						  doc.Ddocumento,
						  abs(round((imp.MontoCalculado - imp.MontoPagado) * (tc.TC - doc.EDtcultrev), 2)),
						  case when round((imp.MontoCalculado - imp.MontoPagado) * (tc.TC - doc.EDtcultrev), 2) >= 0.00 then 'C' else 'D' end,
						  'Diferencial Cambiario Impuesto Documento: ' #_Cat# rtrim(doc.CPTcodigo) #_Cat# '-' #_Cat# rtrim(doc.Ddocumento),
						  '#FechaHoy#',
						  0.00,
						  #Periodo#,
						  #Mes#,
						  imp.CcuentaImp,
						  doc.Mcodigo,
						  doc.Ocodigo,
						  0.00
					from EDocumentosCP doc
					 inner join ImpDocumentosCxP imp
					  on  imp.IDdocumento = doc.IDdocumento
					  and imp.Ecodigo   = doc.Ecodigo
					 inner join #monedas# tc
					  on tc.Mcodigo = doc.Mcodigo
					  and tc.Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">
					  and tc.Mes     = <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">
					 inner join CPTransacciones t
					  on t.CPTcodigo = doc.CPTcodigo
					  and t.Ecodigo = doc.Ecodigo
					  and t.CPTtipo ='D'
					where doc.Ecodigo =  #arguments.Ecodigo#
					  and doc.EDsaldo <> 0.00
					  and doc.Mcodigo <> #Monloc#
					  and round((imp.MontoCalculado - imp.MontoPagado) * (tc.TC - doc.EDtcultrev), 2) <> 0
					  and doc.CPTcodigo not in ('FE','NH')
				</cfquery>
				<cfquery name="rs_A_Intarc" datasource="#arguments.conexion#">
					insert INTO #Intarc# (INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE)
					select
						  'CPCM',
						  1,
						  doc.CPTcodigo,
						  doc.Ddocumento,
						  abs(round((imp.MontoCalculado - imp.MontoPagado) * (tc.TC - doc.EDtcultrev), 2)),
						  case when round((imp.MontoCalculado - imp.MontoPagado) * (tc.TC - doc.EDtcultrev), 2) >= 0.00 then 'D' else 'C' end,
						  'Diferencial Cambiario Documento: ' #_Cat# rtrim(doc.CPTcodigo) #_Cat# '-' #_Cat# rtrim(doc.Ddocumento),
						  '#FechaHoy#',
						  0.00,
						  #Periodo#,
						  #Mes#,
						  imp.CcuentaImp,
						  doc.Mcodigo,
						  doc.Ocodigo,
						  0.00
					from EDocumentosCP doc
					 inner join ImpDocumentosCxP imp
					  on  imp.IDdocumento = doc.IDdocumento
					  and imp.Ecodigo   = doc.Ecodigo
					 inner join #monedas# tc
					  on tc.Mcodigo = doc.Mcodigo
					  AND tc.Mcodigo = doc.Ocodigo
					  and tc.Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Periodo#">
					  and tc.Mes     = <cfqueryparam cfsqltype="cf_sql_integer" value="#Mes#">
					 inner join CPTransacciones t
					  on t.CPTcodigo = doc.CPTcodigo
					  and t.Ecodigo = doc.Ecodigo
					  and t.CPTtipo ='C'
					where doc.Ecodigo = #arguments.Ecodigo#
					  and doc.EDsaldo <> 0.00
					  and doc.Mcodigo <> #Monloc#
					  and round((imp.MontoCalculado - imp.MontoPagado) * (tc.TC - doc.EDtcultrev), 2) <> 0
					  and doc.CPTcodigo not in ('FE','NH')
				</cfquery>

				<!--- DIFERENCIAL CAMBIARIO  GASTOS --->
				<cfquery name="rs_A_Intarc" datasource="#arguments.conexion#">
					insert INTO #Intarc# (INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE)
					 select
						'CPCM',
						1,
						'Cierre:' #_Cat# '#Periodo#' #_Cat# '/' #_Cat# <cfif len(#Mes#) EQ 1>'0'#_Cat#</cfif>'#Mes#',
						'CxP',
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
					 from #Intarc# a
					 group by
						a.Mcodigo,
						a.Ocodigo
				</cfquery>

			<cfif arguments.debug>
				<cfquery datasource="#arguments.conexion#" name="rsIntarcTMP">
			        select INTLIN, INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE
					from #Intarc#
					order by Mcodigo,INTTIP
				</cfquery>
				<cfif isdefined('rsIntarcTMP')>
					<cfdump var="#rsIntarcTMP#" label="tabla Intarc tmp en CierreMesCxP">
				</cfif>
			</cfif>


			<cfquery name="rs_revisa_Intarc" datasource="#arguments.conexion#">
					select INTLIN, INTTIP, Mcodigo, INTMOE
					from #Intarc#
			</cfquery>

			<cfif isdefined('rs_revisa_Intarc') and rs_revisa_Intarc.RecordCount GT 0>
				<cfinvoke component="CG_GeneraAsiento" method="GeneraAsiento" >
					<cfinvokeargument name="Ecodigo" value="#arguments.Ecodigo#"/>
					<cfinvokeargument name="Oorigen" value="CPCM"/>
					<cfinvokeargument name="Eperiodo" value="#Periodo#"/>
					<cfinvokeargument name="Emes" value="#Mes#"/>
					<cfinvokeargument name="Efecha" value="#DateAdd('d', -1, DateAdd('m', 1, CreateDate(Periodo, Mes, 1)))#"/>
					<cfinvokeargument name="Edescripcion" value="#descripcion#"/>
					<cfinvokeargument name="Ereferencia" value="CxP: Revaluación"/>
					<cfinvokeargument name="Edocbase" value="Mes #Periodo#-#Mes#"/>
				</cfinvoke>
			</cfif>

			<!--- Actualiza el último tipo de cambio en los documentos --->
			<cf_dbupdate table="EDocumentosCP" datasource="#arguments.conexion#">
				<cf_dbupdate_join table="#Monedas# a">
					on EDocumentosCP.Mcodigo = a.Mcodigo
						and EDocumentosCP.Ocodigo = a.Ocodigo
				</cf_dbupdate_join>

				<cf_dbupdate_set name='EDtcultrev' expr="a.TC" />

				<cf_dbupdate_where>
					WHERE EDocumentosCP.Ecodigo =   <cf_dbupdate_param type="integer" value="#arguments.Ecodigo#">
						and EDocumentosCP.EDsaldo <> 0.00
						and EDocumentosCP.CPTcodigo not in ('FE','NH')
				</cf_dbupdate_where>
			</cf_dbupdate>
		</cfif>

		<!--- Saldos Iniciales --->
		<cfset this.SISaldosIniciales(arguments.Ecodigo, periodo, mes, arguments.debug, SIdocumentos, Arguments.conexion,0)>
	</cffunction>

	<cffunction name="CMA_CierreMesCxP_BorrarCeros" access="public" output="no">
		<cfargument name="Ecodigo" default="-1" required="yes">
		<cfargument name="conexion" default="#session.dsn#" required="yes">

		<cfset TCP_CPDocs0       = this.Crea_CPDocs0()>

		<cftransaction>
			<!--- 3) Eliminar Documentos sin Saldo --->
            <cfquery datasource="#arguments.conexion#">
                insert into #TCP_CPDocs0# (IDdocumento, Ecodigo, CPTcodigo, Ddocumento, SNcodigo)
                select a.IDdocumento, a.Ecodigo, a.CPTcodigo, a.Ddocumento, a.SNcodigo
                from EDocumentosCP a
                where a.Ecodigo = #arguments.Ecodigo#
                  and a.EDsaldo = 0.00
                  and (
                            select count(1)
                            from EAplicacionCP c
                            where c.ID = a.IDdocumento
                        ) = 0
                  and (
                            select count(1)
                            from DPagosCxP d
                            where d.IDdocumento = a.IDdocumento
                        ) = 0
            </cfquery>

            <cfquery datasource="#arguments.conexion#">
                delete from DDocumentosCP
                where (
                    select count(1)
                    from #TCP_CPDocs0# b
                    where DDocumentosCP.IDdocumento = b.IDdocumento
                    ) > 0
            </cfquery>

            <cfquery datasource="#arguments.conexion#">
                delete from EDocumentosCP
                where (
                    select count(1)
                    from #TCP_CPDocs0# b
                    where EDocumentosCP.IDdocumento = b.IDdocumento
                    ) > 0
            </cfquery>

            <cfquery datasource="#arguments.conexion#">
                delete from #TCP_CPDocs0#
            </cfquery>


        </cftransaction>
	</cffunction>

	<cffunction name="Crea_CPDocs0" access="public" output="no" returntype="string">
		<cf_dbtemp name="CMACxPDcero">
			<cf_dbtempcol name="IDdocumento"  	type="numeric"     	mandatory="yes">
			<cf_dbtempcol name="Ecodigo"  		type="int">
			<cf_dbtempcol name="CPTcodigo"  	type="char(2)">
			<cf_dbtempcol name="Ddocumento"		type="varchar(40)">
			<cf_dbtempcol name="SNcodigo"  		type="int">

			<cf_dbtempkey cols="IDdocumento">
		</cf_dbtemp>

		<cfreturn temp_table>
	</cffunction>

</cfcomponent>


