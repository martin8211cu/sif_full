<cfif isdefined("Form.btnAplicar")>
	<cfset action = "RelacionPuestos-lista.cfm">
<cfelseif isdefined("Form.btnImportar")>
	<cfset action = "RelacionPuestos-import.cfm">
<cfelse>
	<cfset action = "RelacionPuestos.cfm">
</cfif>

<cfif isdefined("Form.btnAplicar")>
<cftransaction>
	<!---<cftry>--->
		<cfif isdefined("Form.chk") and Len(Trim(Form.chk)) NEQ 0>
			<cfset lotesid = ListToArray(Replace(Form.chk,' ', '', 'all'),',')>
			<cfloop index="i" from="1" to="#ArrayLen(lotesid)#">
				<cfset lote = lotesid[i]>
				<!--- Chequea que todos los empleados esten nombrados --->
				<cfquery name="rsChequearEmpleados" datasource="#Session.DSN#">
					select b.DEidentificacion
					from RHEAumentos a, RHDAumentos b
					where a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">
					and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and a.RHAid = b.RHAid
					and not exists(
						select 1
						from DatosEmpleado c, LineaTiempo d
						where b.DEidentificacion = c.DEidentificacion
						and b.NTIcodigo = c.NTIcodigo
						and c.DEid = d.DEid
						and a.Ecodigo = d.Ecodigo
						and a.RHAfdesde between d.LTdesde and d.LThasta
					)
				</cfquery>
				<cfif rsChequearEmpleados.recordCount GT 0>
					<cftransaction action="rollback"/>
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="MSG_ExistenEmpleadosEnElLote"
						Default="Existen empleados en el Lote"
						returnvariable="MSG_ExistenEmpleadosEnElLote"/>
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="MSG_QueNoEstanNombradosProcesoCanceladoApartirDeEsteLote"
						Default="que no están nombrados. Proceso cancelado a partir de este lote"
						returnvariable="MSG_QueNoEstanNombradosProcesoCanceladoApartirDeEsteLote"/>

					<cfset msg = MSG_ExistenEmpleadosEnElLote&" #lote# " & MSG_QueNoEstanNombradosProcesoCanceladoApartirDeEsteLote & ".">
					<cfset reg = "/cfmx/rh/nomina/operacion/RelacionPuestos-lista.cfm">
					<cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=0&errMsg=#URLEncodedFormat(msg)#&Regresar=#URLEncodedFormat(reg)#">
					<cfabort>
				</cfif>
				
				<!--- Chequea que no haya mas de un aumento para un empleado para la misma fecha rige --->
				<cfquery name="rsChequear" datasource="#Session.DSN#">
					select b.DEidentificacion
					from RHEAumentos a, RHDAumentos b
					where a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">
					and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and a.RHAid = b.RHAid
					and exists(
						select 1
						from RHEAumentos c, RHDAumentos d
						where c.RHAfdesde = a.RHAfdesde
						and c.RHAid = d.RHAid
						and b.NTIcodigo = d.NTIcodigo
						and b.DEidentificacion = d.DEidentificacion
						and c.RHAid <> a.RHAid
					)
				</cfquery>
				<cfif rsChequear.recordCount GT 0>
					<cftransaction action="rollback"/>
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="MSG_ExistenAumentosQueYaHabianSidoRegistradosEnElLote"
						Default="Existen aumentos que ya habian sido registrados en el Lote"
						returnvariable="MSG_ExistenAumentosQueYaHabianSidoRegistradosEnElLote"/>
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="MSG_ProcesocanceladoAPartirDeEsteLote"
						Default="Proceso cancelado a partir de este lote"
						returnvariable="MSG_ProcesocanceladoAPartirDeEsteLote"/>

					<cfset msg = MSG_ExistenAumentosQueYaHabianSidoRegistradosEnElLote & " #lote#. "& MSG_ProcesocanceladoAPartirDeEsteLote &".">
					<cfset reg = "/cfmx/rh/nomina/operacion/RelacionPuestos-lista.cfm">
					<cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=0&errMsg=#URLEncodedFormat(msg)#&Regresar=#URLEncodedFormat(reg)#">
					<cfabort>
				</cfif>
				
				<!--- Chequear saldos válidos --->
				<cfquery name="rsChequearSaldos" datasource="#Session.DSN#">
					select 
						x.DEidentificacion as Identificacion, 
						{fn concat(e.DEapellido1, {fn concat(' ', {fn concat(e.DEapellido2,{fn concat(', ',e.DEnombre)})})})} as Nombre, 
						x.RHDvalor
					from RHDAumentos x, RHEAumentos y, DatosEmpleado e
					where x.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">
					and y.RHAid = x.RHAid
					and e.DEidentificacion = x.DEidentificacion
					and e.Ecodigo = y.Ecodigo
					and x.RHDvalor < 0
				</cfquery>
				<cfif rsChequearSaldos.recordCount GT 0>
					<cftransaction action="rollback"/>
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="MSG_LosSaldosNoPuedenSerNegativos"
						Default="Los saldos no pueden ser negativos"
						returnvariable="MSG_LosSaldosNoPuedenSerNegativos"/>
					
					<cfset msg = MSG_LosSaldosNoPuedenSerNegativos>
					<cfset reg = "/cfmx/rh/nomina/operacion/RelacionPuestos-lista.cfm">
					<cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=0&errMsg=#URLEncodedFormat(msg)#&Regresar=#URLEncodedFormat(reg)#">
					<cfabort>
				</cfif>

				<!--- Chequear que haya un tipo de acción de tipo aumento --->
				<cfquery name="rsTipoAccion" datasource="#Session.DSN#">
					select RHTid
					from RHTipoAccion
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and RHTcomportam = 8
				</cfquery>
				<cfif rsTipoAccion.recordCount GT 0>
					<cfset TipoAccion = rsTipoAccion.RHTid>
				</cfif>
				<cfif not isdefined("TipoAccion")>
					<cftransaction action="rollback"/>
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="MSG_DebeHaberAlMenosUnTipoDeAccionConComportamientoAumentoConfigurado"
						Default="Debe haber al menos un tipo de acción con comportamiento Aumento configurado"
						returnvariable="MSG_DebeHaberAlMenosUnTipoDeAccionConComportamientoAumentoConfigurado"/>
					
					<cfset msg = MSG_DebeHaberAlMenosUnTipoDeAccionConComportamientoAumentoConfigurado>
					<cfset reg = "/cfmx/rh/nomina/operacion/RelacionPuestos-lista.cfm">
					<cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=0&errMsg=#URLEncodedFormat(msg)#&Regresar=#URLEncodedFormat(reg)#">
					<cfabort>
				</cfif>
				
				<!--- Chequear que exista un componente salarial base --->
				<cfquery name="rsChequearComponenteSalarial" datasource="#Session.DSN#">
					select CSid
					from ComponentesSalariales
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and CSsalariobase = 1
				</cfquery>
				<cfif rsChequearComponenteSalarial.recordCount EQ 0>
					<cftransaction action="rollback"/>
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="MSG_DebeEscogerUnComponenteSalarialQueRepresenteElSalarioBaseEnElMantenimientoDeComponentesSalariales"
						Default="Debe escoger un componente salarial que represente el salario base en el mantenimiento de componentes salariales"
						returnvariable="MSG_DebeEscogerUnComponenteSalarialQueRepresenteElSalarioBaseEnElMantenimientoDeComponentesSalariales"/>
					<cfset msg = MSG_DebeEscogerUnComponenteSalarialQueRepresenteElSalarioBaseEnElMantenimientoDeComponentesSalariales>
					<cfset reg = "/cfmx/rh/nomina/operacion/RelacionPuestos-lista.cfm">
					<cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=0&errMsg=#URLEncodedFormat(msg)#&Regresar=#URLEncodedFormat(reg)#">
					<cfabort>
				</cfif>

	<!--- Ejecutar el código de la aplicación de los lotes de aumentos salariales --->
				<cfparam name="fecha" type="date">
				<cfparam name="fecha2" type="date">
				<cfparam name="CSid"  type="numeric">
				
				<cfquery name="rsAplicar" datasource="#Session.DSN#">
<!---				declare @fecha datetime, @fecha2 datetime, @CSid numeric
					select @fecha = RHAfdesde--->
					select RHAfdesde
					from RHEAumentos
					where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">
					 and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				</cfquery>

					<cfset fecha = rsAplicar.RHAfdesde>
<!---				select @fecha2 = dateadd(dd, -1, @fecha)--->
					<cfset fecha2 = dateadd(dd, -1, fecha)>

				<cfquery name="rsAplicar2" datasource="#Session.DSN#">
<!---				select @CSid = CSid--->
					select CSid
					from ComponentesSalariales
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and CSsalariobase = 1
				</cfquery>
					
				<cfset CSid = rsAplicar2.CSid>

					<!--- -- Inicializar--->
				<cfquery name="rsAplicar_update_ini" datasource="#Session.DSN#">
					update RHDAumentos 
						set RHDinsertarlt = 0, 
						RHDltactual = null, 
						RHDltnueva = null,
						DEid = null
					where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">
				</cfquery>
					
				<!---	-- Actualizar codigos de Empleados--->
				<cfquery name="rsAplicar_update_codemp" datasource="#Session.DSN#">	
					update RHDAumentos
					set DEid = (select e.DEid from DatosEmpleado e 
								where e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
								and e.NTIcodigo = RHDAumentos.NTIcodigo 
								and e.DEidentificacion = RHDAumentos.DEidentificacion)
					where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">
				</cfquery>
					
					<!--- -- Identificar cuales registros deben insertar en la Linea del Tiempo--->
				<cfquery name="rsAplicar_updateLT" datasource="#Session.DSN#">		
					update RHDAumentos
					set RHDinsertarlt = 1
					where RHDAumentos.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">
					and not exists (
						select 1 
						from LineaTiempo lt
						where lt.DEid = RHDAumentos.DEid
<!---					   and lt.LTdesde = @fecha--->
						   and lt.LTdesde = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fecha#">
						   and lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
					)
				</cfquery>	

					<!--- -- Identificar la linea del tiempo actual para los registros a insertar --->
				<cfquery name="rsAplicar_updateLTA" datasource="#Session.DSN#">		
					update RHDAumentos
					set RHDltactual = ( select LTid from LineaTiempo lt 
										where lt.DEid = RHDAumentos.DEid 
 										 and #fecha# between lt.LTdesde and lt.LThasta)
<!---									 and @fecha between lt.LTdesde and lt.LThasta)--->
					where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">
					and RHDinsertarlt = 1
				</cfquery>
					
				<!---	-- Insertar la Linea del Tiempo con los nuevos registros --->
				<cfquery name="rsAplicar_insertLT" datasource="#Session.DSN#">			
					insert into LineaTiempo (DEid, Ecodigo, Tcodigo, RHTid, Ocodigo, Dcodigo, RHPid, RHPcodigo, RVid, RHJid, LTdesde, LThasta, LTporcplaza, LTsalario, LTporcsal)
<!---					select lt.DEid, lt.Ecodigo, lt.Tcodigo, lt.RHTid, lt.Ocodigo, lt.Dcodigo, lt.RHPid, lt.RHPcodigo, lt.RVid, lt.RHJid, @fecha, lt.LThasta, lt.LTporcplaza, lt.LTsalario, lt.LTporcsal --->
					select lt.DEid, lt.Ecodigo, lt.Tcodigo, lt.RHTid, lt.Ocodigo, lt.Dcodigo, lt.RHPid, lt.RHPcodigo, lt.RVid, lt.RHJid, #fecha#, lt.LThasta, lt.LTporcplaza, lt.LTsalario, lt.LTporcsal
					from RHDAumentos a, LineaTiempo lt
					where a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">
					and a.RHDinsertarlt = 1
					and lt.LTid = a.RHDltactual
				</cfquery>
					
				<!---	-- Obtener la nueva linea del tiempo para los registros insertados --->
				<cfquery name="rsAplicar_updateOLT" datasource="#Session.DSN#">
					update RHDAumentos
					set RHDltnueva = (select LTid from LineaTiempo lt 
									  where lt.DEid = RHDAumentos.DEid 
									  and lt.LTdesde = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fecha#">)
<!---								  and lt.LTdesde = @fecha)--->
					where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">
					and RHDinsertarlt = 1
				</cfquery>	
					
					<!--- -- Actualizar la Fecha Hasta de la Linea del Tiempo Anterior--->
<!---				update LineaTiempo
					set LThasta = @fecha2
					from RHDAumentos a
					where a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">
					and a.RHDinsertarlt = 1
					and LineaTiempo.LTid = a.RHDltactual--->
					
					
<!---
					update LineaTiempo
					set LThasta = @fecha2
					WHERE exists
							(
								select 1
								  from RHDAumentos a
								 where a.RHAid 			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">
								   and a.RHDinsertarlt 	= 1
								   and a.RHDltactual 	= LineaTiempo.LTid
							)--->
					
				<cfquery name="rsAplicar_updateAFHLTA" datasource="#Session.DSN#">
					update LineaTiempo
					set LThasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fecha2#">
					WHERE exists
							(
								select 1
								  from RHDAumentos a
								 where a.RHAid 			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">
								   and a.RHDinsertarlt 	= 1
								   and a.RHDltactual 	= LineaTiempo.LTid
							)
				</cfquery>			



					<!--- -- Insertar los Componentes de los registros insertados en la Linea del Tiempo--->
				<cfquery name="rsAplicar_insertCRILT" datasource="#Session.DSN#">
					insert into DLineaTiempo (LTid, CSid, DLTmonto, DLTunidades, DLTtabla)
				</cfquery>
				
				<cfquery name="rsAplicar_CRILT" datasource="#Session.DSN#">
					select a.RHDltnueva, b.CSid, b.DLTmonto, b.DLTunidades, b.DLTtabla
					from RHDAumentos a, DLineaTiempo b
					where a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">
					and a.RHDinsertarlt = 1
					and b.LTid = a.RHDltactual
				</cfquery>	
					
				<!---	-- Insercion en DLaboralesEmpleado --->
				<cfquery name="rsAplicar_insertDLE" datasource="#Session.DSN#">
					insert into DLaboralesEmpleado (
						DLconsecutivo, DEid, RHTid, Ecodigo, RHPid, RHPcodigo, Tcodigo, RVid, Dcodigo, Ocodigo, RHJid, 
						DLfvigencia, DLffin, DLsalario, DLobs, DLfechaaplic, Usucodigo, Ulocalizacion, DLporcplaza, DLporcsal,
						Dcodigoant, Ocodigoant, RHPidant, RHPcodigoant, Tcodigoant, DLsalarioant, RVidant, DLporcplazaant, DLporcsalant, RHJidant)
				</cfquery>
				
				<cfquery name="rsAplicar_DLE" datasource="#Session.DSN#">
					select -1, d.DEid, #TipoAccion#, d.Ecodigo, d.RHPid, d.RHPcodigo, d.Tcodigo, d.RVid, d.Dcodigo, d.Ocodigo, d.RHJid, 
							d.LTdesde, null, d.LTsalario + b.RHDvalor, 
							'Aumento Salarial', <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">, <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">, d.LTporcplaza, d.LTporcsal,
<!---						'Aumento Salarial', getDate(), <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">, d.LTporcplaza, d.LTporcsal,--->
							d.Dcodigo, d.Ocodigo, d.RHPid, d.RHPcodigo, d.Tcodigo, d.LTsalario, d.RVid, d.LTporcplaza, d.LTporcsal, d.RHJid
					from RHEAumentos a, RHDAumentos b, LineaTiempo d
					where a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">
					and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and a.RHAid = b.RHAid
					and a.Ecodigo = d.Ecodigo
					and b.DEid = d.DEid
					and a.RHAfdesde = d.LTdesde
				</cfquery>
					
				<!---	-- Insercion en DDLaboralesEmpleado --->
				<cfquery name="rsAplicar_insertDDLE" datasource="#Session.DSN#">	
					insert into DDLaboralesEmpleado 
						(DLlinea, CSid, DDLtabla, DDLunidad, DDLmontobase, DDLmontores, Usucodigo, Ulocalizacion, 
						DDLunidadant, DDLmontobaseant, DDLmontoresant)
				</cfquery>
				
				<cfquery name="rsAplicar_DDLE" datasource="#Session.DSN#">
					select f.DLlinea, e.CSid, e.DLTtabla, e.DLTunidades, 
							e.DLTmonto + (case when g.CSsalariobase = 1 then b.RHDvalor else 0.00 end),
							e.DLTmonto + (case when g.CSsalariobase = 1 then b.RHDvalor else 0.00 end),
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">, 
							e.DLTunidades, e.DLTmonto, e.DLTmonto
					from RHEAumentos a, RHDAumentos b, LineaTiempo d, DLineaTiempo e, DLaboralesEmpleado f, ComponentesSalariales g
					where a.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">
					and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and a.RHAid = b.RHAid
					and a.Ecodigo = d.Ecodigo
					and b.DEid = d.DEid
					and a.RHAfdesde = d.LTdesde
					and d.LTid = e.LTid
					and a.Ecodigo = f.Ecodigo
					and b.DEid = f.DEid
					and f.DLconsecutivo = -1
					and e.CSid = g.CSid
				</cfquery>	

<!--- creación consecutivo ******************** --->
					
				<!---	-- Actualizacion del Consecutivo en DLaboralesEmpleado--->
					<!---declare @cont numeric--->
				<cfparam name="cont" type="numeric">
				<cfquery name="rsAplicar_CDLE" datasource="#Session.DSN#">
					select coalesce(max(DLconsecutivo)+1, 1) as contt
					from DLaboralesEmpleado
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				</cfquery>
				<cfset cont = rsAplicar_CDLE.contt>

				<cfquery name="rsAplicar_CDLE" datasource="#Session.DSN#">
					select DLlinea
					from DLaboralesEmpleado
					where DLconsecutivo = -1
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				</cfquery>

				<cfloop query="rsAplicar_CDLE">
					<cfquery name="rsAplicar_updateCDLE" datasource="#Session.DSN#">	
						update DLaboralesEmpleado
						set DLconsecutivo = <cfqueryparam cfsqltype="cf_sql_integer" value="#cont#">
						where DLlinea = #rsAplicar_CDLE.DLlinea#
					</cfquery>	
					<cfset cont = cont + 1>
				</cfloop> 
<!--- creación consecutivo ******************** --->					
					<!--- -- Actualizacion del calendario de pago y monto de los salarios en la linea del tiempo a partir de la fecha en que rige el aumento--->
				<cfquery name="rsAplicar_updateCPMS" datasource="#Session.DSN#">
					update LineaTiempo
						set 
							LTsalario = LTsalario + da.RHDvalor,
							CPid = (select e.CPid
									from CalendarioPagos e
									where e.Ecodigo = LineaTiempo.Ecodigo
									  and e.Tcodigo = LineaTiempo.Tcodigo
									  and e.CPdesde = (
											select min(z.CPdesde) 
											from CalendarioPagos z
											where z.Ecodigo = LineaTiempo.Ecodigo
											  and z.Tcodigo = LineaTiempo.Tcodigo
<!---										  and z.CPdesde >= @fecha--->
											  and z.CPdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fecha#">
											  and z.CPfcalculo is null
									  )
							)
					where exists
						(
							select 1
							from RHDAumentos da
							where da.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#"> 
							  and LineaTiempo.DEid = da.DEid
							  and LineaTiempo.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							  and LineaTiempo.LTdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fecha#">
						)
				</cfquery>
					
				<!---	-- Actualizacion del salario base en los componentes a partir de la fecha en que rige el aumento--->
				<cfquery name="rsAplicar_updateSBC" datasource="#Session.DSN#">
					update DLineaTiempo
					   set DLTmonto = DLTmonto + da.RHDvalor
						where exists
							(
								select 1
								from RHDAumentos da, LineaTiempo lt
								where da.RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">
								  and lt.DEid = da.DEid
								  and lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
								  and lt.LTdesde >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#fecha#">
								  and DLineaTiempo.LTid = lt.LTid
								  and DLineaTiempo.CSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#CSid#">
							)
				</cfquery>
					
				<!---	-- Actualizacion del estado del lote de aumentos--->
				<cfquery name="rsAplicar_updateELA" datasource="#Session.DSN#">
					update RHEAumentos
					set RHAestado = 1
					where RHAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lote#">
					and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				</cfquery>

			</cfloop>
		</cfif>

<!---	<cfcatch type="any">
		<cftransaction action="rollback">
		<cfinclude template="/sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>--->
</cftransaction>
</cfif>

<cfoutput>
<form action="#action#" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<cfif isdefined("Form.HYERVid") and Len(Trim(Form.HYERVid)) NEQ 0>
		<input name="HYERVid" type="hidden" value="<cfoutput>#Form.HYERVid#</cfoutput>"> 
	</cfif>
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">	
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
