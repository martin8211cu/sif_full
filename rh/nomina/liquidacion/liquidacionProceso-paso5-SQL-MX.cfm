<cfif isdefined("Form.Aprobar")>
	<cfquery name="rsDetalleRHLiquidacionPersonal" datasource="#session.DSN#">
		select DLfvigencia as DLfechaaplic
			 from DLaboralesEmpleado
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
			  and DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DLlinea#">
	</cfquery>
	<cfinvoke component="rh.Componentes.RHLiquidacionMX" method="fnGetLF" returnvariable="rsLF">
		<cfinvokeargument name="DLlinea" value="#form.DLlinea#">
		<cfinvokeargument name="DEid" value="#form.DEid#">
	</cfinvoke>
	<cfif rsLF.recordcount gt 0>
		<cfinvoke component="rh.Componentes.RHLiquidacionMX" method="fnValidaModificaciones" returnvariable="datosHanCambiado">
			<cfinvokeargument name="DLlinea" value="#form.DLlinea#">
			<cfinvokeargument name="DEid" value="#form.DEid#">
			<cfinvokeargument name="Fecha" value="#rsDetalleRHLiquidacionPersonal.DLfechaaplic#">
		</cfinvoke>
		<cfif datosHanCambiado>
			<cfthrow message="Los datos del paso 2 han sido modificados y no se han guardado, debe de Guardar los datos para aprobar la Liquidación.">
		</cfif>
	<cfelse>
		<cfthrow message="El paso 2 es necesario para la liquidación y este no ha sido proceso, debe de Guardar los datos generados por este para aprobar la Liquidación.">
	</cfif>
	<cftransaction>

		<!--- Procesillo para matar saldo de vacaciones de un empleado cesado.
			  Este calculo se REALIZABA cuando se aplicaba la accion, pero se cambio
			  para realizarlo en este punto.
		 --->
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_Liquidacion_de_Vacaciones"
			xmlfile="/rh/nomina/liquidacion/liquidacionProceso.xml"
			Default="Liquidación de Vacaciones."
			returnvariable="MSG_Liquidacion"/>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_Liquidacion_de_Dias_de_Enfermedad"
			xmlfile="/rh/nomina/liquidacion/liquidacionProceso.xml"
			Default="Liquidación de Días de Enfermedad."
			returnvariable="MSG_LiquidacionEnf"/>

		<cfif isdefined("form.DLlinea") and len(trim(form.DLlinea))>
			<cfquery datasource="#session.DSN#" name="rsFcese">
				select DLfvigencia from DLaboralesEmpleado where DLlinea=#form.DLlinea#
			</cfquery>
			<cfset fechaLiq = rsFcese.DLfvigencia>
		<cfelse>
			<cfset fechaLiq = now()>
		</cfif>

		<cfquery datasource="#session.DSN#" >
			insert into DVacacionesEmpleado( DEid,
											 Ecodigo,
											 DVEfecha,
											 DVEdescripcion,
											 DVEdisfrutados,
											 DVEcompensados,
											 DVEenfermedad,
											 DVEadicionales,
											 DVEmonto,
											 Usucodigo,
											 Ulocalizacion,
											 DVEfalta,
											 BMUsucodigo )
			select DEid,
				   <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				   <cfqueryparam cfsqltype="cf_sql_date" value="#fechaLiq#">,
				   '#MSG_Liquidacion#',
				    sum(DVEdisfrutados + DVEcompensados)*-1,
					0,
					0,
					0,
					0,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
					'00',
					<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">

			from DVacacionesEmpleado
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			group by DEid
		</cfquery>

		<!--- 	Desarrollo Baroda-DHC
				Se inserta un registro para saldar a cero los dias de enfermedad del empleado.
				Solo si empresa maneja dias de enfermedad.
		--->
		<cfquery name="rs_p960" datasource="#session.DSN#">
			select Pvalor
			from RHParametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and Pcodigo = 960
		</cfquery>

		<cfif trim(rs_p960.Pvalor) eq 1>
			<cfquery datasource="#session.DSN#" >
				insert into DVacacionesEmpleado( DEid,
												 Ecodigo,
												 DVEfecha,
												 DVEdescripcion,
												 DVEdisfrutados,
												 DVEcompensados,
												 DVEenfermedad,
												 DVEadicionales,
												 DVEmonto,
												 Usucodigo,
												 Ulocalizacion,
												 DVEfalta,
												 BMUsucodigo )
				select DEid,
					   <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					   #fechaLiq#,
					   '#MSG_LiquidacionEnf#',
						0,
						0,
						sum(DVEenfermedad)*-1,
						0,
						0,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
						'00',
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">

				from DVacacionesEmpleado
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
				group by DEid
			</cfquery>

			<cfquery datasource="#session.DSN#">
				update EVacacionesEmpleado
				set EVfenfermedad = ( select DLfvigencia
									  from DLaboralesEmpleado
									  where DEid = EVacacionesEmpleado.DEid
									    and DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DLlinea#"> )
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			</cfquery>
		</cfif>

		<!--- Procesillo para matar pago de intereses por cesantia --->
		<!--- solo si empresa para intereses por cesantia --->
		<cfquery name="rs_parametro_810" datasource="#session.DSN#" >
			select Pvalor
			from RHParametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and Pcodigo = 810
		</cfquery>
		<cfif ucase(rs_parametro_810.Pvalor) eq 'YES'>
			<cfquery name="rs_datos" datasource="#session.DSN#">
				select RHLPid, DEid, motivoliq
				from RHLiqIngresos
				where DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DLlinea#">
				and cesantia = 1
			</cfquery>

			<cfif len(trim(rs_datos.DEid)) and len(trim(rs_datos.motivoliq)) >
				<!--- hace los calculos del pago de intereses por cesantia --->
				<cfinvoke component="rh.Componentes.RH_Cesantia" method="liquidacion" returnvariable="rs_calculado">
					<cfinvokeargument name="DEid" value="#rs_datos.DEid#">
					<cfinvokeargument name="tipo" value="#rs_datos.motivoliq#">
				</cfinvoke>

				<!--- modifica el registro asociado a la cesantia (solo es uno) --->
				<cfquery datasource="#session.DSN#">
					update RHLiqIngresos
					set importe = <cfif len(trim(rs_calculado.monto_total))><cfqueryparam cfsqltype="cf_sql_money" value="#rs_calculado.intereses#"><cfelse>0</cfif>
					where DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DLlinea#">
					and cesantia = 1
				</cfquery>

			<cfelse>
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="MSG_Error._Debe_definir_el_Concepto_Incidente_y_el_motivo_de_la_liquidacion_para_el_calculo_de_intereses_por_Cesantia._Debe_ir_al_paso_1_a_definir_esta_informacion"
					xmlfile="/rh/nomina/liquidacion/liquidacionProceso.xml"
					Default="Error de configuraci&oacute;n. Debe definir el Concepto Incidente y el motivo de la liquidaci&oacute;n para el c&aacute;lculo de intereses por Cesant&iacute;a. Debe ir al paso 1 a definir esta informaci&oacute;n"
					returnvariable="MSG_Error"/>
				    <cf_throw message="#MSG_Error#" errorCode="1075">
			</cfif>
		</cfif>

		<cfquery name="updLiquidacion" datasource="#Session.DSN#">
			update RHLiquidacionPersonal
			set RHLPestado = 1,
			RHLPfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
			where DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DLlinea#">
		</cfquery>

		<!--- pone la fecha de ultima liquidacion de cesantia para el empleado --->
		<cfquery datasource="#session.DSN#">
			update EVacacionesEmpleado
			set EVfliquidacion = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">
			where DEid = ( select DEid from RHLiquidacionPersonal where DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DLlinea#"> )
		</cfquery>

       	<!--- SML Modificar el estatus del Fondo de Ahorro--->
        <cfquery datasource="#session.DSN#">
			update RHHFondoAhorro
			set FAEstatus= 1
			where DEid = ( select DEid from RHLiquidacionPersonal where DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DLlinea#"> )
            	and FAEstatus= 0
		</cfquery>

    	<cfquery datasource="#session.DSN#">
			update RHHFondoAhorro
			set FAEstatusFini= 1
			where DEid = ( select DEid from RHLiquidacionPersonal where DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DLlinea#"> )
            	and RCNid in (select top(1) RCNid
								from RHHFondoAhorro
								where DEid = ( select DEid from RHLiquidacionPersonal where DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DLlinea#"> )
								order by HFAid desc)
		</cfquery>

		<!---====== OPARRALES 2019-03-06 Modificacion para generar polizas de liquidacion =====--->
		<cfquery name="rsCuentaEmp" datasource="#session.dsn#">
			select 
				cf.CFcuentac 
			from LineaTiempo lt 
			inner join RHPlazas p 
			on lt.RHPid = p.RHPid
			inner join CFuncional cf
			on cf.CFid = p.CFid
			where DEid = ( select DEid from RHLiquidacionPersonal where DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DLlinea#"> )
			and lt.LTid = (select max(lt2.LTid) 
											from LineaTiempo lt2 
											where lt2.DEid = ( select DEid from RHLiquidacionPersonal 
																					where DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DLlinea#"> )
										)
		</cfquery>
		
		<cfset arrCcuenta = ListToArray(rsCuentaEmp.CFcuentac,"-")>
		
		<cfset varCcuenta = "">
		<cfloop from="1" to="#ArrayLen(arrCcuenta)#" index="count">
			<cfset varCcuenta &= "#(count eq 1) ? '' : '-'##Trim(arrCcuenta[count])#">
		</cfloop>

		<cfif Trim(varCcuenta) eq ''>
			<cfthrow message="Centro Funcional " detail="No se ha configurado la Cuenta de Gasto o Compras de Servicios">
		</cfif>

		<cfinvoke component="sif.Componentes.CG_GeneraAsiento" returnvariable="INTARC" method="CreaIntarc" />

		<cfquery datasource="#session.DSN#">
			delete from #INTARC#
		</cfquery>

		<cfquery name="rsInfoL" datasource="#session.dsn#">
			select
				RHLPfecha 
			from RHLiquidacionPersonal
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#"> 
			and DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DLlinea#"> 
		</cfquery>

		<cfquery name="rsIdentificacion" datasource="#session.dsn#">
			select DEidentificacion from DatosEmpleado
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#"> 
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#"> 
		</cfquery>
		<cfset varIdentificacion = rsIdentificacion.recordCount gt 0 ? rsIdentificacion.DEidentificacion : "">

		<cfquery name="rsLTEmp" datasource="#session.dsn#">	
			select Max(LTid),Ocodigo from LineaTiempo where DEid = #form.DEid#
			group by Ocodigo 
		</cfquery>
		
		<cfset varOcodigo = rsLTEmp.Ocodigo>

		<cfquery name="rsMcodigo" datasource="#session.dsn#">	
			select Mcodigo 
			from Empresas 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		</cfquery>
		<cfset varMcodigo = rsMcodigo.Mcodigo>

		<cfset varFechaFL = LSDateFormat(rsInfoL.RHLPfecha,"YYYY-MM-dd")>
		<cfset varDoc = "" & varFechaFL & "-" & varOcodigo>
		
		<cfquery name="rsPerc" datasource="#session.dsn#">
			Select
				'Percepciones' as TipoReg,
				i.RHLPdescripcion as descripcion,
				round(dd.DDCcant,2) as cantidad,
				round(dd.DDCimporte,2) as importe,
				round(dd.DDCres,2) as resultado,
				ci.CIcuentac
			from RHLiqIngresos i
			inner join DDConceptosEmpleado dd
				on dd.DLlinea = i.DLlinea
				and dd.CIid = i.CIid
			inner join CIncidentes ci
				on ci.CIid = i.CIid
			where i.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#"> 
			and i.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DLlinea#">
			AND dd.DDCres > 0
		</cfquery>

		<cfloop query="rsPerc">
			<cfset mascara = createObject("component", "sif.Componentes.AplicarMascara")>
			<!--- <cfset unCFformato = Trim(varCcuenta) &  CIcuentac> --->
			<cfset unCFformato = mascara.AplicarMascara(
				cuenta = Trim(varCcuenta),
				valor = CIcuentac,
				sustitucion = '?')>
				
			<cfquery name="rsCFcuenta" datasource="#session.dsn#">
				select 
					CFcuenta 
				from CFinanciera 
				where CFformato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#unCFformato#">
				and Ecodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#"> 
			</cfquery>
			<cfif rsCFcuenta.RecordCount eq 0>
				<cfthrow message="Cuenta Financiera" detail="La cuenta con el formato: #unCFformato# no existe.">
			</cfif>
			<cfset unaCFcuenta = rsCFcuenta.CFcuenta>
			<cfquery datasource="#session.dsn#">
				insert into #INTARC#
				(
					INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP,
					INTDES, INTFEC, INTCAM, Periodo, Mes, Mcodigo,
					Ocodigo, INTMOE, Ccuenta, CFcuenta
				)
				values
				(
					'RHPN', 1, '#varDoc#', 'Liquidacion-Finiquito #varIdentificacion#', Round(#RESULTADO#,4),	'D',
					'INCIDENCIA', <cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(varFechaFL,'yyyymmdd')#">,
					1, #Year(varFechaFL)#, #Month(varFechaFL)#, #varMcodigo#, #varOcodigo#,Round(#RESULTADO#,4),
					#unaCFcuenta#,#unaCFcuenta#
				)
			</cfquery>
		</cfloop>
		
		<cfquery name="rsDeducs" datasource="#session.dsn#">
			select
				TipoReg,
				descripcion,
				cantidad,
				importe,
				resultado,
				Ccuenta
			from
			(
				<!---
				select
					'Deducciones' as TipoReg,
					RHLCdescripcion as descripcion,
					1 as cantidad,
					importe,
					importe as resultado
				from RHLiqCargas
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
				and DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DLlinea#">
				union
				--->				
				select
					'Deducciones' as TipoReg,
					RHLDdescripcion as descripcion,
					1 as cantidad,
					importe,
					importe as resultado,
					td.Ccuenta
				from RHLiqDeduccion ld
				inner join DeduccionesEmpleado de
					on de.Did = ld.Did
				inner join TDeduccion td
					on td.TDid = de.TDid
				where ld.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
				and DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DLlinea#">
			) obj
			order by TipoReg
		</cfquery>

		<cfquery name="rsISR" datasource="#session.dsn#">
			select
					'Deducciones' as TipoReg,
					'I.S.R' as descripcion,
					1 as cantidad,
					RHLFLisptF as importe,
					RHLFLisptF as resultado
			from RHLiqFL
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			and DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DLlinea#">
			and RHLFLisptF > 0
		</cfquery>
		
		<cfset montoISR = 0>
		<cfif rsISR.RecordCount gt 0>
			<cfset montoISR = LSNumberFormat(rsISR.RESULTADO,'9.0000')>
			<cfquery name="rsCuentaISR" datasource="#session.dsn#">
				select Pvalor 
				from RHParametros 
				WHERE Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="140"> 
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			</cfquery>

			<cfif rsCuentaISR.RecordCount eq 0>
				<cfthrow message="Parametros RH" detail="La Cuenta Contable de Renta no se ha parametrizado.">
			</cfif>

			<cfquery datasource="#session.dsn#">
				insert into #INTARC#
				(
					INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP,
					INTDES, INTFEC, INTCAM, Periodo, Mes, Mcodigo,
					Ocodigo, INTMOE, Ccuenta, CFcuenta
				)
				values
				(
					'RHPN', 1, '#varDoc#', 'Liquidacion-Finiquito #varIdentificacion#', #LSNumberFormat(rsISR.RESULTADO,'9.0000')#,	'C',
					'ISR', <cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(varFechaFL,'yyyymmdd')#">,
					1, #Year(varFechaFL)#, #Month(varFechaFL)#, #varMcodigo#, #varOcodigo#,#LSNumberFormat(rsISR.RESULTADO,'9.0000')#,
					#rsCuentaISR.Pvalor#,#rsCuentaISR.Pvalor#
				)
			</cfquery>
		</cfif>

		<cfloop query="rsDeducs">
			<cfif Trim(Ccuenta) eq "">
				<cfthrow message="Cuenta Financiera" detail="No se ha definido una cuenta para la deduccion #descripcion#.">
			</cfif>
			<cfset unaCFcuenta = rsDeducs.Ccuenta>
			<cfquery datasource="#session.dsn#">
				insert into #INTARC#
				(
					INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP,
					INTDES, INTFEC, INTCAM, Periodo, Mes, Mcodigo,
					Ocodigo, INTMOE, Ccuenta, CFcuenta
				)
				values
				(
					'RHPN', 1, '#varDoc#', 'Liquidacion-Finiquito #varIdentificacion#', Round(#RESULTADO#,4),	'C',
					'DEDUCCION', <cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(varFechaFL,'yyyymmdd')#">,
					1, #Year(varFechaFL)#, #Month(varFechaFL)#, #varMcodigo#, #varOcodigo#,Round(#RESULTADO#,4),
					#unaCFcuenta#,#unaCFcuenta#
				)
			</cfquery>
		</cfloop>
		
		<cfset totPerc = 0>
		<cfset totDed  = 0>

		<cfquery name="rsTotPerc" dbtype="query">
			select sum(resultado) as Total
			from rsPerc
		</cfquery>
		<cfif rsTotPerc.RecordCount gt 0>
			<cfset totPerc = rsTotPerc.Total>
		</cfif>

		<cfquery name="rsTotDeduc" dbtype="query">
			select sum(resultado) as Total
			from rsDeducs
		</cfquery>
		<cfif rsTotDeduc.RecordCount gt 0>
			<cfset totDed  = rsTotDeduc.Total>
		</cfif>

		<cfset totDed += montoISR>

		<cfset difSueldos = totPerc - totDed>

		<cfif difSueldos gt 0 >
			<cfquery name="rsCuentaSueldos" datasource="#session.dsn#">
				select Pvalor
				from RHParametros 
				WHERE Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="150"> 
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			</cfquery>

			<cfif rsCuentaSueldos.RecordCount eq 0 or Trim(rsCuentaSueldos.Pvalor) eq ''>
				<cfthrow message="Parametros RH" detail="La Cuenta Contable de Pagos no Realizados no se ha configurado.">
			</cfif>

			<cfquery datasource="#session.dsn#">
				insert into #INTARC#
				(
					INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP,
					INTDES, INTFEC, INTCAM, Periodo, Mes, Mcodigo,
					Ocodigo, INTMOE, Ccuenta, CFcuenta
				)
				values
				(
					'RHPN', 1, '#varDoc#', 'Liquidacion-Finiquito #varIdentificacion#', #difSueldos#,	'C',
					'SUELDOS', <cfqueryparam cfsqltype="cf_sql_varchar" value="#LSDateFormat(varFechaFL,'yyyymmdd')#">,
					1, #Year(varFechaFL)#, #Month(varFechaFL)#, #varMcodigo#, #varOcodigo#,#difSueldos#,
					#Trim(rsCuentaSueldos.Pvalor)#,#Trim(rsCuentaSueldos.Pvalor)#
				)
			</cfquery>
		<cfelse>
			<cfthrow message="Montos Negativos" detail="La suma de las deducciones no puede ser mayor a la suma de las percepciones.">
		</cfif>
		
		<cfquery name="rsSQL" datasource="#session.DSN#">
			select Cconcepto
				from ConceptoContable
				where Ecodigo = #session.Ecodigo#
					and Oorigen = 'RHPN'
		</cfquery>

		<cfif rsSQL.Cconcepto EQ "">
			<cfthrow message="ERROR: No se ha definido el Concepto Contable para el Origen 'RHPN = RH Pago de Nómina' en Administración del Sistema">
		</cfif>

		<cfset LvarCconcepto = rsSQL.Cconcepto>
		
		<cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="GeneraAsiento" returnvariable="LvarIDcontable">
			<cfinvokeargument name="Ecodigo" 				value="#session.Ecodigo#"/>
			<cfinvokeargument name="Oorigen" 				value="RHPN"/>
			<cfinvokeargument name="Cconcepto" 			value="#LvarCconcepto#"/>
			<cfinvokeargument name="Eperiodo" 			value="#Year(varFechaFL)#"/>
			<cfinvokeargument name="Emes" 					value="#Month(varFechaFL)#"/>
			<cfinvokeargument name="Efecha" 				value="#varFechaFL#"/>
			<cfinvokeargument name="Edocbase" 			value="#varDoc#"/>
			<cfinvokeargument name="Ereferencia" 		value="Liquidacion-Finiquito #varIdentificacion#"/>
			<cfinvokeargument name="Edescripcion"		value="Liquidacion-Finiquito #varIdentificacion#"/>
		</cfinvoke>
		<!--- FIN GENERAR POLIZAS --->

		<!--- OPARRALES 2019-01-12
			- Modificacion para insertar una Solicitud de Pago
		 --->
		<cfquery name="rsConceptoSer" datasource="#session.dsn#">
			select Cid,Ccodigo
			from Conceptos
			where LTrim(RTrim(Ccodigo)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="NSUEXPAG">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		</cfquery>

		<cfif rsConceptoSer.RecordCount eq 0>
			<cfthrow message="CONCEPTOS DE SERVICIO: " detail="El concepto con el codigo NSUEXPAG no se ha configurado.">
		</cfif>

		 <cfinvoke component="rh.Componentes.RHLiquidacionMX" method="fnGetLF" returnvariable="rsLF">
			<cfinvokeargument name="DLlinea" value="#form.DLlinea#">
			<cfinvokeargument name="DEid" value="#form.DEid#">
		</cfinvoke>

		<cfquery name="rsSumRHLiqIngresos" datasource="#session.DSN#">
			select coalesce(sum( case when a.importe < 0 then a.importe else a.importe*b.CInegativo end ),0) as totIngresos
			from RHLiqIngresos a
			inner join CIncidentes b
			on b.CIid=a.CIid
			where a.DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DLlinea#">
			and a.RHLPautomatico = 0
		</cfquery>

		<cfquery name="rsSumRHLiqCargas" datasource="#session.DSN#">
			select coalesce(sum(importe),0)  as totCargas
			from RHLiqCargas
			where DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DLlinea#">
		</cfquery>

		<cfquery name="rsSumRHLiqDeduccion" datasource="#session.DSN#">
			select coalesce(sum(importe),0) as totDeduc
			from RHLiqDeduccion
			where DLlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DLlinea#">
		</cfquery>

		<cfset totLiq = rsLF.RHLFLresultado + rsSumRHLiqIngresos.totIngresos - rsSumRHLiqCargas.totCargas - rsSumRHLiqDeduccion.totDeduc>

		<!--- Obtiene el id de Beneficiario, si no existe, lo crea --->
		<cfquery name="q_beneficiario" datasource="#session.dsn#">
			select
				coalesce(TESBid,0) as TESBid,
				de.DEidentificacion
			from
				DatosEmpleado de
			left join TESbeneficiario b
			on de.DEid = b.DEid
			where
				de.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			and de.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		</cfquery>

		<cfif q_beneficiario.TESBid eq 0>
			<cfthrow message="Beneficiarios: " detail="No se ha definido el Beneficiario para el empleado #q_beneficiario.DEidentificacion#.">
		</cfif>

		<cfset idBeneficiario = q_beneficiario.TESBid>

		<!--- Obtener Codigo de Moneda Local (Moneda de Empresa) --->
		<cfquery name="q_Moneda" datasource="#session.dsn#">
			select e.Mcodigo, m.Miso4217
			from empresas e
				inner join Monedas m
					on m.Mcodigo = e.Mcodigo
			where e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		</cfquery>

		<!--- id de concepto Cid--->
		<cfset ConceptoServicioID = LSParseNumber(rsConceptoSer.Cid)>

		<cfquery name="rsCFGen" datasource="#session.dsn#">
			select CFid
			from CFuncional
			where CFcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="RAIZ">
		</cfquery>

		<!--- id de Centro Funcional --->
		<cfset CentroFuncionalID = rsCFGen.CFid>

		<!--- Fecha de solicitud de pago --->
		<cfset SP_Date = DateTimeFormat(Now(),'yyyy-mm-dd hh:nn:ss')>

		<!--- Se toma la cuenta de parametros para pagos pendientes --->
		<!--- Se asigna la cuenta financiera--->
		<cfquery name="rsCCuenta" datasource="#session.dsn#">
			select
				Pvalor
			from
				RHParametros
			where
				Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="150">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		</cfquery>

		<cfif rsCCuenta.RecordCount eq 0>
			<cfthrow message="Cuenta Contable" detail="No se ha definido la Cuenta Contable de Pagos no Realizados en parametros">
		</cfif>
		<cfset LvarCFcuentaDB = rsCCuenta.Pvalor>

		<cfquery name="rsTES" datasource="#session.dsn#">
			Select e.TESid, t.EcodigoAdm
			from TESempresas e
			inner join Tesoreria t
				on t.TESid = e.TESid
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		<cfset session.Tesoreria.TESid = rsTES.TESid>
	    <cfset session.Tesoreria.EcodigoAdm = rsTES.EcodigoAdm>
		<cflock type="exclusive" name="TesSolPago#session.Ecodigo#" timeout="3">
			<cfquery name="rsNewSol" datasource="#session.dsn#">
				select coalesce(max(TESSPnumero),0) + 1 as newSol
				from TESsolicitudPago
				where EcodigoOri = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>
			<cfquery datasource="#session.dsn#" name="insert">
				insert into TESsolicitudPago (
					  TESid
					, CFid
					, EcodigoOri
					, TESSPnumero
					, TESSPtipoDocumento
					, TESSPestado
					, TESBid
					, TESSPfechaPagar
					, McodigoOri
					, TESSPtipoCambioOriManual
					, TESSPtotalPagarOri
					, TESSPfechaSolicitud
					, UsucodigoSolicitud
					, BMUsucodigo
					, PagoTercero
					)
				values (
					<!---  TESid --->						  #session.Tesoreria.TESid#
					<!---  CFid --->						, #CentroFuncionalID#
					<!--- EcodigoOri --->					, <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					<!--- TESSPnumero --->					, <cfqueryparam cfsqltype="cf_sql_integer" value="#rsNewSol.newSol#">
					<!--- TESSPtipoDocumento --->			, 0
					<!--- TESSPestado --->					, 0
					<!--- TESBid --->						, <cfqueryparam cfsqltype="cf_sql_numeric" value="#idBeneficiario#">
					<!--- TESSPfechaPagar --->				, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#SP_Date#">
					<!--- McodigoOri --->					, <cfqueryparam cfsqltype="cf_sql_numeric" value="#q_Moneda.Mcodigo#">
					<!--- TESSPtipoCambioOriManual --->		, 1
					<!--- TESSPtotalPagarOri --->			, <cfqueryparam cfsqltype="cf_sql_money" value="#LSNumberFormat(totLiq,'9.0000')#">
					<!--- TESSPfechaSolicitud --->			, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#SP_Date#">
					<!--- UsucodigoSolicitud --->			, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
					<!--- BMUsucodigo --->					, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
					<!--- PagoTercero --->					, 1
				)
				<cf_dbidentity1 datasource="#session.DSN#" name="insert">
			</cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="insert" returnvariable="idE_SolicitudPago">
		</cflock>

		<!--- Se obtiene el Ocodigo para el detalle del pago--->
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select cf.Ocodigo
				from CFuncional cf
				where cf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CentroFuncionalID#">
		</cfquery>

		<!--- Definicion de iva y ieps (actualmente no aplica)--->
		<cfset LvarIcodigo  = ''>
		<cfset LvarIcodieps = ''>
		<!--- INSERTA DETALLE DE ORDEN DE PAGO --->
		<cfquery name="inserted"  datasource="#session.dsn#">
			insert INTO TESdetallePago (
					  TESid
					, CFid
					, OcodigoOri
					, TESDPestado
					, EcodigoOri
					, TESSPid
					, TESDPtipoDocumento
					, TESDPidDocumento
					, TESDPmoduloOri
					, TESDPdocumentoOri
					, TESDPreferenciaOri
					, TESDPfechaVencimiento
					, TESDPfechaSolicitada
					, TESDPfechaAprobada
					, Miso4217Ori
					, TESDPmontoVencimientoOri
					, TESDPmontoSolicitadoOri
					, TESDPmontoAprobadoOri
					, TESDPmontoAprobadoLocal
					, TESDPimpNCFOri
					, TESDPdescripcion
					, CFcuentaDB
					, Icodigo
					, codIEPS
					, Cid
					, CPDCid
					, TESDPespecificacuenta
					, PagoTercero
					, TESDPtipoCambioOri
				)
			values (
					<!--- TESid --->						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
															<cfif len(trim(CentroFuncionalID))>
					<!--- CFid --->								, <cfqueryparam value="#CentroFuncionalID#" cfsqltype="cf_sql_numeric">
															<cfelse>
																, null
															</cfif>
					<!--- OcodigoOri --->					, #rsSQL.Ocodigo#
					<!--- TESDPestado --->					, 0
					<!--- EcodigoOri --->					, <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					<!--- TESSPid --->						, <cfqueryparam cfsqltype="cf_sql_numeric" value="#idE_SolicitudPago#">
					<!--- TESDPtipoDocumento --->			, 0
					<!--- TESDPidDocumento --->				, <cfqueryparam cfsqltype="cf_sql_numeric" value="#idE_SolicitudPago#">
					<!--- TESDPmoduloOri --->				, 'TESP'
					<!--- TESDPdocumentoOri --->			, <cfqueryparam cfsqltype="cf_sql_varchar" value="RH-ProcesoLF-#DateFormat(Now(),'yymmdd')#">
					<!--- TESDPdreferenciaOri --->			, <cfqueryparam cfsqltype="cf_sql_varchar" value="Liquidacion y Finiquito">
					<!--- TESDPfechaVencimiento --->		, <cfqueryparam value="#SP_Date#" cfsqltype="cf_sql_timestamp">
					<!--- TESDPfechaSolicitada --->			, <cfqueryparam value="#SP_Date#" cfsqltype="cf_sql_timestamp">
					<!--- TESDPfechaAprobada --->			, <cfqueryparam value="#SP_Date#" cfsqltype="cf_sql_timestamp">
					<!--- Miso4217Ori --->					, <cfqueryparam cfsqltype="cf_sql_char" value="#q_Moneda.Miso4217#">
					<!--- TESDPmontoVencimientoOri --->		, round(#totLiq#,2)
					<!--- TESDPmontoSolicitadoOri --->		, round(#totLiq#,2)
					<!--- TESDPmontoAprobadoOri --->		, round(#totLiq#,2)
					<!--- TESDPmontoAprobadoLocal --->		, round(#totLiq#,2)
					<!--- TESDPimpNCFOri --->				, 0
					<!--- TESDPdescripcion --->				, null
					<!--- CFcuentaDB --->					, <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarCFcuentaDB#">
															<cfif len(trim(LvarIcodigo))>
					<!--- Icodigo --->							, <cfqueryparam cfsqltype="cf_sql_char"    value="#LvarIcodigo#">
															<cfelse>
																, null
															</cfif>
															<cfif len(trim(LvarIcodieps))>
					<!--- codIEPS --->	   						, <cfqueryparam cfsqltype="cf_sql_char"    value="#LvarIcodieps#">
															<cfelse>
																, null
															</cfif>
					<!--- Cid --->							, <cfqueryparam cfsqltype="cf_sql_numeric" value="#ConceptoServicioID#">
					<!--- CPDCid ---> 						, null
					<!--- TESDPespecificacuenta --->		, 0
					<!--- PagoTercero --->					, 1
					<!--- TESDPtipoCambioOri --->			, 1
					)
			<!--- <cf_dbidentity1 datasource="#session.DSN#" name="insertd" returnvariable="LvarTESDPid"> --->
		</cfquery>

	</cftransaction>
	<cflocation url="liquidacionProceso.cfm">
</cfif>